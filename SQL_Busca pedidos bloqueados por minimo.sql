--BUSCA OS PEDIDOS BLOQUEADOS POR MINIMO E O VALOR COM DESCONTO
select A.DB_EDIP_VAN,
       H.DB_LAB_DESCRICAO,
       A.DB_EDIP_COMPRADOR,
       D.DB_CLI_NOME, 
       A.DB_EDIP_EMPRESA,
       A.DB_EDIP_NRO,       
       SUM(C.DB_EDII_QTDE_VDA * G.DB_PRECOP_VALOR ) VALOR,    
       C.DB_EDII_PERC_DCTO PERC_DESCONTO,
       CASE WHEN (C.DB_EDII_PERC_DCTO > 0) THEN
          SUM(C.DB_EDII_QTDE_VDA * G.DB_PRECOP_VALOR ) - (SUM(C.DB_EDII_QTDE_VDA * G.DB_PRECOP_VALOR ) * C.DB_EDII_PERC_DCTO)/100
       ELSE SUM(C.DB_EDII_QTDE_VDA * G.DB_PRECOP_VALOR ) 
       END AS VALOR_COM_DESCONTO            
  from DB_EDI_PEDIDO     A, 
       DB_EDI_LDISTR_LOG B, 
       DB_EDI_PEDPROD    C,
       DB_CLIENTE        D, 
       DB_CLIENTE_REPRES E,
       DB_PRODUTO_EMBAL  F,
       DB_PRECO_PROD     G,
       DB_LABORATORIO    H
 where A.db_edip_dt_emissao   =  '22/11/2011'
   and A.db_edip_pedmerc         is null
   --AND A.DB_EDIP_NRO        =  '7348683'    --NUMERO PEDIDO CLIENTE
   AND A.DB_EDIP_LOTE         >   1136        --NUMERO DO LOTE
   AND A.DB_EDIP_LOTE         =   B.DB_EDILL_SEQ_LOTE
   AND B.DB_EDILL_TXTLOG          LIKE '%999%'--COD LOG 999 = BLOQ VALOR MINIMO
   AND A.DB_EDIP_NRO          =   C.DB_EDII_NRO   
   AND D.DB_CLI_CGCMF         =   A.DB_EDIP_COMPRADOR
   AND D.DB_CLI_CODIGO        =   E.DB_CLIR_CLIENTE
   AND E.DB_CLIR_EMPRESA      =   A.DB_EDIP_EMPRESA
   AND F.DB_PRDEMB_CODBARRA   =   C.DB_EDII_PRODUTO
   AND F.DB_PRDEMB_PRODUTO    =   G.DB_PRECOP_PRODUTO
   AND E.DB_CLIR_LPRECO       =   G.DB_PRECOP_CODIGO
   AND E.DB_CLIR_TPPROD       IS NULL
   AND A.DB_EDIP_LABCOD       = H.DB_LAB_CODIGO
GROUP BY A.DB_EDIP_VAN, H.DB_LAB_DESCRICAO,A.DB_EDIP_COMPRADOR,D.DB_CLI_NOME,A.DB_EDIP_EMPRESA,A.DB_EDIP_NRO, C.DB_EDII_PERC_DCTO