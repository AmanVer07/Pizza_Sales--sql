-- Retrive the total no of orders placed.
use pizzahut;
SELECT 
    COUNT(order_id) AS 'Total_Orders'
FROM
    orders;
    
    
-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(p.price * o.quantity)) AS 'Total_Revenue'
FROM
    pizzas AS p
        LEFT JOIN
    order_details AS o ON p.pizza_id = o.pizza_id;
    
-- Identify the highest-priced pizza.
SELECT 
    p2.price AS 'Highest_Price', p.name
FROM
    pizza_types AS p
        JOIN
    pizzas AS p2 ON p.pizza_type_id = p2.pizza_type_id
ORDER BY Highest_Price DESC
LIMIT 1;


-- Identify the most common pizza size ordered.
SELECT 
    p.size, COUNT(*) AS 'Max_cnt'
FROM
    pizzas AS p
        JOIN
    order_details AS o ON p.pizza_id = o.pizza_id
GROUP BY p.size
ORDER BY Max_cnt DESC
LIMIT 1;


-- List the top 5 most ordered pizza types along with their quantities.

SELECT 
    p.name, SUM(o.quantity) AS 'Qty'
FROM
    pizza_types AS p
        JOIN
    pizzas AS p1 ON p.pizza_type_id = p1.pizza_type_id
        JOIN
    order_details AS o ON o.pizza_id = p1.pizza_id
GROUP BY p.name
ORDER BY Qty DESC
LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    p1.category, SUM(o.quantity) AS 'qty'
FROM
    pizza_types AS p1
        JOIN
    pizzas AS p2 ON p1.pizza_type_id = p2.pizza_type_id
        JOIN
    order_details AS o ON p2.pizza_id = o.pizza_id
GROUP BY p1.category
ORDER BY qty DESC;


-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time) AS 'Hr', COUNT(order_id) AS 'cnt'
FROM
    orders
GROUP BY Hr;

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(*)
FROM
    pizza_types
GROUP BY category;



-- Group the orders by date and calculate the average number of pizzas ordered per day
use pizzahut;

WITH daily_order AS (SELECT 
        o.order_date, SUM(o1.quantity) AS 'quantity'
    FROM
        orders AS o
    JOIN order_details AS o1 ON o.order_id = o1.order_id
    GROUP BY order_date)
    
SELECT AVG(quantity) FROM daily_order;


-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    p.name, ROUND(SUM(o.quantity * p1.price)) AS 'Revenue'
FROM
    pizza_types AS p
        JOIN
    pizzas AS p1 ON p.pizza_type_id = p1.pizza_type_id
        JOIN
    order_details AS o ON p1.pizza_id = o.pizza_id
GROUP BY p.name
ORDER BY Revenue DESC
LIMIT 3;


-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    p.name,
    ROUND(SUM(p1.price * o.quantity)) * 100 / (SELECT 
            ROUND(SUM(p1.price * o.quantity), 2)
        FROM
            pizzas AS p1
                JOIN
            order_details AS o ON p1.pizza_id = o.pizza_id) AS 'per_revenue'
FROM
    pizza_types AS p
        JOIN
    pizzas AS p1 ON p.pizza_type_id = p1.pizza_type_id
        JOIN
    order_details AS o ON p1.pizza_id = o.pizza_id
GROUP BY p.name;

/*Analyze the cumulative revenue generated over time.*/

SELECT order_date,
SUM(revenue) OVER(ORDER BY order_date) AS cum_revenue
FROM 
(SELECT orders.order_date,
SUM(order_details.quantity * pizzas.price) AS revenue
FROM order_details JOIN pizzas 
ON order_details.pizza_id = pizzas.pizza_id
JOIN orders
ON orders.order_id = order_details.order_id
GROUP BY orders.order_date) AS sales;

/*Determine the top 3 most ordered pizza types based on revenue for each pizza category.*/

SELECT order_date,
SUM(revenue) OVER(ORDER BY order_date) AS cum_revenue
FROM 
(SELECT orders.order_date,
SUM(order_details.quantity * pizzas.price) AS revenue
FROM order_details JOIN pizzas 
ON order_details.pizza_id = pizzas.pizza_id
JOIN orders
ON orders.order_id = order_details.order_id
GROUP BY orders.order_date) AS sales;
 