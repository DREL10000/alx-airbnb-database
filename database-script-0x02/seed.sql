-- =====================================================
-- SAMPLE DATA FOR AIRBNB DATABASE
-- =====================================================

-- Clear existing data (useful for testing - be careful in production!)
TRUNCATE TABLE Message, Review, Payment, Booking, Property, "User" CASCADE;

-- =====================================================
-- 1. INSERT USERS
-- =====================================================
-- Mix of guests, hosts, and admins

INSERT INTO "User" (user_id, first_name, last_name, email, password_hash, phone_number, role) VALUES
-- Hosts
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Alice', 'Johnson', 'alice.johnson@example.com', '$2a$10$abcdefghijklmnopqrstuv', '+1234567890', 'host'),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'Bob', 'Smith', 'bob.smith@example.com', '$2a$10$bcdefghijklmnopqrstuvw', '+1234567891', 'host'),
('c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'Carol', 'Williams', 'carol.williams@example.com', '$2a$10$cdefghijklmnopqrstuvwx', '+1234567892', 'host'),

-- Guests
('d3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'David', 'Brown', 'david.brown@example.com', '$2a$10$defghijklmnopqrstuvwxy', '+1234567893', 'guest'),
('e4eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'Emma', 'Davis', 'emma.davis@example.com', '$2a$10$efghijklmnopqrstuvwxyz', '+1234567894', 'guest'),
('f5eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 'Frank', 'Miller', 'frank.miller@example.com', '$2a$10$fghijklmnopqrstuvwxyza', '+1234567895', 'guest'),
('a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', 'Grace', 'Wilson', 'grace.wilson@example.com', '$2a$10$ghijklmnopqrstuvwxyzab', NULL, 'guest'),

-- Admin
('b7eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', 'Henry', 'Moore', 'henry.moore@example.com', '$2a$10$hijklmnopqrstuvwxyzabc', '+1234567896', 'admin');

-- Note: password_hash values are examples of bcrypt hashed passwords
-- In real application, these would be actual hashed passwords


-- =====================================================
-- 2. INSERT PROPERTIES
-- =====================================================
-- Various properties in different locations

INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at) VALUES
-- Alice's Properties
('10eebc99-9c0b-4ef8-bb6d-6bb9bd380a21', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 
 'Cozy Downtown Apartment', 
 'A beautiful 2-bedroom apartment in the heart of downtown. Perfect for business travelers and tourists alike. Walking distance to major attractions, restaurants, and shopping centers. Features modern amenities, high-speed WiFi, and a fully equipped kitchen.',
 'New York, NY', 
 150.00, 
 '2024-01-15 10:00:00', 
 '2024-01-15 10:00:00'),

('11eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 
 'Beach House Paradise', 
 'Stunning 4-bedroom beach house with direct ocean access. Wake up to breathtaking sunrise views, enjoy private beach access, and relax on the spacious deck. Perfect for families and groups seeking a memorable coastal getaway.',
 'Miami, FL', 
 350.00, 
 '2024-02-01 14:30:00', 
 '2024-02-01 14:30:00'),

-- Bob's Properties
('12eebc99-9c0b-4ef8-bb6d-6bb9bd380a23', 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 
 'Mountain Cabin Retreat', 
 'Rustic yet comfortable 3-bedroom cabin nestled in the mountains. Features a stone fireplace, hot tub, and panoramic mountain views. Ideal for hiking enthusiasts, winter sports lovers, or anyone seeking peace and tranquility in nature.',
 'Aspen, CO', 
 275.00, 
 '2024-01-20 09:15:00', 
 '2024-03-10 16:20:00'),

('13eebc99-9c0b-4ef8-bb6d-6bb9bd380a24', 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 
 'Urban Loft Studio', 
 'Modern studio loft in trendy neighborhood. Exposed brick walls, high ceilings, and industrial-chic design. Perfect for solo travelers or couples. Close to art galleries, coffee shops, and nightlife.',
 'Portland, OR', 
 95.00, 
 '2024-02-10 11:00:00', 
 '2024-02-10 11:00:00'),

-- Carol's Properties
('14eebc99-9c0b-4ef8-bb6d-6bb9bd380a25', 'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 
 'Luxury Penthouse Suite', 
 'Exclusive 5-bedroom penthouse with 360-degree city views. Features include a private rooftop terrace, infinity pool, chef\'s kitchen, home theater, and concierge service. The ultimate luxury experience for discerning guests.',
 'Los Angeles, CA', 
 850.00, 
 '2024-01-05 08:00:00', 
 '2024-01-05 08:00:00'),

('15eebc99-9c0b-4ef8-bb6d-6bb9bd380a26', 'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 
 'Charming Cottage Garden', 
 'Quaint 2-bedroom cottage surrounded by beautiful English gardens. Features vintage decor, a cozy reading nook, and a sunny breakfast room. Perfect for romantic getaways or peaceful solo retreats.',
 'Charleston, SC', 
 125.00, 
 '2024-02-20 13:45:00', 
 '2024-02-20 13:45:00');


-- =====================================================
-- 3. INSERT BOOKINGS
-- =====================================================
-- Mix of confirmed, pending, and canceled bookings

INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
-- David's Bookings
('20eebc99-9c0b-4ef8-bb6d-6bb9bd380a31', '10eebc99-9c0b-4ef8-bb6d-6bb9bd380a21', 'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14',
 '2024-03-15', '2024-03-20', 750.00, 'confirmed', '2024-02-15 10:30:00'),

('21eebc99-9c0b-4ef8-bb6d-6bb9bd380a32', '12eebc99-9c0b-4ef8-bb6d-6bb9bd380a23', 'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14',
 '2024-12-20', '2024-12-27', 1925.00, 'confirmed', '2024-10-01 14:20:00'),

-- Emma's Bookings
('22eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', '11eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'e4eebc99-9c0b-4ef8-bb6d-6bb9bd380a15',
 '2024-07-01', '2024-07-10', 3150.00, 'confirmed', '2024-05-10 09:00:00'),

('23eebc99-9c0b-4ef8-bb6d-6bb9bd380a34', '13eebc99-9c0b-4ef8-bb6d-6bb9bd380a24', 'e4eebc99-9c0b-4ef8-bb6d-6bb9bd380a15',
 '2024-11-15', '2024-11-18', 285.00, 'pending', '2024-10-20 16:45:00'),

-- Frank's Bookings
('24eebc99-9c0b-4ef8-bb6d-6bb9bd380a35', '14eebc99-9c0b-4ef8-bb6d-6bb9bd380a25', 'f5eebc99-9c0b-4ef8-bb6d-6bb9bd380a16',
 '2024-06-10', '2024-06-15', 4250.00, 'confirmed', '2024-04-15 11:30:00'),

('25eebc99-9c0b-4ef8-bb6d-6bb9bd380a36', '10eebc99-9c0b-4ef8-bb6d-6bb9bd380a21', 'f5eebc99-9c0b-4ef8-bb6d-6bb9bd380a16',
 '2024-09-05', '2024-09-08', 450.00, 'canceled', '2024-08-01 13:15:00'),

-- Grace's Bookings
('26eebc99-9c0b-4ef8-bb6d-6bb9bd380a37', '15eebc99-9c0b-4ef8-bb6d-6bb9bd380a26', 'a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17',
 '2024-05-01', '2024-05-05', 500.00, 'confirmed', '2024-03-20 15:00:00'),

('27eebc99-9c0b-4ef8-bb6d-6bb9bd380a38', '12eebc99-9c0b-4ef8-bb6d-6bb9bd380a23', 'a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17',
 '2024-10-10', '2024-10-14', 1100.00, 'confirmed', '2024-09-01 10:00:00'),

-- Additional bookings to show variety
('28eebc99-9c0b-4ef8-bb6d-6bb9bd380a39', '13eebc99-9c0b-4ef8-bb6d-6bb9bd380a24', 'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14',
 '2024-04-01', '2024-04-03', 190.00, 'confirmed', '2024-03-01 12:00:00'),

('29eebc99-9c0b-4ef8-bb6d-6bb9bd380a40', '11eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'f5eebc99-9c0b-4ef8-bb6d-6bb9bd380a16',
 '2024-08-15', '2024-08-22', 2450.00, 'canceled', '2024-07-01 09:30:00');


-- =====================================================
-- 4. INSERT PAYMENTS
-- =====================================================
-- Payments for confirmed bookings only

INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
-- Payments for confirmed bookings
('30eebc99-9c0b-4ef8-bb6d-6bb9bd380a41', '20eebc99-9c0b-4ef8-bb6d-6bb9bd380a31', 
 750.00, '2024-02-15 10:35:00', 'credit_card'),

('31eebc99-9c0b-4ef8-bb6d-6bb9bd380a42', '21eebc99-9c0b-4ef8-bb6d-6bb9bd380a32', 
 1925.00, '2024-10-01 14:25:00', 'paypal'),

('32eebc99-9c0b-4ef8-bb6d-6bb9bd380a43', '22eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 
 3150.00, '2024-05-10 09:05:00', 'stripe'),

('33eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', '24eebc99-9c0b-4ef8-bb6d-6bb9bd380a35', 
 4250.00, '2024-04-15 11:35:00', 'credit_card'),

('34eebc99-9c0b-4ef8-bb6d-6bb9bd380a45', '26eebc99-9c0b-4ef8-bb6d-6bb9bd380a37', 
 500.00, '2024-03-20 15:05:00', 'paypal'),

('35eebc99-9c0b-4ef8-bb6d-6bb9bd380a46', '27eebc99-9c0b-4ef8-bb6d-6bb9bd380a38', 
 1100.00, '2024-09-01 10:05:00', 'stripe'),

('36eebc99-9c0b-4ef8-bb6d-6bb9bd380a47', '28eebc99-9c0b-4ef8-bb6d-6bb9bd380a39', 
 190.00, '2024-03-01 12:05:00', 'credit_card');

-- Note: No payments for pending or canceled bookings


-- =====================================================
-- 5. INSERT REVIEWS
-- =====================================================
-- Reviews for completed stays only

INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at) VALUES
-- David's Reviews
('40eebc99-9c0b-4ef8-bb6d-6bb9bd380a51', '10eebc99-9c0b-4ef8-bb6d-6bb9bd380a21', 'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14',
 5, 'Absolutely loved this apartment! The location was perfect - walked everywhere. Alice was a wonderful host, very responsive and helpful. The place was spotless and exactly as described. Would definitely stay again!',
 '2024-03-21 14:30:00'),

('41eebc99-9c0b-4ef8-bb6d-6bb9bd380a52', '13eebc99-9c0b-4ef8-bb6d-6bb9bd380a24', 'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14',
 4, 'Great little studio in a fun neighborhood. The exposed brick and high ceilings were beautiful. Only minor issue was some street noise at night, but overall a wonderful stay.',
 '2024-04-04 10:15:00'),

-- Emma's Reviews
('42eebc99-9c0b-4ef8-bb6d-6bb9bd380a53', '11eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'e4eebc99-9c0b-4ef8-bb6d-6bb9bd380a15',
 5, 'This beach house exceeded all expectations! Waking up to ocean views every morning was magical. The house had everything we needed for a family vacation. Direct beach access was incredible. Thank you, Alice!',
 '2024-07-11 09:00:00'),

-- Frank's Reviews
('43eebc99-9c0b-4ef8-bb6d-6bb9bd380a54', '14eebc99-9c0b-4ef8-bb6d-6bb9bd380a25', 'f5eebc99-9c0b-4ef8-bb6d-6bb9bd380a16',
 5, 'Pure luxury! The penthouse was stunning - rooftop pool, incredible views, top-notch amenities. Carol thought of everything. Perfect for our anniversary celebration. Worth every penny!',
 '2024-06-16 16:20:00'),

-- Grace's Reviews
('44eebc99-9c0b-4ef8-bb6d-6bb9bd380a55', '15eebc99-9c0b-4ef8-bb6d-6bb9bd380a26', 'a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17',
 5, 'The most charming cottage! The garden was absolutely beautiful, and the interior was cozy and romantic. Perfect for a peaceful getaway. Carol is a wonderful host. Highly recommend!',
 '2024-05-06 11:00:00'),

('45eebc99-9c0b-4ef8-bb6d-6bb9bd380a56', '12eebc99-9c0b-4ef8-bb6d-6bb9bd380a23', 'a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17',
 4, 'Beautiful mountain cabin with amazing views. The hot tub was perfect after a day of hiking. Only issue was the Wi-Fi was a bit slow, but that added to the unplugged experience. Would return!',
 '2024-10-15 13:45:00'),

-- Additional reviews
('46eebc99-9c0b-4ef8-bb6d-6bb9bd380a57', '10eebc99-9c0b-4ef8-bb6d-6bb9bd380a21', 'e4eebc99-9c0b-4ef8-bb6d-6bb9bd380a15',
 3, 'Decent apartment, good location. However, there were some maintenance issues - the bathroom faucet was leaking and the WiFi kept dropping. Alice did respond quickly when we reported it. Good value for the price.',
 '2024-02-10 15:30:00'),

('47eebc99-9c0b-4ef8-bb6d-6bb9bd380a58', '12eebc99-9c0b-4ef8-bb6d-6bb9bd380a23', 'f5eebc99-9c0b-4ef8-bb6d-6bb9bd380a16',
 5, 'Amazing mountain retreat! The cabin was well-equipped, clean, and cozy. Bob was an excellent host. The fireplace and mountain views made for a perfect winter getaway.',
 '2024-01-15 12:00:00');


-- =====================================================
-- 6. INSERT MESSAGES
-- =====================================================
-- Communication between guests and hosts

INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
-- David and Alice conversation about Downtown Apartment
('50eebc99-9c0b-4ef8-bb6d-6bb9bd380a61', 'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
 'Hi Alice, I''m interested in booking your downtown apartment for March 15-20. Is it available? Also, is there parking available?',
 '2024-02-14 09:00:00'),

('51eebc99-9c0b-4ef8-bb6d-6bb9bd380a62', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14',
 'Hi David! Yes, the apartment is available for those dates. There is street parking available, and I can provide a parking permit. Would you like to proceed with the booking?',
 '2024-02-14 10:30:00'),

('52eebc99-9c0b-4ef8-bb6d-6bb9bd380a63', 'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
 'Perfect! I''ll book it now. What''s the check-in process?',
 '2024-02-14 11:00:00'),

('53eebc99-9c0b-4ef8-bb6d-6bb9bd380a64', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14',
 'Great! Check-in is after 3 PM. I''ll send you the door code and detailed instructions a day before your arrival. Looking forward to hosting you!',
 '2024-02-14 11:15:00'),

-- Emma and Alice conversation about Beach House
('54eebc99-9c0b-4ef8-bb6d-6bb9bd380a65', 'e4eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
 'Hi! Your beach house looks amazing. We''re a family of 6 - will that work? Also, are pets allowed?',
 '2024-05-08 14:20:00'),

('55eebc99-9c0b-4ef8-bb6d-6bb9bd380a66', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'e4eebc99-9c0b-4ef8-bb6d-6bb9bd380a15',
 'Hello Emma! Yes, the house comfortably sleeps 8, so 6 will be perfect. Unfortunately, we don''t allow pets. The house has 4 bedrooms and 3 bathrooms. Let me know if you have any other questions!',
 '2024-05-08 16:00:00'),

-- Frank and Carol conversation about Penthouse
('56eebc99-9c0b-4ef8-bb6d-6bb9bd380a67', 'f5eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a13',
 'Hi Carol, I want to book the penthouse for my anniversary. Can you arrange anything special like flowers or champagne?',
 '2024-04-10 10:00:00'),

('57eebc99-9c0b-4ef8-bb6d-6bb9bd380a68', 'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'f5eebc99-9c0b-4ef8-bb6d-6bb9bd380a16',
 'Absolutely! I''d be happy to help make your anniversary special. I can arrange for rose petals, champagne, and chocolates. There''s an additional $150 fee for this service. Would you like me to arrange it?',
 '2024-04-10 12:00:00'),

('58eebc99-9c0b-4ef8-bb6d-6bb9bd380a69', 'f5eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a13',
 'That sounds perfect! Yes, please arrange it. This will make it unforgettable. Thank you!',
 '2024-04-10 13:30:00'),

-- Grace and Bob conversation about Mountain Cabin
('59eebc99-9c0b-4ef8-bb6d-6bb9bd380a70', 'a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12',
 'Hi Bob, what''s the best time to visit for fall foliage? I''m planning a trip in October.',
 '2024-08-15 11:00:00'),

('60eebc99-9c0b-4ef8-bb6d-6bb9bd380a71', 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17',
 'Hi Grace! Mid-October is peak foliage season here. The aspens turn brilliant gold and the scenery is breathtaking. I''d recommend October 10-14 for the best colors. Book soon as it''s a popular time!',
 '2024-08-15 14:30:00'),

-- David and Bob conversation
('61eebc99-9c0b-4ef8-bb6d-6bb9bd380a72', 'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12',
 'Hi Bob, I''m booking your cabin for Christmas week. Do you provide firewood, or should we bring our own?',
 '2024-09-25 16:00:00'),

('62eebc99-9c0b-4ef8-bb6d-6bb9bd380a73', 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14',
 'Hi David! We provide a starter bundle of firewood. Additional firewood can be purchased locally - I''ll send you information about nearby suppliers. The cabin also has central heating, so you''ll be warm and cozy!',
 '2024-09-25 18:00:00');