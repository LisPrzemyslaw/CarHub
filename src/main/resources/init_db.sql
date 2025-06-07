-- ENUM-y
CREATE TYPE user_role AS ENUM ('CUSTOMER', 'EMPLOYEE', 'ADMIN');
CREATE TYPE account_status_enum AS ENUM ('ACTIVE', 'INACTIVE', 'BLOCKED');
CREATE TYPE fuel_type_enum AS ENUM ('PETROL', 'DIESEL', 'ELECTRIC', 'HYBRID');
CREATE TYPE transmission_enum AS ENUM ('MANUAL', 'AUTOMATIC');
CREATE TYPE car_status_enum AS ENUM ('AVAILABLE', 'RENTED', 'IN_SERVICE', 'UNAVAILABLE');
CREATE TYPE reservation_status_enum AS ENUM ('PENDING', 'CONFIRMED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED');
CREATE TYPE payment_type_enum AS ENUM ('CREDIT_CARD', 'DEBIT_CARD', 'BANK_TRANSFER', 'CASH');
CREATE TYPE payment_status_enum AS ENUM ('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED');
CREATE TYPE document_type_enum AS ENUM ('CONTRACT', 'INVOICE', 'DAMAGE_REPORT', 'INSURANCE');

-- rental_offices
CREATE TABLE rental_offices
(
    id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name          VARCHAR(255) NOT NULL,
    address       VARCHAR(255) NOT NULL,
    city          VARCHAR(100) NOT NULL,
    postal_code   VARCHAR(10)  NOT NULL,
    phone_number  VARCHAR(20),
    email         VARCHAR(100),
    opening_hours VARCHAR(255),
    latitude      NUMERIC(10, 8),
    longitude     NUMERIC(11, 8),
    is_active     BOOLEAN DEFAULT TRUE,
    created_at    TIMESTAMP,
    updated_at    TIMESTAMP
);

-- users
CREATE TABLE users
(
    id                     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email                  VARCHAR(100) UNIQUE NOT NULL,
    password               VARCHAR(255)        NOT NULL,
    first_name             VARCHAR(50)         NOT NULL,
    last_name              VARCHAR(50)         NOT NULL,
    phone_number           VARCHAR(20),
    address                VARCHAR(255),
    city                   VARCHAR(100),
    postal_code            VARCHAR(10),
    driving_license_number VARCHAR(50),
    role                   user_role           NOT NULL,
    account_status         account_status_enum NOT NULL,
    created_at             TIMESTAMP,
    updated_at             TIMESTAMP
);

-- car_categories
CREATE TABLE car_categories
(
    id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name           VARCHAR(50)    NOT NULL,
    description    TEXT,
    daily_rate     NUMERIC(10, 2) NOT NULL,
    deposit_amount NUMERIC(10, 2) NOT NULL,
    created_at     TIMESTAMP,
    updated_at     TIMESTAMP
);

-- cars
CREATE TABLE cars
(
    id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rental_office_id    BIGINT,
    category_id         BIGINT,
    brand               VARCHAR(50)        NOT NULL,
    model               VARCHAR(50)        NOT NULL,
    year                INTEGER            NOT NULL,
    color               VARCHAR(30),
    registration_number VARCHAR(20) UNIQUE NOT NULL,
    vin_number          VARCHAR(17) UNIQUE NOT NULL,
    mileage             INTEGER,
    fuel_type           fuel_type_enum,
    transmission        transmission_enum,
    number_of_seats     INTEGER,
    air_conditioning    BOOLEAN,
    navigation_system   BOOLEAN,
    current_status      car_status_enum,
    daily_rate          NUMERIC(10, 2),
    image_url           VARCHAR(255),
    created_at          TIMESTAMP,
    updated_at          TIMESTAMP,
    FOREIGN KEY (rental_office_id) REFERENCES rental_offices (id),
    FOREIGN KEY (category_id) REFERENCES car_categories (id)
);

-- reservations
CREATE TABLE reservations
(
    id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id                 BIGINT,
    car_id                  BIGINT,
    rental_office_pickup_id BIGINT,
    rental_office_return_id BIGINT,
    start_date              TIMESTAMP NOT NULL,
    end_date                TIMESTAMP NOT NULL,
    actual_return_date      TIMESTAMP,
    status                  reservation_status_enum,
    total_price             NUMERIC(10, 2),
    deposit_paid            BOOLEAN,
    notes                   TEXT,
    created_at              TIMESTAMP,
    updated_at              TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (car_id) REFERENCES cars (id),
    FOREIGN KEY (rental_office_pickup_id) REFERENCES rental_offices (id),
    FOREIGN KEY (rental_office_return_id) REFERENCES rental_offices (id)
);

-- payments
CREATE TABLE payments
(
    id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reservation_id BIGINT,
    amount         NUMERIC(10, 2) NOT NULL,
    payment_type   payment_type_enum,
    payment_status payment_status_enum,
    transaction_id VARCHAR(100),
    payment_date   TIMESTAMP,
    created_at     TIMESTAMP,
    updated_at     TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations (id)
);

-- reviews
CREATE TABLE reviews
(
    id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reservation_id BIGINT,
    user_id        BIGINT,
    car_id         BIGINT,
    rating         INTEGER CHECK (rating BETWEEN 1 AND 5),
    comment        TEXT,
    created_at     TIMESTAMP,
    updated_at     TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations (id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (car_id) REFERENCES cars (id)
);

-- documents
CREATE TABLE documents
(
    id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reservation_id BIGINT,
    document_type  document_type_enum,
    file_path      VARCHAR(255),
    created_at     TIMESTAMP,
    updated_at     TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations (id)
);
