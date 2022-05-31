select db_edild_seq ,db_edip_comprador , db_edip_nro , db_edild_distr, db_edild_situacao , db_edild_data , db_edild_layout, db_edild_nomearq , db_edild_conteudo
from mercanet_prd.db_edi_pedido , mercanet_prd.db_edi_lote_distr 
where db_edip_lote = db_edild_seq 
and db_edip_dtenvio = to_date('31/12/9999 00:00:00','dd/mm/yyyy hh24:mi:ss')
and db_edild_data between to_date('11/12/2012 00:00:00','dd/mm/yyyy hh24:mi:ss')                     
                      and to_date('14/12/2012 23:59:00','dd/mm/yyyy hh24:mi:ss')
and db_edild_situacao=0
order by db_edild_data