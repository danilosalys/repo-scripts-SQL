select * from mercanet_qa.db_edi_lcposai a
where exists(
select * from mercanet_qa.db_edi_lregsai b
where db_edis_codigo = 'NISSEI_NF'
and db_edis_tipo = 1
and a.db_edic_codigo = b.db_edis_campo)
and not exists (select * from mercanet_hml.db_edi_lcposai d
where exists(
select * from mercanet_hml.db_edi_lregsai e
where e.db_edis_codigo = 'NISSEI_NF'
and e.db_edis_tipo = 1
and d.db_edic_codigo = e.db_edis_campo)
and d.db_edic_codigo = a.db_edic_codigo
and d.db_edic_expressao = a.db_edic_expressao
)

