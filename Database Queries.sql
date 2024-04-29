/* These queries can be used to build interactive visualizations in Metabase for Analysts and C-Level, allowing executives to click through different metrics, filter results, and get a real-time snapshot of the company's performance.*/


/* 1) Revenue streams: Sales and Rent */
SELECT 
  date_trunc('month', date) AS Month, 
  transactiontype, 
  SUM(amount) AS Total_Revenue
FROM 
  past_transactions
GROUP BY 
  Month, 
  transactiontype
ORDER BY 
  Month;

/* 2) Insights into how home prices vary with size, which can inform strategic pricing, investment, and marketing decisions.*/

SELECT
  FLOOR(squarefootage / 1250.0) * 1250 AS SquareFootageRange,
  COUNT(*) AS Count,
  AVG(price) AS AveragePrice
FROM
  homes_listings
GROUP BY
  SquareFootageRange
ORDER BY
  SquareFootageRange ASC;

/* 3) Rank employees by their sales performance.
Aiding C-suite executives in identifying top performers and making informed decisions on personnel management and resource allocation. */

SELECT
  RANK() OVER (ORDER BY SUM(p.amount) DESC) AS rank,
  e.firstname || ' ' || e.lastname AS fullname,
  COUNT(p.transactionid) AS transactions_count,
  SUM(p.amount) AS total_value
FROM
  employees e
JOIN
  past_transactions p ON e.employeeid = p.employeeid
GROUP BY
  e.employeeid, e.firstname, e.lastname
ORDER BY
  total_value DESC
LIMIT 15;


/* 4) Added value of various amenities to home prices, which can guide marketing strategies, property development decisions, and investment priorities.   
This query assists analysts and C-suite executives: */

SELECT
  ha.homeid AS home_id,
  COUNT(*) AS amenities_count,
  AVG(hl.price) AS average_price
FROM
  home_id_amenities ha
JOIN
  homes_listings hl ON ha.homeid = hl.homeid
GROUP BY
  ha.homeid
ORDER BY
  average_price DESC, 
  ha.homeid ASC;

/* 5) Revenue breakdown by home type and status */

SELECT
  bedroomcount,
  bathroomcount,
  status,
  AVG(price) AS average_price,
  SUM(price) AS total_revenue,
  COUNT(*) AS number_of_homes
FROM
  homes_listings
GROUP BY
  bedroomcount, bathroomcount, status
ORDER BY
  bedroomcount, bathroomcount, status;

/* 6) Average time to sell by listing months. 

This helps understand the market dynamics by showing how long, on average, properties take to sell during different months, which can influence listing strategies, marketing efforts, and cash flow projections.*/

WITH SoldHomes AS (
  SELECT
    hl.homeid,
    hl.listingdate,
    MIN(pt.date) AS solddate
  FROM
    homes_listings hl
  JOIN
    past_transactions pt ON hl.homeid = pt.homeid AND pt.transactiontype = 'Sale'
  GROUP BY
    hl.homeid, hl.listingdate
)
SELECT
  EXTRACT(month FROM listingdate) AS listing_month,
  AVG(solddate - listingdate) AS average_days_on_market
FROM
  SoldHomes
GROUP BY
  listing_month
ORDER BY
  listing_month;

/* 7) Most valuable customers based on transaction type */ 

SELECT
  buyerid,
  COUNT(transactionid) AS transactions_count,
  SUM(amount) AS total_spent,
  AVG(amount) AS average_spent_per_transaction
FROM
  past_transactions
WHERE
  transactiontype = 'Sale'
GROUP BY
  buyerid
HAVING
  COUNT(transactionid) > 1
ORDER BY
  total_spent DESC
LIMIT 10;

/* 8) Year-over-Year sales growth.
Crucial for C-suite executives as it provides a clear indication of the company's growth and business trends over time.
*/

WITH YearlySales AS (
  SELECT
    o.officeid,
    o.officename,
    EXTRACT(year FROM pt.date) AS year,
    SUM(pt.amount) AS total_sales
  FROM
    offices o
  JOIN employees e ON o.officeid = e.officeid
  JOIN past_transactions pt ON e.employeeid = pt.employeeid AND pt.transactiontype = 'Sale'
  GROUP BY
    o.officeid, o.officename, year
)
SELECT
  ys1.officename,
  ys1.year AS year,
  ys1.total_sales AS sales_this_year,
  ys2.total_sales AS sales_last_year,
  (ys1.total_sales - ys2.total_sales) / ys2.total_sales * 100.0 AS growth_percentage
FROM
  YearlySales ys1
JOIN YearlySales ys2 ON ys1.officeid = ys2.officeid AND ys1.year = ys2.year + 1
ORDER BY
  growth_percentage DESC;

/* 9) Amenity popularity and impact on sale prices  */

SELECT 
  a.amenitytype, 
  COUNT(*) AS Number_of_Homes, 
  AVG(hl.price) AS Average_Sale_Price
FROM 
  amenities a
  JOIN home_id_amenities hia ON a.amenityid = hia.amenityid
  JOIN homes_listings hl ON hia.homeid = hl.homeid AND hl.status = 'Sold'
GROUP BY 
  a.amenitytype
ORDER BY 
  Average_Sale_Price DESC;

/* 10) Correlation between the number of open houses and subsequent sales for listings  */ 

SELECT 
  hl.homeid,
  COUNT(oh.openhouseid) AS NumberOfOpenHouses,
  SUM(CASE WHEN pt.transactiontype = 'Sale' THEN 1 ELSE 0 END) AS SalesCount,
  SUM(CASE WHEN pt.transactiontype = 'Sale' THEN pt.amount ELSE 0 END) AS TotalSalesValue
FROM 
  homes_listings hl
  LEFT JOIN open_houses oh ON hl.homeid = oh.homeid
  LEFT JOIN past_transactions pt ON hl.homeid = pt.homeid AND pt.transactiontype = 'Sale'
WHERE 
  hl.status = 'Sold'
GROUP BY 
  hl.homeid
ORDER BY 
  NumberOfOpenHouses DESC, 
  SalesCount DESC;

/* 11) Find Agents with the Most Client Appointments
This query retrieves the top agents with the highest number of client appointments. */

SELECT
    e.employeeid,
    e.firstname || ' ' || e.lastname AS agent_name,
    COUNT(a.appointmentid) AS total_appointments
FROM
    employees e
    JOIN appointments a ON e.employeeid = a.employeeid
GROUP BY
    e.employeeid, e.firstname, e.lastname
ORDER BY
    total_appointments DESC
LIMIT 5;

/* 12) Total sales volume by agent with office details on a monthly basis  */

SELECT 
  EXTRACT(YEAR FROM pt.date) AS sale_year, 
  EXTRACT(MONTH FROM pt.date) AS sale_month,
  e.employeeid, 
  CONCAT(e.firstname, ' ', e.lastname) AS agent_name, 
  o.officename,
  SUM(pt.amount) AS monthly_sales_volume
FROM 
  employees e
JOIN 
  offices o ON e.officeid = o.officeid
JOIN 
  past_transactions pt ON e.employeeid = pt.sellerid
WHERE 
  pt.transactiontype = 'Sale'
GROUP BY 
  sale_year, sale_month, e.employeeid, o.officename
ORDER BY 
  sale_year, sale_month, monthly_sales_volume DESC;


