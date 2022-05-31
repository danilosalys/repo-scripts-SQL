select * from mercanet_prd.db_produto_embal 
where db_prdemb_codbarra in ('7896026301640','7896026300186','7896026300315','7896026303194','7795304000179',
                             '7896026303095','7896026300322','7896026300476','7896026305594','7896026301879','7896026300469')
--Não existem
7896026301640
7795304000179
7896026300322
7896026300476
7896026301879

--estão cadastrados
select db_edii_produto,
       max(db_edii_motivoret),
       max(db_edip_nro),
       max(db_edild_nomearq),
       max(db_edild_data)
  from (select distinct b.db_edii_produto,
                        b.db_edii_motivoret,
                        a.db_edip_nro,
                        c.db_edild_nomearq,
                        c.db_edild_data
          from mercanet_prd.db_edi_pedido     a,
               mercanet_prd.db_edi_pedprod    b,
               mercanet_prd.db_edi_lote_distr c
         where b.db_edii_comprador = a.db_edip_comprador
           and b.db_edii_nro = a.db_edip_nro
           and b.db_edii_produto in ('7795304000179','7896026300322','7896026300476',
                                     '7896026301640','7896026301879')
           and a.db_edip_van = 506
           and b.db_edii_motivoret = '05'
           and a.db_edip_lote = c.db_edild_seq
         group by b.db_edii_produto,b.db_edii_produto,b.db_edii_motivoret,
                  a.db_edip_lote,a.db_edip_nro,c.db_edild_nomearq,c.db_edild_data)
group by db_edii_produto; 



