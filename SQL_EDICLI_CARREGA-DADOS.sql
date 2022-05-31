
-- 1:: INSERE CLUSTER
SELECT 'INSERT INTO IO_CLUSTER VALUES ('
       ||CLR_ID 
       ||','''
       ||CLR_NAME
       ||''','''
       ||CLR_ENABLED
       ||''');'
 FROM IO_CLUSTER 
WHERE CLR_ID > 1;

-- 2 : INSERE CLIENTES 
SELECT 'INSERT INTO CUSTOMER (CTR_ID,CTR_CODE,CTR_TAXID,CTR_NAME,CTR_UF,CTR_CITY,CTR_STATUS,CTR_CREDIT,WSR_CODE,CTR_BILLINGCODE,CTR_CLOSINGTIME) VALUES ('
        ||CTR_ID
        ||','''
        ||CTR_CODE 
        ||''','''
        ||CTR_TAXID
        ||''','''
        ||CTR_NAME
        ||''','''
        ||CTR_UF
        ||''','''
        ||CTR_CITY
        ||''','''
        ||CTR_STATUS
        ||''','
        ||CTR_CREDIT
        ||','''
        ||WSR_CODE
        ||''','''
        ||CTR_BILLINGCODE
        ||''','''
        ||CTR_CLOSINGTIME	
        ||''');'
  FROM CUSTOMER
 WHERE CTR_ID > 389;
 
-- 3 : INSERE CLIENTES X CLUSTERS  
SELECT 'INSERT INTO IO_CLUSTER_CFG_CUSTOMER VALUES ('
       ||CCC_ID
       ||','
       ||CLR_ID 
       ||','''
       ||CCC_ENABLED
       ||''','
       ||CTR_ID
       ||','
       ||5
       ||','
       ||0
       ||');'
  FROM IO_CLUSTER_CFG_CUSTOMER
 WHERE CCC_ID > 389;
 
-- 4 : INSERE CONFIGURACAO DE PASTAS
SELECT 'INSERT INTO IO_CLUSTER_CFG_FILE VALUES ('
       ||CCF_ID
       ||','
       ||CLR_ID 
       ||','''
       ||SCH_TYPE
       ||''','''
       ||SCH_OPER
       ||''','
       ||SCH_CODE	
       ||','''
       ||REPLACE(UPPER(CCF_PATH),'SRVDC38','SRVDC11')	
       ||''','
       ||CCF_LIMITFILES	
       ||','''
       ||CCF_MOVE_FILE
       ||''','''
       ||REPLACE(UPPER(CCF_MOVE_PATH),'SRVDC38','SRVDC11')
       ||''','''
       ||CCF_ENABLED
       ||''','''
       ||CCF_MASK_FILE
       ||''','''
       ||CCF_SAVE_NAME
       ||''','
       ||CCF_AFTER_IMP_ACT
       ||','
       ||CCF_SEC_DIR_SAFE_COPY
       ||','''
       ||CCF_PURGE_IMP_FILE
       ||''','
       ||CCF_PURGE_IMP_FILE_DAYS
       ||','
       ||CCF_ORDERBY1
       ||','
       ||CCF_ORDERBY2
 	     ||');'
  FROM IO_CLUSTER_CFG_FILE
 WHERE CLR_ID > 1
 ORDER BY  CCF_ID;


-- 5 : INSERE CONFIGURACAO DE FTP
SELECT 'INSERT INTO IO_CLUSTER_CFG_FTP VALUES ('
        ||CCP_ID
        ||','''	
        ||CCP_ENABLED
        ||''','
        ||CLR_ID	
        ||','''
        ||SCH_TYPE
        ||''','''
        ||SCH_OPER
        ||''','
        ||SCH_CODE
        ||','''
        ||REPLACE(CCP_HOST,'10.0.1.3','ftp.drogacenter.com.br')
        ||''','
        ||CCP_PORT
        ||','''
        ||CCP_USER
        ||''','''
        ||CCP_PWD
        ||''','''
        ||CCP_PASSIVE_MODE
        ||''','
        ||CCP_REM_LIMITFILES
        ||','
        ||CCP_REM_SEC_DIR_SAFE_CP
        ||','
        ||CCP_REM_AFTER_CP_ACT
        ||','''
        ||CCP_REM_DIR
        ||''','''
        ||CCP_REM_FILE_MASK
        ||''','''
        ||CCP_REM_MOVE_DIR
        ||''','''
        ||CCP_REM_REN_EXT
        ||''','
        ||CCP_LOC_LIMITFILES
        ||','
        ||CCP_LOC_SEC_DIR_SAFE_CP	
        ||','
        ||CCP_LOC_AFTER_CP_ACT	
        ||','''
        ||REPLACE(UPPER(CCP_LOC_DIR),'SRVDC38','SRVDC11')
        ||''','''
        ||CCP_LOC_FILE_MASK
        ||''','''
        ||CCP_LOC_MOVE_DIR
        ||''','''
        ||CCP_LOC_REN_EXT
        ||''','''
        ||CCP_FTP_LOG_ENABLED
        ||''','''
        ||CCP_FTP_LOG_FILE_PATH
        ||''','
        ||CCP_ORDERBY1
        ||','
        ||CCP_ORDERBY2
        ||');'
 FROM IO_CLUSTER_CFG_FTP
WHERE CLR_ID > 1 
ORDER BY CCP_ID;

-- 6 : INSERE CONFIGURACAO DE INTEGRAÇÃO COM JDE
SELECT 'INSERT INTO IO_CLUSTER_CFG_INTEGRATION  VALUES ('
        ||CCI_ID
        ||','
        ||CLR_ID
        ||','''
        ||CCI_ENABLED
        ||''','''
        ||SCH_OPER
        ||''','
        ||CCI_ORDERBY1
        ||','
        ||CCI_ORDERBY2
        ||');'
  FROM IO_CLUSTER_CFG_INTEGRATION 
 WHERE CLR_ID > 1 
 ORDER BY CCI_ID ;
 
-- 7: INSERE CONFIGURACAO DE LAYOUTS
SELECT 'INSERT INTO IO_CLUSTER_CFG_LAYOUT VALUES ('
        ||CCL_ID
        ||','
        ||CLR_ID	
        ||','''
        ||CCL_ENABLED	
        ||''','''
        ||SCH_OPER
        ||''','
        ||LAY_ID	
        ||','
        ||CCL_ORDERBY1
        ||','
        ||CCL_ORDERBY2
        ||');'
  FROM IO_CLUSTER_CFG_LAYOUT 
 WHERE CLR_ID > 1 
   ORDER BY CCL_ID;
   
-- 8: INSERE CONFIGURACAO DE LAYOUTS 
SELECT 'INSERT INTO LAYOUT (LAY_ID,LAY_OPER,LAY_DESCRIPTION) VALUES ('
        ||LAY_ID
        ||','''
        ||LAY_OPER
        ||''','''
        ||LAY_DESCRIPTION
        ||''');'

  FROM LAYOUT
 WHERE LAY_ID IN (3,4)
