-- first
SELECT DISTINCT (COUNT('Customer ID')) AS "Number of customers", "Country"
FROM online_retail
GROUP BY "Country"
ORDER BY 1 DESC


-- second
SELECT DISTINCT ("StockCode"), "Description", COUNT(*) AS "Order Frequency"
FROM online_retail
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10
