
SELECT trunc(((max(DB_PEDT_DTCOLET) - max(DB_EDILD_DATA)) * 86400 / 3600)) || ':' ||
       trunc(mod((max(DB_PEDT_DTCOLET) - max(DB_EDILD_DATA)) * 86400, 3600) / 60) || ':' ||
       trunc(mod(mod((max(DB_PEDT_DTCOLET) - max(DB_EDILD_DATA)) * 86400,
                     3600),
                 60)) as "TEMPO DE IMPORTAÇÃO"
  FROM mercanet_qa.DB_PEDIDO_DISTR     A,
       mercanet_qa.DB_EDI_PEDIDO       B,
       mercanet_qa.DB_PEDIDO           C,
       mercanet_qa.INTERFACE_DB_PEDIDO D,
       mercanet_qa.DB_EDI_LOTE_DISTR   E
 WHERE B.DB_EDIP_PEDMERC = A.DB_PEDT_PEDIDO(+)
   AND A.DB_PEDT_PEDIDO = C.DB_PED_NRO(+)
   AND C.DB_PED_NRO = D.DB_PED_NRO(+)
   AND E.DB_EDILD_SEQ = B.DB_EDIP_LOTE
   AND DB_EDIP_LOTE = 90534;
