----------CADASTRO DE PRODUTO

truncate table qadta.F4101 ;
insert into qadta.F4101
select * 
  from proddta.F4101@dc01.drogacenter.com.br;
commit ;

truncate table qadta.F4102;
insert into qadta.F4102
select * 
  from proddta.F4102@dc01.drogacenter.com.br;
commit ;

truncate table qadta.F76411;
insert into qadta.F76411 
select * 
  from proddta.f76411@dc01.drogacenter.com.br;
commit ;

truncate table qadta.F76412;
insert into qadta.F76412 
select * 
  from proddta.f76412@dc01.drogacenter.com.br;
commit ;

-- REFERÊNCIA CRUZADA - EAN
truncate table qadta.F4104 ;
insert into qadta.F4104
select * 
 from proddta.F4104@dc01.drogacenter.com.br;
commit ;

--- CUSTO
truncate table qadta.F4105 ;
insert into qadta.F4105
select * 
 from proddta.F4105@dc01.drogacenter.com.br 
where comcu like '%DIF%';
commit;

--- PREÇOS
truncate table qadta.F4106 ;
insert into qadta.F4106
select * 
  from proddta.F4106@dc01.drogacenter.com.br;
commit;

--- LOTE
truncate table qadta.F4108 ;
insert into qadta.F4108
select * 
  from proddta.F4108@dc01.drogacenter.com.br 
 where iomcu in ('    DIFARCAT', '     DIFARMA') ;
commit;

truncate table qadta.F554108 ;
insert into qadta.F554108
select * 
  from proddta.F554108@dc01.drogacenter.com.br ;
commit;

--- UNIDADE DE MEDIDA
truncate table qadta.F41002 ;
insert into qadta.F41002
select * 
  from proddta.F41002@dc01.drogacenter.com.br ;
commit;

--- REGRA DE LOCAL
truncate table qadta.F4100T ;
insert into qadta.F4100T
select * 
 from proddta.F4100T@dc01.drogacenter.com.br;
commit;

--- Farmacia popular
truncate table qadta.F55410P ;
insert into qadta.F55410P
select * 
  from proddta.F55410P@dc01.drogacenter.com.br;
commit;

--- TRANSBORDO
truncate table qadta.F554901A ;
insert into qadta.F554901A
select * 
  from proddta.F554901A@dc01.drogacenter.com.br;
commit;

----------CADASTRO DE PESSOAS

truncate table qadta.F0101;
insert into qadta.F0101
select * 
  from proddta.F0101@dc01.drogacenter.com.br;
commit;

truncate table qadta.F0111;
insert into qadta.F0111
select * 
  from proddta.F0111@dc01.drogacenter.com.br;
commit;

truncate table qadta.F0115;
insert into qadta.F0115
select * 
  from proddta.F0115@dc01.drogacenter.com.br;
commit;

truncate table qadta.F0116;
insert into qadta.F0116
select * 
  from proddta.F0116@dc01.drogacenter.com.br;
commit;

truncate table qadta.F00165;
insert into qadta.F00165
select * 
  from proddta.F00165@dc01.drogacenter.com.br;
commit;

truncate table qadta.F03012;
insert into qadta.F03012
select * 
  from proddta.F03012@dc01.drogacenter.com.br;
commit;

truncate table qadta.F0030; 
insert into qadta.F0030 
select * 
  from proddta.F0030@dc01.drogacenter.com.br; 
commit; 


truncate table qadta.F5501015;
insert into qadta.F5501015
select * 
  from proddta.F5501015@dc01.drogacenter.com.br;
commit;

truncate table qadta.F5501019;
insert into qadta.F5501019
select * 
  from proddta.F5501019@dc01.drogacenter.com.br;
commit;
