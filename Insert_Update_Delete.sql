USE LittleLemonDM;

-- Add Booking Procedure
DELIMITER $$
CREATE PROCEDURE AddBookings(IN BookingID INT, IN CustomerID INT, IN BookingDate DATE, IN TableNumber INT)
BEGIN
    DECLARE tableBooked INT DEFAULT 0;

    SELECT COUNT(*)
    INTO tableBooked
    FROM Bookings
    WHERE Date = BookingDate AND TableNumber = TableNumber;

    IF tableBooked > 0 THEN
        SELECT CONCAT('Table ', TableNumber, ' is already booked on ', BookingDate, ' - booking not added') AS Message;
    ELSE
      
        INSERT INTO Bookings (BookingID, Date, TableNumber, CustomerID)
        VALUES (BookingID, BookingDate, TableNumber, CustomerID);

        SELECT CONCAT('Booking successfully added for Table ', TableNumber, ' on ', BookingDate) AS Message;
    END IF;
END$$

DELIMITER ;

CALL AddBookings(9, 3, "2022-12-30", 4 );

SELECT * FROM Bookings;


-- Update Booking

DELIMITER $$
CREATE PROCEDURE UpdateBooking(IN BookID INT, IN NewBookingDate DATE)
BEGIN
    IF EXISTS (
        SELECT 1 FROM Bookings WHERE BookingID = BookID
    ) THEN
        UPDATE Bookings
        SET Date = NewBookingDate
        WHERE BookingID = BookID;

        SELECT CONCAT('Booking ', BookID, ' updated to ', NewBookingDate) AS Message;
    ELSE
        SELECT CONCAT('Booking ', BookID, ' does not exist') AS Message;
    END IF;
END$$

DELIMITER ;

SET SQL_SAFE_UPDATES = 0;


CALL UpdateBooking(9, '2022-10-17');




-- CancelBooking

SELECT 1 FROM Bookings WHERE BookingID = 9;


DELIMITER $$
CREATE PROCEDURE CancelBooking(IN BookID INT)
BEGIN
    IF EXISTS (
        SELECT 1 FROM Bookings WHERE BookingID = BookID
    ) THEN
        DELETE FROM Bookings WHERE BookingID = BookID;

        SELECT CONCAT('Booking ', BookID, ' successfully cancelled') AS Message;
    ELSE
        SELECT CONCAT('Booking ', BookID, ' does not exist') AS Message;
    END IF;
END$$

DELIMITER ;

CALL CancelBooking(9);


DROP PROCEDURE IF EXISTS CancelBooking;
DROP PROCEDURE IF EXISTS UpdateBooking;
SELECT * FROM Bookings;
























