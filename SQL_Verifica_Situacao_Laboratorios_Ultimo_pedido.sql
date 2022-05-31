select t1.em06_distr as "Codigo da Van",
       t4.em01_ean as "Nome da Van",
       t1.em06_laboratorio as "Codigo do Laboratorio",
       t2.db_lab_descricao as "Descrição do Laboratório",
       max(t3.db_edip_dt_emissao) as "Data do Último Pedido Enviado",
       count(db_edip_nro) "Total_Pedidos_Existentes_Base"
  from mercanet_prd.mem06          t1,
       mercanet_prd.db_laboratorio t2,
       mercanet_prd.db_edi_pedido  t3,
       mercanet_prd.mem01          t4       
 where t1.em06_laboratorio = t2.db_lab_codigo
   and t1.em06_distr = t4.em01_codigo
   and t1.em06_distr = t3.db_edip_van(+)
   and t1.em06_laboratorio = t3.db_edip_labcod(+)
   and exists (select * from mercanet_prd.db_tb_repres t5
                where t5.db_tbrep_codigo = t1.em06_distr
                  and t5.db_tbrep_nome not like '%DESATIVADO%')
   and t1.em06_distr <> 540 --Layout Pharmalink 3.0 ainda não entrou em produção.
 group by t1.em06_distr,
          t4.em01_ean,
          t1.em06_laboratorio,
          t2.db_lab_descricao,
          t3.db_edip_labcod
