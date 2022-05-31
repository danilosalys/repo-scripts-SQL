insert into mercanet_hml.db_restricao
select * from mercanet_qa.db_restricao
where db_res_codigo in (11, 1019 , 1020, 1020,1022,1021,1023,1024,1025);

insert into mercanet_hml.db_restr_filtros 
select * from mercanet_qa.db_restr_filtros 
where db_resf_codigo in (11, 1019 , 1020, 1020,1022,1021,1023,1024,1025);

insert into mercanet_hml.db_restr_regras
select * from mercanet_qa.db_restr_regras
where db_resr_codigo in (11, 1019 , 1020, 1020,1022,1021,1023,1024,1025);

insert into mercanet_hml.db_restr_regras_pai
select * from mercanet_qa.db_restr_regras_pai
where db_resrp_codigo in (11, 1019 , 1020, 1020,1022,1021,1023,1024,1025);

insert into mercanet_hml.db_cpo_atrib
select * from mercanet_qa.db_cpo_atrib
WHERE DB_cpo_codigo IN(11, 1019 , 1020, 1020,1022,1021,1023,1024,1025)





