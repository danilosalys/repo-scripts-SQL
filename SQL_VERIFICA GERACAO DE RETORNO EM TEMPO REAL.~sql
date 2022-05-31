--PARA VERIFICAR EM TEMPO REAL, ATIVE O AUTO REFRESH TIMER

select * from mercanet_prd.db_edi_log_exp
where db_edile_id = (select max(db_edile_id)from mercanet_prd.db_edi_log_exp)
or db_edile_id =  (select max(db_edile_id)from mercanet_prd.db_edi_log_exp)-1
or db_edile_id =  (select max(db_edile_id)from mercanet_prd.db_edi_log_exp)-2
or db_edile_id =  (select max(db_edile_id)from mercanet_prd.db_edi_log_exp)-3
or db_edile_id =  (select max(db_edile_id)from mercanet_prd.db_edi_log_exp)-4
or db_edile_id =  (select max(db_edile_id)from mercanet_prd.db_edi_log_exp)-5
or db_edile_id =  (select max(db_edile_id)from mercanet_prd.db_edi_log_exp)-6
