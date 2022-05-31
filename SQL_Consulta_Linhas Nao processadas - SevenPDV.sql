-- mostra quantidade de linhas que ainda n�o foram processadas (arquivos da SevenPDV)
select distinct db_edip_lote,        
                TO_NUMBER(substr(C.db_edild_nomearq,39,6))||' linhas' "TOTAL DE LINHAS DO ARQUIVO",
                count(*) || ' linhas' "FALTA PROCESSAR"
  from db_edi_pedido A, db_edi_pedprod B, db_edi_lote_distr C
 where A.db_edip_comprador = B.db_edii_comprador
   and A.db_edip_nro = B.db_edii_nro
   and A.db_edip_lote = 331701
   and A.db_edip_dtenvio is not null
   and A.db_edip_dtenvio = '31/12/9999'
   and A.db_edip_lote = C.db_edild_seq
  group by A.db_edip_lote, c.db_edild_nomearq
