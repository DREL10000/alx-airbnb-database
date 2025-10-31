-- Query 1: Total number of bookings made by each user
-- Uses COUNT aggregation with GROUP BY to count bookings per user
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM 
    User u
LEFT JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, 
    u.first_name, 
    u.last_name, 
    u.email
ORDER BY 
    total_bookings DESC;

-- Alternative: Show only users who have made bookings
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM 
    User u
INNER JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, 
    u.first_name, 
    u.last_name, 
    u.email
ORDER BY 
    total_bookings DESC;


-- Query 2: Rank properties by total number of bookings using ROW_NUMBER
-- ROW_NUMBER assigns unique sequential numbers (no ties)
SELECT 
    p.property_id,
    p.name,
    p.location,
    p.host_id,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_rank
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, 
    p.name, 
    p.location, 
    p.host_id
ORDER BY 
    row_rank;


-- Query 3: Rank properties by total number of bookings using RANK
-- RANK assigns same rank to ties, with gaps in sequence
SELECT 
    p.property_id,
    p.name,
    p.location,
    p.host_id,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank_position
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, 
    p.name, 
    p.location, 
    p.host_id
ORDER BY 
    rank_position;


-- Query 4: Rank properties using DENSE_RANK for comparison
-- DENSE_RANK assigns same rank to ties, without gaps in sequence
SELECT 
    p.property_id,
    p.name,
    p.location,
    p.host_id,
    COUNT(b.booking_id) AS total_bookings,
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_rank_position
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, 
    p.name, 
    p.location, 
    p.host_id
ORDER BY 
    dense_rank_position;


-- Query 5: Advanced - Rank properties within each location
-- Shows how to partition window functions by location
SELECT 
    p.property_id,
    p.name,
    p.location,
    p.host_id,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (PARTITION BY p.location ORDER BY COUNT(b.booking_id) DESC) AS rank_in_location,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS overall_rank
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, 
    p.name, 
    p.location, 
    p.host_id
ORDER BY 
    p.location, 
    rank_in_location;