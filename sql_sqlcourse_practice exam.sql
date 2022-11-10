# PRACTICE EXAM

SELECT 
    emp_no, DATEDIFF(to_date, from_date), salary
FROM
    salaries
WHERE
    DATEDIFF(to_date, from_date) > 365
        AND salary >= 104038;
        
DELIMITER $$
CREATE FUNCTION f_highest_salary(p_emp_no INTEGER) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE v_highest_salary DECIMAL(10,2);
    
    SELECT MAX(s.salary)
    INTO v_highest_salary FROM
		employees e
        JOIN
        salaries s ON e.emp_no = s.emp_no
	WHERE
		e.emp_no = p_emp_no;

RETURN v_highest_salary;
END$$
DELIMITER ;

## EXAM SQL COURSE
USE albums;

SELECT 
    *
FROM
    albums
WHERE album_name IS NULL;

SELECT 
    SUM(CASE
        WHEN album_name IS NULL THEN 1
        ELSE 0
    END) AS count_nulls
FROM
    albums;

SELECT
	CASE 
		WHEN (SELECT COUNT(record_label_id)
				FROM
					albums
				WHERE record_label_id =13) = (SELECT
											total_no_artists
											FROM record_labels
                                            WHERE record_label_id=13)
		THEN 'Equal'
        ELSE 'Not EQUAL'
END AS result;

SELECT
	SUM(CASE
		WHEN alb.release_date BETWEEN art.record_label_contract_start_date AND art.record_label_contract_end_date THEN 0
        ELSE 1
        END) AS invalid
FROM
	artists art
    JOIN
    albums alb ON art.artist_id = alb.artist_id
WHERE
	art.record_label_contract_start_date IS NOT NULL
		AND art.record_label_contract_end_date IS NOT NULL;
        
SELECT
	a.artist_id, a.artist_first_name, a.artist_last_name, al.genre_id
FROM 
	artists a
    JOIN
    albums al ON a.artist_id = al.artist_id

GROUP BY 1
HAVING COUNT(DISTINCT(al.genre_id)) > 1;

SELECT
	a.artist_id, a.artist_first_name, a.artist_last_name
FROM 
	artists a
    JOIN
    albums al ON a.artist_id = al.artist_id

GROUP BY 2,3
HAVING SUM(al.genre_id) > 1;

DROP TABLE IF EXISTS artist_managers;
CREATE TABLE artist_managers
(
	artist_id INTEGER NOT NULL,
    artist_first_name VARCHAR(30) NOT NULL,
    artist_last_name VARCHAR(30) NOT NULL,
    manager_id INTEGER NOT NULL
);

INSERT INTO artist_managers
(
	artist_id,
    artist_first_name,
    artist_last_name,
    manager_id
)
SELECT 
	artist_id,
    artist_first_name,
    artist_last_name,
    CASE 
		WHEN artist_id < 1025 THEN 1012
        WHEN artist_id > 1250 THEN 1022
	END AS manager_id
FROM artists
WHERE 
	artist_id < 1025 OR artist_id > 1250;
    
SELECT 
    a.artist_first_name,
    a.artist_last_name,
    rl.record_label_name
FROM
    artists a
        JOIN
    record_labels rl
WHERE
    a.artist_id < 1016;

SELECT 
	a.artist_id, a.no_weeks_top_100
FROM artists a
	JOIN 
    albums al ON a.artist_id  = al.artist_id
GROUP BY 1
ORDER BY 2 DESC;

SELECT 
    artist_id,COUNT(DISTINCT genre_id) AS no_genre
FROM
    albums
GROUP BY artist_id
ORDER BY artist_id;