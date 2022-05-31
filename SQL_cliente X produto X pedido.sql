select distinct db_cli_codigo , db_cli_cgcmf , db_cli_cidade, db_prod_codigo , db_prdemb_codbarra
  from mercanet_prd.db_cliente,
       mercanet_prd.db_cliente_atrib,
       mercanet_prd.db_edi_pedido,
       mercanet_prd.db_pedido,
       mercanet_prd.db_produto,
       mercanet_prd.db_produto_atrib,
       mercanet_prd.db_pedido_prod,
       mercanet_prd.db_produto_embal
 where db_cli_codigo = db_clia_codigo
   and db_clia_atrib = 1033
   and db_clia_valor = '21:30'
   and db_cli_cgcmf = db_edip_comprador
   and db_edip_van = 505
   and db_edip_projeto = 'GSK'
   and db_edip_pedmerc = db_ped_nro 
   and db_ped_nro = db_pedi_pedido 
   and db_pedi_produto = db_prod_codigo
   and db_prdemb_produto = db_prod_codigo
   and db_prdemb_codemb = 1
   and db_prod_codigo = db_proda_codigo 
   and db_proda_atrib = 2009 
   and db_proda_valor = 'DEPHPC'
   and db_pedi_qtde_atend > 0
  
