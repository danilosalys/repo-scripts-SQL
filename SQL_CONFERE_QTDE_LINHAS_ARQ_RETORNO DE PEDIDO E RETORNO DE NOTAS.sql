--CONFERENCIA DE QTDE DE LINHAS DO RETORNO DE NOTAS

SELECT DISTINCT EDIP1.DB_EDIP_LOTE,
                EDIP1.DB_EDIP_CLIENTE,
                
                (SELECT COUNT(*)
                   FROM MERCANET_PRD.DB_EDI_PEDIDO EDIP2, MERCANET_PRD.DB_EDI_PEDPROD EDII2
                  WHERE EDIP2.DB_EDIP_NRO = EDII2.DB_EDII_NRO
                    AND EDIP2.DB_EDIP_COMPRADOR = EDII2.DB_EDII_COMPRADOR
                    AND EDIP2.DB_EDIP_LOTE = EDIP1.DB_EDIP_LOTE) ||
                ' itens' "QTDE ITENS DO PEDIDO",
                
                (SELECT SUM(DISTINCT
                            TO_NUMBER(SUBSTR(EDILE1.DB_EDILE_ARQUIVO, 36, 6)))
                   FROM MERCANET_PRD.DB_EDI_PEDIDO EDIP3, MERCANET_PRD.DB_EDI_LOG_EXP EDILE1
                  WHERE EDILE1.DB_EDILE_EDIP_COMP = EDIP3.DB_EDIP_COMPRADOR
                    AND EDILE1.DB_EDILE_EDIP_NRO = EDIP3.DB_EDIP_NRO
                    AND EDILE1.DB_EDILE_EDIA_CODI = 'SEVENPDV_RET'
                    AND EDIP3.DB_EDIP_LOTE = EDIP1.DB_EDIP_LOTE) ||
                ' linhas' "RETORNO DO PEDIDO",
                
                (SELECT COUNT(*)
                   FROM MERCANET_PRD.DB_EDI_LOTE_DISTR  EDILD4,
                        MERCANET_PRD.DB_EDI_PEDIDO      EDIP4,
                        MERCANET_PRD.DB_EDI_PEDPROD     EDII4,
                        MERCANET_PRD.DB_PEDIDO          PED4,
                        MERCANET_PRD.DB_PEDIDO_PROD     PEDI4,
                        MERCANET_PRD.DB_PEDIDO_DISTR    PEDT4,
                        MERCANET_PRD.DB_PEDIDO_DISTR_IT PDIT4
                  WHERE EDILD4.DB_EDILD_SEQ = EDIP4.DB_EDIP_LOTE
                    AND EDIP4.DB_EDIP_PEDMERC = PEDT4.DB_PEDT_PEDIDO
                    AND PEDT4.DB_PEDT_PEDIDO = PED4.DB_PED_NRO
                    AND EDIP4.DB_EDIP_COMPRADOR = EDII4.DB_EDII_COMPRADOR
                    AND EDIP4.DB_EDIP_NRO = EDII4.DB_EDII_NRO
                    AND PEDT4.DB_PEDT_PEDIDO = PDIT4.DB_PDIT_PEDIDO
                    AND PED4.DB_PED_NRO = PEDI4.DB_PEDI_PEDIDO
                    AND EDII4.DB_EDII_SEQ = PDIT4.DB_PDIT_EDII_SEQ
                    AND PDIT4.DB_PDIT_PRODUTO = PEDI4.DB_PEDI_PRODUTO
                    AND PEDI4.DB_PEDI_QTDE_ATEND > 0
                    AND PEDI4.DB_PEDI_SITUACAO IN ('2', '1')
                    AND EXISTS
                  (SELECT *
                           FROM MERCANET_PRD.DB_NOTA_FISCAL NF
                          WHERE PED4.DB_PED_NRO_ORIG = NF.DB_NOTA_PED_ORIG
                            AND PED4.DB_PED_NRO = NF.DB_NOTA_PED_MERC
                            AND PED4.DB_PED_CLIENTE = NF.DB_NOTA_CLIENTE
                            AND DECODE(PED4.DB_PED_EMPRESA,
                                       104,
                                       103,
                                       PED4.DB_PED_EMPRESA) =
                                NF.DB_NOTA_EMPRESA)
                    AND EDIP4.DB_EDIP_LOTE = EDIP1.DB_EDIP_LOTE) ||
                ' itens' "QTDE ITENS DA NF",
                
                (SELECT SUM(DISTINCT
                            TO_NUMBER(SUBSTR(EDILE5.DB_EDILE_ARQUIVO, 36, 6)))
                   FROM MERCANET_PRD.DB_EDI_PEDIDO EDIP5, MERCANET_PRD.DB_EDI_LOG_EXP EDILE5
                  WHERE EDILE5.DB_EDILE_EDIP_COMP = EDIP5.DB_EDIP_COMPRADOR
                    AND EDILE5.DB_EDILE_EDIP_NRO = EDIP5.DB_EDIP_NRO
                    AND EDILE5.DB_EDILE_EDIA_CODI = 'SEVENPDV_NOT'
                    AND EDIP5.DB_EDIP_LOTE = EDIP1.DB_EDIP_LOTE) ||
                ' linhas' "RETORNO DA NOTA"

  FROM MERCANET_PRD.DB_EDI_PEDIDO EDIP1
 WHERE DB_EDIP_OBS1 = '006854'

/*
SELECT * FROM MERCANET_PRD.DB_PEDIDO_PROD 
WHERE DB_PEDI_PEDIDO = 80846440*/
