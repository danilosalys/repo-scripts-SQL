SELECT *
  FROM MDM05
 WHERE DM05_MSGDATA >
       to_date('26/06/2012 10:00:00', 'DD/MM/YYYY HH24:MI:SS')
       and dm05_servico = 'DataManagerService05'
       and dm05_guid = 184
 order by dm05_msgdata , dm05_sessaoid , dm05_msgid
 ;
 
 
 
 SELECT *
  FROM MDM05
  
 WHERE   DM05_MSGDATA >
       to_date('01/06/2012 10:00:00', 'DD/MM/YYYY HH24:MI:SS')
 and  DM05_MSG like '%ERRO Número 53%'-- - File not found na rotina SL_Conteudo_Arquivo na linha 10010'
      
    
 
 
