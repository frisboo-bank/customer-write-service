BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE OR REPLACE FUNCTION created_at_trigger()
RETURNS TRIGGER AS $$
BEGIN
    NEW.created_at = OLD.created_at;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION updated_at_trigger()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE customer_personal_information (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    title text,
    first_name text,
    middle_name text,
    last_name text,
    first_name_in_english text,
    middle_name_in_english text,
    last_name_in_english text,
    date_of_birth TIMESTAMPTZ,
    country_of_birth_id text,
    gender_id text,
    is_politically_exposed bool,
    is_us_person bool,
    marital_status_id text,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TRIGGER created_at_customers_trigger
BEFORE UPDATE ON customer_personal_information
FOR EACH ROW EXECUTE PROCEDURE created_at_trigger();

CREATE TRIGGER updated_at_customers_trigger
BEFORE UPDATE ON customer_personal_information
FOR EACH ROW EXECUTE PROCEDURE updated_at_trigger();

COMMIT;
