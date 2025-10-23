-- Enable UUID extension for generating UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- USER TABLE
-- =====================================================
-- This stores all users: guests, hosts, and admins
CREATE TABLE "User" (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) NULL,
    role VARCHAR(10) NOT NULL CHECK (role IN ('guest', 'host', 'admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index on email for fast lookups during login
CREATE INDEX idx_user_email ON "User"(email);

-- Index on role for filtering users by type
CREATE INDEX idx_user_role ON "User"(role);


-- =====================================================
-- PROPERTY TABLE
-- =====================================================
-- Stores property listings created by hosts
CREATE TABLE Property (
    property_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    host_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    pricepernight DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key: each property must belong to a valid user (host)
    CONSTRAINT fk_property_host 
        FOREIGN KEY (host_id) 
        REFERENCES "User"(user_id) 
        ON DELETE CASCADE
);

-- Index on host_id to quickly find all properties by a specific host
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index on location for location-based searches
CREATE INDEX idx_property_location ON Property(location);

-- Index on pricepernight for price range queries
CREATE INDEX idx_property_price ON Property(pricepernight);


-- =====================================================
-- BOOKING TABLE
-- =====================================================
-- Stores reservation information
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(10) NOT NULL CHECK (status IN ('pending', 'confirmed', 'canceled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign keys
    CONSTRAINT fk_booking_property 
        FOREIGN KEY (property_id) 
        REFERENCES Property(property_id) 
        ON DELETE CASCADE,
    
    CONSTRAINT fk_booking_user 
        FOREIGN KEY (user_id) 
        REFERENCES "User"(user_id) 
        ON DELETE CASCADE,
    
    -- Check constraint: end_date must be after start_date
    CONSTRAINT chk_booking_dates 
        CHECK (end_date > start_date)
);

-- Index on property_id to find all bookings for a property
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Index on user_id to find all bookings by a user
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index on status for filtering by booking status
CREATE INDEX idx_booking_status ON Booking(status);

-- Composite index for date range queries (finding available properties)
CREATE INDEX idx_booking_dates ON Booking(property_id, start_date, end_date);


-- =====================================================
-- PAYMENT TABLE
-- =====================================================
-- Stores payment transactions
CREATE TABLE Payment (
    payment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('credit_card', 'paypal', 'stripe')),
    
    -- Foreign key: payment must be linked to a valid booking
    CONSTRAINT fk_payment_booking 
        FOREIGN KEY (booking_id) 
        REFERENCES Booking(booking_id) 
        ON DELETE CASCADE
);

-- Index on booking_id to quickly find payments for a specific booking
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Index on payment_date for financial reporting
CREATE INDEX idx_payment_date ON Payment(payment_date);


-- =====================================================
-- REVIEW TABLE
-- =====================================================
-- Stores property reviews from guests
CREATE TABLE Review (
    review_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign keys
    CONSTRAINT fk_review_property 
        FOREIGN KEY (property_id) 
        REFERENCES Property(property_id) 
        ON DELETE CASCADE,
    
    CONSTRAINT fk_review_user 
        FOREIGN KEY (user_id) 
        REFERENCES "User"(user_id) 
        ON DELETE CASCADE
);

-- Index on property_id to get all reviews for a property
CREATE INDEX idx_review_property_id ON Review(property_id);

-- Index on user_id to get all reviews by a user
CREATE INDEX idx_review_user_id ON Review(user_id);

-- Index on rating for filtering high/low rated properties
CREATE INDEX idx_review_rating ON Review(rating);


-- =====================================================
-- MESSAGE TABLE
-- =====================================================
-- Stores messages between users
CREATE TABLE Message (
    message_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign keys
    CONSTRAINT fk_message_sender 
        FOREIGN KEY (sender_id) 
        REFERENCES "User"(user_id) 
        ON DELETE CASCADE,
    
    CONSTRAINT fk_message_recipient 
        FOREIGN KEY (recipient_id) 
        REFERENCES "User"(user_id) 
        ON DELETE CASCADE,
    
    -- Check constraint: sender and recipient must be different
    CONSTRAINT chk_message_different_users 
        CHECK (sender_id != recipient_id)
);

-- Index on sender_id to find all messages sent by a user
CREATE INDEX idx_message_sender_id ON Message(sender_id);

-- Index on recipient_id to find all messages received by a user
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);

-- Composite index for conversation threads
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);