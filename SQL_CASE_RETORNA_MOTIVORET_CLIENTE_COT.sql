SELECT CASE
         WHEN (SELECT COUNT(*)
                 FROM DB_CLIENTE
                WHERE DB_CLI_CGCMF = DB_EDIP_COMPRADOR) = 0
         THEN
          '5'
         ELSE
        CASE
         WHEN (SELECT COUNT(*)
                 FROM DB_PEDIDO, DB_PEDIDO_DISTR 
                WHERE DB_PED_NRO = DB_EDIP_PEDMERC
                  AND DB_PED_SITUACAO  = 9
                  AND DB_PED_SITCORP = '1'
                  AND DB_PED_NRO = DB_PEDT_PEDIDO
                  AND DB_PEDT_DTDISP IS NOT NULL) = 1 
         THEN
          '4'
         ELSE
        CASE
         WHEN (SELECT COUNT(*)
                 FROM DB_PEDIDO, DB_PEDIDO_DISTR 
                WHERE DB_PED_NRO = DB_EDIP_PEDMERC
                  AND DB_PED_SITUACAO  = 9
                  AND DB_PED_SITCORP = '2'
                  AND DB_PED_NRO = DB_PEDT_PEDIDO
                  AND DB_PEDT_DTDISP IS NOT NULL) = 1 
         THEN
          '3'
          ELSE
        CASE
         WHEN (SELECT COUNT(*)
                 FROM DB_PEDIDO, DB_PEDIDO_DISTR 
                WHERE DB_PED_NRO = DB_EDIP_PEDMERC
                  AND DB_PED_SITUACAO  = 9
                  AND DB_PED_SITCORP = '9'
                  AND DB_PED_NRO = DB_PEDT_PEDIDO
                  AND DB_PEDT_DTDISP IS NOT NULL) = 1 
         THEN
          '2' 
          ELSE ''
       END END END END
  FROM DB_EDI_PEDIDO
  WHERE DB_EDIP_PEDMERC  = '80052811'