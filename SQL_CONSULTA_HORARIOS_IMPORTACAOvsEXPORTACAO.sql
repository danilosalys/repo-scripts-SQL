
SELECT DB_PEDT_PEDIDO,
       DB_EDIP_NRO,
       DB_EDILD_DATA,
       DB_PEDT_DTIMP,
       DB_PEDT_DTCOLET,
       DB_EDIP_DTENVIO,
       DATA_INCLUSAO,
       DB_PEDT_DTDISP,
       DB_PEDT_DTRET,
       DB_EDIP_DTENVIO
  FROM DB_PEDIDO_DISTR     A,
       DB_EDI_PEDIDO       B,
       DB_PEDIDO           C,
       INTERFACE_DB_PEDIDO D,
       DB_EDI_LOTE_DISTR   E
 WHERE B.DB_EDIP_PEDMERC = A.DB_PEDT_PEDIDO(+)
   AND A.DB_PEDT_PEDIDO = C.DB_PED_NRO(+)
   AND C.DB_PED_NRO = D.DB_PED_NRO(+)
   AND E.DB_EDILD_SEQ = B.DB_EDIP_LOTE
   AND DB_EDIP_LOTE = 84051
ORDER BY DB_EDIP_NRO 