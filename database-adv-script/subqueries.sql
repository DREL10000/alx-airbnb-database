-- Non-Correlated Subquery: Properties with Average Rating > 4.0

SELECT 
    p.property_id,
    p.name,
    p.location,
    p.pricepernight
FROM Property p
WHERE p.property_id IN (
    SELECT r.property_id
    FROM Review r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
);

-- Correlated Subquery: Users with More Than 3 Bookings

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role
FROM User u
WHERE (
    SELECT COUNT(*)
    FROM Booking b
    WHERE b.user_id = u.user_id
) > 3;