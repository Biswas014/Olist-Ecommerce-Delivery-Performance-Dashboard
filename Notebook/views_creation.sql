
select * from orders
select * from customers
select * from category_english

--creating view for order_items
drop view if exists fact_order_items;
create view fact_order_items as(
   select ot.order_id,
		  ot.product_id,
		  ot.seller_id,
		  CAST(ot.shipping_limit_date AS DATE),
		  CAST(o.order_delivered_carrier_date AS DATE),
		  date_part('days',age(o.order_delivered_carrier_date, ot.shipping_limit_date)) as days_gap,
		  ot.price,
		  ot.freight_value,
		  case when s.seller_state = c.customer_state then 'Interstate'
		     else 'Intrastate'
			 end as state_match_type
  from order_items ot
  join orders o on o.order_id = ot.order_id
  join sellers s on s.seller_id = ot.seller_id
  join customers c on c.customer_id = o.customer_id
);

-- select * from fact_order_items;

--checking does the dataset have orders where estimated shipping time are less than the actual carrier date
select o.order_id,
       cast(o.order_delivered_carrier_date as date),
	   cast(ot.shipping_limit_date as date),
	   (cast(o.order_delivered_carrier_date as date) - cast(ot.shipping_limit_date as date)) as days_gap
from order_items ot
left join orders o
on o.order_id = ot.order_id
where cast(o.order_delivered_carrier_date as date) > cast(ot.shipping_limit_date as date)

--creating view for reviews
drop view if exists dim_reviews;
create view dim_reviews as(
   select review_id,
		  order_id,
		  review_score
  from reviews
);

-- select * from dim_reviews;

--creating view for sellers
drop view if exists dim_sellers;
create view dim_sellers as(
   select seller_id,
		  seller_city,
		  seller_state
  from sellers
);

-- select * from dim_sellers;

--creating view for customers
drop view if exists dim_customers;
create view dim_customers as(
   select customer_id,
          customer_city,
		  customer_state
  from customers
);

-- select * from dim_customers;

--creating view for products
drop view if exists dim_products;
create view dim_products as(
   select p.product_id,
          case when p.product_category_name is null then 'Unknown'
		  else ce.product_category_name_english
		  end as product_category,
		  p.product_weight_g,
		  case when product_weight_g >= 40000 then '>40kg'
	   when p.product_weight_g >= 35000  and p.product_weight_g < 40000 then '35-40kg'
	   when p.product_weight_g >= 30000  and p.product_weight_g < 35000 then '30-35kg'
	   when p.product_weight_g >= 25000  and p.product_weight_g < 30000 then '25-30kg'
	   when p.product_weight_g >= 20000  and p.product_weight_g < 25000 then '20-25kg'
	   when p.product_weight_g >= 15000  and p.product_weight_g < 20000 then '15-20kg'
	    when p.product_weight_g >= 10000  and p.product_weight_g < 15000 then '10-15kg'
		 when p.product_weight_g >= 5000  and p.product_weight_g < 10000 then '5-10kg'
		  when p.product_weight_g >= 1000  and p.product_weight_g < 5000 then '1-5kg'
		  else '<1kg'
		  end as weight_range
  from products p
  left join category_english ce
  on p.product_category_name = ce.product_category_name
);

-- select * from dim_products where product_category = 'Unknown';

--creating view for transactions
drop view if exists transactions;
create view transactions as(
   select order_id,
          customer_id,
		  order_status,
		  CAST(order_purchase_timestamp AS DATE),
		  CAST(order_approved_at AS DATE),
		  CAST(order_delivered_carrier_date AS DATE),
		  CAST(order_delivered_customer_date AS DATE),
		  CAST(order_estimated_delivery_date AS DATE),
		  date_part('days',age(order_delivered_customer_date ,order_purchase_timestamp)) as lead_time,
		  date_part('days',age(order_delivered_carrier_date ,order_approved_at)) as dispatch_time,
		  date_part('days',age(order_delivered_customer_date ,order_delivered_carrier_date)) as transit_time,
		  case when date_part('days',age(order_delivered_customer_date ,order_estimated_delivery_date)) <=0 
		       then 'On_Time'
			   else 'Delayed'
		  end as Delivery_Type
  from (select *
from(
select *,
       case when order_approved_at > order_delivered_carrier_date or
	    order_approved_at > order_delivered_customer_date or
		order_approved_at > order_estimated_delivery_date or
		order_delivered_carrier_date > order_delivered_customer_date or
		order_purchase_timestamp > order_delivered_carrier_date then 'not_possible'
		else 'possible'
		end as dates_overlaping,
       case when (order_approved_at is null or order_delivered_customer_date is null or
	     order_delivered_carrier_date is null) and order_status = 'delivered' then 'unimagined'
		else 'imagined'
	   end as null_possiblity
from orders
) where dates_overlaping = 'possible' and null_possiblity = 'imagined'
)
)

--select * from transactions

-- checking whether the above view working or not
select order_id,
          customer_id,
		  order_status,
		  order_purchase_timestamp,
		  order_approved_at,
		  order_delivered_carrier_date,
		  order_delivered_customer_date,
		  order_estimated_delivery_date
from transactions
where order_delivered_carrier_date is null and order_status = 'delivered'

-- select * from dim_calendar order by date desc

---------
--extra stuff to ensure everything before creating views
select count(*)
 from orders
  where order_approved_at > order_delivered_carrier_date
  
---------
select order_item_id,
       count(distinct order_id)
from order_items
group by order_item_id
order by order_item_id asc

select order_id,
       count(order_item_id) as items,
	   max(order_item_id) as highest_no_items,
	   count(product_id) as no_products
from order_items
group by order_id
having count(product_id) >1  
order by order_id asc
------

select customer_id,
       count(customer_unique_id) 
from customers
group by customer_id
having count(customer_unique_id) >1
--no records. that means customer_id and it's unique id are not smiliar but unique for each one
--------
select min(product_weight_g),
      max(product_weight_g)
from products
where product_weight_g !=0

select distinct product_weight_g
from products 
where product_weight_g !=0
order by product_weight_g asc
limit 3;

select distinct product_weight_g
from products 
where product_weight_g !=0

select distinct product_weight_g
from products 
order by product_weight_g desc
