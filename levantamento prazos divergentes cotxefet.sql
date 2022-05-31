select d.db_cli_codigo,d.db_cli_nome, b.db_edip_nro,b.db_edip_condpgto, b.db_edip_dt_emissao, b.db_edip_pedmerc,--COTACAO
       c.db_cli_codigo,c.db_cli_nome, a.db_edip_nro,a.db_edip_condpgto ,a.db_edip_dt_emissao,a.db_edip_pedmerc --EFETIVACAO     
from mercanet_prd.db_edi_pedido a , mercanet_prd.db_edi_pedido b , mercanet_prd.db_cliente c, mercanet_prd.db_cliente d
where A.DB_EDIP_DT_EMISSAO > TO_DATE('01/01/2013','DD/MM/YYYY')
  and a.db_edip_obs1 = b.db_edip_obs1
  and a.db_edip_van  = 530
  and b.db_edip_van = 529
  --and a.db_edip_pedmerc = 0
  and a.db_edip_comprador = c.db_cli_cgcmf
  and b.db_edip_comprador = d.db_cli_cgcmf
  --and d.db_cli_codigo = c.db_cli_codigo
  AND a.db_edip_condpgto != b.db_edip_condpgto