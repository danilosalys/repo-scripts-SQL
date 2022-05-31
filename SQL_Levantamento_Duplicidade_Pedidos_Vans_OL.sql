SELECT A.DB_EDILD_SEQ,
       A.DB_EDILD_DATA,
       A.DB_EDILD_LAYOUT,
       A.DB_EDILD_NOMEARQ,
       B.DB_EDIP_COMPRADOR,
       B.DB_EDIP_NRO,
       B.DB_EDIP_PEDMERC,
       B.DB_EDIP_PROJETO,
       B.DB_EDIP_DTENVIO,
       C.DB_NOTA_NRO,
       C.DB_NOTA_SERIE,
       C.DB_NOTA_DT_ENVIO,
       C.DB_NOTA_VLR_TOTAL
  FROM MERCANET_PRD.DB_EDI_LOTE_DISTR A,
       (SELECT T1.*
          FROM MERCANET_PRD.DB_EDI_PEDIDO     T1,
               MERCANET_PRD.DB_EDI_LOTE_DISTR T2
         WHERE DB_EDIP_NRO LIKE '%D'
           AND (DB_EDIP_NRO, DB_EDILD_NOMEARQ) IN
               (SELECT DB_EDIP_NRO || 'D', DB_EDILD_NOMEARQ
                  FROM MERCANET_PRD.DB_EDI_PEDIDO,
                       MERCANET_PRD.DB_EDI_LOTE_DISTR
                 WHERE (DB_EDIP_NRO, DB_EDILD_NOMEARQ) IN
                       (SELECT REPLACE(DB_EDIP_NRO, 'D', NULL),
                               DB_EDILD_NOMEARQ
                          FROM MERCANET_PRD.DB_EDI_PEDIDO,
                               MERCANET_PRD.DB_EDI_LOTE_DISTR
                         WHERE DB_EDIP_NRO LIKE '%D'
                           AND DB_EDIP_LOTE = DB_EDILD_SEQ)
                   AND DB_EDIP_LOTE = DB_EDILD_SEQ
                   AND EXISTS (SELECT *
                          FROM MERCANET_PRD.DB_PEDIDO
                         WHERE DB_PED_NRO = DB_EDIP_PEDMERC
                           AND DB_PED_SITUACAO <> 9)
                   AND EXISTS
                 (SELECT *
                          FROM MERCANET_PRD.DB_NOTA_FISCAL
                         WHERE DB_EDIP_PEDMERC = DB_NOTA_PED_MERC))
           AND DB_EDIP_LOTE = DB_EDILD_SEQ
        UNION ALL
        SELECT T1.*
          FROM MERCANET_PRD.DB_EDI_PEDIDO     T1,
               MERCANET_PRD.DB_EDI_LOTE_DISTR T2
         WHERE (DB_EDIP_NRO, DB_EDILD_NOMEARQ) IN
               (SELECT REPLACE(DB_EDIP_NRO, 'D', NULL), DB_EDILD_NOMEARQ
                  FROM MERCANET_PRD.DB_EDI_PEDIDO,
                       MERCANET_PRD.DB_EDI_LOTE_DISTR
                 WHERE DB_EDIP_NRO LIKE '%D'
                   AND DB_EDIP_LOTE = DB_EDILD_SEQ)
           AND DB_EDIP_LOTE = DB_EDILD_SEQ
           AND EXISTS (SELECT *
                  FROM MERCANET_PRD.DB_PEDIDO
                 WHERE DB_PED_NRO = DB_EDIP_PEDMERC
                   AND DB_PED_SITUACAO <> 9)
           AND EXISTS
         (SELECT *
                  FROM MERCANET_PRD.DB_NOTA_FISCAL
                 WHERE DB_EDIP_PEDMERC = DB_NOTA_PED_MERC)) B,
       MERCANET_PRD.DB_NOTA_FISCAL C
 WHERE DB_EDIP_LOTE = DB_EDILD_SEQ
   AND DB_EDIP_PEDMERC = DB_NOTA_PED_MERC(+)
   AND DB_NOTA_FATUR(+) <> '3'
 ORDER BY DB_EDIP_VAN, DB_EDIP_NRO;
