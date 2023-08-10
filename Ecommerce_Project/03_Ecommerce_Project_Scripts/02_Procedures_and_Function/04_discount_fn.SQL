										 
CREATE OR REPLACE PROCEDURE discount_sp (
    p_product_id   IN NUMBER,
	p_category_id  IN VARCHAR2,
    p_err_msg    OUT VARCHAR2,
    p_status     OUT VARCHAR2
) AS
    v_product_id NUMBER;
    v_price      NUMBER;
    v_discount   NUMBER;
	v_category_id VARCHAR2(30);   
BEGIN
    -- Get the price of the product based on the provided product_id
    SELECT price,category_id,product_id INTO v_price,v_category_id,v_product_id FROM product_tb WHERE product_id = product_id;
-- Apply discount based on the category_id
    IF v_category_id = 'A' THEN
        v_discount := v_price * 0.005;  -- 0.5%
    ELSIF v_category_id = 'B' THEN
        v_discount := v_price * 0.002;  -- 0.2%
    ELSIF v_category_id = 'C' THEN
        v_discount := v_price * 0.003;  -- 0.3%
    ELSIF v_category_id = 'D' THEN
        v_discount := v_price * 0.002;  -- 0.2%
    ELSE
        v_discount := 0;  
    END IF;

    -- Calculate the final price after applying the discount
    v_price := v_price - v_discount;

    -- Update the price of the product in the product_tb table
    UPDATE product_tb 
	SET price = v_price 
	WHERE product_id = product_id;
      
	  
	  INSERT INTO discount_tb(product_id,
	                          category_id,
                              discounts)
                      VALUES(v_product_id,
					         v_category_id
                             v_discount);					  
    -- Set output parameters
    p_err_msg := NULL;
    p_status := 'Success';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_err_msg := 'No product found for the provided product_id';
        p_status := 'Error';
    WHEN OTHERS THEN
        p_err_msg := SQLERRM;
        p_status := 'Error';
END;
/







CREATE OR REPLACE FUNCTION calculate_discount_fn (
    p_product_id   IN NUMBER,
    p_category_id  IN VARCHAR2
) RETURN VARCHAR2 AS
    v_product_id  NUMBER;
    v_price       NUMBER;
    v_discount    NUMBER;
    v_category_id VARCHAR2(30);
    v_err_msg     VARCHAR2(200);
    v_status      VARCHAR2(20);
BEGIN
    -- Get the price of the product based on the provided product_id
    SELECT price, category_id, product_id INTO v_price, v_category_id, v_product_id
    FROM product_tb
    WHERE product_id = p_product_id;

    -- Apply discount based on the category_id
    IF v_category_id = 'A' THEN
        v_discount := v_price * 0.005;  -- 0.5%
    ELSIF v_category_id = 'B' THEN
        v_discount := v_price * 0.002;  -- 0.2%
    ELSIF v_category_id = 'C' THEN
        v_discount := v_price * 0.003;  -- 0.3%
    ELSIF v_category_id = 'D' THEN
        v_discount := v_price * 0.002;  -- 0.2%
    ELSE
        v_discount := 0;  
    END IF;

    -- Calculate the final price after applying the discount
    v_price := v_price - v_discount;

    -- Update the price of the product in the product_tb table
    --UPDATE product_tb
    --SET discount_price = v_price
    --WHERE product_id = p_product_id;

    -- Insert the discount details into the discount_tb table
    INSERT INTO discount_tb (product_id, category_id, discounts,discount_price)
    VALUES (v_product_id, v_category_id, v_discount,v_price);
commit;
    -- Set output parameters
    v_err_msg := NULL;
    v_status := 'Success';

    -- Return status
    RETURN v_status;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        v_err_msg := 'No product found for the provided product_id';
        v_status := 'Error';
        RETURN v_status;
    WHEN OTHERS THEN
        v_err_msg := SQLERRM;
        v_status := 'Error';
        RETURN v_status;
END;
/
