-- ============================================================================
-- Database Performance Indexes
-- Purpose: Optimize query performance for high-usage columns
-- ============================================================================

EXPLAIN SELECT * FROM Property WHERE location = 'Miami' AND pricepernight < 200;
EXPLAIN SELECT * FROM Booking WHERE property_id = 'xxx' AND start_date >= '2025-11-01' AND end_date <= '2025-11-30';
EXPLAIN SELECT * FROM Review WHERE property_id = 'xxx' ORDER BY created_at DESC;
EXPLAIN SELECT * FROM User WHERE role = 'host' AND created_at > '2025-01-01';
EXPLAIN SELECT * FROM Payment WHERE payment_date BETWEEN '2025-10-01' AND '2025-10-31';

-- ----------------------------------------------------------------------------
-- USER TABLE INDEXES
-- ----------------------------------------------------------------------------

-- Index on role column for filtering users by type (guest, host, admin)
-- Use case: Admin dashboards, role-based queries
CREATE INDEX idx_user_role ON User(role);

-- Index on created_at for sorting and filtering new users
-- Use case: Recent user reports, user growth analytics
CREATE INDEX idx_user_created_at ON User(created_at);

-- Composite index for role and created_at (common filtering pattern)
-- Use case: "Show me all hosts created in the last month"
CREATE INDEX idx_user_role_created ON User(role, created_at);


-- ----------------------------------------------------------------------------
-- PROPERTY TABLE INDEXES
-- ----------------------------------------------------------------------------

-- Index on host_id (foreign key) for joining and filtering properties by host
-- Use case: "Show all properties for a specific host"
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index on location for searching properties by location
-- Use case: Property search by city/region
CREATE INDEX idx_property_location ON Property(location);

-- Index on pricepernight for filtering and sorting by price
-- Use case: Price range filters, sorting by price
CREATE INDEX idx_property_price ON Property(pricepernight);

-- Index on created_at for sorting new listings
-- Use case: "Show newest properties"
CREATE INDEX idx_property_created_at ON Property(created_at);

-- Composite index for location and price (common search pattern)
-- Use case: "Find properties in Miami under $200/night"
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);


-- ----------------------------------------------------------------------------
-- BOOKING TABLE INDEXES
-- ----------------------------------------------------------------------------

-- Index on property_id (foreign key) for property booking history
-- Use case: "Show all bookings for a property"
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Index on user_id (foreign key) for user booking history
-- Use case: "Show all bookings for a user"
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index on status for filtering bookings by status
-- Use case: "Show all pending bookings", "Show confirmed reservations"
CREATE INDEX idx_booking_status ON Booking(status);

-- Index on start_date for date range queries and availability checks
-- Use case: Checking property availability, upcoming bookings
CREATE INDEX idx_booking_start_date ON Booking(start_date);

-- Index on end_date for date range queries
-- Use case: Availability checks, booking conflicts
CREATE INDEX idx_booking_end_date ON Booking(end_date);

-- Composite index for property availability queries
-- Use case: "Is this property available between these dates?"
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);

-- Composite index for user bookings with status
-- Use case: "Show user's confirmed bookings"
CREATE INDEX idx_booking_user_status ON Booking(user_id, status);

-- Index on created_at for recent bookings
-- Use case: Recent booking reports
CREATE INDEX idx_booking_created_at ON Booking(created_at);


-- ----------------------------------------------------------------------------
-- PAYMENT TABLE INDEXES
-- ----------------------------------------------------------------------------

-- Index on booking_id (foreign key) for payment lookup by booking
-- Use case: "Get payment details for a booking"
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Index on payment_date for financial reports and date filtering
-- Use case: "Monthly revenue reports", "Payments in date range"
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- Index on payment_method for payment analytics
-- Use case: "Revenue by payment method"
CREATE INDEX idx_payment_method ON Payment(payment_method);

-- Composite index for payment reports by date and method
-- Use case: "Credit card payments in October 2025"
CREATE INDEX idx_payment_date_method ON Payment(payment_date, payment_method);


-- ----------------------------------------------------------------------------
-- REVIEW TABLE INDEXES
-- ----------------------------------------------------------------------------

-- Index on property_id (foreign key) for property reviews
-- Use case: "Show all reviews for a property"
CREATE INDEX idx_review_property_id ON Review(property_id);

-- Index on user_id (foreign key) for user review history
-- Use case: "Show all reviews written by a user"
CREATE INDEX idx_review_user_id ON Review(user_id);

-- Index on rating for filtering by rating
-- Use case: "Show 5-star reviews", rating analytics
CREATE INDEX idx_review_rating ON Review(rating);

-- Index on created_at for sorting reviews by date
-- Use case: "Show most recent reviews"
CREATE INDEX idx_review_created_at ON Review(created_at);

-- Composite index for property reviews with rating
-- Use case: "Show 5-star reviews for this property"
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);


-- ----------------------------------------------------------------------------
-- MESSAGE TABLE INDEXES
-- ----------------------------------------------------------------------------

-- Index on sender_id (foreign key) for sent messages
-- Use case: "Show messages sent by user"
CREATE INDEX idx_message_sender_id ON Message(sender_id);

-- Index on recipient_id (foreign key) for received messages
-- Use case: "Show messages received by user"
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);

-- Index on sent_at for sorting messages by date
-- Use case: Chronological message ordering
CREATE INDEX idx_message_sent_at ON Message(sent_at);

-- Composite index for user conversation queries
-- Use case: "Show conversation between two users"
CREATE INDEX idx_message_sender_recipient ON Message(sender_id, recipient_id, sent_at);

-- Composite index for inbox queries
-- Use case: "Show recent messages for user"
CREATE INDEX idx_message_recipient_sent ON Message(recipient_id, sent_at);

EXPLAIN SELECT * FROM Property WHERE location = 'Miami' AND pricepernight < 200;
EXPLAIN SELECT * FROM Booking WHERE property_id = 'xxx' AND start_date >= '2025-11-01' AND end_date <= '2025-11-30';
EXPLAIN SELECT * FROM Review WHERE property_id = 'xxx' ORDER BY created_at DESC;
EXPLAIN SELECT * FROM User WHERE role = 'host' AND created_at > '2025-01-01';
EXPLAIN SELECT * FROM Payment WHERE payment_date BETWEEN '2025-10-01' AND '2025-10-31';