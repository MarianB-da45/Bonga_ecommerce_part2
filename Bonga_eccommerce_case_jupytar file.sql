- Using Data Definition Languages (DDL)
/*
Here we are going to be using the sql commands to create our tables
this would involve using CREATE and DROP statements
*/

CREATE TABLE products (
	product_id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	price DECIMAL NOT NULL,
	category TEXT NOT NULL
);

CREATE TABLE customers  (
	customer_id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	email TEXT UNIQUE NOT NULL
);

CREATE TABLE orders (
	order_id SERIAL PRIMARY KEY,
	customer_id INTEGER NOT NULL,
	order_date DATE NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE orderitems (
	order_item_id SERIAL PRIMARY KEY,
	order_id INTEGER NOT NULL,
	product_id INTEGER NOT NULL,
	quantity INTEGER NOT NULL,
	FOREIGN KEY (order_id) REFERENCES orders(order_id),
	FOREIGN KEY (product_id) REFERENCES products(product_id)
);

DROP TABLE IF EXISTS orderitems CASCADE;     
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS products CASCADE;

-- Data Manipulation Language
-- Insert
-- Adding a new product

SELECT *
FROM products

INSERT into products (product_id, name, price, category) VALUES (1001,'New gadget', 299.99, 'Electronics')


SELECT *
FROM products
WHERE  product_id >= 999;


---Adding a new customer
INSERT INTO customers (customer_id, name, email) VALUES (501,'Jane Doe', 'jane.doe@ymail.com')

-- Update
-- updating a Customer's Email
UPDATE customers SET email = 'jane.doe@ymail.com' WHERE name = 'Jane.Doe'
UPDATE customers SET email = 'jane.doe@gmail.com' WHERE name = 'Jane.Doe'

-- Delete
-- Deleting a product
DELETE FROM products WHERE name =  'New gadget'

SELECT * FROM public.orders
WHERE order_date >= '2022-01-01' and order_date <= '2022-01-31'
ORDER BY order_id DESC;

-- Deleting Orders Before a Specific Date
DELETE FROM orderitems WHERE order_id IN (SELECT order_id FROM orders WHERE order_date >= '2022-01-07')
DELETE FROM orders WHERE order_date >= '2022-01-01'AND  order_date <= '2022-01-07'


-- Data Querying Languages
-- Select Products with Specific Price Range 
SELECT *
FROM products
WHERE price >= 300 AND price <= 500;


-- BETWEEN
SELECT *
FROM products
WHERE price BETWEEN 300 and 500;

-- Find Orders Placed on a Specific Date
SELECT *
FROM orders
WHERE order_date = '2022-01-01'

-- Finding Products by Partial Name
SELECT *
FROM products
WHERE name ILIKE '%gadget'

SELECT *
FROM products
WHERE name ILIKE '%gadget%'

-- Search Customers By Email Domain
SELECT *
FROM customers
WHERE email ILIKE '%gmail.com'


-- Select Orders Within A Specific Date 
SELECT *
FROM orders
WHERE order_date BETWEEN '2022-01-01' AND '2022-01-31'


-- Find The Total Sales Per Category
SELECT category, SUM(price * quantity) AS total_price
FROM orderitems, products
WHERE orderitems.product_id = products.product_id
GROUP BY category

-- Find The Highest Selling Product
SELECT product_id, SUM(quantity) as total_quantity
FROM orderitems	
GROUP BY  product_id 	
ORDER BY total_quantity
LIMIT 1;


SELECT orderitems.product_id, products.name, SUM(orderitems.quantity) as total_quantity
FROM orderitems, products
WHERE orderitems.product_id = products.product_id
GROUP BY orderitems.product_id, products.name	
ORDER BY total_quantity
LIMIT 1;

SELECT orderitems.product_id, products.name, SUM(orderitems.quantity) as total_quantity
FROM orderitems, products
WHERE orderitems.product_id = products.product_id
GROUP BY orderitems.product_id, products.name	
ORDER BY total_quantity DESC
LIMIT 1;

SELECT orderitems.product_id, products.name, SUM(orderitems.quantity) as total_quantity
FROM orderitems, products
WHERE orderitems.product_id = products.product_id
GROUP BY orderitems.product_id, products.name	
ORDER BY total_quantity
LIMIT 1;

SELECT product_id, SUM(quantity) as total_quantity
FROM orderitems	
GROUP BY  product_id 	
ORDER BY total_quantity DESC
LIMIT 1;


-- Categories with more than 10 Sales
/*
SELECT
FROM
JOIN
WHERE
GROUP BY
ORDER BY
HAVING
*/

SELECT pd.category, COUNT (od.order_id) as order_count
FROM orders as od, orderitems as oi, products as pd
WHERE od.order_id = oi.order_id
	AND oi.product_id = pd.product_id
GROUP BY pd.category
HAVING COUNT (od.order_id) > 10;

----Find the Average Product Price Per Category Ordered By Price
SELECT category, AVG(price) average_price
FROM products
GROUP BY category
ORDER BY average_price DESC;

--Ascending
SELECT category, AVG(price) average_price
FROM products
GROUP BY category
ORDER BY average_price;

SELECT pd.category, COUNT (od.order_id) as order_count
FROM orders as od, orderitems as oi, products as pd
WHERE od.order_id = oi.order_id
	AND oi.product_id = pd.product_id
GROUP BY pd.category
HAVING COUNT (od.order_id) > 10;


--I Introducing INNER Joins 
SELECT pd.category, COUNT (od.order_id) as order_count
FROM orders as od
INNER JOIN orderitems as oi ON od.order_id = oi.order_id
INNER JOIN products as pd ON oi.product_id = pd.product_id
GROUP BY pd.category
HAVING COUNT (od.order_id) > 10;


--Get the Products and their Orders
SELECT pd.name, od.order_date
FROM products as pd
INNER JOIN orderitems as oi  ON oi.product_id = pd.product_id
INNER JOIN orders as od ON oi.order_id = od.order_id;


--Get the Customers and their Orders
SELECT customers.name, orders.order_id
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id;

-- List All Unique Customer Names And Product  Names In One Column. 
SELECT name 
FROM customers
UNION
SELECT name 
FROM products;

-- Combine Custome's First and Last Names into Fullname
SELECT name || '' || email AS full_details
FROM customers;