# Ramtex Mobile App - Frontend Development Blueprint

**Version:** 1.0  
**Last Updated:** January 14, 2026  
**Status:** Production Ready

---

## 📋 Table of Contents

1. [Authentication & Profile](#1-authentication--profile)
2. [Home & Discovery](#2-home--discovery)
3. [Product Details](#3-product-details)
4. [Shopping Cart & Checkout](#4-shopping-cart--checkout)
5. [User Dashboard](#5-user-dashboard)
6. [Global Conventions](#global-conventions)

---

## 1. Authentication & Profile

### 1.1 Login Screen

**Purpose:** Allow existing customers to authenticate and access their account.

#### Related Endpoint
```
POST /api/client/login
```

#### Data Sent to API (Request)

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `email` | string | if phone is empty | Customer email address | `jane@example.com` |
| `phone` | string | if email is empty | Customer phone number | `+961-71-987-654` |
| `password` | string | Yes | Account password (minimum 6 chars) | `password123` |

**UI Rules:**
- Show either Email OR Phone input field toggle, not both required.
- Password field must be masked (bullets/dots).
- "Forgot Password" link can be added (future feature, no API endpoint yet).

#### Data Returned from API (Response)

| Field | Type | Description | Example | UI Hint |
|-------|------|-------------|---------|---------|
| `token` | string | Bearer token for authenticated requests | `2\|xyz123abc...` | **CRITICAL:** Store in app secure storage (Keychain/Keystore). Include in all subsequent `Authorization: Bearer` headers |
| `client.id` | integer | Unique customer ID | `2` | Use for client-specific requests |
| `client.name` | string | Full customer name | `Jane Smith` | Display in Profile screen |
| `client.email` | string | Email address | `jane@example.com` | Display in Profile screen |
| `client.phone` | string | Phone number | `+961-71-987-654` | Display in Profile screen |
| `client.company_name` | string | Company/Business name | `Test Corp` | Display if not null |
| `client.city` | string | City | `Beirut` | Display in Profile screen |
| `client.country` | string | Country | `Lebanon` | Display in Profile screen |

**Response Example:**
```json
{
  "message": "Login successful",
  "token": "2|xyz123abc...",
  "client": {
    "id": 2,
    "name": "Jane Smith",
    "email": "jane@example.com",
    "phone": "+961-71-987-654",
    "company_name": "Test Corp",
    "city": "Beirut",
    "country": "Lebanon",
    "created_at": "2026-01-14T12:00:00.000000Z",
    "updated_at": "2026-01-14T12:00:00.000000Z"
  }
}
```

---

### 1.2 Register Screen

**Purpose:** Allow new customers to create an account.

#### Related Endpoint
```
POST /api/client/register
```

#### Data Sent to API (Request)

| Field | Type | Required | Description | Validation | Example |
|-------|------|----------|-------------|-----------|---------|
| `full_name` | string | Yes | Customer full name | Max 255 chars | `Jane Smith` |
| `email` | string | Yes | Email address | Unique, valid email format | `jane@example.com` |
| `phone` | string | Yes | Phone number | Unique, max 30 chars | `+961-71-987-654` |
| `password` | string | Yes | Account password | Min 6 chars, must match confirmation | `password123` |
| `password_confirmation` | string | Yes | Password confirmation | Must match password field | `password123` |
| `company_name` | string | No | Business/company name | Max 255 chars | `Test Corp` |
| `city` | string | No | City | Max 255 chars | `Beirut` |
| `country` | string | No | Country | Max 255 chars, defaults to "Lebanon" | `Lebanon` |

**UI Rules:**
- Email and Phone fields must show real-time validation (check icon/error).
- Password and Confirmation fields must match (show mismatch error).
- All required fields marked with asterisk (*).
- Submit button disabled until all required fields valid.
- Show password strength indicator (optional but recommended).

#### Data Returned from API (Response)

| Field | Type | Description | Example | UI Hint |
|-------|------|-------------|---------|---------|
| `token` | string | Bearer token for authenticated requests | `2\|xyz123abc...` | **CRITICAL:** Store in secure storage immediately. Auto-login after successful registration |
| `client.id` | integer | New customer ID | `3` | Store for future reference |
| `client.name` | string | Customer name | `Jane Smith` | Welcome message: "Welcome, Jane!" |
| `client.email` | string | Email | `jane@example.com` | Show confirmation message |
| `client.phone` | string | Phone | `+961-71-987-654` | Show in confirmation |
| `client.created_at` | timestamp | Account creation time | `2026-01-14T12:00:00.000000Z` | Can use for "Account created on X" message |

**Response Example (Success - 201 Created):**
```json
{
  "message": "User registered successfully",
  "token": "3|xyz456def...",
  "client": {
    "id": 3,
    "name": "Jane Smith",
    "email": "jane@example.com",
    "phone": "+961-71-987-654",
    "company_name": "Test Corp",
    "city": "Beirut",
    "country": "Lebanon",
    "created_at": "2026-01-14T12:00:00.000000Z",
    "updated_at": "2026-01-14T12:00:00.000000Z"
  }
}
```

**Error Example (422 Validation):**
```json
{
  "message": "This email is already registered.",
  "errors": {
    "email": ["This email is already registered."]
  }
}
```

---

### 1.3 Profile Screen

**Purpose:** Display logged-in customer's profile information.

#### Related Endpoint
```
GET /api/client/me
```

**Authentication:** Required (Bearer token)

#### Data Sent to API (Request)
None. This is a simple GET request.

#### Data Returned from API (Response)

| Field | Type | Description | Example | UI Hint |
|-------|------|-------------|---------|---------|
| `client.id` | integer | Customer ID | `2` | Use for API requests |
| `client.name` | string | Full name | `Jane Smith` | Display as profile title |
| `client.email` | string | Email | `jane@example.com` | Display in editable field (future: edit profile) |
| `client.phone` | string | Phone | `+961-71-987-654` | Display in editable field |
| `client.company_name` | string | Company | `Test Corp` | Display; may be null |
| `client.city` | string | City | `Beirut` | Display; may be null |
| `client.country` | string | Country | `Lebanon` | Display; may be null |
| `client.created_at` | timestamp | Member since | `2026-01-14T12:00:00.000000Z` | Format as: "Member since Jan 14, 2026" |

**Response Example:**
```json
{
  "client": {
    "id": 2,
    "name": "Jane Smith",
    "email": "jane@example.com",
    "phone": "+961-71-987-654",
    "company_name": "Test Corp",
    "city": "Beirut",
    "country": "Lebanon",
    "created_at": "2026-01-14T12:00:00.000000Z",
    "updated_at": "2026-01-14T12:00:00.000000Z"
  }
}
```

---

### 1.4 Logout

**Purpose:** Sign out customer and clear authentication token.

#### Related Endpoint
```
POST /api/client/logout
```

**Authentication:** Required (Bearer token)

#### Data Sent to API (Request)
None.

#### Data Returned from API (Response)

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `message` | string | Confirmation message | `Logged out successfully.` |

**Response Example:**
```json
{
  "message": "Logged out successfully."
}
```

**UI Rules:**
- After successful logout (200 OK), immediately clear:
  - Stored token from secure storage
  - User profile data from memory
  - All cart data (optional: can re-sync on next login)
- Navigate to Login screen
- Show brief success toast: "Logged out successfully"

---

## 2. Home & Discovery

### 2.1 Home Screen

**Purpose:** Main landing page showing product categories, brands, and featured/latest products for easy browsing.

#### Sub-Components

#### 2.1.1 Categories Slider

**Related Endpoint:**
```
GET /api/categories
```

**Authentication:** Not required

#### Data Sent to API (Request)
None. Simple GET request.

#### Data Returned from API (Response)

| Field | Type | Description | Example | UI Hint |
|-------|------|-------------|---------|---------|
| `data[].id` | integer | Category ID | `1` | Use as `category_id` param when filtering products |
| `data[].name` | string | Category name | `Apparel` | Display as category label |
| `data[].slug` | string | URL-friendly slug | `apparel` | Can use for analytics/tracking |
| `data[].image_url` | string | Category image URL | `http://localhost:8000/storage/categories/apparel.jpg` | Display as category card image; if null, show placeholder icon |
| `data[].products_count` | integer | Number of products | `45` | Show "(45 items)" badge below category name |

**Response Example:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Apparel",
      "slug": "apparel",
      "image_url": "http://localhost:8000/storage/categories/apparel.jpg",
      "products_count": 45
    },
    {
      "id": 2,
      "name": "Electronics",
      "slug": "electronics",
      "image_url": "http://localhost:8000/storage/categories/electronics.jpg",
      "products_count": 120
    }
  ]
}
```

**UI Implementation:**
- Display as horizontal scrollable slider (iOS: UICollectionView, Android: HorizontalScrollView or RecyclerView)
- Card size: ~100x120 dp (image + text)
- On tap: Navigate to Products Screen with `?category_id={id}` filter pre-applied
- Show all categories (no pagination)

---

#### 2.1.2 Brands Slider

**Related Endpoint:**
```
GET /api/brands
```

**Authentication:** Not required

#### Data Sent to API (Request)
None. Simple GET request.

#### Data Returned from API (Response)

| Field | Type | Description | Example | UI Hint |
|-------|------|-------------|---------|---------|
| `data[].id` | integer | Brand ID | `1` | Use as `brand_id` param when filtering products |
| `data[].name` | string | Brand name | `Nike` | Display as brand label |
| `data[].slug` | string | URL-friendly slug | `nike` | For analytics |
| `data[].logo_url` | string | Brand logo URL | `http://localhost:8000/storage/brands/nike-logo.png` | Display as brand card logo; if null, show placeholder or text-only card |
| `data[].products_count` | integer | Number of products | `78` | Show "(78 items)" or similar |

**Response Example:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Nike",
      "slug": "nike",
      "logo_url": "http://localhost:8000/storage/brands/nike-logo.png",
      "products_count": 78
    },
    {
      "id": 2,
      "name": "Adidas",
      "slug": "adidas",
      "logo_url": "http://localhost:8000/storage/brands/adidas-logo.png",
      "products_count": 92
    }
  ]
}
```

**UI Implementation:**
- Display as horizontal scrollable slider below categories
- Logo size: ~80x80 dp
- On tap: Navigate to Products Screen with `?brand_id={id}` filter pre-applied
- Show all brands (no pagination)

---

#### 2.1.3 Featured/Latest Products Grid

**Related Endpoint:**
```
GET /api/products?per_page=10&sort=newest
```

**Authentication:** Not required (but include token if available for `is_favorite` flag)

#### Data Sent to API (Request)

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `per_page` | integer | Products to fetch | `10` |
| `sort` | string | Sort order | `newest` |

#### Data Returned from API (Response)

| Field | Type | Description | Example | UI Hint |
|-------|------|-------------|---------|---------|
| `data[].id` | integer | Product ID | `1` | Use for navigation to Product Details |
| `data[].name` | string | Product name | `Cotton T-Shirt` | Display as product title |
| `data[].item_code` | string | SKU | `TSH-001` | Show in product details (optional in grid) |
| `data[].description` | string | Short description | `Classic cotton...` | Display in grid or details only |
| `data[].price` | float | Retail price | `29.99` | Display prominently; format as currency (e.g., "$29.99") |
| `data[].image_url` | string | Product image URL | `http://localhost:8000/storage/products/tsh-001.jpg` | Display as product grid image; if null, show placeholder |
| `data[].category.id` | integer | Category ID | `1` | Store for filtering |
| `data[].category.name` | string | Category name | `Apparel` | Display as small badge |
| `data[].category.slug` | string | Category slug | `apparel` | For navigation |
| `data[].brand.id` | integer | Brand ID | `1` | Store for filtering |
| `data[].brand.name` | string | Brand name | `Nike` | Display as small badge |
| `data[].brand.slug` | string | Brand slug | `nike` | For navigation |
| `data[].brand.logo_url` | string | Brand logo | `http://localhost:8000/storage/brands/nike-logo.png` | Optional: show small logo in corner |
| `data[].stock_available` | integer | Current stock qty | `150` | **UI Hint:** If 0, disable "Add to Cart" and show "Out of Stock" badge in red |
| `data[].in_stock` | boolean | Stock status | `true` | Use this boolean; if false, show "Out of Stock" overlay |
| `data[].is_favorite` | boolean | Customer favorited? | `false` | Show filled/empty heart icon; if not logged in, skip heart icon |

**Response Example:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Cotton T-Shirt",
      "item_code": "TSH-001",
      "description": "Classic cotton t-shirt, comfortable and breathable.",
      "category": {
        "id": 1,
        "name": "Apparel",
        "slug": "apparel"
      },
      "brand": {
        "id": 1,
        "name": "Nike",
        "slug": "nike",
        "logo_url": "http://localhost:8000/storage/brands/nike-logo.png"
      },
      "price": 29.99,
      "image_url": "http://localhost:8000/storage/products/tsh-001.jpg",
      "stock_available": 150,
      "in_stock": true,
      "is_favorite": false
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 5,
    "per_page": 10,
    "total": 45
  }
}
```

**UI Implementation:**
- Display as grid (2 columns on mobile, 3-4 on tablet/web)
- Card layout: Image (top, square aspect ratio) + Name (line 1) + Price (bold, line 2) + Favorite heart icon (top-right corner)
- On card tap: Navigate to Product Details screen (see section 3)

---

### 2.2 Search & Filter Sheet

**Purpose:** Allow customers to search for products and apply advanced filters (category, brand, price range, sorting).

#### Related Endpoint
```
GET /api/products
```

**Authentication:** Optional (include token if available)

#### Data Sent to API (Request)

| Parameter | Type | Required | Description | Example |
|-----------|------|----------|-------------|---------|
| `search` | string | No | Search keyword (name, code, description) | `shirt` |
| `category_id` | integer | No | Filter by category | `1` |
| `brand_id` | integer | No | Filter by brand | `1` |
| `price_min` | decimal | No | Minimum price | `10.00` |
| `price_max` | decimal | No | Maximum price | `100.00` |
| `sort` | string | No | Sort order: `price_asc`, `price_desc`, `newest`, `name_asc` | `price_asc` |
| `per_page` | integer | No | Results per page (max 100) | `20` |

**Filter UI Components:**
- **Search Bar:** Text input, real-time search with debounce (300-500ms)
- **Category Filter:** Dropdown/Picker fetching from `/api/categories`
- **Brand Filter:** Dropdown/Picker fetching from `/api/brands`
- **Price Range Slider:** Min/Max sliders or two input fields
- **Sort Dropdown:** Options - Latest, Price (Low to High), Price (High to Low), Name (A-Z)
- **Apply/Search Button:** Triggers API call with all selected filters

#### Data Returned from API (Response)

Same as section 2.1.3 (Products Grid).

**Response Includes Pagination:**
```json
{
  "data": [ ... ],
  "meta": {
    "current_page": 1,
    "last_page": 3,
    "per_page": 20,
    "total": 45
  }
}
```

**UI Implementation:**
- Bottom sheet (iOS) / Modal (Android) when user taps search/filter icon
- Include "Clear Filters" button to reset all
- Show applied filter count badge on filter icon in Home screen
- Implement infinite scroll / "Load More" for pagination

---

## 3. Product Details

### 3.1 Single Product Screen

**Purpose:** Display full product information with options to add to cart or favorite.

#### Related Endpoints
```
GET /api/products/{id}
POST /api/client/favorites (to toggle favorite)
POST /api/client/cart (to add to cart)
```

**Authentication:** Required for favorites/cart; optional for product view

#### Data Sent to API (Request - Get Product)

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `id` | integer | Product ID (from URL path) | `1` |

#### Data Returned from API (Response)

| Field | Type | Description | Example | UI Hint |
|-------|------|-------------|---------|---------|
| `data.id` | integer | Product ID | `1` | Store for cart/favorite actions |
| `data.name` | string | Product name | `Cotton T-Shirt` | Display as main title |
| `data.item_code` | string | SKU | `TSH-001` | Display as secondary title or in Details section |
| `data.description` | string | Full product description | `Made from premium... comfortable fit...` | Display as long-form text |
| `data.price` | float | Retail price | `29.99` | Display prominently; format as currency |
| `data.image_url` | string | Product image URL | `http://localhost:8000/storage/products/tsh-001.jpg` | Display as main product image; implement image gallery if multiple images (future) |
| `data.category.id` | integer | Category ID | `1` | Store for navigation |
| `data.category.name` | string | Category name | `Apparel` | Display as breadcrumb / info |
| `data.category.slug` | string | Category slug | `apparel` | For navigation |
| `data.brand.id` | integer | Brand ID | `1` | Store for navigation |
| `data.brand.name` | string | Brand name | `Nike` | Display as brand info |
| `data.brand.slug` | string | Brand slug | `nike` | For navigation |
| `data.brand.logo_url` | string | Brand logo | `http://localhost:8000/storage/brands/nike-logo.png` | Display brand logo in details |
| `data.stock_available` | integer | Current stock | `150` | **UI Hint:** Display stock status; if 0, disable "Add to Cart" |
| `data.in_stock` | boolean | Is in stock? | `true` | Show "In Stock" badge if true; "Out of Stock" if false |
| `data.is_favorite` | boolean | Is favorited? | `false` | Initialize heart icon state (filled if true, empty if false) |

**Response Example:**
```json
{
  "data": {
    "id": 1,
    "name": "Cotton T-Shirt",
    "item_code": "TSH-001",
    "description": "Made from premium cotton. Comfortable fit, suitable for casual wear. Available in multiple colors.",
    "category": {
      "id": 1,
      "name": "Apparel",
      "slug": "apparel"
    },
    "brand": {
      "id": 1,
      "name": "Nike",
      "slug": "nike",
      "logo_url": "http://localhost:8000/storage/brands/nike-logo.png"
    },
    "price": 29.99,
    "image_url": "http://localhost:8000/storage/products/tsh-001.jpg",
    "stock_available": 150,
    "in_stock": true,
    "is_favorite": false
  }
}
```

---

### 3.2 Toggle Favorite Action

**Related Endpoint:**
```
POST /api/client/favorites
```

**Authentication:** Required (Bearer token)

#### Data Sent to API (Request)

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `product_id` | integer | Yes | Product ID to favorite | `1` |

#### Data Returned from API (Response)

| Field | Type | Description | Example | UI Hint |
|-------|------|-------------|---------|---------|
| `action` | string | Action performed: `added` or `removed` | `added` | Update heart icon based on this (filled if added, empty if removed) |
| `is_favorite` | boolean | New favorite state | `true` | Update local state |
| `message` | string | Confirmation message | `Product added to favorites.` | Show brief toast message |

**Response Example (Added):**
```json
{
  "message": "Product added to favorites.",
  "action": "added",
  "product_id": 1,
  "is_favorite": true
}
```

**Response Example (Removed):**
```json
{
  "message": "Product removed from favorites.",
  "action": "removed",
  "product_id": 1,
  "is_favorite": false
}
```

**UI Implementation:**
- Heart icon button in Product Details screen (top-right or bottom action bar)
- On tap: POST to `/api/client/favorites` with product_id
- Update icon state immediately (filled/empty) based on response
- Show toast: "Added to Favorites" or "Removed from Favorites"

---

### 3.3 Add to Cart Action

**Related Endpoint:**
```
POST /api/client/cart
```

**Authentication:** Required (Bearer token)

#### Data Sent to API (Request)

| Field | Type | Required | Description | Validation | Example |
|-------|------|----------|-------------|-----------|---------|
| `product_id` | integer | Yes | Product ID | Must exist and be active | `1` |
| `quantity` | integer | Yes | Quantity to add | Min 1, max available stock | `2` |

**UI Implementation:**
- Quantity input (spinner with +/- buttons or text input)
- Default quantity: `1`
- Max quantity: Limited by `stock_available` from Product Details
- "Add to Cart" button
- Disabled if `in_stock = false`

#### Data Returned from API (Response)

| Field | Type | Description | Example | UI Hint |
|-------|------|-------------|---------|---------|
| `message` | string | Confirmation message | `Item added to cart` | Show as toast |
| `data.id` | integer | Cart item ID | `5` | Store for future updates |
| `data.quantity` | integer | Quantity in cart | `2` | Display confirmation: "Added 2 items" |
| `data.unit_price` | float | Price per unit | `29.99` | Show: "2 × $29.99 = $59.98" |
| `data.subtotal` | float | Line total | `59.98` | Confirmation message |
| `totals.items_count` | integer | Total items in cart | `5` | Update cart badge (show "5" on cart icon) |
| `totals.grand_total` | float | Cart total | `149.95` | Update cart total display |

**Response Example:**
```json
{
  "message": "Item added to cart",
  "data": {
    "id": 5,
    "quantity": 2,
    "unit_price": 29.99,
    "subtotal": 59.98,
    "product": {
      "id": 1,
      "name": "Cotton T-Shirt",
      "price": 29.99,
      "image_url": "http://localhost:8000/storage/products/tsh-001.jpg"
    }
  },
  "totals": {
    "items_count": 5,
    "grand_total": 149.95
  }
}
```

**Error Example (Stock exceeded):**
```json
{
  "message": "Requested quantity exceeds available stock.",
  "errors": {
    "quantity": ["Max 150 items available."]
  }
}
```

**UI Implementation:**
- After successful add (201 Created):
  - Show toast: "Added 2 items to cart"
  - Update cart icon badge to show total items count
  - Optional: Show "View Cart" quick action in toast
  - Optional: Navigate to Cart screen if user confirms

---

## 4. Shopping Cart & Checkout

### 4.1 Cart Screen

**Purpose:** Display all items in customer's shopping cart with options to modify quantities and remove items.

#### Related Endpoints
```
GET /api/client/cart
PUT /api/client/cart/{id}
DELETE /api/client/cart/{id}
DELETE /api/client/cart
```

**Authentication:** Required (Bearer token)

#### Data Sent to API (Request - Get Cart)

None. Simple GET request to `/api/client/cart`

#### Data Returned from API (Response)

| Field | Type | Description | Example | UI Hint |
|-------|------|-------------|---------|---------|
| `data[].id` | integer | Cart item ID | `5` | Use for update/delete actions |
| `data[].quantity` | integer | Current quantity | `2` | Display in quantity field/selector |
| `data[].unit_price` | float | Price per unit | `29.99` | Display as "Unit: $29.99" |
| `data[].subtotal` | float | Line total | `59.98` | Display prominently (bold) |
| `data[].product.id` | integer | Product ID | `1` | Store for navigation |
| `data[].product.name` | string | Product name | `Cotton T-Shirt` | Display as item title |
| `data[].product.image_url` | string | Product image | `http://localhost:8000/storage/products/tsh-001.jpg` | Display as item thumbnail |
| `data[].product.category.name` | string | Category | `Apparel` | Display as small label |
| `data[].product.brand.name` | string | Brand | `Nike` | Display as small label |
| `data[].product.stock_available` | integer | Available stock | `150` | **UI Hint:** Validate quantity doesn't exceed this |
| `data[].product.in_stock` | boolean | Is in stock? | `true` | If false, show warning; allow removal but prevent quantity increase |
| `totals.items_count` | integer | Total items (sum of quantities) | `5` | Display as "5 items in cart" |
| `totals.grand_total` | float | Cart subtotal | `149.95` | Display prominently as "Total: $149.95" |

**Response Example:**
```json
{
  "data": [
    {
      "id": 5,
      "quantity": 2,
      "unit_price": 29.99,
      "subtotal": 59.98,
      "product": {
        "id": 1,
        "name": "Cotton T-Shirt",
        "item_code": "TSH-001",
        "image_url": "http://localhost:8000/storage/products/tsh-001.jpg",
        "category": {
          "id": 1,
          "name": "Apparel",
          "slug": "apparel"
        },
        "brand": {
          "id": 1,
          "name": "Nike",
          "slug": "nike",
          "logo_url": "http://localhost:8000/storage/brands/nike-logo.png"
        },
        "stock_available": 150,
        "in_stock": true
      }
    },
    {
      "id": 6,
      "quantity": 3,
      "unit_price": 49.99,
      "subtotal": 149.97,
      "product": {
        "id": 2,
        "name": "Blue Jeans",
        "image_url": "http://localhost:8000/storage/products/jns-002.jpg",
        "category": {
          "id": 1,
          "name": "Apparel",
          "slug": "apparel"
        },
        "brand": {
          "id": 2,
          "name": "Adidas",
          "slug": "adidas",
          "logo_url": "http://localhost:8000/storage/brands/adidas-logo.png"
        },
        "stock_available": 80,
        "in_stock": true
      }
    }
  ],
  "totals": {
    "items_count": 5,
    "grand_total": 209.95
  }
}
```

**UI Implementation:**
- List view (iOS: UITableView, Android: RecyclerView)
- Each cart item card:
  - Thumbnail image (left, square ~60x60 dp)
  - Product name + brand (center, 2 lines)
  - Quantity field (center-right, spinner with +/- or text input)
  - Unit price (top-right, small)
  - Subtotal (bottom-right, bold)
  - Delete button (far right, trash icon)
- Cart total section (sticky at bottom):
  - "Items: X"
  - "Total: $XXX.XX" (large, bold)
  - "Proceed to Checkout" button (primary CTA)
  - "Continue Shopping" button (secondary)
- Empty cart state: Show illustration + "Your cart is empty. Start shopping!" with link to Home
- "Clear Cart" button in top navigation or menu

---

### 4.2 Update Cart Item Quantity

**Related Endpoint:**
```
PUT /api/client/cart/{id}
```

**Authentication:** Required (Bearer token)

#### Data Sent to API (Request)

| Field | Type | Required | Description | Validation | Example |
|-------|------|----------|-------------|-----------|---------|
| `quantity` | integer | Yes | New quantity | Min 1, max stock available | `5` |

#### Data Returned from API (Response)

| Field | Type | Description | Example | UI Hint |
|-------|------|-------------|---------|---------|
| `message` | string | Confirmation message | `Cart item updated` | Show toast |
| `data.id` | integer | Cart item ID | `5` | Same item |
| `data.quantity` | integer | Updated quantity | `5` | Update UI |
| `data.subtotal` | float | New line total | `149.95` | Update display |
| `totals.items_count` | integer | New total items | `8` | Update cart badge |
| `totals.grand_total` | float | New cart total | `299.90` | Update cart total |

**Response Example:**
```json
{
  "message": "Cart item updated",
  "data": {
    "id": 5,
    "quantity": 5,
    "unit_price": 29.99,
    "subtotal": 149.95,
    "product": { ... }
  },
  "totals": {
    "items_count": 8,
    "grand_total": 299.90
  }
}
```

**UI Implementation:**
- Quantity field on cart item card: spinner (+/- buttons) or text input
- On value change: Debounce 500ms, then PUT request
- Show loading indicator on that item while updating
- Update item subtotal and cart total immediately after successful response
- **Error handling:** If quantity exceeds stock, show validation error and revert to previous quantity

---

### 4.3 Remove Cart Item

**Related Endpoint:**
```
DELETE /api/client/cart/{id}
```

**Authentication:** Required (Bearer token)

#### Data Sent to API (Request)

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `id` | integer | Cart item ID (from URL) | `5` |

#### Data Returned from API (Response)

| Field | Type | Description | Example | UI Hint |
|-------|------|-------------|---------|---------|
| `message` | string | Confirmation message | `Cart item removed` | Show toast |
| `totals.items_count` | integer | Updated cart count | `5` | Update badge |
| `totals.grand_total` | float | Updated total | `149.95` | Update display |

**Response Example:**
```json
{
  "message": "Cart item removed",
  "totals": {
    "items_count": 5,
    "grand_total": 149.95
  }
}
```

**UI Implementation:**
- Trash icon button on each cart item
- Tap action: Show confirmation dialog (optional) or directly DELETE
- After deletion: Remove item from list with fade-out animation
- Show toast: "Item removed from cart"
- Update cart total and badge
- If last item deleted: Show empty cart state

---

### 4.4 Clear Cart

**Related Endpoint:**
```
DELETE /api/client/cart
```

**Authentication:** Required (Bearer token)

#### Data Sent to API (Request)
None. Simple DELETE request.

#### Data Returned from API (Response)

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `message` | string | Confirmation message | `Cart cleared` |
| `totals.items_count` | integer | Should be 0 | `0` |
| `totals.grand_total` | float | Should be 0 | `0.00` |

**Response Example:**
```json
{
  "message": "Cart cleared",
  "totals": {
    "items_count": 0,
    "grand_total": 0
  }
}
```

**UI Implementation:**
- "Clear Cart" button in navigation menu or cart screen options
- Show confirmation dialog: "Are you sure? This will remove all items from your cart."
- After confirmed: DELETE request
- On success: Clear cart items list, show empty state, show toast
- Reset cart badge to 0

---

### 4.5 Checkout (Place Order)

**Purpose:** Create an order from all items currently in the customer's shopping cart.

**Related Endpoint:**
```
POST /api/client/orders
```

**Authentication:** Required (Bearer token)

#### Data Sent to API (Request)

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `notes` | string | No | Special delivery/order notes | `Leave at door, please.` |

**Request Example:**
```json
{
  "notes": "Please deliver after 5 PM. Leave at door."
}
```

**Important:** The API **automatically fetches all items from the client's cart**. Do NOT send item details in the request. The endpoint will return an error if the cart is empty.

#### Data Returned from API (Response)

| Field | Type | Description | Example | UI Hint |
|-------|------|-------------|---------|---------|
| `message` | string | Success message | `Order created successfully.` | Show confirmation screen |
| `data.id` | integer | Order/Invoice ID | `10` | Display as "Order #10" |
| `data.invoice_number` | string | Invoice reference | `INV-2026-001` | Display on confirmation |
| `data.status` | string | Order status | `draft` | Initial status is draft, can be confirmed by admin |
| `data.total_amount` | float | Order total | `209.95` | Display on confirmation |
| `data.created_at` | timestamp | Order time | `2026-01-14T12:00:00.000000Z` | Format as "Jan 14, 2026 at 12:00 PM" |
| `data.notes` | string | Order notes | `Leave at door.` | Display if present |
| `data.items[].product_id` | integer | Product ID | `1` | Reference |
| `data.items[].product_name` | string | Product name | `Cotton T-Shirt` | Display in confirmation |
| `data.items[].quantity` | integer | Ordered quantity | `2` | Confirmation list |
| `data.items[].price` | float | Unit price | `29.99` | Confirmation |
| `data.items[].subtotal` | float | Line total | `59.98` | Confirmation |

**Response Example (Success - 201 Created):**
```json
{
  "message": "Order created successfully.",
  "data": {
    "id": 10,
    "invoice_number": "INV-2026-001",
    "status": "draft",
    "total_amount": 209.95,
    "notes": "Leave at door.",
    "created_at": "2026-01-14T12:00:00.000000Z",
    "items": [
      {
        "id": 1,
        "product_id": 1,
        "product_name": "Cotton T-Shirt",
        "quantity": 2,
        "price": 29.99,
        "subtotal": 59.98
      },
      {
        "id": 2,
        "product_id": 2,
        "product_name": "Blue Jeans",
        "quantity": 3,
        "price": 49.99,
        "subtotal": 149.97
      }
    ]
  }
}
```

**Error Example (Empty Cart - 422 Unprocessable Entity):**
```json
{
  "message": "Your cart is empty. Please add items before placing an order.",
  "errors": {
    "cart": ["Your cart is empty. Please add items before placing an order."]
  }
}
```

**Error Example (Insufficient Stock - 422):**
```json
{
  "message": "Insufficient stock for Cotton T-Shirt. Available: 5, Requested: 10.",
  "errors": {
    "items": ["Insufficient stock for Cotton T-Shirt. Available: 5, Requested: 10."]
  }
}
```

**UI Implementation:**
- **Cart Screen:** Show "Proceed to Checkout" button (enabled only if cart has items)
- **Optional Checkout Screen:**
  - Display order summary (items, quantities, prices, total)
  - Notes textarea (optional)
  - "Place Order" button (CTA)
  - Show loading spinner while processing
- **On Success (201 Created):**
  - Navigate to Order Confirmation screen
  - Display "Order Placed Successfully!"
  - Show Order #, invoice number, total, items, and timestamps
  - **CRITICAL:** Cart is automatically cleared by the API (no need to call `DELETE /api/client/cart`)
  - Provide "View Order Details" and "Continue Shopping" buttons
- **On Error (422):**
  - **If "cart is empty":** Show alert and redirect user back to Home/Products screen
  - **If "insufficient stock":** Show validation error and allow user to adjust quantities in Cart screen before retrying checkout

---

## 5. User Dashboard

### 5.1 Favorites Screen

**Purpose:** Display customer's saved/wishlist products.

#### Related Endpoint
```
GET /api/client/favorites
```

**Authentication:** Required (Bearer token)

#### Data Sent to API (Request)

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `per_page` | integer | Results per page | `15` |

#### Data Returned from API (Response)

Same structure as section 2.1.3 (Products Grid), but filtered to only favorited items.

| Field | Type | Description | Example | UI Hint |
|-------|------|-------------|---------|---------|
| `data[].id` | integer | Product ID | `1` | Tap to view details |
| `data[].name` | string | Product name | `Cotton T-Shirt` | Display as title |
| `data[].price` | float | Price | `29.99` | Format as currency |
| `data[].image_url` | string | Product image | `http://...` | Display as grid thumbnail |
| `data[].category.name` | string | Category | `Apparel` | Show as small badge |
| `data[].brand.name` | string | Brand | `Nike` | Show as small badge |
| `data[].stock_available` | integer | Stock | `150` | If 0, show "Out of Stock" overlay |
| `data[].in_stock` | boolean | In stock? | `true` | If false, disable "Add to Cart" |
| `data[].is_favorite` | boolean | Always true | `true` | Heart icon always filled |

**Response Example:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Cotton T-Shirt",
      "price": 29.99,
      "image_url": "http://localhost:8000/storage/products/tsh-001.jpg",
      "category": { "id": 1, "name": "Apparel", "slug": "apparel" },
      "brand": { "id": 1, "name": "Nike", "slug": "nike", "logo_url": "..." },
      "stock_available": 150,
      "in_stock": true,
      "is_favorite": true
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 1,
    "per_page": 15,
    "total": 3
  }
}
```

**UI Implementation:**
- Grid view (2 columns mobile, 3-4 on tablet)
- Same card layout as Products grid
- Heart icon always filled (show it's favorited)
- Long-press or swipe options:
  - "Remove from Favorites"
  - "Add to Cart"
- Empty state: "No favorites yet. Start adding products!"
- Pagination: Infinite scroll or "Load More"

---

### 5.2 Order History Screen

**Purpose:** Display customer's past orders and order details.

#### Related Endpoint
```
GET /api/client/orders
```

**Authentication:** Required (Bearer token)

#### Data Sent to API (Request)

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `per_page` | integer | Results per page | `10` |

#### Data Returned from API (Response)

| Field | Type | Description | Example | UI Hint |
|-------|------|-------------|---------|---------|
| `data[].id` | integer | Order ID | `10` | Display as order reference |
| `data[].invoice_number` | string | Invoice number | `INV-2026-001` | Display prominently |
| `data[].status` | string | Order status | `draft` | Color-code: draft=gray, confirmed=blue, shipped=green, completed=green |
| `data[].total_amount` | float | Order total | `209.95` | Display as main amount |
| `data[].created_at` | timestamp | Order date | `2026-01-14T12:00:00.000000Z` | Format as "Jan 14, 2026" |
| `data[].notes` | string | Special notes | `Leave at door.` | Optional: show in details |
| `data[].items[].product_name` | string | Product name | `Cotton T-Shirt` | Show in order detail view |
| `data[].items[].quantity` | integer | Quantity ordered | `2` | Show in order detail view |
| `data[].items[].price` | float | Unit price | `29.99` | Show in order detail view |
| `data[].items[].subtotal` | float | Line total | `59.98` | Show in order detail view |

**Response Example:**
```json
{
  "data": [
    {
      "id": 10,
      "invoice_number": "INV-2026-001",
      "status": "draft",
      "total_amount": 209.95,
      "notes": "Leave at door.",
      "created_at": "2026-01-14T12:00:00.000000Z",
      "items": [
        {
          "id": 1,
          "product_id": 1,
          "product_name": "Cotton T-Shirt",
          "quantity": 2,
          "price": 29.99,
          "subtotal": 59.98
        }
      ]
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 1,
    "per_page": 10,
    "total": 1
  }
}
```

**UI Implementation:**
- List view (iOS: UITableView, Android: RecyclerView)
- Each order card:
  - Order number (e.g., "Order #INV-2026-001") - bold, top-left
  - Order date (e.g., "Jan 14, 2026") - small, top-right
  - Status badge (color-coded) - top-right, next to date
  - Item preview (e.g., "2 items") - center
  - Total amount (e.g., "$209.95") - bold, bottom-right
- Tap action: Open Order Details screen (expandable or navigation)
- Order Details view:
  - Full order info (number, date, status, total)
  - Item list with images, names, quantities, prices
  - Notes (if any)
  - "Reorder" button (add items back to cart)
  - "Contact Support" button (future feature)
- Empty state: "No orders yet. Start shopping!"
- Pagination: Infinite scroll or "Load More"

---

## Global Conventions

### HTTP Status Codes & Error Handling

| Status | Meaning | Action | Example Response |
|--------|---------|--------|------------------|
| 200 OK | Successful GET/PUT | Display data / Update UI | (varies) |
| 201 Created | Successful POST | Show success toast, navigate | `{ "message": "Created successfully", "data": {...} }` |
| 400 Bad Request | Malformed request | Show error toast, check implementation | `{ "message": "Invalid input", "errors": {...} }` |
| 401 Unauthorized | Missing/invalid token | Navigate to Login screen | `{ "message": "Unauthenticated" }` |
| 404 Not Found | Resource doesn't exist | Show error toast, navigate back | `{ "message": "Product not found" }` |
| 422 Unprocessable Entity | Validation failed | Show validation errors below fields | `{ "message": "...", "errors": { "email": ["Already registered"] } }` |
| 500 Internal Server Error | Server error | Show error toast, allow retry | `{ "message": "Server error" }` |

### Token Management

- **Store token securely:** Keychain (iOS), Keystore (Android), SecureStorage (Web)
- **Include in all authenticated requests:** `Authorization: Bearer {token}`
- **Token expiration:** Implement refresh token logic (future: API may provide refresh endpoints)
- **On 401 response:** Clear token, navigate to Login screen

### Request/Response Conventions

- **Content-Type:** Always `application/json`
- **Accept Header:** Always include `Accept: application/json`
- **Pagination:** Returned as `meta` object with `current_page`, `last_page`, `per_page`, `total`
- **Errors:** Single object with `message` and optional `errors` object (field-specific messages)

### Image Handling

- **Placeholder:** If `image_url` is null or fails to load, display:
  - Product: Generic product icon
  - Category: Generic category icon
  - Brand: Gray placeholder with brand name text
- **Aspect Ratios:**
  - Product images: Square (1:1)
  - Category images: 16:9
  - Brand logos: Square (1:1) or landscape (16:9)

### Number Formatting

- **Currency:** Always format with 2 decimal places, currency symbol (e.g., "$29.99")
- **Quantities:** Integer, no decimals (e.g., "2 items", not "2.5 items")
- **Dates:** Format as human-readable (e.g., "Jan 14, 2026" or "14 Jan 2026")

### Real-Time Updates

- **Cart Badge:** Update immediately when item added/removed, reflects `totals.items_count`
- **Favorite Heart:** Update icon immediately on toggle (before API response if acceptable, revert on error)
- **Stock Status:** Refresh on product view or at least every app session

### Offline Handling (Future Enhancement)

- Cache product catalog, categories, brands for offline browsing
- Queue cart/order actions for sync when online
- Show "offline" indicator when no connectivity

---

**End of Frontend Development Blueprint**

For questions or clarifications, contact the Backend Team.
