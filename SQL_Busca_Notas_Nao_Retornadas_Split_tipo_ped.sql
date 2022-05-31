select distinct db_edip_pedmerc, db_pedi_atd_dcto, db_ped_nro_orig, db_edip_van , db_edip_dt_emissao
 from mercanet_prd.db_edi_pedido, mercanet_prd.db_pedido_prod, mercanet_prd.db_pedido
where db_edip_pedmerc = db_pedi_pedido 
and db_edip_pedmerc = db_ped_nro 
--and db_edip_van = 508
and db_edip_dt_emissao > '01/02/2014'
and db_pedi_situacao <> 9
and db_pedi_atd_dcto is null 
and exists (select * from mercanet_prd.db_nota_fiscal 
            where db_edip_pedmerc = db_nota_ped_merc) 
and exists (select * from mercanet_prd.mem01
             where em01_codigo = db_edip_van 
               and em01_larqnf is not null)
and db_edip_projeto not in ('LAB', 'EUR')

