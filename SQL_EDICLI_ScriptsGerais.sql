SELECT * FROM  BKP_IO_EVENT;
SELECT * FROM CTRL_TABLE;
SELECT * FROM EVENTCODES;
SELECT * FROM CUSTOMER WHERE CTR_CODE = 742134;
SELECT * FROM IO_CLUSTER WHERE CLR_ID = 98;
SELECT * FROM IO_CLUSTER_CFG_FILE WHERE CLR_ID = 103 for update ;
SELECT * FROM IO_CLUSTER_CFG_FTP WHERE CLR_ID = 103 for update ;
;---
SELECT * FROM IO_CLUSTER_CFG_INTEGRATION ;
SELECT * FROM IO_CLUSTER_CFG_CUSTOMER WHERE CTR_ID = 1308 ;
SELECT * FROM IO_CLUSTER_CFG_LAYOUT WHERE CLR_ID = 158; 
SELECT * FROM LAYOUT for update;
SELECT * FROM IO_CLUSTER_CFG_RETURN_CODE FOR UPDATE; 
SELECT * FROM IO_EVENT WHERE CLR_ID = 59 AND EVC_CODE = 1000 AND EVT_FLAG1 = 2;
SELECT * FROM IO_FILE;
SELECT * FROM ORDERADDINFO;
SELECT * FROM ORDERDETAIL;
SELECT * FROM ORDERHEADER;
SELECT * FROM PRODUCT;
SELECT * FROM PRODUCT_BARCODE;
SELECT * FROM SCHEDULE;
SELECT * FROM SCHEDULE_EVENT ORDER BY sce_date DESC;
SELECT * FROM WHOLESALER;

SELECT t2.*,t1.*,t3.*
  FROM IO_CLUSTER_CFG_CUSTOMER T1
       ,CUSTOMER               T2
       ,IO_CLUSTER             T3
 WHERE T1.CTR_ID = T2.CTR_ID
   AND T1.CLR_ID = T3.CLR_ID
   AND T2.CTR_code = 754532 ;

SELECT t1.*
      ,t2.*
      ,t3.*
      ,t4.*
      ,t5.*
  FROM  IO_CLUSTER_CFG_FTP    T1
       ,IO_CLUSTER_CFG_FILE   T2
       ,IO_CLUSTER            T3
       ,IO_CLUSTER_CFG_LAYOUT T4
       ,LAYOUT                T5
 WHERE T1.CLR_ID   = T2.CLR_ID
   AND T1.CLR_ID   = T3.CLR_ID
   AND T1.SCH_OPER = T2.SCH_OPER
   AND T1.CLR_ID   = T4.CLR_ID
   AND T1.SCH_OPER = T4.SCH_OPER
   AND T4.LAY_ID   = T5.LAY_ID
   AND T4.SCH_OPER = T5.LAY_OPER
   AND T3.CLR_ID   = 164 ;   
   
   SELECT-- T4.*
       T2.CLR_ID
       ,T3.CLR_NAME
       ,T1.LAY_DESCRIPTION,
       T1.*
  FROM LAYOUT T1
       ,IO_CLUSTER_CFG_LAYOUT T2
       ,IO_CLUSTER T3
   --    ,IO_CLUSTER_CFG_RETURN_CODE T4       
 WHERE UPPER(LAY_JSON_CONFIG) LIKE '%CCR%'
   AND T1.LAY_ID = T2.LAY_ID
   AND T1.LAY_OPER = 'O'
   AND T2.CLR_ID = T3.CLR_ID
   AND NOT EXISTS (SELECT * FROM IO_CLUSTER_CFG_RETURN_CODE T4 WHERE T3.CLR_ID = T4.CLR_ID   )
 --  AND T3.CLR_ID = T4.CLR_ID
 --  ORDER BY T4.CLR_ID, T4.CCR_TYPE, T4.CCR_RESP_STATUS
 
 
