-- RESTAURANT ORDER ANALYSIS

-- OBJECTIVE 1 
-- Explore the items table

-- View the menu_items table and write a query to find the number of items on the menu 
SELECT 
 *
FROM
  menu_items;
  
SELECT COUNT(item_name) AS item_count 
FROM menu_items;

-- What are the least and most expensive items on the menu? 
SELECT 
    item_name, price
FROM
    menu_items
ORDER BY price ASC;
SELECT 
    item_name, price
FROM
    menu_items
ORDER BY price DESC;

-- How many Italian dishes are on the menu? 
SELECT 
    COUNT(category) AS italian_dishes_count
FROM
    menu_items
WHERE
    category = 'Italian';

-- What are the least and most expensive Italian dishes on the menu?
SELECT 
    item_name, price AS most_expensive_italian_dish
FROM
    menu_items
WHERE
    category = 'italian'
ORDER BY price DESC;

SELECT 
    item_name, price AS least_expensive_italian_dish
FROM
    menu_items
WHERE
    category = 'italian'
ORDER BY price ASC;

-- How many dishes are in each category? 
SELECT 
    category, COUNT(*) AS item_dish_count
FROM
    menu_items
GROUP BY category;

-- What is the average dish price within each category? 
SELECT 
    category, AVG(price) AS avg_price
FROM
    menu_items
GROUP BY category;

-- OBJECTIVE 2
-- Explore the orders table

-- View the order_details table. What is the date range of the table? 
SELECT
    MIN(order_date) AS start_date, MAX(order_date) AS end_date
FROM
    order_details;
    
-- How many orders were made within this date range? 
SELECT 
    COUNT(order_id) AS order_count
FROM
    order_details
WHERE
    order_date BETWEEN (SELECT 
            MIN(order_date)
        FROM
            order_details) AND (SELECT 
            MAX(order_date)
        FROM
            order_details);

-- How many items were ordered within this date range?
SELECT 
    COUNT(item_id) AS items_ordered_count
FROM
    order_details
WHERE
    order_date BETWEEN (SELECT 
            MIN(order_date)
        FROM
            order_details) AND (SELECT 
            MAX(order_date)
        FROM
            order_details);
            
-- Which orders had the most number of items? 

SELECT 
    order_id, COUNT(item_id) AS items_count
FROM
    order_details
GROUP BY order_id
ORDER BY items_count DESC;

-- How many orders had more than 12 items?
SELECT 
    COUNT(*) AS orders_with_more_than_12_items
FROM
    (SELECT 
        order_id, COUNT(item_id) AS items_count
    FROM
        order_details
    GROUP BY order_id
    HAVING items_count > 12) AS subquery;
    
    -- OBJECTIVE 3 
-- Analyze customer behavior 

-- Combine the menu_items and order_details tables into a single table 

SELECT*
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id;

-- What were the least and most ordered items? What categories were they in?
-- Most Ordered Item
SELECT 
    mi.item_name, mi.category, COUNT(od.item_id) AS order_count
FROM
    order_details od
        INNER JOIN
    menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name , mi.category
ORDER BY order_count DESC
LIMIT 1;

-- Least Ordered Item
SELECT 
    mi.item_name, mi.category, COUNT(od.item_id) AS order_count
FROM
    order_details od
        INNER JOIN
    menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name , mi.category
ORDER BY order_count ASC
LIMIT 1;

-- What were the top 5 orders that spent the most money?
SELECT 
    od.order_id, SUM(mi.price) AS total_spent
FROM
    order_details od
        INNER JOIN
    menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY od.order_id
ORDER BY total_spent DESC
LIMIT 5;

-- View the details of the highest spend order. Which specific items were purchased?
 -- Identify the highest spend order
 SELECT 
    od.order_id, SUM(mi.price) AS total_spent
FROM
    order_details od
        INNER JOIN
    menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY od.order_id
ORDER BY total_spent DESC
LIMIT 1;

-- View details of the highest spend order
SELECT 
    od.order_id, mi.item_name, mi.category, mi.price
FROM
    order_details od
        INNER JOIN
    menu_items mi ON od.item_id = mi.menu_item_id
WHERE
    od.order_id = (SELECT 
            order_id
        FROM
            (SELECT 
                od.order_id, SUM(mi.price) AS total_spent
            FROM
                order_details od
            INNER JOIN menu_items mi ON od.item_id = mi.menu_item_id
            GROUP BY od.order_id
            ORDER BY total_spent DESC
            LIMIT 1) AS highest_order);
            
	-- END 


 







    
    
