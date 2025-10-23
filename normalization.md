# StayBackend DB Normalization check

In order to ensure data integrity and remove redundancy, verified my database schema to ensure that it satisfied the:

## First Normal Form (1NF):

- As you'll observe, each column in the tables contains atomic values.
- You'll also observe that each row in the tables have unique identifiers called the Primary Key

## Second Normal Form (2NF):

- You'll observe in my ERD that each non-key column in the tables are solely dependent on the primary key. there are no partial dependencies since there are no composite keys but solely primary keys.

## Third Normal Form (3NF):

- You'll observe that there are no transitive depencies between non-key columns and their primary key.

Therefore my ERD satisfies all the Normal form requirements and is therefore not at risk of data reduncies or loss if integrity or anomalies.
