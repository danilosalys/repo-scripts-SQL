

SELECT A.DB_EDIP_LOTE,
       D.DB_EDILD_NOMEARQ,
       A.DB_EDIP_PROJETO,
       A.DB_EDIP_LABCOD,
       D.DB_EDILD_DATA,
       A.DB_EDIP_NRO,
       A.DB_EDIP_PEDMERC   
  FROM DB_EDI_PEDIDO A, DB_EDI_LOTE_DISTR D
 WHERE D.DB_EDILD_DATA BETWEEN
       TO_DATE('06/02/12 00:00:00', 'DD/MM/YY HH24:MI:SS') AND
       TO_DATE('06/02/12 23:59:59', 'DD/MM/YY HH24:MI:SS')
   AND DB_EDIP_LOTE = DB_EDILD_SEQ
   ORDER BY DB_EDILD_DATA ASC
   
  