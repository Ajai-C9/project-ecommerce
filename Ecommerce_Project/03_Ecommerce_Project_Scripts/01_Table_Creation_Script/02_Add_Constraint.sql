prompt-- Customer_tb constraints

ALTER TABLE customers_tb
ADD CONSTRAINT customer_pk PRIMARY KEY (customer_id);

prompt-- Product_tb constraints

ALTER TABLE product_tb
ADD CONSTRAINT product_pk PRIMARY KEY (product_id);

prompt-- Cart_tb constraints


ALTER TABLE cart_tb
ADD CONSTRAINT cart_pk PRIMARY KEY (cart_id);

ALTER TABLE cart_tb
ADD CONSTRAINT cart_customer_fk FOREIGN KEY (customer_id)
REFERENCES customers_tb(customer_id);

ALTER TABLE cart_tb
ADD CONSTRAINT cart_product_fk FOREIGN KEY (product_id)
REFERENCES product_tb(product_id);

prompt-- Category_tb constraints

ALTER TABLE category_tb
ADD CONSTRAINT category_pk PRIMARY KEY (category_id);

prompt-- Order_tb constraints

ALTER TABLE order_tb
ADD CONSTRAINT order_pk PRIMARY KEY (order_id);

ALTER TABLE order_tb
ADD CONSTRAINT order_customer_fk FOREIGN KEY (customer_id)
REFERENCES customers_tb(customer_id);

ALTER TABLE order_tb
ADD CONSTRAINT order_product_fk FOREIGN KEY (product_id)
REFERENCES product_tb(product_id);

prompt-- Order_item_tb constraints

ALTER TABLE order_item_tb
ADD CONSTRAINT order_item_pk PRIMARY KEY (order_item_id);

ALTER TABLE order_item_tb
ADD CONSTRAINT order_item_product_fk FOREIGN KEY (product_id)
REFERENCES product_tb(product_id);


/*ALTER TABLE order_item_tb
ADD CONSTRAINT order_item_order_fk FOREIGN KEY (order_id)
REFERENCES order_tb(order_id);*/

prompt-- Payment_tb constraints

ALTER TABLE payment_tb
ADD CONSTRAINT payment_pk PRIMARY KEY (payment_id);

ALTER TABLE payment_tb
ADD CONSTRAINT payment_customer_fk FOREIGN KEY (customer_id)
REFERENCES customers_tb(customer_id);


prompt-- Shipment_tb constraints

ALTER TABLE shipment_tb
ADD CONSTRAINT shipment_customer_fk FOREIGN KEY (customer_id)
REFERENCES customers_tb(customer_id);
