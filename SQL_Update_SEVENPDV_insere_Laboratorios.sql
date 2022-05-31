/*

begin 
update  db_edi_pedido set db_edip_labcod = '34'
where db_edip_pedmerc in ('80011884',
  '80011885')
and db_edip_lab  = '30';
update db_pedido_compl set db_pedc_lab= 33 where db_pedc_nro in  ('80011886',
  '80011887',
  '80011888')
end;



*/


  select db_edip_pedmerc ,db_edip_lab,db_edip_labcod, a.* from db_edi_pedido a
  where db_edip_pedmerc in ('80011884',
  '80011885',
  '80011886',
  '80011887',
  '80011888')
and db_edip_lab = '24'
; 

select db_pedc_lab , db_pedc_nro ,a.* 
from  db_pedido_compl a
 where db_pedc_nro in('80011884',
  '80011886',
  '80011886',
  '80011887',
  '80011888')
