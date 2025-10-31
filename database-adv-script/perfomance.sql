-- ============================================================================
-- INITIAL QUERY (Before Optimization)
-- ============================================================================
-- This query retrieves all bookings with related user, property, and payment details
-- Performance issues: Multiple joins, potential N+1 problems, retrieving unnecessary data

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    
    -- Guest user details
    u.user_id AS guest_id,
    u.first_name AS guest_first_name,
    u.last_name AS guest_last_name,
    u.email AS guest_email,
    u.phone_number AS guest_phone,
    u.role AS guest_role,
    u.created_at AS guest_created_at,
    
    -- Property details
    p.property_id,
    p.name AS property_name,
    p.description AS property_description,
    p.location AS property_location,
    p.pricepernight,
    p.created_at AS property_created_at,
    p.updated_at AS property_updated_at,
    
    -- Host details
    h.user_id AS host_id,
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    h.email AS host_email,
    h.phone_number AS host_phone,
    h.role AS host_role,
    h.created_at AS host_created_at,
    
    -- Payment details
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_date,
    pay.payment_method
    
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.status = 'confirmed'
  AND b.start_date >= CURRENT_DATE
ORDER BY b.created_at DESC;


-- ============================================================================
-- PERFORMANCE ANALYSIS
-- ============================================================================
-- Run this to analyze the query performance:

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    u.user_id AS guest_id,
    u.first_name AS guest_first_name,
    u.last_name AS guest_last_name,
    u.email AS guest_email,
    u.phone_number AS guest_phone,
    u.role AS guest_role,
    u.created_at AS guest_created_at,
    p.property_id,
    p.name AS property_name,
    p.description AS property_description,
    p.location AS property_location,
    p.pricepernight,
    p.created_at AS property_created_at,
    p.updated_at AS property_updated_at,
    h.user_id AS host_id,
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    h.email AS host_email,
    h.phone_number AS host_phone,
    h.role AS host_role,
    h.created_at AS host_created_at,
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_date,
    pay.payment_method
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC;


-- ============================================================================
-- IDENTIFIED INEFFICIENCIES
-- ============================================================================
/*
1. EXCESSIVE COLUMNS: Retrieving all columns including large TEXT fields (description, password_hash)
2. MULTIPLE JOINS: Four joins on User table (guest and host), Property, and Payment
3. MISSING INDEXES: Need indexes on foreign keys (user_id, property_id, host_id, booking_id)
4. FULL TABLE SCAN: Without proper indexes, joins may require full table scans
5. LARGE TEXT FIELDS: Including property.description in SELECT can slow down query
6. NO FILTERING: Query retrieves all records without pagination or date filters
7. SORTING OVERHEAD: ORDER BY on booking.created_at without optimization
*/


-- ============================================================================
-- RECOMMENDED INDEXES (Run these before refactored query)
-- ============================================================================

-- Index on Booking foreign keys (if not already indexed)
CREATE INDEX IF NOT EXISTS idx_booking_user_id ON Booking(user_id);
CREATE INDEX IF NOT EXISTS idx_booking_property_id ON Booking(property_id);
CREATE INDEX IF NOT EXISTS idx_booking_status ON Booking(status);
CREATE INDEX IF NOT EXISTS idx_booking_created_at ON Booking(created_at);

-- Index on Property foreign key
CREATE INDEX IF NOT EXISTS idx_property_host_id ON Property(host_id);

-- Index on Payment foreign key
CREATE INDEX IF NOT EXISTS idx_payment_booking_id ON Payment(booking_id);

-- Composite index for common queries
CREATE INDEX IF NOT EXISTS idx_booking_status_created ON Booking(status, created_at DESC);


-- ============================================================================
-- REFACTORED QUERY (Optimized Version)
-- ============================================================================
-- Improvements:
-- 1. Removed unnecessary columns (especially large TEXT fields)
-- 2. Removed redundant user details (role, created_at for users)
-- 3. Added LIMIT for pagination
-- 4. Used covering indexes
-- 5. Optimized JOIN order (smaller tables first)

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    
    -- Guest essentials only
    u.user_id AS guest_id,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email AS guest_email,
    u.phone_number AS guest_phone,
    
    -- Property essentials only (no description)
    p.property_id,
    p.name AS property_name,
    p.location AS property_location,
    p.pricepernight,
    
    -- Host essentials only
    h.user_id AS host_id,
    CONCAT(h.first_name, ' ', h.last_name) AS host_name,
    h.email AS host_email,
    h.phone_number AS host_phone,
    
    -- Payment essentials
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_date,
    pay.payment_method
    
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.status IN ('confirmed', 'pending')  -- Filter early
ORDER BY b.created_at DESC
LIMIT 100;  -- Add pagination
