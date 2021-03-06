  
SELECT DISTINCT DB_EDIP_LOTE ,DB_EDILD_NOMEARQ, 'COPY /Y  '||DB_EDILE_ARQUIVO||'  "\\SRVDC40\Mercanet\edi\OL\fidelize";', DB_EDILE_EDIA_CODI 
  FROM MERCANET_PRD.DB_EDI_LOG_EXP, MERCANET_PRD.DB_EDI_PEDIDO, MERCANET_PRD.db_edi_lote_distr
 WHERE DB_EDIP_NRO IN ('0000007784','0000007781','0000007759','0000007690','0000007691','0000007684','0000007578',
                       '0000007576','0000007575','0000007574','0000007573','0000007563','0000007548','0000007545',
                       '0000007514','0000007515','0000007444','0000007443')
  AND DB_EDIP_NRO = DB_EDILE_EDIP_NRO
   AND DB_EDIP_COMPRADOR = DB_EDILE_EDIP_COMP
   AND DB_EDIP_LOTE = DB_EDILD_SEQ
   AND DB_EDILE_EDIA_CODI LIKE '%PED%'
   GROUP BY DB_EDIP_LOTE,DB_EDILD_NOMEARQ, DB_EDILE_ARQUIVO,DB_EDILE_EDIA_CODI
   ORDER BY DB_EDIP_LOTE 
