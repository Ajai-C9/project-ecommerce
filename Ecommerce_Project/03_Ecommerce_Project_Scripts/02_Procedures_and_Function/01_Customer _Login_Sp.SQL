
CREATE OR REPLACE PROCEDURE insert_customer_dtl_sp(
  p_first_name   IN customers_tb.first_name%TYPE,
  p_last_name    IN customers_tb.last_name%TYPE,
  p_email        IN customers_tb.email%TYPE,
  p_address      IN customers_tb.address%TYPE,
  p_p_no         IN customers_tb.p_no%TYPE,
  p_status OUT VARCHAR2,
  p_err_msg OUT VARCHAR2
) IS
  v_customer_id customers_tb.customer_id%TYPE;
BEGIN
  -- VALIDATE INPUT PARAMETERS
  IF p_first_name IS NULL THEN
    p_status := 'FAILED';
    p_err_msg := 'FIRST_NAME NOT ENTERED';
    RETURN;
  END IF;

  IF p_address IS NULL THEN
    p_status := 'FAILED';
    p_err_msg := 'ADDRESS NOT ENTERED';
    RETURN;
  END IF;

  IF p_p_no IS NULL THEN
    p_status := 'FAILED';
    p_err_msg := 'PHONE NUMBER NOT ENTERED';
    RETURN;
  END IF;

  SELECT CUSTM_SEQ.NEXTVAL INTO v_customer_id FROM DUAL;
  
  -- INSERT CUSTOMER DETAILS INTO CUSTOMERS_TB
  INSERT INTO customers_tb (customer_id, first_name, last_name, email, address, p_no)
  VALUES (v_customer_id, p_first_name, p_last_name, p_email, p_address, p_p_no);
  
  p_status := 'SUCCESS';
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    p_status := 'FAILED';
    p_err_msg := SQLERRM;
END;
/
