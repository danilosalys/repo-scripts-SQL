select DB_EPC_ID,
       DB_CLI_CODIGO,
       DB_CLI_ESTADO,
       DB_TBEMP_CODIGO,
       DB_TBEMP_CNPJ,
       CASE NVL((SELECT MAX(DB_CLI_ESTADO)
              FROM MERCANET_QA.DB_CLIENTE
             WHERE DB_EPC_COD_CLIENTE = DB_CLI_CODIGO),
            0)
         WHEN 'SP' THEN
          '053405954'
         WHEN 'SC' THEN
          '053405988'
         WHEN 'PR' THEN
          '053405988'
         WHEN 'MS' THEN
          '053405988'
         WHEN 'RS' THEN
          '053405988'
         ELSE
          '000000000'
       END AS CQ3,
       NVL((SELECT MAX(DB_CLI_ESTADO)
             FROM MERCANET_QA.DB_CLIENTE
            WHERE DB_EPC_COD_CLIENTE = DB_CLI_CODIGO),
           0) AS CQ4,
       TO_CHAR(CURRENT_DATE, 'DDMMYYYY') AS CQ5,
       ROWNUM + 1 AS CQ7,
       DB_EPP_COD_PRODUTO AS CQ8,
       CASE
         WHEN (SELECT COUNT(1)
                 FROM MERCANET_QA.DB_PRODUTO_ATRIB
                WHERE DB_PRODA_CODIGO = DB_EPP_COD_PRODUTO
                  AND DB_PRODA_ATRIB = 2008
                  AND TRIM(DB_PRODA_VALOR) IN ('C', 'V')) > 0 THEN
          DB_EPP_PRECO_BASE
         ELSE
          DB_EPP_PRECO_LIQ
       END AS CQ9,
       CASE
         WHEN (SELECT COUNT(1)
                 FROM MERCANET_QA.DB_PRODUTO_ATRIB
                WHERE DB_PRODA_CODIGO = DB_EPP_COD_PRODUTO
                  AND DB_PRODA_ATRIB = 2008
                  AND TRIM(DB_PRODA_VALOR) IN ('C', 'V')) > 0 THEN
          DB_EPP_PERC_REP_ICMS
         ELSE
          0
       END AS CQ11,
       DB_EPP_PERC_ICMS AS CQ12,
       CASE
         WHEN DB_EPP_PERC_RED_BASE_ICMS > 0 THEN
          100 - DB_EPP_PERC_RED_BASE_ICMS
         else
          DB_EPP_PERC_RED_BASE_ICMS
       END AS CQ13,
       CASE
         WHEN DB_EPP_VLR_ST > 0 THEN
          DB_EPP_BASE_CALC_ICMS_ST
         ELSE
          0
       END AS CQ14,
       DB_EPP_VLR_ST AS CQ15,
       DB_EPC_PRAZO AS CQ16,
       (SELECT MAX(LPAD(DB_PRDEMB_CODBARRA, 13, 0))
          FROM MERCANET_QA.DB_PRODUTO_EMBAL A
         WHERE DB_PRDEMB_PRODUTO = DB_PROD_CODIGO
           AND LENGTH(DB_PRDEMB_CODBARRA) <= 13
           AND DB_PRDEMB_PADRAO IN
               (SELECT MAX(NVL(DB_PRDEMB_PADRAO, 0))
                  FROM MERCANET_QA.DB_PRODUTO_EMBAL C
                 WHERE C.DB_PRDEMB_PRODUTO = A.DB_PRDEMB_PRODUTO)) AS CQ17,
       CASE
         WHEN (SELECT COUNT(1)
                 FROM MERCANET_QA.DB_PRODUTO_ATRIB
                WHERE DB_PRODA_CODIGO = DB_EPP_COD_PRODUTO
                  AND DB_PRODA_ATRIB = 2008
                  AND DB_PRODA_VALOR = 'P') > 0 THEN
          'S'
         ELSE
          'N'
       END AS CQ18,

       CASE
         WHEN (SELECT COUNT(1)
                 FROM MERCANET_QA.DB_MRG_PRES_ITEM B
                WHERE B.DB_MPRI_CODIGO = 4
                  AND B.DB_MPRI_LST_PROD = DB_EPP_COD_PRODUTO
                  AND B.DB_MPRI_UF_ORIG IN
                      (SELECT DB_TBEMP_UF
                         FROM MERCANET_QA.DB_TB_EMPRESA
                        WHERE DB_EPC_EMPRESA = DB_TBEMP_CODIGO)
                  AND B.DB_MPRI_UF_DEST IN
                      (SELECT DB_CLI_ESTADO
                         FROM MERCANET_QA.DB_CLIENTE
                        WHERE DB_EPC_COD_CLIENTE = DB_CLI_CODIGO)) > 0 THEN
          DB_EPP_VLR_ST
         ELSE
          0
       END AS CQ20,
       NVL((SELECT distinct CASE
                             WHEN DB_ESTAL_QTDE_EST > 0 THEN
                              DB_ESTAL_QTDE_EST
                             ELSE
                              0
                           END DB_ESTAL_QTDE_EST
             FROM MERCANET_QA.DB_ESTOQUE_ALMOX, MERCANET_QA.DB_PRODUTO_ATRIB
            WHERE DB_EPP_COD_PRODUTO = DB_ESTAL_PRODUTO
              AND DB_ESTAL_QTDE_EST > 0
              AND DB_EPP_COD_PRODUTO = DB_PRODA_CODIGO
              AND DB_PRODA_ATRIB = 2010
              AND DB_ESTAL_EMPRESA = (CASE
                    WHEN ((SELECT COUNT(1)
                             FROM MERCANET_QA.DB_ESTOQUE_PRODEMP
                            WHERE VALOR_ATRIBUTO = DB_PRODA_VALOR
                              AND EMPRESA_FATURAMENTO = DB_EPC_EMPRESA)) = 0 THEN
                     (SELECT TO_NUMBER(DB_TBEMP_EMPESTOQ)
                        FROM MERCANET_QA.DB_TB_EMPRESA
                       WHERE DB_TBEMP_CODIGO = DB_EPC_EMPRESA)
                    ELSE
                     (SELECT TO_NUMBER(EMPRESA_ESTOQUE)
                        FROM MERCANET_QA.DB_ESTOQUE_PRODEMP
                       WHERE VALOR_ATRIBUTO = DB_PRODA_VALOR
                         AND EMPRESA_FATURAMENTO = DB_EPC_EMPRESA)
                  END)),
           0) AS CQ21,
       (SELECT MAX(DB_PROD_CLASFIS)
          FROM MERCANET_QA.DB_PRODUTO
         WHERE DB_PROD_CODIGO = DB_EPP_COD_PRODUTO) AS CQ23,
       NVL((SELECT DB_PRODA_VALOR
             FROM MERCANET_QA.DB_PRODUTO_ATRIB
            WHERE DB_PRODA_ATRIB = 2021
              AND DB_PRODA_CODIGO = DB_PROD_CODIGO),
           ' ') AS CQ24,

       NVL((SELECT DECODE(DB_PRODA_VALOR, 'IMP', '2', '0')
             FROM MERCANET_QA.DB_PRODUTO_ATRIB
            WHERE DB_PRODA_ATRIB = 2018
              AND DB_PRODA_CODIGO = DB_PROD_CODIGO),
           '0') AS CQ26,
       CASE
         WHEN DB_EPP_PERC_ICMS > 0 AND DB_EPP_PERC_RED_BASE_ICMS = 0 AND
              DB_EPP_PERC_RED_BASE_ICMSST = 0 THEN
          '00'
         WHEN DB_EPP_PERC_ICMS > 0 AND DB_EPP_PERC_RED_BASE_ICMS = 0 AND
              DB_EPP_PERC_RED_BASE_ICMSST > 0 THEN
          '20'
         WHEN DB_EPP_PERC_ICMS = 0 AND DB_EPP_PERC_RED_BASE_ICMS = 0 AND
              DB_EPP_PERC_RED_BASE_ICMSST = 0 THEN
          '40'
         WHEN DB_EPP_PERC_ICMS > 0 AND DB_EPP_PERC_RED_BASE_ICMS > 0 AND
              DB_EPP_PERC_RED_BASE_ICMSST > 0 THEN
          DECODE(DB_EPC_COD_LISTAPRECO, 'PSP', '60', 'PMG', '60', '70')
         WHEN DB_EPP_PERC_ICMS > 0 AND DB_EPP_PERC_RED_BASE_ICMS > 0 AND
              DB_EPP_PERC_RED_BASE_ICMSST = 0 THEN
          '10'
         ELSE
          '00'
       END AS CQ27,
       NVL((SELECT B.DB_PRECOP_VALOR
             FROM MERCANET_QA.DB_PRECO A, MERCANET_QA.DB_PRECO_PROD B
            WHERE A.DB_PRECO_LST_PMC = B.DB_PRECOP_CODIGO
              AND A.DB_PRECO_CODIGO = DB_EPC_COD_LISTAPRECO
              AND B.DB_PRECOP_PRODUTO = DB_EPP_COD_PRODUTO),
           0) AS CQ32,
       NVL((SELECT MIN(DECODE(DB_PRDEMB_QTDEEMB, 0, 1, DB_PRDEMB_QTDEEMB))
             FROM MERCANET_QA.DB_PRODUTO_EMBAL A
            WHERE A.DB_PRDEMB_PRODUTO = DB_EPP_COD_PRODUTO
              AND A.DB_PRDEMB_PADRAO = 1),
           1) AS CQ33,
       NVL((SELECT COUNT(1) + 2
             FROM MERCANET_QA.DB_EDI_PRECOCLI_PROD A
            WHERE A.DB_EPP_ID = DB_EDI_PRECOCLI_PROD.DB_EPP_ID),
           0) AS CQ35,
       NVL((SELECT COUNT(1) + 2
             FROM MERCANET_QA.DB_EDI_PRECOCLI_PROD A
            WHERE A.DB_EPP_ID = DB_EDI_PRECOCLI_PROD.DB_EPP_ID),
           0) AS CQ36,

           -----------
       DB_PROD_CODIGO    AS CODIGO_PRODUTO,
       DB_PROD_DESCRICAO AS DESCRICAO_PRODUTO,
       DB_EPP_PRECO_LIQ  AS PRECO_LIQUIDO,
       CASE
         WHEN (SELECT COUNT(1)
                 FROM MERCANET_QA.DB_PRODUTO_ATRIB
                WHERE DB_PRODA_CODIGO = DB_EPP_COD_PRODUTO
                  AND DB_PRODA_ATRIB = 2008
                  AND TRIM(DB_PRODA_VALOR) IN ('C', 'V')) > 0 THEN
          DB_EPP_PERC_DESC
         ELSE
          0
       END AS DESCONTO_A_Z,

       NVL((SELECT MAX(DB_TBCVP_DESCTO)
         FROM MERCANET_QA.DB_TB_COND_VPRZ,
              MERCANET_QA.DB_TB_COND_VPRZAT
        WHERE DB_TBCVPA_CODIGO = 1
          AND DB_TBCVP_CODIGO  = DB_TBCVPA_CODIGO
          AND DB_TBCVP_SEQ     = DB_TBCVPA_SEQ
          AND DB_PROD_FAMILIA  = DB_TBCVPA_VALOR),0) AS DESCONTO_OL
       ------------
  from MERCANET_QA.DB_EDI_PRECOCLI,
       MERCANET_QA.DB_EDI_PRECOCLI_PROD,
       MERCANET_QA.db_tb_empresa,
       MERCANET_QA.db_cliente,
       MERCANET_QA.db_produto
 Where DB_EPC_ID = DB_EPP_ID
   and DB_EPC_EMPRESA = DB_TBEMP_CODIGO
   and DB_EPC_COD_CLIENTE = DB_CLI_CODIGO
   and DB_EPP_COD_PRODUTO = db_prod_codigo
   and DB_EPC_ID = 507
