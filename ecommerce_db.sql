CREATE DATABASE EcommerceDB;
USE EcommerceDB;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    City VARCHAR(50),
    ReferrerID INT
);

INSERT INTO Customers VALUES
(1,'Rahul','Mumbai',NULL),
(2,'Priya','Delhi',1),
(3,'Amit','Pune',1),
(4,'Sneha','Bangalore',2),
(5,'Karan','Hyderabad',NULL),
(6,'Neha','Chennai',3);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

INSERT INTO Products VALUES
(101,'Laptop','Electronics',65000),
(102,'Mobile','Electronics',25000),
(103,'Headphones','Electronics',3000),
(104,'T-Shirt','Fashion',800),
(105,'Jeans','Fashion',1500),
(106,'SQL Book','Books',500),
(107,'Football','Sports',1200);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    OrderDate DATE
);

INSERT INTO Orders VALUES
(1001,1,101,1,'2025-01-10'),
(1002,1,103,2,'2025-01-12'),
(1003,2,104,3,'2025-01-15'),
(1004,3,102,1,'2025-02-01'),
(1005,4,106,2,'2025-02-10'),
(1006,6,107,1,'2025-02-20');

-- 1. Display customer names with product names.

SELECT CustomerName, ProductName
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
INNER JOIN Products
ON Orders.ProductID = Products.ProductID;


-- 2. Display customer names with their orders.

SELECT CustomerName, OrderID
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;


-- 3. Display all customers including those who never placed orders.

SELECT CustomerName, OrderID
FROM Customers
LEFT JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;


-- 4. Find customers who never placed an order.

SELECT CustomerName
FROM Customers
LEFT JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
WHERE OrderID IS NULL;


-- 5. Display all products including products never ordered.

SELECT ProductName, OrderID
FROM Products
LEFT JOIN Orders
ON Products.ProductID = Orders.ProductID;


-- 6. Find products never ordered.

SELECT ProductName
FROM Products
LEFT JOIN Orders
ON Products.ProductID = Orders.ProductID
WHERE OrderID IS NULL;


-- 7. Display customer name, product name and quantity.

SELECT CustomerName, ProductName, Quantity
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
INNER JOIN Products
ON Orders.ProductID = Products.ProductID;


-- 8. Display complete order details.

SELECT OrderID,
       CustomerName,
       ProductName,
       Quantity,
       OrderDate
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
INNER JOIN Products
ON Orders.ProductID = Products.ProductID;


-- 9. Find total orders placed by each customer.

SELECT CustomerName,
       COUNT(OrderID) AS Total_Orders
FROM Customers
LEFT JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
GROUP BY CustomerName;


-- 10. Find total quantity sold for each product.

SELECT ProductName,
       SUM(Quantity) AS Total_Sold
FROM Products
LEFT JOIN Orders
ON Products.ProductID = Orders.ProductID
GROUP BY ProductName;


-- 11. Find customer who placed highest number of orders.

SELECT CustomerName,
       COUNT(OrderID) AS Total_Orders
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
GROUP BY CustomerName
ORDER BY Total_Orders DESC
LIMIT 1;


-- 12. Find best-selling product.

SELECT ProductName,
       SUM(Quantity) AS Total_Sold
FROM Products
INNER JOIN Orders
ON Products.ProductID = Orders.ProductID
GROUP BY ProductName
ORDER BY Total_Sold DESC
LIMIT 1;


-- 13. Find customers who purchased Electronics products.

SELECT DISTINCT CustomerName
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
INNER JOIN Products
ON Orders.ProductID = Products.ProductID
WHERE Category = 'Electronics';


-- 14. Find customers who purchased products from multiple categories.

SELECT CustomerName
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
INNER JOIN Products
ON Orders.ProductID = Products.ProductID
GROUP BY CustomerName
HAVING COUNT(DISTINCT Category) > 1;


-- 15. Display customer and referrer names.

SELECT C.CustomerName AS Customer,
       R.CustomerName AS Referrer
FROM Customers C
LEFT JOIN Customers R
ON C.ReferrerID = R.CustomerID;


-- 16. Find customers referred by Rahul.

SELECT C.CustomerName
FROM Customers C
INNER JOIN Customers R
ON C.ReferrerID = R.CustomerID
WHERE R.CustomerName = 'Rahul';


-- 17. Find referrers who referred more than one customer.

SELECT R.CustomerName,
       COUNT(*) AS Referrals
FROM Customers C
INNER JOIN Customers R
ON C.ReferrerID = R.CustomerID
GROUP BY R.CustomerName
HAVING COUNT(*) > 1;


-- 18. Generate all customer-product combinations.

SELECT CustomerName, ProductName
FROM Customers
CROSS JOIN Products;


-- 19. Find customers spending more than average spending.

SELECT CustomerName
FROM Customers C
INNER JOIN Orders O
ON C.CustomerID = O.CustomerID
INNER JOIN Products P
ON O.ProductID = P.ProductID
GROUP BY CustomerName
HAVING SUM(P.Price * O.Quantity) >
(
    SELECT AVG(TotalSpend)
    FROM
    (
        SELECT SUM(P.Price * O.Quantity) AS TotalSpend
        FROM Orders O
        INNER JOIN Products P
        ON O.ProductID = P.ProductID
        GROUP BY O.CustomerID
    ) X
);


-- 20. Find highest revenue product.

SELECT ProductName,
       SUM(Price * Quantity) AS Revenue
FROM Products
INNER JOIN Orders
ON Products.ProductID = Orders.ProductID
GROUP BY ProductName
ORDER BY Revenue DESC
LIMIT 1;