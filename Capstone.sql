Show tables FROM LittleLemonDM;
USE LittleLemonDM;
SELECT * FROM Bookings;

select * FROM Customers;

--  Add Data

-- Customers

INSERT INTO Customers (CustomerID, FirstName, LastName)
VALUES
(1, 'John', 'Doe'),
(2, 'Jane', 'Smith'),
(3, 'Emily', 'Johnson'),
(4, 'Michael', 'Brown'),
(5, 'Sarah', 'Davis'),
(6, 'Chris', 'Wilson'),
(7, 'Laura', 'Garcia'),
(8, 'Daniel', 'Martinez'),
(9, 'Sophia', 'Anderson'),
(10, 'James', 'Taylor');

-- Staff

INSERT INTO Staff (StaffID, Role, Salary)
VALUES
(1, 'Chef', 50000.00),
(2, 'Waiter', 30000.00),
(3, 'Manager', 60000.00),
(4, 'Host', 25000.00),
(5, 'Bartender', 28000.00),
(6, 'Dishwasher', 20000.00),
(7, 'Delivery Driver', 27000.00),
(8, 'Sous Chef', 45000.00),
(9, 'Server', 32000.00),
(10, 'Receptionist', 26000.00);

-- Menu
INSERT INTO Menu (MenuID, Cuisine, Courses, Drinks, Desserts)
VALUES
(1, 'Italian', 'Pizza', 'Wine', 'Tiramisu'),
(2, 'Indian', 'Curry', 'Lassi', 'Gulab Jamun'),
(3, 'American', 'Burger', 'Coke', 'Ice Cream'),
(4, 'Mexican', 'Tacos', 'Margarita', 'Churros'),
(5, 'Chinese', 'Noodles', 'Green Tea', 'Mango Pudding'),
(6, 'Japanese', 'Sushi', 'Sake', 'Mochi'),
(7, 'French', 'Croissant', 'Champagne', 'Crème Brûlée'),
(8, 'Thai', 'Pad Thai', 'Thai Iced Tea', 'Sticky Rice'),
(9, 'Mediterranean', 'Falafel', 'Mint Lemonade', 'Baklava'),
(10, 'Greek', 'Gyro', 'Ouzo', 'Loukoumades');


-- Orders

INSERT INTO Orders (OrderID, OrderDate, Quantity, TotalCost, CustomerID, StaffID, MenuID)
VALUES
(1, '2024-11-01', 2, 40.00, 1, 2, 1),
(2, '2024-11-01', 1, 20.00, 2, 1, 3),
(3, '2024-11-02', 3, 60.00, 3, 2, 2),
(4, '2024-11-02', 1, 25.00, 4, 5, 4),
(5, '2024-11-03', 4, 50.00, 5, 6, 5),
(6, '2024-11-04', 2, 30.00, 6, 7, 6),
(7, '2024-11-04', 1, 35.00, 7, 8, 7),
(8, '2024-11-05', 5, 75.00, 8, 3, 8),
(9, '2024-11-05', 3, 45.00, 9, 4, 9),
(10, '2024-11-06', 2, 40.00, 10, 5, 10);

-- OrderDeliveryStatus

INSERT INTO OrderDeliveryStatus (DeliveryID, DeliveryStatus, DeliveryDate, OrderID, CustomerID)
VALUES
(1, 'Delivered', '2024-11-01', 1, 1),
(2, 'Delivered', '2024-11-01', 2, 2),
(3, 'In Progress', '2024-11-02', 3, 3),
(4, 'Pending', '2024-11-02', 4, 4),
(5, 'Delivered', '2024-11-03', 5, 5),
(6, 'Cancelled', '2024-11-04', 6, 6),
(7, 'Delivered', '2024-11-04', 7, 7),
(8, 'Pending', '2024-11-05', 8, 8),
(9, 'Delivered', '2024-11-05', 9, 9),
(10, 'In Progress', '2024-11-06', 10, 10);

-- Bookings

INSERT INTO Bookings (BookingID, Date, TableNumber, CustomerID, Staff_StaffID)
VALUES
(1, '2024-11-01', 5, 1, 3),
(2, '2024-11-02', 3, 2, 2),
(3, '2024-11-03', 1, 3, 1),
(4, '2024-11-04', 2, 4, 4),
(5, '2024-11-05', 4, 5, 5),
(6, '2024-11-06', 6, 6, 6),
(7, '2024-11-07', 7, 7, 7),
(8, '2024-11-08', 8, 8, 8),
(9, '2024-11-09', 9, 9, 9),
(10, '2024-11-10', 10, 10, 10);


-- TASK 1 - Virtual Table

CREATE VIEW OrdersView AS
SELECT OrderID, Quantity, TotalCost 
FROM Orders
WHERE Quantity > 2;

SELECT * FROM OrdersView;


-- Task 2 

SELECT 
	c.CustomerID, 
    CONCAT(FirstName, ' ', LastName) AS FullName, 
    o.OrderID, 
    o.TotalCost, 
    m.Cuisine, 
    m.Courses, 
    m.Drinks, 
    m.Desserts
FROM Customers AS c
INNER JOIN Orders AS o
USING(CustomerID)
INNER JOIN Menu AS m
USING (MenuID)
ORDER BY o.TotalCost;

-- TASK 3

SELECT 
    m.MenuID, 
    m.Cuisine, 
    m.Courses, 
    m.Drinks, 
    m.Desserts, 
    COUNT(o.OrderID) AS TotalOrders
FROM Menu AS m
INNER JOIN Orders AS o
    ON m.MenuID = o.MenuID
GROUP BY m.MenuID, m.Cuisine, m.Courses, m.Drinks, m.Desserts
HAVING COUNT(o.OrderID) > 1;

SELECT 
    m.MenuID, 
    m.Cuisine, 
    m.Courses, 
    m.Drinks, 
    m.Desserts
FROM Menu AS m
WHERE m.MenuID = ANY (
    SELECT o.MenuID
    FROM Orders AS o
    GROUP BY o.MenuID
    HAVING COUNT(o.OrderID) > 2
);

-- Create optimized queries to manage and analyze data

CREATE PROCEDURE GetMaxQuantity()
SELECT MAX(Quantity) AS "Max Quantity in Order" FROM Orders;

-- call
CALL GetMaxQuantity();

-- Prepared statment

PREPARE GetOrderDetail FROM
'SELECT Orders.OrderID, Orders.Quantity,Orders.TotalCost 
FROM Orders JOIN Customers USING(CustomerID)
WHERE Customers.CustomerID = ? ;';

SELECT Customers.CustomerID, Orders.OrderID, Orders.Quantity,Orders.TotalCost 
FROM Orders JOIN Customers USING(CustomerID);


SET @id = 2;
EXECUTE GetOrderDetail USING @id;

-- Cancel Order - Stored procedure

ALTER TABLE `Orders`
ADD COLUMN `status` VARCHAR(50) DEFAULT 'Pending';

DELIMITER $$

CREATE PROCEDURE CancelOrder(IN orderID INT)
BEGIN
    -- Update the order's status to 'Cancelled'
    UPDATE `LittleLemonDM`.`Orders`
    SET status = 'Cancelled'
    WHERE OrderID = orderID;

    -- Return a success or error message
    SELECT 
        IF(ROW_COUNT() > 0, 
           CONCAT('Order ', orderID, ' has been successfully cancelled.'), 
           CONCAT('Order ', orderID, ' does not exist.')
        ) AS message;
END$$

DELIMITER ;




CALL CancelOrder(5);

/*
DROP PROCEDURE IF EXISTS CancelOrder;
SELECT ROUTINE_NAME
FROM information_schema.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'CancelOrder';
*/








