UPDATE MERCANET_PRD.DB_PEDIDO_PROD
SET DB_PEDI_QTDE_CANC = DB_PEDI_QTDE_SOLIC, 
  DB_PEDI_QTDE_ATEND = 0,
  DB_PEDI_PRECO_UNIT = 0,
  DB_PEDI_PRECO_LIQ = 0,
  DB_PEDI_PREV_ENTR = NULL,
  DB_PEDI_SITUACAO = 9 ,
  DB_PEDI_VLR_SUBST = 0,
  DB_PEDI_SITCORP1 = NULL,
	DB_PEDI_SITCORP2 = NULL
WHERE DB_PEDI_PEDIDO  = -- NUMERO DO PEDIDO MERCANET; 

UPDATE MERCANET_PRD.DB_PEDIDO
SET DB_PED_DT_PREVENT = NULL,
	DB_PED_SITUACAO = 9,
	DB_PED_NRO_ORIG = 'CANCEL',
	DB_PED_SITCORP = 9
WHERE DB_PED_NRO  =  -- NUMERO DO PEDIDO MERCANET; 

UPDATE MERCANET_PRD.DB_PEDIDO_DISTR_IT
SET DB_PDIT_QTDEATD = 0,
    DB_PDIT_MOTIVORET = '14' 
WHERE DB_PDIT_PEDIDO = -- NUMERO DO PEDIDO MERCANET; 

UPDATE MERCANET_PRD.DB_EDI_PEDPROD
SET DB_EDII_MOTIVORET = '14' 
WHERE DB_EDII_PEDMERC =  -- NUMERO DO PEDIDO MERCANET; 


