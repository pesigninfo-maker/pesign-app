-- =========================================================================
-- PESIGN INITIAL DATABASE MASTER SCHEMA
-- Target Database: PostgreSQL 15+ (Optimized for Neon Serverless)
-- Author: Senior Startup CTO
-- =========================================================================

-- Enable UUID extension if not already present
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- -------------------------------------------------------------------------
-- 1. CUSTOM ENUMERATED TYPES (Enforces Strict State Machine & RBAC)
-- -------------------------------------------------------------------------
CREATE TYPE user_role AS ENUM ('CUSTOMER', 'ADMIN', 'DESIGNER', 'PRINTER');

CREATE TYPE order_status AS ENUM (
    'PENDING_PAYMENT', 
    'PAYMENT_CONFIRMED', 
    'DESIGNING', 
    'DESIGN_APPROVED', 
    'PRINTING', 
    'PRINT_COMPLETED', 
    'SHIPPED', 
    'DELIVERED', 
    'CANCELLED'
);

CREATE TYPE design_job_status AS ENUM (
    'UNASSIGNED', 
    'ASSIGNED', 
    'IN_PROGRESS', 
    'PENDING_INTERNAL_REVIEW',
    'PENDING_CUSTOMER_APPROVAL', 
    'REVISION_REQUESTED', 
    'APPROVED'
);

CREATE TYPE print_job_status AS ENUM (
    'UNASSIGNED', 
    'ASSIGNED', 
    'PREPARING_MEDIA', 
    'IN_PRODUCTION', 
    'QUALITY_CHECK_FAILED', 
    'COMPLETED'
);

CREATE TYPE delivery_partner AS ENUM ('DELHIVERY', 'SHIPROCKET', 'DUNZO', 'PORTER', 'INTERNAL_RUNNER');

CREATE TYPE delivery_status AS ENUM ('PENDING', 'PICKED_UP', 'IN_TRANSIT', 'OUT_FOR_DELIVERY', 'DELIVERED', 'FAILED_ATTEMPT', 'RETURNED');

CREATE TYPE discount_type AS ENUM ('PERCENTAGE', 'FIXED_AMOUNT');

CREATE TYPE address_type AS ENUM ('SHIPPING', 'BILLING', 'BOTH');

-- -------------------------------------------------------------------------
-- 2. CORE CORE IDENTITY TABLES
-- -------------------------------------------------------------------------
CREATE TABLE users (
    id VARCHAR(255) PRIMARY KEY, -- Maps directly to Clerk user ID (e.g., 'user_2N...')
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    role user_role NOT NULL DEFAULT 'CUSTOMER',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE addresses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id VARCHAR(255) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type address_type NOT NULL DEFAULT 'SHIPPING',
    company_name VARCHAR(255),
    gstin VARCHAR(15), -- Crucial for Indian B2B corporate billing
    address_line1 TEXT NOT NULL,
    address_line2 TEXT,
    landmark VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'India',
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- -------------------------------------------------------------------------
-- 3. PRODUCT CATALOG DATA LAYER
-- -------------------------------------------------------------------------
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(120) NOT NULL UNIQUE,
    description TEXT,
    image_url TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    display_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    base_price_design DECIMAL(12, 2) NOT NULL DEFAULT 0.00, -- Price charged if they require professional design
    base_price_print DECIMAL(12, 2) NOT NULL DEFAULT 0.00,  -- Base print cost configuration
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Dynamic Variant Combinations (e.g., 300 GSM + Matte + A4)
CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    paper_type VARCHAR(100) NOT NULL, -- e.g., '300 GSM Art Card', 'PVC Sheet'
    size VARCHAR(50) NOT NULL,       -- e.g., 'A4', 'Standard Visiting Card Size'
    finishing VARCHAR(100),           -- e.g., 'Spot UV', 'Gold Foil', 'None'
    price_modifier_print DECIMAL(12, 2) NOT NULL DEFAULT 0.00, -- Added to base product print price
    min_quantity INT NOT NULL DEFAULT 1,
    is_available BOOLEAN NOT NULL DEFAULT TRUE
);

-- -------------------------------------------------------------------------
-- 4. MARKETING & CONVERSION LAYER
-- -------------------------------------------------------------------------
CREATE TABLE coupons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(50) UNIQUE NOT NULL,
    type discount_type NOT NULL DEFAULT 'PERCENTAGE',
    value DECIMAL(12, 2) NOT NULL, -- percentage or fixed rupee amount
    min_order_value DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    max_discount_amount DECIMAL(12, 2), -- Cap for percentage-based coupons
    starts_at TIMESTAMPTZ NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    usage_limit INT, -- NULL means unlimited total uses
    used_count INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

-- -------------------------------------------------------------------------
-- 5. ORDER TRANSITION LAYER
-- -------------------------------------------------------------------------
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    short_order_id SERIAL, -- Human readable serial fallback for easy phone support
    customer_id VARCHAR(255) NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    shipping_address_id UUID NOT NULL REFERENCES addresses(id) ON DELETE RESTRICT,
    billing_address_id UUID NOT NULL REFERENCES addresses(id) ON DELETE RESTRICT,
    
    -- Sub-total allocations
    total_design_price DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    total_print_price DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    shipping_fee DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00, -- Calculated central GST
    discount_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    net_payable DECIMAL(12, 2) NOT NULL,
    
    coupon_id UUID REFERENCES coupons(id),
    status order_status NOT NULL DEFAULT 'PENDING_PAYMENT',
    
    -- Razorpay Transaction Tracking
    razorpay_order_id VARCHAR(255) UNIQUE,
    razorpay_payment_id VARCHAR(255) UNIQUE,
    razorpay_signature VARCHAR(255),
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    product_variant_id UUID REFERENCES product_variants(id) ON DELETE RESTRICT,
    quantity INT NOT NULL CHECK (quantity > 0),
    
    -- Snapshots pricing fields at the exact moment of checkout to insulate historical data changes
    unit_design_price DECIMAL(12, 2) NOT NULL,
    unit_print_price DECIMAL(12, 2) NOT NULL,
    
    requires_design_service BOOLEAN NOT NULL DEFAULT FALSE,
    customer_uploaded_raw_url TEXT, -- If they select "Upload Own Design" from UI
    special_instructions TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- -------------------------------------------------------------------------
-- 6. CENTRALIZED DECOUPLED WORKFLOW LAYER (THE MIDDLEMAN STRUCTURE)
-- -------------------------------------------------------------------------

-- Internal Design Assignment Engine (Hidden from customer)
CREATE TABLE design_jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_item_id UUID NOT NULL UNIQUE REFERENCES order_items(id) ON DELETE CASCADE,
    designer_id VARCHAR(255) REFERENCES users(id) ON DELETE SET NULL,
    status design_job_status NOT NULL DEFAULT 'UNASSIGNED',
    brief_notes TEXT,
    internal_admin_notes TEXT, -- Private review feedback between Admin and Designer
    current_proof_url TEXT,    -- Cloudinary link to latest design iteration
    revision_count INT NOT NULL DEFAULT 0,
    assigned_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Internal Printing Assignment Engine (Hidden from customer and designer)
CREATE TABLE print_jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE RESTRICT,
    printer_id VARCHAR(255) REFERENCES users(id) ON DELETE SET NULL,
    status print_job_status NOT NULL DEFAULT 'UNASSIGNED',
    print_ready_file_url TEXT, -- Populated via approved design proof OR direct upload asset
    negotiated_vendor_cost DECIMAL(12, 2), -- Internal cost tracking for platform margin audit
    assigned_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Logistics & Shipping Manifest Layer
CREATE TABLE deliveries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL UNIQUE REFERENCES orders(id) ON DELETE RESTRICT,
    partner_name delivery_partner NOT NULL DEFAULT 'SHIPROCKET',
    tracking_number VARCHAR(100),
    status delivery_status NOT NULL DEFAULT 'PENDING',
    weight_grams INT,
    waybill_url TEXT,
    estimated_delivery_at TIMESTAMPTZ,
    actual_delivery_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- -------------------------------------------------------------------------
-- 7. AUDIT & TELEMETRY LAYER
-- -------------------------------------------------------------------------
CREATE TABLE order_status_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    old_status order_status,
    new_status order_status NOT NULL,
    changed_by VARCHAR(255) REFERENCES users(id),
    changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    comments TEXT
);

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id VARCHAR(255) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    dispatch_channel VARCHAR(20) NOT NULL, -- 'IN_APP', 'EMAIL', 'WHATSAPP'
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- -------------------------------------------------------------------------
-- 8. DATABASE AUTOMATION & PERFORMANCE OPTIMIZATIONS
-- -------------------------------------------------------------------------

-- Automated Trigger to sync dynamic "updated_at" columns
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply modified update triggers
CREATE TRIGGER update_users_modtime BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_addresses_modtime BEFORE UPDATE ON addresses FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_products_modtime BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_orders_modtime BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_design_jobs_modtime BEFORE UPDATE ON design_jobs FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_print_jobs_modtime BEFORE UPDATE ON print_jobs FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_deliveries_modtime BEFORE UPDATE ON deliveries FOR EACH ROW EXECUTE FUNCTION update_modified_column();

-- Automated Logging Trigger for Tracking Order History Changes
CREATE OR REPLACE FUNCTION log_order_status_change()
RETURNS TRIGGER AS $$
BEGIN
    IF (OLD.status IS NULL OR OLD.status <> NEW.status) THEN
        INSERT INTO order_status_history (order_id, old_status, new_status, changed_at)
        VALUES (NEW.id, OLD.status, NEW.status, NOW());
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_order_status_history
AFTER UPDATE ON orders
FOR EACH ROW EXECUTE FUNCTION log_order_status_change();

-- High Performance Multi-Column Search Indexes (Optimizes query executions)
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_addresses_user_id ON addresses(user_id);
CREATE INDEX idx_products_slug ON products(slug);
CREATE INDEX idx_product_variants_lookup ON product_variants(product_id, is_available);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_design_jobs_status ON design_jobs(status);
CREATE INDEX idx_design_jobs_designer ON design_jobs(designer_id);
CREATE INDEX idx_print_jobs_status ON print_jobs(status);
CREATE INDEX idx_print_jobs_printer ON print_jobs(printer_id);
CREATE INDEX idx_deliveries_status ON deliveries(status);
CREATE INDEX idx_notifications_unread ON notifications(user_id) WHERE is_read = FALSE;

-- =========================================================================
-- DATABASE DEPLOYMENT COMPLETE VALIDATION
-- =========================================================================