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

-- ENUM Types
CREATE TYPE Bookings_resource_type_enum AS ENUM ('meeting room', 'equipment');
CREATE TYPE EntryType_enum AS ENUM ('entry', 'exit');
CREATE TYPE Maintenance_enum AS ENUM ('finished', 'in_progress', 'scheduled');
CREATE TYPE Invoice_enum AS ENUM ('paid', 'pending', 'overdue');
CREATE TYPE Security_enum AS ENUM ('active', 'inactive');
CREATE TYPE occupied_enum AS ENUM ('occupied', 'not_occupied', 'under_maintenance');
CREATE TYPE member_status_enum AS ENUM ('active', 'inactive');
CREATE TYPE usage_enum AS ENUM ('item', 'service');
CREATE TYPE participant_type AS ENUM ('member', 'non_member');

-- Tables

CREATE TABLE Plan_Type (
    plan_type_id BIGSERIAL PRIMARY KEY,
    plan_type TEXT NOT NULL,
    monthly_fees BIGINT NOT NULL
);

CREATE TABLE Locations (
    location_id BIGSERIAL PRIMARY KEY,
    location_name TEXT NOT NULL,
    address TEXT NOT NULL
);

CREATE TABLE Members (
    member_id BIGSERIAL PRIMARY KEY,
    member_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    membership_type_id BIGINT NOT NULL,
    status member_status_enum NOT NULL,
    FOREIGN KEY (membership_type_id) REFERENCES Plan_Type(plan_type_id)
);

CREATE TABLE Membership (
    membership_id BIGSERIAL PRIMARY KEY,
    member_id BIGINT NOT NULL,
    membership_type_id BIGINT NOT NULL,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    purchased_date TIMESTAMP NOT NULL,
    invoice_id BIGINT,
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (membership_type_id) REFERENCES Plan_Type(plan_type_id)
);

CREATE TABLE Workspaces (
    workspace_id BIGSERIAL PRIMARY KEY,
    workspace_type BIGINT NOT NULL,
    location_id BIGINT NOT NULL,
    occupied occupied_enum NOT NULL,
    workspace_area_sqft BIGINT NOT NULL,
    FOREIGN KEY (workspace_type) REFERENCES Plan_Type(plan_type_id),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

CREATE TABLE MeetingRooms (
    meeting_room_id BIGSERIAL PRIMARY KEY,
    meeting_room_no BIGINT NOT NULL,
    location_id BIGINT NOT NULL,
    occupied occupied_enum NOT NULL,
    capacity BIGINT NOT NULL,
    price_per_hour BIGINT NOT NULL,
    device_id BIGINT NOT NULL,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

CREATE TABLE EquipmentsType (
    equipment_type_id BIGSERIAL PRIMARY KEY,
    equipment_type_name TEXT NOT NULL
);

CREATE TABLE Equipments (
    equipment_id BIGSERIAL PRIMARY KEY,
    equipment_type_id BIGINT NOT NULL,
    price_per_hour BIGINT NOT NULL,
    location_id BIGINT NOT NULL,
    occupied occupied_enum NOT NULL,
    FOREIGN KEY (equipment_type_id) REFERENCES EquipmentsType(equipment_type_id),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

CREATE TABLE Vendors (
    vendor_id BIGSERIAL PRIMARY KEY,
    vendor_name TEXT NOT NULL
);

CREATE TABLE StockedItem (
    item_id BIGSERIAL PRIMARY KEY,
    item_type_id BIGINT NOT NULL,
    vendor_id BIGINT NOT NULL,
    price BIGINT NOT NULL,
    available_quantity BIGINT NOT NULL,
    location_id BIGINT NOT NULL,
    FOREIGN KEY (item_type_id) REFERENCES ItemsType(item_type_id),
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

CREATE TABLE ItemsType (
    item_type_id BIGSERIAL PRIMARY KEY,
    item_type_name TEXT NOT NULL
);

CREATE TABLE ServiceItems (
    item_id BIGSERIAL PRIMARY KEY,
    item_type_id BIGINT NOT NULL,
    vendor_id BIGINT NOT NULL,
    price BIGINT NOT NULL,
    location_id BIGINT NOT NULL,
    FOREIGN KEY (item_type_id) REFERENCES ItemsType(item_type_id),
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

CREATE TABLE MaintenanceItems (
    item_id BIGSERIAL PRIMARY KEY,
    item_name TEXT NOT NULL,
    vendor_id BIGINT NOT NULL,
    price BIGINT NOT NULL,
    location_id BIGINT NOT NULL,
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

CREATE TABLE SecurityDevices (
    device_id BIGSERIAL PRIMARY KEY,
    device_name TEXT NOT NULL,
    location_id BIGINT NOT NULL,
    status Security_enum NOT NULL,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

CREATE TABLE Invoice (
    invoice_id BIGSERIAL PRIMARY KEY,
    member_id BIGINT NOT NULL,
    total_amount BIGINT NOT NULL,
    due_date TIMESTAMP NOT NULL,
    invoice_status Invoice_enum NOT NULL,
    invoice_date TIMESTAMP NOT NULL,
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

CREATE TABLE MaintenanceHistory (
    Maintenance_id BIGSERIAL PRIMARY KEY,
    item_id BIGINT NOT NULL,
    maintenance_status Maintenance_enum NOT NULL,
    total_amount BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    FOREIGN KEY (item_id) REFERENCES MaintenanceItems(item_id)
);

CREATE TABLE usage (
    usage_id BIGSERIAL PRIMARY KEY,
    usage_type usage_enum NOT NULL,
    type_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    quantity BIGINT NOT NULL,
    total_price BIGINT NOT NULL,
    purchased_date TIMESTAMP NOT NULL,
    invoice_id BIGINT,
    FOREIGN KEY (type_id) REFERENCES StockedItem(item_id),
    FOREIGN KEY (member_id) REFERENCES Membership(member_id),
    FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
);

CREATE TABLE AccessCard (
    card_id BIGSERIAL PRIMARY KEY,
    member_id BIGINT NOT NULL,
    access_type BIGINT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (access_type) REFERENCES Plan_Type(plan_type_id)
);

CREATE TABLE AccessLogs (
    log_id BIGSERIAL PRIMARY KEY,
    member_id BIGINT NOT NULL,
    device_id BIGINT NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    entry_type EntryType_enum NOT NULL,
    FOREIGN KEY (member_id) REFERENCES Membership(member_id),
    FOREIGN KEY (device_id) REFERENCES SecurityDevices(device_id)
);

CREATE TABLE Events (
    event_id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    location_id BIGINT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    capacity BIGINT NOT NULL,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

CREATE TABLE EventParticipation (
    event_id BIGINT NOT NULL,
    participant_type participant_type NOT NULL,
    participant_id BIGINT NOT NULL,
    PRIMARY KEY (event_id, participant_type, participant_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

CREATE TABLE Guests (
    guest_id BIGSERIAL PRIMARY KEY,
    guest_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL
);

CREATE TABLE Bookings (
    booking_id BIGSERIAL PRIMARY KEY,
    member_id BIGINT NOT NULL,
    resource_type Bookings_resource_type_enum NOT NULL,
    resource_id BIGINT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    total_price BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    invoice_id BIGINT,
    FOREIGN KEY (member_id) REFERENCES Membership(member_id),
    FOREIGN KEY (resource_id) REFERENCES MeetingRooms(meeting_room_id),
    FOREIGN KEY (resource_id) REFERENCES Equipments(equipment_id),
    FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
);

CREATE TABLE WorkspaceBookings (
    booking_id BIGSERIAL PRIMARY KEY,
    member_id BIGINT NOT NULL,
    workspace_id BIGINT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    invoice_id BIGINT,
    FOREIGN KEY (member_id) REFERENCES Membership(member_id),
    FOREIGN KEY (workspace_id) REFERENCES Workspaces(workspace_id),
    FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
);

-- Additional foreign keys for EventParticipation
ALTER TABLE EventParticipation
    ADD FOREIGN KEY (participant_id) REFERENCES Guests(guest_id),
    ADD FOREIGN KEY (participant_id) REFERENCES Membership(member_id);

-- Additional foreign keys for usage
ALTER TABLE usage
    ADD FOREIGN KEY (type_id) REFERENCES ServiceItems(item_id);

-- Additional foreign keys for MeetingRooms
ALTER TABLE MeetingRooms
    ADD FOREIGN KEY (device_id) REFERENCES SecurityDevices(device_id);
