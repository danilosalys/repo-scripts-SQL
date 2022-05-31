select cli.db_cli_cidade as "Loja",
       (edip.db_edip_comprador) as "Código do Cliente(CNPJ)",
       nvl(edip.db_edip_pedmerc, 0) as "Pedido Drogacenter",
       edip.db_edip_nro as "Pedido Coop",
       edipedprod.db_edii_valor1 as "Sequencia do Item",
       produto.db_prod_codigo as "Código Produto",
       familia.db_tbfam_descricao as "Fornecedor",
       edipedprod.db_edii_produto as "Codigo de barras",
       produto.db_prod_descricao as "Descrição Produto",
       edipedprod.db_edii_qtde_vda as "Qtd solicitada",
       nvl(pedidoprod.db_pedi_qtde_atend, 0) as "Qtd Atendida",
       motivo.db_motr_descr as "Descr. Retorno",
       motivo.db_motr_codigo ,
       edip.db_edip_dt_emissao as "Data Pedido",
       nvl(pedidoprod.db_pedi_preco_liq, 0) as "Preço Liquido",
       SUBSTR(TO_CHAR(edild.db_edild_data, 'DD/MM/YYYY HH24:MM:SS'),
              12,
              8) as "Hora cap",
       nvl(pedidoprod.db_pedi_float2, 0) as "Perc Desconto",
       nvl(pedidoprod.db_pedi_preco_unit, 0) as "Preço fab"
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
  and edip.db_edip_van = 532
 order by edild.db_edild_data,
          edip.db_edip_dt_emissao,
          edip.db_edip_pedmerc,
          edipedprod.db_edii_valor1


