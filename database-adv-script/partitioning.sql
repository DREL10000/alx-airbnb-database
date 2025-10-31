-- ========================================
-- TABLE PARTITIONING FOR BOOKING TABLE
-- ========================================
-- This script implements RANGE partitioning on the Booking table
-- based on the start_date column to optimize query performance


DROP TABLE IF EXISTS Booking_old;


CREATE TABLE Booking (
    booking_id CHAR(36) NOT NULL,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id, start_date),  -- Composite key including partition column
    INDEX idx_property_id (property_id),
    INDEX idx_user_id (user_id),
    INDEX idx_start_date (start_date),
    INDEX idx_status (status)
) ENGINE=InnoDB
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p_2020 VALUES LESS THAN (2021),
    PARTITION p_2021 VALUES LESS THAN (2022),
    PARTITION p_2022 VALUES LESS THAN (2023),
    PARTITION p_2023 VALUES LESS THAN (2024),
    PARTITION p_2024 VALUES LESS THAN (2025),
    PARTITION p_2025 VALUES LESS THAN (2026),
    PARTITION p_2026 VALUES LESS THAN (2027),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);


ALTER TABLE Booking
    ADD CONSTRAINT fk_booking_property 
    FOREIGN KEY (property_id) REFERENCES Property(property_id)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Booking
    ADD CONSTRAINT fk_booking_user 
    FOREIGN KEY (user_id) REFERENCES User(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE;


SELECT 
    PARTITION_NAME,
    PARTITION_EXPRESSION,
    PARTITION_DESCRIPTION,
    TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_NAME = 'Booking' AND TABLE_SCHEMA = DATABASE();

-- ========================================
-- PERFORMANCE TESTING QUERIES
-- ========================================

-- Query 1: Fetch bookings for a specific date range (single partition)
-- This query should benefit most from partitioning
EXPLAIN PARTITIONS
SELECT 
    booking_id, 
    property_id, 
    user_id, 
    start_date, 
    end_date, 
    total_price, 
    status
FROM Booking
WHERE start_date >= '2025-01-01' AND start_date < '2025-12-31';

-- Query 2: Fetch confirmed bookings for a specific month
EXPLAIN PARTITIONS
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    p.name AS property_name
FROM Booking b
JOIN Property p ON b.property_id = p.property_id
WHERE b.start_date >= '2025-06-01' 
  AND b.start_date < '2025-07-01'
  AND b.status = 'confirmed';

-- Query 3: Count bookings by year (multi-partition scan)
EXPLAIN PARTITIONS
SELECT 
    YEAR(start_date) AS booking_year,
    COUNT(*) AS total_bookings,
    SUM(total_price) AS total_revenue
FROM Booking
GROUP BY YEAR(start_date)
ORDER BY booking_year;

-- Query 4: Recent bookings (last 30 days) - most common query
EXPLAIN PARTITIONS
SELECT 
    booking_id,
    property_id,
    user_id,
    start_date,
    end_date,
    status
FROM Booking
WHERE start_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY start_date DESC;

-- Query 5: User's booking history (filtered by partition)
EXPLAIN PARTITIONS
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    p.name AS property_name
FROM Booking b
JOIN Property p ON b.property_id = p.property_id
WHERE b.user_id = 'sample-user-uuid'
  AND b.start_date >= '2025-01-01'
ORDER BY b.start_date DESC;

-- ========================================
-- PARTITION MANAGEMENT QUERIES
-- ========================================


ALTER TABLE Booking 
REORGANIZE PARTITION p_future INTO (
    PARTITION p_2027 VALUES LESS THAN (2028),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);


-- Analyze partition statistics
ANALYZE TABLE Booking;

-- Check partition sizes
SELECT 
    PARTITION_NAME,
    TABLE_ROWS,
    AVG_ROW_LENGTH,
    DATA_LENGTH,
    INDEX_LENGTH,
    ROUND(DATA_LENGTH / 1024 / 1024, 2) AS data_size_mb,
    ROUND(INDEX_LENGTH / 1024 / 1024, 2) AS index_size_mb
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_NAME = 'Booking' 
  AND TABLE_SCHEMA = DATABASE()
ORDER BY PARTITION_ORDINAL_POSITION;

-- ========================================
-- SAMPLE DATA GENERATION (for testing)
-- ========================================

-- Generate sample bookings across different years
-- This helps test partition pruning effectiveness
DELIMITER //

CREATE PROCEDURE generate_sample_bookings(IN num_records INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE random_year INT;
    DECLARE random_month INT;
    DECLARE random_day INT;
    DECLARE sample_start_date DATE;
    
    WHILE i < num_records DO
        SET random_year = 2020 + FLOOR(RAND() * 7);  -- Years 2020-2026
        SET random_month = 1 + FLOOR(RAND() * 12);   -- Months 1-12
        SET random_day = 1 + FLOOR(RAND() * 28);     -- Days 1-28 (safe for all months)
        SET sample_start_date = DATE(CONCAT(random_year, '-', random_month, '-', random_day));
        
        INSERT IGNORE INTO Booking (
            booking_id,
            property_id,
            user_id,
            start_date,
            end_date,
            total_price,
            status,
            created_at
        ) VALUES (
            UUID(),
            (SELECT property_id FROM Property ORDER BY RAND() LIMIT 1),
            (SELECT user_id FROM User WHERE role = 'guest' ORDER BY RAND() LIMIT 1),
            sample_start_date,
            DATE_ADD(sample_start_date, INTERVAL (3 + FLOOR(RAND() * 10)) DAY),
            100 + (RAND() * 900),
            ELT(1 + FLOOR(RAND() * 3), 'pending', 'confirmed', 'canceled'),
            NOW()
        );
        
        SET i = i + 1;
    END WHILE;
END//

DELIMITER ;



-- ========================================
-- PERFORMANCE COMPARISON SCRIPT
-- ========================================


SET profiling = 1;

-- Run test queries
SELECT COUNT(*) FROM Booking WHERE start_date >= '2025-01-01' AND start_date < '2025-12-31';
SELECT COUNT(*) FROM Booking WHERE start_date >= '2024-01-01' AND start_date < '2024-12-31';
SELECT COUNT(*) FROM Booking WHERE YEAR(start_date) = 2025;

-- View profiling results
SHOW PROFILES;

-- Get detailed information for last query
SHOW PROFILE FOR QUERY 1;