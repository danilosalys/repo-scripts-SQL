select '1' as " ",
       'Produto Faturado' as "Rótulo de Linha",
       
       sum(nvl((select sum(pedidoprod2.db_pedi_qtde_solic)
                 from mercanet_qa.db_pedido_prod pedidoprod2
                where pedidoprod2.db_pedi_pedido = v.db_pedi_pedido
                  and pedidoprod2.db_pedi_sequencia = v.db_pedi_sequencia
                  and pedidoprod2.db_pedi_produto = v.db_pedi_produto
                  and pedidoprod2.db_pedi_situacao = 2),
               0)) as "Soma de Qtde Solicitada",
       
       sum(nvl((select sum(pedidoprod2.db_pedi_qtde_atend)
                 from mercanet_qa.db_pedido_prod pedidoprod2
                where pedidoprod2.db_pedi_pedido = v.db_pedi_pedido
                  and pedidoprod2.db_pedi_sequencia = v.db_pedi_sequencia
                  and pedidoprod2.db_pedi_produto = v.db_pedi_produto
                  and pedidoprod2.db_pedi_situacao = 2),
               0)) as "Soma de Qtde Atendida",
       
       round(sum(nvl((select sum(pedidoprod2.db_pedi_qtde_atend)
                       from mercanet_qa.db_pedido_prod pedidoprod2
                      where pedidoprod2.db_pedi_pedido = v.db_pedi_pedido
                        and pedidoprod2.db_pedi_sequencia =
                            v.db_pedi_sequencia
                        and pedidoprod2.db_pedi_produto = v.db_pedi_produto
                        and pedidoprod2.db_pedi_situacao = 2),
                     0)) / (sum(v.db_edii_qtde_vda)) * 100,
             2) || '%' as "Representatividade"
  from mercanet_qa.v_pedido_coop v
  
union
select '2',
       'Produto em Falta' as "Rótulo de Linha",
       sum(nvl((select sum(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador = v.db_edii_comprador
                  and edipedprod2.db_edii_nro = v.db_edii_nro
                  and edipedprod2.db_edii_motivoret = '16M'),
               0)) as "Soma de Qtde Solicitada",
       0 as "Soma de Qtde Atendida",
       round(sum(nvl(((select sum(edipedprod2.db_edii_qtde_vda)
                         from mercanet_qa.db_edi_pedprod edipedprod2
                        where edipedprod2.db_edii_comprador =
                              v.db_edii_comprador
                          and edipedprod2.db_edii_nro = v.db_edii_nro
                          and edipedprod2.db_edii_motivoret = '16M')),
                     0)) / (sum(v.db_edii_qtde_vda)) * 100,
             2) || '%' as "Representatividade"
  from mercanet_qa.v_pedido_coop v
  
union
select '3',
       'Produto Atendido Parcialmente' as "Rótulo de Linha",
       sum(nvl((select sum(pedidoprod2.db_pedi_qtde_solic)
                 from mercanet_qa.db_pedido_prod pedidoprod2
                where pedidoprod2.db_pedi_pedido = v.db_pedi_pedido
                  and pedidoprod2.db_pedi_sequencia = v.db_pedi_sequencia
                  and pedidoprod2.db_pedi_produto = v.db_pedi_produto
                  and pedidoprod2.db_pedi_situacao = 1),
               0)) as "Soma de Qtde Solicitada",
       
       sum(nvl((select sum(pedidoprod2.db_pedi_qtde_atend)
                 from mercanet_qa.db_pedido_prod pedidoprod2
                where pedidoprod2.db_pedi_pedido = v.db_pedi_pedido
                  and pedidoprod2.db_pedi_sequencia = v.db_pedi_sequencia
                  and pedidoprod2.db_pedi_produto = v.db_pedi_produto
                  and pedidoprod2.db_pedi_situacao = 1),
               0)) as "Soma de Qtde Atendida",
       round(sum(nvl((select sum(pedidoprod2.db_pedi_qtde_atend)
                       from mercanet_qa.db_pedido_prod pedidoprod2
                      where pedidoprod2.db_pedi_pedido = v.db_pedi_pedido
                        and pedidoprod2.db_pedi_sequencia =
                            v.db_pedi_sequencia
                        and pedidoprod2.db_pedi_produto = v.db_pedi_produto
                        and pedidoprod2.db_pedi_situacao = 1),
                     0)) / (sum(v.db_edii_qtde_vda)) * 100,
             2) || '%' as "Representatividade"
  from mercanet_qa.v_pedido_coop v
  
union
select '4',
       'Produto Descontinuado / Desativado' as "Rótulo de Linha",
       
       sum(nvl((select sum(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador = v.db_edii_comprador
                  and edipedprod2.db_edii_nro = v.db_edii_nro
                  and edipedprod2.db_edii_motivoret = '09M'
                  and exists
                (select *
                         from mercanet_qa.db_produto_embal codbarra,
                              mercanet_qa.db_produto       prod
                        where codbarra.db_prdemb_produto =
                              prod.db_prod_codigo
                          and prod.db_prod_situacao = '3'
                          and codbarra.db_prdemb_codbarra =
                              edipedprod2.db_edii_produto)),
               0)) as "Soma de Qtde Solicitada",
       
       0 as "Soma de Qtde Atendida",
       
       round(sum(nvl((select sum(edipedprod2.db_edii_qtde_vda)
                       from mercanet_qa.db_edi_pedprod edipedprod2
                      where edipedprod2.db_edii_comprador =
                            v.db_edii_comprador
                        and edipedprod2.db_edii_nro = v.db_edii_nro
                        and edipedprod2.db_edii_motivoret = '09M'
                        and exists
                      (select *
                               from mercanet_qa.db_produto_embal codbarra,
                                    mercanet_qa.db_produto       prod
                              where codbarra.db_prdemb_produto =
                                    prod.db_prod_codigo
                                and prod.db_prod_situacao = '3'
                                and codbarra.db_prdemb_codbarra =
                                    edipedprod2.db_edii_produto)),
                     0)) / (sum(v.db_edii_qtde_vda)) * 100,
             2) || '%' as "Representatividade"
  from mercanet_qa.v_pedido_coop v
  
union
select '5',
       'Produto não Cadastrado' as "Rótulo de Linha",
       
       sum(nvl((select sum(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador = v.db_edii_comprador
                  and edipedprod2.db_edii_nro = v.db_edii_nro
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
                            v.db_edii_comprador
                        and edipedprod2.db_edii_nro = v.db_edii_nro
                        and not exists
                      (select *
                               from mercanet_qa.db_produto_embal codbarra
                              where codbarra.db_prdemb_codbarra =
                                    edipedprod2.db_edii_produto)),
                     0)) / (sum(v.db_edii_qtde_vda)) * 100,
             2) || '%' as "Representatividade"
  from mercanet_qa.v_pedido_coop v
  
union
select '6',
       'Produto com preco errado' as "Rótulo de Linha",
       
       sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                 from mercanet_qa.db_edi_pedprod edipedprod2
                where edipedprod2.db_edii_comprador = v.db_edii_comprador
                  and edipedprod2.db_edii_nro = v.db_edii_nro
                  and edipedprod2.db_edii_motivoret = '09M'),
               0)) as "Soma de Qtde Solicitada",
       
       0 as "Soma de Qtde Atendida",
       
       round(sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
                       from mercanet_qa.db_edi_pedprod edipedprod2
                      where edipedprod2.db_edii_comprador =
                            v.db_edii_comprador
                        and edipedprod2.db_edii_nro = v.db_edii_nro
                        and edipedprod2.db_edii_motivoret = '09M'),
                     0)) / (sum(v.db_edii_qtde_vda)) * 100,
             2) || '%' as "Representatividade"
  from mercanet_qa.v_pedido_coop v
  
union
select '7' as " ",
       'Total Geral' as "Rótulo de Linha",
       sum(v.db_edii_qtde_vda) as "Soma de Qtde Solicitada",
       sum(nvl(v.db_pedi_qtde_atend, 0)) as "Soma de Qtde Atendida",
       100.00 || '%' as "Representatividade"

  from mercanet_qa.v_pedido_coop v
  
