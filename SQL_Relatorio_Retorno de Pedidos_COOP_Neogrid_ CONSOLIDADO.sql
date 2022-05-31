select '1' as " ",
       'Produto Faturado' as "Rótulo de Linha",
       
        sum(nvl((select sum(pedidoprod2.db_pedi_qtde_solic)
          from mercanet_prd.db_pedido_prod pedidoprod2
          where pedidoprod2.db_pedi_pedido = pedidoprod.db_pedi_pedido
          and pedidoprod2.db_pedi_sequencia = pedidoprod.db_pedi_sequencia
          and pedidoprod2.db_pedi_produto = pedidoprod.db_pedi_produto
          and pedidoprod2.db_pedi_situacao = 2),0)) as "Soma de Qtde Solicitada",
          
       sum(nvl((select sum(pedidoprod2.db_pedi_qtde_atend)
          from mercanet_prd.db_pedido_prod pedidoprod2
          where pedidoprod2.db_pedi_pedido = pedidoprod.db_pedi_pedido
          and pedidoprod2.db_pedi_sequencia = pedidoprod.db_pedi_sequencia
          and pedidoprod2.db_pedi_produto = pedidoprod.db_pedi_produto
          and pedidoprod2.db_pedi_situacao = 2),0)) as "Soma de Qtde Atendida", 
          
       round(sum(nvl((select sum(pedidoprod2.db_pedi_qtde_atend)
          from mercanet_prd.db_pedido_prod pedidoprod2
          where pedidoprod2.db_pedi_pedido = pedidoprod.db_pedi_pedido
          and pedidoprod2.db_pedi_sequencia = pedidoprod.db_pedi_sequencia
          and pedidoprod2.db_pedi_produto = pedidoprod.db_pedi_produto
          and pedidoprod2.db_pedi_situacao = 2),0)) /
             (sum(edipedprod.db_edii_qtde_vda)) * 100,
             2)  as "Representatividade (em %)"
  from mercanet_prd.db_edi_pedido      edip,
       mercanet_prd.db_edi_pedprod     edipedprod,
       mercanet_prd.db_edi_lote_distr  lotedistr,
       mercanet_prd.db_pedido_distr_it pedidodistrit,
       mercanet_prd.db_pedido_prod     pedidoprod,
       mercanet_prd.db_cliente         cliente,
       mercanet_prd.db_produto         produto,
       mercanet_prd.db_produto_embal   produtoembal,
       mercanet_prd.db_tb_familia      familia,
       mercanet_prd.db_motivo_retdistr motivo
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
 and edip.db_edip_van = 501
 and lotedistr.db_edild_data  between to_date('27/11/2012 00:00:00','dd/mm/yyyy hh24:mi:ss') 
                                  and to_date('27/11/2012 23:59:59','dd/mm/yyyy hh24:mi:ss')
union
select '2',
       'Produto em Falta' as "Rótulo de Linha",
       sum(nvl((select sum(edipedprod2.db_edii_qtde_vda)
          from mercanet_prd.db_edi_pedprod edipedprod2
        where edipedprod2.db_edii_comprador = edipedprod.db_edii_comprador
          and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
          and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
          and edipedprod2.db_edii_motivoret = '06'),0)) as "Soma de Qtde Solicitada",
       0 as "Soma de Qtde Atendida",
      round(sum(nvl(((select sum(edipedprod2.db_edii_qtde_vda)
          from mercanet_prd.db_edi_pedprod edipedprod2 
        where edipedprod2.db_edii_comprador = edipedprod.db_edii_comprador
          and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
          and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
          and edipedprod2.db_edii_motivoret = '06')),0)) /
             (sum(edipedprod.db_edii_qtde_vda)) * 100,2)  as "Representatividade (em %)"
  from mercanet_prd.db_edi_pedido      edip,
       mercanet_prd.db_edi_pedprod     edipedprod,
       mercanet_prd.db_edi_lote_distr  lotedistr,
       mercanet_prd.db_pedido_distr_it pedidodistrit,
       mercanet_prd.db_pedido_prod     pedidoprod,
       mercanet_prd.db_cliente         cliente,
       mercanet_prd.db_produto         produto,
       mercanet_prd.db_produto_embal   produtoembal,
       mercanet_prd.db_tb_familia      familia,
       mercanet_prd.db_motivo_retdistr motivo
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
 and edip.db_edip_van = 501
 and lotedistr.db_edild_data  between to_date('27/11/2012 00:00:00','dd/mm/yyyy hh24:mi:ss') 
                                  and to_date('27/11/2012 23:59:59','dd/mm/yyyy hh24:mi:ss')
union
select '3',
       'Produto Atendido Parcialmente' as "Rótulo de Linha",
       sum(nvl((select sum(pedidoprod2.db_pedi_qtde_solic)
          from mercanet_prd.db_pedido_prod pedidoprod2
          where pedidoprod2.db_pedi_pedido = pedidoprod.db_pedi_pedido
          and pedidoprod2.db_pedi_sequencia = pedidoprod.db_pedi_sequencia
          and pedidoprod2.db_pedi_produto = pedidoprod.db_pedi_produto
          and pedidoprod2.db_pedi_situacao = 1),0)) as "Soma de Qtde Solicitada",
          
       sum(nvl((select sum(pedidoprod2.db_pedi_qtde_atend)
          from mercanet_prd.db_pedido_prod pedidoprod2
          where pedidoprod2.db_pedi_pedido = pedidoprod.db_pedi_pedido
          and pedidoprod2.db_pedi_sequencia = pedidoprod.db_pedi_sequencia
          and pedidoprod2.db_pedi_produto = pedidoprod.db_pedi_produto
          and pedidoprod2.db_pedi_situacao = 1),0)) as "Soma de Qtde Atendida",
      round( sum(nvl((select sum(pedidoprod2.db_pedi_qtde_atend)
          from mercanet_prd.db_pedido_prod pedidoprod2
          where pedidoprod2.db_pedi_pedido = pedidoprod.db_pedi_pedido
          and pedidoprod2.db_pedi_sequencia = pedidoprod.db_pedi_sequencia
          and pedidoprod2.db_pedi_produto = pedidoprod.db_pedi_produto
          and pedidoprod2.db_pedi_situacao = 1),0)) /
             (sum(edipedprod.db_edii_qtde_vda)) * 100,2) as "Representatividade (em %)"
  from mercanet_prd.db_edi_pedido      edip,
       mercanet_prd.db_edi_pedprod     edipedprod,
       mercanet_prd.db_edi_lote_distr  lotedistr,
       mercanet_prd.db_pedido_distr_it pedidodistrit,
       mercanet_prd.db_pedido_prod     pedidoprod,
       mercanet_prd.db_cliente         cliente,
       mercanet_prd.db_produto         produto,
       mercanet_prd.db_produto_embal   produtoembal,
       mercanet_prd.db_tb_familia      familia,
       mercanet_prd.db_motivo_retdistr motivo
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
 and edip.db_edip_van = 501
 and lotedistr.db_edild_data  between to_date('27/11/2012 00:00:00','dd/mm/yyyy hh24:mi:ss') 
                                  and to_date('27/11/2012 23:59:59','dd/mm/yyyy hh24:mi:ss')
union
select '4',
       'Produto Descontinuado / Desativado' as "Rótulo de Linha",
       
       sum(nvl((select sum(edipedprod2.db_edii_qtde_vda)
          from mercanet_prd.db_edi_pedprod edipedprod2
        where edipedprod2.db_edii_comprador = edipedprod.db_edii_comprador
          and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
          and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
          and edipedprod2.db_edii_motivoret = '05'
          and exists (select * from mercanet_prd.db_produto_embal codbarra,
                                    mercanet_prd.db_produto prod
                        where codbarra.db_prdemb_produto = prod.db_prod_codigo
                          and prod.db_prod_situacao = '3'
                          and codbarra.db_prdemb_codbarra = edipedprod2.db_edii_produto)),0)) as "Soma de Qtde Solicitada",
             
       0 as "Soma de Qtde Atendida",
       
      round( sum(nvl((select sum(edipedprod2.db_edii_qtde_vda)
          from mercanet_prd.db_edi_pedprod edipedprod2
        where edipedprod2.db_edii_comprador = edipedprod.db_edii_comprador
          and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
          and edipedprod2.db_edii_seq = edipedprod.db_edii_seq
          and edipedprod2.db_edii_motivoret = '05'
          and exists (select * from mercanet_prd.db_produto_embal codbarra,
                                    mercanet_prd.db_produto prod
                        where codbarra.db_prdemb_produto = prod.db_prod_codigo
                          and prod.db_prod_situacao = '3'
                          and codbarra.db_prdemb_codbarra = edipedprod2.db_edii_produto)),0)) /
             (sum(edipedprod.db_edii_qtde_vda)) * 100,2) as "Representatividade (em %)"
  from mercanet_prd.db_edi_pedido      edip,
       mercanet_prd.db_edi_pedprod     edipedprod,
       mercanet_prd.db_edi_lote_distr  lotedistr,
       mercanet_prd.db_pedido_distr_it pedidodistrit,
       mercanet_prd.db_pedido_prod     pedidoprod,
       mercanet_prd.db_cliente         cliente,
       mercanet_prd.db_produto         produto,
       mercanet_prd.db_produto_embal   produtoembal,
       mercanet_prd.db_tb_familia      familia,
       mercanet_prd.db_motivo_retdistr motivo
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
 and edip.db_edip_van = 501
 and lotedistr.db_edild_data  between to_date('27/11/2012 00:00:00','dd/mm/yyyy hh24:mi:ss') 
                                  and to_date('27/11/2012 23:59:59','dd/mm/yyyy hh24:mi:ss')
union
select '5',
       'Produto não Cadastrado' as "Rótulo de Linha",
       
       sum(nvl((select sum(edipedprod2.db_edii_qtde_vda)
          from mercanet_prd.db_edi_pedprod edipedprod2
        where edipedprod2.db_edii_comprador = edipedprod.db_edii_comprador
          and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
          and edipedprod2.db_edii_motivoret = '05'
          and not exists (select * from mercanet_prd.db_produto_embal codbarra                                    
                        where codbarra.db_prdemb_codbarra = edipedprod2.db_edii_produto)),0)) as "Soma de Qtde Solicitada",
             
       0 as "Soma de Qtde Atendida",
       
      round( sum(nvl((select sum(edipedprod2.db_edii_qtde_vda)
          from mercanet_prd.db_edi_pedprod edipedprod2
        where edipedprod2.db_edii_comprador = edipedprod.db_edii_comprador
          and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
          and edipedprod2.db_edii_motivoret = '05'
          and not exists (select * from mercanet_prd.db_produto_embal codbarra
                        where codbarra.db_prdemb_codbarra = edipedprod2.db_edii_produto)),0)) /
             (sum(edipedprod.db_edii_qtde_vda)) * 100,2) as "Representatividade (em %)"
  from mercanet_prd.db_edi_pedido      edip,
       mercanet_prd.db_edi_pedprod     edipedprod,
       mercanet_prd.db_edi_lote_distr  lotedistr,
       mercanet_prd.db_pedido_distr_it pedidodistrit,
       mercanet_prd.db_pedido_prod     pedidoprod,
       mercanet_prd.db_cliente         cliente,
       mercanet_prd.db_produto         produto,
       mercanet_prd.db_produto_embal   produtoembal,
       mercanet_prd.db_tb_familia      familia,
       mercanet_prd.db_motivo_retdistr motivo
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
 and edip.db_edip_van = 501
 and lotedistr.db_edild_data  between to_date('27/11/2012 00:00:00','dd/mm/yyyy hh24:mi:ss') 
                                  and to_date('27/11/2012 23:59:59','dd/mm/yyyy hh24:mi:ss')
union
select '6',
       'Produto com preco errado' as "Rótulo de Linha",
       
       sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
          from mercanet_prd.db_edi_pedprod edipedprod2
        where edipedprod2.db_edii_comprador = edipedprod.db_edii_comprador
          and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
          and edipedprod2.db_edii_motivoret = '99'),0)) as "Soma de Qtde Solicitada",
             
       0 as "Soma de Qtde Atendida",
       
      round(sum(nvl((select max(edipedprod2.db_edii_qtde_vda)
          from mercanet_prd.db_edi_pedprod edipedprod2
        where edipedprod2.db_edii_comprador = edipedprod.db_edii_comprador
          and edipedprod2.db_edii_nro = edipedprod.db_edii_nro
          and edipedprod2.db_edii_motivoret = '99'),0)) /
             (sum(edipedprod.db_edii_qtde_vda)) * 100,2) as "Representatividade (em %)"
  from mercanet_prd.db_edi_pedido      edip,
       mercanet_prd.db_edi_pedprod     edipedprod,
       mercanet_prd.db_edi_lote_distr  lotedistr,
       mercanet_prd.db_pedido_distr_it pedidodistrit,
       mercanet_prd.db_pedido_prod     pedidoprod,
       mercanet_prd.db_cliente         cliente,
       mercanet_prd.db_produto         produto,
       mercanet_prd.db_produto_embal   produtoembal,
       mercanet_prd.db_tb_familia      familia,
       mercanet_prd.db_motivo_retdistr motivo
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
 and edip.db_edip_van = 501
 and lotedistr.db_edild_data  between to_date('27/11/2012 00:00:00','dd/mm/yyyy hh24:mi:ss') 
                                  and to_date('27/11/2012 23:59:59','dd/mm/yyyy hh24:mi:ss')
/*
union 
select '7' as " ",
       'Total Geral' as "Rótulo de Linha",
       sum(edipedprod.db_edii_qtde_vda) as "Soma de Qtde Solicitada",
       sum(nvl(pedidoprod.db_pedi_qtde_atend,0)) as "Soma de Qtde Atendida",
       100.00 || '%' as "Representatividade (em %)"
       
  from mercanet_prd.db_edi_pedido      edip,
       mercanet_prd.db_edi_pedprod     edipedprod,
       mercanet_prd.db_edi_lote_distr  lotedistr,
       mercanet_prd.db_pedido_distr_it pedidodistrit,
       mercanet_prd.db_pedido_prod     pedidoprod,
       mercanet_prd.db_cliente         cliente,
       mercanet_prd.db_produto         produto,
       mercanet_prd.db_produto_embal   produtoembal,
       mercanet_prd.db_tb_familia      familia,
       mercanet_prd.db_motivo_retdistr motivo
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
 and edip.db_edip_van = 501
 and lotedistr.db_edild_data  between to_date('27/11/2012 00:00:00','dd/mm/yyyy hh24:mi:ss') 
                                  and to_date('27/11/2012 23:59:59','dd/mm/yyyy hh24:mi:ss')*/


