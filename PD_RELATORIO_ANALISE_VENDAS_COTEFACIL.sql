--1 a 15/01/2017 - RELATORIO DE VENDAS COTEFÁCIL
SELECT 'COTACAO' AS "TIPO DO ARQUIVO",
       C.DB_EDIP_COMPRADOR AS "CNPJ DO COTADOR",
       C.DB_CLI_CODIGO AS "CODIGO DO COTADOR",
       C.DB_CLI_NOME AS "RAZAO SOCIAL",
       C.DB_CLI_REGIAOCOM AS "REGIAO COMERCIAL",
       CASE
         WHEN C.CODJDE_GR_MERC = '2002716' THEN
          'REGIONAL 1'
         ELSE
          CASE
            WHEN C.CODJDE_GR_MERC = '2000428' THEN
             'REGIONAL 2'
            ELSE
             CASE
               WHEN C.CODJDE_GR_MERC = '2000856' THEN
                'REGIONAL 3'
               ELSE
                CASE
                  WHEN C.CODJDE_GR_MERC = '2001056' THEN
                   'REGIONAL 4'
                  ELSE
                   'SEM REGIONAL'
                END
             END
          END
       END AS "REGIONAL",
       C.AC07 AS "SETOR",
       C.DB_EDIP_OBS1 AS "CODIGO DA COTACAO",
       C.DB_EDILD_NOMEARQ AS "NOME DO ARQUIVO",
       TO_DATE(TO_CHAR(SUBSTR(C.DB_EDILD_CONTEUDO,
                              INSTR(C.DB_EDILD_CONTEUDO, ';', 1, 3) + 1,
                              13)),
               'DD/MM/YYYY HH24:MI:SS') AS "DATA DE VENCIMENTO",
       C.DB_EDILD_DATA AS "DATA DE PROCESSAMENTO",
       --NVL(C.DB_EDIP_PEDMERC, 0) AS "PEDIDO MERCANET",
       CASE
         WHEN C.DB_EDIP_DTENVIO <> '31/12/9999' AND
              C.DB_EDIP_DTENVIO IS NOT NULL THEN
          'RESPONDIDA'
         ELSE
          CASE
            WHEN C.DB_EDIP_DTENVIO = '31/12/9999' AND C.DB_EDILD_SITUACAO = 0 THEN
             'NÃO RESPONDIDA'
            ELSE
             'EM PROCESSAMENTO'
          END
       END AS STATUS,
       CASE
         WHEN C.DB_EDIP_DTENVIO = '31/12/9999' AND C.DB_EDILD_SITUACAO = 0 THEN
          NULL
         ELSE
          C.DB_EDIP_DTENVIO
       END AS "HORARIO DA RESPOSTA",
       C.DB_EDIP_CONDPGTO AS "CONDICAO DE PAGAMENTO",
       (SELECT T1.DB_TBFAM_DESCRICAO
          FROM MERCANET_PRD.DB_TB_FAMILIA T1, MERCANET_PRD.DB_PRODUTO T2
         WHERE T1.DB_TBFAM_CODIGO = T2.DB_PROD_FAMILIA
           AND T2.DB_PROD_CODIGO = CASE
                 WHEN C.DB_PEDI_PRODUTO IS NULL THEN
                  (SELECT DB_PRDEMB_PRODUTO
                     FROM MERCANET_PRD.DB_PRODUTO_EMBAL
                    WHERE DB_PRDEMB_CODBARRA = C.DB_EDII_PRODUTO)
                 ELSE
                  C.DB_PEDI_PRODUTO
               END) AS FORNECEDOR,
       C.DB_EDII_PRODUTO AS "EAN COTADO",
       CASE
         WHEN C.DB_PEDI_PRODUTO IS NULL THEN
          (SELECT DB_PRDEMB_PRODUTO
             FROM MERCANET_PRD.DB_PRODUTO_EMBAL
            WHERE DB_PRDEMB_CODBARRA = C.DB_EDII_PRODUTO)
         ELSE
          C.DB_PEDI_PRODUTO
       END AS "CODIGO DO PRODUTO",
       C.DB_EDII_QTDE_VDA AS "QUANTIDADE COTADA",
       NVL(C.DB_PEDI_QTDE_ATEND, 0) AS "QUANTIDADE ATENDIDA",
       NVL(C.DB_PEDI_PRECO_LIQ * C.DB_PEDI_QTDE_ATEND, 0) AS "VALOR TOTAL COTADO",
       --------------------------------------------------------------------------------------------------
       'EFETIVACAO ->' AS "TIPO DO ARQUIVO",
       NVL(E.DB_EDIP_COMPRADOR, ' - ') AS "CNPJ EFETIVADOR",
       NVL(TO_CHAR(E.DB_CLI_CODIGO), ' - ') AS "CODIGO DO EFETIVADOR",
       NVL(E.DB_CLI_NOME, ' - ') AS "RAZAO SOCIAL",
       NVL(E.DB_EDIP_TXT2, ' - ') AS "CODIGO DA EFETIVACAO",
       NVL(TO_CHAR(E.DB_EDILD_DATA, 'DD/MM/YYYY HH24:MI:SS'), ' - ') AS "DATA DE PROCESSAMENTO",
       NVL(TO_CHAR(E.DB_EDIP_DTENVIO, 'DD/MM/YYYY HH24:MI:SS'), ' - ') AS "HORARIO DA RESPOSTA",
       NVL(TO_CHAR(E.DB_EDIP_CONDPGTO), ' - ') AS "CONDICAO DE PAGAMENTO",
       NVL(TO_CHAR(E.DB_PEDI_NRO_ENVIO), ' - ') AS "PEDIDO JDE",
       NVL((SELECT T1.DB_TBFAM_DESCRICAO
             FROM MERCANET_PRD.DB_TB_FAMILIA T1, MERCANET_PRD.DB_PRODUTO T2
            WHERE T1.DB_TBFAM_CODIGO = T2.DB_PROD_FAMILIA
              AND T2.DB_PROD_CODIGO = CASE
                    WHEN E.DB_PEDI_PRODUTO IS NULL THEN
                     (SELECT DB_PRDEMB_PRODUTO
                        FROM MERCANET_PRD.DB_PRODUTO_EMBAL
                       WHERE DB_PRDEMB_CODBARRA = E.DB_EDII_PRODUTO)
                    ELSE
                     E.DB_PEDI_PRODUTO
                  END),
           ' - ') AS FORNECEDOR,
       NVL(E.DB_EDII_PRODUTO, ' - ') AS "EAN EFETIVADO",
       NVL(CASE
             WHEN E.DB_PEDI_PRODUTO IS NULL THEN
              (SELECT DB_PRDEMB_PRODUTO
                 FROM MERCANET_PRD.DB_PRODUTO_EMBAL
                WHERE DB_PRDEMB_CODBARRA = E.DB_EDII_PRODUTO)
             ELSE
              E.DB_PEDI_PRODUTO
           END,
           ' - ') AS "CODIGO DO PRODUTO",
       NVL(E.DB_EDII_QTDE_VDA, 0) AS "QUANTIDADE SOLICITADA",
       NVL(E.DB_PEDI_QTDE_ATEND, 0) AS "QUANTIDADE ATENDIDA",
       NVL(E.DB_PEDI_PRECO_LIQ * E.DB_PEDI_QTDE_ATEND, 0) AS "VALOR TOTAL EFETIVADO"
  FROM (SELECT *
          FROM MERCANET_PRD.DB_EDI_LOTE_DISTR LOTECOT,
               MERCANET_PRD.DB_EDI_PEDIDO     EDIPCOT,
               MERCANET_PRD.DB_EDI_PEDPROD    EDIICOT
          LEFT JOIN (SELECT CLI.*, AC07.DB_CLIA_VALOR AS AC07
                      FROM MERCANET_PRD.DB_CLIENTE       CLI,
                           MERCANET_PRD.DB_CLIENTE_ATRIB AC07
                     WHERE DB_CLI_CODIGO = AC07.DB_CLIA_CODIGO
                       AND AC07.DB_CLIA_ATRIB = 1007) CLICOT
            ON EDIICOT.DB_EDII_COMPRADOR = CLICOT.DB_CLI_CGCMF
          LEFT JOIN (SELECT *
                      FROM MERCANET_PRD.DB_PEDIDO_DISTR,
                           MERCANET_PRD.DB_PEDIDO_DISTR_IT
                     WHERE DB_PEDT_PEDIDO = DB_PDIT_PEDIDO) PDISTRCOT
            ON EDIICOT.DB_EDII_PEDMERC = PDISTRCOT.DB_PDIT_PEDIDO
           AND EDIICOT.DB_EDII_SEQ = PDISTRCOT.DB_PDIT_EDII_SEQ
          LEFT JOIN (SELECT *
                      FROM MERCANET_PRD.DB_PEDIDO,
                           MERCANET_PRD.DB_PEDIDO_PROD
                     WHERE DB_PED_NRO = DB_PEDI_PEDIDO) PEDCOT
            ON PDISTRCOT.DB_PDIT_PEDIDO = PEDCOT.DB_PEDI_PEDIDO
           AND PDISTRCOT.DB_PDIT_PRODUTO = PEDCOT.DB_PEDI_PRODUTO
          LEFT JOIN (SELECT T2.DB_TBREP_CODIGO  AS REP_MERC,
                           T2.DB_TBREP_CODORIG AS CODJDE_REP_MERC,
                           T2.DB_TBREP_NOME    AS NOME_REP_MERC,
                           T3.DB_TBREP_CODIGO  AS GA_MERC,
                           T3.DB_TBREP_CODORIG AS CODJDE_GA_MERC,
                           T3.DB_TBREP_NOME    AS NOME_GA_MERC,
                           T4.DB_TBREP_CODIGO  AS GR_MERC,
                           T4.DB_TBREP_CODORIG AS CODJDE_GR_MERC,
                           T4.DB_TBREP_NOME    AS NOME_GR_MERC
                      FROM MERCANET_PRD.DB_TB_REPRES T2,
                           MERCANET_PRD.DB_TB_REPRES T3,
                           MERCANET_PRD.DB_TB_REPRES T4
                     WHERE T2.DB_TBREP_SUPERIOR = T3.DB_TBREP_CODIGO
                       AND T3.DB_TBREP_SUPERIOR = T4.DB_TBREP_CODIGO) GER
            ON CLICOT.DB_CLI_REPRES = GER.REP_MERC
         WHERE LOTECOT.DB_EDILD_SEQ = EDIPCOT.DB_EDIP_LOTE
           AND EDIPCOT.DB_EDIP_COMPRADOR = EDIICOT.DB_EDII_COMPRADOR
           AND EDIPCOT.DB_EDIP_NRO = EDIICOT.DB_EDII_NRO
           AND LOTECOT.DB_EDILD_DISTR = 529) C
  LEFT JOIN (SELECT *
               FROM MERCANET_PRD.DB_EDI_LOTE_DISTR LOTEEFET,
                    MERCANET_PRD.DB_EDI_PEDIDO     EDIPEFET,
                    MERCANET_PRD.DB_EDI_PEDPROD    EDIIEFET
               LEFT JOIN (SELECT CLI.*, AC07.DB_CLIA_VALOR AS AC07
                           FROM MERCANET_PRD.DB_CLIENTE       CLI,
                                MERCANET_PRD.DB_CLIENTE_ATRIB AC07
                          WHERE DB_CLI_CODIGO = AC07.DB_CLIA_CODIGO
                            AND AC07.DB_CLIA_ATRIB = 1007) CLIEFET
                 ON EDIIEFET.DB_EDII_COMPRADOR = CLIEFET.DB_CLI_CGCMF
               LEFT JOIN (SELECT *
                           FROM MERCANET_PRD.DB_PEDIDO_DISTR,
                                MERCANET_PRD.DB_PEDIDO_DISTR_IT
                          WHERE DB_PEDT_PEDIDO = DB_PDIT_PEDIDO) PDISTREFET
                 ON EDIIEFET.DB_EDII_PEDMERC = PDISTREFET.DB_PDIT_PEDIDO
                AND EDIIEFET.DB_EDII_SEQ = PDISTREFET.DB_PDIT_EDII_SEQ
               LEFT JOIN (SELECT *
                           FROM MERCANET_PRD.DB_PEDIDO,
                                MERCANET_PRD.DB_PEDIDO_PROD
                          WHERE DB_PED_NRO = DB_PEDI_PEDIDO) PEDEFET
                 ON PDISTREFET.DB_PDIT_PEDIDO = PEDEFET.DB_PEDI_PEDIDO
                AND PDISTREFET.DB_PDIT_PRODUTO = PEDEFET.DB_PEDI_PRODUTO
               LEFT JOIN (SELECT T2.DB_TBREP_CODIGO  AS REP_MERC,
                                T2.DB_TBREP_CODORIG AS CODJDE_REP_MERC,
                                T2.DB_TBREP_NOME    AS NOME_REP_MERC,
                                T3.DB_TBREP_CODIGO  AS GA_MERC,
                                T3.DB_TBREP_CODORIG AS CODJDE_GA_MERC,
                                T3.DB_TBREP_NOME    AS NOME_GA_MERC,
                                T4.DB_TBREP_CODIGO  AS GR_MERC,
                                T4.DB_TBREP_CODORIG AS CODJDE_GR_MERC,
                                T4.DB_TBREP_NOME    AS NOME_GR_MERC
                           FROM MERCANET_PRD.DB_TB_REPRES T2,
                                MERCANET_PRD.DB_TB_REPRES T3,
                                MERCANET_PRD.DB_TB_REPRES T4
                          WHERE T2.DB_TBREP_SUPERIOR = T3.DB_TBREP_CODIGO
                            AND T3.DB_TBREP_SUPERIOR = T4.DB_TBREP_CODIGO) GEREFET
                 ON CLIEFET.DB_CLI_REPRES = GEREFET.REP_MERC
              WHERE LOTEEFET.DB_EDILD_SEQ = EDIPEFET.DB_EDIP_LOTE
                AND EDIPEFET.DB_EDIP_COMPRADOR = EDIIEFET.DB_EDII_COMPRADOR
                AND EDIPEFET.DB_EDIP_NRO = EDIIEFET.DB_EDII_NRO
                AND LOTEEFET.DB_EDILD_DISTR = 530) E
    ON C.DB_EDIP_OBS1 = E.DB_EDIP_OBS1
   AND C.DB_EDII_PRODUTO = E.DB_EDII_PRODUTO
 WHERE C.DB_EDILD_DATA BETWEEN TO_DATE('07/05/2017 00:00:00','DD/MM/YYYY HH24:MI:SS')
                           AND TO_DATE('13/05/2017 23:59:59','DD/MM/YYYY HH24:MI:SS')
 ORDER BY C.DB_EDILD_DATA, C.DB_EDILD_SEQ, C.DB_EDII_SEQ




/*
--1 a 15/02/2017 - RELATORIO DE VENDAS COTEFÁCIL
SELECT 'COTACAO' AS "TIPO DO ARQUIVO",
       C.DB_EDIP_COMPRADOR AS "CNPJ DO COTADOR",
       C.DB_CLI_CODIGO AS "CODIGO DO COTADOR",
       C.DB_CLI_NOME AS "RAZAO SOCIAL",
       C.DB_CLI_REGIAOCOM AS "REGIAO COMERCIAL",
       NVL((SELECT REGIONAL
  FROM (SELECT DB_CLIR_CLIENTE,
               MAX(DB_CLIR_REPRES) AS DB_CLIR_REPRES,
               MAX(REGIONAL) AS REGIONAL
          FROM (SELECT DB_CLIR_CLIENTE,
                       DB_CLIR_REPRES,
                       NVL(DECODE(GER.CODJDE_GR_MERC,
                                  '2002716',
                                  'REGIONAL 1',
                                  '2000428',
                                  'REGIONAL 2',
                                  '2000856',
                                  'REGIONAL 3',
                                  '2001056',
                                  'REGIONAL 4'),
                           'SEM REGIONAL') AS "REGIONAL"
                  FROM MERCANET_PRD.DB_CLIENTE_REPRES T1,
                       (SELECT T2.DB_TBREP_CODIGO  AS REP_MERC,
                               T2.DB_TBREP_CODORIG AS CODJDE_REP_MERC,
                               T2.DB_TBREP_NOME    AS NOME_REP_MERC,
                               T3.DB_TBREP_CODIGO  AS GA_MERC,
                               T3.DB_TBREP_CODORIG AS CODJDE_GA_MERC,
                               T3.DB_TBREP_NOME    AS NOME_GA_MERC,
                               T4.DB_TBREP_CODIGO  AS GR_MERC,
                               T4.DB_TBREP_CODORIG AS CODJDE_GR_MERC,
                               T4.DB_TBREP_NOME    AS NOME_GR_MERC
                          FROM MERCANET_PRD.DB_TB_REPRES T2,
                               MERCANET_PRD.DB_TB_REPRES T3,
                               MERCANET_PRD.DB_TB_REPRES T4
                         WHERE T2.DB_TBREP_SUPERIOR = T3.DB_TBREP_CODIGO
                           AND T3.DB_TBREP_SUPERIOR = T4.DB_TBREP_CODIGO
                           AND T2.DB_TBREP_SITUACAO = 1
                           AND T3.DB_TBREP_SITUACAO = 1
                           AND T4.DB_TBREP_SITUACAO = 1
                           AND T2.DB_TBREP_TIPO = 6
                           AND T3.DB_TBREP_TIPO = 5
                           AND T4.DB_TBREP_TIPO = 4) GER
                 WHERE EXISTS (SELECT T0.DB_CLIR_CLIENTE,
                               COUNT(DISTINCT T0.DB_CLIR_REPRES)
                          FROM MERCANET_PRD.DB_CLIENTE_REPRES T0
                         WHERE T0.DB_CLIR_CLIENTE = T1.DB_CLIR_CLIENTE
                         GROUP BY DB_CLIR_CLIENTE
                        HAVING COUNT(DISTINCT T0.DB_CLIR_REPRES) > 1)
                   AND T1.DB_CLIR_REPRES <> 3
                   AND GER.REP_MERC = DB_CLIR_REPRES)
         WHERE REGIONAL <> 'SEM REGIONAL'
         GROUP BY DB_CLIR_CLIENTE
        UNION
        SELECT DB_CLIR_CLIENTE, MAX(DB_CLIR_REPRES), MAX(REGIONAL)
          FROM (SELECT DB_CLIR_CLIENTE,
                       DB_CLIR_REPRES,
                       NVL(DECODE(GER.CODJDE_GR_MERC,
                                  '2002716',
                                  'REGIONAL 1',
                                  '2000428',
                                  'REGIONAL 2',
                                  '2000856',
                                  'REGIONAL 3',
                                  '2001056',
                                  'REGIONAL 4'),
                           'SEM REGIONAL') AS "REGIONAL"
                  FROM MERCANET_PRD.DB_CLIENTE_REPRES T1,
                       (SELECT T2.DB_TBREP_CODIGO  AS REP_MERC,
                               T2.DB_TBREP_CODORIG AS CODJDE_REP_MERC,
                               T2.DB_TBREP_NOME    AS NOME_REP_MERC,
                               T3.DB_TBREP_CODIGO  AS GA_MERC,
                               T3.DB_TBREP_CODORIG AS CODJDE_GA_MERC,
                               T3.DB_TBREP_NOME    AS NOME_GA_MERC,
                               T4.DB_TBREP_CODIGO  AS GR_MERC,
                               T4.DB_TBREP_CODORIG AS CODJDE_GR_MERC,
                               T4.DB_TBREP_NOME    AS NOME_GR_MERC
                          FROM MERCANET_PRD.DB_TB_REPRES T2,
                               MERCANET_PRD.DB_TB_REPRES T3,
                               MERCANET_PRD.DB_TB_REPRES T4
                         WHERE T2.DB_TBREP_SUPERIOR = T3.DB_TBREP_CODIGO
                           AND T3.DB_TBREP_SUPERIOR = T4.DB_TBREP_CODIGO
                           AND T2.DB_TBREP_SITUACAO = 1
                           AND T3.DB_TBREP_SITUACAO = 1
                           AND T4.DB_TBREP_SITUACAO = 1
                           AND T2.DB_TBREP_TIPO = 6
                           AND T3.DB_TBREP_TIPO = 5
                           AND T4.DB_TBREP_TIPO = 4) GER
                 WHERE EXISTS (SELECT T0.DB_CLIR_CLIENTE,
                               COUNT(DISTINCT T0.DB_CLIR_REPRES)
                          FROM MERCANET_PRD.DB_CLIENTE_REPRES T0
                         WHERE T0.DB_CLIR_CLIENTE = T1.DB_CLIR_CLIENTE
                         GROUP BY DB_CLIR_CLIENTE
                        HAVING COUNT(DISTINCT T0.DB_CLIR_REPRES) > 1)
                   AND T1.DB_CLIR_REPRES <> 3
                   AND GER.REP_MERC = DB_CLIR_REPRES)
         WHERE REGIONAL = 'SEM REGIONAL'
           AND DB_CLIR_CLIENTE NOT IN
               (SELECT DB_CLIR_CLIENTE
                  FROM (SELECT DB_CLIR_CLIENTE,
                               DB_CLIR_REPRES,
                               NVL(DECODE(GER.CODJDE_GR_MERC,
                                          '2002716',
                                          'REGIONAL 1',
                                          '2000428',
                                          'REGIONAL 2',
                                          '2000856',
                                          'REGIONAL 3',
                                          '2001056',
                                          'REGIONAL 4'),
                                   'SEM REGIONAL') AS "REGIONAL"
                          FROM MERCANET_PRD.DB_CLIENTE_REPRES T1,
                               (SELECT T2.DB_TBREP_CODIGO  AS REP_MERC,
                                       T2.DB_TBREP_CODORIG AS CODJDE_REP_MERC,
                                       T2.DB_TBREP_NOME    AS NOME_REP_MERC,
                                       T3.DB_TBREP_CODIGO  AS GA_MERC,
                                       T3.DB_TBREP_CODORIG AS CODJDE_GA_MERC,
                                       T3.DB_TBREP_NOME    AS NOME_GA_MERC,
                                       T4.DB_TBREP_CODIGO  AS GR_MERC,
                                       T4.DB_TBREP_CODORIG AS CODJDE_GR_MERC,
                                       T4.DB_TBREP_NOME    AS NOME_GR_MERC
                                  FROM MERCANET_PRD.DB_TB_REPRES T2,
                                       MERCANET_PRD.DB_TB_REPRES T3,
                                       MERCANET_PRD.DB_TB_REPRES T4
                                 WHERE T2.DB_TBREP_SUPERIOR =
                                       T3.DB_TBREP_CODIGO
                                   AND T3.DB_TBREP_SUPERIOR =
                                       T4.DB_TBREP_CODIGO
                                   AND T2.DB_TBREP_SITUACAO = 1
                                   AND T3.DB_TBREP_SITUACAO = 1
                                   AND T4.DB_TBREP_SITUACAO = 1
                                   AND T2.DB_TBREP_TIPO = 6
                                   AND T3.DB_TBREP_TIPO = 5
                                   AND T4.DB_TBREP_TIPO = 4) GER
                         WHERE EXISTS
                         (SELECT T0.DB_CLIR_CLIENTE,
                                       COUNT(DISTINCT T0.DB_CLIR_REPRES)
                                  FROM MERCANET_PRD.DB_CLIENTE_REPRES T0
                                 WHERE T0.DB_CLIR_CLIENTE = T1.DB_CLIR_CLIENTE
                                 GROUP BY DB_CLIR_CLIENTE
                                HAVING COUNT(DISTINCT T0.DB_CLIR_REPRES) > 1)
                           AND T1.DB_CLIR_REPRES <> 3
                           AND GER.REP_MERC = DB_CLIR_REPRES)
                 WHERE REGIONAL <> 'SEM REGIONAL')
         GROUP BY DB_CLIR_CLIENTE
        UNION
        SELECT DB_CLIR_CLIENTE, MAX(DB_CLIR_REPRES), MAX(REGIONAL)
          FROM (SELECT DB_CLIR_CLIENTE,
                       DB_CLIR_REPRES,
                       NVL(DECODE(GER.CODJDE_GR_MERC,
                                  '2002716',
                                  'REGIONAL 1',
                                  '2000428',
                                  'REGIONAL 2',
                                  '2000856',
                                  'REGIONAL 3',
                                  '2001056',
                                  'REGIONAL 4'),
                           'SEM REGIONAL') AS "REGIONAL"
                  FROM MERCANET_PRD.DB_CLIENTE_REPRES T1,
                       (SELECT T2.DB_TBREP_CODIGO  AS REP_MERC,
                               T2.DB_TBREP_CODORIG AS CODJDE_REP_MERC,
                               T2.DB_TBREP_NOME    AS NOME_REP_MERC,
                               T3.DB_TBREP_CODIGO  AS GA_MERC,
                               T3.DB_TBREP_CODORIG AS CODJDE_GA_MERC,
                               T3.DB_TBREP_NOME    AS NOME_GA_MERC,
                               T4.DB_TBREP_CODIGO  AS GR_MERC,
                               T4.DB_TBREP_CODORIG AS CODJDE_GR_MERC,
                               T4.DB_TBREP_NOME    AS NOME_GR_MERC
                          FROM MERCANET_PRD.DB_TB_REPRES T2,
                               MERCANET_PRD.DB_TB_REPRES T3,
                               MERCANET_PRD.DB_TB_REPRES T4
                         WHERE T2.DB_TBREP_SUPERIOR = T3.DB_TBREP_CODIGO
                           AND T3.DB_TBREP_SUPERIOR = T4.DB_TBREP_CODIGO
                           AND T2.DB_TBREP_SITUACAO = 1
                           AND T3.DB_TBREP_SITUACAO = 1
                           AND T4.DB_TBREP_SITUACAO = 1
                           AND T2.DB_TBREP_TIPO = 6
                           AND T3.DB_TBREP_TIPO = 5
                           AND T4.DB_TBREP_TIPO = 4) GER
                 WHERE EXISTS (SELECT T0.DB_CLIR_CLIENTE,
                               COUNT(DISTINCT T0.DB_CLIR_REPRES)
                          FROM MERCANET_PRD.DB_CLIENTE_REPRES T0
                         WHERE T0.DB_CLIR_CLIENTE = T1.DB_CLIR_CLIENTE
                         GROUP BY DB_CLIR_CLIENTE
                        HAVING COUNT(DISTINCT T0.DB_CLIR_REPRES) = 1)
                   AND T1.DB_CLIR_REPRES <> 3
                   AND GER.REP_MERC = DB_CLIR_REPRES)
         GROUP BY DB_CLIR_CLIENTE) CLI_REPRES
WHERE DB_CLIR_CLIENTE = C.DB_CLI_CODIGO),'SEM REGIONAL'),
       CASE
         WHEN C.CODJDE_GR_MERC = '2002716' THEN
          'REGIONAL 1'
         ELSE
          CASE
            WHEN C.CODJDE_GR_MERC = '2000428' THEN
             'REGIONAL 2'
            ELSE
             CASE
               WHEN C.CODJDE_GR_MERC = '2000856' THEN
                'REGIONAL 3'
               ELSE
                CASE
                  WHEN C.CODJDE_GR_MERC = '2001056' THEN
                   'REGIONAL 4'
                  ELSE
                   'SEM REGIONAL'
                END
             END
          END
       END AS "REGIONAL",
       C.AC07 AS "SETOR",
       C.DB_EDIP_OBS1 AS "CODIGO DA COTACAO",
       C.DB_EDILD_NOMEARQ AS "NOME DO ARQUIVO",
       TO_DATE(TO_CHAR(SUBSTR(C.DB_EDILD_CONTEUDO,
                              INSTR(C.DB_EDILD_CONTEUDO, ';', 1, 3) + 1,
                              13)),
               'DD/MM/YYYY HH24:MI:SS') AS "DATA DE VENCIMENTO",
       C.DB_EDILD_DATA AS "DATA DE PROCESSAMENTO",
       --NVL(C.DB_EDIP_PEDMERC, 0) AS "PEDIDO MERCANET",
       CASE
         WHEN C.DB_EDIP_DTENVIO <> '31/12/9999' AND
              C.DB_EDIP_DTENVIO IS NOT NULL THEN
          'RESPONDIDA'
         ELSE
          CASE
            WHEN C.DB_EDIP_DTENVIO = '31/12/9999' AND C.DB_EDILD_SITUACAO = 0 THEN
             'NÃO RESPONDIDA'
            ELSE
             'EM PROCESSAMENTO'
          END
       END AS STATUS,
       CASE
         WHEN C.DB_EDIP_DTENVIO = '31/12/9999' AND C.DB_EDILD_SITUACAO = 0 THEN
          NULL
         ELSE
          C.DB_EDIP_DTENVIO
       END AS "HORARIO DA RESPOSTA",
       C.DB_EDIP_CONDPGTO AS "CONDICAO DE PAGAMENTO",
       (SELECT T1.DB_TBFAM_DESCRICAO
          FROM MERCANET_PRD.DB_TB_FAMILIA T1, MERCANET_PRD.DB_PRODUTO T2
         WHERE T1.DB_TBFAM_CODIGO = T2.DB_PROD_FAMILIA
           AND T2.DB_PROD_CODIGO = CASE
                 WHEN C.DB_PEDI_PRODUTO IS NULL THEN
                  (SELECT DB_PRDEMB_PRODUTO
                     FROM MERCANET_PRD.DB_PRODUTO_EMBAL
                    WHERE DB_PRDEMB_CODBARRA = C.DB_EDII_PRODUTO)
                 ELSE
                  C.DB_PEDI_PRODUTO
               END) AS FORNECEDOR,
       C.DB_EDII_PRODUTO AS "EAN COTADO",
       CASE
         WHEN C.DB_PEDI_PRODUTO IS NULL THEN
          (SELECT DB_PRDEMB_PRODUTO
             FROM MERCANET_PRD.DB_PRODUTO_EMBAL
            WHERE DB_PRDEMB_CODBARRA = C.DB_EDII_PRODUTO)
         ELSE
          C.DB_PEDI_PRODUTO
       END AS "CODIGO DO PRODUTO",
       C.DB_EDII_QTDE_VDA AS "QUANTIDADE COTADA",
       NVL(C.DB_PEDI_QTDE_ATEND, 0) AS "QUANTIDADE ATENDIDA",
       NVL(C.DB_PEDI_PRECO_LIQ * C.DB_PEDI_QTDE_ATEND, 0) AS "VALOR TOTAL COTADO",
       --------------------------------------------------------------------------------------------------
       'EFETIVACAO ->' AS "TIPO DO ARQUIVO",
       NVL(E.DB_EDIP_COMPRADOR, ' - ') AS "CNPJ EFETIVADOR",
       NVL(TO_CHAR(E.DB_CLI_CODIGO), ' - ') AS "CODIGO DO EFETIVADOR",
       NVL(E.DB_CLI_NOME, ' - ') AS "RAZAO SOCIAL",
       NVL(E.DB_EDIP_TXT2, ' - ') AS "CODIGO DA EFETIVACAO",
       NVL(TO_CHAR(E.DB_EDILD_DATA, 'DD/MM/YYYY HH24:MI:SS'), ' - ') AS "DATA DE PROCESSAMENTO",
       NVL(TO_CHAR(E.DB_EDIP_DTENVIO, 'DD/MM/YYYY HH24:MI:SS'), ' - ') AS "HORARIO DA RESPOSTA",
       NVL(TO_CHAR(E.DB_EDIP_CONDPGTO), ' - ') AS "CONDICAO DE PAGAMENTO",
       NVL(TO_CHAR(E.DB_PEDI_NRO_ENVIO), ' - ') AS "PEDIDO JDE",
       NVL((SELECT T1.DB_TBFAM_DESCRICAO
             FROM MERCANET_PRD.DB_TB_FAMILIA T1, MERCANET_PRD.DB_PRODUTO T2
            WHERE T1.DB_TBFAM_CODIGO = T2.DB_PROD_FAMILIA
              AND T2.DB_PROD_CODIGO = CASE
                    WHEN E.DB_PEDI_PRODUTO IS NULL THEN
                     (SELECT DB_PRDEMB_PRODUTO
                        FROM MERCANET_PRD.DB_PRODUTO_EMBAL
                       WHERE DB_PRDEMB_CODBARRA = E.DB_EDII_PRODUTO)
                    ELSE
                     E.DB_PEDI_PRODUTO
                  END),
           ' - ') AS FORNECEDOR,
       NVL(E.DB_EDII_PRODUTO, ' - ') AS "EAN EFETIVADO",
       NVL(CASE
             WHEN E.DB_PEDI_PRODUTO IS NULL THEN
              (SELECT DB_PRDEMB_PRODUTO
                 FROM MERCANET_PRD.DB_PRODUTO_EMBAL
                WHERE DB_PRDEMB_CODBARRA = E.DB_EDII_PRODUTO)
             ELSE
              E.DB_PEDI_PRODUTO
           END,
           ' - ') AS "CODIGO DO PRODUTO",
       NVL(E.DB_EDII_QTDE_VDA, 0) AS "QUANTIDADE SOLICITADA",
       NVL(E.DB_PEDI_QTDE_ATEND, 0) AS "QUANTIDADE ATENDIDA",
       NVL(E.DB_PEDI_PRECO_LIQ * E.DB_PEDI_QTDE_ATEND, 0) AS "VALOR TOTAL EFETIVADO"
  FROM (SELECT DB_EDILD_SEQ,
               DB_EDILD_NOMEARQ,
               DB_EDILD_CONTEUDO,
               DB_EDILD_SITUACAO,
               DB_EDILD_DISTR,
               DB_EDILD_DATA,
               DB_EDIP_COMPRADOR,
               DB_EDIP_OBS1,
               DB_EDIP_PEDMERC,
               DB_EDIP_DTENVIO,
               DB_EDIP_CONDPGTO,
               DB_EDIP_TXT2,
               DB_EDIP_LOTE,
               DB_EDIP_NRO,
               DB_EDII_PEDMERC,
               DB_EDII_NRO,
               DB_EDII_COMPRADOR,
               DB_EDII_SEQ,
               DB_EDII_PRODUTO,
               DB_EDII_QTDE_VDA,
               DB_CLI_CODIGO,
               DB_CLI_CGCMF,
               DB_CLI_NOME,
               DB_CLI_REGIAOCOM,
               DB_CLI_REPRES,
               AC07,
               DB_PDIT_PEDIDO,
               DB_PDIT_PRODUTO,
               DB_PDIT_EDII_SEQ,
               DB_PDIT_PEDI_SEQ,
               DB_PEDI_PEDIDO,
               DB_PEDI_PRODUTO,
               DB_PEDI_SEQUENCIA,
               DB_PEDI_QTDE_ATEND,
               DB_PEDI_PRECO_LIQ,
               DB_PEDI_NRO_ENVIO
          FROM MERCANET_PRD.DB_EDI_LOTE_DISTR LOTECOT,
               MERCANET_PRD.DB_EDI_PEDIDO     EDIPCOT,
               MERCANET_PRD.DB_EDI_PEDPROD    EDIICOT
          LEFT JOIN (SELECT DB_CLI_CODIGO,
                            DB_CLI_CGCMF,
                            DB_CLI_NOME,
                            DB_CLI_REGIAOCOM,
                            DB_CLI_REPRES,
                            AC07.DB_CLIA_VALOR AS AC07
                      FROM MERCANET_PRD.DB_CLIENTE       CLI,
                           MERCANET_PRD.DB_CLIENTE_ATRIB AC07
                     WHERE DB_CLI_CODIGO = AC07.DB_CLIA_CODIGO
                       AND AC07.DB_CLIA_ATRIB = 1007) CLICOT
            ON EDIICOT.DB_EDII_COMPRADOR = CLICOT.DB_CLI_CGCMF
          LEFT JOIN (SELECT DB_PDIT_PEDIDO,
                            DB_PDIT_PRODUTO,
                            DB_PDIT_EDII_SEQ,
                            DB_PDIT_PEDI_SEQ
                      FROM MERCANET_PRD.DB_PEDIDO_DISTR,
                           MERCANET_PRD.DB_PEDIDO_DISTR_IT
                     WHERE DB_PEDT_PEDIDO = DB_PDIT_PEDIDO
                       AND DB_PEDT_DISTR = DB_PDIT_DISTR) PDISTRCOT
            ON EDIICOT.DB_EDII_PEDMERC = PDISTRCOT.DB_PDIT_PEDIDO
           AND EDIICOT.DB_EDII_SEQ = PDISTRCOT.DB_PDIT_EDII_SEQ
          LEFT JOIN (SELECT DB_PEDI_PEDIDO,
                            DB_PEDI_PRODUTO,
                            DB_PEDI_SEQUENCIA,
                            DB_PEDI_QTDE_ATEND,
                            DB_PEDI_PRECO_LIQ,
                            DB_PEDI_NRO_ENVIO
                      FROM MERCANET_PRD.DB_PEDIDO,
                           MERCANET_PRD.DB_PEDIDO_PROD
                     WHERE DB_PED_NRO = DB_PEDI_PEDIDO) PEDCOT
            ON PDISTRCOT.DB_PDIT_PEDIDO = PEDCOT.DB_PEDI_PEDIDO
           AND PDISTRCOT.DB_PDIT_PRODUTO = PEDCOT.DB_PEDI_PRODUTO
           AND PDISTRCOT.DB_PDIT_PEDI_SEQ = PEDCOT.DB_PEDI_SEQUENCIA
          LEFT JOIN (SELECT T2.DB_TBREP_CODIGO  AS REP_MERC,
                           T2.DB_TBREP_CODORIG AS CODJDE_REP_MERC,
                           T2.DB_TBREP_NOME    AS NOME_REP_MERC,
                           T3.DB_TBREP_CODIGO  AS GA_MERC,
                           T3.DB_TBREP_CODORIG AS CODJDE_GA_MERC,
                           T3.DB_TBREP_NOME    AS NOME_GA_MERC,
                           T4.DB_TBREP_CODIGO  AS GR_MERC,
                           T4.DB_TBREP_CODORIG AS CODJDE_GR_MERC,
                           T4.DB_TBREP_NOME    AS NOME_GR_MERC
                      FROM MERCANET_PRD.DB_TB_REPRES T2,
                           MERCANET_PRD.DB_TB_REPRES T3,
                           MERCANET_PRD.DB_TB_REPRES T4
                     WHERE T2.DB_TBREP_SUPERIOR = T3.DB_TBREP_CODIGO
                       AND T3.DB_TBREP_SUPERIOR = T4.DB_TBREP_CODIGO) GER
            ON CLICOT.DB_CLI_REPRES = GER.REP_MERC
         WHERE LOTECOT.DB_EDILD_SEQ = EDIPCOT.DB_EDIP_LOTE
           AND EDIPCOT.DB_EDIP_COMPRADOR = EDIICOT.DB_EDII_COMPRADOR
           AND EDIPCOT.DB_EDIP_NRO = EDIICOT.DB_EDII_NRO
           AND LOTECOT.DB_EDILD_DISTR = 529) C
  LEFT JOIN (SELECT DB_EDILD_SEQ,
               DB_EDILD_NOMEARQ,
               DB_EDILD_CONTEUDO,
               DB_EDILD_SITUACAO,
               DB_EDILD_DISTR,
               DB_EDILD_DATA,
               DB_EDIP_COMPRADOR,
               DB_EDIP_OBS1,
               DB_EDIP_PEDMERC,
               DB_EDIP_DTENVIO,
               DB_EDIP_CONDPGTO,
               DB_EDIP_TXT2,
               DB_EDIP_LOTE,
               DB_EDIP_NRO,
               DB_EDII_PEDMERC,
               DB_EDII_NRO,
               DB_EDII_COMPRADOR,
               DB_EDII_SEQ,
               DB_EDII_PRODUTO,
               DB_EDII_QTDE_VDA,
               DB_CLI_CODIGO,
               DB_CLI_CGCMF,
               DB_CLI_NOME,
               DB_CLI_REGIAOCOM,
               DB_CLI_REPRES,
               AC07,
               DB_PDIT_PEDIDO,
               DB_PDIT_PRODUTO,
               DB_PDIT_EDII_SEQ,
               DB_PDIT_PEDI_SEQ,
               DB_PEDI_PEDIDO,
               DB_PEDI_PRODUTO,
               DB_PEDI_SEQUENCIA,
               DB_PEDI_QTDE_ATEND,
               DB_PEDI_PRECO_LIQ,
               DB_PEDI_NRO_ENVIO
               FROM MERCANET_PRD.DB_EDI_LOTE_DISTR LOTEEFET,
                    MERCANET_PRD.DB_EDI_PEDIDO     EDIPEFET,
                    MERCANET_PRD.DB_EDI_PEDPROD    EDIIEFET
               LEFT JOIN (SELECT DB_CLI_CODIGO,
                                 DB_CLI_CGCMF,
                                 DB_CLI_NOME,
                                 DB_CLI_REGIAOCOM,
                                 DB_CLI_REPRES,
                                 AC07.DB_CLIA_VALOR AS AC07
                           FROM MERCANET_PRD.DB_CLIENTE       CLI,
                                MERCANET_PRD.DB_CLIENTE_ATRIB AC07
                          WHERE DB_CLI_CODIGO = AC07.DB_CLIA_CODIGO
                            AND AC07.DB_CLIA_ATRIB = 1007) CLIEFET
                 ON EDIIEFET.DB_EDII_COMPRADOR = CLIEFET.DB_CLI_CGCMF
               LEFT JOIN (SELECT DB_PDIT_PEDIDO,
                                 DB_PDIT_PRODUTO,
                                 DB_PDIT_EDII_SEQ,
                                 DB_PDIT_PEDI_SEQ
                           FROM MERCANET_PRD.DB_PEDIDO_DISTR,
                                MERCANET_PRD.DB_PEDIDO_DISTR_IT
                          WHERE DB_PEDT_PEDIDO = DB_PDIT_PEDIDO
                            AND DB_PEDT_DISTR = DB_PDIT_DISTR) PDISTREFET
                 ON EDIIEFET.DB_EDII_PEDMERC = PDISTREFET.DB_PDIT_PEDIDO
                AND EDIIEFET.DB_EDII_SEQ = PDISTREFET.DB_PDIT_EDII_SEQ
               LEFT JOIN (SELECT DB_PEDI_PEDIDO,
                                 DB_PEDI_PRODUTO,
                                 DB_PEDI_SEQUENCIA,
                                 DB_PEDI_QTDE_ATEND,
                                 DB_PEDI_PRECO_LIQ,
                                 DB_PEDI_NRO_ENVIO
                           FROM MERCANET_PRD.DB_PEDIDO,
                                MERCANET_PRD.DB_PEDIDO_PROD
                          WHERE DB_PED_NRO = DB_PEDI_PEDIDO) PEDEFET
                 ON PDISTREFET.DB_PDIT_PEDIDO = PEDEFET.DB_PEDI_PEDIDO
                AND PDISTREFET.DB_PDIT_PRODUTO = PEDEFET.DB_PEDI_PRODUTO
                AND PDISTREFET.DB_PDIT_PEDI_SEQ = PEDEFET.DB_PEDI_SEQUENCIA
               LEFT JOIN (SELECT T2.DB_TBREP_CODIGO  AS REP_MERC,
                                T2.DB_TBREP_CODORIG AS CODJDE_REP_MERC,
                                T2.DB_TBREP_NOME    AS NOME_REP_MERC,
                                T3.DB_TBREP_CODIGO  AS GA_MERC,
                                T3.DB_TBREP_CODORIG AS CODJDE_GA_MERC,
                                T3.DB_TBREP_NOME    AS NOME_GA_MERC,
                                T4.DB_TBREP_CODIGO  AS GR_MERC,
                                T4.DB_TBREP_CODORIG AS CODJDE_GR_MERC,
                                T4.DB_TBREP_NOME    AS NOME_GR_MERC
                           FROM MERCANET_PRD.DB_TB_REPRES T2,
                                MERCANET_PRD.DB_TB_REPRES T3,
                                MERCANET_PRD.DB_TB_REPRES T4
                          WHERE T2.DB_TBREP_SUPERIOR = T3.DB_TBREP_CODIGO
                            AND T3.DB_TBREP_SUPERIOR = T4.DB_TBREP_CODIGO) GEREFET
                 ON CLIEFET.DB_CLI_REPRES = GEREFET.REP_MERC
              WHERE LOTEEFET.DB_EDILD_SEQ = EDIPEFET.DB_EDIP_LOTE
                AND EDIPEFET.DB_EDIP_COMPRADOR = EDIIEFET.DB_EDII_COMPRADOR
                AND EDIPEFET.DB_EDIP_NRO = EDIIEFET.DB_EDII_NRO
                AND LOTEEFET.DB_EDILD_DISTR = 530) E
    ON C.DB_EDIP_OBS1 = E.DB_EDIP_OBS1
   AND C.DB_EDII_PRODUTO = E.DB_EDII_PRODUTO  à
 WHERE C.DB_EDILD_DATA BETWEEN TO_DATE('07/05/2017 00:00:00','DD/MM/YYYY HH24:MI:SS')
                           AND TO_DATE('13/05/2017 23:59:59','DD/MM/YYYY HH24:MI:SS')
 ORDER BY C.DB_EDILD_DATA, C.DB_EDILD_SEQ, C.DB_EDII_SEQ

*/
