
select 'INSERT INTO MERCANET_PRD.DB_PEDIDO_COMPL (db_pedc_nro,db_pedc_ec_debito,db_pedc_ec_credit,db_pedc_descto_fin, db_pedc_cpgto_vend, db_pedc_emp_ent,db_pedc_prev_fat,db_pedc_dtdigi, db_pedc_dtdigf,db_pedc_usu_cria,db_pedc_lote,db_pedc_versaodig, db_pedc_lab,db_pedc_pbm) VALUES ('|| db_ped_nro ||', ''0'',''0'', ''0'','||db_ped_cond_pgto||','||db_ped_empresa||','''||to_date(db_ped_dt_emissao,'dd/mm/yyyy')|| ''','''||to_date(db_ped_dt_emissao,'dd/mm/yyyy')||''','''||to_date(db_ped_dt_emissao,'dd/mm/yyyy')||''',''Manager'',''0'',''4'','|| (select db_edip_labcod  from mercanet_prd.db_edi_pedido where db_edip_pedmerc = db_ped_nro)||', ''0'')'
from mercanet_prd.db_pedido 
where not exists (select * from mercanet_prd.db_pedido_compl
                   where db_ped_nro =  db_pedc_nro)
 and db_ped_nro = 84083321; 
 

