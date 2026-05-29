-- =========================================================================
-- PESIGN MASTER DATABASE SCHEMA (PostgreSQL)
-- Target: Neon Serverless Postgres
-- ORM Compatibility: Drizzle ORM / Prisma
-- =========================================================================

-- 1. ENUMS (Custom Data Types for Strict Validation)
CREATE TYPE user_role AS ENUM ('CUSTOMER', 'DESIGNER', 'PRINTER', 'ADMIN');
CREATE TYPE order_status AS ENUM (
    'PENDING_PAYMENT', 
    'PAYMENT_CONFIRMED', 
    'IN_DESIGN', 
    'PENDING_APPROVAL', 
    'IN_PRINT', 
    'SHIPPED', 
    'DELIVERED', 
    'CANCELLED'
);
CREATE TYPE workflow_task_type AS ENUM ('DESIGN', 'PRINT', 'QUALITY_CHECK');
CREATE TYPE ai_check_status AS ENUM ('PENDING', 'PASSED', 'FAILED_BLEED', 'FAILED_RESOLUTION');

-- 2. USERS TABLE (Synced via Clerk Webhooks)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clerk_id VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255),
    role user_role DEFAULT 'CUSTOMER',
    gstin VARCHAR(15), -- For Corporate B2B Clients
    phone_number VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. PRODUCTS TABLE (Base Catalog)
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. PRODUCT VARIANTS (Complex Configurations like GSM, Size, Finish)
CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    sku_code VARCHAR(100) UNIQUE NOT NULL,
    size_dimensions VARCHAR(100),
    paper_gsm INTEGER,
    finish_type VARCHAR(50), -- e.g., Matte, Gloss, Spot UV
    price_multiplier DECIMAL(5, 2) DEFAULT 1.00,
    is_active BOOLEAN DEFAULT TRUE
);

-- 5. ORDERS TABLE (Core Transaction Record)
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    razorpay_order_id VARCHAR(255) UNIQUE,
    razorpay_payment_id VARCHAR(255) UNIQUE,
    status order_status DEFAULT 'PENDING_PAYMENT',
    total_amount DECIMAL(12, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) NOT NULL,
    shipping_address JSONB NOT NULL,
    tracking_awb VARCHAR(100), -- Logistics tracking number (Shiprocket/Delhivery)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. ORDER ITEMS (Line Items linked to Variants & Assets)
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    variant_id UUID NOT NULL REFERENCES product_variants(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,
    customer_upload_url TEXT, -- Raw assets from customer
    final_print_url TEXT, -- Vectorized high-res PDF for printer
    ai_validation ai_check_status DEFAULT 'PENDING'
);

-- 7. WORKFLOWS TABLE (Multi-Vendor Task Assignment)
CREATE TABLE workflows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    assigned_vendor_id UUID REFERENCES users(id), -- Must be a DESIGNER or PRINTER
    task_type workflow_task_type NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    vendor_payout DECIMAL(10, 2), -- Internal margin calculation
    notes TEXT,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE
);

-- 8. INDEXES (For High-Speed Queries on Edge Deployment)
CREATE INDEX idx_users_clerk_id ON users(clerk_id);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_workflows_vendor_id ON workflows(assigned_vendor_id);
