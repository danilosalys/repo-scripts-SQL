
WITH TESTE AS ( 
SELECT DISTINCT  DB_EDIP_PEDMERC,
                   DB_EDII_COMPRADOR , DB_EDII_NRO , DB_TBFAM_CODIGO
 FROM MERCANET_PRD.DB_PEDIDO,
       MERCANET_PRD.DB_PEDIDO_PROD,
       MERCANET_PRD.DB_EDI_PEDIDO,
       MERCANET_PRD.DB_EDI_PEDPROD,
       MERCANET_PRD.DB_PEDIDO_DISTR_IT,
       MERCANET_PRD.MEM01,
       MERCANET_PRD.DB_EDI_LOTE_DISTR, 
       MERCANET_PRD.DB_PRODUTO,
       MERCANET_PRD.DB_TB_FAMILIA
WHERE DB_PED_NRO = DB_PEDI_PEDIDO
   AND DB_PED_SITUACAO NOT IN (2, 4)
   AND DB_PED_SITCORP NOT IN ('0', '3', '4')
   AND DB_PEDI_SITUACAO NOT IN (0, 1, 2)
   AND DB_PEDI_ATD_DCTO IS NOT NULL
   AND DB_PED_NRO = DB_EDIP_PEDMERC
   AND DB_EDIP_VAN = EM01_CODIGO
   AND DB_EDIP_LOTE = DB_EDILD_SEQ
   AND DB_PEDI_PRODUTO = DB_PROD_CODIGO 
   AND DB_PROD_FAMILIA = DB_TBFAM_CODIGO
   AND DB_EDII_NRO = DB_EDIP_NRO
   AND DB_EDII_COMPRADOR = DB_EDIP_COMPRADOR 
   AND DB_EDII_PEDMERC = DB_PDIT_PEDIDO 
   AND DB_EDII_SEQ = DB_PDIT_EDII_SEQ 
   AND DB_PDIT_PEDIDO = DB_PEDI_PEDIDO 
   AND DB_PDIT_PRODUTO = DB_PEDI_PRODUTO
   AND DB_PED_NRO   IN( 80863721,80010256,80010378) )
SELECT  DB_EDIP_PEDMERC,
                   DB_EDII_COMPRADOR , DB_EDII_NRO
                   , RTRIM (XMLAGG (XMLELEMENT (E,TRIM( DB_TBFAM_CODIGO) || ',')).EXTRACT ('//text()'), ',') enames
FROM  TESTE
GROUP  BY DB_EDIP_PEDMERC,    DB_EDII_COMPRADOR , DB_EDII_NRO 