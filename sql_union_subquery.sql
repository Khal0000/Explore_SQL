/*
INSERT INTO + UNION + SUBQUERY
*/

INSERT INTO emp_manager
SELECT U.*
FROM
	(SELECT A.*
	FROM
		(SELECT 
			e.emp_no AS employee_ID,
			MIN(de.dept_no) AS dept_code,
			(SELECT 
					emp_no
				FROM
					dept_manager
				WHERE
					emp_no = 110022) AS manager_id
		FROM
			employees e
				JOIN
			dept_emp de ON e.emp_no = de.emp_no
		WHERE e.emp_no <= 10020
		GROUP BY e.emp_no) AS A
	UNION
	SELECT B.*
	FROM
		(SELECT 
			e.emp_no AS employee_ID,
			MIN(de.dept_no) AS dept_code,
			(SELECT 
					emp_no
				FROM
					dept_manager
				WHERE
					emp_no = 110039) AS manager_id
		FROM
			employees e
				JOIN
			dept_emp de ON e.emp_no = de.emp_no
		WHERE e.emp_no BETWEEN 10021 AND 10040
		GROUP BY e.emp_no) AS B
	UNION
	SELECT C.*
	FROM
		(SELECT 
			e.emp_no AS employee_ID,
			MIN(de.dept_no) AS dept_code,
			(SELECT 
					emp_no
				FROM
					dept_manager
				WHERE
					emp_no = 110039) AS manager_id
		FROM
			employees e
				JOIN
			dept_emp de ON e.emp_no = de.emp_no
		WHERE e.emp_no = 110022
		GROUP BY e.emp_no) AS C
	UNION
	SELECT D.*
	FROM
		(SELECT 
			e.emp_no AS employee_ID,
			MIN(de.dept_no) AS dept_code,
			(SELECT 
					emp_no
				FROM
					dept_manager
				WHERE
					emp_no = 110022) AS manager_id
		FROM
			employees e
				JOIN
			dept_emp de ON e.emp_no = de.emp_no
		WHERE e.emp_no = 110039
		GROUP BY e.emp_no) AS D) AS U;

TRUNCATE TABLE emp_manager;


SELECT 
    *
FROM
    emp_manager;

SELECT 
    em1.*
FROM
    emp_manager em1
        JOIN
    emp_manager em2 ON em1.emp_no = em2.manager_no
GROUP BY em1.emp_no;
