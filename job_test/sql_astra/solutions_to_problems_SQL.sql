/* 
note : For the solution I am querying using MYSQL ver. 8.
*/

# Problem 1 : Top 3 Province with the mose bad customer
SELECT provinces_name, COUNT(is_bad_cust) AS total_bad_cust
FROM Astra_data
GROUP BY provinces_name
ORDER BY total_bad_cust DESC
LIMIT 3;

# Problem 2 : Top 3 provinces with the most Upsells
SELECT provinces_name,
CASE 
	WHEN first_bu = second_bu AND (first_bu AND second_bu) is NOT NULL THEN 'Up Sell'
    ELSE 'Cross Sell'
END AS strategy, 
COUNT(CASE 
	WHEN first_bu = second_bu AND (first_bu AND second_bu) is NOT NULL THEN 'Up Sell'
    ELSE 'Cross Sell'
END) AS total
FROM Astra_data
WHERE first_bu = second_bu
GROUP BY provinces_name
ORDER BY total DESC
LIMIT 3;

# Problem 2 : Top 3 provinces with the most Cross-sells
SELECT provinces_name,
CASE 
	WHEN first_bu = second_bu AND (first_bu AND second_bu) is NOT NULL THEN 'Up Sell'
    ELSE 'Cross Sell'
END AS strategy, 
COUNT(CASE 
	WHEN first_bu = second_bu AND (first_bu AND second_bu) is NOT NULL THEN 'Up Sell'
    ELSE 'Cross Sell'
END) AS total
FROM Astra_data
WHERE first_bu != second_bu
GROUP BY provinces_name
ORDER BY total DESC
LIMIT 3;

# Problem 3 : Monthly Gross Transaction Value (GTV)
SELECT year_, month_, SUM(asset_price ) as GTV , 'Price in million (x10^6)' AS unit
FROM (
	SELECT YEAR(a.first_go_live_date) AS year_ ,MONTH(a.first_go_live_date) AS month_, a.first_asset_price AS asset_price
    FROM mytable AS a
UNION ALL
	SELECT YEAR(b.second_go_live_date) AS year_, MONTH(b.second_go_live_date) AS month_, b.second_asset_price  AS asset_price
FROM mytable AS b) AS c
GROUP BY year_, month_
ORDER BY year_, month_

