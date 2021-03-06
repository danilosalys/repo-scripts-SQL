/* EXECUTAR A SQL SOMENTE SE O PEDIDO FOI ATENDIDO PARCIALMENTE NO JDE. 
   VERIFICAR O ITEM CORRETO A SER CANCELADO
*/ 

UPDATE MERCANET_PRD.DB_PEDIDO_PROD
SET DB_PEDI_QTDE_CANC = DB_PEDI_QTDE_SOLIC, 
  DB_PEDI_QTDE_ATEND = 0,
  DB_PEDI_PRECO_UNIT = 0,
  DB_PEDI_PRECO_LIQ = 0,
  DB_PEDI_PREV_ENTR = NULL,
  DB_PEDI_SITUACAO = 9 ,
  DB_PEDI_VLR_SUBST = 0,
  DB_PEDI_SITCORP1 = '980',
  DB_PEDI_SITCORP2 = '999',
  DB_PEDI_FLOAT2= 0
WHERE DB_PEDI_PEDIDO  = --INFORMAR O NUMERO DO PEDIDO MERCANET
AND DB_PEDI_PRODUTO IN ()--INFORMAR O(S) CODIGO(S) DO(S) PRODUTO(S); 

UPDATE MERCANET_PRD.DB_PEDIDO
SET DB_PED_SITUACAO = 2,
    DB_PED_SITCORP = 3
WHERE DB_PED_NRO  =  -- NUMERO DO PEDIDO MERCANET; 

UPDATE MERCANET_PRD.DB_PEDIDO_DISTR_IT
SET DB_PDIT_QTDEATD = 0,
    DB_PDIT_MOTIVORET = '400' 
WHERE DB_PDIT_PEDIDO = -- NUMERO DO PEDIDO MERCANET
  AND DB_PDIT_PRODUTO IN ()--INFORMAR O(S) CODIGO(S) DO(S) PRODUTO(S); 

UPDATE MERCANET_PRD.DB_EDI_PEDPROD
SET DB_EDII_MOTIVORET = '400' 
WHERE DB_EDII_PEDMERC =  -- NUMERO DO PEDIDO MERCANET
  AND DB_EDII_PRODUTO IN() --INFORMAR O(S) CODIGO(S) DE BARRA DO(S) PRODUTO(S); 
