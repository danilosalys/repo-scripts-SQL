
select * from table(integracao.pkg_integracao.FNC_RELAC_CLIENTE( '05651966' , '2012904')) 

select * from table(integracao.pkg_integracao.FNC_CAD_CLIENTE(null, 34888,null,null,null,NULL ) )

select * from table(integracao.pkg_integracao.FNC_PRODUTO( null ,null,'SERVICOS DE TRANSPORTES'))

select * from table(integracao.pkg_integracao.FNC_NOTA_FISCAL(NULL , 580593 ,619358 ,0 ,114304))

select * from table(integracao.pkg_integracao.FNC_NOTA_FISCAL(NULL , null ,null ,null ,114304))

select * from table(integracao.pkg_integracao.FNC_NOTA_FISCAL_ITENS(NULL , 32,NULL ,7))

select * from table(integracao.pkg_integracao.FNC_MOT_DEVOLUCAO(null,null) )

select * from table(integracao.pkg_integracao.FNC_NOTA_FISCAL_DEVOL(null,null,null,null,null) )
