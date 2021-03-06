SELECT DB_EDIP_DT_EMISSAO, 
       DB_EDIP_LOTE,
       DB_EDIP_NRO,
       DB_EDIP_PEDMERC, 
       DB_EDII_PRODUTO, 
       DB_PRDEMB_PRODUTO,
       DB_PROD_DESCRICAO,
       DB_EDII_MOTIVORET,
       TO_CHAR(SUBSTR(DB_EDILE_CONTEUDO,INSTR(DB_EDILE_CONTEUDO,';',INSTR(DB_EDILE_CONTEUDO,DB_EDII_PRODUTO),5)+1,3)) AS MOTIVO_ARQUIVO,
       DB_EDILE_CONTEUDO
  FROM MERCANET_PRD.DB_EDI_PEDPROD, 
       MERCANET_PRD.DB_EDI_PEDIDO,
       MERCANET_PRD.DB_CLIENTE, 
       MERCANET_PRD.DB_CLIENTE_ATRIB,
       MERCANET_PRD.DB_EDI_LOG_EXP,
       MERCANET_PRD.DB_PRODUTO_EMBAL,
       MERCANET_PRD.DB_PRODUTO
 WHERE DB_EDII_COMPRADOR = DB_EDIP_COMPRADOR
   AND DB_EDII_NRO = DB_EDIP_NRO 
   AND DB_EDIP_VAN = 517 
   AND DB_EDIP_COMPRADOR = DB_CLI_CGCMF 
   AND DB_CLI_CODIGO = DB_CLIA_CODIGO
   AND DB_EDIP_NRO = DB_EDILE_EDIP_NRO
   AND DB_EDIP_COMPRADOR = DB_EDILE_EDIP_COMP
   AND DB_EDII_PRODUTO = DB_PRDEMB_CODBARRA
   AND DB_PRDEMB_PRODUTO = DB_PROD_CODIGO 
   AND DB_EDILE_EDIA_CODI = 'FIDELIZE_PD2'
   AND DB_CLIA_ATRIB = 1005
   AND DB_CLIA_VALOR = 'DRO'
   --AND DB_EDIP_DT_EMISSAO > '23/01/2018'
   AND TO_CHAR(SUBSTR(DB_EDILE_CONTEUDO,INSTR(DB_EDILE_CONTEUDO,';',INSTR(DB_EDILE_CONTEUDO,DB_EDII_PRODUTO),5)+1,3)) = '201'
   --AND DB_EDII_MOTIVORET <> TO_CHAR(SUBSTR(DB_EDILE_CONTEUDO,INSTR(DB_EDILE_CONTEUDO,';',INSTR(DB_EDILE_CONTEUDO,DB_EDII_PRODUTO),5)+1,3))
   AND DB_EDIP_PEDMERC IN (89235188)

