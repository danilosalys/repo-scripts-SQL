--Notas Sem detalhe
select *
  from mercanet_prd.db_nota_fiscal
 where not exists (select *
          from mercanet_prd.db_nota_prod
         where db_nota_nro = db_notap_nro
           and db_nota_serie = db_notap_serie
           and db_nota_empresa = db_notap_empresa)
   and exists (select *
          from mercanet_prd.db_edi_pedido, mercanet_prd.mem01
         where db_nota_ped_merc = db_edip_pedmerc
           and db_edip_van = em01_codigo
           and em01_larqnf is not null
           and db_edip_projeto not in ('LAB'))
   and not exists (select *
          from mercanet_prd.db_edi_pedido,
               mercanet_prd.mem01,
               mercanet_prd.db_edi_log_exp
         where db_nota_ped_merc = db_edip_pedmerc
           and db_edip_van = em01_codigo
           and em01_larqnf is not null
           and db_edip_nro = db_edile_edip_nro
           and db_edip_comprador = db_edile_edip_comp
           and em01_larqnf = db_edile_edia_codi
           and db_edile_arquivo is not null)
   and not exists (select *
          from mercanet_prd.db_edi_pedido,
               mercanet_prd.mem01,
               mercanet_prd.db_edi_log_exp_hist
         where db_nota_ped_merc = db_edip_pedmerc
           and db_edip_van = em01_codigo
           and em01_larqnf is not null
           and db_edip_nro = db_edile_edip_nro
           and db_edip_comprador = db_edile_edip_comp
           and em01_larqnf = db_edile_edia_codi
           and db_edile_arquivo is not null)
   and db_nota_fatur = 0;
