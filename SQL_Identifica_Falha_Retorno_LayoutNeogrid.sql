SELECT db_edip_pedmerc,
       db_edii_comprador,
       db_edii_produto,
       to_char(substr(db_edile_conteudo,
                      -- Identificando a posicao inicial do substring
                      instr(db_edile_conteudo, db_edii_produto, 1, 1) - 18,
                      -- Identificando a quantidade de caracteres do substring (posfim - posini)
                      (instr(db_edile_conteudo,
                             chr(10),
                             instr(db_edile_conteudo, chr(10) || '04', 1, 1) + 1,
                             1) - 1) -
                      (instr(db_edile_conteudo, chr(10) || '04', 1, 1) + 1))) AS Linha_com_problema,
       db_edile_conteudo
  FROM MERCANET_PRD.DB_EDI_PEDIDO,
       MERCANET_PRD.DB_EDI_PEDPROD,
       MERCANET_PRD.DB_EDI_LOG_EXP
 WHERE DB_EDIP_NRO = DB_EDII_NRO
   AND DB_EDIP_COMPRADOR = DB_EDII_COMPRADOR
   AND DB_EDIP_NRO = DB_EDILE_EDIP_NRO
   AND DB_EDIP_COMPRADOR = DB_EDILE_EDIP_COMP
   AND DB_EDIP_VAN = 510
   AND DB_EDIP_DT_EMISSAO = '20/10/2015'
   AND DB_EDILE_EDIA_CODI = 'VIALIVRE_PED'
   AND (instr(db_edile_conteudo,
              chr(10),
              instr(db_edile_conteudo, db_edii_produto, 1, 1) - 18,
              1)) - (instr(db_edile_conteudo, db_edii_produto, 1, 1) - 18) < 260
