--PRIMEIRO RETORNO
DECLARE 
 ID_TEST_RESULT NUMBER:=0;
 ID_NEXT_LINE NUMBER :=0;

BEGIN 

FOR CEN IN (SELECT * FROM INTEGRATOR_CENARIOS) LOOP
 FOR PED IN ( SELECT * FROM ID_TESTES T1
                WHERE CEN.ID_CENARIO = T1.ID) LOOP 
ID_TEST_RESULT := ID_TEST_RESULT + 1; 

-- F5547011 E F5547012
--INICIO
ID_NEXT_LINE:=ID_NEXT_LINE+1;
INSERT INTO TEST_RESULTS VALUES (ID_NEXT_LINE,ID_TEST_RESULT,CEN.ID_CENARIO,'F5547011 E F5547012','','','','','','','','','','','','','','','','');
   ID_NEXT_LINE:=ID_NEXT_LINE+1;

INSERT INTO TEST_RESULTS 
VALUES (ID_NEXT_LINE,
        ID_TEST_RESULT,
        CEN.ID_CENARIO,
        'PED_JDE', 
        'PED_MERCANET', 
        'ORIGEM_PED', 
        'ID_RELATORIO', 
        'DATA_PROC_JDE',
        'HORA_PROC_JDE', 
        'SOMA_QTDE_SOLIC',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '');
   ID_NEXT_LINE:=ID_NEXT_LINE+1;

INSERT INTO TEST_RESULTS 
SELECT ID_NEXT_LINE,
        ID_TEST_RESULT,
       CEN.ID_CENARIO,
       SADOCO AS PED_JDE, 
       SAVR01 AS PED_MERCANET, 
       SAZ55ORI AS ORIGEM_PED, 
       SAEDBT AS ID_RELATORIO, 
       TO_DATE(SAUPMJ+1900000,'YYYYDDD') AS DATA_PROC_JDE,
       to_char(to_timestamp(to_char(SATDAY),'hh24:mi:ss'),'hh24:mi:ss')  AS HORA_PROC_JDE, 
       SUM(SBUORG) as SOMA_QTDE_SOLIC,
       '' AS "11",
       '' AS "12",
       '' AS "13",
       '' AS "14",
       '' AS "15",
       '' AS "16",
       '' AS "17",
       '' AS "18",
       '' AS "19",
       '' AS "20"
 FROM QADTA.F5547011,
      QADTA.F5547012
WHERE SAUKID = SBUKID
  AND TRIM(SAVR01) = PED.PEDIDO
GROUP BY SADOCO, 
         SAVR01, 
         SAZ55ORI, 
         SAEDBT, 
         SAUPMJ, 
         SATDAY;
   ID_NEXT_LINE:=ID_NEXT_LINE+1;         
INSERT INTO TEST_RESULTS VALUES (ID_NEXT_LINE,ID_TEST_RESULT,CEN.ID_CENARIO,'','','','','','','','','','','','','','','','','');   
--FIM

--F5542456
--INICIO
ID_NEXT_LINE:=ID_NEXT_LINE+1;     
INSERT INTO TEST_RESULTS VALUES (ID_NEXT_LINE,ID_TEST_RESULT,CEN.ID_CENARIO,'F5542456','','','','','','','','','','','','','','','','');
   ID_NEXT_LINE:=ID_NEXT_LINE+1; 

INSERT INTO TEST_RESULTS 
VALUES (ID_NEXT_LINE,
        ID_TEST_RESULT,
       CEN.ID_CENARIO,
       'PED_JDE',
       'PED_MERCANET',
       'LOG_EXECUCAO_RELATORIO',
       'FLAG_INTEGRACAO',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '');
   ID_NEXT_LINE:=ID_NEXT_LINE+1;

INSERT INTO TEST_RESULTS 
SELECT ID_NEXT_LINE,
        ID_TEST_RESULT,
       CEN.ID_CENARIO,
       TGDOCO AS PED_JDE,
       TGEDOC AS PED_MERCANET,
       TRIM(TGMGTX) AS LOG_EXECUCAO_RELATORIO,
       TGFLAG AS FLAG_INTEGRACAO,
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       ''
 FROM QADTA.F5542456 
WHERE TGEDOC = PED.PEDIDO;
   ID_NEXT_LINE:=ID_NEXT_LINE+1;
INSERT INTO TEST_RESULTS VALUES (ID_NEXT_LINE,ID_TEST_RESULT,CEN.ID_CENARIO,'','','','','','','','','','','','','','','','','');   
--FIM

--F4201 E F4211  
--INICIO
ID_NEXT_LINE:=ID_NEXT_LINE+1;    
INSERT INTO TEST_RESULTS VALUES (ID_NEXT_LINE,ID_TEST_RESULT,CEN.ID_CENARIO,'F4211','','','','','','','','','','','','','','','','');  
   ID_NEXT_LINE:=ID_NEXT_LINE+1;      
       
INSERT INTO TEST_RESULTS
VALUES(
       ID_NEXT_LINE,
        ID_TEST_RESULT,
       CEN.ID_CENARIO,
       'PED_JDE',
       'PED_MERCANET',
       'DCTO',
       'HOLD',
       'SOMA_QTDE_SOLIC',
       'SOMA_QTDE_ATEND',
       'SOMA_QTDE_CANC',
       'SOMA_VALOR_LIQ',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '');
   ID_NEXT_LINE:=ID_NEXT_LINE+1;

INSERT INTO TEST_RESULTS
SELECT ID_NEXT_LINE,
       ID_TEST_RESULT,
       CEN.ID_CENARIO,
       SDDOCO AS PED_JDE,
       SDOORN AS PED_MERCANET,
       SDDCTO AS DCTO,
       SHHOLD AS HOLD,
       SUM(SDUORG) AS SOMA_QTDE_SOLIC,
       SUM(SDSOQS) AS SOMA_QTDE_ATEND,
       SUM(SDSOCN) AS SOMA_QTDE_CANC,
       SUM(SDAEXP/100) AS SOMA_VALOR_LIQ,
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       ''
 FROM QADTA.F4211, QADTA.F4201
WHERE SDOORN = PED.PEDIDO
 AND SDDOCO = SHDOCO
 AND SDDCTO = SHDCTO
 AND SDLNTY = 'BS'
 AND SDSO08 = ' '
GROUP BY SDDOCO,
         SDOORN,
         SDDCTO,
         SHHOLD;
         
ID_NEXT_LINE:=ID_NEXT_LINE+1;        
INSERT INTO TEST_RESULTS VALUES (ID_NEXT_LINE,ID_TEST_RESULT,CEN.ID_CENARIO,'','','','','','','','','','','','','','','','','');  
--FIM


--INTERFACE_DB_PEDIDO E INTERFACE_DB_PEDIDO_PROD
--INICIO    
ID_NEXT_LINE:=ID_NEXT_LINE+1;
INSERT INTO TEST_RESULTS VALUES (ID_NEXT_LINE,ID_TEST_RESULT,CEN.ID_CENARIO,'INTERFACE_DB_PEDIDO E INTERFACE_DB_PEDIDO_PROD','','','','','','','','','','','','','','','',''); 
   ID_NEXT_LINE:=ID_NEXT_LINE+1;

INSERT INTO TEST_RESULTS
VALUES (ID_NEXT_LINE,
        ID_TEST_RESULT,
        CEN.ID_CENARIO,
       'DATA_INCLUSAO',
       'DATA_ATUALIZACAO',
       'PED_JDE',
       'PED_MERCANET',
       'SOMA_QTDE_SOLIC',
       'SOMA_QTDE_ATEND',
       'SOMA_QTDE_CANC',
       'SOMA_VALOR_LIQ',
       'SITUACAO_PEDIDO',
       'SITCORP_PEDIDO',
       '',
       '',
       '',
       '',
       '',
       '',
       '');
   ID_NEXT_LINE:=ID_NEXT_LINE+1;

INSERT INTO TEST_RESULTS
SELECT ID_NEXT_LINE,
       ID_TEST_RESULT,
       CEN.ID_CENARIO,
       MAX(TO_CHAR(T1.DATA_INCLUSAO,'DD/MM/YYYY HH24:MI:SS')),
       MAX(TO_CHAR(T1.DATA_ATUALIZACAO,'DD/MM/YYYY HH24:MI:SS')),
       T1.DB_PED_NRO_ORIG AS PED_JDE,
       T1.DB_PED_NRO AS PED_MERCANET,
       SUM(T2.DB_PEDI_QTDE_SOLIC) AS SOMA_QTDE_SOLIC,
       SUM(T2.DB_PEDI_QTDE_ATEND) AS SOMA_QTDE_ATEND,
       SUM(T2.DB_PEDI_QTDE_CANC) AS SOMA_QTDE_CANC,
       ROUND(SUM(T2.DB_PEDI_PRECO_LIQ * T2.DB_PEDI_QTDE_ATEND),2)  AS SOMA_VALOR_LIQ,
       CASE
         WHEN T1.DB_PED_SITUACAO = 0 THEN
          '0 - LIBERADO'
         ELSE
          CASE
         WHEN T1.DB_PED_SITUACAO = 1 THEN
          '1 - BLOQUEADO'
         ELSE
          CASE
         WHEN T1.DB_PED_SITUACAO = 2 THEN
          '2 - FATURADO PARCIAL'
         ELSE
           CASE
         WHEN T1.DB_PED_SITUACAO = 4 THEN
          '4 - FATURADO'
         ELSE
          '9 - CANCELADO'
       END END END END AS SITUACAO_PEDIDO,
       CASE
         WHEN T1.DB_PED_SITCORP = 0 THEN
          '0 - LIBERADO'
         ELSE
          CASE
         WHEN T1.DB_PED_SITCORP = 1 THEN
          '1 - BLOQUEADO MN'
         ELSE
          CASE
         WHEN T1.DB_PED_SITCORP = 2 THEN
          '2 - BLOQUEADO C2'
         ELSE
          CASE
         WHEN T1.DB_PED_SITCORP = 3 THEN
          '3 - FATURADO PARCIAL'
         ELSE
          CASE
         WHEN T1.DB_PED_SITCORP = 5 THEN
          '5 - CANCEL BLOQ DO CLIENTE'
         ELSE
          '9 - CANCELADO'
       END END END END END AS SITCORP,
       '',
       '',
       '',
       '',
       '',
       '',
       ''
  FROM MERCANET_QA.INTERFACE_DB_PEDIDO@DC12.DROGACENTER.COM.BR T1,
       MERCANET_QA.INTERFACE_DB_PEDIDO_PROD@DC12.DROGACENTER.COM.BR T2
 WHERE T1.DB_PED_NRO = T2.DB_PEDI_PEDIDO
   AND T1.DB_PED_NRO = PED.PEDIDO
   AND T1.ID = T2.ID
GROUP BY T1.DB_PED_NRO_ORIG,
         T1.DB_PED_NRO,
         T1.DB_PED_SITUACAO,
         T1.DB_PED_SITCORP;            
    ID_NEXT_LINE:=ID_NEXT_LINE+1;
INSERT INTO TEST_RESULTS VALUES (ID_NEXT_LINE,ID_TEST_RESULT,CEN.ID_CENARIO,'','','','','','','','','','','','','','','','',''); 
--FIM  

--DB_PEDIDO E DB_PEDIDO_PROD
--INICIO
ID_NEXT_LINE:=ID_NEXT_LINE+1;

INSERT INTO TEST_RESULTS VALUES (ID_NEXT_LINE,ID_TEST_RESULT,CEN.ID_CENARIO,'DB_PEDIDO E DB_PEDIDO_PROD','','','','','','','','','','','','','','','','');
   ID_NEXT_LINE:=ID_NEXT_LINE+1;

INSERT INTO TEST_RESULTS 
VALUES (ID_NEXT_LINE,
        ID_TEST_RESULT,
        CEN.ID_CENARIO,
       'PED_MERCANET',
       'PED_JDE',
       'COND_PGTO',
       'DATA_ENVIO_JDE',
       'SOMA_QTDE_SOLIC',
       'SOMA_QTDE_ATEND',
       'SOMA_QTDE_CANC',
       'SOMA_VALOR_LIQ',
       'SITUACAO_PEDIDO',
       'SITCORP_PEDIDO',
       '',
       '',
       '',
       '',
       '',
       '',
       '');
   ID_NEXT_LINE:=ID_NEXT_LINE+1; 

INSERT INTO TEST_RESULTS 
SELECT ID_NEXT_LINE,
        ID_TEST_RESULT,
       CEN.ID_CENARIO,
       DB_PED_NRO AS PED_MERCANET, 
       DB_PED_NRO_ORIG AS PED_JDE,
       DB_PED_COND_PGTO AS COND_PGTO,
       TO_CHAR(DB_PED_DATA_ENVIO,'DD/MM/YYYY HH24:MI:SS') AS DATA_ENVIO_JDE,
       SUM(DB_PEDI_QTDE_SOLIC) AS SOMA_QTDE_SOLIC, 
       SUM(DB_PEDI_QTDE_ATEND) AS SOMA_QTDE_ATEND,
       SUM(DB_PEDI_QTDE_CANC) AS SOMA_QTDE_CANC,
       ROUND(SUM(DB_PEDI_PRECO_LIQ*DB_PEDI_QTDE_ATEND),2) AS SOMA_VALOR_LIQ,
       CASE
         WHEN DB_PED_SITUACAO = 0 THEN
          '0 - LIBERADO'
         ELSE
          CASE
         WHEN DB_PED_SITUACAO = 1 THEN
          '1 - BLOQUEADO'
         ELSE
          CASE
         WHEN DB_PED_SITUACAO = 2 THEN
          '2 - FATURADO PARCIAL'
         ELSE
           CASE
         WHEN DB_PED_SITUACAO = 4 THEN
          '4 - FATURADO'
         ELSE
          '9 - CANCELADO'
       END END END END AS SITUACAO_PEDIDO,
       CASE
         WHEN DB_PED_SITCORP = 0 THEN
          '0 - LIBERADO'
         ELSE
          CASE
         WHEN DB_PED_SITCORP = 1 THEN
          '1 - BLOQUEADO MN'
         ELSE
          CASE
         WHEN DB_PED_SITCORP = 2 THEN
          '2 - BLOQUEADO C2'
         ELSE
          CASE
         WHEN DB_PED_SITCORP = 3 THEN
          '3 - FATURADO PARCIAL'
         ELSE
          CASE
         WHEN DB_PED_SITCORP = 5 THEN
          '5 - CANCEL BLOQ DO CLIENTE'
         ELSE
          '9 - CANCELADO'
       END END END END END AS SITCORP,
       '' AS "14",
       '' AS "15",
       '' AS "16",
       '' AS "17",
       '' AS "18",
       '' AS "19",
       '' AS "20"
  FROM MERCANET_QA.DB_PEDIDO@DC12.DROGACENTER.COM.BR, 
       MERCANET_QA.DB_PEDIDO_PROD@DC12.DROGACENTER.COM.BR
 WHERE DB_PED_NRO = DB_PEDI_PEDIDO 
   AND DB_PED_NRO = PED.PEDIDO
GROUP BY DB_PED_NRO, 
       DB_PED_NRO_ORIG,
       DB_PED_COND_PGTO,
       DB_PED_DATA_ENVIO,
       DB_PED_SITUACAO,
       DB_PED_SITCORP;
       
ID_NEXT_LINE:=ID_NEXT_LINE+1;
INSERT INTO TEST_RESULTS VALUES (ID_NEXT_LINE,ID_TEST_RESULT,CEN.ID_CENARIO,'','','','','','','','','','','','','','','','','');       
--FIM


END LOOP;
 
--SELECT * FROM TEST_RESULTS WHERE COLUNA2 = 12 order by coluna1
--SELECT * FROM TEST_RESULTS_2 order by coluna1
--DELETE FROM TEST_RESULTS
--SELECT * FROM ID_TESTES FOR UPDATE
--SELECT * FROM ID_TESTES_SEG_RETURN FOR UPDATE 
COMMIT;
END LOOP; 

END; 

 





 
