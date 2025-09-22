---- ONLINE RETAIL SALES DATABASE ----
 -- Problem: A retail company wants to analyze customer purchases and improve sales strategy---
CREATE DATABASE OnlineRetailDB;
USE OnlineRetailDB;

-- Customers Table ---
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    region VARCHAR(50)
);

-- Products Table ---
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL
);

-- Orders Table---
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Sales Table (Order Details)---
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT CHECK (quantity > 0),
    total_amount DECIMAL(12,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Customers (customer_name, email, region) VALUES
('Alice Johnson', 'alice@example.com', 'North'),
('Bob Smith', 'bob@example.com', 'South'),
('Charlie Brown', 'charlie@example.com', 'East'),
('Diana Prince', 'diana@example.com', 'West'),
('Ethan Hunt', 'ethan@example.com', 'North'),
('Fiona Clark', 'fiona@example.com', 'South');

INSERT INTO Products (product_name, category, price) VALUES
('Laptop', 'Electronics', 800.00),
('Smartphone', 'Electronics', 600.00),
('Headphones', 'Electronics', 150.00),
('T-Shirt', 'Clothing', 25.00),
('Jeans', 'Clothing', 45.00),
('Sofa', 'Home & Kitchen', 1200.00),
('Microwave', 'Home & Kitchen', 300.00),
('Football', 'Sports', 50.00),
('Tennis Racket', 'Sports', 120.00);

INSERT INTO Orders (customer_id, order_date) VALUES
(1, '2024-01-15'),
(2, '2024-01-20'),
(3, '2024-02-05'),
(4, '2024-02-18'),
(5, '2024-03-10'),
(6, '2024-03-22'),
(1, '2024-04-01'),
(2, '2024-04-12'),
(3, '2024-05-03');

INSERT INTO Sales (order_id, product_id, quantity, total_amount) VALUES
(1, 1, 1, 800.00),   -- Alice buys Laptop
(1, 3, 2, 300.00),   -- Alice also buys 2 Headphones
(2, 2, 1, 600.00),   -- Bob buys Smartphone
(2, 4, 3, 75.00),    -- Bob buys 3 T-Shirts
(3, 5, 2, 90.00),    -- Charlie buys 2 Jeans
(3, 8, 1, 50.00),    -- Charlie buys Football
(4, 6, 1, 1200.00),  -- Diana buys Sofa
(5, 7, 1, 300.00),   -- Ethan buys Microwave
(6, 9, 2, 240.00),   -- Fiona buys 2 Tennis Rackets
(7, 2, 1, 600.00),   -- Alice buys Smartphone
(8, 4, 5, 125.00),   -- Bob buys 5 T-Shirts
(9, 1, 1, 800.00);   -- Charlie buys Laptop

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Sales;

--- Step 2: SQL Queries---
--- a) Top 5 Customers by Total Spending ---
SELECT c.customer_id, c.customer_name, SUM(s.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Sales s ON o.order_id = s.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

--- b) Best-Selling Products---
SELECT p.product_id, p.product_name, SUM(s.quantity) AS total_sold
FROM Products p
JOIN Sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 5;

--- c) Monthly Revenue Trend ---
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month, 
       SUM(s.total_amount) AS monthly_revenue
FROM Orders o
JOIN Sales s ON o.order_id = s.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

--- Step 3: GROUP BY + HAVING (Customers who bought > 5 products) ---
SELECT c.customer_id, c.customer_name, COUNT(DISTINCT s.product_id) AS products_bought
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Sales s ON o.order_id = s.order_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT s.product_id) > 5;

--- Step 4: JOIN Example (Combine Order, Customer, Product Details) ---
SELECT o.order_id, o.order_date, c.customer_name, p.product_name, s.quantity, s.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Sales s ON o.order_id = s.order_id
JOIN Products p ON s.product_id = p.product_id
ORDER BY o.order_date DESC;

---- Step 5: Create a View (Daily Sales Summary) ---
CREATE VIEW Daily_Sales_Summary AS
SELECT o.order_date, 
       SUM(s.total_amount) AS total_sales,
       COUNT(DISTINCT o.order_id) AS total_orders
FROM Orders o
JOIN Sales s ON o.order_id = s.order_id
GROUP BY o.order_date
ORDER BY o.order_date;

SELECT * FROM Daily_Sales_Summary;

