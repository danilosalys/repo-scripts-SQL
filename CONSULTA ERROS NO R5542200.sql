
--QUERY RETORNA A SITUA�AO DOS PEDIDOS QUE FORAM RETORNADOS DO JDE 

SELECT DB_EDIP_VAN,
       DB_PED_NRO,       
       DB_PEDI_PRODUTO,
       DB_PEDI_QTDE_SOLIC,
       DB_PEDI_QTDE_ATEND,
       DB_PEDI_QTDE_CANC,
       DB_EDII_PRODUTO,
       DB_PED_SITUACAO,
       CASE
         WHEN DB_PED_SITUACAO = 0 THEN
          'LIBERADO'
         ELSE
          CASE
         WHEN DB_PED_SITUACAO = 1 THEN
          'BLOQUEADO'
         ELSE
          CASE
         WHEN DB_PED_SITUACAO = 2 THEN
          'FATURADO PARCIAL'
         ELSE
          'CANCELADO'
       END END END "SITUACAO DO PEDIDO" ,
       DB_PED_SITCORP,
       CASE
         WHEN DB_PED_SITCORP = 0 THEN
          'LIBERADO'
         ELSE
          CASE
         WHEN DB_PED_SITCORP = 1 THEN
          'BLOQUEADO MN'
         ELSE
          CASE
         WHEN DB_PED_SITCORP = 2 THEN
          'BLOQUEADO C2'
         ELSE
          CASE
         WHEN DB_PED_SITCORP = 3 THEN
          'FATURADO PARCIAL'
         ELSE
          CASE
         WHEN DB_PED_SITCORP = 5 THEN
          'CANCEL BLOQ DO CLIENTE'
         ELSE
          ''
       END END END END END "SITUACAO NO JDE ",
       DB_PEDI_SITUACAO,
       CASE
         WHEN DB_PEDI_SITUACAO = 0 THEN
          'LIBERADO'
         ELSE
          CASE
         WHEN DB_PEDI_SITUACAO = 1 THEN
          'FATURADO PARCIAL'
         ELSE
          CASE
         WHEN DB_PEDI_SITUACAO = 2 THEN
          'FATURADO'
         ELSE
          'CANCELADO'
       END END END "SITUACAO DO ITEM",
       DB_PEDI_SITCORP1,
       DB_PEDI_SITCORP2
  FROM DB_PEDIDO,
       DB_PEDIDO_PROD,
       DB_PEDIDO_DISTR,
       DB_PEDIDO_DISTR_IT,
       DB_EDI_PEDIDO,
       DB_EDI_PEDPROD
 WHERE DB_PED_NRO = DB_PEDI_PEDIDO
   AND DB_PED_NRO = DB_PEDT_PEDIDO
   AND DB_PEDT_PEDIDO = DB_PDIT_PEDIDO
   AND DB_PEDT_PEDIDO = DB_EDIP_PEDMERC
   AND DB_EDIP_NRO = DB_EDII_NRO
   AND DB_EDIP_COMPRADOR = DB_EDII_COMPRADOR
   AND DB_PEDI_PEDIDO = DB_PDIT_PEDIDO
   AND DB_PEDI_PRODUTO = DB_PDIT_PRODUTO
   AND DB_PDIT_PEDIDO = DB_EDII_PEDMERC
   AND DB_PDIT_EDII_SEQ = DB_EDII_SEQ
   AND DB_PEDT_DTDISP IS NOT NULL
   AND DB_PED_NRO  IN ('80161905', '80161877', '80161755', '80161853',
        '80161852', '80161871', '80161917', '80161762',
        '80161749', '80161939', '80161924', '80161904')
   GROUP BY DB_PED_NRO,
            DB_EDIP_VAN,
            DB_PEDI_PRODUTO,
            DB_EDII_PRODUTO,
            DB_PED_SITUACAO,
            DB_PEDI_SITCORP1,
            DB_PEDI_SITCORP2,
            DB_PED_SITCORP,
            DB_PEDI_SITUACAO,
            DB_PEDI_QTDE_SOLIC,
            DB_PEDI_QTDE_ATEND,
            DB_PEDI_QTDE_CANC