CREATE TABLE category (
    id BIGINT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE location (
    id BIGINT PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(255),
    longitude DECIMAL,
    latitude DECIMAL
);

CREATE TABLE car (
    id BIGINT PRIMARY KEY,
    vin VARCHAR(100),
    make VARCHAR(100),
    model VARCHAR(100),
    year BIGINT,
    location_id BIGINT,
    FOREIGN KEY (location_id) REFERENCES location(id)
);

CREATE TABLE car_category (
    category_id BIGINT,
    car_id BIGINT,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (category_id, car_id, start_date),
    FOREIGN KEY (category_id) REFERENCES category(id),
    FOREIGN KEY (car_id) REFERENCES car(id)
);

CREATE TABLE customer (
    id BIGINT PRIMARY KEY,
    license_number VARCHAR(100) UNIQUE,
    name VARCHAR(100),
    phone_num VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(255)
);

CREATE TABLE reservation (
    id BIGINT PRIMARY KEY,
    car_id BIGINT,
    customer_id BIGINT,
    created_at TIMESTAMP,
    start_date DATE,
    no_of_days BIGINT,
    status VARCHAR(20),
    FOREIGN KEY (car_id) REFERENCES car(id),
    FOREIGN KEY (customer_id) REFERENCES customer(id)
);

CREATE TABLE maintenance_schedule (
    schedule_id BIGINT PRIMARY KEY,
    car_id BIGINT,
    planned_date TIMESTAMP,
    status VARCHAR(20),
    FOREIGN KEY (car_id) REFERENCES car(id)
);

CREATE TABLE maintenance_record (
    schedule_id BIGINT,
    "desc" VARCHAR(255),
    actual_date TIMESTAMP,
    PRIMARY KEY (schedule_id),
    FOREIGN KEY (schedule_id) REFERENCES maintenance_schedule(schedule_id)
);
