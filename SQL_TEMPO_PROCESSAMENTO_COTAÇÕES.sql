SELECT LOTECOT.db_edild_nomearq AS "NOME_ARQUIVO",
       PDISTRCOT.DB_PEDT_PEDIDO AS "PEDIDO_MERCANET",
       EDIPCOT.DB_EDIP_NRO AS "CODIGO_COTACAO",
       PEDCOT.DB_PED_CLIENTE AS "COD_CLIENTE",
       CLICOT.DB_CLI_NOME AS "RAZAO_SOCIAL",
       EDIPCOT.db_edip_cliente AS "FILIAL",
       (select count(EDIICOT.db_edii_produto)
          from mercanet_prd.db_edi_pedprod EDIICOT
         where EDIICOT.db_edii_nro = EDIPCOT.db_edip_nro
           and EDIICOT.db_edii_comprador = EDIPCOT.db_edip_comprador) AS "TOTAL_PRODUTOS_COTADOS",
       (SELECT COUNT(1)
          FROM MERCANET_PRD.DB_PEDIDO_PROD PEDICOT
         WHERE EDIPCOT.DB_EDIP_PEDMERC = PEDICOT.DB_PEDI_PEDIDO) AS "TOTAL_PRODUTOS_IMPORTADOS",
       
       TO_DATE(TO_CHAR(SUBSTR(LOTECOT.DB_EDILD_CONTEUDO,
                              INSTR(LOTECOT.DB_EDILD_CONTEUDO, ';', 1, 3) + 1,
                              8)),
               'DD/MM/YYYY') AS "DATA_VCTO_COTACAO",
       SUBSTR(TO_CHAR(TO_DATE(TO_CHAR(SUBSTR(LOTECOT.DB_EDILD_CONTEUDO,
                                             INSTR(LOTECOT.DB_EDILD_CONTEUDO,
                                                   ';',
                                                   1,
                                                   3) + 1,
                                             13)),
                              'DD/MM/YYYY HH24:MI:SS'),
                      'DD/MM/YYYY HH24:MI:SS'),
              12,
              9) AS "HORA_VCTO_COTACAO",
       SUBSTR(TO_CHAR(LOTECOT.DB_EDILD_DATA, 'DD/MM/YYYY'), 1, 10) AS "DATA_INICIO_GRAVACAO_ARQ",
       SUBSTR(TO_CHAR(LOTECOT.DB_EDILD_DATA, 'DD/MM/YYYY HH24:MI:SS'),
              12,
              9) AS "HORA_INICIO_GRAVACAO_ARQ",
       SUBSTR(TO_CHAR(PDISTRCOT.DB_PEDT_DTIMP, 'DD/MM/YYYY'), 1, 10) AS "DATA_INICIO_GRAVACAO_PED",
       SUBSTR(TO_CHAR(PDISTRCOT.DB_PEDT_DTIMP, 'DD/MM/YYYY HH24:MI:SS'),
              12,
              9) AS "HORA_INICIO_GRAVACAO_PED",
       SUBSTR(TO_CHAR(PDISTRCOT.DB_PEDT_DTCOLET, 'DD/MM/YYYY'), 1, 10) AS "DATA_TERMINO_GRAVACAO_PED",
       SUBSTR(TO_CHAR(PDISTRCOT.DB_PEDT_DTCOLET, 'DD/MM/YYYY HH24:MI:SS'),
              12,
              9) AS "HORA_TERMINO_GRAVACAO_PED",
       
       CASE
         WHEN EDIPCOT.DB_EDIP_PEDMERC IS NULL THEN
          NULL
         ELSE
          LPAD(TRUNC(MOD((PDISTRCOT.DB_PEDT_DTCOLET -
                         PDISTRCOT.DB_PEDT_DTIMP) * 24,
                         60)),
               2,
               '0') || ':' || LPAD(TRUNC(MOD((PDISTRCOT.DB_PEDT_DTCOLET -
                                             PDISTRCOT.DB_PEDT_DTIMP) * 1440,
                                             60)),
                                   2,
                                   '0') || ':' ||
          LPAD(TRUNC(MOD((PDISTRCOT.DB_PEDT_DTCOLET -
                         PDISTRCOT.DB_PEDT_DTIMP) * 86400,
                         60)),
               2,
               '0')
       END AS "TEMPO_GRAVACAO_ARQUIVO",
       
       SUBSTR(TO_CHAR(PEDCOT.DB_PED_DATA_ENVIO, 'DD/MM/YYYY'), 1, 10) AS "DATA_ENVIO_P/_JDE",
       SUBSTR(TO_CHAR(PEDCOT.DB_PED_DATA_ENVIO, 'DD/MM/YYYY HH24:MI:SS'),
              12,
              9) AS "HORA_ENVIO_P/_JDE",
       SUBSTR(TO_CHAR(INTPEDCOT.DATA_INCLUSAO, 'DD/MM/YYYY'), 1, 10) AS "HORA_RETORNO_JDE_P/_INTERFACE",
       SUBSTR(TO_CHAR(INTPEDCOT.DATA_INCLUSAO, 'DD/MM/YYYY HH24:MI:SS'),
              12,
              9) AS "HORA_RETORNO_JDE_P/_INTERFACE",
       
       CASE
         WHEN EDIPCOT.DB_EDIP_PEDMERC IS NULL THEN
          NULL
         ELSE
          LPAD(TRUNC(MOD((INTPEDCOT.DATA_INCLUSAO - PEDCOT.DB_PED_DATA_ENVIO) * 24,
                         60)),
               2,
               '0') || ':' ||
          LPAD(TRUNC(MOD((INTPEDCOT.DATA_INCLUSAO - PEDCOT.DB_PED_DATA_ENVIO) * 1440,
                         60)),
               2,
               '0') || ':' ||
          LPAD(TRUNC(MOD((INTPEDCOT.DATA_INCLUSAO - PEDCOT.DB_PED_DATA_ENVIO) *
                         86400,
                         60)),
               2,
               '0')
       END AS "TEMPO_PROCESSAMENTO_JDE",
       
       SUBSTR(TO_CHAR(PDISTRCOT.DB_PEDT_DTDISP, 'DD/MM/YYYY'), 1, 10) AS "DB_PEDT_DTDISP(DATA)",
       SUBSTR(TO_CHAR(PDISTRCOT.DB_PEDT_DTDISP, 'DD/MM/YYYY HH24:MI:SS'),
              12,
              9) AS "HORA_RETORNO_INTERFACE",
       SUBSTR(TO_CHAR(EDIPCOT.DB_EDIP_DTENVIO, 'DD/MM/YYYY'), 1, 10) AS "DB_EDIP_DTENVIO(DATA)",
       SUBSTR(TO_CHAR(EDIPCOT.DB_EDIP_DTENVIO, 'DD/MM/YYYY HH24:MI:SS'),
              12,
              9) AS "HORA_RETORNO_VAN",
       
       LPAD(TRUNC(MOD((EDIPCOT.DB_EDIP_DTENVIO - LOTECOT.DB_EDILD_DATA) * 24,
                      60)),
            2,
            '0') || ':' ||
       LPAD(TRUNC(MOD((EDIPCOT.DB_EDIP_DTENVIO - LOTECOT.DB_EDILD_DATA) * 1440,
                      60)),
            2,
            '0') || ':' || LPAD(TRUNC(MOD((EDIPCOT.DB_EDIP_DTENVIO -
                                          LOTECOT.DB_EDILD_DATA) * 86400,
                                          60)),
                                2,
                                '0') AS "TEMPO_TOTAL_GASTO",
       
       (TRUNC((ROUND((TO_DATE(TO_CHAR(SUBSTR(LOTECOT.DB_EDILD_CONTEUDO,
                                             INSTR(LOTECOT.DB_EDILD_CONTEUDO,
                                                   ';',
                                                   1,
                                                   3) + 1,
                                             13)),
                              'DD/MM/YYYY HH24:MI:SS') -
                     EDIPCOT.DB_EDIP_DTENVIO) * 1440)) / 60) || ' hs : ' ||
       round(((((ROUND((TO_DATE(TO_CHAR(SUBSTR(LOTECOT.DB_EDILD_CONTEUDO,
                                                INSTR(LOTECOT.DB_EDILD_CONTEUDO,
                                                      ';',
                                                      1,
                                                      3) + 1,
                                                13)),
                                 'DD/MM/YYYY HH24:MI:SS') -
                        EDIPCOT.DB_EDIP_DTENVIO) * 1440)) / 60) -
              TRUNC((ROUND((TO_DATE(TO_CHAR(SUBSTR(LOTECOT.DB_EDILD_CONTEUDO,
                                                     INSTR(LOTECOT.DB_EDILD_CONTEUDO,
                                                           ';',
                                                           1,
                                                           3) + 1,
                                                     13)),
                                      'DD/MM/YYYY HH24:MI:SS') -
                             EDIPCOT.DB_EDIP_DTENVIO) * 1440)) / 60)) * 60),
              2)) || 'min' AS "SALDO_TEMPO_RESPOSTA"

  FROM MERCANET_PRD.DB_PEDIDO_DISTR     PDISTRCOT,
       MERCANET_PRD.DB_EDI_PEDIDO       EDIPCOT,
       MERCANET_PRD.DB_PEDIDO           PEDCOT,
       MERCANET_PRD.INTERFACE_DB_PEDIDO INTPEDCOT,
       MERCANET_PRD.DB_EDI_LOTE_DISTR   LOTECOT,
       MERCANET_PRD.DB_CLIENTE          CLICOT
 WHERE EDIPCOT.DB_EDIP_PEDMERC = PDISTRCOT.DB_PEDT_PEDIDO(+)
   AND PDISTRCOT.DB_PEDT_PEDIDO = PEDCOT.DB_PED_NRO(+)
   AND PEDCOT.DB_PED_NRO = INTPEDCOT.DB_PED_NRO(+)
   AND LOTECOT.DB_EDILD_SEQ = EDIPCOT.DB_EDIP_LOTE
   AND PEDCOT.DB_PED_CLIENTE = CLICOT.DB_CLI_CODIGO(+)
   AND EDIPCOT.DB_EDIP_VAN = 529
   AND LOTECOT.DB_EDILD_DATA BETWEEN
       TO_DATE('30/04/2014 00:00:00', 'DD/MM/YYYY HH24:MI:SS') AND
       TO_DATE('30/04/2014 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
