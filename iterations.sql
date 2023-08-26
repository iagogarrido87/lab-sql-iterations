-- 1. Write a query to find the total business done by each store:
SELECT s.store_id, CONCAT(st.first_name, ' ', st.last_name) AS manager_name, SUM(p.amount) AS total_sales
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id, manager_name;

-- Convert the previous query into a stored procedure:
DELIMITER //
CREATE PROCEDURE GetTotalSalesByStore()
BEGIN
    SELECT s.store_id, CONCAT(st.first_name, ' ', st.last_name) AS manager_name, SUM(p.amount) AS total_sales
    FROM store s
    JOIN staff st ON s.store_id = st.store_id
    JOIN payment p ON st.staff_id = p.staff_id
    GROUP BY s.store_id, manager_name;
END //
DELIMITER ;

-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store:
DELIMITER //
CREATE PROCEDURE GetTotalSalesForStore(IN storeId INT)
BEGIN
    SELECT s.store_id, CONCAT(st.first_name, ' ', st.last_name) AS manager_name, SUM(p.amount) AS total_sales
    FROM store s
    JOIN staff st ON s.store_id = st.store_id
    JOIN payment p ON st.staff_id = p.staff_id
    WHERE s.store_id = storeId
    GROUP BY s.store_id, manager_name;
END //
DELIMITER ;

-- Update the previous query to declare a variable total_sales_value of float type, call the stored procedure, and print the results:
DELIMITER //
CREATE PROCEDURE GetTotalSalesForStorePrint(IN storeId INT)
BEGIN
    DECLARE total_sales_value FLOAT;
    
    SELECT SUM(p.amount) INTO total_sales_value
    FROM staff st
    JOIN payment p ON st.staff_id = p.staff_id
    WHERE st.store_id = storeId;
    
    SELECT total_sales_value;
END //
DELIMITER ;

-- Call the stored procedure and print results
CALL GetTotalSalesForStorePrint(1);

-- Update the stored procedure to include a flag based on the total sales value:
DELIMITER //
CREATE PROCEDURE GetTotalSalesAndFlag(IN storeId INT)
BEGIN
    DECLARE total_sales_value FLOAT;
    DECLARE flag VARCHAR(10);
    
    SELECT SUM(p.amount) INTO total_sales_value
    FROM staff st
    JOIN payment p ON st.staff_id = p.staff_id
    WHERE st.store_id = storeId;
    
    IF total_sales_value > 30000 THEN
        SET flag = 'green_flag';
    ELSE
        SET flag = 'red_flag';
    END IF;
    
    SELECT total_sales_value, flag;
END //
DELIMITER ;

-- Call the updated stored procedure and print results
CALL GetTotalSalesAndFlag(1);
