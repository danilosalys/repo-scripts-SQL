select distinct   a.* , b.* , c.* , d.*
from db_edi_lote_distr a, db_edi_pedido b, db_edi_pedprod c , db_pedido_distr d
where a.db_edild_nomearq = 'PHL5005651966000455_20110304194246.txt'
and a.db_edild_seq = b.db_edip_lote (+);


select distinct   a.* , b.* , c.*
from db_edi_lote_distr a, db_edi_pedido b, db_edi_pedprod c
where db_edild_nomearq = 'PHL7005651966000102_20110131195508.txt'
and a.db_edild_seq = b.db_edip_lote (+)
and b.db_edip_comprador = c.db_edii_comprador (+)
and b.db_edip_nro = c.db_edii_nro (+) ;

/*select * from db_pedido_distr;
select * from db_edi_pedprod;
select * from   db_edi_pedido	;
select * from  db_edi_lote_distr	;*/
select * from db_pedido_distr_it;			
			
				