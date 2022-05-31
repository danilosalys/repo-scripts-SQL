select b.db_edii_nro,
       b.db_edii_comprador,
       c.db_prdemb_produto,
       b.db_edii_produto,
       count(1)
  from db_edi_pedido a, db_edi_pedprod b, db_produto_embal c
 where db_edip_lote >= 3423
   and a.db_edip_nro = b.db_edii_nro
   and b.db_edii_produto = c.db_prdemb_codbarra(+)
 group by b.db_edii_nro,
          b.db_edii_comprador,
          c.db_prdemb_produto,
          b.db_edii_produto
having count(1) > 1
 order by b.db_edii_nro