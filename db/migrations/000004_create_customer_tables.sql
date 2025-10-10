-- +goose Up
CREATE TABLE customers (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    disabled_at timestamptz,
    disabled_reason text,
    deleted_at timestamptz,
    deleted_reason text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE customers_personal_details (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title text,
    first_name text,
    middle_name text,
    last_name text,
    first_name_in_english text,
    middle_name_in_english text,
    last_name_in_english text,
    date_of_birth date CHECK (validate_of_age(date_of_birth)),
    country_of_birth_code char(2),
    gender_id text,
    is_politically_exposed bool NOT NULL DEFAULT false,
    is_us_person bool NOT NULL DEFAULT false,
    marital_status_id text,
    number_of_dependents smallint NOT NULL DEFAULT 0 CHECK (number_of_dependents >= 0),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_customers_deleted
ON customers (deleted_at);

CREATE TABLE customer_addresses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id uuid NOT NULL REFERENCES customers (id) ON DELETE CASCADE,
    address_line1 text,
    address_line2 text,
    address_line3 text,
    address_line4 text,
    address_line5 text,
    city text,
    district text,
    state text,
    region text,
    postal_code text,
    country_code char(2),
    is_primary boolean NOT NULL DEFAULT false,
    verified_at timestamptz,
    deleted_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_customer_addresses_customer
ON customer_addresses (customer_id);

CREATE TABLE customer_emails (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id uuid NOT NULL REFERENCES customers (id) ON DELETE CASCADE,
    email citext NOT NULL,
    is_primary boolean NOT NULL DEFAULT false,
    verified_at timestamptz,
    deleted_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_customer_emails_customer
ON customer_emails (customer_id);

CREATE TABLE customer_nationalities (
    customer_id uuid NOT NULL REFERENCES customers (id) ON DELETE CASCADE,
    country_code char(2) NOT NULL,
    deleted_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (customer_id, country_code)
);

CREATE INDEX idx_customer_nationalities_customer
ON customer_nationalities (customer_id);

CREATE TABLE customer_phone_numbers (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id uuid NOT NULL REFERENCES customers (id) ON DELETE CASCADE,
    country_code char(2) NOT NULL,
    phone_number text NOT NULL,
    is_primary boolean NOT NULL DEFAULT false,
    verified_at timestamptz,
    deleted_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_customer_phone_numbers_customer
ON customer_phone_numbers (customer_id);

-- Indexes
CREATE UNIQUE INDEX ux_customer_primary_address
ON customer_addresses (customer_id)
WHERE is_primary AND deleted_at IS NULL;

CREATE UNIQUE INDEX ux_customer_primary_email
ON customer_emails (customer_id)
WHERE is_primary AND deleted_at IS NULL;

CREATE UNIQUE INDEX ux_customer_phone_number
ON customer_phone_numbers (customer_id)
WHERE is_primary AND deleted_at IS NULL;

CREATE UNIQUE INDEX ux_email_global
ON customer_emails (email)
WHERE deleted_at IS NULL;

CREATE UNIQUE INDEX ux_phone_global
ON customer_phone_numbers (country_code, phone_number)
WHERE deleted_at IS NULL;

-- Triggers
CREATE TRIGGER trg_customers_row_metadata
BEFORE UPDATE ON customers
FOR EACH ROW EXECUTE FUNCTION set_row_metadata();

CREATE TRIGGER trg_customer_addresses_row_metadata
BEFORE UPDATE ON customer_addresses
FOR EACH ROW EXECUTE FUNCTION set_row_metadata();

CREATE TRIGGER trg_customer_emails_row_metadata
BEFORE UPDATE ON customer_emails
FOR EACH ROW EXECUTE FUNCTION set_row_metadata();

CREATE TRIGGER trg_customer_nationalities_row_metadata
BEFORE UPDATE ON customer_nationalities
FOR EACH ROW EXECUTE FUNCTION set_row_metadata();

CREATE TRIGGER trg_customer_phone_numbers_row_metadata
BEFORE UPDATE ON customer_phone_numbers
FOR EACH ROW EXECUTE FUNCTION set_row_metadata();

-- RLS
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_emails ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_phone_numbers ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_nationalities ENABLE ROW LEVEL SECURITY;

-- +goose Down
DROP TABLE IF EXISTS customer_addresses;
DROP TABLE IF EXISTS customer_emails;
DROP TABLE IF EXISTS customer_nationalities;
DROP TABLE IF EXISTS customer_phone_numbers;
DROP TABLE IF EXISTS customers_personal_details;
DROP TABLE IF EXISTS customers;
