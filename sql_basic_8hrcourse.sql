SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Cathie'
        OR first_name = 'Mark'
        OR first_name = 'Nathan';
        
SELECT 
    *
FROM
    employees
WHERE
    first_name IN ('Cathie' , 'Mark', 'Nathan');
    
SELECT 
    *
FROM
    employees
WHERE
    first_name NOT IN ('Cathie' , 'Mark', 'Nathan');
    
SELECT 
    *
FROM
    employees
WHERE
    first_name IN ('Denis' , 'Elvis');
    
SELECT 
    *
FROM
    employees
WHERE
    first_name NOT IN ('John' , 'Mark', 'Jacob');
    

SELECT 
    *
FROM
    employees
WHERE
    emp_no LIKE ('1000_');
    
SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE ('%Jack%');
    
SELECT 
    *
FROM
    salaries
WHERE
    salary BETWEEN 66000 AND 70000
        AND (emp_no NOT BETWEEN 10004 AND 10012);
        
SELECT 
    *
FROM
    departments
WHERE
    dept_no BETWEEN 'd003' AND 'd006'; 
    
SELECT 
    *
FROM
    departments
WHERE
    dept_name IS NOT NULL;
    
SELECT 
    *
FROM
    employees
WHERE
    gender = 'F' AND hire_date >= '2000-01-01';
    
SELECT 
    *
FROM
    salaries
WHERE
    salary >= 150000;
    
SELECT DISTINCT
    hire_date
FROM
    employees;
    
SELECT 
    COUNT(*)
FROM
    salaries
WHERE salary >= 100000;


SELECT 
    *
FROM
    employees
ORDER BY hire_date DESC;


SELECT 
    salary, COUNT(salary) AS emps_with_same_salary
FROM
    salaries
WHERE
    salary >= 80000
GROUP BY salary
ORDER BY salary ASC;

SELECT 
    *, AVG(salary)
FROM
    salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000;

SELECT 
    *, AVG(salary)
FROM
    salaries
WHERE
    salary > 120000
GROUP BY emp_no
ORDER BY emp_no;

SELECT 
    *, COUNT(first_name) AS appearance
FROM
    employees
WHERE
    hire_date > '1999-01-01'
GROUP BY first_name 
HAVING appearance < 200
ORDER BY appearance DESC;

SELECT 
    emp_no, COUNT(emp_no) AS no_contract
FROM
    dept_emp
WHERE
    from_date > '2000-01-01'
GROUP BY emp_no
HAVING no_contract > 1;

SELECT 
    *
FROM
    titles
LIMIT 10;

ALTER TABLE titles
DROP FOREIGN KEY titles_ibfk_1;

INSERT INTO titles
(
	emp_no,
    title,
    from_date
) VALUES
(
	999903,
    'Senior Engineer',
    '1997-10-01'
);

SELECT 
    *
FROM
    titles
ORDER BY emp_no DESC
LIMIT 10;

DELETE FROM titles
WHERE emp_no = 999903;

ALTER TABLE titles
ADD FOREIGN KEY (emp_no) REFERENCES employees(emp_no) ON DELETE CASCADE;

SELECT 
    *
FROM
    departments
LIMIT 10;

INSERT INTO departments
(
	dept_no,
    dept_name
) VALUES
(
	'd010',
    'Business Analysis'
);

CREATE TABLE departements_dub (
    dept_no CHAR(4) NOT NULL,
    dept_name VARCHAR(40) NOT NULL
);

SELECT 
    *
FROM
    departements_dub;
    
INSERT INTO departements_dub
(
	dept_no,
    dept_name
)
SELECT *
FROM departments;

TRUNCATE TABLE departements_dub;


SELECT 
    *
FROM
    departements_dub;

COMMIT;

UPDATE departements_dub
SET 
	dept_no = 'd011',
    dept_name = 'QA';

ROLLBACK;

UPDATE departments 
SET 
    dept_name = 'Data Analysis'
WHERE
    dept_no = 'd010';
    
SELECT 
    *
FROM
    departments;

DELETE FROM departments 
WHERE
    dept_no = 'd010';

SELECT 
    dept_no, COUNT(dept_no)
FROM
    dept_emp
GROUP BY dept_no;

SELECT 
    SUM(salary)
FROM
    salaries
WHERE from_date = '1997-01-01';

SELECT 
    ROUND(AVG(salary),0)
FROM
    salaries;
    
SELECT 
    *
FROM
    departements_dub;
    
ALTER TABLE departements_dub
ADD dept_info VARCHAR(255);

SELECT 
    dept_no,
    dept_name,
    COALESCE(dept_info, dept_name) AS dept_info
FROM
    departements_dub;
    
SELECT 
    emp.*, dept.*
FROM
    employees AS emp
        JOIN
    dept_emp AS dept ON emp.emp_no = dept.emp_no;
    
SELECT 
    *
FROM
    departements_dub;
    
ALTER table departements_dub
DROP COLUMN dept_info;

ALTER TABLE departements_dub
MODIFY COLUMN dept_no CHAR(4) NULL;

ALTER TABLE departements_dub
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;

INSERT INTO departements_dub
(
	dept_name
) VALUES
(
	'Public Relations'
);

DELETE FROM departements_dub 
WHERE
    dept_no = 'd002';
    
INSERT INTO departements_dub
(
	dept_no
) VALUES
(
	'd010'
),
(
	'd011'
);

DROP TABLE IF EXISTS dept_manager_dup;
CREATE TABLE dept_manager_dup
(
	emp_no INT NOT NULL,
    dept_no CHAR(4) NULL,
    from_date DATE NOT NULL,
    to_date DATE NULL
);

SELECT * FROM dept_manager_dup;

INSERT INTO dept_manager_dup
(
	emp_no,
    dept_no,
    from_date,
    to_date
)
SELECT * FROM dept_manager;

INSERT INTO dept_manager_dup
(
	emp_no,
    from_date
) VALUES
(999904, '2017-01-01'),
(999905, '2017-01-01'),
(999906, '2017-01-01'),
(999907, '2017-01-01');

DELETE FROM dept_manager_dup
WHERE
	dept_no = 'd001';

SELECT * FROM departements_dub;

SELECT *
FROM dept_manager_dup;

SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        INNER JOIN
    departements_dub d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

SELECT * FROM employees;
SELECT * FROM dept_manager;

SELECT 
    e.emp_no, e.first_name, e.last_name, m.dept_no, m.from_date
FROM
    employees e
        LEFT JOIN
    dept_manager m ON e.emp_no = m.emp_no
WHERE e. first_name = 'Margareta' AND e.last_name = 'Markovitch'
ORDER BY m.dept_no DESC, e.emp_no;

SELECT dm.*, d.*
FROM dept_manager dm
	CROSS JOIN
	departments d
WHERE 
	d.dept_no = 'd009'
ORDER BY dm.emp_no, d.dept_no;

SELECT 
    e.gender, COUNT(e.gender) AS manager_by_gender
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
--         JOIN
--     titles t ON dm.emp_no = t.emp_no
GROUP BY e.gender;

SELECT 
    e.gender, COUNT(dm.emp_no)
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY gender;

SELECT 
    *
FROM
    (SELECT 
        e.emp_no,
            e.first_name,
            e.last_name,
            NULL AS dept_no,
            NULL AS from_date
    FROM
        employees e
    WHERE
        last_name = 'Denis' UNION SELECT 
        NULL AS emp_no,
            NULL AS first_name,
            NULL AS last_name,
            dm.dept_no,
            dm.from_date
    FROM
        dept_manager dm) AS a
ORDER BY - a.emp_no DESC;

SELECT 
    e.first_name, e.last_name
FROM
    employees e
WHERE
    e.emp_no IN (SELECT 
            emp_no
        FROM
            dept_manager
        WHERE
            from_date BETWEEN '1990-01-01' AND '1995-01-01');

SELECT 
    *
FROM
    employees e
WHERE
    EXISTS( SELECT 
            *
        FROM
            titles t
        WHERE
            t.title = 'Assistant Engineer'
                AND (e.emp_no = t.emp_no))
;

DROP TABLE IF EXISTS emp_manager;
CREATE TABLE emp_manager (
    emp_no INT NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT NOT NULL
);

CREATE OR REPLACE VIEW v_average_manager_salary AS
SELECT
	e.first_name, e.last_name, ROUND(AVG(s.salary),2) AS average_salary
FROM employees e
	JOIN
	dept_manager dm ON e.emp_no = dm.emp_no
    JOIN
    salaries s ON dm.emp_no = s.emp_no AND e.emp_no = s.emp_no
GROUP BY e.emp_no
ORDER BY average_salary DESC;

CREATE OR REPLACE VIEW v_avg_managerr_salary AS
SELECT AVG(s.salary) AS average_salary
FROM salaries s
	JOIN 
    dept_manager dm ON s.emp_no = dm.emp_no;

# QUIZ
SELECT 
    first_name, last_name, YEAR(hire_date)
FROM
    employees
WHERE
    YEAR(hire_date) = '2000'
ORDER BY first_name ASC;

SELECT e.gender, d.dept_name, AVG(s.salary)
FROM salaries s
	JOIN
    employees e ON s.emp_no = e.emp_no
    JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
    JOIN
    departments d ON dm.dept_no = d.dept_no
GROUP BY e.gender, dm.dept_no
ORDER BY d.dept_name;


DROP PROCEDURE IF EXISTS last_dept;

DELIMITER $$
CREATE PROCEDURE last_dept(IN p_emp_no INTEGER)
BEGIN
	SELECT
		e.emp_no, d.dept_no, d.dept_name
	FROM
		employees e
        JOIN
        dept_emp de ON e.emp_no = de.emp_no
        JOIN
        departments d ON de.dept_no = d.dept_no
	WHERE 
		e.emp_no = p_emp_no
			AND de.from_date = (SELECT 
									MAX(from_date)
								FROM dept_emp
								WHERE
										emp_no = p_emp_no);
END$$
DELIMITER ;

CALL last_dept(10014); 
CALL last_dept(10100);

USE employees;

SELECT 
    gender, COUNT(emp_no) AS no_emp, YEAR(hire_date) AS year_working
FROM
    employees
WHERE YEAR(hire_date) >= '1990'
GROUP BY gender, year_working
ORDER BY hire_date DESC;