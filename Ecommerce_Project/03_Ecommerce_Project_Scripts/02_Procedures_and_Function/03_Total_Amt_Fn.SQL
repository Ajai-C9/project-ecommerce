CREATE OR REPLACE FUNCTION CalculateTotalPrice(p_product_id IN NUMBER) 
RETURN NUMBER 
IS
  totalAmount NUMBER;
BEGIN
  SELECT SUM(o.quantity * p.price) 
  INTO totalAmount
  FROM cart_tb o JOIN Product_tb p 
  ON o.product_id = p.product_id
  AND o.product_id =p_product_Id;

  RETURN totalAmount;
END CalculateTotalPrice;
/