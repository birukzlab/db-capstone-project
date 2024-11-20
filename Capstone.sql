Show tables FROM LittleLemonDM;
USE LittleLemonDM;
SELECT * FROM Bookings;

select * FROM Customers;

--  Add Data

-- Customers

INSERT INTO Customers (CustomerID, FullName, Email, ContactNumber)
VALUES
    (1, 'John Doe', 'john.doe@example.com', '123-456-7890'),
    (2, 'Jane Smith', 'jane.smith@example.com', '987-654-3210'),
    (3, 'Emily Davis', 'emily.davis@example.com', '555-555-5555');


-- Staff

INSERT INTO Staff (StaffID, Role, Salary)
VALUES
    (1, 'Manager', 50000),
    (2, 'Waiter', 25000),
    (3, 'Chef', 40000);


-- Menu
INSERT INTO Menu (MenuID, Cuisine, Courses, Drinks, Desserts)
VALUES
    (1, 'Italian', 'Pasta, Pizza', 'Wine, Beer', 'Tiramisu'),
    (2, 'Indian', 'Curry, Naan', 'Lassi, Soda', 'Gulab Jamun'),
    (3, 'Mexican', 'Tacos, Burritos', 'Tequila, Soda', 'Churros');



-- Orders

INSERT INTO Orders (OrderID, OrderDate, Quantity, TotalCost, CustomerID, StaffID, MenuID)
VALUES
    (1, '2022-10-10', 2, 50.00, 1, 2, 1),
    (2, '2022-10-11', 1, 25.00, 2, 3, 3),
    (3, '2022-11-12', 3, 75.00, 3, 1, 2);


-- OrderDeliveryStatus

INSERT INTO OrderDeliveryStatus (DeliveryID, DeliveryStatus, DeliveryDate, OrderID)
VALUES
    (1, 'Delivered', '2022-10-11', 1),
    (2, 'Pending', '2022-10-12', 3),
    (3, 'In Progress', '2022-11-13', 2);





-- Bookings

INSERT INTO Bookings (BookingID, Date, TableNumber, CustomerID)
VALUES
    (1, '2022-10-10', 5, 1),
    (2, '2022-11-12', 3, 3),
    (3, '2022-10-11', 2, 2),
    (4, '2022-10-13', 2, 1);

/*
DELETE FROM Bookings
WHERE BookingID IN (1,2,3,4);
*/



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




CALL CancelOrder(2);

/*
DROP PROCEDURE IF EXISTS CancelOrder;
SELECT ROUTINE_NAME
FROM information_schema.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'CancelOrder';
*/

SELECT * FROM Customers;








