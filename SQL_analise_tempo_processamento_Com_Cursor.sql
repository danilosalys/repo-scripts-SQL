CREATE TABLE ANALISE_PROCESS AS 
SELECT 0 AS ID_PROC, 
      LOTE.db_edild_nomearq AS "NOME_ARQUIVO",
      PEDDISTR.DB_PEDT_PEDIDO AS "PEDIDO_MERCANET",
      EDIPED.DB_EDIP_NRO AS "PEDIDO_VAN",
      PED.DB_PED_CLIENTE AS "COD_CLIENTE",
      CLI.DB_CLI_NOME AS "RAZAO_SOCIAL",
      EDIPED.db_edip_cliente AS "FILIAL",
      
(SELECT count(EDII.db_edii_produto) 
FROM  MERCANET_PRD.db_edi_pedprod EDII 
WHERE EDII.db_edii_nro = EDIPED.db_edip_nro 
AND EDII.db_edii_comprador = EDIPED.db_edip_comprador) AS "TOTAL_PRODUTOS_ARQ",
      
(SELECT COUNT(1) 
FROM MERCANET_PRD.DB_PEDIDO_PROD PEDI 
WHERE EDIPED.DB_EDIP_PEDMERC = PEDI.DB_PEDI_PEDIDO) AS "TOTAL_PRODUTOS_IMPORTADOS",
      SUBSTR(TO_CHAR(LOTE.DB_EDILD_DATA,
      'DD/MM/YYYY'),
      1,
      10) AS "DATA_INICIO_GRAVACAO_ARQ",
      SUBSTR(TO_CHAR(LOTE.DB_EDILD_DATA,
      'DD/MM/YYYY HH24:MI:SS'),
      12,
      9) AS "HORA_INICIO_GRAVACAO_ARQ",
      SUBSTR(TO_CHAR(PEDDISTR.DB_PEDT_DTIMP,
      'DD/MM/YYYY'),
      1,
      10) AS "DATA_INICIO_GRAVACAO_PED",
      SUBSTR(TO_CHAR(PEDDISTR.DB_PEDT_DTIMP,
      'DD/MM/YYYY HH24:MI:SS'),
      12,
      9) AS "HORA_INICIO_GRAVACAO_PED",
      SUBSTR(TO_CHAR(PEDDISTR.DB_PEDT_DTCOLET,
      'DD/MM/YYYY'),
      1,
      10) AS "DATA_TERMINO_GRAVACAO_PED",
      SUBSTR(TO_CHAR(PEDDISTR.DB_PEDT_DTCOLET,
      'DD/MM/YYYY HH24:MI:SS'),
      12,
      9) AS "HORA_TERMINO_GRAVACAO_PED",
      CASE WHEN EDIPED.DB_EDIP_PEDMERC IS NULL THEN NULL ELSE LPAD(TRUNC(MOD((PEDDISTR.DB_PEDT_DTCOLET 
      - PEDDISTR.DB_PEDT_DTIMP) * 24,
      60)),
      2,
      '0') || ':' || LPAD(TRUNC(MOD((PEDDISTR.DB_PEDT_DTCOLET - PEDDISTR.DB_PEDT_DTIMP) * 1440,
      60)),
      2,
      '0') || ':' || LPAD(TRUNC(MOD((PEDDISTR.DB_PEDT_DTCOLET - PEDDISTR.DB_PEDT_DTIMP) * 86400,
      60)),
      2,
      '0') END AS "TEMPO_GRAVACAO_ARQUIVO",
      SUBSTR(TO_CHAR(PED.DB_PED_DATA_ENVIO,
      'DD/MM/YYYY'),
      1,
      10) AS "DATA_ENVIO_P/_JDE",
      SUBSTR(TO_CHAR(PED.DB_PED_DATA_ENVIO,
      'DD/MM/YYYY HH24:MI:SS'),
      12,
      9) AS "HORA_ENVIO_P/_JDE",
      SUBSTR(TO_CHAR(INTPED.DATA_INCLUSAO,
      'DD/MM/YYYY'),
      1,
      10) AS "DATA_RETORNO_JDE_P/_INTERFACE",
      SUBSTR(TO_CHAR(INTPED.DATA_INCLUSAO,
      'DD/MM/YYYY HH24:MI:SS'),
      12,
      9) AS "HORA_RETORNO_JDE_P/_INTERFACE",
      CASE WHEN EDIPED.DB_EDIP_PEDMERC IS NULL THEN NULL ELSE LPAD(TRUNC(MOD((INTPED.DATA_INCLUSAO 
      - PED.DB_PED_DATA_ENVIO) * 24,
      60)),
      2,
      '0') || ':' || LPAD(TRUNC(MOD((INTPED.DATA_INCLUSAO - PED.DB_PED_DATA_ENVIO) * 1440,
      60)),
      2,
      '0') || ':' || LPAD(TRUNC(MOD((INTPED.DATA_INCLUSAO - PED.DB_PED_DATA_ENVIO) * 86400,
      60)),
      2,
      '0') END AS "TEMPO_PROCESSAMENTO_JDE",
      SUBSTR(TO_CHAR(PEDDISTR.DB_PEDT_DTDISP,
      'DD/MM/YYYY'),
      1,
      10) AS "DB_PEDT_DTDISP(DATA)",
      SUBSTR(TO_CHAR(PEDDISTR.DB_PEDT_DTDISP,
      'DD/MM/YYYY HH24:MI:SS'),
      12,
      9) AS "HORA_RETORNO_INTERFACE",
      SUBSTR(TO_CHAR(EDIPED.DB_EDIP_DTENVIO,
      'DD/MM/YYYY'),
      1,
      10) AS "DB_EDIP_DTENVIO(DATA)",
      SUBSTR(TO_CHAR(EDIPED.DB_EDIP_DTENVIO,
      'DD/MM/YYYY HH24:MI:SS'),
      12,
      9) AS "HORA_RETORNO_VAN",
      (LPAD(TRUNC(MOD((EDIPED.DB_EDIP_DTENVIO - LOTE.DB_EDILD_DATA) * 24,
      60)),
      2,
      '0') || ':' || LPAD(TRUNC(MOD((EDIPED.DB_EDIP_DTENVIO - LOTE.DB_EDILD_DATA) * 1440,
      60)),
      2,
      '0') || ':' || LPAD(TRUNC(MOD((EDIPED.DB_EDIP_DTENVIO - LOTE.DB_EDILD_DATA) * 86400,60)),2,'0')) AS "TEMPO_TOTAL_GASTO" 
FROM MERCANET_PRD.DB_PEDIDO_DISTR PEDDISTR,
     MERCANET_PRD.DB_EDI_PEDIDO EDIPED,
     MERCANET_PRD.DB_PEDIDO PED,
     MERCANET_PRD.INTERFACE_DB_PEDIDO INTPED,
     MERCANET_PRD.DB_EDI_LOTE_DISTR LOTE,
     MERCANET_PRD.DB_CLIENTE CLI 
WHERE EDIPED.DB_EDIP_PEDMERC = PEDDISTR.DB_PEDT_PEDIDO(+) 
AND PEDDISTR.DB_PEDT_PEDIDO = PED.DB_PED_NRO(+) 
AND PED.DB_PED_NRO = INTPED.DB_PED_NRO(+) 
AND LOTE.DB_EDILD_SEQ = EDIPED.DB_EDIP_LOTE 
AND PED.DB_PED_CLIENTE = CLI.DB_CLI_CODIGO(+) 
AND LOTE.DB_EDILD_DATA  BETWEEN TO_DATE('01/12/2014 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
                            AND TO_DATE('31/12/2014 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
AND LOTE.DB_EDILD_DISTR = 505 
ORDER BY
 LOTE.DB_EDILD_DATA 
 
----------

SELECT DATA_GRAV, HORA, SUM(TOTAL_ITENS) ,COUNT(*), TRUNC(SUM(TOTAL_ITENS)/COUNT(*)) MEDIA FROM(

      SELECT 
      DATA_INICIO_GRAVACAO_ARQ DATA_GRAV,
      T1.TOTAL_PRODUTOS_ARQ TOTAL_ITENS,
      SUBSTR(T1.HORA_INICIO_GRAVACAO_ARQ,01,02)||SUBSTR(T1.HORA_INICIO_GRAVACAO_ARQ,04,02) HORA,
      T1.*
      FROM ANALISE_PROCESS T1
      WHERE 
      T1.DATA_INICIO_GRAVACAO_ARQ BETWEEN '01/12/2014' AND '31/12/2014'  )
GROUP BY DATA_GRAV, HORA      
      
      
      
SELECT * FROM ANALISE_PROCESS T1
WHERE T1.DATA_INICIO_GRAVACAO_ARQ = '01/12/2014'
AND SUBSTR(T1.HORA_INICIO_GRAVACAO_ARQ,01,02)||SUBSTR(T1.HORA_INICIO_GRAVACAO_ARQ,04,02) IN ( '0733','0734', '0735', '0736')


----------

--86400 
--UPDATE ANALISE_PROCESS SET ID_PROC = ROWNUM

DECLARE 
     N_DATA DATE ;
     N_DIFF NUMBER;
     N_COUNTER NUMBER := 0;
BEGIN
  
FOR X IN (SELECT  ID_PROC
                 ,TO_DATE(DATA_INICIO_GRAVACAO_ARQ||' '||HORA_INICIO_GRAVACAO_ARQ,'DD/MM/YYYY HH24:MI:SS') AS PROC_LOTE   
            FROM ANALISE_PROCESS      
            ORDER BY 2
          )
          LOOP  
            
            IF N_COUNTER = 0 THEN 
               N_DATA    := X.PROC_LOTE;             
               N_COUNTER := 10000;
            END IF;            
          
            N_DIFF := ROUND((X.PROC_LOTE - N_DATA)*86400);
          
            N_DATA := X.PROC_LOTE;
                       
            
            IF N_DIFF > 60 THEN              
               N_COUNTER := N_COUNTER + 1;
               UPDATE ANALISE_PROCESS UP
               SET UP.ID_PROC = N_COUNTER
               WHERE UP.ID_PROC = X.ID_PROC;
            ELSE
               UPDATE ANALISE_PROCESS UP
               SET UP.ID_PROC = N_COUNTER
               WHERE UP.ID_PROC = X.ID_PROC;          
            END IF;

          END LOOP;
 END ;     
 
 
/* SELECT  TRUNC((FIM - INICIO) * 1440)
  FROM (
 SELECT TO_DATE('09/01/2014 14:00:00','DD/MM/YYYY HH24:MI:SS') AS INICIO,
        TO_DATE('09/01/2014 14:01:50','DD/MM/YYYY HH24:MI:SS') AS FIM
 FROM DUAL)*/
 
--SELECT * FROM ANALISE_PROCESS ORDER BY 1    



















 
 
 
 
 
