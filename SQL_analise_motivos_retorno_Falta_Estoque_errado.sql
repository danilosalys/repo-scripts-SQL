select a.db_edip_lote,
       a.db_edip_comprador,
       a.db_edip_nro,
       b.db_edii_produto,
       b.db_edii_qtde_vda,
       b.db_edii_motivoret,
       e.db_pdit_motivoret,
       f.db_ped_sitcorp,
       case
         when db_ped_sitcorp = 0 then
          'Liberado'
         else
          case
         when db_ped_sitcorp = 1 then
          'Bloqueado MN'
         else
          case
         when db_ped_sitcorp = 2 then
          'Bloqueado C2'
         else
          case
         when db_ped_sitcorp = 3 then
          'Faturado Parcial'
         else
          case
         when db_ped_sitcorp = 5 then
          'Cancel Bloq do Cliente'
         else
          'Cancelado'
       end end end end end Sitcorp,
       f.db_ped_situacao,
       g.db_pedi_situacao,
       case
         when db_pedi_situacao = 0 then
          'Liberado'
         else
          case
         when db_pedi_situacao = 1 then
          'Faturado Parcial'
         else
          case
         when db_pedi_situacao = 2 then
          'Faturado'
         else
          'Cancelado'
       end end end Descr_pedi_situacao,
       g.db_pedi_motcanc,
       g.db_pedi_sitcorp1,
       g.db_pedi_sitcorp2,
       
  from mercanet_prd.db_edi_pedido      a,
       mercanet_prd.db_edi_pedprod     b,
       mercanet_prd.mem05              c,
       mercanet_prd.db_pedido_distr    d,
       mercanet_prd.db_pedido_distr_it e,
       mercanet_prd.db_pedido          f,
       mercanet_prd.db_pedido_prod     g
 where a.db_edip_van = c.em05_distr
   and c.em05_situacao = 10
   and b.db_edii_motivoret = c.em05_motivo          --cabs
   and a.db_edip_pedmerc = d.db_pedt_pedido         --cabs
   and d.db_pedt_pedido = f.db_ped_nro              --cabs
   and a.db_edip_comprador = b.db_edii_comprador    ---cab x det
   and a.db_edip_nro = b.db_edii_nro                ---cab x det
   and d.db_pedt_pedido = e.db_pdit_pedido          ---cab x det
   and f.db_ped_nro = g.db_pedi_pedido              ---cab x det
   and b.db_edii_pedmerc = e.db_pdit_pedido         ----det x det
   and b.db_edii_seq = e.db_pdit_edii_seq           ----det x det
   and e.db_pdit_pedi_ped = g.db_pedi_pedido        ----det x det
   and e.db_pdit_pedi_seq = g.db_pedi_sequencia     ----det x det
   and a.db_edip_pedmerc = 82684165
