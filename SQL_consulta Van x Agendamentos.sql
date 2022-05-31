--DATA 07/08/2013

SELECT DISTINCT 
                B.DB_EDILD_DISTR as "COD_VAN",
                D.EM01_EAN as "NOME_VAN",
                (SUBSTR(C.DM03_CONFIGSTRING,
                        INSTR(C.DM03_CONFIGSTRING, '\\', 1, 1) + 2,
                        (INSTR(C.DM03_CONFIGSTRING, '\', 1, 3) -
                        INSTR(C.DM03_CONFIGSTRING, '\\', 1, 1) - 2))) as "SERVIDOR",
                C.DM03_SERVICO as "INSTANCIA/SERVIÇO",
                COUNT(DISTINCT B.DB_EDILD_SEQ) AS "TOTAL_ARQUIVOS",
                SUM(DISTINCT DBMS_LOB.getlength(B.DB_EDILD_CONTEUDO)) "CONSUMO_ESPAÇO_DISCO_BYTES",
	              (SELECT COUNT(T1.DB_EDII_PRODUTO) FROM MERCANET_PRD.DB_EDI_PEDPROD T1
                 WHERE T1.DB_EDII_COMPRADOR = A.DB_EDIP_COMPRADOR
                   AND T1.DB_EDII_NRO = A.DB_EDIP_NRO)
  FROM MERCANET_PRD.DB_EDI_PEDIDO     A,
       MERCANET_PRD.DB_EDI_LOTE_DISTR B,
       MERCANET_PRD.MDM03             C,
       MERCANET_PRD.MEM01             D
 WHERE A.DB_EDIP_LOTE = B.DB_EDILD_SEQ
   AND B.DB_EDILD_DATA > TO_DATE('01/01/2013', 'DD/MM/YYYY')
   AND B.DB_EDILD_DISTR = D.EM01_CODIGO
   AND C.DM03_GRUPO in ('IMPORT OL', 'IMPORT PED')
   AND C.DM03_ULTIMAEXEC > '01/01/2013'
   AND CASE
         WHEN DB_EDILD_DISTR IN (529, 530) THEN
          UPPER(SUBSTR(D.EM01_PASTABKP,
                       1,
                       INSTR(D.EM01_PASTABKP, '\', 1, 8) -
                       INSTR(D.EM01_PASTABKP, '\\', 1, 1)))
         ELSE
          UPPER(SUBSTR(D.EM01_PASTABKP,
                       1,
                       INSTR(D.EM01_PASTABKP, '\', 1, 7) -
                       INSTR(D.EM01_PASTABKP, '\\', 1, 1)))
       END = CASE
         WHEN DB_EDILD_DISTR IN (529, 530) THEN
          UPPER(SUBSTR(C.DM03_CONFIGSTRING,
                       INSTR(C.DM03_CONFIGSTRING, '\\', 1, 1),
                       INSTR(C.DM03_CONFIGSTRING, '\', 1, 8) -
                       INSTR(C.DM03_CONFIGSTRING, '\\', 1, 1)))
         ELSE
          UPPER(SUBSTR(C.DM03_CONFIGSTRING,
                       INSTR(C.DM03_CONFIGSTRING, '\\', 1, 1),
                       INSTR(C.DM03_CONFIGSTRING, '\', 1, 7) -
                       INSTR(C.DM03_CONFIGSTRING, '\\', 1, 1)))
       END
 GROUP BY B.DB_EDILD_DISTR,
          C.DM03_GUID,
          D.EM01_CODIGO,
          D.EM01_EAN,
          C.DM03_CONFIGSTRING,
          C.DM03_SERVICO,
          C.DM03_DESCRICAO,
          A.DB_EDIP_COMPRADOR,
          A.DB_EDIP_NRO

