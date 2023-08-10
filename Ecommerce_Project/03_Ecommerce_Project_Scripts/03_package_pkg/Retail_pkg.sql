CREATE OR REPLACE PACKAGE ecom_package AS

  PROCEDURE insert_customer_dtl_sp(
    p_first_name   IN customers_tb.first_name%TYPE,
    p_last_name    IN customers_tb.last_name%TYPE,
    p_email        IN customers_tb.email%TYPE,
    p_address      IN customers_tb.address%TYPE,
    p_no           IN customers_tb.p_no%TYPE,
    p_status OUT VARCHAR2,
    p_err_msg OUT VARCHAR2
  );

  PROCEDURE insertcart_sp(
    p_customer_id IN NUMBER,
    p_product_id IN NUMBER,
    p_quantity IN NUMBER,
    p_status OUT VARCHAR2,
    p_err_msg OUT VARCHAR2
  );

  FUNCTION calculate_discount_fn(
    p_product_id   IN NUMBER,
    p_category_id  IN VARCHAR2
  ) RETURN VARCHAR2;

  FUNCTION CalculateTotalPrice(
    p_product_id IN NUMBER
  ) RETURN NUMBER;

  PROCEDURE ecom_insert_sp(
    p_customer_id IN NUMBER,
    p_product_id  IN NUMBER,
    p_status      OUT VARCHAR2,
    p_err_msg     OUT VARCHAR2
  );

  PROCEDURE PAYMENT_SP(
    P_CUSTOMER_ID    IN NUMBER,
    P_ORDER_ID       IN NUMBER,
    P_PAYMENT_METHOD IN VARCHAR2,
    P_AMOUNT         IN NUMBER,
    P_STATUS         OUT VARCHAR2,
    p_err_msg        OUT VARCHAR2
  );

END ecom_package;
/




CREATE OR REPLACE PACKAGE BODY ecom_package AS

  PROCEDURE insert_customer_dtl_sp(
    p_first_name   IN customers_tb.first_name%TYPE,
    p_last_name    IN customers_tb.last_name%TYPE,
    p_email        IN customers_tb.email%TYPE,
    p_address      IN customers_tb.address%TYPE,
    p_no           IN customers_tb.p_no%TYPE,
    p_status OUT VARCHAR2,
    p_err_msg OUT VARCHAR2
  ) IS
    v_customer_id customers_tb.customer_id%TYPE;
    abort_ex2     EXCEPTION;
    abort_ex3     EXCEPTION;
    abort_ex4     EXCEPTION;
    abort_ex5     EXCEPTION;
    abort_ex6     EXCEPTION;
    abort_ex7     EXCEPTION;
  BEGIN
    SELECT custm_seq.NEXTVAL INTO v_customer_id FROM dual;

    IF p_no IS NULL THEN
      RAISE abort_ex7;
    ELSIF LENGTH(p_no) > 10 THEN
      RAISE abort_ex6;
    ELSIF LENGTH(p_no) < 10 THEN
      RAISE abort_ex6;
    END IF;

    INSERT INTO customers_tb (
      customer_id,
      first_name,
      last_name,
      email,
      address,
      p_no
    ) VALUES (
      v_customer_id,
      p_first_name,
      p_last_name,
      p_email,
      p_address,
      p_no
    );

    IF p_first_name IS NULL THEN
      RAISE abort_ex2;
    ELSIF p_last_name IS NULL THEN
      RAISE abort_ex3;
    ELSIF p_email IS NULL THEN
      RAISE abort_ex4;
    ELSIF p_address IS NULL THEN
      RAISE abort_ex5;
    END IF;

    COMMIT;
    p_status := 'S';
    p_err_msg := NULL;

  EXCEPTION
    WHEN abort_ex2 THEN
      p_status := 'F';
      p_err_msg := 'Check the valid first name';
    WHEN abort_ex3 THEN
      p_status := 'F';
      p_err_msg := 'Check the valid last name';
    WHEN abort_ex4 THEN
      p_status := 'F';
      p_err_msg := 'Check the valid email';
    WHEN abort_ex5 THEN
      p_status := 'F';
      p_err_msg := 'Check the valid address';
    WHEN abort_ex6 THEN
      p_status := 'F';
      p_err_msg := 'Phone number should be 10 digits';
    WHEN abort_ex7 THEN
      p_status := 'F';
      p_err_msg := 'Phone number cannot be NULL';
    WHEN OTHERS THEN
      p_status := 'F';
      p_err_msg := SQLERRM;
  END;

  PROCEDURE insertcart_sp(
    p_customer_id IN NUMBER,
    p_product_id IN NUMBER,
    p_quantity IN NUMBER,
    p_status OUT VARCHAR2,
    p_err_msg OUT VARCHAR2
  ) AS
    v_cart_id NUMBER;
    v_total_quantity NUMBER;
    v_max_quantity NUMBER := 10;
    EXP1 EXCEPTION;
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
      RAISE EXP1;
    ELSIF p_product_id IS NULL THEN
      RAISE EXP2;
    ELSIF p_quantity IS NULL THEN
      RAISE EXP3;
    END IF;

    p_status := 'S';
    p_err_msg := NULL;
    COMMIT;

  EXCEPTION
    WHEN EXP1 THEN
      p_status := 'F';
      p_err_msg := 'Check the valid customer_id';
    WHEN EXP2 THEN
      p_status := 'F';
      p_err_msg := 'Check the valid product_id';
    WHEN EXP3 THEN
      p_status := 'F';
      p_err_msg := 'Check the valid p_quantity';
    WHEN OTHERS THEN
      p_status := 'F';
      p_err_msg := SQLERRM;
      ROLLBACK;
  END;

  FUNCTION calculate_discount_fn (
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
    SELECT price, category_id, product_id INTO v_price, v_category_id, v_product_id
    FROM product_tb
    WHERE product_id = p_product_id;

    IF v_category_id = 'A' THEN
      v_discount := v_price * 0.5;  -- 0.5%
    ELSIF v_category_id = 'B' THEN
      v_discount := v_price * 0.2;  -- 0.2%
    ELSIF v_category_id = 'C' THEN
      v_discount := v_price * 0.3;  -- 0.3%
    ELSIF v_category_id = 'D' THEN
      v_discount := v_price * 0.2;  -- 0.2%
    ELSE
      v_discount := 0;  
    END IF;

    v_price := v_price - v_discount;

    INSERT INTO discount_tb (product_id, category_id, discounts, discount_price)
    VALUES (v_product_id, v_category_id, v_discount, v_price);
    COMMIT;

    v_err_msg := NULL;
    v_status := 'Success';

    RETURN v_status;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_err_msg := 'No product found for the provided product_id';
      v_status := 'Error';
      RETURN v_status;
    WHEN OTHERS THEN
      v_err_msg := SQLERRM;
      v_status := 'Error';
  END;

  FUNCTION calculate_total_price(p_product_id IN NUMBER) RETURN NUMBER IS
    total_amount NUMBER;
  BEGIN
    SELECT SUM(o.quantity * p.discount_price)
    INTO total_amount
    FROM cart_tb o
    JOIN discount_tb p ON o.product_id = p.product_id
    AND o.product_id = p_product_id;

    RETURN total_amount;
  END calculate_total_price;

  PROCEDURE ecom_insert_sp(
    p_customer_id IN NUMBER,
    p_product_id  IN NUMBER,
    p_status      OUT VARCHAR2,
    p_err_msg     OUT VARCHAR2
  ) AS
    v_total_amount NUMBER;
    v_product_id   NUMBER;
    v_order_item_id NUMBER;
    v_order_id     NUMBER;
    v_price        NUMBER;
    v_quantity     NUMBER;
    ex1            EXCEPTION;
    ex2            EXCEPTION;
  BEGIN
    SELECT calculate_total_price(p_product_id) INTO v_total_amount FROM dual;

    SELECT quantity INTO v_quantity FROM cart_tb WHERE customer_id = p_customer_id;

    SELECT price INTO v_price FROM product_tb WHERE product_id = p_product_id;

    SELECT ori_seq.nextval INTO v_order_item_id FROM dual;

    SELECT product_id INTO v_product_id FROM cart_tb WHERE product_id = p_product_id;

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
      ORDER_ID,
      ORDER_DATE,
      TOTAL_PRICE,
      CUSTOMER_ID,
      PRODUCT_ID
    ) VALUES (
      v_order_id,
      systimestamp,
      v_total_amount,
      p_customer_id,
      p_product_id
    );

    IF p_customer_id IS NULL THEN
      RAISE ex1;
    ELSIF p_product_id IS NULL THEN
      RAISE ex2;
    END IF;

    p_status := 'S';
    p_err_msg := NULL;
    COMMIT;

  EXCEPTION
    WHEN ex1 THEN
      p_status := 'F';
      p_err_msg := 'Check the valid customer_id';
    WHEN ex2 THEN
      p_status := 'F';
      p_err_msg := 'Check the valid product_id';
    WHEN OTHERS THEN
      p_status := 'F';
      p_err_msg := SQLERRM;
  END;

  PROCEDURE payment_sp (
    p_customer_id    IN NUMBER,
    p_order_id       IN NUMBER,
    p_payment_method IN VARCHAR2,
    p_amount         IN NUMBER,
    p_status         OUT VARCHAR2,
    p_err_msg        OUT VARCHAR2
  ) AS
    v_payment_id   NUMBER;
    v_shipment_id  NUMBER;
    v_amount       NUMBER;
    v_address      VARCHAR2(200);
    v_datetime     DATE;
    EXP1           EXCEPTION;
    EXP2           EXCEPTION;
    EXP3           EXCEPTION;
  BEGIN
    SELECT payment_seq.nextval INTO v_payment_id FROM dual;

    SELECT shipment_seq.nextval INTO v_shipment_id FROM dual;

    SELECT total_price INTO v_amount FROM order_tb WHERE order_id = p_order_id;

    SELECT address INTO v_address FROM customers_tb WHERE customer_id = p_customer_id;

    IF p_payment_method NOT IN ('Credit Card', 'Debit Card', 'PayPal', 'Cash') THEN
      RAISE_APPLICATION_ERROR(-20003, 'Invalid payment method');
    END IF;

    IF p_amount <> v_amount THEN
      RAISE_APPLICATION_ERROR(-20004, 'Payment amount does not match the order total');
    END IF;

    INSERT INTO payment_tb (
      payment_id,
      payment_date,
      customer_id,
      order_id,
      payment_method,
      amount
    ) VALUES (
      v_payment_id,
      systimestamp,
      p_customer_id,
      p_order_id,
      p_payment_method,
      p_amount
    );

    INSERT INTO shipment_tb (
      shipment_id,
      shipment_date,
      order_id,
      customer_id,
      shipment_address
    ) VALUES (
      v_shipment_id,
      systimestamp,
      p_order_id,
      p_customer_id,
      v_address
    );

    IF p_customer_id IS NULL THEN
      RAISE EXP1;
    ELSIF p_order_id IS NULL THEN
      RAISE EXP2;
    ELSIF p_amount IS NULL THEN
      RAISE EXP3;
    END IF;

    p_status := 'S';
    p_err_msg := NULL;
    COMMIT;

  EXCEPTION
    WHEN EXP1 THEN
      p_status := 'F';
      p_err_msg := 'Check the valid customer_id';
    WHEN EXP2 THEN
      p_status := 'F';
      p_err_msg := 'Check the valid order_id';
    WHEN EXP3 THEN
      p_status := 'F';
      p_err_msg := 'Check the valid amount';
    WHEN OTHERS THEN
      p_status := 'F';
      p_err_msg := SQLERRM;
      ROLLBACK;
  END;

END ecom_package;
/
