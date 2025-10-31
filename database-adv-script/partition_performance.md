# Table Partitioning Performance Report

## Implementation Overview

I implemented RANGE partitioning on the Booking table using the start_date column. The table was partitioned by year to improve query performance for date-based searches.

## Approach

The Booking table was recreated with partitions for each year (2020-2026, plus a future partition). I used RANGE partitioning because most queries filter bookings by date ranges, so this seemed like a logical choice.

I had to modify the primary key to include start_date alongside booking_id, since MySQL requires the partition key to be part of the primary key.

## Performance Testing

I tested several common queries to compare performance:

**Query 1: Date range filter**

```sql
SELECT * FROM Booking
WHERE start_date >= '2025-01-01' AND start_date < '2025-12-31';
```

With partitioning, the database only scanned one partition instead of the entire table. The query ran noticeably faster.

**Query 2: Recent bookings**

```sql
SELECT * FROM Booking
WHERE start_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);
```

Similar improvement - only the current year's partition was accessed.

**Query 3: Yearly aggregations**

```sql
SELECT YEAR(start_date), COUNT(*), SUM(total_price)
FROM Booking
GROUP BY YEAR(start_date);
```

This query benefited from partition-aware processing.

## Results

The main improvement I noticed was that queries with date filters executed faster because the database uses something called "partition pruning" - it only looks at relevant partitions instead of scanning the whole table.

Other benefits:

- Maintenance operations (like rebuilding indexes) can be done on individual partitions
- Old data can be archived by simply dropping old partitions
- The table feels more organized and manageable

## Challenges

- Had to change the primary key structure to include start_date
- Foreign keys needed to be added after creating the table
- Queries without date filters don't benefit as much from partitioning

## Conclusion

Partitioning improved performance for the most common query patterns on the Booking table. Since bookings are naturally organized by date and most searches filter by date ranges, this optimization makes sense for this use case.
