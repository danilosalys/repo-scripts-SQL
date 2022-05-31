SELECT TIPO_PROBLEMA,
       "COMANDO DOS P/ REENVIO ARQ",
       DB_EDILD_DATA,
       DB_EDILD_NOMEARQ,
       DB_EDILD_CONTEUDO,
       DB_EDILD_SEQ,
       DB_EDIP_PEDMERC,
       DB_EDIP_DTENVIO
  FROM (SELECT 'pedido travado' as TIPO_PROBLEMA,
               'COPY /Y ' ||
               (SELECT REPLACE(EM01_PASTABKP,
                               'D:',
                               CASE
                                 WHEN T1.DB_EDILD_DISTR IN (501,
                                                            502,
                                                            503,
                                                            504,
                                                            505,
                                                            508,
                                                            513,
                                                            521,
                                                            517,
                                                            530) THEN
                                  '\\srvdc43'
                                 ELSE
                                  '\\srvdc40'
                               END)
                  FROM MERCANET_PRD.MEM01
                 WHERE T1.DB_EDILD_DISTR = EM01_CODIGO) || '\' ||
               T1.DB_EDILD_NOMEARQ || ' C:\temp;' AS "COMANDO DOS P/ REENVIO ARQ",
               T1.*,
               T2.*
          FROM MERCANET_PRD.DB_EDI_LOTE_DISTR T1,
               MERCANET_PRD.DB_EDI_PEDIDO     T2
         WHERE T1.DB_EDILD_SEQ = T2.DB_EDIP_LOTE
           AND T1.DB_EDILD_DATA BETWEEN SYSDATE - 5 AND SYSDATE - 0.01
           AND T2.DB_EDIP_DTENVIO = '31/12/9999'
        UNION ALL
        SELECT 'sem pedido compl', 
               'COPY /Y ' ||
               (SELECT REPLACE(EM01_PASTAbkp,
                               'D:',
                               CASE
                                 WHEN T1.DB_EDILD_DISTR IN (501,
                                                            502,
                                                            503,
                                                            504,
                                                            505,
                                                            508,
                                                            513,
                                                            521,
                                                            517,
                                                            530) THEN
                                  '\\srvdc43'
                                 ELSE
                                  '\\srvdc40'
                               END)
                  FROM MERCANET_PRD.MEM01
                 WHERE T1.DB_EDILD_DISTR = EM01_CODIGO) || '\' ||
               T1.DB_EDILD_NOMEARQ || ' C:\temp;' AS "COMANDO DOS P/ REENVIO ARQ",
               T1.*,
               T2.*
          FROM MERCANET_PRD.DB_EDI_LOTE_DISTR T1,
               MERCANET_PRD.DB_EDI_PEDIDO     T2,
               MERCANET_PRD.DB_PEDIDO         T3
         WHERE T1.DB_EDILD_SEQ = T2.DB_EDIP_LOTE
           AND T2.DB_EDIP_PEDMERC = T3.DB_PED_NRO
           AND T1.DB_EDILD_DATA BETWEEN SYSDATE - 5 AND SYSDATE - 0.01
           AND NOT EXISTS (SELECT *
                  FROM MERCANET_PRD.DB_PEDIDO_COMPL
                 WHERE DB_PEDC_NRO = T3.DB_PED_NRO)
        UNION ALL
        SELECT  'sem detalhe', 
                'COPY /Y ' ||
               (SELECT REPLACE(EM01_PASTABKP,
                               'D:',
                               CASE
                                 WHEN T1.DB_EDILD_DISTR IN (501,
                                                            502,
                                                            503,
                                                            504,
                                                            505,
                                                            508,
                                                            513,
                                                            521,
                                                            517,
                                                            530) THEN
                                  '\\srvdc43'
                                 ELSE
                                  '\\srvdc40'
                               END)
                  FROM MERCANET_PRD.MEM01
                 WHERE T1.DB_EDILD_DISTR = EM01_CODIGO) || '\' ||
               T1.DB_EDILD_NOMEARQ || ' C:\temp;' AS "COMANDO DOS P/ REENVIO ARQ",
               T1.*,
               T2.*
          FROM MERCANET_PRD.DB_EDI_LOTE_DISTR T1,
               MERCANET_PRD.DB_EDI_PEDIDO     T2
         WHERE T1.DB_EDILD_SEQ = T2.DB_EDIP_LOTE
           AND T1.DB_EDILD_DATA BETWEEN SYSDATE - 5 AND SYSDATE - 0.01
           AND NOT EXISTS
         (SELECT *
                  FROM MERCANET_PRD.DB_EDI_PEDPROD
                 WHERE T2.DB_EDIP_NRO = DB_EDII_NRO
                   AND T2.DB_EDIP_COMPRADOR = DB_EDII_COMPRADOR));

