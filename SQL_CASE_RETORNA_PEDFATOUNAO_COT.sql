SELECT CASE
         WHEN (SELECT COUNT(*)
                 FROM DB_PEDIDO, DB_PEDIDO_DISTR 
                WHERE DB_PED_NRO = DB_EDIP_PEDMERC
                  AND DB_PED_SITUACAO IN (0,2)
                  AND DB_PED_SITCORP IN ('0','3')
                  AND DB_PED_NRO = DB_PEDT_PEDIDO
                  AND DB_PEDT_DTDISP IS NOT NULL) >= 1 
         THEN
          'S'
         ELSE
          'N'
       END
  FROM DB_EDI_PEDIDO
  WHERE DB_EDIP_PEDMERC  = '80052945'