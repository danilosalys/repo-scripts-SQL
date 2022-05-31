SELECT *
  FROM (select DB_NOTA_NRO,
               DB_NOTA_SERIE,
               DB_NOTA_EMPRESA,
               DB_NOTA_PED_MERC,
               ROUND(SUM(nvl(((SELECT max(DB_PEDI_PRECO_UNIT)
                                 FROM mercanet_PRD.DB_PEDIDO_PROD tab1
                                WHERE TAB1.DB_PEDI_PEDIDO =
                                      DB_NOTA_FISCAL.DB_NOTA_PED_MERC
                                  AND tab1.DB_PEDI_PRODUTO =
                                      DB_NOTA_PROD.DB_NOTAP_PRODUTO) *
                             db_nota_prod.db_notap_qtde),
                             0)),
                     2) AS "SOMA PRECO BRUTO TOTAL ",
               SUM(NVL(DB_NOTAP_VALOR, 0) + NVL(DB_NOTAP_INCENTIVO, 0)) AS "SOMA PRECO LIQ TOTAL + DESC",
               NVL((DB_NOTA_VLR_PROD), 0) AS "VLR TOTAL DOS PRODUTOS TRAILER",
               SUM(NVL(DB_NOTAP_VALOR, 0) + NVL(DB_NOTAP_VLR_SUBST, 0)) AS "SOMA PRECO LIQ TOTAL",
               NVL((db_nota_vlr_total), 0) AS "VALOR TOTAL DA NOTA",
               NVL((DB_NOTA_VLR_PROD), 0)+(nvl((select SUM(NFPROD1.DB_NOTAP_VLR_SUBST)
                      from mercanet_PRD.db_nota_prod nfprod1
                     where nfprod1.db_notap_nro = db_nota_nro
                       and nfprod1.db_notap_serie = db_nota_serie
                       and nfprod1.db_notap_empresa = db_nota_empresa),
                    0)) -
               (nvl((select SUM(NFPROD1.DB_NOTAP_INCENTIVO)
                      from mercanet_PRD.db_nota_prod nfprod1
                     where nfprod1.db_notap_nro = db_nota_nro
                       and nfprod1.db_notap_serie = db_nota_serie
                       and nfprod1.db_notap_empresa = db_nota_empresa),
                    0)) AS "TOTOL PROD - DESC = VLR TOT NF", 
                    (nvl((select SUM(NFPROD1.DB_NOTAP_INCENTIVO)
                      from mercanet_PRD.db_nota_prod nfprod1
                     where nfprod1.db_notap_nro = db_nota_nro
                       and nfprod1.db_notap_serie = db_nota_serie
                       and nfprod1.db_notap_empresa = db_nota_empresa),
                    0)) "DESCONTO"
        
          from mercanet_PRD.DB_NOTA_FISCAL, MERCANET_PRD.DB_NOTA_PROD
         WHERE DB_NOTA_NRO = DB_NOTAP_NRO
           AND DB_NOTA_SERIE = DB_NOTAP_SERIE
           AND DB_NOTA_EMPRESA = DB_NOTAP_EMPRESA
           AND EXISTS
         (SELECT *
                  FROM MERCANET_PRD.DB_EDI_PEDIDO,
                       MERCANET_PRD.DB_EDI_LOTE_DISTR
                 WHERE DB_EDIP_LOTE = DB_EDILD_SEQ
                   AND DB_NOTA_PED_MERC = DB_EDIP_PEDMERC
                   AND DB_EDIP_VAN = 531
                   AND DB_EDILD_DATA >
                       TO_DATE('24/04/2013 00:00:00', 'DD/MM/YYYY HH24:MI:SS'))
           AND DB_NOTA_DT_ENVIO >
               TO_DATE('26/04/2013 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
         GROUP BY DB_NOTA_NRO,
                  DB_NOTA_SERIE,
                  DB_NOTA_EMPRESA,
                  DB_NOTA_PED_MERC,
                  db_nota_vlr_total,
                  DB_NOTA_VLR_PROD)
 WHERE "TOTOL PROD - DESC = VLR TOT NF" <> "VALOR TOTAL DA NOTA"
  --"SOMA PRECO LIQ TOTAL + DESC" <> "VLR TOTAL DOS PRODUTOS TRAILER"
 UNION 
 
 SELECT *
  FROM (select DB_NOTA_NRO,
               DB_NOTA_SERIE,
               DB_NOTA_EMPRESA,
               DB_NOTA_PED_MERC,
               ROUND(SUM(nvl(((SELECT max(DB_PEDI_PRECO_UNIT)
                                 FROM mercanet_PRD.DB_PEDIDO_PROD tab1
                                WHERE TAB1.DB_PEDI_PEDIDO =
                                      DB_NOTA_FISCAL.DB_NOTA_PED_MERC
                                  AND tab1.DB_PEDI_PRODUTO =
                                      DB_NOTA_PROD.DB_NOTAP_PRODUTO) *
                             db_nota_prod.db_notap_qtde),
                             0)),
                     2) AS "SOMA PRECO BRUTO TOTAL ",
               SUM(NVL(DB_NOTAP_VALOR, 0) + NVL(DB_NOTAP_INCENTIVO, 0)) AS "SOMA PRECO LIQ TOTAL + DESC",
               NVL((DB_NOTA_VLR_PROD), 0) AS "VLR TOTAL DOS PRODUTOS TRAILER",
               SUM(NVL(DB_NOTAP_VALOR, 0) + NVL(DB_NOTAP_VLR_SUBST, 0)) AS "SOMA PRECO LIQ TOTAL",
               NVL((db_nota_vlr_total), 0) AS "VALOR TOTAL DA NOTA",
               NVL((DB_NOTA_VLR_PROD), 0) -
               (nvl((select SUM(NFPROD1.DB_NOTAP_INCENTIVO)
                      from mercanet_PRD.db_nota_prod nfprod1
                     where nfprod1.db_notap_nro = db_nota_nro
                       and nfprod1.db_notap_serie = db_nota_serie
                       and nfprod1.db_notap_empresa = db_nota_empresa),
                    0)) AS "TOTOL PROD - DESC = VLR TOT NF",
                    (nvl((select SUM(NFPROD1.DB_NOTAP_INCENTIVO)
                      from mercanet_PRD.db_nota_prod nfprod1
                     where nfprod1.db_notap_nro = db_nota_nro
                       and nfprod1.db_notap_serie = db_nota_serie
                       and nfprod1.db_notap_empresa = db_nota_empresa),
                    0)) "DESCONTO"
        
          from mercanet_PRD.DB_NOTA_FISCAL, MERCANET_PRD.DB_NOTA_PROD
         WHERE DB_NOTA_NRO = DB_NOTAP_NRO
           AND DB_NOTA_SERIE = DB_NOTAP_SERIE
           AND DB_NOTA_EMPRESA = DB_NOTAP_EMPRESA
           AND EXISTS
         (SELECT *
                  FROM MERCANET_PRD.DB_EDI_PEDIDO,
                       MERCANET_PRD.DB_EDI_LOTE_DISTR
                 WHERE DB_EDIP_LOTE = DB_EDILD_SEQ
                   AND DB_NOTA_PED_MERC = DB_EDIP_PEDMERC
                   AND DB_EDIP_VAN = 531
                   AND DB_EDILD_DATA >
                       TO_DATE('24/04/2013 00:00:00', 'DD/MM/YYYY HH24:MI:SS'))
           AND DB_NOTA_DT_ENVIO >
               TO_DATE('26/04/2013 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
         GROUP BY DB_NOTA_NRO,
                  DB_NOTA_SERIE,
                  DB_NOTA_EMPRESA,
                  DB_NOTA_PED_MERC,
                  db_nota_vlr_total,
                  DB_NOTA_VLR_PROD)
 WHERE "SOMA PRECO LIQ TOTAL + DESC" <> "VLR TOTAL DOS PRODUTOS TRAILER"
