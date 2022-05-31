select 1 as " ",
       'Produto Faturado' as "Rótulo de Linha",
       
       sum(nvl((select sum(pedidoprod2.db_pedi_qtde_solic)
                 from mercanet_qa.db_pedido_prod pedidoprod2
                where pedidoprod2.db_pedi_pedido =
                      pedidoprod.db_pedi_pedido
                  and pedidoprod2.db_pedi_sequencia =
                      pedidoprod.db_pedi_sequencia
                  and pedidoprod2.db_pedi_produto =
                      pedidoprod.db_pedi_produto
                  and pedidoprod2.db_pedi_situacao = 2),
               0)) as "Soma de Qtde Solicitada",
       
       sum(nvl((select sum(pedidoprod2.db_pedi_qtde_atend)
                 from mercanet_qa.db_pedido_prod pedidoprod2
                where pedidoprod2.db_pedi_pedido =
                      pedidoprod.db_pedi_pedido
                  and pedidoprod2.db_pedi_sequencia =
                      pedidoprod.db_pedi_sequencia
                  and pedidoprod2.db_pedi_produto =
                      pedidoprod.db_pedi_produto
                  and pedidoprod2.db_pedi_situacao = 2),
               0)) as "Soma de Qtde Atendida",
       
       round(sum(nvl((select sum(pedidoprod2.db_pedi_qtde_atend)
                       from mercanet_qa.db_pedido_prod pedidoprod2
                      where pedidoprod2.db_pedi_pedido =
                            pedidoprod.db_pedi_pedido
                        and pedidoprod2.db_pedi_sequencia =
                            pedidoprod.db_pedi_sequencia
                        and pedidoprod2.db_pedi_produto =
                            pedidoprod.db_pedi_produto
                        and pedidoprod2.db_pedi_situacao = 2),
                     0)) / (sum(edipedprod.db_edii_qtde_vda)) * 100,
             2) as "Representatividade (em %)"
  from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  edild,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cli,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cli.db_cli_cgcmf(+)
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and edild.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and not exists
 (select *
          from mercanet_qa.db_edi_pedido      edip2,
               mercanet_qa.db_edi_pedprod     edipedprod2,
               mercanet_qa.db_pedido_distr_it pedidodistrit2,
               mercanet_qa.db_pedido_prod     pedidoprod2,
               mercanet_qa.db_pedido_distr    pedidodistr
         where edip2.db_edip_comprador = edipedprod2.db_edii_comprador
           and edip2.db_edip_nro = edipedprod2.db_edii_nro
           and edipedprod2.db_edii_pedmerc =
               pedidodistrit2.db_pdit_pedido(+)
           and edipedprod2.db_edii_seq = pedidodistrit2.db_pdit_edii_seq(+)
           and pedidodistrit2.db_pdit_pedido = pedidoprod2.db_pedi_pedido(+)
           and pedidodistrit2.db_pdit_produto =
               pedidoprod2.db_pedi_produto(+)
           and edip2.db_edip_lote = edip.db_edip_lote
           and edip2.db_edip_pedmerc = pedidodistr.db_pedt_pedido(+)
           and pedidodistr.db_pedt_dtdisp is null
           and edip2.db_edip_pedmerc is not null)
   AND edild.db_edild_distr = 532

union
select 2,
       'Produto em Falta' as "Rótulo de Linha",
       
       sum(nvl((select sum(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador =
                      edipedprod.db_edii_comprador
                  and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
                  and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
                  and edipedprod2.db_edii_motivoret = '16M'),
               0)) as "Soma de Qtde Solicitada",
       
       0 as "Soma de Qtde Atendida",
       
       round(sum(nvl(((select sum(edipedprod2.db_edii_qtde_vda)
                         from mercanet_qa.db_edi_pedprod edipedprod2
                        where edipedprod2.db_edii_comprador =
                              edipedprod.db_edii_comprador
                          and edipedprod2.db_edii_nro =
                              edipedprod.db_edii_nro
                          and edipedprod2.db_edii_seq =
                              edipedprod.db_edii_seq
                          and edipedprod2.db_edii_motivoret = '16M')),
                     0)) / (sum(edipedprod.db_edii_qtde_vda)) * 100,
             2) as "Representatividade (em %)"

  from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  edild,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cli,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cli.db_cli_cgcmf(+)
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and edild.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and not exists
 (select *
          from mercanet_qa.db_edi_pedido      edip2,
               mercanet_qa.db_edi_pedprod     edipedprod2,
               mercanet_qa.db_pedido_distr_it pedidodistrit2,
               mercanet_qa.db_pedido_prod     pedidoprod2,
               mercanet_qa.db_pedido_distr    pedidodistr
         where edip2.db_edip_comprador = edipedprod2.db_edii_comprador
           and edip2.db_edip_nro = edipedprod2.db_edii_nro
           and edipedprod2.db_edii_pedmerc =
               pedidodistrit2.db_pdit_pedido(+)
           and edipedprod2.db_edii_seq = pedidodistrit2.db_pdit_edii_seq(+)
           and pedidodistrit2.db_pdit_pedido = pedidoprod2.db_pedi_pedido(+)
           and pedidodistrit2.db_pdit_produto =
               pedidoprod2.db_pedi_produto(+)
           and edip2.db_edip_lote = edip.db_edip_lote
           and edip2.db_edip_pedmerc = pedidodistr.db_pedt_pedido(+)
           and pedidodistr.db_pedt_dtdisp is null
           and edip2.db_edip_pedmerc is not null)
   AND edild.db_edild_distr = 532  
    
union
select 3,
       'Produto Atendido Parcialmente' as "Rótulo de Linha",
       
       sum(nvl((select sum(pedidoprod2.db_pedi_qtde_solic)
                 from mercanet_qa.db_pedido_prod pedidoprod2
                where pedidoprod2.db_pedi_pedido = pedidoprod.db_pedi_pedido
                  and pedidoprod2.db_pedi_sequencia = pedidoprod.db_pedi_sequencia
                  and pedidoprod2.db_pedi_produto = pedidoprod.db_pedi_produto
                  and pedidoprod2.db_pedi_situacao = 1),
               0)) as "Soma de Qtde Solicitada",
       
       sum(nvl((select sum(pedidoprod2.db_pedi_qtde_atend)
                 from mercanet_qa.db_pedido_prod pedidoprod2
                where pedidoprod2.db_pedi_pedido = pedidoprod.db_pedi_pedido
                  and pedidoprod2.db_pedi_sequencia = pedidoprod.db_pedi_sequencia
                  and pedidoprod2.db_pedi_produto = pedidoprod.db_pedi_produto
                  and pedidoprod2.db_pedi_situacao = 1),
               0)) as "Soma de Qtde Atendida",
               
       round(sum(nvl((select sum(pedidoprod2.db_pedi_qtde_solic)
                       from mercanet_qa.db_pedido_prod pedidoprod2
                      where pedidoprod2.db_pedi_pedido = pedidoprod.db_pedi_pedido
                        and pedidoprod2.db_pedi_sequencia =
                            pedidoprod.db_pedi_sequencia
                        and pedidoprod2.db_pedi_produto = pedidoprod.db_pedi_produto
                        and pedidoprod2.db_pedi_situacao = 1),
                     0)) / (sum(edipedprod.db_edii_qtde_vda)) * 100,

             2) as "Representatividade (em %)"
  from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  edild,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cli,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cli.db_cli_cgcmf(+)
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and edild.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and not exists
 (select *
          from mercanet_qa.db_edi_pedido      edip2,
               mercanet_qa.db_edi_pedprod     edipedprod2,
               mercanet_qa.db_pedido_distr_it pedidodistrit2,
               mercanet_qa.db_pedido_prod     pedidoprod2,
               mercanet_qa.db_pedido_distr    pedidodistr
         where edip2.db_edip_comprador = edipedprod2.db_edii_comprador
           and edip2.db_edip_nro = edipedprod2.db_edii_nro
           and edipedprod2.db_edii_pedmerc =
               pedidodistrit2.db_pdit_pedido(+)
           and edipedprod2.db_edii_seq = pedidodistrit2.db_pdit_edii_seq(+)
           and pedidodistrit2.db_pdit_pedido = pedidoprod2.db_pedi_pedido(+)
           and pedidodistrit2.db_pdit_produto =
               pedidoprod2.db_pedi_produto(+)
           and edip2.db_edip_lote = edip.db_edip_lote
           and edip2.db_edip_pedmerc = pedidodistr.db_pedt_pedido(+)
           and pedidodistr.db_pedt_dtdisp is null
           and edip2.db_edip_pedmerc is not null)
   AND edild.db_edild_distr = 532  
    
union
select 4,
       'Produto Descontinuado / Desativado' as "Rótulo de Linha",
       
       sum(nvl((select sum(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador = edipedprod.db_edii_comprador
                  and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
                  and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
                  and edipedprod2.db_edii_motivoret = '09M'
                  and exists
                (select *
                         from mercanet_qa.db_produto_embal codbarra,
                              mercanet_qa.db_produto       prod
                        where codbarra.db_prdemb_produto =
                              prod.db_prod_codigo
                          and codbarra.db_prdemb_codbarra =
                              edipedprod2.db_edii_produto)),
               0)) as "Soma de Qtde Solicitada",
       
       0 as "Soma de Qtde Atendida",
       
       round(sum(nvl((select sum(edipedprod2.db_edii_qtde_vda)
                       from mercanet_qa.db_edi_pedprod edipedprod2
                      where edipedprod2.db_edii_comprador =
                            edipedprod.db_edii_comprador
                        and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
                        and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
                        and edipedprod2.db_edii_motivoret = '09M'
                        and exists
                      (select *
                               from mercanet_qa.db_produto_embal codbarra,
                                    mercanet_qa.db_produto       prod
                              where codbarra.db_prdemb_produto =
                                    prod.db_prod_codigo
                                and codbarra.db_prdemb_codbarra =
                                    edipedprod2.db_edii_produto)),
                     0)) / (sum(edipedprod.db_edii_qtde_vda)) * 100,
             2) as "Representatividade (em %)"
  from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  edild,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cli,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cli.db_cli_cgcmf(+)
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and edild.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and not exists
 (select *
          from mercanet_qa.db_edi_pedido      edip2,
               mercanet_qa.db_edi_pedprod     edipedprod2,
               mercanet_qa.db_pedido_distr_it pedidodistrit2,
               mercanet_qa.db_pedido_prod     pedidoprod2,
               mercanet_qa.db_pedido_distr    pedidodistr
         where edip2.db_edip_comprador = edipedprod2.db_edii_comprador
           and edip2.db_edip_nro = edipedprod2.db_edii_nro
           and edipedprod2.db_edii_pedmerc =
               pedidodistrit2.db_pdit_pedido(+)
           and edipedprod2.db_edii_seq = pedidodistrit2.db_pdit_edii_seq(+)
           and pedidodistrit2.db_pdit_pedido = pedidoprod2.db_pedi_pedido(+)
           and pedidodistrit2.db_pdit_produto =
               pedidoprod2.db_pedi_produto(+)
           and edip2.db_edip_lote = edip.db_edip_lote
           and edip2.db_edip_pedmerc = pedidodistr.db_pedt_pedido(+)
           and pedidodistr.db_pedt_dtdisp is null
           and edip2.db_edip_pedmerc is not null)
   AND edild.db_edild_distr = 532  
   
union
select 5,
       'Produto não Cadastrado' as "Rótulo de Linha",
       
       sum(nvl((select sum(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador =
                      edipedprod.db_edii_comprador
                  and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
                  and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
                  and edipedprod2.db_edii_motivoret = '09M'
                  and not exists
                (select *
                         from mercanet_qa.db_produto_embal codbarra
                        where codbarra.db_prdemb_codbarra =
                              edipedprod2.db_edii_produto)),
               0)) as "Soma de Qtde Solicitada",
       
       0 as "Soma de Qtde Atendida",
       
       round(sum(nvl((select sum(edipedprod2.db_edii_qtde_vda)
                       from mercanet_qa.db_edi_pedprod edipedprod2
                      where edipedprod2.db_edii_comprador =
                            edipedprod.db_edii_comprador
                        and edipedprod2.db_edii_nro =
                            edipedprod.db_edii_nro
                        and edipedprod2.db_edii_seq =
                            edipedprod.db_edii_seq
                        and edipedprod2.db_edii_motivoret = '09M'
                        and not exists
                      (select *
                               from mercanet_qa.db_produto_embal codbarra
                              where codbarra.db_prdemb_codbarra =
                                    edipedprod2.db_edii_produto)),
                     0)) / (sum(edipedprod.db_edii_qtde_vda)) * 100,
                     
             2) as "Representatividade (em %)"
   from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  edild,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cli,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cli.db_cli_cgcmf(+)
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and edild.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and not exists
 (select *
          from mercanet_qa.db_edi_pedido      edip2,
               mercanet_qa.db_edi_pedprod     edipedprod2,
               mercanet_qa.db_pedido_distr_it pedidodistrit2,
               mercanet_qa.db_pedido_prod     pedidoprod2,
               mercanet_qa.db_pedido_distr    pedidodistr
         where edip2.db_edip_comprador = edipedprod2.db_edii_comprador
           and edip2.db_edip_nro = edipedprod2.db_edii_nro
           and edipedprod2.db_edii_pedmerc =
               pedidodistrit2.db_pdit_pedido(+)
           and edipedprod2.db_edii_seq = pedidodistrit2.db_pdit_edii_seq(+)
           and pedidodistrit2.db_pdit_pedido = pedidoprod2.db_pedi_pedido(+)
           and pedidodistrit2.db_pdit_produto =
               pedidoprod2.db_pedi_produto(+)
           and edip2.db_edip_lote = edip.db_edip_lote
           and edip2.db_edip_pedmerc = pedidodistr.db_pedt_pedido(+)
           and pedidodistr.db_pedt_dtdisp is null
           and edip2.db_edip_pedmerc is not null)
 AND edild.db_edild_distr = 532   
 
union
select 6,
       'Produto com preco errado' as "Rótulo de Linha",
       
       sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador =
                      edipedprod.db_edii_comprador
                  and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
                  and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
                  and edipedprod2.db_edii_motivoret = '05M'),
               0)) as "Soma de Qtde Solicitada",
       
       0 as "Soma de Qtde Atendida",
       
       round(sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                       from mercanet_qa.db_edi_pedprod edipedprod2
                      where edipedprod2.db_edii_comprador =
                            edipedprod.db_edii_comprador
                        and edipedprod2.db_edii_nro =
                            edipedprod.db_edii_nro
                        and edipedprod2.db_edii_seq =
                            edipedprod.db_edii_seq
                        and edipedprod2.db_edii_motivoret = '05M'),
                     0)) / (sum(edipedprod.db_edii_qtde_vda)) * 100,
             
             2) as "Representatividade (em %)"
  from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  edild,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cli,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cli.db_cli_cgcmf(+)
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and edild.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and not exists
 (select *
          from mercanet_qa.db_edi_pedido      edip2,
               mercanet_qa.db_edi_pedprod     edipedprod2,
               mercanet_qa.db_pedido_distr_it pedidodistrit2,
               mercanet_qa.db_pedido_prod     pedidoprod2,
               mercanet_qa.db_pedido_distr    pedidodistr
         where edip2.db_edip_comprador = edipedprod2.db_edii_comprador
           and edip2.db_edip_nro = edipedprod2.db_edii_nro
           and edipedprod2.db_edii_pedmerc =
               pedidodistrit2.db_pdit_pedido(+)
           and edipedprod2.db_edii_seq = pedidodistrit2.db_pdit_edii_seq(+)
           and pedidodistrit2.db_pdit_pedido = pedidoprod2.db_pedi_pedido(+)
           and pedidodistrit2.db_pdit_produto =
               pedidoprod2.db_pedi_produto(+)
           and edip2.db_edip_lote = edip.db_edip_lote
           and edip2.db_edip_pedmerc = pedidodistr.db_pedt_pedido(+)
           and pedidodistr.db_pedt_dtdisp is null
           and edip2.db_edip_pedmerc is not null)
   AND edild.db_edild_distr = 532
  
 
union       
select 7,
       'Produto Bloqueado' as "Rótulo de Linha",
       
       sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador =
                      edipedprod.db_edii_comprador
                  and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
                  and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
                  and edipedprod2.db_edii_motivoret = '02M'),
               0)) as "Soma de Qtde Solicitada",
       
       0 as "Soma de Qtde Atendida",
       
       round(sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                       from mercanet_qa.db_edi_pedprod edipedprod2
                      where edipedprod2.db_edii_comprador =
                            edipedprod.db_edii_comprador
                        and edipedprod2.db_edii_nro =
                            edipedprod.db_edii_nro
                        and edipedprod2.db_edii_seq =
                            edipedprod.db_edii_seq
                        and edipedprod2.db_edii_motivoret = '02M'),
                     0)) / (sum(edipedprod.db_edii_qtde_vda)) * 100,
             
             2) as "Representatividade (em %)"

  from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  edild,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cli,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cli.db_cli_cgcmf(+)
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and edild.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and not exists
 (select *
          from mercanet_qa.db_edi_pedido      edip2,
               mercanet_qa.db_edi_pedprod     edipedprod2,
               mercanet_qa.db_pedido_distr_it pedidodistrit2,
               mercanet_qa.db_pedido_prod     pedidoprod2,
               mercanet_qa.db_pedido_distr    pedidodistr
         where edip2.db_edip_comprador = edipedprod2.db_edii_comprador
           and edip2.db_edip_nro = edipedprod2.db_edii_nro
           and edipedprod2.db_edii_pedmerc =
               pedidodistrit2.db_pdit_pedido(+)
           and edipedprod2.db_edii_seq = pedidodistrit2.db_pdit_edii_seq(+)
           and pedidodistrit2.db_pdit_pedido = pedidoprod2.db_pedi_pedido(+)
           and pedidodistrit2.db_pdit_produto =
               pedidoprod2.db_pedi_produto(+)
           and edip2.db_edip_lote = edip.db_edip_lote
           and edip2.db_edip_pedmerc = pedidodistr.db_pedt_pedido(+)
           and pedidodistr.db_pedt_dtdisp is null
           and edip2.db_edip_pedmerc is not null)
   AND edild.db_edild_distr = 532
 
union
select 8,
       'Não Faturado : Cliente Bloq/Desativado/Não cadastrado' as "Rótulo de Linha",
       
       sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador =
                      edipedprod.db_edii_comprador
                  and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
                  and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
                  and edipedprod2.db_edii_motivoret = '18M'),
               0)) as "Soma de Qtde Solicitada",
       
       0 as "Soma de Qtde Atendida",
       
       round(sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
from mercanet_qa.db_edi_pedprod edipedprod2
                      where edipedprod2.db_edii_comprador =
                            edipedprod.db_edii_comprador
                        and edipedprod2.db_edii_nro =
                            edipedprod.db_edii_nro
                        and edipedprod2.db_edii_seq =
                            edipedprod.db_edii_seq
                        and edipedprod2.db_edii_motivoret = '18M'),
                     0)) / 
             (sum(edipedprod.db_edii_qtde_vda)) * 100,
             
             2) as "Representatividade (em %)"
   from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  edild,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cli,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cli.db_cli_cgcmf(+)
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and edild.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and not exists
 (select *
          from mercanet_qa.db_edi_pedido      edip2,
               mercanet_qa.db_edi_pedprod     edipedprod2,
               mercanet_qa.db_pedido_distr_it pedidodistrit2,
               mercanet_qa.db_pedido_prod     pedidoprod2,
               mercanet_qa.db_pedido_distr    pedidodistr
         where edip2.db_edip_comprador = edipedprod2.db_edii_comprador
           and edip2.db_edip_nro = edipedprod2.db_edii_nro
           and edipedprod2.db_edii_pedmerc =
               pedidodistrit2.db_pdit_pedido(+)
           and edipedprod2.db_edii_seq = pedidodistrit2.db_pdit_edii_seq(+)
           and pedidodistrit2.db_pdit_pedido = pedidoprod2.db_pedi_pedido(+)
           and pedidodistrit2.db_pdit_produto =
               pedidoprod2.db_pedi_produto(+)
           and edip2.db_edip_lote = edip.db_edip_lote
           and edip2.db_edip_pedmerc = pedidodistr.db_pedt_pedido(+)
           and pedidodistr.db_pedt_dtdisp is null
           and edip2.db_edip_pedmerc is not null)
 AND edild.db_edild_distr = 532 
 
         
union
select 9,
       'Não Faturado : Cliente Sem Limite de Crédito' as "Rótulo de Linha",
       
       sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador =
                      edipedprod.db_edii_comprador
                  and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
                  and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
                  and edipedprod2.db_edii_motivoret = '01M'),
               0)) as "Soma de Qtde Solicitada",
       
       0 as "Soma de Qtde Atendida",
       
       round(sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                       from mercanet_qa.db_edi_pedprod edipedprod2
                      where edipedprod2.db_edii_comprador =
                            edipedprod.db_edii_comprador
                        and edipedprod2.db_edii_nro =
                            edipedprod.db_edii_nro
                        and edipedprod2.db_edii_seq =
                            edipedprod.db_edii_seq
                        and edipedprod2.db_edii_motivoret = '01M'
                        ),
                     0)) /
             (sum(edipedprod.db_edii_qtde_vda)) * 100,
             
             2) as "Representatividade (em %)"
  from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  edild,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cli,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cli.db_cli_cgcmf(+)
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and edild.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and not exists
 (select *
          from mercanet_qa.db_edi_pedido      edip2,
               mercanet_qa.db_edi_pedprod     edipedprod2,
               mercanet_qa.db_pedido_distr_it pedidodistrit2,
               mercanet_qa.db_pedido_prod     pedidoprod2,
               mercanet_qa.db_pedido_distr    pedidodistr
         where edip2.db_edip_comprador = edipedprod2.db_edii_comprador
           and edip2.db_edip_nro = edipedprod2.db_edii_nro
           and edipedprod2.db_edii_pedmerc =
               pedidodistrit2.db_pdit_pedido(+)
           and edipedprod2.db_edii_seq = pedidodistrit2.db_pdit_edii_seq(+)
           and pedidodistrit2.db_pdit_pedido = pedidoprod2.db_pedi_pedido(+)
           and pedidodistrit2.db_pdit_produto =
               pedidoprod2.db_pedi_produto(+)
           and edip2.db_edip_lote = edip.db_edip_lote
           and edip2.db_edip_pedmerc = pedidodistr.db_pedt_pedido(+)
           and pedidodistr.db_pedt_dtdisp is null
           and edip2.db_edip_pedmerc is not null)
 AND edild.db_edild_distr = 532 
 
         
union 
select 10,
       'Não Faturado : Pedido Minimo' as "Rótulo de Linha",
       
       sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador =
                      edipedprod.db_edii_comprador
                  and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
                  and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
                  and edipedprod2.db_edii_motivoret = '22M'),
               0)) as "Soma de Qtde Solicitada",
       
       0 as "Soma de Qtde Atendida",
       
       round(sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                       from mercanet_qa.db_edi_pedprod edipedprod2
                      where edipedprod2.db_edii_comprador =
                            edipedprod.db_edii_comprador
                        and edipedprod2.db_edii_nro =
                            edipedprod.db_edii_nro
                        and edipedprod2.db_edii_seq =
                            edipedprod.db_edii_seq
                        and edipedprod2.db_edii_motivoret = '22M'),
                     0)) / (sum(edipedprod.db_edii_qtde_vda)) * 100,
             
             2) as "Representatividade (em %)"
  from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  edild,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cli,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cli.db_cli_cgcmf(+)
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and edild.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and not exists
 (select *
          from mercanet_qa.db_edi_pedido      edip2,
               mercanet_qa.db_edi_pedprod     edipedprod2,
               mercanet_qa.db_pedido_distr_it pedidodistrit2,
               mercanet_qa.db_pedido_prod     pedidoprod2,
               mercanet_qa.db_pedido_distr    pedidodistr
         where edip2.db_edip_comprador = edipedprod2.db_edii_comprador
           and edip2.db_edip_nro = edipedprod2.db_edii_nro
           and edipedprod2.db_edii_pedmerc =
               pedidodistrit2.db_pdit_pedido(+)
           and edipedprod2.db_edii_seq = pedidodistrit2.db_pdit_edii_seq(+)
           and pedidodistrit2.db_pdit_pedido = pedidoprod2.db_pedi_pedido(+)
           and pedidodistrit2.db_pdit_produto =
               pedidoprod2.db_pedi_produto(+)
           and edip2.db_edip_lote = edip.db_edip_lote
           and edip2.db_edip_pedmerc = pedidodistr.db_pedt_pedido(+)
           and pedidodistr.db_pedt_dtdisp is null
           and edip2.db_edip_pedmerc is not null)
   AND edild.db_edild_distr = 532
   
union 
select 11,
       'Não Faturado : Pedido Já Enviado' as "Rótulo de Linha",
       
       sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador =
                      edipedprod.db_edii_comprador
                  and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
                  and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
                  and edipedprod2.db_edii_motivoret = '27M' 
                  ),
               0)) as "Soma de Qtde Solicitada",
       
       0 as "Soma de Qtde Atendida",
       
       round(sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                       from mercanet_qa.db_edi_pedprod edipedprod2
                      where edipedprod2.db_edii_comprador =
                            edipedprod.db_edii_comprador
                        and edipedprod2.db_edii_nro =
                            edipedprod.db_edii_nro
                        and edipedprod2.db_edii_seq =
                            edipedprod.db_edii_seq
                        and edipedprod2.db_edii_motivoret = '27M'
                        ),
                     0)) /
             (sum(edipedprod.db_edii_qtde_vda)) * 100,
             2) as "Representatividade (em %)"
   from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  edild,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cli,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cli.db_cli_cgcmf(+)
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and edild.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and not exists
 (select *
          from mercanet_qa.db_edi_pedido      edip2,
               mercanet_qa.db_edi_pedprod     edipedprod2,
               mercanet_qa.db_pedido_distr_it pedidodistrit2,
               mercanet_qa.db_pedido_prod     pedidoprod2,
               mercanet_qa.db_pedido_distr    pedidodistr
         where edip2.db_edip_comprador = edipedprod2.db_edii_comprador
           and edip2.db_edip_nro = edipedprod2.db_edii_nro
           and edipedprod2.db_edii_pedmerc =
               pedidodistrit2.db_pdit_pedido(+)
           and edipedprod2.db_edii_seq = pedidodistrit2.db_pdit_edii_seq(+)
           and pedidodistrit2.db_pdit_pedido = pedidoprod2.db_pedi_pedido(+)
           and pedidodistrit2.db_pdit_produto =
               pedidoprod2.db_pedi_produto(+)
           and edip2.db_edip_lote = edip.db_edip_lote
           and edip2.db_edip_pedmerc = pedidodistr.db_pedt_pedido(+)
           and pedidodistr.db_pedt_dtdisp is null
           and edip2.db_edip_pedmerc is not null)
 AND edild.db_edild_distr = 532
  
union 
select 12,
       'Não Faturado : Cliente Sem Alvará/Vencido' as "Rótulo de Linha",
       
       sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador =
                      edipedprod.db_edii_comprador
                  and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
                  and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
                  and edipedprod2.db_edii_motivoret = '06M'
                  ),
               0)) as "Soma de Qtde Solicitada",
       
       0 as "Soma de Qtde Atendida",
       
       round(sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                       from mercanet_qa.db_edi_pedprod edipedprod2
                      where edipedprod2.db_edii_comprador =
                            edipedprod.db_edii_comprador
                        and edipedprod2.db_edii_nro =
                            edipedprod.db_edii_nro
                        and edipedprod2.db_edii_seq =
                            edipedprod.db_edii_seq
                        and edipedprod2.db_edii_motivoret = '06M'
                        ),
                     0)) /
             (sum(edipedprod.db_edii_qtde_vda)) * 100,
             
             2) as "Representatividade (em %)"
  from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  edild,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cli,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cli.db_cli_cgcmf(+)
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and edild.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and not exists
 (select *
          from mercanet_qa.db_edi_pedido      edip2,
               mercanet_qa.db_edi_pedprod     edipedprod2,
               mercanet_qa.db_pedido_distr_it pedidodistrit2,
               mercanet_qa.db_pedido_prod     pedidoprod2,
               mercanet_qa.db_pedido_distr    pedidodistr
         where edip2.db_edip_comprador = edipedprod2.db_edii_comprador
           and edip2.db_edip_nro = edipedprod2.db_edii_nro
           and edipedprod2.db_edii_pedmerc =
               pedidodistrit2.db_pdit_pedido(+)
           and edipedprod2.db_edii_seq = pedidodistrit2.db_pdit_edii_seq(+)
           and pedidodistrit2.db_pdit_pedido = pedidoprod2.db_pedi_pedido(+)
           and pedidodistrit2.db_pdit_produto =
               pedidoprod2.db_pedi_produto(+)
           and edip2.db_edip_lote = edip.db_edip_lote
           and edip2.db_edip_pedmerc = pedidodistr.db_pedt_pedido(+)
           and pedidodistr.db_pedt_dtdisp is null
           and edip2.db_edip_pedmerc is not null)
 AND edild.db_edild_distr = 532  
 
union 
select 13,
'Não Faturado : Motivo não Especificado' as "Rótulo de Linha",
       
       sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador =
                      edipedprod.db_edii_comprador
                  and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
                  and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
                  and edipedprod2.db_edii_motivoret = '97' 
                  ),
               0)) as "Soma de Qtde Solicitada",
       
       0 as "Soma de Qtde Atendida",
       
       round(sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                       from mercanet_qa.db_edi_pedprod edipedprod2
                      where edipedprod2.db_edii_comprador =
                            edipedprod.db_edii_comprador
                        and edipedprod2.db_edii_nro =
                            edipedprod.db_edii_nro
                        and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
                        and edipedprod2.db_edii_motivoret = '97'
                        ),
                     0)) /
             (sum(edipedprod.db_edii_qtde_vda)) * 100,
             
             2) as "Representatividade (em %)"
   from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  edild,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cli,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cli.db_cli_cgcmf(+)
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and edild.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and not exists
 (select *
          from mercanet_qa.db_edi_pedido      edip2,
               mercanet_qa.db_edi_pedprod     edipedprod2,
               mercanet_qa.db_pedido_distr_it pedidodistrit2,
               mercanet_qa.db_pedido_prod     pedidoprod2,
               mercanet_qa.db_pedido_distr    pedidodistr
         where edip2.db_edip_comprador = edipedprod2.db_edii_comprador
           and edip2.db_edip_nro = edipedprod2.db_edii_nro
           and edipedprod2.db_edii_pedmerc =
               pedidodistrit2.db_pdit_pedido(+)
           and edipedprod2.db_edii_seq = pedidodistrit2.db_pdit_edii_seq(+)
           and pedidodistrit2.db_pdit_pedido = pedidoprod2.db_pedi_pedido(+)
           and pedidodistrit2.db_pdit_produto =
               pedidoprod2.db_pedi_produto(+)
           and edip2.db_edip_lote = edip.db_edip_lote
           and edip2.db_edip_pedmerc = pedidodistr.db_pedt_pedido(+)
           and pedidodistr.db_pedt_dtdisp is null
           and edip2.db_edip_pedmerc is not null)
 AND edild.db_edild_distr = 532   
   
union
select 14,
       'Total Geral' as "Rótulo de Linha",
       sum(edipedprod.db_edii_qtde_vda) as "Soma de Qtde Solicitada",
       sum(nvl(pedidoprod.db_pedi_qtde_atend, 0)) as "Soma de Qtde Atendida",
       100.00 as "Representatividade (em %)"

   from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  edild,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cli,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cli.db_cli_cgcmf(+)
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and edild.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and not exists
 (select *
          from mercanet_qa.db_edi_pedido      edip2,
               mercanet_qa.db_edi_pedprod     edipedprod2,
               mercanet_qa.db_pedido_distr_it pedidodistrit2,
               mercanet_qa.db_pedido_prod     pedidoprod2,
               mercanet_qa.db_pedido_distr    pedidodistr
         where edip2.db_edip_comprador = edipedprod2.db_edii_comprador
           and edip2.db_edip_nro = edipedprod2.db_edii_nro
           and edipedprod2.db_edii_pedmerc =
               pedidodistrit2.db_pdit_pedido(+)
           and edipedprod2.db_edii_seq = pedidodistrit2.db_pdit_edii_seq(+)
           and pedidodistrit2.db_pdit_pedido = pedidoprod2.db_pedi_pedido(+)
           and pedidodistrit2.db_pdit_produto =
               pedidoprod2.db_pedi_produto(+)
           and edip2.db_edip_lote = edip.db_edip_lote
           and edip2.db_edip_pedmerc = pedidodistr.db_pedt_pedido(+)
           and pedidodistr.db_pedt_dtdisp is null
           and edip2.db_edip_pedmerc is not null)
 AND edild.db_edild_distr = 532 
 
         