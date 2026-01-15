# Mobile API - Quick Reference

## All Endpoints (8 Total)

### Authentication
- `POST /api/client/login` – Login with email/phone + password → returns token
- `POST /api/client/logout` – Logout (revoke all tokens) `[auth required]`
- `GET /api/client/me` – Get current client profile `[auth required]`

### Orders/Checkout
- `POST /api/client/orders` – Create new order `[auth required]`
  - Body: `{ "items": [{ "product_id": 1, "quantity": 2 }], "notes": "..." }`
  - Returns: Invoice with id, number, items, total
- `GET /api/client/orders` – Get client's order history `[auth required]`
  - Query: `?per_page=15`
  - Returns: Paginated invoices

### Product Catalog (Public)
- `GET /api/products` – List active products
  - Query: `?per_page=15`
- `GET /api/products/{id}` – Get single product details

### Health Check
- `GET /api/ping` – API health check (always returns `{ "message": "pong" }`)

---

## Quick Test Sequence

### 1. Create Test Client
```bash
php artisan tinker

use App\Models\Client;
use Illuminate\Support\Facades\Hash;

Client::create([
    'full_name' => 'John Doe',
    'email' => 'john@example.com',
    'phone' => '+961-71-123-456',
    'password' => Hash::make('password123'),
    'city' => 'Beirut',
]);
```

### 2. Login
```bash
curl -X POST http://localhost:8000/api/client/login \
  -H "Content-Type: application/json" \
  -d '{"email":"john@example.com","password":"password123"}'
```
**Copy the returned `token` value**

### 3. Browse Products
```bash
curl http://localhost:8000/api/products
```

### 4. Create Order
```bash
TOKEN="1|abc123xyz..." # from login response

curl -X POST http://localhost:8000/api/client/orders \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "items":[{"product_id":1,"quantity":2}],
    "notes":"Test order"
  }'
```

### 5. View Orders
```bash
curl -X GET http://localhost:8000/api/client/orders \
  -H "Authorization: Bearer $TOKEN"
```

---

## Request/Response Templates

### Login Request
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

### Login Response (201)
```json
{
  "token": "1|abc123xyz...",
  "client": {
    "id": 1,
    "name": "John Doe",
    "company": "Tech LLC",
    "email": "john@example.com",
    "phone": "+961-71-123-456"
  }
}
```

### Create Order Request
```json
{
  "items": [
    {"product_id": 1, "quantity": 2},
    {"product_id": 5, "quantity": 10}
  ],
  "notes": "Please deliver after 5 PM"
}
```

### Create Order Response (201)
```json
{
  "message": "Order created successfully.",
  "order": {
    "id": 1,
    "invoice_number": "INV-2026-00001",
    "status": "draft",
    "items": [ ... ],
    "total_amount": "59.98",
    "grand_total": "59.98"
  }
}
```

### Product List Response
```json
{
  "data": [
    {
      "id": 1,
      "name": "T-Shirt Red",
      "price": 29.99,
      "image_url": "...",
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

---

## HTTP Status Codes

| Code | Meaning | Example |
|------|---------|---------|
| 200 | OK | GET /api/products, /api/client/me |
| 201 | Created | POST /api/client/orders (success) |
| 401 | Unauthorized | Missing/invalid token |
| 404 | Not Found | GET /api/products/999 |
| 422 | Validation Error | Invalid product_id, out of stock, missing fields |

---

## Key Validation Rules

### Order Creation
- `items` array required, min 1 item
- Each item needs `product_id` (must exist, must be active) and `quantity` (min 1)
- Stock must be >= requested quantity (fails with 422)
- `notes` optional, max 1000 chars

### Login
- `email` (valid format) OR `phone` (string) – at least one required
- `password` required, min 6 chars

---

## Authentication

All `[auth required]` endpoints need:

**Header:**
```
Authorization: Bearer <token>
```

**Token source:** Returned from POST `/api/client/login`

**Token format:** `1|abc123xyz...` (Sanctum format)

---

## Errors

### Invalid Credentials
```json
{
  "message": "Invalid email/phone or password.",
  "errors": {"credentials": ["Invalid email/phone or password."]}
}
```

### Out of Stock
```json
{
  "message": "Insufficient stock for T-Shirt Red. Available: 1, Requested: 5.",
  "errors": {"items": ["Insufficient stock for T-Shirt Red. Available: 1, Requested: 5."]}
}
```

### Missing Token
```json
{
  "message": "Unauthenticated."
}
```

---

## Architecture Highlights

✓ **Guard:** `client-api` (isolated from admin `web` guard)  
✓ **Auth:** Laravel Sanctum (stateless tokens)  
✓ **Validation:** FormRequest classes  
✓ **Response:** JSON Resources (clean DTOs)  
✓ **Stock:** Server-side validation before invoice creation  
✓ **Transactions:** All-or-nothing invoice creation  
✓ **Reuse:** Built on proven InvoiceService  

---

## Files Created/Modified

**New Controllers:**
- `app/Http/Controllers/Api/Auth/ClientAuthController.php`
- `app/Http/Controllers/Api/ProductController.php`
- `app/Http/Controllers/Api/OrderController.php`

**New Requests:**
- `app/Http/Requests/Api/StoreOrderRequest.php`

**New Resources:**
- `app/Http/Resources/ClientResource.php`
- `app/Http/Resources/ProductResource.php`
- `app/Http/Resources/InvoiceResource.php`
- `app/Http/Resources/InvoiceItemResource.php`

**Modified Models:**
- `app/Models/Client.php` (Added Authenticatable, HasApiTokens, invoices() relation)
- `config/auth.php` (Added client-api guard + clients provider)

**Routes:**
- `routes/api.php` (All 8 endpoints)

**Migrations:**
- `database/migrations/2026_01_14_000000_add_password_to_clients_table.php`

---

## Next Phase

Suggested enhancements:
1. Payment processing endpoint
2. Order status tracking (draft → posted → shipped)
3. Order cancellation
4. Sales returns API
5. Promotions/discount codes
6. Push notifications
7. Payment gateway integration (Stripe/PayPal)
