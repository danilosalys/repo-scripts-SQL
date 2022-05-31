SELECT DISTINCT EPD.DB_EDIP_LOTE "NUM LOTE MERCANET",

                ELD.DB_EDILD_NOMEARQ "NOME DO ARQUIVO",
                  
                 (SELECT distinct (EM01_EAN)
                   FROM mercanet_prd.DB_EDI_PEDIDO  EDIP,
                        mercanet_prd.Mem01 MEM01
                  WHERE EDIP.DB_EDIP_VAN = MEM01.EM01_CODIGO
                  AND EDIP.DB_EDIP_COMPRADOR = EPD.DB_EDIP_COMPRADOR
                  AND EDIP.DB_EDIP_NRO = EPD.DB_EDIP_NRO 
                  AND EDIP.DB_EDIP_LOTE = EPD.DB_EDIP_LOTE)"VAN",
                
                DB_EDIP_NRO "CODIGO PEDIDO VAN",
                
                
                CASE WHEN DB_EDIP_PEDMERC IS NULL THEN 'Não Gerado' else
                 to_char(DB_EDIP_PEDMERC)  end "CODIGO PEDIDO MERCANET",               
                  
                   (SELECT distinct (COUNT(*))
                   FROM mercanet_prd.DB_EDI_PEDIDO  EDIP,
                        mercanet_prd.DB_EDI_PEDPROD EDII
                  WHERE EDIP.DB_EDIP_COMPRADOR = EDII.DB_EDII_COMPRADOR
                    AND EDIP.DB_EDIP_NRO = EDII.DB_EDII_NRO
                    AND EDIP.DB_EDIP_LOTE  = EPD.DB_EDIP_LOTE
                   /* AND NOT EXISTS
                  (SELECT *
                           FROM mercanet_prd.DB_EDI_PEDIDO EDIP2
                          WHERE EDIP.DB_EDIP_DTENVIO =
                                TO_DATE('31/12/9999 00:00:00',
                                        'DD/MM/YYYY HH24:MI:SS'))*/)"TOTAL DE PRODUTOS A PROCESSAR",

                DB_EDILD_DATA "DATA/HORA DE ENTRADA ARQ",
                
                CASE WHEN (SELECT COUNT(1) FROM MERCANET_PRD.DB_PEDIDO_DISTR PDT
                           WHERE PDT.DB_PEDT_PEDIDO = EPD.DB_EDIP_PEDMERC) = 0 THEN '0' ELSE                                         
                (SELECT trim(to_char(trunc(((max(DB_PEDT_DTCOLET) - max(DB_EDILD_DATA)) *
                              86400 / 3600)),'09')) || ':' ||
                        trim(to_char(trunc(mod((max(DB_PEDT_DTCOLET) - max(DB_EDILD_DATA)) *
                                  86400,
                                  3600) / 60),'09')) || ':' ||
                         trim(to_char(trunc(mod(mod((max(DB_PEDT_DTCOLET) -
                                      max(DB_EDILD_DATA)) * 86400,
                                      3600),
                                  60)),'09'))
                   FROM mercanet_prd.DB_PEDIDO_DISTR     A,
                        mercanet_prd.DB_EDI_PEDIDO       B,
                        mercanet_prd.DB_PEDIDO           C,
                        mercanet_prd.INTERFACE_DB_PEDIDO D,
                        mercanet_prd.DB_EDI_LOTE_DISTR   E
                  WHERE B.DB_EDIP_PEDMERC = A.DB_PEDT_PEDIDO(+)
                    AND A.DB_PEDT_PEDIDO = C.DB_PED_NRO(+)
                    AND C.DB_PED_NRO = D.DB_PED_NRO(+)
                    AND E.DB_EDILD_SEQ = B.DB_EDIP_LOTE
                    AND DB_EDIP_LOTE = EPD.DB_EDIP_LOTE) END as "TEMPO DE IMPORTAÇÃO"
                    
  FROM mercanet_prd.DB_EDI_LOTE_DISTR ELD,
       mercanet_prd.DB_EDI_PEDIDO     EPD,
       mercanet_prd.DB_EDI_PEDPROD    EPP
 WHERE DB_EDIP_LOTE = DB_EDILD_SEQ
   AND DB_EDIP_COMPRADOR = DB_EDII_COMPRADOR
   AND DB_EDIP_NRO = DB_EDII_NRO
   AND eld.db_edild_data  BETWEEN TO_DATE('08/04/2013 00:00:00','DD/MM/YYYY HH24:MI:SS')
                              AND TO_DATE('08/04/2013 23:59:00','DD/MM/YYYY HH24:MI:SS')
   AND EPD.DB_EDIP_VAN != 508
UNION 
SELECT DISTINCT EPD.DB_EDIP_LOTE "NUM LOTE MERCANET",

                ELD.DB_EDILD_NOMEARQ "NOME DO ARQUIVO",
                 
                              
              (SELECT distinct (EM01_EAN)
                   FROM mercanet_prd.DB_EDI_PEDIDO  EDIP,
                        mercanet_prd.Mem01 MEM01
                  WHERE EDIP.DB_EDIP_VAN = MEM01.EM01_CODIGO
                  AND EDIP.DB_EDIP_COMPRADOR = EPD.DB_EDIP_COMPRADOR
                  AND EDIP.DB_EDIP_NRO = EPD.DB_EDIP_NRO 
                  AND EDIP.DB_EDIP_LOTE = EPD.DB_EDIP_LOTE)"VAN",
                
                ' ',
                
                ' ',           
                  
                   (SELECT distinct (COUNT(*))
                   FROM mercanet_prd.DB_EDI_PEDIDO  EDIP,
                        mercanet_prd.DB_EDI_PEDPROD EDII
                  WHERE EDIP.DB_EDIP_COMPRADOR = EDII.DB_EDII_COMPRADOR
                    AND EDIP.DB_EDIP_NRO = EDII.DB_EDII_NRO
                    AND EDIP.DB_EDIP_LOTE  = EPD.DB_EDIP_LOTE
                   /* AND NOT EXISTS
                  (SELECT *
                           FROM mercanet_prd.DB_EDI_PEDIDO EDIP2
                          WHERE EDIP.DB_EDIP_DTENVIO =
                                TO_DATE('31/12/9999 00:00:00',
                                        'DD/MM/YYYY HH24:MI:SS'))*/)"TOTAL DE PRODUTOS A PROCESSAR",

                DB_EDILD_DATA "DATA/HORA DE ENTRADA ARQ",
                                 
                (SELECT trim(to_char(trunc(((max(DB_PEDT_DTCOLET) - max(DB_EDILD_DATA)) *
                              86400 / 3600)),'09')) || ':' ||
                        trim(to_char(trunc(mod((max(DB_PEDT_DTCOLET) - max(DB_EDILD_DATA)) *
                                  86400,
                                  3600) / 60),'09')) || ':' ||
                         trim(to_char(trunc(mod(mod((max(DB_PEDT_DTCOLET) -
                                      max(DB_EDILD_DATA)) * 86400,
                                      3600),
                                  60)),'09'))
                   FROM mercanet_prd.DB_PEDIDO_DISTR     A,
                        mercanet_prd.DB_EDI_PEDIDO       B,
                        mercanet_prd.DB_PEDIDO           C,
                        mercanet_prd.INTERFACE_DB_PEDIDO D,
                        mercanet_prd.DB_EDI_LOTE_DISTR   E
                  WHERE B.DB_EDIP_PEDMERC = A.DB_PEDT_PEDIDO(+)
                    AND A.DB_PEDT_PEDIDO = C.DB_PED_NRO(+)
                    AND C.DB_PED_NRO = D.DB_PED_NRO(+)
                    AND E.DB_EDILD_SEQ = B.DB_EDIP_LOTE
                    AND DB_EDIP_LOTE = EPD.DB_EDIP_LOTE) as "TEMPO DE IMPORTAÇÃO"
                    
  FROM mercanet_prd.DB_EDI_LOTE_DISTR ELD,
       mercanet_prd.DB_EDI_PEDIDO     EPD,
       mercanet_prd.DB_EDI_PEDPROD    EPP
 WHERE DB_EDIP_LOTE = DB_EDILD_SEQ
   AND DB_EDIP_COMPRADOR = DB_EDII_COMPRADOR
   AND DB_EDIP_NRO = DB_EDII_NRO
   AND eld.db_edild_data  BETWEEN TO_DATE('08/04/2013 00:00:00','DD/MM/YYYY HH24:MI:SS')
                              AND TO_DATE('08/04/2013 23:59:00','DD/MM/YYYY HH24:MI:SS')
   AND EPD.DB_EDIP_VAN = 508
 GROUP BY ELD.DB_EDILD_NOMEARQ,
          EPD.DB_EDIP_COMPRADOR,
          EPD.DB_EDIP_NRO,
          EPD.DB_EDIP_LOTE,
          ELD.DB_EDILD_SEQ,
          DB_EDILD_DATA,
          DB_EDIP_PEDMERC
--ORDER BY DB_EDIP_LOTE
