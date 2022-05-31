create table seven_comp_ped  (cnpjs_ped varchar(30) );
create table seven_comp_ret (cnpjs_ret varchar(30))

alter table seven_comp_ped add(ean_ped varchar(30))
alter table seven_comp_ret add(ean_ret varchar (30))

/*select * from seven_comp_ret for update */
/*select * from seven_comp_ped for update */

select A.*, B.*, C.db_prdemb_produto
  from seven_comp_ped A, seven_comp_ret B, db_produto_embal C
 where cnpjs_ped = cnpjs_ret(+)
   and ean_ped = ean_ret(+)
   and db_prdemb_codbarra(+) = ean_ped
