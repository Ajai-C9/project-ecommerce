CREATE OR REPLACE TRIGGER reduce_stock_trigger
AFTER INSERT ON cart_tb
FOR EACH ROW
BEGIN
  UPDATE product_tb
  SET stock = stock - :new.quantity
  WHERE product_id = :new.product_id;
END;
/



