/*
STORED PROCEDURES
*/

USE employees;

# FIRST METHOD:

DROP PROCEDURE IF EXISTS select_employees;

DELIMITER $$
CREATE PROCEDURE select_employees()
BEGIN
	SELECT * FROM employees
    LIMIT 1000;
END$$

DELIMITER ;


CALL employees.select_employees(); -- CALLING THE PROCEDURE
DROP PROCEDURE select_employees; -- DELETE THE PROCEDURE

DROP PROCEDURE IF EXISTS average_salary;

DELIMITER $$
CREATE PROCEDURE average_salary()
BEGIN
	SELECT 
		AVG(s.salary)
	FROM
		employees e
			JOIN
		salaries s ON e.emp_no = s.emp_no;
END$$

DELIMITER ;

# SECOND METHOD: THORUGH WORKBENCH INTERFACE

# STORED PROCEDURE WITH AN INPUT PARAMETER
DROP PROCEDURE IF EXISTS emp_salary;

DELIMITER $$
CREATE PROCEDURE emp_salary(in p_emp_no INT)
BEGIN
	SELECT e.first_name, e.last_name, s.salary, s.from_date, s.to_date
    FROM employees e
		JOIN
        salaries s ON e.emp_no = s.emp_no
	WHERE 
		e.emp_no = p_emp_no
	ORDER BY s.from_date DESC;
END$$

DELIMITER ;

# STORED PROCEDURE WITH TWO PARAMETERS (IN AND OUT)
DROP PROCEDURE IF EXISTS emp_info;

DELIMITER $$
CREATE PROCEDURE emp_info(in p_first_name VARCHAR(255), in p_last_name VARCHAR(255), out p_emp_no INTEGER)
BEGIN
	SELECT
		e.emp_no 
	INTO p_emp_no FROM 
		employees e
	WHERE 
		e.first_name = p_first_name 
			AND e.last_name = p_last_name;
END$$
DELIMITER ;

CALL employees.emp_info2('Lillian', 'Fontet', @p_emp_no);

# Stored procedures with an output parameter - solution
DELIMITER $$
CREATE PROCEDURE emp_info2(in p_first_name varchar(255), in p_last_name varchar(255), out p_emp_no integer)
BEGIN
                SELECT
                                e.emp_no
                INTO p_emp_no FROM
                                employees e
                WHERE
                                e.first_name = p_first_name
                                                AND e.last_name = p_last_name;
END$$
DELIMITER ;

# HOW TO CALL - USING VARIABLE
SET @p_emp_no = 0;
CALL employees.emp_info('Lillian', 'Fontet', @p_emp_no);
SELECT @p_emp_no;

SET @v_emp_no = 0;
CALL emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;

# USER-DEFINED FUNCTION
DROP FUNCTION IF EXISTS f_emp_info;

DELIMITER $$
CREATE FUNCTION f_emp_info(p_first_name VARCHAR(255), p_last_name VARCHAR(255)) RETURNS INTEGER
DETERMINISTIC
BEGIN
	DECLARE v_emp_no INTEGER;
    
    SELECT 
		emp_no
    INTO v_emp_no FROM
		employees
	WHERE
		first_name = p_first_name
			AND last_name = p_last_name;
RETURN v_emp_no;
END$$

DELIMITER ;

SELECT f_emp_info('Lillian', 'Fontet') AS employer_no; -- CALLING THE FUNCTION

# EXERCISE
DROP FUNCTION IF EXISTS emp_salary;

DELIMITER $$
CREATE FUNCTION emp_salary(p_first_name VARCHAR(255), p_last_name VARCHAR(255)) RETURNS DECIMAL(10,2)
DETERMINISTIC NO SQL READS SQL DATA
BEGIN
	DECLARE v_max_date DATE;
    DECLARE v_salary DECIMAL(10,2);
    
    SELECT 
		MAX(s.from_date)
	INTO v_max_date FROM
		employees e
			JOIN
		salaries s ON e.emp_no = s.emp_no
	WHERE 
		e.first_name = p_first_name
			AND e.last_name = p_last_name;
            
	SELECT 
		s.salary
	INTO v_salary FROM
		employees e
			JOIN 
		salaries s ON e.emp_no = s.emp_no
	WHERE
		e.first_name = p_first_name
			AND e.last_name = p_last_name
				AND s.from_date = v_max_date;
RETURN v_salary;
END$$
DELIMITER ;