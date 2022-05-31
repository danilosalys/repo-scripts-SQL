select db_edii_pedmerc, db_prod_codigo, db_edii_produto,db_edii_qtde_vda
  from db_edi_pedprod a, db_produto b
 where db_edii_pedmerc = '80011506'
   and a.db_edii_produto = b.db_prod_cod_barra ; 
   
   SELECT DB_PROD_CODIGO, DB_PROD_COD_BARRA , COUNT(1) FROM INTERFACE_DB_PRODUTO
   WHERE DB_PROD_CODIGO IN ('28054',
'27840',
'12489')
GROUP BY DB_PROD_CODIGO, DB_PROD_COD_BARRA 
   