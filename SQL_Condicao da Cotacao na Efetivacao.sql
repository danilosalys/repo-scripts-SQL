select (select pedcot.db_ped_cond_pgto
          from mercanet_prd.db_pedido     pedcot,
               mercanet_prd.db_edi_pedido edicot,
               mercanet_prd.mem01         vancot,
               mercanet_prd.db_edi_pedido ediefe,
               mercanet_prd.mem01         vanefe
         where ediefe.db_edip_van = vanefe.em01_codigo
           and vanefe.em01_tppedido = 'VP'
           and edicot.db_edip_van = vancot.em01_codigo
           and vancot.em01_tppedido = 'VC'
           and edicot.db_edip_pedmerc = pedcot.db_ped_nro
           and edicot.db_edip_obs1 = ediefe.db_edip_obs1
           and ediefe.db_edip_pedmerc = a.db_ped_nro)
  from mercanet_prd.db_pedido a
 where db_ped_nro in () --NUMERO DO PEDIDO DE EFETIVAÇÃO
