-- Create database
CREATE DATABASE hostel_management_system;

-- Select database
USE hostel_management_system;

-- Create users table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL
);

-- Create students table
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    student_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    phone VARCHAR(15),
    email VARCHAR(100),
    course VARCHAR(100),
    year INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create rooms table
CREATE TABLE rooms (6
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(20) NOT NULL UNIQUE,
    room_type VARCHAR(30),
    capacity INT NOT NULL,
    occupied_count INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'Available'
);

-- Create room allocations table
CREATE TABLE room_allocations (
    allocation_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    room_id INT NOT NULL,
    allocation_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- Create complaints table
CREATE TABLE complaints (
    complaint_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    complaint_text VARCHAR(500) NOT NULL,
    complaint_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Create payments table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Insert users
INSERT INTO users (username, password, role)
VALUES
('admin', 'admin123', 'Admin'),
('charanya', 'student123', 'Student'),
('varsha', 'student123', 'Student'),
('harshitha', 'student123', 'Student');

-- Insert students
INSERT INTO students
(user_id, student_name, gender, phone, email, course, year)
VALUES
(2, 'Charanya', 'Female', '9876543210', 'charanya@gmail.com', 'B.Tech CSE', 4),
(3, 'Varsha', 'Female', '9876543211', 'varsha@gmail.com', 'B.Tech CSE', 3),
(4, 'Harshitha', 'Female', '9876543212', 'harshitha@gmail.com', 'B.Tech CSE', 4);

-- Insert rooms
INSERT INTO rooms
(room_number, room_type, capacity, occupied_count, status)
VALUES
('101', '2 Sharing', 2, 1, 'Available'),
('102', '4 Sharing', 4, 1, 'Available'),
('103', '2 Sharing', 2, 0, 'Available'),
('104', '4 Sharing', 4, 4, 'Full');

-- Insert room allocations
INSERT INTO room_allocations
(student_id, room_id, allocation_date)
VALUES
(1, 1, '2026-09-18'),
(2, 2, '2026-09-18'),
(3, 4, '2026-09-19');

-- Insert complaints
INSERT INTO complaints
(student_id, complaint_text, complaint_date, status)
VALUES
(1, 'Water problem in the room', '2026-09-18', 'Pending'),
(2, 'Fan is not working', '2026-09-19', 'Resolved'),
(3, 'WiFi is not working', '2026-09-19', 'Pending');

-- Insert payments
INSERT INTO payments
(student_id, amount, payment_date, payment_status)
VALUES
(1, 50000.00, '2026-09-18', 'Paid'),
(2, 50000.00, '2026-09-18', 'Pending'),
(3, 50000.00, '2026-09-19', 'Paid');

-- Query 1: Display all students
SELECT * FROM students;

-- Query 2: Display all rooms
SELECT * FROM rooms;

-- Query 3: Find available rooms
SELECT *
FROM rooms
WHERE status = 'Available';


-- Query 4: Update room status
UPDATE rooms
SET status = 'Full'
WHERE room_id = 4;

-- Query 5: Display students with their login usernames
SELECT
    s.student_name,
    u.username,
    u.role
FROM students s
JOIN users u ON s.user_id = u.user_id;

-- Query 6: Display students with their room numbers
SELECT
    s.student_name,
    r.room_number,
    r.room_type,
    ra.allocation_date
FROM room_allocations ra
JOIN students s ON ra.student_id = s.student_id
JOIN rooms r ON ra.room_id = r.room_id;

-- Query 7: Display student complaints
SELECT
    s.student_name,
    c.complaint_text,
    c.complaint_date,
    c.status
FROM complaints c
JOIN students s ON c.student_id = s.student_id;

-- Query 8: Display student payment details
SELECT
    s.student_name,
    p.amount,
    p.payment_date,
    p.payment_status
FROM payments p
JOIN students s ON p.student_id = s.student_id;

-- Query 9: Count total students
SELECT COUNT(*) AS total_students
FROM students;

-- Query 10: Count total rooms
SELECT COUNT(*) AS total_rooms
FROM rooms;

-- Query 11: Calculate total payment amount
SELECT SUM(amount) AS total_payment
FROM payments;

-- Query 12: Calculate average payment
SELECT AVG(amount) AS average_payment
FROM payments;

-- Query 13: Find maximum payment
SELECT MAX(amount) AS maximum_payment
FROM payments;

-- Query 14: Count complaints by status
SELECT
    status,
    COUNT(*) AS complaint_count
FROM complaints
GROUP BY status;

-- Query 15: Count students by course
SELECT
    course,
    COUNT(*) AS student_count
FROM students
GROUP BY course;

-- Query 16: Find rooms having available space
SELECT
    room_number,
    capacity,
    occupied_count,
    capacity - occupied_count AS available_spaces
FROM rooms
WHERE occupied_count < capacity;

-- Query 17: Find students who have complaints
SELECT student_name
FROM students
WHERE student_id IN (
    SELECT student_id
    FROM complaints
);

-- Query 18: Find students who have pending payments
SELECT student_name
FROM students
WHERE student_id IN (
    SELECT student_id
    FROM payments
    WHERE payment_status = 'Pending'
);

-- Query 19: Find rooms with occupancy greater than average occupancy
SELECT
    room_number,
    occupied_count
FROM rooms
WHERE occupied_count > (
    SELECT AVG(occupied_count)
    FROM rooms
);

-- Query 20: Create a view for student room details
CREATE VIEW student_room_details AS
SELECT
    s.student_id,
    s.student_name,
    s.course,
    r.room_number,
    r.room_type,
    ra.allocation_date
FROM room_allocations ra
JOIN students s ON ra.student_id = s.student_id
JOIN rooms r ON ra.room_id = r.room_id;

-- Display the view
SELECT * FROM student_room_details;

-- Query 21: Create a view for pending complaints
CREATE VIEW pending_complaints AS
SELECT
    s.student_name,
    c.complaint_text,
    c.complaint_date
FROM complaints c
JOIN students s ON c.student_id = s.student_id
WHERE c.status = 'Pending';

-- Display pending complaints
SELECT * FROM pending_complaints;

-- Query 22: Create index on student name
CREATE INDEX idx_student_name
ON students(student_name);

-- Query 23: Create index on room number
CREATE INDEX idx_room_number
ON rooms(room_number);

-- Query 24: Display indexes
SHOW INDEX FROM students;

SHOW INDEX FROM rooms;

-- Query 25: Create stored procedure to display available rooms
DELIMITER //

CREATE PROCEDURE GetAvailableRooms()
BEGIN
    SELECT
        room_number,
        room_type,
        capacity,
        occupied_count
    FROM rooms
    WHERE occupied_count < capacity;
END //

DELIMITER ;

-- Execute stored procedure
CALL GetAvailableRooms();

-- Query 26: Create stored procedure to find student payments
DELIMITER //

CREATE PROCEDURE GetStudentPayments(IN studentId INT)
BEGIN
    SELECT
        s.student_name,
        p.amount,
        p.payment_date,
        p.payment_status
    FROM payments p
    JOIN students s ON p.student_id = s.student_id
    WHERE p.student_id = studentId;
END //

DELIMITER ;

-- Execute stored procedure
CALL GetStudentPayments(1);

-- Query 27: Create trigger to increase room occupancy
DELIMITER //

CREATE TRIGGER after_room_allocation
AFTER INSERT ON room_allocations
FOR EACH ROW
BEGIN
    UPDATE rooms
    SET occupied_count = occupied_count + 1
    WHERE room_id = NEW.room_id;
END //

DELIMITER ;

-- Query 28: Create trigger to decrease room occupancy
DELIMITER //

CREATE TRIGGER after_room_deallocation
AFTER DELETE ON room_allocations
FOR EACH ROW
BEGIN
    UPDATE rooms
    SET occupied_count = occupied_count - 1
    WHERE room_id = OLD.room_id;
END //

DELIMITER ;

-- Query 29: Update complaint status
UPDATE complaints
SET status = 'Resolved'
WHERE complaint_id = 1;

-- Query 30: Find students with pending complaints and pending payments
SELECT
    s.student_name,
    c.complaint_text,
    p.amount
FROM students s
JOIN complaints c ON s.student_id = c.student_id
JOIN payments p ON s.student_id = p.student_id
WHERE c.status = 'Pending'
AND p.payment_status = 'Pending';