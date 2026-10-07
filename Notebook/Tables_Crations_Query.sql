--creating the tables
DROP TABLE IF EXISTS customers;

CREATE TABLE customers(
    customer_id	VARCHAR(50),
	customer_unique_id	VARCHAR(50),
	customer_zip_code_prefix	INT,
	customer_city	VARCHAR(50),
	customer_state	VARCHAR(5)
);
------------------------
DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
    order_id	VARCHAR(50),
	customer_id	VARCHAR(50),
	order_status	VARCHAR(20),
	order_purchase_timestamp	TIMESTAMP,
	order_approved_at	TIMESTAMP,
	order_delivered_carrier_date	TIMESTAMP,
	order_delivered_customer_date	TIMESTAMP,
	order_estimated_delivery_date	TIMESTAMP
);
------------------------
DROP TABLE IF EXISTS products;
CREATE TABLE products(
    product_id	VARCHAR(50),
	product_category_name	VARCHAR(50),
	product_name_lenght	SMALLINT,
	product_description_lenght	SMALLINT,
	product_photos_qty	SMALLINT,
	product_weight_g	INT,
	product_length_cm	INT,
	product_height_cm	SMALLINT,
	product_width_cm	SMALLINT
);
------------------------
DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items(
	order_id	VARCHAR(50),
	order_item_id	SMALLINT,
	product_id	VARCHAR(50),
	seller_id	VARCHAR(50),
	shipping_limit_date	TIMESTAMP,
	price	DECIMAL(6,2),
	freight_value	DECIMAL(6,2)
);
------------------------
DROP TABLE IF EXISTS sellers;
CREATE TABLE sellers(
	seller_id	VARCHAR(50),
	seller_zip_code_prefix	INT,
	seller_city	VARCHAR(50),
	seller_state	VARCHAR(5)
);
------------------------
--creating a temporary table for storing reviews dataset temporarily
create temporary table t(
 review_id	varchar(50),
	order_id	varchar(50),
	review_score	smallint,
	review_comment_title	varchar(50),
	review_comment_message	varchar(500),
	review_creation_date	timestamp,
	review_answer_timestamp	timestamp
)
------------------------
DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews(
	 review_id	varchar(50),
	order_id	varchar(50),
	review_score	smallint,
	review_comment_title	varchar(50),
	review_creation_date	timestamp,
	review_answer_timestamp	timestamp
);
------------------------
DROP TABLE IF EXISTS category_english;
CREATE TABLE category_english(
   product_category_name	varchar(50),
   product_category_name_english	varchar(50)
);
------------------------
--inserting the records into the tables
COPY products
FROM 'E:\Projects\Portfolio_Projects\sql, power bi\Olist_Brazilian_Ecommerce\olist_products.csv'
DELIMITER ','
CSV HEADER

-- select * from products
------------------------
COPY customers
FROM 'E:\Projects\Portfolio_Projects\sql, power bi\Olist_Brazilian_Ecommerce\olist_customers.csv'
DELIMITER ','
CSV HEADER

-- select * from customers
------------------------
COPY orders
FROM 'E:\Projects\Portfolio_Projects\sql, power bi\Olist_Brazilian_Ecommerce\olist_orders.csv'
DELIMITER ','
CSV HEADER

-- select * from orders
------------------------
COPY order_items
FROM 'E:\Projects\Portfolio_Projects\sql, power bi\Olist_Brazilian_Ecommerce\olist_order_items.csv'
DELIMITER ','
CSV HEADER

-- select * from order_items
------------------------
COPY sellers
FROM 'E:\Projects\Portfolio_Projects\sql, power bi\Olist_Brazilian_Ecommerce\olist_sellers.csv'
DELIMITER ','
CSV HEADER

-- select * from sellers
------------------------
COPY category_english
FROM 'E:\Projects\Portfolio_Projects\sql, power bi\Olist_Brazilian_Ecommerce\product_category_translation.csv'
DELIMITER ','
CSV HEADER

-- select * from category_english
------------------------
copy t
from 'E:\Projects\Portfolio_Projects\sql, power bi\Olist_Brazilian_Ecommerce\olist_order_reviews.csv'
delimiter ','
csv header
------------------------

--taking only the necessary columns from the reviews
INSERT INTO reviews(review_id,order_id,review_score, review_comment_title, review_creation_date,review_answer_timestamp)
select review_id,order_id,review_score, review_comment_title, review_creation_date,review_answer_timestamp
from t

-- select * from reviews