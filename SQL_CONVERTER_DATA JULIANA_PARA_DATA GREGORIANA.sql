--JULIANO PARA GREGORIANO
select TO_DATE(SAUPMJ+1900000,'YYYYDDD')SAUPMJ 
from qadta.f5547011


--GREGORIANO PARA JULIANO 

----passando a data como parametro
select to_number(to_char(to_date('15/12/2014','dd/mm/yyyy'),'YYYYDDD')-1900000) as from dual 

----passando um campo data como parametro
select to_number(to_char(CAMPO_DATA,'YYYYDDD')-1900000) as from dual
