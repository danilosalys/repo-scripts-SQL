SELECT LOTE.db_edild_nomearq AS "NOME_ARQUIVO",
       EDIPED.DB_EDIP_VAN AS "VAN",
       PEDDISTR.DB_PEDT_PEDIDO AS "PEDIDO_MERCANET",
       EDIPED.DB_EDIP_NRO AS "PEDIDO_VAN",
       PED.DB_PED_CLIENTE AS "COD_CLIENTE",
       CLI.DB_CLI_NOME AS "RAZAO_SOCIAL",
       EDIPED.db_edip_cliente AS "FILIAL",
       LOTE.DB_EDILD_DATA AS "HORA_INICIO_GRAVACAO_ARQ",
       PEDDISTR.DB_PEDT_DTIMP AS "HORA_INICIO_GRAVACAO_PED",
       PEDDISTR.DB_PEDT_DTCOLET AS "HORA_TERMINO_GRAVACAO_PED",
       (SELECT count(EDII.db_edii_produto)
          FROM MERCANET_QA.db_edi_pedprod EDII
         WHERE EDII.db_edii_nro = EDIPED.db_edip_nro
           AND EDII.db_edii_comprador = EDIPED.db_edip_comprador) AS "QTDE_PRODUTOS_ARQ",
       (SELECT COUNT(1)
          FROM MERCANET_QA.DB_PEDIDO_PROD PEDI
         WHERE EDIPED.DB_EDIP_PEDMERC = PEDI.DB_PEDI_PEDIDO) AS "QTDE_PRODUTOS_IMPORTADOS",
       (SELECT SUM(DB_PEDI_QTDE_SOLIC)
          FROM MERCANET_QA.DB_PEDIDO_PROD PEDI
         WHERE EDIPED.DB_EDIP_PEDMERC = PEDI.DB_PEDI_PEDIDO) AS "TOTAL_QTDE_SOLICITADA",
       (SELECT SUM(PEDI.DB_PEDI_QTDE_ATEND)
          FROM MERCANET_QA.DB_PEDIDO_PROD PEDI
         WHERE EDIPED.DB_EDIP_PEDMERC = PEDI.DB_PEDI_PEDIDO
           AND PEDI.DB_PEDI_QTDE_ATEND > 0) AS "TOTAL_QTDE_ATENDIDA",
       (SELECT SUM(PEDI.DB_PEDI_QTDE_CANC)
          FROM MERCANET_QA.DB_PEDIDO_PROD PEDI
         WHERE EDIPED.DB_EDIP_PEDMERC = PEDI.DB_PEDI_PEDIDO
           AND PEDI.DB_PEDI_QTDE_CANC > 0) AS "TOTAL_QTDE_N�O_ATENDIDA",
       CASE
         WHEN PED.DB_PED_SITUACAO = 0 THEN
          PED.DB_PED_SITUACAO || ' - LIBERADO'
         ELSE
          CASE
            WHEN PED.DB_PED_SITUACAO = 1 THEN
             PED.DB_PED_SITUACAO || ' - BLOQUEADO'
            ELSE
             CASE
               WHEN PED.DB_PED_SITUACAO = 2 THEN
                PED.DB_PED_SITUACAO || ' - FATURADO PARCIAL'
               ELSE
                CASE
                  WHEN PED.DB_PED_SITUACAO = 4 THEN
                   PED.DB_PED_SITUACAO || ' - FATURADO'
                  ELSE
                   PED.DB_PED_SITUACAO || ' - CANCELADO'
                END
             END
          END
       END "PED SITUACAO",
       CASE
         WHEN PED.DB_PED_SITCORP = 0 THEN
          PED.DB_PED_SITCORP || ' - LIBERADO'
         ELSE
          CASE
            WHEN PED.DB_PED_SITCORP = 1 THEN
             PED.DB_PED_SITCORP || ' - BLOQUEADO MN'
            ELSE
             CASE
               WHEN PED.DB_PED_SITCORP = 2 THEN
                PED.DB_PED_SITCORP || ' - BLOQUEADO C2'
               ELSE
                CASE
                  WHEN PED.DB_PED_SITCORP = 3 THEN
                   PED.DB_PED_SITCORP || ' - FATURADO PARCIAL'
                  ELSE
                   CASE
                     WHEN PED.DB_PED_SITCORP = 5 THEN
                      PED.DB_PED_SITCORP || ' - CANCEL BLOQ DO CLIENTE'
                     ELSE
                      CASE
                        WHEN PED.DB_PED_SITCORP IS NULL THEN
                         NULL
                        ELSE
                         PED.DB_PED_SITCORP || ' - CANCELADO'
                      END
                   END
                END
             END
          END
       END AS "SITCORP",
       PED.DB_PED_DATA_ENVIO AS "HORA_ENVIO_P/_JDE",
       '||||||' AS "||||||",
       CASE
         WHEN F5547011.SAEDBT = ' ' AND F5547011.SAEDSP = ' ' OR
              F5547011.SAEDBT = 'PROCESSAR      ' THEN
          NULL
         ELSE
          TO_CHAR(TO_DATE(SAUPMJ + 1900000, 'YYYYDDD'), 'DD/MM/YYYY ') ||
          TO_CHAR(TO_DATE(LPAD(SATDAY, 6, '0'), 'HH24:MI:SS'), 'HH24:MI:SS')
       END AS "HORA DE EXEC R5542200",
       F5547011.SAEDBT,
       F5547011.SAEDSP,
       F5547011.SAUKID,
       F5547011.SADOCO,
       F5547011.SADCTO,
       (SELECT COUNT(SBLITM)
          FROM QADTA.F5547012@DC10 F5547012
         WHERE F5547011.SAUKID = F5547012.SBUKID) AS "QTDE_PRODUTOS_F5547012",
       (SELECT SUM(SBUORG)
          FROM QADTA.F5547012@DC10 F5547012
         WHERE F5547011.SAUKID = F5547012.SBUKID) AS "TOTAL_QTDE_SOLICITADA_F5547012",
       (SELECT COUNT(SDLITM)
          FROM QADTA.F4211@DC10 F4211
         WHERE F5547011.SADOCO = F4211.SDDOCO) AS "QTDE_PRODUTOS_F4211",
       (SELECT SUM(SDUORG)
          FROM QADTA.F4211@DC10 F4211
         WHERE F5547011.SADOCO = F4211.SDDOCO) AS "TOTAL_QTDE_SOLICITADA_F4211",
       (SELECT SUM(SDSOQS)
          FROM QADTA.F4211@DC10 F4211
         WHERE F5547011.SADOCO = F4211.SDDOCO) AS "TOTAL_QTDE_ATENDIDA_F4211",
       (SELECT SUM(SDSOCN)
          FROM QADTA.F4211@DC10 F4211
         WHERE F5547011.SADOCO = F4211.SDDOCO) AS "TOTAL_QTDE_CANCELADA_F4211",
       CASE
         WHEN TGFLAG IS NULL OR TGFLAG in (' ', '#') THEN
          NULL
         ELSE
          TO_CHAR(TO_DATE(TGUPMJ + 1900000, 'YYYYDDD'), 'DD/MM/YYYY ') ||
          TO_CHAR(TO_DATE(LPAD(TGUPMT, 6, '0'), 'HH24:MI:SS'), 'HH24:MI:SS')
       END AS "HORA EXEC INTEGRATOR",
       TGFLAG AS "FLAG INTEGRATOR",
       '||||||' AS "||||||",
       INTPED.DATA_INCLUSAO AS "HORA GRAVACAO INTERFACE PED",
       CASE
         WHEN INTPED.DB_PED_SITUACAO = 0 THEN
          INTPED.DB_PED_SITUACAO || ' - LIBERADO'
         ELSE
          CASE
            WHEN INTPED.DB_PED_SITUACAO = 1 THEN
             INTPED.DB_PED_SITUACAO || ' - BLOQUEADO'
            ELSE
             CASE
               WHEN INTPED.DB_PED_SITUACAO = 2 THEN
                INTPED.DB_PED_SITUACAO || ' - FATURADO PARCIAL'
               ELSE
                CASE
                  WHEN INTPED.DB_PED_SITUACAO = 4 THEN
                   INTPED.DB_PED_SITUACAO || ' - FATURADO'
                  ELSE
                   CASE
                     WHEN INTPED.DB_PED_SITUACAO IS NULL THEN
                      NULL
                     ELSE
                      INTPED.DB_PED_SITUACAO || ' - CANCELADO'
                   END
                END
             END
          END
       END "PED SITUACAO INTERFACE",
       CASE
         WHEN INTPED.DB_PED_SITCORP = 0 THEN
          INTPED.DB_PED_SITCORP || ' - LIBERADO'
         ELSE
          CASE
            WHEN INTPED.DB_PED_SITCORP = 1 THEN
             INTPED.DB_PED_SITCORP || ' - BLOQUEADO MN'
            ELSE
             CASE
               WHEN INTPED.DB_PED_SITCORP = 2 THEN
                INTPED.DB_PED_SITCORP || ' - BLOQUEADO C2'
               ELSE
                CASE
                  WHEN INTPED.DB_PED_SITCORP = 3 THEN
                   INTPED.DB_PED_SITCORP || ' - FATURADO PARCIAL'
                  ELSE
                   CASE
                     WHEN INTPED.DB_PED_SITCORP = 5 THEN
                      PED.DB_PED_SITCORP || ' - CANCEL BLOQ DO CLIENTE'
                     ELSE
                      CASE
                        WHEN INTPED.DB_PED_SITCORP IS NULL THEN
                         NULL
                        ELSE
                         INTPED.DB_PED_SITCORP || ' - CANCELADO'
                      END
                   END
                END
             END
          END
       END AS "SITCORP INTERFACE",
       (SELECT COUNT(1)
          FROM MERCANET_QA.INTERFACE_DB_PEDIDO_PROD INTPEDI
         WHERE EDIPED.DB_EDIP_PEDMERC = INTPEDI.DB_PEDI_PEDIDO
           AND INTPEDI.ID = INTPED.ID) AS "QTDE_PRODUTOS_RETORNADOS_JDE",
       (SELECT SUM(INTPEDI.DB_PEDI_QTDE_SOLIC)
          FROM MERCANET_QA.INTERFACE_DB_PEDIDO_PROD INTPEDI
         WHERE EDIPED.DB_EDIP_PEDMERC = INTPEDI.DB_PEDI_PEDIDO
           and intpedi.id = intped.id) AS "TOTAL_QTDE_SOLICITADA",
       (SELECT SUM(INTPEDI.DB_PEDI_QTDE_ATEND)
          FROM MERCANET_QA.INTERFACE_DB_PEDIDO_PROD INTPEDI
         WHERE EDIPED.DB_EDIP_PEDMERC = INTPEDI.DB_PEDI_PEDIDO
           AND INTPEDI.DB_PEDI_QTDE_ATEND > 0
           and intpedi.id = intped.id) AS "TOTAL_QTDE_ATENDIDA",
       (SELECT SUM(INTPEDI.DB_PEDI_QTDE_CANC)
          FROM MERCANET_QA.DB_PEDIDO_PROD INTPEDI
         WHERE EDIPED.DB_EDIP_PEDMERC = INTPEDI.DB_PEDI_PEDIDO
           AND INTPEDI.DB_PEDI_QTDE_CANC > 0) AS "TOTAL_QTDE_N�O_ATENDIDA",
       '||||||' AS "||||||",
       PEDDISTR.DB_PEDT_DTDISP AS "HORA EXECUCAO DA API",
       '||||||' AS "||||||",
       EDIPED.DB_EDIP_DTENVIO AS "HORA_RETORNO_VAN",
       '||||||' AS "||||||",
       /*       NF.DATA_INCLUSAO AS "HORA INTEGRACAO DA NF",
       NF.DATA_ATUALIZACAO AS "HORA EXECUCAO API DA NF", */
       (SELECT COUNT(1)
          FROM MERCANET_QA.DB_PEDIDO_PROD PEDI
         WHERE EDIPED.DB_EDIP_PEDMERC = PEDI.DB_PEDI_PEDIDO
           AND PEDI.DB_PEDI_QTDE_ATEND > 0) AS "QTDE_PRODUTOS_ATENDIDOS"
  FROM MERCANET_QA.DB_PEDIDO_DISTR          PEDDISTR,
       MERCANET_QA.DB_EDI_PEDIDO            EDIPED,
       MERCANET_QA.DB_PEDIDO                PED,
       MERCANET_QA.INTERFACE_DB_PEDIDO      INTPED,
       MERCANET_QA.DB_EDI_LOTE_DISTR        LOTE,
       MERCANET_QA.DB_CLIENTE               CLI,
       MERCANET_QA.F5547011                 F5547011,
       QADTA.F5542456@DC10                  F5542456,
       MERCANET_QA.INTERFACE_DB_NOTA_FISCAL NF
 WHERE EDIPED.DB_EDIP_PEDMERC = PEDDISTR.DB_PEDT_PEDIDO(+)
   AND PEDDISTR.DB_PEDT_PEDIDO = PED.DB_PED_NRO(+)
   AND PED.DB_PED_NRO = INTPED.DB_PED_NRO(+)
   AND LOTE.DB_EDILD_SEQ = EDIPED.DB_EDIP_LOTE
   AND PED.DB_PED_CLIENTE = CLI.DB_CLI_CODIGO(+)
   AND TO_CHAR(PED.DB_PED_NRO) = TRIM(SAVR01(+))
   AND SAUKID = TGUKID(+)
   AND PED.DB_PED_NRO = NF.DB_NOTA_PED_MERC(+)
   AND PED.DB_PED_NRO_ORIG = NF.DB_NOTA_PED_ORIG(+)
   AND LOTE.DB_EDILD_NOMEARQ IN ( 'PHL009005651966000617135192620160517194719.TXT')
   AND case
         when intped.ID is null then
          1
         else
          intped.id
       end = case
         when intped.id is null then
          1
         else
          (SELECT MAX(B.ID)
             FROM MERCANET_QA.INTERFACE_DB_PEDIDO_PROD B
            WHERE B.DB_PEDI_PEDIDO = DB_PEDI_PEDIDO)
       end
 ORDER BY LOTE.DB_EDILD_DATA;
