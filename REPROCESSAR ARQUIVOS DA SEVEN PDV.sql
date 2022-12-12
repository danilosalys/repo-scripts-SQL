--VERIFICANDO SE PROCESSOU TODAS DAS LINHAS

SELECT * FROM 
(SELECT DISTINCT (SELECT MAX(TO_NUMBER(SUBSTR(DB_EDILD_NOMEARQ, 39, 6)))
                   FROM MERCANET_PRD.DB_EDI_LOTE_DISTR EDILD
                  WHERE EDILD.DB_EDILD_SEQ = EPD.DB_EDIP_LOTE) "TOTAL LINHAS DO ARQUIVO",
                
                EPD.DB_EDIP_LOTE,
                
                ELD.DB_EDILD_NOMEARQ,
                
                ((SELECT distinct (COUNT(*))
                   FROM MERCANET_PRD.DB_EDI_PEDIDO  EDIP,
                        MERCANET_PRD.DB_EDI_PEDPROD EDII
                  WHERE EDIP.DB_EDIP_COMPRADOR = EDII.DB_EDII_COMPRADOR
                    AND EDIP.DB_EDIP_NRO = EDII.DB_EDII_NRO
                    AND EDIP.DB_EDIP_LOTE = EPD.DB_EDIP_LOTE
                    AND EDIP.DB_EDIP_DTENVIO BETWEEN DB_EDILD_DATA AND SYSDATE)  +
                        (SELECT distinct (COUNT(*))
                           FROM MERCANET_PRD.DB_EDI_PEDIDO  EDIP,
                                MERCANET_PRD.DB_EDI_PEDPROD EDII
                          WHERE EDIP.DB_EDIP_COMPRADOR =
                                EDII.DB_EDII_COMPRADOR
                            AND EDIP.DB_EDIP_NRO = EDII.DB_EDII_NRO
                            AND EDIP.DB_EDIP_LOTE = EPD.DB_EDIP_LOTE
                            AND EDIP.DB_EDIP_DTENVIO is null)) "TOTAL CONSISTIDO(LINHAS)",
                
                (SELECT (COUNT(*))
                   FROM MERCANET_PRD.DB_EDI_PEDIDO  EDIP,
                        MERCANET_PRD.DB_EDI_PEDPROD EDII
                  WHERE EDIP.DB_EDIP_COMPRADOR = EDII.DB_EDII_COMPRADOR
                    AND EDIP.DB_EDIP_NRO = EDII.DB_EDII_NRO
                    AND EDIP.DB_EDIP_LOTE = EPD.DB_EDIP_LOTE
                    AND EDIP.DB_EDIP_DTENVIO =
                        TO_DATE('31/12/9999 00:00:00',
                                'DD/MM/YYYY HH24:MI:SS')) "FALTA CONSISTIR (LINHAS)",
                
                (SELECT COUNT(EDIP.DB_EDIP_NRO)
                   FROM MERCANET_PRD.DB_EDI_PEDIDO EDIP
                  WHERE EDIP.DB_EDIP_LOTE = EPD.DB_EDIP_LOTE
                    AND EDIP.DB_EDIP_DTENVIO IS NULL) +
                     (SELECT COUNT(EDIP.DB_EDIP_NRO)
                   FROM MERCANET_PRD.DB_EDI_PEDIDO EDIP
                  WHERE EDIP.DB_EDIP_LOTE = EPD.DB_EDIP_LOTE
                    AND EDIP.DB_EDIP_DTENVIO BETWEEN DB_EDILD_DATA AND SYSDATE) "EDIP_NRO GERADOS",
                
                (SELECT CASE
                          WHEN (((SELECT distinct (COUNT(*))
                   FROM MERCANET_PRD.DB_EDI_PEDIDO  EDIP,
                        MERCANET_PRD.DB_EDI_PEDPROD EDII
                  WHERE EDIP.DB_EDIP_COMPRADOR = EDII.DB_EDII_COMPRADOR
                    AND EDIP.DB_EDIP_NRO = EDII.DB_EDII_NRO
                    AND EDIP.DB_EDIP_LOTE = EPD.DB_EDIP_LOTE
                    AND EDIP.DB_EDIP_DTENVIO  BETWEEN DB_EDILD_DATA AND SYSDATE) +
                        (SELECT distinct (COUNT(*))
                           FROM MERCANET_PRD.DB_EDI_PEDIDO  EDIP,
                                MERCANET_PRD.DB_EDI_PEDPROD EDII
                          WHERE EDIP.DB_EDIP_COMPRADOR =
                                EDII.DB_EDII_COMPRADOR
                            AND EDIP.DB_EDIP_NRO = EDII.DB_EDII_NRO
                            AND EDIP.DB_EDIP_LOTE = EPD.DB_EDIP_LOTE
                            AND EDIP.DB_EDIP_DTENVIO is null)) <
                               
                               (SELECT (TO_NUMBER(SUBSTR(DB_EDILD_NOMEARQ,
                                                          39,
                                                          6)))
                                   FROM MERCANET_PRD.DB_EDI_LOTE_DISTR EDILD
                                  WHERE EDILD.DB_EDILD_SEQ = EPD.DB_EDIP_LOTE)) THEN
                           'NAO FINALIZADA'
                          ELSE
                           CASE
                             WHEN ((SELECT distinct (COUNT(*))
                   FROM MERCANET_PRD.DB_EDI_PEDIDO  EDIP,
                        MERCANET_PRD.DB_EDI_PEDPROD EDII
                  WHERE EDIP.DB_EDIP_COMPRADOR = EDII.DB_EDII_COMPRADOR
                    AND EDIP.DB_EDIP_NRO = EDII.DB_EDII_NRO
                    AND EDIP.DB_EDIP_LOTE = EPD.DB_EDIP_LOTE
                    AND EDIP.DB_EDIP_DTENVIO  BETWEEN DB_EDILD_DATA AND SYSDATE +
                        (SELECT distinct (COUNT(*))
                           FROM MERCANET_PRD.DB_EDI_PEDIDO  EDIP,
                                MERCANET_PRD.DB_EDI_PEDPROD EDII
                          WHERE EDIP.DB_EDIP_COMPRADOR =
                                EDII.DB_EDII_COMPRADOR
                            AND EDIP.DB_EDIP_NRO = EDII.DB_EDII_NRO
                            AND EDIP.DB_EDIP_LOTE = EPD.DB_EDIP_LOTE
                            AND EDIP.DB_EDIP_DTENVIO is null)) =
                                  
                                  (SELECT (TO_NUMBER(SUBSTR(DB_EDILD_NOMEARQ,
                                                             39,
                                                             6)))
                                      FROM MERCANET_PRD.DB_EDI_LOTE_DISTR EDILD
                                     WHERE EDILD.DB_EDILD_SEQ = EPD.DB_EDIP_LOTE)) THEN
                              'OK - FINALIZADO'
                             ELSE
                              'NAO INICIADA'
                           END
                        END
                   FROM MERCANET_PRD.DB_EDI_LOTE_DISTR EDILD
                  WHERE EDILD.DB_EDILD_SEQ = EPD.DB_EDIP_LOTE) "CONSISTENCIA"

  FROM MERCANET_PRD.DB_EDI_LOTE_DISTR ELD,
       MERCANET_PRD.DB_EDI_PEDIDO     EPD,
       MERCANET_PRD.DB_EDI_PEDPROD    EPP
 WHERE DB_EDIP_VAN = 508
   AND DB_EDIP_LOTE = DB_EDILD_SEQ
   AND DB_EDIP_COMPRADOR = DB_EDII_COMPRADOR
   AND DB_EDIP_NRO = DB_EDII_NRO
   --AND DB_EDIP_LOTE = 14964645
   AND DB_EDIP_DT_EMISSAO >  '30/07/2022'
   --AND EPD.DB_EDIP_OBS1 IN ('009830')
   --AND EPD.DB_EDIP_CLIENTE = '05651966000455' --INFORME OS LOTES
-- AND ELD.DB_EDILD_NOMEARQ = 'SP00665505651966000960LGX201210241105_000116.S43' --= 678208 --informe OS ARQUIVOS
 GROUP BY ELD.DB_EDILD_NOMEARQ,
          EPD.DB_EDIP_COMPRADOR,
          EPD.DB_EDIP_NRO,
          EPD.DB_EDIP_LOTE,
          ELD.DB_EDILD_SEQ, 
          ELD.DB_EDILD_DATA
 ORDER BY ELD.DB_EDILD_NOMEARQ DESC, EPD.DB_EDIP_LOTE
 )
 WHERE CONSISTENCIA = 'NAO FINALIZADA'
 ;
 



/*--REPROCESSAR ARQUIVO

--1º OBTER LINHAS PROCESSADAS
DROP TABLE LINHA_PROCESSADA;
CREATE TABLE LINHA_PROCESSADA(NOMEARQ VARCHAR2(100),
                              CNPJ VARCHAR2(14),
                              EAN  NUMBER(13),
                              PROJETO VARCHAR2(2),
                              QUANTIDADE VARCHAR2(4),
                              PED_NRO    VARCHAR2(30)
                              );
ALTER TABLE LINHA_PROCESSADA ADD CONSTRAINT PK_LP PRIMARY KEY(NOMEARQ,
                                                              CNPJ,
                                                              EAN,
                                                              PROJETO,
                                                              PED_NRO
                                                              );

INSERT INTO LINHA_PROCESSADA
  SELECT DB_EDILD_NOMEARQ,
         DB_EDII_COMPRADOR,
         DB_EDII_PRODUTO,
         DB_EDII_PROJETO,
         DB_EDII_QTDE_VDA,
         DB_EDII_NRO 
    FROM MERCANET_PRD.DB_EDI_LOTE_DISTR EDILD, MERCANET_PRD.DB_EDI_PEDIDO EDIP, MERCANET_PRD.DB_EDI_PEDPROD EDII
   WHERE EDIP.DB_EDIP_COMPRADOR = EDII.DB_EDII_COMPRADOR
     AND EDIP.DB_EDIP_NRO = EDII.DB_EDII_NRO
     AND EDILD.DB_EDILD_SEQ = EDIP.DB_EDIP_LOTE 
     AND EDIP.DB_EDIP_LOTE IN (59067434,59058427,59056097,59042364,59027940) --INSERIR LOTE
     AND EDIP.DB_EDIP_DTENVIO IS NULL
  UNION
  SELECT DB_EDILD_NOMEARQ,
         DB_EDII_COMPRADOR,
         DB_EDII_PRODUTO,
         DB_EDII_PROJETO,
         DB_EDII_QTDE_VDA,
         DB_EDII_NRO
    FROM MERCANET_PRD.DB_EDI_LOTE_DISTR EDILD, MERCANET_PRD.DB_EDI_PEDIDO EDIP, MERCANET_PRD.DB_EDI_PEDPROD EDII
   WHERE EDIP.DB_EDIP_COMPRADOR = EDII.DB_EDII_COMPRADOR
     AND EDIP.DB_EDIP_NRO = EDII.DB_EDII_NRO
     AND EDILD.DB_EDILD_SEQ = EDIP.DB_EDIP_LOTE 
     AND EDIP.DB_EDIP_LOTE IN (59067434,59058427,59056097,59042364,59027940) --INSERIR LOTE
     AND EDIP.DB_EDIP_DTENVIO <> '31/12/9999'
     AND EDIP.DB_EDIP_DTENVIO IS NOT NULL;
COMMIT;

--2º OBTER ARQUIVO COM TODAS AS LINHAS e GRAVAR NA TABELA TEMPORARIA
DROP TABLE PEDIDO_SEVENPDV;
create table PEDIDO_SEVENPDV(NOMEARQUIVO VARCHAR2(100),
                             CNPJ_PED VARCHAR2(14),
                             EAN_PED VARCHAR2(13),
                             PROJETO_PED VARCHAR2(2),
                             QUANTIDADE_PED VARCHAR2(4),
                             DESCONTO1_PED VARCHAR2(5),
                             DESCONTO2_PED VARCHAR2(5),
                             FIXO_PED VARCHAR2(1),
                             CONDICAOPGTO_PED VARCHAR2(2),
                             ORDEMCOMPRA_PED VARCHAR2(15));
ALTER TABLE PEDIDO_SEVENPDV ADD CONSTRAINT PK_PS PRIMARY KEY(NOMEARQUIVO,
                                                             CNPJ_PED,
                                                             EAN_PED,
                                                             PROJETO_PED,
                                                             ORDEMCOMPRA_PED);

SELECT * FROM MERCANET_PRD.DB_EDI_LOTE_DISTR WHERE DB_EDILD_SEQ IN (59067434,59058427,59056097,59042364,59027940);
--
SELECT * FROM PEDIDO_SEVENPDV FOR UPDATE; --INSERIR ARQUIVO DE PEDIDO (TABULAR TODOS OS CAMPOS DO LAYOUT NO EXCEL PRIMEIRO)


--RETORNA AS LINHAS DO ARQUIVO DE PEDIDO NAO PROCESSADA (COPIAR O ARQUIVO PARA UM TXT E COLOCAR NA PASTA TRANSAÇAO)
SELECT *
  FROM PEDIDO_SEVENPDV
 WHERE NOT EXISTS (SELECT *
          FROM LINHA_PROCESSADA
         WHERE CNPJ_PED = CNPJ
           AND EAN_PED = EAN)
 ORDER BY CNPJ_PED, EAN_PED*/



