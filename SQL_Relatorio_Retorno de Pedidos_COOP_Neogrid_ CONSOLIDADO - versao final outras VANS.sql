select 1 as " ",
       'Produto Faturado' as "R�tulo de Linha",
       
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
       mercanet_qa.db_edi_lote_distr  lotedistr,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cliente,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cliente.db_cli_cgcmf
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and lotedistr.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and edip.db_edip_van = 532
          
union
select 2,
       'Produto em Falta' as "R�tulo de Linha",
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
       mercanet_qa.db_edi_lote_distr  lotedistr,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cliente,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cliente.db_cli_cgcmf
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and lotedistr.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and edip.db_edip_van = 532
    
union
select 3,
       'Produto Atendido Parcialmente' as "R�tulo de Linha",
       sum(nvl((select sum(pedidoprod2.db_pedi_qtde_solic)
                 from mercanet_qa.db_pedido_prod pedidoprod2
                where pedidoprod2.db_pedi_pedido =
                      pedidoprod.db_pedi_pedido
                  and pedidoprod2.db_pedi_sequencia =
                      pedidoprod.db_pedi_sequencia
                  and pedidoprod2.db_pedi_produto =
                      pedidoprod.db_pedi_produto
                  and pedidoprod2.db_pedi_situacao = 1),
               0)) as "Soma de Qtde Solicitada",
       
       sum(nvl((select sum(pedidoprod2.db_pedi_qtde_atend)
                 from mercanet_qa.db_pedido_prod pedidoprod2
                where pedidoprod2.db_pedi_pedido =
                      pedidoprod.db_pedi_pedido
                  and pedidoprod2.db_pedi_sequencia =
                      pedidoprod.db_pedi_sequencia
                  and pedidoprod2.db_pedi_produto =
                      pedidoprod.db_pedi_produto
                  and pedidoprod2.db_pedi_situacao = 1),
               0)) as "Soma de Qtde Atendida",
       round(sum(nvl((select sum(pedidoprod2.db_pedi_qtde_atend)
                       from mercanet_qa.db_pedido_prod pedidoprod2
                      where pedidoprod2.db_pedi_pedido =
                            pedidoprod.db_pedi_pedido
                        and pedidoprod2.db_pedi_sequencia =
                            pedidoprod.db_pedi_sequencia
                        and pedidoprod2.db_pedi_produto =
                            pedidoprod.db_pedi_produto
                        and pedidoprod2.db_pedi_situacao = 1),
                     0)) / (sum(edipedprod.db_edii_qtde_vda)) * 100,
             2) as "Representatividade (em %)"
  from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  lotedistr,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cliente,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cliente.db_cli_cgcmf
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and lotedistr.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and edip.db_edip_van = 532        
union
select 4,
       'Produto Descontinuado / Desativado' as "R�tulo de Linha",
       
       sum(nvl((select sum(edipedprod2.db_edii_qtde_vda)
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
                          and prod.db_prod_situacao = 'I'
                          and codbarra.db_prdemb_codbarra =
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
                        and exists
                      (select *
                               from mercanet_qa.db_produto_embal codbarra,
                                    mercanet_qa.db_produto       prod
                              where codbarra.db_prdemb_produto =
                                    prod.db_prod_codigo
                                and prod.db_prod_situacao = 'I'
                                and codbarra.db_prdemb_codbarra =
                                    edipedprod2.db_edii_produto)),
                     0)) / (sum(edipedprod.db_edii_qtde_vda)) * 100,
             2) as "Representatividade (em %)"
  from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  lotedistr,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cliente,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cliente.db_cli_cgcmf
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and lotedistr.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and edip.db_edip_van = 532
    
        
        
union
select 5,
       'Produto n�o Cadastrado' as "R�tulo de Linha",
       
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
       mercanet_qa.db_edi_lote_distr  lotedistr,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cliente,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cliente.db_cli_cgcmf
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and lotedistr.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and edip.db_edip_van = 532
    
        
        
union
select 6,
       'Produto com preco errado' as "R�tulo de Linha",
       
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
       mercanet_qa.db_edi_lote_distr  lotedistr,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cliente,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cliente.db_cli_cgcmf
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and lotedistr.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and edip.db_edip_van = 532
    
        
        
union       
select 7,
       'Produto Bloqueado' as "R�tulo de Linha",
       
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
       mercanet_qa.db_edi_lote_distr  lotedistr,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cliente,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cliente.db_cli_cgcmf
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and lotedistr.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and edip.db_edip_van = 532
    
        
        


union
select 8,
       'N�o Faturado : Cliente Bloq/Desativado/N�o cadastrado' as "R�tulo de Linha",
       
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
       mercanet_qa.db_edi_lote_distr  lotedistr,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cliente,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cliente.db_cli_cgcmf
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and lotedistr.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and edip.db_edip_van = 532
    
        
        
union
select 9,
       'N�o Faturado : Cliente Sem Limite de Cr�dito' as "R�tulo de Linha",
       
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
       mercanet_qa.db_edi_lote_distr  lotedistr,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cliente,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cliente.db_cli_cgcmf
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and lotedistr.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and edip.db_edip_van = 532
    
        
        
union 
select 10,
       'N�o Faturado : Pedido Minimo' as "R�tulo de Linha",
       
       sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador =
                      edipedprod.db_edii_comprador
                  and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
                  and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
                  and edipedprod2.db_edii_motivoret = '22M' 
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
                        and edipedprod2.db_edii_motivoret = '22M'
                        ),
                     0)) /
             (sum(edipedprod.db_edii_qtde_vda)) * 100,
             2) as "Representatividade (em %)"
  from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  lotedistr,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cliente,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cliente.db_cli_cgcmf
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and lotedistr.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and edip.db_edip_van = 532
    
        
        

union 
select 11,
       'N�o Faturado : Pedido J� Enviado' as "R�tulo de Linha",
       
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
       mercanet_qa.db_edi_lote_distr  lotedistr,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cliente,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cliente.db_cli_cgcmf
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and lotedistr.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and edip.db_edip_van = 532
    
        
        
union 
select 12,
       'N�o Faturado : Cliente Sem Alvar�/Vencido' as "R�tulo de Linha",
       
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
       mercanet_qa.db_edi_lote_distr  lotedistr,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cliente,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cliente.db_cli_cgcmf
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and lotedistr.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and edip.db_edip_van = 532
    
        
        
union 
select 13,
       'N�o Faturado : Motivo n�o Especificado' as "R�tulo de Linha",
       
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
                        and edipedprod2.db_edii_seq =
                            edipedprod.db_edii_seq
                        and edipedprod2.db_edii_motivoret = '97'
                        ),
                     0)) /
             (sum(edipedprod.db_edii_qtde_vda)) * 100,
             2) as "Representatividade (em %)"
  from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  lotedistr,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cliente,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cliente.db_cli_cgcmf
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and lotedistr.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and edip.db_edip_van = 532       

union
select 14,
       'Total Geral' as "R�tulo de Linha",
       sum(edipedprod.db_edii_qtde_vda) as "Soma de Qtde Solicitada",
       sum(nvl(pedidoprod.db_pedi_qtde_atend, 0)) as "Soma de Qtde Atendida",
       100.00 as "Representatividade (em %)"

  from mercanet_qa.db_edi_pedido      edip,
       mercanet_qa.db_edi_pedprod     edipedprod,
       mercanet_qa.db_edi_lote_distr  lotedistr,
       mercanet_qa.db_pedido_distr_it pedidodistrit,
       mercanet_qa.db_pedido_prod     pedidoprod,
       mercanet_qa.db_cliente         cliente,
       mercanet_qa.db_produto         produto,
       mercanet_qa.db_produto_embal   produtoembal,
       mercanet_qa.db_tb_familia      familia,
       mercanet_qa.db_motivo_retdistr motivo
 where edip.db_edip_comprador = cliente.db_cli_cgcmf
   and edip.db_edip_comprador = edipedprod.db_edii_comprador
   and edip.db_edip_nro = edipedprod.db_edii_nro
   and lotedistr.db_edild_seq = edip.db_edip_lote
   and edipedprod.db_edii_pedmerc = pedidodistrit.db_pdit_pedido(+)
   and edipedprod.db_edii_seq = pedidodistrit.db_pdit_edii_seq(+)
   and pedidodistrit.db_pdit_pedido = pedidoprod.db_pedi_pedido(+)
   and pedidodistrit.db_pdit_produto = pedidoprod.db_pedi_produto(+)
   and edipedprod.db_edii_produto = produtoembal.db_prdemb_codbarra
   and produtoembal.db_prdemb_produto = produto.db_prod_codigo
   and produto.db_prod_familia = familia.db_tbfam_codigo
   and edipedprod.db_edii_motivoret = motivo.db_motr_codigo
   and edip.db_edip_van = 532
    
        
        
