-- ===================================================================================
-- END-TO-END PIZZA PLACE SALES ANALYSIS - POSTGRESQL CODE
-- ===================================================================================


-- STEP 1: DATABASE SCHEMA & TABLE CREATION
-- ===================================================================================


create table pizzas 
 (pizza_id varchar primary key,
 pizza_type_id	varchar ,
 size varchar,
 price	numeric);	


 create table pizza_types
  ( pizza_type_id varchar,
   name varchar,
  category	varchar,
  ingredients	varchar(100));


  create table orders
  (order_id numeric primary key,
  date date,
  time	time);

  create table order_details
  (order_details_id	numeric,
  order_id numeric,
  pizza_id varchar,
  quantity numeric);

  select * from pizzas

  select * from pizza_types

  select * from orders

  select * from order_details

-- STEP 2: BUSINESS INSIGHTS & ANALYTICAL QUERIES
-- ================================================================================
  
-- q1: Total Revenue and Total Orders
   select count(distinct(o.order_id)) as total_orders, sum(p.price * o.quantity) as total_revenue 
   from pizzas p 
   join order_details o on p.pizza_id = o.pizza_id;


-- q2: Average Order Value - AOV
   select round(sum(p.price * o.quantity) / count(distinct(o.order_id)), 2) as average_order_value
   from order_details o
   join pizzas p  on p.pizza_id = o.pizza_id;


-- q3: Average Pizzas Per Order
   select round(sum(quantity)::numeric / count(distinct(order_id)::numeric),2) as avg_pizzas_per_order
   from order_details;
   

-- q4: Peak Days Analysis 
   select to_char(o.date, 'day') as weekday_name, count(distinct(o.order_id)) as total_orders,
   round(sum(p.price * od.quantity), 2) as total_revenue
   from orders o
   join order_details od on o.order_id = od.order_id
   join pizzas p on od.pizza_id = p.pizza_id
   group by weekday_name
   order by total_revenue desc;


-- q5: Peak Hours Analysis
   select extract(hour from time) as order_hour,
   count(distinct(order_id)) as total_orders
   from orders
   group by order_hour
   order by total_orders desc;

-- q6: Monthly Sales Trend
   select extract(month from o.date) as month_number,
   to_char(o.date, 'month') as month_name,
   count(distinct(o.order_id)) as total_orders,
   round(sum(p.price * od.quantity), 2) as total_revenue
   from orders o
   join order_details od on o.order_id = od.order_id
   join pizzas p on od.pizza_id = p.pizza_id
   group by month_number , month_name 
   order by month_number;

-- q7: Top 5 And Bottam 5 Pizzas by Revenue 
   select pt.name as pizza_name,
   round(sum(p.price * od.quantity), 2) as total_revenue
   from order_details od
   join pizzas p on od.pizza_id = p.pizza_id
   join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
   group by pizza_name
   order by total_revenue desc 
   limit 5;

   select pt.name as pizza_name,
   round(sum(p.price * od.quantity), 2) as total_revenue
   from order_details od
   join pizzas p on od.pizza_id = p.pizza_id
   join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
   group by pizza_name
   order by total_revenue asc
   limit 5;

-- q8: Top 5 And Bottam 5 Pizzas by Quantity Sold
    select pt.name as pizza_name,
   sum(od.quantity) as total_quantity_sold
   from order_details od
   join pizzas p on od.pizza_id = p.pizza_id
   join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
   group by pizza_name
   order by total_quantity_sold desc 
   limit 5;
   
   
    select pt.name as pizza_name,
   sum(od.quantity) as total_quantity_sold
   from order_details od
   join pizzas p on od.pizza_id = p.pizza_id
   join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
   group by pizza_name
   order by total_quantity_sold asc 
   limit 5;

-- q9: Percentage Sales by Pizza Category using Window Function
   select pt.category as pizza_category,
   round(sum(p.price * od.quantity), 2) as total_revenue,
   round(sum(p.price * od.quantity) / sum(sum(p.price * od.quantity)) over() * 100,2) as revenue_percentage
   from order_details od
   join pizzas p on od.pizza_id = p.pizza_id
   join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
   group by pt.category
   order by total_revenue desc;

-- q10: Total Pizzas Sold by Pizza Size
   select p.size as pizza_size,
   sum(od.quantity) as total_quantity_sold,
   round(sum(p.price * od.quantity), 2) as total_revenue
   from order_details od
   join pizzas p on od.pizza_id = p.pizza_id
   group by pizza_size
   order by total_quantity_sold desc;
   		