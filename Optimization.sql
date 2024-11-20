USE LittleLemonDM;
SELECT * FROM Bookings;

-- Create optimized queries to manage and analyze data

-- Stored Procedure
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


SET @id = 5;
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


-- TASK: Check if a table in the resturant is already booked?

select * FROM Bookings;

SELECT *
FROM Bookings
WHERE TableNumber = 2
  AND Date = '2022-10-11';


 SELECT COUNT(*) AS 'Booked'
    FROM Bookings
    WHERE TableNumber = 5 AND Date = '2022-10-10';




DELIMITER $$

CREATE PROCEDURE CheckBooking(IN TableNum INT, IN BookDate DATE)
BEGIN
    DECLARE bookingCount INT;
    SELECT COUNT(*)
    INTO bookingCount
    FROM Bookings
    WHERE TableNumber = TableNum AND Date =  BookDate;
    
    IF bookingCount > 0 THEN
        SELECT CONCAT('Table ', TableNum, ' is already booked on ', BookDate) AS Message;
    ELSE
        SELECT CONCAT('Table ', TableNum, ' is available on ', BookDate) AS Message;
    END IF;
END$$

DELIMITER ;

-- DROP PROCEDURE IF EXISTS CheckBooking ;

CALL CheckBooking(1, '2022-10-10');


-- Task: 
-- AddValidBooking

DELIMITER $$
CREATE PROCEDURE AddValidBooking(IN BookingDate DATE, IN TableNumber INT)
BEGIN
    DECLARE tableBooked INT DEFAULT 0;
    START TRANSACTION;

    SELECT COUNT(*)
    INTO tableBooked
    FROM Bookings
    WHERE Date = BookingDate AND TableNumber = TableNumber;

    IF tableBooked > 0 THEN
        ROLLBACK;
        SELECT CONCAT('Table ', TableNumber, ' is already booked - booking cancelled') AS Message;
    ELSE
        INSERT INTO Bookings (Date, TableNumber, CustomerID)
        VALUES (BookingDate, TableNumber, NULL);

        COMMIT;
        SELECT CONCAT('Booking added for Table ', TableNumber, ' on ', BookingDate) AS Message;
    END IF;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS AddValidBooking;

CALL AddValidBooking('2022-11-10', 6)












