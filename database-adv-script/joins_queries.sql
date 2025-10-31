-- ============================================================================
-- 1. INNER JOIN: Retrieve all bookings with their respective users
-- ============================================================================
-- This query returns only bookings that have an associated user
-- (excludes any orphaned bookings without a valid user_id)

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
ORDER BY 
    b.created_at DESC;


-- ============================================================================
-- 2. LEFT JOIN: Retrieve all properties and their reviews
-- ============================================================================
-- This query returns ALL properties, including those without any reviews
-- Properties with no reviews will show NULL values in the review columns

SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    p.host_id,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date,
    CONCAT(u.first_name, ' ', u.last_name) AS reviewer_name
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
LEFT JOIN 
    User u ON r.user_id = u.user_id
ORDER BY 
    p.property_id, r.created_at DESC;


-- ============================================================================
-- 3. FULL OUTER JOIN: Retrieve all users and all bookings
-- ============================================================================
-- MySQL doesn't support FULL OUTER JOIN directly, so we simulate it using
-- UNION of LEFT JOIN and RIGHT JOIN
-- This returns all users (even without bookings) and all bookings (even 
-- without valid users)

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at
FROM 
    User u
LEFT JOIN 
    Booking b ON u.user_id = b.user_id

UNION

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at
FROM 
    Booking b
RIGHT JOIN 
    User u ON b.user_id = u.user_id
WHERE 
    u.user_id IS NULL
ORDER BY 
    user_id, booking_created_at DESC;


-- ============================================================================
-- BONUS: Enhanced queries with aggregations
-- ============================================================================

-- INNER JOIN with booking count per user
SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_spent,
    MIN(b.start_date) AS first_booking_date,
    MAX(b.start_date) AS latest_booking_date
FROM 
    User u
INNER JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name, u.email
HAVING 
    COUNT(b.booking_id) > 0
ORDER BY 
    total_bookings DESC;


-- LEFT JOIN showing properties with review statistics
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    COUNT(r.review_id) AS total_reviews,
    AVG(r.rating) AS average_rating,
    MAX(r.rating) AS highest_rating,
    MIN(r.rating) AS lowest_rating,
    CASE 
        WHEN COUNT(r.review_id) = 0 THEN 'No Reviews'
        WHEN AVG(r.rating) >= 4.5 THEN 'Excellent'
        WHEN AVG(r.rating) >= 3.5 THEN 'Good'
        WHEN AVG(r.rating) >= 2.5 THEN 'Fair'
        ELSE 'Poor'
    END AS rating_category
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.name, p.location, p.pricepernight
ORDER BY 
    average_rating DESC, total_reviews DESC;