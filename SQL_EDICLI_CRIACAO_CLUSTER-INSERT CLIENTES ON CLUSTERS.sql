--SCRIPT PARA INSERÇÃO DE NOVOS CLUSTERS
----AMBIENTES: DCEDICLI-QA - EXECUTAR NO DC10
----AMBIENTES: DCEDICLI-PRD - EXECUTAR NO DC01


DECLARE

V_MAX_ID_CUSTOMER NUMBER      := 0;
V_MAX_ID_CLUSTER  NUMBER      := 0; 
V_CHECK           NUMBER      := 0;
V_AMBIENTE        VARCHAR2(30):= '&Ambiente';
V_SERVIDOR        VARCHAR2(15):= ''; --SRVDC38 OU SRVDC11
V_HOST_FTP        VARCHAR2(30):= ''; -- 10.0.1.3 OU ftp.drogacenter.com.br
V_OWNER           VARCHAR2(30):= ''; 
V_COMMAND         VARCHAR2(500):= '';
V_DIRETORIO       VARCHAR2(1000):= '';
V_UDC_DRSY        VARCHAR2(2):= '40';
V_UDC_DRRT        VARCHAR2(2):= 'ZN';
V_CLUSTER         VARCHAR2(30):='';
V_MKDIR           VARCHAR2(30):= 'MKDIR ';
V_ATIVAR_CLUSTER  CHAR(1) := '&AtivarCluster';
V_EFETUAR_CARGA   NUMBER := 0;
V_NOME_RETORNO    VARCHAR2(30) := '%FILENAME%';
V_CLIENTE         VARCHAR2(30) := '';

BEGIN  
  
IF V_AMBIENTE= 'PD' THEN 
   V_SERVIDOR := 'D:';
   V_HOST_FTP := 'ftp.drogacenter.com.br';
   V_OWNER    := 'DCEDICLI_PRD.';
   
   SELECT COUNT(1) 
     INTO V_EFETUAR_CARGA
     FROM NEW_CUSTOMER
    WHERE INTEGRACAO_CONCLUIDA = 'N';
    
  ELSIF V_AMBIENTE = 'QA' THEN
     V_SERVIDOR := '\\SRVDC38';
     V_HOST_FTP := '10.0.1.3';
     V_OWNER := 'DCEDICLI_QA.';
     
     SELECT COUNT(1) 
      INTO V_EFETUAR_CARGA
      FROM NEW_CUSTOMER
     WHERE INTEGRACAO_CONCLUIDA = 'N';
     
  ELSE 
     V_SERVIDOR := '\\SRVDC38';
     V_HOST_FTP := '10.0.1.3';
     V_OWNER := '';
     
     SELECT COUNT(1) 
      INTO V_EFETUAR_CARGA
      FROM NEW_CUSTOMER
     WHERE INTEGRACAO_CONCLUIDA = 'N';
     
END IF;  
   
  FOR NEW_GROUP_CONFIG IN
    (SELECT USER_FTP
            ,PASSWORD_FTP
            ,LAYOUT
            ,DIRETORIO_PED
            ,DIRETORIO_RET
            ,EXTENSAO_ARQ_PED
            ,EXTENSAO_ARQ_RET
            ,CASE WHEN LAYOUT IN ( 'DROGACENTER PADRAO 1.0'
                                  ,'VSM'
                                  ,'CONSYS'
                                  ,'CALLFARMA') 
                  THEN 'RETORNO'||REPLACE(EXTENSAO_ARQ_RET,'*','')
                    ELSE 
                      CASE WHEN LAYOUT IN ('PODIUM')
                        THEN '%FILENAME%EXT%'
                        ELSE '%FILENAME%'||REPLACE(EXTENSAO_ARQ_RET,'*','')
              END 
              END AS NOMENCLATURA_RETORNO 
            ,COUNT(1) 
       FROM NEW_CUSTOMER
     WHERE INTEGRACAO_CONCLUIDA = 'N'
      GROUP BY USER_FTP 
               ,PASSWORD_FTP
               ,LAYOUT
               ,DIRETORIO_PED
               ,DIRETORIO_RET
               ,EXTENSAO_ARQ_PED
               ,EXTENSAO_ARQ_RET) LOOP
               
   V_DIRETORIO:=NULL;           
   
   SELECT CTR_ID + 1 
     INTO V_MAX_ID_CUSTOMER 
      FROM (SELECT MAX(CTR_ID) AS CTR_ID 
              FROM DCEDICLI_QA.CUSTOMER);
    
    SELECT CLR_ID + 1
      INTO V_MAX_ID_CLUSTER 
      FROM (SELECT MAX(CLR_ID) AS CLR_ID 
              FROM DCEDICLI_QA.IO_CLUSTER); 
              
         BEGIN --DADOS CLUSTER
                 FOR IO_CLUSTER IN 
                   (SELECT USER_FTP 
                      FROM NEW_CUSTOMER
                     WHERE UPPER(USER_FTP) = UPPER(NEW_GROUP_CONFIG.USER_FTP)
                       AND NOT EXISTS (SELECT * 
                                         FROM DCEDICLI_QA.IO_CLUSTER
                                        WHERE UPPER(CLR_NAME) = UPPER(USER_FTP))
                    GROUP BY USER_FTP) LOOP
                             
                    INSERT INTO DCEDICLI_QA.IO_CLUSTER 
                                  (CLR_ID
                                   ,CLR_NAME
                                   ,CLR_ENABLED) 
                           VALUES ((SELECT MAX(CLR_ID) + 1 
                                      FROM DCEDICLI_QA.IO_CLUSTER)
                                    ,UPPER(IO_CLUSTER.USER_FTP)
                                    ,V_ATIVAR_CLUSTER);
                     COMMIT;
                     
                     V_CHECK := V_CHECK + 1;
                     
                END LOOP; 
                    
                  SELECT CLR_ID 
                   INTO V_CLUSTER
                   FROM DCEDICLI_QA.IO_CLUSTER
                   WHERE UPPER(CLR_NAME) = UPPER(NEW_GROUP_CONFIG.USER_FTP);
                                
                    IF V_CHECK = 0 THEN 
                     DBMS_OUTPUT.put_line('CLUSTER '
                                        || V_CLUSTER 
                                        ||' - '
                                        ||NEW_GROUP_CONFIG.USER_FTP
                                        ||' -  CLUSTER JÁ EXISTE NA BASE!');
                    ELSE 
                      DBMS_OUTPUT.put_line('CLUSTER '
                                            || V_CLUSTER 
                                            ||' - '
                                            ||NEW_GROUP_CONFIG.USER_FTP
                                            ||' -  TOTAL DE CLUSTERS INSERIDOS: ' 
                                            || V_CHECK);
                    END IF ;
                                  
             END;
             
             V_CHECK := 0;        
               
          BEGIN -- DADOS CUSTOMER
                FOR CUSTOMER 
                  IN (SELECT * 
                        FROM NEW_CUSTOMER
                       WHERE USER_FTP = NEW_GROUP_CONFIG.USER_FTP
                         AND INTEGRACAO_CONCLUIDA = 'N'   
                         AND NOT EXISTS 
                             (SELECT * 
                                FROM DCEDICLI_QA.CUSTOMER 
                               WHERE CTR_CODE = CODIGO_CLI)) LOOP 
                               
                  V_CLIENTE := CUSTOMER.CODIGO_CLI;
                  
                  DBMS_OUTPUT.put_line('Cluster: '||V_CLUSTER||' - Cliente adicionado: '||V_CLIENTE);
                   
                  INSERT INTO DCEDICLI_QA.CUSTOMER 
                      SELECT  (SELECT MAX(CTR_ID) + 1 FROM  DCEDICLI_QA.CUSTOMER)
                              ,ABAN8 AS CTR_CODE
                              ,TRIM(ABTAX) AS CTR_TAXID
                              ,ABALPH AS CTR_NAME
                              ,TRIM(ABAC16) AS CTR_UF
                              ,ALCTY1 AS CTR_CITY
                              ,AIHOLD AS CTR_STATUS
                              ,0 AS CTR_CREDIT
                              ,LPAD(CUSTOMER.FILIAL,12,' ')
                              ,CUSTOMER.COND_PGTO AS CTR_BILLINGCODE
                              ,TRIM(DRDL02) AS CTR_CLOSINGTIME       
                         FROM QADTA.F0101  T1, 
                              QADTA.F03012 T2,
                              QADTA.F0116  T3,
                              QADTA.F0005  T4
                        WHERE ABAN8 = AIAN8 (+)
                          AND ABAN8 = ALAN8 (+)
                          AND AIZON = TRIM(DRKY(+))
                          AND DRSY(+) = '40'
                          AND DRRT(+) = 'ZN'
                          AND ABAN8(+) = CUSTOMER.CODIGO_CLI;
                COMMIT;                     
                 V_CHECK := V_CHECK + 1; 
                 
                END LOOP;                
                
                IF V_CHECK = 0 THEN 
                  
                  DBMS_OUTPUT.put_line('CLUSTER '
                                        || V_CLUSTER 
                                        ||' - '
                                        ||NEW_GROUP_CONFIG.USER_FTP
                                        ||' -  CLIENTES JÁ EXISTEM NA BASE!');
                ELSE 
                  DBMS_OUTPUT.put_line('CLUSTER '
                                        || V_CLUSTER 
                                        ||' - '
                                        ||NEW_GROUP_CONFIG.USER_FTP
                                        ||' -  TOTAL DE CLIENTES INSERIDOS: ' 
                                        || V_CHECK);
                END IF;
           END;
           
            V_CHECK := 0; 
            
             
             BEGIN --DADOS IO_CLUSTER_CFG_CUSTOMER
                  FOR IO_CLUSTER_CFG_CUSTOMER IN 
                     (SELECT CTR_ID
                        FROM DCEDICLI_QA.CUSTOMER T1
                             ,NEW_CUSTOMER
                       WHERE UPPER(USER_FTP) = UPPER(NEW_GROUP_CONFIG.USER_FTP)
                         AND CODIGO_CLI = CTR_CODE
                         AND NOT EXISTS
                                 (SELECT * 
                                    FROM DCEDICLI_QA.IO_CLUSTER_CFG_CUSTOMER T2 
                                         ,DCEDICLI_QA.IO_CLUSTER             T3
                                   WHERE T2.CTR_ID = T1.CTR_ID
                                     AND T2.CLR_ID = T3.CLR_ID
                                     AND T3.CLR_NAME = UPPER(NEW_GROUP_CONFIG.USER_FTP))
                                   ORDER BY CTR_ID) LOOP
                                          
                     INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_CUSTOMER 
                         (CCC_ID
                          ,CLR_ID
                          ,CCC_ENABLED
                          ,CTR_ID
                          ,CCC_ORDERBY1
                          ,CCC_ORDERBY2)
                            VALUES ((SELECT MAX(CCC_ID) + 1 
                                      FROM DCEDICLI_QA.IO_CLUSTER_CFG_CUSTOMER)
                                     ,(SELECT CLR_ID 
                                         FROM DCEDICLI_QA.IO_CLUSTER
                                        WHERE UPPER(CLR_NAME) = UPPER(NEW_GROUP_CONFIG.USER_FTP))
                                     ,'Y'
                                     ,IO_CLUSTER_CFG_CUSTOMER.CTR_ID
                                     ,0
                                     ,0);
                       COMMIT;   
                                      
                       V_CHECK := V_CHECK + 1;
                     
                END LOOP;     
                
                    IF V_CHECK = 0 THEN 
                       DBMS_OUTPUT.put_line('CLUSTER '
                                            || V_CLUSTER 
                                            ||' - '
                                            ||NEW_GROUP_CONFIG.USER_FTP
                                            ||' -  CONFIG CUSTOMER CLUSTER JÁ EXISTE NA BASE!');
                    ELSE 
                      DBMS_OUTPUT.put_line('CLUSTER '
                                            || V_CLUSTER 
                                            ||' - '
                                            ||NEW_GROUP_CONFIG.USER_FTP
                                            ||' -  TOTAL DE CONFIG CUSTOMER CLUSTERS INSERIDAS: ' 
                                            || V_CHECK);
                    END IF ;              
                    
               END;
               
               V_CHECK := 0; 
               
               BEGIN --DADOS IO_CLUSTER_CFG_FILE
                  FOR IO_CLUSTER_CFG_FILE IN 
                     (SELECT CLR_ID 
                        FROM DCEDICLI_QA.IO_CLUSTER T1
                       WHERE UPPER(CLR_NAME) = UPPER(NEW_GROUP_CONFIG.USER_FTP)
                         AND NOT EXISTS (SELECT * 
                                           FROM DCEDICLI_QA.IO_CLUSTER_CFG_FILE T2
                                          WHERE T2.CLR_ID = T1.CLR_ID)) LOOP                       
                                          
                     INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_FILE 
                         (CCF_ID
                          ,CLR_ID
                          ,SCH_TYPE
                          ,SCH_OPER
                          ,SCH_CODE
                          ,CCF_PATH
                          ,CCF_LIMITFILES
                          ,CCF_MOVE_FILE
                          ,CCF_MOVE_PATH
                          ,CCF_ENABLED
                          ,CCF_MASK_FILE
                          ,CCF_SAVE_NAME
                          ,CCF_AFTER_IMP_ACT
                          ,CCF_SEC_DIR_SAFE_COPY
                          ,CCF_PURGE_IMP_FILE
                          ,CCF_PURGE_IMP_FILE_DAYS
                          ,CCF_ORDERBY1
                          ,CCF_ORDERBY2)
                            VALUES ((SELECT MAX(CCF_ID) + 1 
                                      FROM DCEDICLI_QA.IO_CLUSTER_CFG_FILE)
                                     ,IO_CLUSTER_CFG_FILE.CLR_ID
                                     ,'FILE'
                                     ,'I'
                                     ,0
                                     ,V_SERVIDOR||'\DCEDICLI\'||UPPER(NEW_GROUP_CONFIG.USER_FTP)||'\'||UPPER(NEW_GROUP_CONFIG.DIRETORIO_PED)
                                     ,0
                                     ,'Y'
                                     ,V_SERVIDOR||'\DCEDICLI\'||UPPER(NEW_GROUP_CONFIG.USER_FTP)||'\PROCESSADOS'
                                     ,'Y'
                                     ,NEW_GROUP_CONFIG.EXTENSAO_ARQ_PED
                                     ,''
                                     ,1
                                     ,5
                                     ,'N'
                                     ,0
                                     ,0
                                     ,0
                                     );
                       COMMIT;
                       
                       V_DIRETORIO:=V_DIRETORIO||V_MKDIR|| V_SERVIDOR||'\DCEDICLI\'||UPPER(NEW_GROUP_CONFIG.USER_FTP)||'\'||UPPER(NEW_GROUP_CONFIG.DIRETORIO_PED)||';'||CHR(13);
                       V_DIRETORIO:=V_DIRETORIO||V_MKDIR||V_SERVIDOR||'\DCEDICLI\'||UPPER(NEW_GROUP_CONFIG.USER_FTP)||'\PROCESSADOS'||';'||CHR(13);                    
                       V_CHECK := V_CHECK + 1;
                       
                       INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_FILE 
                         (CCF_ID
                          ,CLR_ID
                          ,SCH_TYPE
                          ,SCH_OPER
                          ,SCH_CODE
                          ,CCF_PATH
                          ,CCF_LIMITFILES
                          ,CCF_MOVE_FILE
                          ,CCF_MOVE_PATH
                          ,CCF_ENABLED
                          ,CCF_MASK_FILE
                          ,CCF_SAVE_NAME
                          ,CCF_AFTER_IMP_ACT
                          ,CCF_SEC_DIR_SAFE_COPY
                          ,CCF_PURGE_IMP_FILE
                          ,CCF_PURGE_IMP_FILE_DAYS
                          ,CCF_ORDERBY1
                          ,CCF_ORDERBY2)
                            VALUES ((SELECT MAX(CCF_ID) + 1 
                                      FROM DCEDICLI_QA.IO_CLUSTER_CFG_FILE)
                                     ,IO_CLUSTER_CFG_FILE.CLR_ID
                                     ,'FILE'
                                     ,'O'
                                     ,0
                                     ,V_SERVIDOR||'\DCEDICLI\'||UPPER(NEW_GROUP_CONFIG.USER_FTP)||'\'||UPPER(NEW_GROUP_CONFIG.DIRETORIO_RET)
                                     ,0
                                     ,'Y'
                                     ,V_SERVIDOR||'\DCEDICLI\'||UPPER(NEW_GROUP_CONFIG.USER_FTP)||'\PROCESSADOS'
                                     ,'Y'
                                     ,NEW_GROUP_CONFIG.EXTENSAO_ARQ_RET
                                     ,NEW_GROUP_CONFIG.NOMENCLATURA_RETORNO
                                     ,1
                                     ,0
                                     ,'N'
                                     ,0
                                     ,0
                                     ,0
                                     );
                       COMMIT;  
                        
                       V_DIRETORIO := V_DIRETORIO||V_MKDIR||V_SERVIDOR||'\DCEDICLI\'||UPPER(NEW_GROUP_CONFIG.USER_FTP)||'\'||UPPER(NEW_GROUP_CONFIG.DIRETORIO_RET)||';'||CHR(13);
                       
                       V_CHECK := V_CHECK + 1;
                     
                END LOOP;     
                
                    IF V_CHECK = 0 THEN 
                       DBMS_OUTPUT.put_line('CLUSTER '
                                            || V_CLUSTER 
                                            ||' - '
                                            ||NEW_GROUP_CONFIG.USER_FTP
                                            ||' -  CONFIG CLUSTER FILE JÁ EXISTE NA BASE!');
                    ELSE 
                      DBMS_OUTPUT.put_line('CLUSTER '
                                            || V_CLUSTER 
                                            ||' - '
                                            ||NEW_GROUP_CONFIG.USER_FTP
                                            ||' -  TOTAL DE CONFIG CLUSTER FILE INSERIDA: ' 
                                            || V_CHECK);
                    END IF ;              
                    
               END;
               
                V_CHECK := 0; 
              
                BEGIN --DADOS IO_CLUSTER_CFG_FTP
                  FOR IO_CLUSTER_CFG_FTP IN 
                     (SELECT CLR_ID 
                        FROM DCEDICLI_QA.IO_CLUSTER T1
                       WHERE UPPER(CLR_NAME) = UPPER(NEW_GROUP_CONFIG.USER_FTP)
                         AND NOT EXISTS (SELECT * 
                                           FROM DCEDICLI_QA.IO_CLUSTER_CFG_FTP T2
                                          WHERE T2.CLR_ID = T1.CLR_ID)) LOOP                       
                                          
                     INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_FTP 
                         (CCP_ID
                          ,CCP_ENABLED
                          ,CLR_ID
                          ,SCH_TYPE
                          ,SCH_OPER
                          ,SCH_CODE
                          ,CCP_HOST
                          ,CCP_PORT
                          ,CCP_USER
                          ,CCP_PWD
                          ,CCP_PASSIVE_MODE
                          ,CCP_REM_LIMITFILES
                          ,CCP_REM_SEC_DIR_SAFE_CP
                          ,CCP_REM_AFTER_CP_ACT
                          ,CCP_REM_DIR
                          ,CCP_REM_FILE_MASK
                          ,CCP_REM_MOVE_DIR          
                          ,CCP_REM_REN_EXT
                          ,CCP_LOC_LIMITFILES
                          ,CCP_LOC_SEC_DIR_SAFE_CP
                          ,CCP_LOC_AFTER_CP_ACT
                          ,CCP_LOC_DIR
                          ,CCP_LOC_FILE_MASK
                          ,CCP_LOC_MOVE_DIR
                          ,CCP_LOC_REN_EXT
                          ,CCP_FTP_LOG_ENABLED
                          ,CCP_FTP_LOG_FILE_PATH
                          ,CCP_ORDERBY1
                          ,CCP_ORDERBY2
                          )
                            VALUES ((SELECT MAX(CCP_ID) + 1 
                                      FROM DCEDICLI_QA.IO_CLUSTER_CFG_FTP)
                                     ,'Y'
                                     ,IO_CLUSTER_CFG_FTP.CLR_ID
                                     ,'FTP'
                                     ,'I'
                                     ,0
                                     ,V_HOST_FTP
                                     ,21
                                     ,NEW_GROUP_CONFIG.USER_FTP
                                     ,NEW_GROUP_CONFIG.PASSWORD_FTP
                                     ,'Y'
                                     ,0
                                     ,5
                                     ,1
                                     ,NEW_GROUP_CONFIG.DIRETORIO_PED||'/'
                                     ,NEW_GROUP_CONFIG.EXTENSAO_ARQ_PED
                                     ,''
                                     ,''
                                     ,0
                                     ,0
                                     ,0
                                     ,V_SERVIDOR||'\DCEDICLI\'||UPPER(NEW_GROUP_CONFIG.USER_FTP)||'\'||UPPER(NEW_GROUP_CONFIG.DIRETORIO_PED)
                                     ,'*.*'
                                     ,''
                                     ,''
                                     ,'N'
                                     ,0
                                     ,0
                                     ,0
                                     );
                       COMMIT;
                        V_CHECK := V_CHECK + 1;
                       
                       INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_FTP
                         (CCP_ID
                          ,CCP_ENABLED
                          ,CLR_ID
                          ,SCH_TYPE
                          ,SCH_OPER
                          ,SCH_CODE
                          ,CCP_HOST
                          ,CCP_PORT
                          ,CCP_USER
                          ,CCP_PWD
                          ,CCP_PASSIVE_MODE
                          ,CCP_REM_LIMITFILES
                          ,CCP_REM_SEC_DIR_SAFE_CP
                          ,CCP_REM_AFTER_CP_ACT
                          ,CCP_REM_DIR
                          ,CCP_REM_FILE_MASK
                          ,CCP_REM_MOVE_DIR          
                          ,CCP_REM_REN_EXT
                          ,CCP_LOC_LIMITFILES
                          ,CCP_LOC_SEC_DIR_SAFE_CP
                          ,CCP_LOC_AFTER_CP_ACT
                          ,CCP_LOC_DIR
                          ,CCP_LOC_FILE_MASK
                          ,CCP_LOC_MOVE_DIR
                          ,CCP_LOC_REN_EXT
                          ,CCP_FTP_LOG_ENABLED
                          ,CCP_FTP_LOG_FILE_PATH
                          ,CCP_ORDERBY1
                          ,CCP_ORDERBY2)
                            VALUES ((SELECT MAX(CCP_ID) + 1 
                                      FROM DCEDICLI_QA.IO_CLUSTER_CFG_FTP)
                                     ,'Y'
                                     ,IO_CLUSTER_CFG_FTP.CLR_ID
                                     ,'FTP'
                                     ,'O'
                                     ,0
                                     ,V_HOST_FTP
                                     ,21
                                     ,NEW_GROUP_CONFIG.USER_FTP
                                     ,NEW_GROUP_CONFIG.PASSWORD_FTP
                                     ,'Y'
                                     ,0
                                     ,5
                                     ,1
                                     ,'retorno/'
                                     ,'*.*'
                                     ,''
                                     ,''
                                     ,0
                                     ,0
                                     ,1
                                     ,V_SERVIDOR||'\DCEDICLI\'||UPPER(NEW_GROUP_CONFIG.USER_FTP)||'\'||UPPER(NEW_GROUP_CONFIG.DIRETORIO_RET)
                                     ,NEW_GROUP_CONFIG.EXTENSAO_ARQ_RET
                                     ,''
                                     ,''
                                     ,'N'
                                     ,0
                                     ,0
                                     ,0
                                     );
                       COMMIT;              
                       V_CHECK := V_CHECK + 1;
                     
                END LOOP;     
                
                    IF V_CHECK = 0 THEN 
                       DBMS_OUTPUT.put_line('CLUSTER '
                                            || V_CLUSTER 
                                            ||' - '
                                            ||NEW_GROUP_CONFIG.USER_FTP
                                            ||' -  CONFIG CLUSTER FTP JÁ EXISTE NA BASE!');
                    ELSE 
                      DBMS_OUTPUT.put_line('CLUSTER '
                                            || V_CLUSTER 
                                            ||' - '
                                            ||NEW_GROUP_CONFIG.USER_FTP
                                            ||' -  TOTAL DE CONFIG CLUSTER FTP INSERIDA: ' 
                                            || V_CHECK);
                    END IF ;              
                    
               END;
               
               V_CHECK := 0; 
               
               BEGIN --DADOS IO_CLUSTER_CFG_INTEGRATION
                  FOR IO_CLUSTER_CFG_INTEGRATION IN 
                     (SELECT CLR_ID 
                        FROM DCEDICLI_QA.IO_CLUSTER T1
                       WHERE UPPER(CLR_NAME) = UPPER(NEW_GROUP_CONFIG.USER_FTP)
                         AND NOT EXISTS (SELECT * 
                                           FROM DCEDICLI_QA.IO_CLUSTER_CFG_INTEGRATION T2
                                          WHERE T2.CLR_ID = T1.CLR_ID)) LOOP                       
                                          
                     INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_INTEGRATION 
                         (CCI_ID
                          ,CLR_ID
                          ,CCI_ENABLED
                          ,SCH_OPER
                          ,CCI_ORDERBY1
                          ,CCI_ORDERBY2
                          )
                            VALUES ((SELECT MAX(CCI_ID) + 1 
                                      FROM DCEDICLI_QA.IO_CLUSTER_CFG_INTEGRATION)
                                     ,IO_CLUSTER_CFG_INTEGRATION.CLR_ID
                                     ,'Y'
                                     ,'I'
                                     ,0
                                     ,0
                                     );
                       COMMIT;
                        V_CHECK := V_CHECK + 1;
                       
                      INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_INTEGRATION 
                         (CCI_ID
                          ,CLR_ID
                          ,CCI_ENABLED
                          ,SCH_OPER
                          ,CCI_ORDERBY1
                          ,CCI_ORDERBY2
                          )
                            VALUES ((SELECT MAX(CCI_ID) + 1 
                                      FROM DCEDICLI_QA.IO_CLUSTER_CFG_INTEGRATION)
                                     ,IO_CLUSTER_CFG_INTEGRATION.CLR_ID
                                     ,'Y'
                                     ,'O'
                                     ,0
                                     ,0
                                     );
                       COMMIT;    
                       V_CHECK := V_CHECK + 1;
                     
                END LOOP;     
                
                    IF V_CHECK = 0 THEN 
                       DBMS_OUTPUT.put_line('CLUSTER '
                                            || V_CLUSTER 
                                            ||' - '
                                            ||NEW_GROUP_CONFIG.USER_FTP
                                            ||' -  CONFIG CLUSTER INTEGRATION JÁ EXISTE NA BASE!');
                    ELSE 
                      DBMS_OUTPUT.put_line('CLUSTER '
                                            || V_CLUSTER 
                                            ||' - '
                                            ||NEW_GROUP_CONFIG.USER_FTP
                                            ||' -  TOTAL DE CONFIG INTEGRATION INSERIDA: ' 
                                            || V_CHECK);
                    END IF ;             
                    
               END;
               
                V_CHECK := 0; 
               
               BEGIN --DADOS DSL_IO_CLUSTER_CFG_LAYOUT
                  FOR IO_CLUSTER_CFG_LAYOUT IN 
                     (SELECT CLR_ID 
                        FROM DCEDICLI_QA.IO_CLUSTER T1
                       WHERE UPPER(CLR_NAME) = UPPER(NEW_GROUP_CONFIG.USER_FTP)
                         AND NOT EXISTS (SELECT * 
                                           FROM DCEDICLI_QA.IO_CLUSTER_CFG_LAYOUT T2
                                          WHERE T2.CLR_ID = T1.CLR_ID)) LOOP                       
                                          
                     INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_LAYOUT 
                         (CCL_ID
                          ,CLR_ID
                          ,CCL_ENABLED
                          ,SCH_OPER
                          ,LAY_ID
                          ,CCL_ORDERBY1
                          ,CCL_ORDERBY2
                          )
                            VALUES ((SELECT MAX(CCL_ID) + 1 
                                      FROM DCEDICLI_QA.IO_CLUSTER_CFG_LAYOUT)
                                     ,IO_CLUSTER_CFG_LAYOUT.CLR_ID
                                     ,'Y'
                                     ,'I'
                                     ,(SELECT LAY_ID 
                                         FROM DCEDICLI_QA.LAYOUT 
                                        WHERE LAY_OPER = 'I' 
                                          AND LAY_DESCRIPTION LIKE ('%'||NEW_GROUP_CONFIG.LAYOUT||'%'))
                                     ,0
                                     ,0
                                     );
                       COMMIT;
                        V_CHECK := V_CHECK + 1;
                       
                      INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_LAYOUT 
                         (CCL_ID
                          ,CLR_ID
                          ,CCL_ENABLED
                          ,SCH_OPER
                          ,LAY_ID
                          ,CCL_ORDERBY1
                          ,CCL_ORDERBY2
                          )
                            VALUES ((SELECT MAX(CCL_ID) + 1 
                                      FROM DCEDICLI_QA.IO_CLUSTER_CFG_LAYOUT)
                                     ,IO_CLUSTER_CFG_LAYOUT.CLR_ID
                                     ,'Y'
                                     ,'O'
                                     ,(SELECT LAY_ID 
                                         FROM DCEDICLI_QA.LAYOUT 
                                        WHERE LAY_OPER = 'O' 
                                          AND LAY_DESCRIPTION LIKE ('%'||NEW_GROUP_CONFIG.LAYOUT||'%'))
                                     ,0
                                     ,0
                                     );
                       COMMIT;    
                       V_CHECK := V_CHECK + 1;
                     
                END LOOP;     
                
                    IF V_CHECK = 0 THEN 

                       DBMS_OUTPUT.put_line('CLUSTER '
                                            || V_CLUSTER 
                                            ||' - '
                                            ||NEW_GROUP_CONFIG.USER_FTP
                                            ||' -  CONFIG CLUSTER CONFIG LAYOUT JÁ EXISTE NA BASE!');
                    ELSE 
                      DBMS_OUTPUT.put_line('CLUSTER '
                                            || V_CLUSTER 
                                            ||' - '
                                            ||NEW_GROUP_CONFIG.USER_FTP
                                            ||' -  TOTAL DE CLUSTER CONFIG LAYOUT INSERIDA: ' 
                                            || V_CHECK);
                    END IF;             
                    
               END;
               
                V_CHECK := 0; 
               
               BEGIN 
                    
                  FOR IO_CLUSTER_CFG_RETURN_CODE IN 
                     (SELECT T2.CLR_ID AS CLR_ID
                        FROM DCEDICLI_QA.LAYOUT T1
                             ,DCEDICLI_QA.IO_CLUSTER_CFG_LAYOUT T2
                       WHERE INSTR(T1.LAY_DESCRIPTION,NEW_GROUP_CONFIG.LAYOUT) > 0 
                         AND UPPER(LAY_JSON_CONFIG) LIKE '%CCR%'
                         AND T1.LAY_ID = T2.LAY_ID
                         AND T1.LAY_OPER = 'O'
                         AND NOT EXISTS (SELECT * 
                                           FROM DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE T3
                                          WHERE T3.CLR_ID = T2.CLR_ID)
                      ) LOOP    
                     
                     IF(NEW_GROUP_CONFIG.LAYOUT NOT IN ('PHARMALINK','VAN CLAMED','DROGACENTER PADRAO 2.0','SOFTPHARMA')) THEN
                     
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','901','06','Falta de estoque','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','620','00','Atendido','N','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','980','06','Falta de estoque','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','610','00','Atendido','N','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','982','03','Pedido não alcançou o valor mínimo','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','984','02','Falta de limite de crédito','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9100','','01','Problemas cadastrais','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9101','','01','Problemas cadastrais','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9102','','01','Problemas cadastrais','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9103','980','05','Produto não cadastrado / desativado','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9103','984','05','Produto não cadastrado / desativado','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9103','982','05','Produto não cadastrado / desativado','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','901','06','Falta de estoque','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','984','02','Falta de limite de crédito','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','610','00','Atendido','N','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','982','03','Pedido não alcançou o valor mínimo','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','620','00','Atendido','N','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9100','980','01','Problemas cadastrais','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9101','980','01','Problemas cadastrais','N','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9102','980','01','Problemas cadastrais','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9103','980','05','Produto não cadastrado / desativado','Y','','','','','');

                    ELSIF (NEW_GROUP_CONFIG.LAYOUT = 'VAN CLAMED') THEN 
                        
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','980','06','ESTOQUE INSUFICIENTE','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','982','03','FATURAMENTO MINIMO','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','901','901','ESTOQUE INSUFICIENTE','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','984','02','LIMITE CREDITO','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9103','980','05','ESTOQUE INSUFICIENTE','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9103','982','05','ESTOQUE INSUFICIENTE','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9103','984','05','ESTOQUE INSUFICIENTE','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','982','03','NAO ATINGIU O VALOR MINIMO','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','901','901','ESTOQUE INSUFICIENTE','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','984','02','LIMITE CREDITO','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9100','980','01','DOCUMENTACAO PENDENTE','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9101','980','01','DOCUMENTACAO PENDENTE','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9102','980','01','DOCUMENTACAO PENDENTE','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9103','980','05','ESTOQUE INSUFICIENTE','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9103','985','05','ESTOQUE INSUFICIENTE','Y','','','','','');
                     
                     ELSIF (NEW_GROUP_CONFIG.LAYOUT = 'DROGACENTER PADRAO 2.0') THEN  
                     
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','620','1','Atendido','N','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','984','3','Falta de limite de crédito','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','982','3','Pedido não alcançou o valor mínimo','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','610','2','Atendido','N','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','980','3','Falta de estoque','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','901','3','Falta de estoque','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9100','','3','Problemas cadastrais','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9101','','3','Problemas cadastrais','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9102','','3','Problemas cadastrais','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9103','980','3','Produto não cadastrado / desativado','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9103','984','3','Produto não cadastrado / desativado','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9103','982','3','Produto não cadastrado / desativado','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','901','3','Falta de estoque','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','610','2','Atendido','N','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','984','3','Falta de limite de crédito','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','982','3','Pedido não alcançou o valor mínimo','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','620','1','Atendido','N','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9100','980','3','Problemas cadastrais','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9101','980','3','Problemas cadastrais','N','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9102','980','3','Problemas cadastrais','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9103','980','3','Produto não cadastrado / desativado','Y','','','','','');
                    
                    ELSIF (NEW_GROUP_CONFIG.LAYOUT = 'SOFTPHARMA') THEN  
                        
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','901','02','Falta de estoque','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','620','00','Atendido','N','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','610','00','Atendido','N','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','980','02','Falta de estoque','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','982','02','Pedido não alcançou o valor mínimo','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S1210','984','02','Falta de limite de crédito','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9100','','03','Problemas cadastrais','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9101','','03','Problemas cadastrais','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9102','','03','Problemas cadastrais','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9103','980','01','Produto não cadastrado / desativado','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9103','984','01','Produto não cadastrado / desativado','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'DETAIL','O','S9103','982','01','Produto não cadastrado / desativado','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','901','3','Falta de estoque','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','610','2','Atendido','N','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','620','1','Atendido','N','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','982','3','Pedido não alcançou o valor mínimo','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S1210','984','3','Falta de limite de crédito','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9100','980','3','Problemas cadastrais','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9101','980','3','Problemas cadastrais','N','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9102','980','3','Problemas cadastrais','Y','','','','','');
                        INSERT INTO DCEDICLI_QA.IO_CLUSTER_CFG_RETURN_CODE VALUES (IO_CLUSTER_CFG_RETURN_CODE.CLR_ID,'HEADER','O','S9103','980','3','Produto não cadastrado / desativado','Y','','','','','');
                   
                    END IF; 

                    
                     COMMIT;    
                       V_CHECK := V_CHECK + 1;
             
                 END LOOP;
                 
                 IF V_CHECK = 0 THEN 

                       DBMS_OUTPUT.put_line('CLUSTER '
                                            || V_CLUSTER 
                                            ||' - '
                                            ||NEW_GROUP_CONFIG.USER_FTP
                                            ||' -  CONFIG CLUSTER CONFIG RETURN CODE JÁ EXISTE NA BASE OU LAYOUT NAO TEM MOTIVO DE RETORNO!');
                    ELSE 
                      DBMS_OUTPUT.put_line('CLUSTER '
                                            || V_CLUSTER 
                                            ||' - '
                                            ||NEW_GROUP_CONFIG.USER_FTP
                                            ||' -  TOTAL DE CLUSTER CONFIG RETURN CODE INSERIDA: ' 
                                            || V_CHECK);
                    END IF;           
               
                 END;
              
               UPDATE NEW_CUSTOMER
                  SET INTEGRACAO_CONCLUIDA = 'Y'
                 WHERE CODIGO_CLI = V_CLIENTE
                   AND UPPER(USER_FTP) = UPPER(NEW_GROUP_CONFIG.USER_FTP);     
            COMMIT;
                                
            V_CHECK := 0; 
             DBMS_OUTPUT.put_line(REPLACE(V_DIRETORIO,'D:','\\SRVDC11'));
                                        
    END LOOP;
   

END;
