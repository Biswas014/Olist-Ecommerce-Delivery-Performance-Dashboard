# Olist-Ecommerce-Delivery-Performance-Dashboard
An end-to-end data analytics project using SQL and Power BI, exploring the order fulfillment and delivery journey from 2016 to 2018.

## Project Overview
Olist is a Brazilian e-commerce platform that acts as a marketplace aggregator and software service, making it easy for small businesses to connect with external marketplaces.
I explored the movement of their orders by analyzing the possible factors and patterns associated with delivery delays and examining how delivery performance changes across shipping status, delivery scope, and geographical differences over different years, quarters, and months.

## Business Problem
The raw dataset does not provide a structured view of delivery performance, making it difficult to identify how frequently orders are delivered late and what factors may be associated with delivery delays.

Some of the questions answered

•	Is there any specific product category, city or product weight range where number of delayed orders are comparatively higher than in other segments?

•	Is late dispatch associated with delayed delivery?

•	Is the difference between the customer and seller states associated with delivery delays, and how does average delivery time vary between same-state and cross-state orders?

•	Is higher order volume across customer states associated with higher delivery delay rates?

•	Do delivery delays spike during particular months or quarters, and do these periods also show higher average delivery times?

## Key Findings

1. Seller-side performance

Late dispatch raises delay risk: Orders dispatched late by the seller were about four times more likely to be delivered late, 20.5% against 5.3% for on-time dispatches.

High-late-rate sellers are dispatch-driven: Among sellers with higher late-shipping rates, longer dispatch times were the main factor associated with delivery delays. These sellers also typically handled lower order volumes.

2. Geographic concentration

21.8% of the 6,509 delayed orders came from just two cities—Rio de Janeiro and Sao Paulo.

3. Product concentration

The Health Beauty and Bed Bath Table categories together accounted for 20.4% of delayed orders.

4. High-delay but low-volume segments

States with higher delay rates showed higher-than-average transit times, although their order volumes were considerably lower than those of the highest-volume states. A similar pattern was observed for heavy products, which had lower order volumes but relatively higher delay rates.

5. Time-based pattern

Transit time increases in the first and fourth quarters relative to the rest of the year. Delay rate stays elevated above 11% in February, March and November, the same months with the highest transit time.

## Business Implications

•	Delay rate nearly doubles from its average in some months, so plan extra logistics capacity and seller reminders before those periods.

•	Late dispatch has a delay rate almost quadruple against on time dispatches so while investigating the causes of late shipping, also look at carrier performance and delivery estimates, since on-time dispatches are still delayed some of the time.



## Data Source

Brazilian Ecommerce Public Dataset by Olist, shared on Kaggle

A real-world dataset with anonymized details, containing almost 99,441 orders placed between September 2016 and mid-October 2018 through multiple marketplaces in Brazil. It includes information about customers, products, orders, order items, payments, sellers, reviews, and English translations of product categories.

## Tools and Tech Stack

Tools and skills I used with their purpose in this project

PostgreSQL	- Data import, cleaning, creating views and exploratory querying on the ~100 thousand rows dataset

Power BI Desktop	- Four Pages interactive dashboard: Executive Summary, Delay and shipping time deep dive

DAX	-   Measures for order counts, delayed rate, delivery time, and calendar table

## Key Metrics & Terms

1	Lead Time – The time from when an order is placed to when it is delivered to the customer.

2     Dispatch Time – The time from order approval to when the order is handed over to the   carrier.

3	Transit Time – The time taken by the carrier from picking up the order from the seller to delivering it to the customer.

4	Delivery Scope – Orders delivered within the same state are classified as Intrastate, while orders delivered between different states are classified as Interstate.

5	Freight Value – The cost spent by the carrier for delivering an item, excluding orders with zero freight value.

## Project Workflow

**Understanding the business** – Defined the business context, identified relevant questions and established the key metrics required to evaluate performance.

**SQL, Data Cleaning & Exploration** – Imported the raw dataset into PostgreSQL, validated data quality, checked for nulls, duplicates and inconsistencies especially date columns, examined the causes behind the nulls and duplicates, created structured views containing the required fields removing all the unrealistic possibilities and segmenting orders by their delivery status

**Power BI, Dashboard Design** – Loaded the cleaned dataset into Power BI and designed a four-page report, added the extra details weren’t present in raw dataset using measures, calculated columns and calculated tables to find answer of the business questions

## Dashboard Structure

**Home Page**: project title, navigation to the two report pages, and a glossary defining average freight value, average lead time, transit, and dispatch time.

![Dashboard Preview](https://github.com/Biswas014/Olist-Ecommerce-Delivery-Performance-Dashboard/blob/main/Snapshots/Home%20Page.JPG)

**Overview**: Total orders, average transit & dispatch time, average freight value and review score as headline kpi’s, with total orders breaking down by delivery status, sellers & deliveries distribution volume by late delivery ratios and delay rate by quarter, and months. Filterable by delivery scope, shipping status, and date dimensions.

![Dashboard Preview](https://github.com/Biswas014/Olist-Ecommerce-Delivery-Performance-Dashboard/blob/main/Snapshots/Overview.JPG)

**Delay Drivers**: Top 5 cities and product categories with higher number of delayed orders, delay rate by product weight range and against freight value across months. Filterable by delivery scope, shipping status, and date dimensions.

![Dashboard Preview](
https://github.com/Biswas014/Olist-Ecommerce-Delivery-Performance-Dashboard/blob/main/Snapshots/Delay%20Drivers.JPG)

**Shipping Time Analysis**: A customer state wise summary table showing total orders, delay rate and the average time taken to deliver an order; relation between dispatch time and delivery time by shipping status; average lead time by delivery scope; changes of review score by delivery status. Filterable by delivery scope, shipping status, and date dimensions.

![Dashboard Preview](https://github.com/Biswas014/Olist-Ecommerce-Delivery-Performance-Dashboard/blob/main/Snapshots/Shipping%20Time%20Analysis.JPG)

## Data Preparation Challenge
Although I converted the order purchase timestamp in the transactions table and the date column in the calendar table to the same data type, blank values still appeared in the date-related dimensions created from the calendar table.
I handled the issue at the report level by filtering out the blank category from the relevant slicers.

## Live Report
[Click and View](https://app.powerbi.com/reportEmbed?reportId=ea7792b3-23fa-4176-87ff-1e69f6bcb835&autoAuth=true&ctid=56c1d497-700b-49cf-8f8d-3dd6b20d522f)
