PROMPT_______________*customer_tb table creation STARTS**************_*

DROP TABLE customers_tb;

Create table customers_tb (customer_id  NUMBER  
                          ,first_name  VARCHAR2(50)
						  ,last_name   VARCHAR2(50)
						  ,email       VARCHAR2(50)
						  ,address     VARCHAR2(50)
						  ,p_no        VARCHAR2(50));
						  
create sequence CUSTM_SEQ
minvalue 1
maxvalue 1000
start with 1
increment by 1
cache 20
NOCYCLE;
						  
PROMPT_______________*customer_tb table creation ENDS**************_*
						  


PROMPT_***************product_tb table creation STARTS**************_*

DROP TABLE product_tb ;

CREATE TABLE product_tb(product_id     NUMBER primary key
                        ,description   VARCHAR2(50)	
                        ,price         NUMBER
						,stock         NUMBER 
                        ,category_id   VARCHAR2(50) );
						
create sequence PRO_SEQ
minvalue 100
maxvalue 1000
start with 100
increment by 10
cache 20
NOCYCLE;
						
PROMPT_______________*product_tb table creation ENDS**************_*

PROMPT_***************discount_tb table creation STARTS**************_*



DROP table discount_tb;
create table  discount_tb (product_id number,
                          category_id VARCHAR2(30),
                          discounts  number,
						  discount_price number);
						  
						  
						  
						  
						 
						 
						 
						 
						 
PROMPT_***************discount_tb table creation ENDS**************_*

PROMPT_______________*cart_tb table creation STARTS**************_*

DROP TABLE carts_tb;

CREATE TABLE cart_tb( cart_id      NUMBER primary key
                     ,quantity     VARCHAR2(50)
                     ,customer_id  NUMBER 
					 ,product_id    NUMBER  
					 );

create sequence CART_SEQ
minvalue 100
maxvalue 1000
start with 100
increment by 2
cache 20
NOCYCLE;
PROMPT_______________*cart_tb table creation ENDS**************_
					
					
PROMPT_______________*category_tb table creation STARTS**************_*

DROP TABLE category_tb;
					
CREATE TABLE category_tb( category_id  VARCHAR2(50)
                          ,name        VARCHAR2(50));
create sequence CATE_SEQ
minvalue 10
maxvalue 1000
start with 10
increment by 10
cache 20
NOCYCLE;
PROMPT_______________*category_tb table creation ENDS**************_*

PROMPT_______________*order_item_tb table creation STARTS**************_*

DROP TABLE order_item_tb;

CREATE TABLE order_item_tb (order_item_id   NUMBER 
                            ,quantity       VARCHAR2(50)
                            ,price          NUMBER
                            ,product_id     NUMBER							
                             );
							
create sequence ORI_SEQ
minvalue 100
maxvalue 100000
start with 100
increment by 200
cache 20
NOCYCLE;

PROMPT_______________*order_item_tb table creation ENDS**************_*


PROMPT_______________*order_tb table creation STARTS**************_*

DROP TABLE order_tb;

CREATE TABLE order_tb(order_id      NUMBER
                     ,order_date    DATE  
                     ,total_price   NUMBER
                     ,customer_id   NUMBER
                     ,product_id    NUMBER
					 ); 

create sequence OR_SEQ
minvalue 1
maxvalue 1000
start with 1
increment by 1
cache 20
NOCYCLE;
PROMPT_______________*order_tb table creation ENDS**************_*

							
PROMPT_______________*payment_tb table creation STARTS**************_*

DROP TABLE payment_tb;

CREATE TABLE payment_tb (payment_id   NUMBER 
                        ,payment_date  DATE 
                        ,payment_method VARCHAR2(50)
                        ,amount         VARCHAR2(50)
						,customer_id    NUMBER
                        ,shipment_id   NUMBER
						);
create sequence PAY_SEQ
minvalue 10
maxvalue 1000
start with 10
increment by 5
cache 20
NOCYCLE;
PROMPT_______________*payment_tb table creation ENDS**************_*
                          						  
PROMPT_______________*shipment_tb table creation STARTS**************_*
						
DROP TABLE shipment_tb;

CREATE TABLE shipment_tb ( shipment_id   NUMBER 
                          ,shipment_date DATE 
                          ,address        VARCHAR2(100)
                          ,customer_id   NUMBER 
                          ,status        VARCHAR2(50)
						  ,constraint shipment_pk PRIMARY key(shipment_id));
	
create sequence SHMT_SEQ
minvalue 100
maxvalue 10000
start with 100
increment by 10
cache 20
NOCYCLE;	
						  
PROMPT_______________*shipment_tb table creation ENDS**************_*…
