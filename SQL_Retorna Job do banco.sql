
select a.job as "Id Job",
      case
        when a.broken = 'N' then
         null
        else
         'Parado'
      end as "Status Job",
      case when a.what like '%20%' or a.what like '%87%' then 'Cliente,Rede' else
      case when a.what like '%21%' then 'Cliente Atrib' else
      case when a.what like '%29%' then 'Cliente e Repres' else
      case when a.what like '%30%' then 'Retorno Pedido' else
      case when a.what like '%35%' then 'Retorno NF' else
      case when a.what like '%90007%' then 'Retorno NF Lote' else
      case when a.what like '%40%' then 'Produto' else
      case when a.what like '%42%' then 'Preco' else
      case when a.what like '%41%' then 'Cod Barra' else   
      case when a.what like '%8005%' then 'Representante' else   
      case when a.what like '%8004%' or a.what like '%49%' or a.what like '%48%' or a.what like '%8003%' then 'Familia,tpprod,marca,grupo' else
      case when a.what like '%90001%' then 'Produto Atrib' else   
      case when a.what like '%90006%' then 'Atributos' else   
      case when a.what like '%90004%' then 'Cliente Obs' else   
      case when a.what like '%54%' then 'Estoque' else          
      case when a.what like '%MERCP_CONCORRENTE_EXPORT%' then 'Exp Ped Merc p/ Jde' else
      case when a.what like '%MERCP_LIMPA_INTERFACE%' then 'Limpeza Interfaces' 
      end end end end end end end end end end end end end end end end end as "Job",
      a.last_date as "Data Ultima Exec",
      a.this_date as "Data Executando",
      a.next_date as "Data Prox Exec",
      a.what as "Procedure"
 from dba_jobs a
where a.schema_user = 'MERCANET_QA' -- Schema
AND a.what like '%MERCP_CONCORRENTE_EXPORT%'
