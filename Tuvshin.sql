-- create schema shalgalt
-- 1
-- CREATE TABLE Products (
--     product_id INT AUTO_INCREMENT PRIMARY KEY,
--     name VARCHAR(100),
--     price DECIMAL(10, 2),
--     category VARCHAR(50),
--     stock_quantity INT
-- );

-- CREATE TABLE Users (
--     user_id INT AUTO_INCREMENT PRIMARY KEY,
--     name VARCHAR(100),
--     email VARCHAR(100),
--     phone_number VARCHAR(20)
-- );

-- CREATE TABLE Orders (
--     order_id INT AUTO_INCREMENT PRIMARY KEY,
--     user_id INT,
--     order_date DATE,
--     total_price DECIMAL(10, 2),
--     FOREIGN KEY (user_id) REFERENCES Users(user_id)
-- );

-- CREATE TABLE Order_Details (
--     order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
--     order_id INT,
--     product_id INT,
--     quantity INT,
--     FOREIGN KEY (order_id) REFERENCES Orders(order_id),
--     FOREIGN KEY (product_id) REFERENCES Products(product_id)
-- );
-- 2
-- Products хүснэгтэд 5 бүтээгдэхүүн оруулах
-- INSERT INTO Products (name, price, category, stock_quantity) VALUES
-- ('Apple', 100.00, 'Fruit', 50),
-- ('Laptop', 1000.00, 'Electronics', 30),
-- ('Shoes', 50.00, 'Clothing', 100),
-- ('Coffee Mug', 15.00, 'Kitchenware', 200),
-- ('Book', 20.00, 'Books', 300);

-- -- Users хүснэгтэд 3 хэрэглэгч оруулах
-- INSERT INTO Users (name, email, phone_number) VALUES
-- ('John Doe', 'johndoe@gmail.com', '1234567890'),
-- ('Jane Smith', 'janesmith@yahoo.com', '9876543210'),
-- ('Alice Johnson', 'alicejohnson@gmail.com', '1122334455');

-- -- Orders хүснэгтэд 1 захиалга үүсгэж
-- INSERT INTO Orders (user_id, order_date, total_price) VALUES
-- (1, '2024-12-06', 115.00);

-- -- Order_Details хүснэгтэд тухайн захиалгын 2 бараа оруулах
-- INSERT INTO Order_Details (order_id, product_id, quantity) VALUES
-- (1, 1, 2),
-- (1, 4, 1);
-- 3.1
-- SELECT name, price FROM Products;
-- 3.2
-- SELECT p.name AS product_name, p.price, od.quantity, (od.quantity * p.price) AS total_price
-- FROM Order_Details od
-- JOIN Products p ON od.product_id = p.product_id;
-- 3.3
-- SELECT u.name, COUNT(o.order_id) AS total_orders, SUM(o.total_price) AS total_spent
-- FROM Users u
-- JOIN Orders o ON u.user_id = o.user_id
-- GROUP BY u.name;
-- 4
-- CREATE VIEW order_summary AS
-- SELECT o.order_id, u.name AS user_name, o.order_date, p.name AS product_name, od.quantity, (od.quantity * p.price) AS total_price
-- FROM Orders o
-- JOIN Users u ON o.user_id = u.user_id
-- JOIN Order_Details od ON o.order_id = od.order_id
-- JOIN Products p ON od.product_id = p.product_id;
-- 5.1
-- UPDATE Products
-- SET stock_quantity = stock_quantity - 1
-- WHERE product_id = 1;
-- 5.2
-- DELETE FROM Order_Details
-- WHERE order_detail_id = 1;
-- 6
-- CREATE TABLE Suppliers (
--     supplier_id INT AUTO_INCREMENT PRIMARY KEY,
--     name VARCHAR(100),
--     contact_email VARCHAR(100),
--     phone_number VARCHAR(20)
-- );


-- ALTER TABLE Products
-- ADD COLUMN supplier_id INT,
-- ADD FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id);
-- 7
-- CREATE OR REPLACE VIEW supplier_product_summary AS
-- SELECT s.name AS supplier_name, p.product_id, p.name AS product_name, p.category AS product_category
-- FROM Suppliers s
-- JOIN Products p ON s.supplier_id = p.supplier_id;
-- 7.1
-- SELECT supplier_name, COUNT(product_id) AS total_products
-- FROM supplier_product_summary
-- GROUP BY supplier_name;
-- 7.2
-- SELECT product_category, supplier_name, COUNT(product_id) AS number_of_suppliers
-- FROM supplier_product_summary
-- GROUP BY product_category, supplier_name;
-- 8
-- DELETE FROM Products
-- WHERE stock_quantity = 0;
-- 9
-- SELECT * FROM Products
-- WHERE price >= 100;
-- 9.1
-- SELECT * FROM Users
-- WHERE email LIKE '%@gmail.com';
-- 10
-- SELECT name
-- FROM Users
-- WHERE user_id = (
--     SELECT user_id
--     FROM Orders
--     JOIN Order_Details ON Orders.order_id = Order_Details.order_id
--     GROUP BY Orders.user_id
--     ORDER BY SUM(Order_Details.quantity) DESC
--     LIMIT 1
-- );
-- 10.1
-- SELECT product_category
-- FROM Products
-- WHERE product_id IN (
--     SELECT product_id
--     FROM Order_Details
--     GROUP BY product_id
--     ORDER BY SUM(quantity) DESC
--     LIMIT 1
-- );
-- 11
...-- ALTER TABLE Products
-- ADD CONSTRAINT price_check CHECK (price >= 10);
-- 12 
-- SELECT u.name, Orders.order_date, SUM(Order_Details.quantity) AS total_products
-- FROM Users u
-- JOIN Orders ON u.user_id = Orders.user_id
-- JOIN Order_Details ON Orders.order_id = Order_Details.order_id
-- GROUP BY u.name, Orders.order_date
-- ORDER BY Orders.order_date;

-- 13
-- CREATE TABLE Product_Summary AS
-- SELECT category, SUM(stock_quantity) AS total_quantity
-- FROM Products
-- GROUP BY category;
-- 14.1
-- SELECT name, MAX(order_date) AS last_order_date
-- FROM Users
-- JOIN Orders ON Users.user_id = Orders.user_id
-- GROUP BY Users.user_id;

-- 14.2
SELECT 
    p.name AS product_name,
    SUM(od.quantity) AS total_quantity
FROM 
    Products p
JOIN 
    Order_Details od ON p.product_id = od.product_id
GROUP BY 
    p.product_id
ORDER BY 
    total_quantity DESC
LIMIT 1;