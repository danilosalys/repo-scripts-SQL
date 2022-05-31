SELECT *
  FROM (select b.db_edip_van as "Codigo VAN",
               l.db_tbrep_nome as "Nome Van",
               c.db_cli_codigo as "Cod Cliente",
               '''' || b.db_edip_comprador as "CNPJ Cliente",
               c.db_cli_nome as "Razao Social",
               c.db_cli_estado as "UF Cliente",
               e.db_tbemp_codorig as "CD Origem",
               b.db_edip_nro as "Pedido Cliente",
               b.db_edip_pedmerc as "Pedido Mercanet",
               null as "Pedido JDE",
               b.db_edip_labcod as "Cod Forn Mercanet",
               f.db_lab_descricao as "Nome Forn",
               -- h.db_prdemb_produto as "Cod Produto",
               -- k.db_prod_descricao as "Desc Produto",
               round(sum((i.db_edii_qtde_vda * g.db_precop_valor) -
                         (((i.db_edii_qtde_vda * g.db_precop_valor) *
                         DB_EDII_PERC_DCTO) / 100)),
                     2) "Valor Total c desc",
               b.db_edip_dt_emissao as "Data de Emissao"
          from mercanet_prd.db_edi_ldistr_log@dc09 a,
               mercanet_prd.db_edi_pedido@dc09     b,
               mercanet_prd.db_edi_pedprod@dc09    i,
               mercanet_prd.db_cliente@dc09        c,
               mercanet_prd.db_cliente_repres@dc09 d,
               mercanet_prd.db_produto_embal@dc09  h,
               mercanet_prd.db_preco_prod@dc09     g,
               mercanet_prd.db_tb_empresa@dc09     e,
               mercanet_prd.db_produto@dc09        k,
               mercanet_prd.db_laboratorio@dc09    f,
               mercanet_prd.db_tb_repres@dc09      l,
               mercanet_prd.Mem01@dc09             p
         where a.db_edill_seq_lote = b.db_edip_lote
           and (a.db_edill_txtlog like '%Pedido com Restrição 999%' or
               a.db_edill_txtlog like '%Pedido com Restrição 996%')
           and a.db_edill_id in
               (select min(a1.db_edill_id)
                  from mercanet_prd.db_edi_ldistr_log@dc09 a1
                 where a.db_edill_seq_lote = a1.db_edill_seq_lote
                 group by a1.db_edill_seq_lote)
           and b.db_edip_comprador = i.db_edii_comprador
           and b.db_edip_nro = i.db_edii_nro
           and b.db_edip_comprador = c.db_cli_cgcmf
           and c.db_cli_codigo = d.db_clir_cliente
           and b.db_edip_empresa = d.db_clir_empresa
           and i.db_edii_produto = h.db_prdemb_codbarra
           and h.db_prdemb_produto = g.db_precop_produto
           and d.db_clir_lpreco = g.db_precop_codigo
           and d.db_clir_lpreco = g.db_precop_codigo
           and d.db_clir_empresa = e.db_tbemp_codigo
           and h.db_prdemb_produto = k.db_prod_codigo
           and b.db_edip_labcod = f.db_lab_codigo
           and b.db_edip_van = l.db_tbrep_codigo
           and p.em01_codigo = b.db_edip_van
           and p.em01_exparqped = 1
         group by b.db_edip_pedmerc,
                  b.db_edip_van,
                  l.db_tbrep_nome,
                  c.db_cli_codigo,
                  b.db_edip_comprador,
                  c.db_cli_nome,
                  c.db_cli_estado,
                  e.db_tbemp_codorig,
                  e.db_tbemp_codorig,
                  e.db_tbemp_codorig,
                  b.db_edip_nro,
                  b.db_edip_labcod,
                  f.db_lab_descricao,
                  b.db_edip_dt_emissao
        union
        select b.db_edip_van as "Codigo VAN",
               l.db_tbrep_nome as "Nome Van",
               c.db_cli_codigo as "Codigo do Cliente",
               '''' || b.db_edip_comprador as "CNPJ Cliente",
               c.db_cli_nome as "Razao Social",
               c.db_cli_estado as "UF Cliente",
               e.db_tbemp_codorig as "CD Origem",
               b.db_edip_nro as "Pedido Cliente",
               b.db_edip_pedmerc as "Pedido Mercanet",
               m.DB_PED_NRO_ORIG as "Pedido JDE",
               b.db_edip_labcod as "Cod Forn Mercanet",
               f.db_lab_descricao as "Nome Forn",
               --  i.db_pedi_produto as "Cod Produto",
               --  k.db_prod_descricao as "Desc Produto",
               round(sum(i.db_pedi_preco_liq * i.db_pedi_qtde_solic), 2) as "Valor Total c desc",
               b.db_edip_dt_emissao as "Data de Emissao"
          from mercanet_prd.db_edi_pedido@dc09  b,
               mercanet_prd.db_pedido_prod@dc09 i,
               mercanet_prd.db_cliente@dc09     c,
               mercanet_prd.db_tb_empresa@dc09  e,
               mercanet_prd.db_produto@dc09     k,
               mercanet_prd.db_laboratorio@dc09 f,
               mercanet_prd.db_tb_repres@dc09   l,
               mercanet_prd.db_pedido@dc09      m
         where b.db_edip_pedmerc = i.db_pedi_pedido
           and m.db_ped_cliente = c.db_cli_codigo
           and b.db_edip_empresa = e.db_tbemp_codigo
           and i.db_pedi_produto = k.db_prod_codigo
           and b.db_edip_labcod = f.db_lab_codigo
           and b.db_edip_van = l.db_tbrep_codigo
           and b.db_edip_pedmerc = m.db_ped_nro
           and m.db_ped_situacao = 9
           and m.db_ped_sitcorp = 1
         group by b.db_edip_pedmerc,
                  b.db_edip_van,
                  l.db_tbrep_nome,
                  c.db_cli_codigo,
                  b.db_edip_comprador,
                  c.db_cli_nome,
                  c.db_cli_estado,
                  e.db_tbemp_codorig,
                  e.db_tbemp_codorig,
                  e.db_tbemp_codorig,
                  b.db_edip_nro,
                  b.db_edip_labcod,
                  f.db_lab_descricao,
                  m.DB_PED_NRO_ORIG,
                  b.db_edip_dt_emissao
        Union
        select b.db_edip_van as "Codigo VAN",
               p.em01_ean as "Nome Van",
               c.db_cli_codigo as "Cod Cliente",
               '''' || b.db_edip_comprador as "CNPJ Cliente",
               c.db_cli_nome as "Razao Social",
               c.db_cli_estado as "UF Cliente",
               e.db_tbemp_codorig as "CD Origem",
               b.db_edip_nro as "Pedido Cliente",
               b.db_edip_pedmerc as "Pedido Mercanet",
               m.DB_PED_NRO_ORIG as "Pedido JDE",
               b.db_edip_labcod as "Cod Forn Mercanet",
               f.db_lab_descricao as "Nome Forn",
               -- h.db_prdemb_produto as "Cod Produto",
               --k.db_prod_descricao as "Desc Produto",
               round(sum((i.db_edii_qtde_vda * g.db_precop_valor) -
                         (((i.db_edii_qtde_vda * g.db_precop_valor) *
                         DB_EDII_PERC_DCTO) / 100)),
                     2) "Valor Total c desc",
               b.db_edip_dt_emissao as "Data de Emissao"
          from mercanet_prd.db_edi_pedido@dc09      b,
               mercanet_prd.db_edi_pedprod@dc09     i,
               mercanet_prd.db_cliente@dc09         c,
               mercanet_prd.db_cliente_repres@dc09  d,
               mercanet_prd.db_produto_embal@dc09   h,
               mercanet_prd.db_preco_prod@dc09      g,
               mercanet_prd.db_tb_empresa@dc09      e,
               mercanet_prd.db_produto@dc09         k,
               mercanet_prd.db_laboratorio@dc09     f,
               mercanet_prd.db_tb_repres@dc09       l,
               mercanet_prd.Mem01@dc09              p,
               mercanet_prd.mem05@dc09              q,
               mercanet_prd.db_pedido@dc09          m,
               mercanet_prd.db_motivo_retdistr@dc09 r
         where b.db_edip_comprador = i.db_edii_comprador
           and b.db_edip_pedmerc = m.db_ped_nro
           and b.db_edip_nro = i.db_edii_nro
           and b.db_edip_comprador = c.db_cli_cgcmf
           and c.db_cli_codigo = d.db_clir_cliente
           and b.db_edip_empresa = d.db_clir_empresa
           and i.db_edii_produto = h.db_prdemb_codbarra
           and h.db_prdemb_produto = g.db_precop_produto
           and d.db_clir_lpreco = g.db_precop_codigo
           and d.db_clir_lpreco = g.db_precop_codigo
           and d.db_clir_empresa = e.db_tbemp_codigo
           and h.db_prdemb_produto = k.db_prod_codigo
           and b.db_edip_labcod = f.db_lab_codigo
           and b.db_edip_van = l.db_tbrep_codigo
           AND p.em01_codigo = b.db_edip_van
           and p.em01_exparqped = 0
           and p.em01_codigo = q.em05_distr
           and q.em05_situacao = 3
           and q.em05_motivo = r.db_motr_codigo
           AND I.DB_EDII_MOTIVORET = Q.EM05_MOTIVO
         group by b.db_edip_pedmerc,
                  b.db_edip_van,
                  l.db_tbrep_nome,
                  c.db_cli_codigo,
                  b.db_edip_comprador,
                  c.db_cli_nome,
                  c.db_cli_estado,
                  e.db_tbemp_codorig,
                  e.db_tbemp_codorig,
                  e.db_tbemp_codorig,
                  b.db_edip_nro,
                  b.db_edip_labcod,
                  f.db_lab_descricao,
                  p.em01_ean,
                  m.DB_PED_NRO_ORIG,
                  b.db_edip_dt_emissao)
 WHERE "Data de Emissao" between to_date('01/01/2013 00:00:00', 'dd/mm/yyyy hh24:mi:ss') and  
                                 to_date('31/01/2013 23:59:59', 'dd/mm/yyyy hh24:mi:ss')
                                 
--Comentário: Inserir Intervalo de data
