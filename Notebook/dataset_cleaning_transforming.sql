--1. nulls & duplicates checking

-- a)for orders tbl
select * from orders

select order_id,
       count(*)
from orders
group by order_id
having count(*) >1

select * 
from orders
where order_id is null or 
      customer_id is null or
	  order_status is null or 
	  order_purchase_timestamp is null or 
	  order_approved_at is null or
	  order_delivered_carrier_date is null or
	  order_delivered_customer_date is null or
	  order_estimated_delivery_date is null

--orders table has nulls specifically in date columns(approv,deliver_car,delive_cus)

-- b)for orders items tbl
select * from order_items

select * 
from order_items
where order_id is null or 
      order_item_id is null or
	  seller_id is null or 
	  shipping_limit_date is null or 
	  price is null or
	  freight_value is null

-------------
-- c)for products tbl
select * from products

select product_id,
       count(*)
from products
group by product_id
having count(*) >1

select * 
from products
where product_id is null or
      product_category_name is null or
	  product_name_lenght is null or 
	  product_description_lenght is null or 
	  product_photos_qty is null or
	  product_weight_g is null or
	  product_length_cm is null or
	  product_height_cm is null or
	  product_width_cm is null 

--nulls available in all columns except (product_id)
--------------
--d)for seller tbl
select seller_id,
       count(*)
from sellers
group by seller_id
having count(*) >1

select * 
from sellers
where seller_id is null or
      seller_zip_code_prefix is null or
	  seller_city is null or 
	  seller_state is null 

--------
--e)for reviews tbl

select review_id,
       count(*)
from reviews
group by review_id
having count(*) >1

--duplicates found in review id

select * 
from reviews
where review_id is null or
      order_id is null or
	  review_score is null or 
	  review_creation_date is null or
	  review_answer_timestamp is null or
	  review_comment_title is null 

--nulls exist in comment_title

-----------
--f)for customers tbl

select customer_id,
       count(*)
from customers
group by customer_id
having count(*) >1


select * 
from customers
where customer_id is null or
      customer_unique_id is null or
	  customer_zip_code_prefix is null or 
	  customer_city is null or
	  customer_state is null

--------------
--g)for category_eng tbl
select * from category_english
where product_category_name is null or
      product_category_name_english is null
 
--2. checking whether the dates are consistent 
-- for order purchase timestamp
select *
from orders
where order_purchase_timestamp > order_delivered_carrier_date

select count(*),
    round(count(*) * 100.0 /(select count(*) from orders),2)
from orders
where order_purchase_timestamp > order_delivered_carrier_date 
-- 0.17% of total
------------------
select *
from orders
where order_purchase_timestamp > order_delivered_customer_date

select *
from orders
where order_purchase_timestamp > order_estimated_delivery_date

--------------
-- for approve_at dt
select * 
from orders
where order_approved_at < order_purchase_timestamp 

select * 
from orders
where order_approved_at > order_delivered_carrier_date

select count(*),
      round(count(*) * 100.0 /(select count(*) from orders),2) 
from orders
where order_approved_at > order_delivered_carrier_date
-- 1.37% of total 
-----------------
select * 
from orders
where order_approved_at > order_delivered_carrier_date

select * 
from orders
where order_approved_at > order_delivered_customer_date

select count(*),
      round(count(*) * 100.0 /(select count(*) from orders),2)  
from orders
where order_approved_at > order_delivered_customer_date
--0.06% of total
-------------

select * 
from orders
where order_approved_at > order_estimated_delivery_date
      and order_approved_at < order_delivered_customer_date
	  
select  count(*),
      round(count(*) * 100.0 /(select count(*) from orders),2)   
from orders
where order_approved_at > order_estimated_delivery_date
--0.01% of total
------------

-- for order_delivered_carrier_date
select * 
from orders
where order_delivered_carrier_date > order_estimated_delivery_date

select count(*),
       round(count(*) * 100.0 /(select count(*) from orders),2)    
from orders
where order_delivered_carrier_date > order_estimated_delivery_date
--it's possible (0.48% of total)
----------
select * 
from orders
where order_delivered_carrier_date > order_delivered_customer_date

select count(*),
      round(count(*) * 100.0 /(select count(*) from orders),2) 
from orders
where order_delivered_carrier_date > order_delivered_customer_date
--0.02% of total
----------

--checking common date format
select count(*)
from orders
where order_purchase_timestamp :: text !~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$'
      and order_purchase_timestamp is not null

select count(*)
from orders
where order_approved_at :: text !~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$'
      and order_approved_at is not null
	  
select count(*)
from orders
where order_delivered_carrier_date :: text !~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$'
      and order_delivered_carrier_date is not null

select count(*)
from orders
where order_estimated_delivery_date :: text !~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$'
      and order_estimated_delivery_date is not null

select count(*)
from orders
where order_delivered_customer_date :: text !~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$'
      and order_delivered_customer_date is not null



-- checking any other type of inconsistencies on other categorical columns
select distinct order_status 
from orders
--------
select order_item_id,
       price
from order_items
where price <= 0 

select order_item_id,
       freight_value
from order_items
where freight_value <= 0

select round(count(*) * 100.0 /(select count(*) from orders),2)
from order_items
where freight_value <= 0
--0.39% of total
------------
select * from reviews

select distinct review_score 
from reviews
----------
select * from sellers

select distinct seller_city 
from sellers

select *
from sellers
where trim(seller_city) != seller_city

select distinct seller_state
from sellers

select *
from sellers
where trim(seller_state) != seller_state

---------
select * from customers

select distinct customer_city 
from customers

select *
from customers
where trim(customer_city) != customer_city

select distinct customer_state
from customers

select *
from customers
where trim(customer_state) != customer_state

--------
select * from products

select distinct product_category_name
from products

select *
from products
where trim(product_category_name) != product_category_name

select count(*) 
from products
where product_weight_g <= 0
--4 products

---------------
-- nulls handling
select distinct order_status 
from orders
where  order_delivered_carrier_date is null   --except 'shipped', all 7
-- problem - only delivered order status (for the rest, it can have)

select count(*)
from orders
where order_delivered_carrier_date is null and order_status = 'delivered'
-- result - 2
---------
select distinct order_status 
from orders
where order_approved_at is null  -- cancell, created, delive
-- problem - only delivered order status (for the rest, it can have)

select count(*)
from orders
where order_approved_at is null and order_status = 'delivered'
-- result - 14
------------
select distinct order_status 
from orders
where order_delivered_customer_date is null  --8 status 
--problem - only delivered order status (for the rest, it can have)

select count(*)
from orders
where order_delivered_customer_date is null and order_status = 'delivered'
-- result - 8
---------

-- check problems in products tbl
select product_id,
      product_weight_g
from products
where product_weight_g <=0 ;

select * from products

select round(count(*) *100.0 / (select count(*)from products),2)
from products
where product_category_name is null
--1.85% rows have blank product category

select round(count(*) *100.0 / (select count(*)from products),2)
from products
where product_weight_g is null
--0.01% rows have blank product product weight

select round(count(*) *100.0 / (select count(*)from products),2)
from products
where product_weight_g is null and product_category_name is null
--0% of total