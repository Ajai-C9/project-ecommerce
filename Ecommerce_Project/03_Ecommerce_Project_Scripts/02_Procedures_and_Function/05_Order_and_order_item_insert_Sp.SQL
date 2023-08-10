
CREATE OR REPLACE PROCEDURE ecom_insert_sp(
    p_customer_id IN NUMBER,
    p_product_id IN NUMBER,
    p_status OUT VARCHAR2,
    p_err_msg OUT VARCHAR2
)
AS
    v_totalamount NUMBER;
    v_product_id NUMBER;
    v_order_item_id NUMBER;
    v_order_id NUMBER;
    v_price NUMBER;
    v_quantity NUMBER;
    v_cust NUMBER;
BEGIN
    p_status := 'SUCCESS'; 
    p_err_msg := NULL; 
	
    SELECT COUNT(*) INTO v_cust FROM customers_tb WHERE customer_id = p_customer_id;
    IF v_cust = 0 THEN
        p_status := 'FAILED';
        p_err_msg := 'Customer not found.';
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_product_id FROM product_tb WHERE product_id = p_product_id;
    IF v_product_id = 0 THEN
        p_status := 'FAILED';
        p_err_msg := 'Product not found.';
        RETURN;
    END IF;

    -- Calculate the total amount
    SELECT CalculateTotalPrice(p_product_id) INTO v_totalamount FROM dual;

    -- Retrieve quantity from the cart_tb
    SELECT quantity INTO v_quantity FROM cart_tb WHERE customer_id = p_customer_id;

    -- Retrieve price from the product_tb
    SELECT price INTO v_price FROM product_tb WHERE product_id = p_product_id;

    -- Generate a unique order_item_id
    SELECT ori_seq.nextval INTO v_order_item_id FROM dual;

    -- Generate a unique order_id
    SELECT or_seq.nextval INTO v_order_id FROM dual;

    INSERT INTO order_item_tb (
        order_item_id,
        quantity,
        price,
        product_id
    ) VALUES (
        v_order_item_id,
        v_quantity,
        v_price,
        p_product_id
    );

    INSERT INTO order_tb (
        order_id,
        order_date,
        total_price,
        customer_id,
        product_id
    ) VALUES (
        v_order_id,
        systimestamp,
        v_totalamount,
        p_customer_id,
        p_product_id
    );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_status := 'FAILED';
        p_err_msg := SQLERRM;
END;
/
