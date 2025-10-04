CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE customer_personal_information (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    title text,
    first_name text,
    middle_name text,
    last_name text,
    first_name_in_english text,
    middle_name_in_english text,
    last_name_in_english text,
    date_of_birth timestamptz,
    country_of_birth_id text,
    gender_id text,
    is_politically_exposed boolean DEFAULT false,
    is_us_person boolean DEFAULT false,
    marital_status_id text,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);
