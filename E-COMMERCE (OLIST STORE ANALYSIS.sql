                                                                                                      /* Domain : E-Commerce
																								Project Name: Olist Store Analysis*/

create database Project2;
use project2;

select count(*) from olist_customers_dataset; 
             select *  from olist_customers_dataset;
select count(*) from olist_order_items_dataset;
			 select *  from olist_order_items_dataset;
select count(*) from olist_order_payments_dataset;
			 select  *  from olist_order_payments_dataset;
select count(*) from olist_orders_dataset;
            select *  from olist_orders_dataset;
select count(*) from olist_products_dataset;
            select * from olist_products_dataset;
select count(* )from olist_order_reviews_dataset;
           select * from olist_order_reviews_dataset;



-- -- KPI1                                                                          Weekday Vs Weekend  Payment Statistics

-- TABLES -  olist_orders_dataset , olist_order_payments_dataset

select * from olist_orders_dataset;
select* from olist_order_payments_dataset;

 select
if (dayname(order_purchase_timestamp) in("sunday","saturday"), "Weekend","Weekday") as Day_Type, 
round(sum(payment_value),2)as Total_Payment  from 
olist_orders_dataset as orders
left join  
olist_order_payments_dataset as payment 
on orders.order_id = payment.order_id
  group by Day_Type;


 

-- -- KPI 2                                                                     Number of Orders with review score 5 and payment type as credit card

--  Tables -    Olist_orders_dataset  ,   olist_order_reviews_dataset ,   olist_order_payments_dataset

select * from olist_orders_dataset;
select * from olist_order_reviews_dataset;
select *from olist_order_payments_dataset;


select  payment.payment_type    , count(orders.order_id ) ,   reviews.review_score from 
olist_orders_dataset as orders
 left join 
 olist_order_reviews_dataset as reviews on orders.order_id=reviews.order_id 
left join
 olist_order_payments_dataset as payment  on orders.order_id = payment.order_id 
  where review_score=5     and    payment_type = "credit_card" ; 


-- -- KPI 3                                                                     Average number of days taken for order_delivered_customer_date for pet_shop

--  Tables -    olist_orders_dataset  ,  olist_products_dataset  , list_order_items_dataset


select* from olist_order_items_dataset;
select *from olist_orders_dataset;
select *from olist_products_dataset;
 

SELECT 
  Product_Category_name,
  ROUND(AVG(DATEDIFF(Order_Delivered_Customer_Date, Order_Purchase_Timestamp))) AS avg_delivery_time
FROM
 Olist_orders_dataset o
 left join 
  Olist_order_items_dataset i ON i.order_id = o.order_id
left JOIN 
 olist_products_dataset p ON p.product_id = i.product_id
WHERE p.product_category_name = "pet_shop";


-- -- KPI 4                                                                   4)   Average price and payment values from customers of sao paulo city

--  Tables -    olist_orders_dataset   , list_order_items_dataset   , olist_order_payments_dataset , olist_customers_dataset

select * from olist_customers_dataset;
select *from olist_order_payments_dataset;
 select* from olist_order_items_dataset;
 select * from olist_orders_dataset;
 

 select  c.customer_city, round(avg( i.price))  ,   round(avg(p.payment_value)) from olist_orders_dataset as o
 left join 
 olist_customers_dataset as c on   o.customer_id=c.customer_id
 left join 
 olist_order_items_dataset as i  on   o.order_id=i.order_id
 left join 
 olist_order_payments_dataset  as p   on  o.order_id = p.order_id 
 where customer_city = "Sao paulo";
 

-- -- KPI 4                                                                   Relationship between shipping days Vs review scores.

--  Tables -    olist_orders_dataset   , Olist_order_reviews_dataset


select  *  from olist_orders_dataset;
select *  from olist_order_reviews_dataset;

 select
 Review_score   ,    round(AVG( datediff(Order_Delivered_Customer_Date, Order_Purchase_Timestamp))) AS Shipping_time 
from
  Olist_orders_dataset o
 left join
Olist_order_reviews_dataset r ON o.Order_id = r.Order_id 
group by    review_score
order by   review_score desc ;
 
 








































