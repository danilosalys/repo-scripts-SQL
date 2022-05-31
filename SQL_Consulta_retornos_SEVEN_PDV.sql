SELECT T3.DB_EDILD_NOMEARQ AS ARQUIVO_SP, 
       TRUNC(T1.DB_EDIP_OBS1) AS NUMERO_ARQ_SP,
       TO_CHAR(SUBSTR(T3.DB_EDILD_CONTEUDO,INSTR(T3.DB_EDILD_CONTEUDO,T1.DB_EDIP_COMPRADOR||LPAD(T2.DB_EDII_PRODUTO,13,'0'),1,1),62)) AS CONTEUDO_LINHA_ARQ_SP,      
       T1.DB_EDIP_DT_EMISSAO AS DATA_ARQUIVO_SP,
       T2.DB_EDII_COMPRADOR AS CNPJ_CLIENTE,
       T2.DB_EDII_PRODUTO AS EAN_PRODUTO,
       T1.DB_EDIP_CLIENTE AS FILIAL_DCENTER,
       T2.DB_EDII_PROJETO AS CODIGO_ADM,
       T4.DB_EDILE_ARQUIVO AS "ARQUIVO_RP.DAT",
       --T4.DB_EDILE_EDIA_CODI,
       TO_CHAR(SUBSTR(T4.DB_EDILE_CONTEUDO,INSTR(T4.DB_EDILE_CONTEUDO,T1.DB_EDIP_COMPRADOR||LPAD(T2.DB_EDII_PRODUTO,13,'0'),1,1),62))  AS "LINHA_ARQ_RP.DAT"
      -- INSTR(T3.DB_EDILD_CONTEUDO,T1.DB_EDIP_COMPRADOR||LPAD(T2.DB_EDII_PRODUTO,13,'0'),1,1),
  FROM MERCANET_PRD.DB_EDI_PEDIDO T1,
       MERCANET_PRD.DB_EDI_PEDPROD T2,
       MERCANET_PRD.DB_EDI_LOTE_DISTR T3,
       MERCANET_PRD.DB_EDI_LOG_EXP T4,
       DSALES.PENDENCIA_SEVENPDV T5
 WHERE T1.DB_EDIP_VAN = 508
   AND T1.DB_EDIP_COMPRADOR = T2.DB_EDII_COMPRADOR
   AND T1.DB_EDIP_NRO = T2.DB_EDII_NRO
   --AND DB_EDIP_COMPRADOR = '02328312000154'
   --AND T1.DB_EDIP_DT_EMISSAO = '01/02/2020'
   AND T1.DB_EDIP_LOTE = T3.DB_EDILD_SEQ
   AND T1.DB_EDIP_COMPRADOR = T4.DB_EDILE_EDIP_COMP
   AND T1.DB_EDIP_NRO = T4.DB_EDILE_EDIP_NRO
   AND T1.DB_EDIP_COMPRADOR = T5.DB_EDIP_COMPRADOR
   AND T1.DB_EDIP_OBS1 = '0'||T5.DB_EDIP_OBS1
   AND T1.DB_EDIP_CLIENTE = T5.DB_EDIP_CLIENTE
   AND T2.DB_EDII_PRODUTO = T5.DB_EDII_PRODUTO
   AND T2.DB_EDII_COMPRADOR = T5.DB_EDIP_COMPRADOR
   AND T1.DB_EDIP_DT_EMISSAO = T5.DB_EDIP_DT_EMISSAO
   AND T4.DB_EDILE_EDIA_CODI = 'SEVENPDV_NOT'
ORDER BY T1.DB_EDIP_OBS1, T1.DB_EDIP_CLIENTE, T2.DB_EDII_COMPRADOR ,T2.DB_EDII_PRODUTO
