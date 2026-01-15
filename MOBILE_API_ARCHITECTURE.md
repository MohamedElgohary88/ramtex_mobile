# Customer Mobile App API - Architecture & Implementation

## Overview

The REST API enables the mobile app to authenticate customers, browse products, manage orders, and view account information. Built with **Laravel Sanctum** for stateless token-based authentication.

---

## Authentication

### Guard: `client-api`

- **Driver:** `sanctum`
- **Provider:** `clients` (Client model)
- **Tokens:** Personal Access Tokens (issued per device/session)
- **Isolation:** Completely separate from admin `web` guard (User model)

### Flow

```
Client (Mobile App)
  ↓
POST /api/client/login (email/phone + password)
  ↓
ClientAuthController::login()
  ↓
Hash::check() → Client found & verified
  ↓
$client->createToken('mobile-app') → Sanctum generates token
  ↓
Return: { token, client }
  ↓
Client stores token → Uses in Authorization header for future requests
```

---

## Database Schema Changes

### clients Table (Updated)

Added column via migration `2026_01_14_000000_add_password_to_clients_table`:

```sql
ALTER TABLE clients ADD password VARCHAR(255) NULL AFTER email;
```

**Model Trait:** `Client` now extends `Authenticatable` + uses `HasApiTokens` (Sanctum).

---

## Endpoints

### 1. Client Authentication

#### `POST /api/client/login`
**Status:** Public (No auth required)  
**Guard:** None  
**Params:**
- `email` OR `phone` (required, one of them)
- `password` (required)

**Response (200):**
```json
{
  "token": "1|xyz...",
  "client": {
    "id": 1,
    "name": "John Doe",
    "company": "Tech LLC",
    "email": "john@example.com",
    "phone": "+961-71-123-456",
    "city": "Beirut",
    "country": "Lebanon",
    "created_at": "2026-01-14T10:30:00.000000Z",
    "updated_at": "2026-01-14T10:30:00.000000Z"
  }
}
```

**Errors:**
- `422` (Unprocessable Entity): Missing fields or validation fails
- `403` (Forbidden): Invalid credentials

---

#### `POST /api/client/logout`
**Status:** Authenticated  
**Guard:** `client-api`  
**Auth Header:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "message": "Logged out successfully."
}
```

**Behavior:** Revokes all API tokens for the client.

---

#### `GET /api/client/me`
**Status:** Authenticated  
**Guard:** `client-api`  
**Auth Header:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "client": { ... same as login response ... }
}
```

---

### 2. Product Catalog

#### `GET /api/products`
**Status:** Public  
**Query Parameters:**
- `per_page` (optional, default: 15, max: 100)

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "name": "T-Shirt Red",
      "item_code": "TSH-001",
      "description": "Classic cotton t-shirt",
      "category": {
        "id": 1,
        "name": "Apparel",
        "slug": "apparel"
      },
      "price": 29.99,
      "image_url": "http://localhost:8000/storage/products/tsh-red.jpg",
      "stock_available": 150,
      "in_stock": true
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 5,
    "per_page": 15,
    "total": 75
  }
}
```

**Performance Notes:**
- Queries only `is_active = true` products
- Eager-loads `category` to prevent N+1
- Selects specific columns only (not full product data)
- Returns paginated results (default 15 per page)

---

#### `GET /api/products/{id}`
**Status:** Public  
**Path Parameter:** `id` (Product ID)

**Response (200):**
```json
{
  "data": {
    "id": 1,
    "name": "T-Shirt Red",
    "item_code": "TSH-001",
    "description": "Classic cotton t-shirt...",
    "category": {
      "id": 1,
      "name": "Apparel",
      "slug": "apparel"
    },
    "price": 29.99,
    "image_url": "http://localhost:8000/storage/products/tsh-red.jpg",
    "stock_available": 150,
    "in_stock": true
  }
}
```

**Errors:**
- `404` (Not Found): Product doesn't exist or `is_active = false`

---

## Resource Classes

### ClientResource

**Location:** `app/Http/Resources/ClientResource.php`

Formats client data for API responses. **Hides** the `password` field (already excluded via model `$hidden`).

**Fields Returned:**
- `id`, `name` (from `full_name`), `company`, `email`, `phone`
- `city`, `country`, `created_at`, `updated_at`

---

### ProductResource

**Location:** `app/Http/Resources/ProductResource.php`

Formats product data for API responses. **Hides** cost-related fields (e.g., `wholesale_price`).

**Fields Returned:**
- `id`, `name`, `item_code`, `description`
- `category` (nested object with id, name, slug)
- `price` (float format)
- `image_url` (full public URL via `asset()` helper)
- `stock_available`, `in_stock` (boolean)

---

## Routes Configuration

**File:** `routes/api.php`

```php
// Public Authentication
Route::prefix('client')->group(function () {
    Route::post('/login', [ClientAuthController::class, 'login']);
});

// Authenticated Endpoints
Route::middleware('auth:client-api')->prefix('client')->group(function () {
    Route::post('/logout', [ClientAuthController::class, 'logout']);
    Route::get('/me', [ClientAuthController::class, 'me']);
});

// Public Catalog
Route::prefix('products')->group(function () {
    Route::get('/', [ProductController::class, 'index']);
    Route::get('/{product}', [ProductController::class, 'show']);
});
```

---

## Security & Validation

### Input Validation

**Login endpoint:**
- Requires `email` (valid email format) **or** `phone` (string)
- Requires `password` (min 6 chars)
- Validates at least one of email/phone is provided

**Password Hashing:**
- Uses Laravel's `Hash::make()` (bcrypt with cost factor 12)
- Client passwords are never returned in responses

### Token Security

- **Sanctum tokens** are stateless (no session needed)
- Tokens are scoped to app/device level
- Logout revokes **all** tokens for the client
- Tokens expire based on `sanctum.expiration` config (default: no expiration, but can be set)

### Authorization

- Product endpoints allow public access (guest users can browse)
- Authentication endpoints (`/api/client/logout`, `/api/client/me`) require valid token

---

## Error Responses

### Validation Error (422)

```json
{
  "message": "The email field is required when phone is not present.",
  "errors": {
    "email": ["The email field is required when phone is not present."]
  }
}
```

### Unauthorized (401)

```json
{
  "message": "Unauthenticated."
}
```

(When `Authorization` header is missing or token is invalid for protected endpoints)

### Not Found (404)

```json
{
  "message": "Product not found."
}
```

---

## Testing Workflow

1. **Create Test Client** (via `php artisan tinker`):
   ```php
   Client::create([
       'full_name' => 'Test User',
       'email' => 'test@example.com',
       'phone' => '+961-71-123-456',
       'password' => Hash::make('password123'),
       'city' => 'Beirut',
       'country' => 'Lebanon',
   ]);
   ```

2. **Login:**
   ```bash
   curl -X POST http://localhost:8000/api/client/login \
     -H "Content-Type: application/json" \
     -d '{"email":"test@example.com","password":"password123"}'
   ```

3. **Use Token:** Store the returned token and include in subsequent requests:
   ```bash
   curl -H "Authorization: Bearer <token>" http://localhost:8000/api/client/me
   ```

4. **Browse Products:**
   ```bash
   curl http://localhost:8000/api/products
   curl http://localhost:8000/api/products/1
   ```

---

## Future Enhancements

1. **Search & Filtering:** Add `/api/products?category=apparel&price_max=100`
2. **Wishlist API:** Save favorite products
3. **Cart & Checkout:** Create orders via API
4. **Order History:** `/api/client/orders`
5. **Payment Processing:** Integrate payment gateway
6. **Push Notifications:** Order status updates
7. **Reviews & Ratings:** Let clients rate products
8. **Real-time Stock Updates:** WebSocket for inventory changes

---

## Configuration Files Modified

1. **config/auth.php**
   - Added `client-api` guard (Sanctum driver)
   - Added `clients` provider (Client model)

2. **routes/api.php**
   - Registered all client and product endpoints

3. **database/migrations/**
   - Added password column to clients table

---

## Summary

The Mobile API is production-ready with:
- ✅ Token-based authentication via Sanctum
- ✅ Secure password hashing
- ✅ Performance-optimized queries (pagination, eager loading)
- ✅ Clean resource-based JSON responses
- ✅ Comprehensive error handling
- ✅ Full separation from admin authentication
