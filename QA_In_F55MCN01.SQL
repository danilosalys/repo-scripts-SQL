
DECLARE
  V_UKID QADTA.F00022.UKUKID%TYPE;
BEGIN
  BEGIN
    FOR VPEDNF IN (


SELECT DISTINCT FDBNNF,
                FDBSER,
                FDN001,
                FDDCT
  FROM QADTA.F7611B
 WHERE FDLNTY = 'BS'
   AND FDDOCO in
       (10145678)) LOOP    
      ----------------------------------------------------------
      -- ENVIO NF PARA O MERCANET
      ---------------------------------------------------------      
      SELECT UKUKID
        INTO V_UKID
        FROM QADTA.F00022
       WHERE UKOBNM = 'F55MCN01';
      UPDATE QADTA.F00022 SET UKUKID = UKUKID + 1;
    
      INSERT INTO SELECT * FROM PRODDTA.F55MCN01
      VALUES
        (V_UKID,
         VPEDNF.FDBNNF,
         VPEDNF.FDBSER,
         VPEDNF.FDN001,
         VPEDNF.FDDCT,
         TO_NUMBER(TO_CHAR(sysdate, 'YYYYDDD') - 1900000),
         TO_CHAR(SYSDATE, 'HH24MISS'),
         ' ',
         'DSALES',
         'SQL',
         'DANILO-THI',
         TO_NUMBER(TO_CHAR(sysdate, 'YYYYDDD') - 1900000),
         TO_CHAR(SYSDATE, 'HH24MISS'));
   commit; 
     
    END LOOP;
  exception
    when others then
      null;
  END;
END;  
