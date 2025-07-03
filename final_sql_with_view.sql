
-- Drop existing tables if they exist
DROP TABLE Payments CASCADE CONSTRAINTS;
DROP TABLE Orders CASCADE CONSTRAINTS;
DROP TABLE Customers CASCADE CONSTRAINTS;

-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Create Payments table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Insert Customers
INSERT INTO Customers VALUES (1, 'Alice', 'Mumbai');
INSERT INTO Customers VALUES (2, 'Bob', 'Pune');
INSERT INTO Customers VALUES (3, 'Charlie', 'Delhi');

-- Insert Orders
INSERT INTO Orders VALUES (101, 1, DATE '2024-01-10', 5000.00);
INSERT INTO Orders VALUES (102, 2, DATE '2024-02-15', 3000.00);
INSERT INTO Orders VALUES (103, 1, DATE '2024-03-05', 4500.00);

-- Insert Payments
INSERT INTO Payments VALUES (1001, 101, DATE '2024-01-12', 5000.00);
INSERT INTO Payments VALUES (1002, 102, DATE '2024-02-18', 3000.00);
INSERT INTO Payments VALUES (1003, 103, DATE '2024-03-08', 2000.00);

-- Basic Queries

-- 1. Show all customers
SELECT * FROM Customers;

-- 2. Orders with amount > 4000
SELECT * FROM Orders WHERE amount > 4000;

-- 3. Distinct cities
SELECT DISTINCT city FROM Customers;

-- 4. Names of customers who placed orders
SELECT c.name FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id;

-- 5. Orders with partial payments
SELECT o.order_id FROM Orders o JOIN Payments p ON o.order_id = p.order_id WHERE p.payment_amount < o.amount;

-- 6. Unpaid orders
SELECT * FROM Orders o LEFT JOIN Payments p ON o.order_id = p.order_id WHERE p.payment_id IS NULL;

-- 7. Count total payments per customer
SELECT
    c.customer_id,
    c.name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(p.payment_amount) AS total_payment
FROM
    Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN Payments p ON o.order_id = p.order_id
GROUP BY
    c.customer_id, c.name;

-- 8. Customers from Pune with orders
SELECT DISTINCT c.name FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id WHERE c.city = 'Pune';

-- 9. Total order amount per customer
SELECT
    c.customer_id,
    c.name,
    SUM(o.amount) AS total_order_amount
FROM
    Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id, c.name;

-- 10. Customers with more than one order
SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders
FROM
    Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id, c.name
HAVING
    COUNT(o.order_id) > 1;

-- --------------------------------------------
-- Additional: Create a view with complex SELECT
-- --------------------------------------------

CREATE VIEW CustomerOrderSummary AS
SELECT
    c.customer_id,
    c.name,
    o.order_id,
    o.amount AS order_amount,
    p.payment_amount
FROM
    Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    LEFT JOIN Payments p ON o.order_id = p.order_id;

-- Example: Use the view
SELECT * FROM CustomerOrderSummary;

-- Example: Find partial payments using the view
SELECT * FROM CustomerOrderSummary WHERE payment_amount < order_amount;

-- Example: Find unpaid orders using the view
SELECT * FROM CustomerOrderSummary WHERE payment_amount IS NULL;
