--CRPDTA
SELECT *
  FROM (SELECT CAUKID AS CODIGO_ACAO,
               CAALPH AS NOME_ACAO,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(CNEUSE) || ','))
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542097
                 WHERE CNPUKID = CAPUKID
                   AND CNUKID = CAUKID) AS CANAIS_CAPTACAO,
                   
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(CIVEND) || ','))
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542095
                 WHERE CIPUKID = CAPUKID
                   AND TRIM(CIVEND) NOT IN ('0')
                   AND CIUKID = CAUKID) AS CODIGOS_INDUSTRIA,
                   
                (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(CIPTC) || ','))
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542095
                 WHERE CIPUKID = CAPUKID
                   AND TRIM(CIPTC) NOT IN ('0')
                   AND CIUKID = CAUKID) AS PTC_INDUSTRIA,
              
NVL(NVL(NVL(NVL(NVL(NVL(NVL(NVL(NVL(NVL(NVL(
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCAN8)) || ',') ORDER BY CCAN8)
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCAN8) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID), --AS CLIENTES,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCAC15)) || ',') ORDER BY CCAC15)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCAC15) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID)), --AS AC15_CLIENTE,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCAC10)) || ',') ORDER BY CCAC10)
                                 .extract('//text()'),
                                 ',')
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCAC10) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID)), --AS AC10_CLIENTE,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCAC14)) || ',') ORDER BY CCAC14)
                                 .extract('//text()'),
                                 ',')
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCAC14) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID)),-- AS AC14_CLIENTE,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCAC28)) || ',') ORDER BY CCAC28)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCAC28) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID)), --AS AC28_CLIENTE,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCPA8)) || ',') ORDER BY CCPA8)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCPA8) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID)),-- AS PA8_CLIENTE,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCWN004)) || ',') ORDER BY CCWN004)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCWN004) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID)),-- AS BANDEIRA_CLIENTE,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCWN005)) || ',') ORDER BY CCWN005)
                                 .extract('//text()'),
                                 ',')
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCWN005) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID)),-- AS UNIAO_BANDEIRAS_CLIENTE, 
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCWN006)) || ',') ORDER BY CCWN006)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCWN006) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID)),-- AS FEDERACAO_CLIENTE,  
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCAC07)) || ',') ORDER BY CCAC07)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCAC07) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID)),-- AS AREA_CLIENTE,    
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCAC01)) || ',') ORDER BY CCAC01)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCAC01) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID)),-- AS SETOR_CLIENTE,      
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCADDS)) || ',') ORDER BY CCADDS)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCADDS) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID)) AS SELECAO_CLIENTES, -- AS UF_CLIENTE                                       
NVL(NVL(NVL(NVL(NVL(                  
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CILITM)) || ','))
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542098
                 WHERE CIPUKID = CAPUKID
                  AND TRIM(CILITM) NOT IN ('0')
                   AND CIUKID = CAUKID), --AS LITM_PRODUTOS,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CIUORG)) || ','))
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542098
                 WHERE CIPUKID = CAPUKID
                   AND CIUKID = CAUKID
                   AND ROWNUM = 1
                   AND TRIM(CIUORG) NOT IN ('0'))), --AS QTDE_SOLIC_PRODUTOS,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CIPRP1)) || ','))
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542098
                 WHERE CIPUKID = CAPUKID
                   AND CIUKID = CAUKID
                   AND ROWNUM = 1
                   AND TRIM(CIPRP1) NOT IN ('0'))), -- AS CLASSE_PRP1_PRODUTOS,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CIPRP2)) || ','))
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542098
                 WHERE CIPUKID = CAPUKID
                   AND CIUKID = CAUKID
                   AND ROWNUM = 1
                   AND TRIM(CIPRP2) NOT IN ('0'))), -- AS SUBCLASSE_PRP2_PRODUTOS,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CISRP5)) || ','))
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542098
                 WHERE CIPUKID = CAPUKID
                   AND CIUKID = CAUKID
                   AND ROWNUM = 1
                   AND TRIM(CISRP5) NOT IN ('0'))), -- AS GRUPO_LAB_SRP5_PRODUTOS,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CIPTC)) || ','))
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542098
                 WHERE CIPUKID = CAPUKID
                   AND CIUKID = CAUKID
                   AND ROWNUM = 1
                   AND TRIM(CIPTC) NOT IN ('0')))  AS SELECAO_PRODUTOS,
  
-----------

(SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCAN8)) || ',') ORDER BY CCAN8)
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCAN8) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID) AS CLIENTES,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCAC15)) || ',') ORDER BY CCAC15)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCAC15) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID) AS AC15_CLIENTE,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCAC10)) || ',') ORDER BY CCAC10)
                                 .extract('//text()'),
                                 ',')
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCAC10) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID) AS AC10_CLIENTE,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCAC14)) || ',') ORDER BY CCAC14)
                                 .extract('//text()'),
                                 ',')
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCAC14) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID) AS AC14_CLIENTE,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCAC28)) || ',') ORDER BY CCAC28)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCAC28) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID) AS AC28_CLIENTE,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCPA8)) || ',') ORDER BY CCPA8)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCPA8) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID) AS PA8_CLIENTE,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCWN004)) || ',') ORDER BY CCWN004)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCWN004) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID) AS BANDEIRA_CLIENTE,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCWN005)) || ',') ORDER BY CCWN005)
                                 .extract('//text()'),
                                 ',')
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCWN005) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID) AS UNIAO_BANDEIRAS_CLIENTE, 
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCWN006)) || ',') ORDER BY CCWN006)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCWN006) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID) AS FEDERACAO_CLIENTE,  
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCAC07)) || ',') ORDER BY CCAC07)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCAC07) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID) AS AREA_CLIENTE,    
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCAC01)) || ',') ORDER BY CCAC01)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCAC01) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID) AS SETOR_CLIENTE,      
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CCADDS)) || ',') ORDER BY CCADDS)
                                 .extract('//text()'),
                                 ',') 
                  FROM CRPDTA.F5542096
                 WHERE CCPUKID = CAPUKID
                   AND TRIM(CCADDS) NOT IN ('0')
                   AND ROWNUM = 1
                   AND CCUKID = CAUKID) AS UF_CLIENTE,
-----------

                    (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CILITM)) || ','))
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542098
                 WHERE CIPUKID = CAPUKID
                   AND CIUKID = CAUKID) AS LITM_PRODUTOS,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CIUORG)) || ','))
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542098
                 WHERE CIPUKID = CAPUKID
                   AND CIUKID = CAUKID
                   AND ROWNUM = 1
                   AND TRIM(CIUORG) NOT IN ('0')) AS QTDE_SOLIC_PRODUTOS,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CIPRP1)) || ','))
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542098
                 WHERE CIPUKID = CAPUKID
                   AND CIUKID = CAUKID
                   AND ROWNUM = 1
                   AND TRIM(CIPRP1) NOT IN ('0')) AS CLASSE_PRP1_PRODUTOS,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CIPRP2)) || ','))
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542098
                 WHERE CIPUKID = CAPUKID
                   AND CIUKID = CAUKID
                   AND ROWNUM = 1
                   AND TRIM(CIPRP2) NOT IN ('0')) AS SUBCLASSE_PRP2_PRODUTOS,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CISRP5)) || ','))
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542098
                 WHERE CIPUKID = CAPUKID
                   AND CIUKID = CAUKID
                   AND ROWNUM = 1
                   AND TRIM(CISRP5) NOT IN ('0')) AS GRUPO_LAB_SRP5_PRODUTOS,
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e,(TRIM(CIPTC)) || ','))
                             .extract('//text()'),
                             ',')
                  FROM CRPDTA.F5542098
                 WHERE CIPUKID = CAPUKID
                   AND CIUKID = CAUKID
                   AND ROWNUM = 1
                   AND TRIM(CIPTC) NOT IN ('0')) AS PTC_PRODUTOS 

          FROM CRPDTA.F5542094 T1
         WHERE T1.CAEXDJ > =
               to_number(to_char(SYSDATE, 'YYYYDDD') - 1900000)
           AND T1.CAPUKID = 2)
 WHERE CANAIS_CAPTACAO LIKE '%CAC%'
   AND NOME_ACAO LIKE '%MERCANET%'

