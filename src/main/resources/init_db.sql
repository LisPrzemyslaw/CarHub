-- Tabela wypożyczalni
CREATE TABLE rental_offices (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    phone_number VARCHAR(20),
    email VARCHAR(100),
    opening_hours VARCHAR(255),
    latitude DECIMAL(10,8),  -- dla geolokalizacji
    longitude DECIMAL(11,8), -- dla geolokalizacji
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Tabela użytkowników
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(100),
    postal_code VARCHAR(10),
    driving_license_number VARCHAR(50),
    role ENUM('CUSTOMER', 'EMPLOYEE', 'ADMIN') NOT NULL,
    account_status ENUM('ACTIVE', 'INACTIVE', 'BLOCKED') NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Tabela kategorii samochodów
CREATE TABLE car_categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    daily_rate DECIMAL(10,2) NOT NULL,
    deposit_amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Tabela samochodów
CREATE TABLE cars (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    rental_office_id BIGINT,
    category_id BIGINT,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INTEGER NOT NULL,
    color VARCHAR(30),
    registration_number VARCHAR(20) UNIQUE NOT NULL,
    vin_number VARCHAR(17) UNIQUE NOT NULL,
    mileage INTEGER,
    fuel_type ENUM('PETROL', 'DIESEL', 'ELECTRIC', 'HYBRID'),
    transmission ENUM('MANUAL', 'AUTOMATIC'),
    number_of_seats INTEGER,
    air_conditioning BOOLEAN,
    navigation_system BOOLEAN,
    current_status ENUM('AVAILABLE', 'RENTED', 'IN_SERVICE', 'UNAVAILABLE'),
    daily_rate DECIMAL(10,2),
    image_url VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (rental_office_id) REFERENCES rental_offices(id),
    FOREIGN KEY (category_id) REFERENCES car_categories(id)
);

-- Tabela rezerwacji
CREATE TABLE reservations (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    car_id BIGINT,
    rental_office_pickup_id BIGINT,
    rental_office_return_id BIGINT,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    actual_return_date TIMESTAMP,
    status ENUM('PENDING', 'CONFIRMED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'),
    total_price DECIMAL(10,2),
    deposit_paid BOOLEAN,
    notes TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (car_id) REFERENCES cars(id),
    FOREIGN KEY (rental_office_pickup_id) REFERENCES rental_offices(id),
    FOREIGN KEY (rental_office_return_id) REFERENCES rental_offices(id)
);

-- Tabela płatności
CREATE TABLE payments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    reservation_id BIGINT,
    amount DECIMAL(10,2) NOT NULL,
    payment_type ENUM('CREDIT_CARD', 'DEBIT_CARD', 'BANK_TRANSFER', 'CASH'),
    payment_status ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED'),
    transaction_id VARCHAR(100),
    payment_date TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations(id)
);

-- Tabela dodatkowych usług
CREATE TABLE additional_services (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    daily_rate DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Tabela łącząca rezerwacje z dodatkowymi usługami
CREATE TABLE reservation_additional_services (
    reservation_id BIGINT,
    service_id BIGINT,
    quantity INTEGER DEFAULT 1,
    price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (reservation_id, service_id),
    FOREIGN KEY (reservation_id) REFERENCES reservations(id),
    FOREIGN KEY (service_id) REFERENCES additional_services(id)
);

-- Tabela przeglądów/serwisów samochodów
CREATE TABLE car_maintenance (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    car_id BIGINT,
    maintenance_type VARCHAR(100),
    description TEXT,
    service_date TIMESTAMP,
    mileage INTEGER,
    cost DECIMAL(10,2),
    next_service_date TIMESTAMP,
    next_service_mileage INTEGER,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES cars(id)
);

-- Tabela ocen i opinii
CREATE TABLE reviews (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    reservation_id BIGINT,
    user_id BIGINT,
    car_id BIGINT,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (car_id) REFERENCES cars(id)
);

-- Tabela dokumentów
CREATE TABLE documents (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    reservation_id BIGINT,
    document_type ENUM('CONTRACT', 'INVOICE', 'DAMAGE_REPORT', 'INSURANCE'),
    file_path VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations(id)
);

-- Tabela uszkodzeń
CREATE TABLE damages (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    car_id BIGINT,
    reservation_id BIGINT,
    description TEXT,
    damage_date TIMESTAMP,
    repair_cost DECIMAL(10,2),
    status ENUM('REPORTED', 'IN_REPAIR', 'REPAIRED'),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES cars(id),
    FOREIGN KEY (reservation_id) REFERENCES reservations(id)
);
