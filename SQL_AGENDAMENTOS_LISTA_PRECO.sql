SELECT T1.*,T2.EM06_LABORATORIO, T3.DB_LAB_DESCRICAO FROM 
(SELECT SERVIDOR, 
        NOME_AGENDAMENTO,
        ULTIMA_EXECUCAO, 
        VAN, 
        EMPRESA, 
        SUBSTR(LISTA_FORNECEDORES,1,INSTR(LISTA_FORNECEDORES,'')-1) AS LISTA_FORNECEDORES, 
        LISTA_PRECO, 
        SUBSTR(PROJETO,1,INSTR(PROJETO,'')-1) AS PROJETO, 
        LISTA_TIPO_PRODUTOS_ENVIADOS
 FROM 
(SELECT DM03_OBSERVACAO AS SERVIDOR,
       DM03_DESCRICAO AS NOME_AGENDAMENTO,
       DM03_ULTIMAEXEC AS ULTIMA_EXECUCAO,
       SUBSTR(TO_CHAR(DM03_CONFIGSTRING), 9, 3) AS VAN,
       SUBSTR(TO_CHAR(DM03_CONFIGSTRING), 27, 3) AS EMPRESA,
       SUBSTR(TO_CHAR(DM03_CONFIGSTRING),
              33,
              INSTR(DM03_CONFIGSTRING, 'P') - 33) AS LISTA_FORNECEDORES,
       SUBSTR(TO_CHAR(DM03_CONFIGSTRING), INSTR(DM03_CONFIGSTRING, 'P'), 3) AS LISTA_PRECO,
        TRIM(SUBSTR(TO_CHAR(DM03_CONFIGSTRING),
                   INSTR(DM03_CONFIGSTRING, 'P') + 4,
                   CASE
                     WHEN INSTR(DM03_CONFIGSTRING, 'L,P') -
                          INSTR(DM03_CONFIGSTRING, 'P') < 0 THEN
                      7
                     ELSE
                      (INSTR(DM03_CONFIGSTRING, 'L,P') - INSTR(DM03_CONFIGSTRING, 'P')) - 4
                   END)) AS PROJETO,
       NVL(REPLACE(TRIM(SUBSTR(TO_CHAR(DM03_CONFIGSTRING),
                   INSTR(DM03_CONFIGSTRING, 'L,P'),
                      (INSTR(DM03_CONFIGSTRING, 'L,P') - INSTR(DM03_CONFIGSTRING, 'P'))
                   )),'L,P', 'LIBERADOS E PERFUMARIA'),'TODOS OS PRODUTOS DO FORNECEDOR') AS LISTA_TIPO_PRODUTOS_ENVIADOS
  FROM MERCANET_PRD.MDM03
 WHERE (UPPER(DM03_DESCRICAO) LIKE '%PRE�O%' OR
       UPPER(DM03_GRUPO) LIKE '%PRE�O%')
   AND DM03_GRUPO NOT IN ('EXPORT PRE�O FINAL CLIENTE',
                          'EXPORT FTP - NISSEI PRODUTO E PRE�O',
                          'EXPORT FTP ',
                          'EXPORT PRODUTO E PRE�O')
   AND DM03_ULTIMAEXEC > '01/06/2020')
)  T1,
MERCANET_PRD.MEM06 T2,
MERCANET_PRD.DB_LABORATORIO T3
 WHERE T2.EM06_DISTR(+) = TO_CHAR(T1.VAN)
   AND T2.EM06_PROJETO(+) = T1.PROJETO
   AND T2.EM06_LABORATORIO = T3.DB_LAB_CODIGO
 
;
SELECT DB_ELP_ARQUIVO AS "ARQUIVO_PRECAO",
       TO_CHAR(SUBSTR(DB_ELP_CONTEUDO,INSTR(DB_ELP_CONTEUDO,TRIM(T1.DB_EPP_COD_PRODUTO))-6,110)) AS "SE��O_ITENS_ARQUIVO_PRE�O",
       DB_EPC_EMPRESA AS "EMPRESA",
       DB_EPC_COD_CLIENTE AS "CODIGO CLIENTE",
       DB_EPC_DATA_GERACAO AS "DATA GERACAO ARQUIVO",
       DB_EPC_COD_LISTAPRECO AS "LISTA DE PRECO",
       DB_EPC_PRAZO AS "PRAZO",
       '2' AS "TIPO DO REGISTRO",
       ROWNUM + 1 AS "SEQUENCIA DO ITEM",
       DB_EPP_COD_PRODUTO AS "CODIGO DO PRODUTO",
       CASE
         WHEN (SELECT COUNT(1)
                 FROM MERCANET_QA.DB_PRODUTO_ATRIB
                WHERE DB_PRODA_CODIGO = DB_EPP_COD_PRODUTO
                  AND DB_PRODA_ATRIB = 2008
                  AND TRIM(DB_PRODA_VALOR) IN ('C', 'V')) > 0 THEN
          DB_EPP_PRECO_BASE
         ELSE
          DB_EPP_PRECO_LIQ
       END AS "PRE�O BASE (MED) OU LIQ (HPC)",
       CASE
         WHEN (SELECT COUNT(1)
                 FROM MERCANET_QA.DB_PRODUTO_ATRIB
                WHERE DB_PRODA_CODIGO = DB_EPP_COD_PRODUTO
                  AND DB_PRODA_ATRIB = 2008
                  AND TRIM(DB_PRODA_VALOR) IN ('C', 'V')) > 0 THEN
          DB_EPP_PERC_DESC
         ELSE
          0
       END AS "PERCENTUAL DE DESCONTO",
       CASE
         WHEN (SELECT COUNT(1)
                 FROM MERCANET_QA.DB_PRODUTO_ATRIB
                WHERE DB_PRODA_CODIGO = DB_EPP_COD_PRODUTO
                  AND DB_PRODA_ATRIB = 2008
                  AND TRIM(DB_PRODA_VALOR) IN ('C', 'V')) > 0 THEN
          DB_EPP_PERC_REP_ICMS
         ELSE
          0
       END AS "PERCENTUAL DO REPASSE",
       DB_EPP_PERC_ICMS AS "PERCENTUAL ICMS",
       CASE
         WHEN DB_EPP_PERC_RED_BASE_ICMS > 0 THEN
          100 - DB_EPP_PERC_RED_BASE_ICMS
         else
          DB_EPP_PERC_RED_BASE_ICMS
       END AS "PERCENTUAL DA REDU��O DE ICMS",
       CASE
         WHEN DB_EPP_VLR_ST > 0 THEN
          ROUND(DB_EPP_BASE_CALC_ICMS_ST, 2)
         ELSE
          0
       END AS "BASE DE CALCULO ST",
       DB_EPP_VLR_ST AS "VALOR DA ST",
       DB_EPC_PRAZO AS "PRAZO",
       (SELECT LPAD(DB_PRDEMB_CODBARRA, 13, 0)
          FROM MERCANET_QA.DB_PRODUTO_EMBAL A
         WHERE DB_PRDEMB_PRODUTO = DB_PROD_CODIGO
           AND LENGTH(DB_PRDEMB_CODBARRA) <= 13
           AND DB_PRDEMB_CODEMB IN
               (SELECT MAX(DB_PRDEMB_CODEMB)
                  FROM MERCANET_QA.DB_PRODUTO_EMBAL B
                 WHERE A.DB_PRDEMB_PRODUTO = B.DB_PRDEMB_PRODUTO
                   AND B.DB_PRDEMB_PADRAO IN
                       (SELECT MAX(NVL(DB_PRDEMB_PADRAO, 0))
                          FROM MERCANET_QA.DB_PRODUTO_EMBAL C
                         WHERE C.DB_PRDEMB_PRODUTO = A.DB_PRDEMB_PRODUTO))) AS "COT_EAN_CLAMED",
       CASE
         WHEN (SELECT COUNT(1)
                 FROM MERCANET_QA.DB_PRODUTO_ATRIB
                WHERE DB_PRODA_CODIGO = DB_EPP_COD_PRODUTO
                  AND DB_PRODA_ATRIB = 2008
                  AND DB_PRODA_VALOR = 'P') > 0 THEN
          'S'
         ELSE
          'N'
       END AS "HPC?",
       '0000' AS "DESCONTO ADICIONAL",
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
       END AS "VALOR ST FARMACIA POPULAR",
       NVL((SELECT distinct CASE
                             WHEN DB_ESTAL_QTDE_EST > 0 THEN
                              DB_ESTAL_QTDE_EST
                             ELSE
                              0
                           END DB_ESTAL_QTDE_EST
             FROM MERCANET_QA.DB_ESTOQUE_ALMOX,
                  MERCANET_QA.DB_PRODUTO_ATRIB
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
           0) AS "QUANTIDADE EM ESTOQUE",
       '3' AS "PERCENTUAL DE MIDIA"
  FROM MERCANET_QA.DB_EDI_PRECOCLI_PROD T1,
       MERCANET_QA.DB_PRODUTO           T2,
       MERCANET_QA.DB_EDI_PRECOCLI      T3,
       MERCANET_QA.DB_EDI_LOG_PRECOCLI  T4
 WHERE DB_EPP_ID = DB_EPC_ID
   AND DB_EPP_COD_PRODUTO = DB_PROD_CODIGO
   AND db_epc_data_geracao > '12/06/2020'
   AND db_epc_id IN (18,19,20,21,22,23)
   AND DB_EPC_ID = DB_ELP_ID
ORDER BY DB_ELP_ARQUIVO
;






