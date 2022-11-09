-- See ALl Data
SELECT * FROM order_table ;

-- Daily Unique DANA users who transacted on Q3 2019 (July, August, September)
SELECT COUNT(DISTINCT(user_id)) AS Daily_Unique_DANA_users_on_Q3
FROM order_table
WHERE created_date >= '2019-07-01' AND created_date < '2019-10-1' ;

-- Daily Unique DANA users who transacted on Q3 2019 (July, August, September)
SELECT DISTINCT(user_id), COUNT(user_id) AS frequency
FROM order_table
WHERE created_date >= '2019-07-01' AND created_date < '2019-10-1'
GROUP BY user_id
ORDER BY frequency DESC ;

-- How many users transact in a certain frequency each week? (Transact 1 Time, Transact 2 Times, Transact 3 Times, Transact more than 3 Times)
WITH week_r AS (SELECT 
    DISTINCT to_char(created_date, '"WEEK NO :"IW (Month)') AS month_week,
    user_id,
    COUNT(user_id) AS frequency,  
    CASE 
        WHEN COUNT(user_id) = 1 THEN 'Transact 1 time'
        WHEN COUNT(user_id) = 2 THEN 'Transact 2 times'
        WHEN COUNT(user_id) = 3 THEN 'Transact 3 times'
        ELSE 'Transact more than 3 times'
    END AS cs
    FROM order_table
    WHERE created_date >= '2019-07-01' AND created_date < '2019-10-1'
    GROUP BY 1,2
    ORDER BY 1)

SELECT month_week,  COUNT(frequency) AS total_users, SUM(frequency) AS total_transaction, cs AS transaction_, ROW_NUMBER () OVER (PARTITION BY month_week ORDER BY cs)
FROM week_r
GROUP BY 1,4 ;

-- What merchant is the most used as first transaction in each month during Q3 2019 (provide merchant_id).
SELECT month_, merchant_id, total_first_transaction
FROM (
    SELECT DISTINCT (merchant_id), SUM(cnt) AS total_first_transaction, MAX(EXTRACT(month from first_trans)) AS Month_, ROW_NUMBER () OVER(PARTITION BY MAX(EXTRACT(month from first_trans)) ORDER BY SUM(cnt) DESC) AS row_num
    FROM (
          SELECT DISTINCT ON (user_id) created_date AS "first_trans", user_id, merchant_id, COUNT(merchant_id) AS cnt
          FROM order_table
          WHERE created_date >= '2019-07-01' AND created_date < '2019-10-1'
          GROUP BY created_date, user_id, merchant_id
          ORDER BY user_id, created_date
          ) AS q3 -- create table for q3 data only
    GROUP BY merchant_id
    ORDER BY month_, row_num ASC
    ) AS nested_table
WHERE row_num = 1 ;

-- Monthly transaction percentages between current Premium and Non Premium Users.
WITH joined_table AS (
    SELECT u.is_premium, CASE WHEN is_premium = 'true' THEN 1 ELSE 0 END AS bool_to_int, o.*
    FROM users_table AS u
    LEFT JOIN order_table AS o
    ON u.user_id = o.user_id
    WHERE o.user_id IS NOT NULL AND (o.created_date >= '2019-07-01' AND o.created_date < '2019-10-1')
    ) -- CREATE TEMPORARY TABLE

SELECT
    to_char(created_date, 'IYYY-Month') AS month_,
    count(nullif(is_premium, true)) * 100/ count(is_premium) AS not_premium_pctg,  -- count false values
    count(nullif(is_premium, false)) * 100/ count(is_premium) AS premium_pctg, -- count true values
    count(is_premium) AS total_users
from joined_table
GROUP BY month_ ;

-- Monthly Retention Rate (how many users back transacting again next monthafter transacting this month).
WITH temp_table AS (
    SELECT user_id, 
           DATE_TRUNC('Month', created_date) AS month_, 
           count(*) AS item_transactions, 
           LAG(DATE_TRUNC('Month', created_date)) OVER (PARTITION BY user_id ORDER BY DATE_TRUNC('Month', created_date)) = date_trunc('month', created_date) - interval '1 month'
           OR NULL AS repeat_transaction
    FROM order_table 
    WHERE created_date >= '2019-07-01' AND created_date < '2019-10-1'
    GROUP BY user_id, created_date
    ORDER BY 1,2
    )

SELECT month_, SUM(item_transactions) AS number_transaction, COUNT(DISTINCT user_id) AS number_users, COUNT(repeat_transaction) AS repeat_buyers
FROM temp_table
GROUP BY month_
ORDER BY month_ ;

       

