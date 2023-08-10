CREATE OR REPLACE PROCEDURE insertcart_sp(
    p_customer_id IN NUMBER,
    p_product_id IN NUMBER,
    p_quantity IN NUMBER,
	p_status      OUT VARCHAR2,
	p_err_msg     OUT VARCHAR2)
    
AS
    v_cart_id NUMBER;
    v_total_quantity NUMBER;
    v_max_quantity NUMBER := 10;
	EXP1 EXCEPTION ;
	EXP2 EXCEPTION;
	EXP3 EXCEPTION; 
BEGIN
    SELECT cart_seq.nextval INTO v_cart_id FROM dual;

    SELECT SUM(quantity) INTO v_total_quantity FROM cart_tb WHERE customer_id = p_customer_id;
    IF v_total_quantity + p_quantity > 100 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Total quantity in cart exceeds the limit of 100.');
    END IF;
	
    IF p_quantity > v_max_quantity THEN
        RAISE_APPLICATION_ERROR(-20002, 'Quantity exceeds the maximum allowed per product.');
    END IF;

    -- Insert into cart_tb table
    INSERT INTO cart_tb (
        cart_id,
        customer_id,
        product_id,
        quantity
    ) VALUES (
        v_cart_id,
        p_customer_id,
        p_product_id,
        p_quantity
    );
IF p_customer_id IS NULL THEN 
raise exp1;
ELSIF p_product_id IS NULL THEN 
raise exp2;
ELSIF p_quantity IS NULL THEN 
raise exp3;
END IF;
 
p_status := 'S';
p_err_msg := NULL;
COMMIT;

EXCEPTION
WHEN exp1 then
  p_status := 'F';
  p_err_msg := 'Check the valid customer_id ';
when exp2 then 
    p_status := 'F';
    p_err_msg := 'Check the valid product_id'; 
when exp3 then 
    p_status := 'F';
    p_err_msg := 'Check the valid p_quantity'; 
 WHEN OTHERS THEN
    p_status := 'F';
    p_err_msg := SQLERRM; 
 ROLLBACK;

END;
/
