-- +goose Up

-- Function: validate_of_age
-- Determines if dob is at least 18 years before current_date.
-- +goose StatementBegin
CREATE OR REPLACE FUNCTION validate_of_age(dob date)
RETURNS boolean 
STABLE
LANGUAGE plpgsql AS $$
BEGIN
  RETURN dob <= (current_date - interval '18 years');
END;
$$;
-- +goose StatementEnd

-- Function: set_row_metadata
-- Handles created_at protection and updated_at refresh only on meaningful changes.
-- +goose StatementBegin
CREATE OR REPLACE FUNCTION set_row_metadata()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.created_at = COALESCE(NEW.created_at, CURRENT_TIMESTAMP);
        NEW.updated_at = CURRENT_TIMESTAMP;
    ELSIF TG_OP = 'UPDATE' THEN
        IF NEW.created_at IS DISTINCT FROM OLD.created_at THEN
            NEW.created_at = OLD.created_at;
        END IF;
        IF NEW IS DISTINCT FROM OLD THEN
            NEW.updated_at = CURRENT_TIMESTAMP;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;
-- +goose StatementEnd

-- Function: validate_verified
-- Validate consistency between verified status and timestamp
-- +goose StatementBegin
CREATE OR REPLACE FUNCTION validate_verified(verified boolean, verified_at timestamptz)
RETURNS boolean
IMMUTABLE
LANGUAGE plpgsql AS $$
BEGIN
    RETURN (verified AND verified_at IS NOT NULL) 
        OR (NOT verified AND verified_at IS NULL);
END;
$$;
-- +goose StatementEnd

-- Function: set_verified_timestamp
-- Auto-manages verified_at based on verified flag transitions.
-- Attach as BEFORE INSERT OR UPDATE trigger where appropriate.
-- +goose StatementBegin
CREATE OR REPLACE FUNCTION set_verified_at()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        IF NEW.verified THEN
            NEW.verified_at := COALESCE(NEW.verified_at, now());
        ELSE
            NEW.verified_at := NULL;
        END IF;
    ELSIF (TG_OP = 'UPDATE') THEN
        IF NEW.verified AND (NOT OLD.verified) THEN
            NEW.verified_at := COALESCE(NEW.verified_at, now());
        ELSIF (NOT NEW.verified) THEN
            NEW.verified_at := NULL;
        END IF;
    END IF;
    RETURN NEW;
END;
$$;
-- +goose StatementEnd





-- +goose Down

DROP FUNCTION IF EXISTS audit_row_changes();
DROP FUNCTION IF EXISTS set_row_metadata();
DROP FUNCTION IF EXISTS set_verified_at();
DROP FUNCTION IF EXISTS validate_of_age(date);
DROP FUNCTION IF EXISTS validate_verified(boolean, timestamptz);
