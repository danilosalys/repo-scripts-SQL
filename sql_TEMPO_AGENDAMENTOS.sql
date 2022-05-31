SELECT DM03_SERVICO, DM03_DESCRICAO, DM05_GUID, MAX("DIFF(Minutos)") MAIOR_TEMPO,MIN("DIFF(Minutos)") MENOR_TEMPO
 FROM (
SELECT B.DM03_SERVICO, 
       B.DM03_DESCRICAO, 
       A.DM05_GUID, 
       A.DM05_SESSAOID, 
       (select dm05_msgdata from mercanet_prd.mdm05 c
         where a.dm05_guid = c.dm05_guid
           and a.dm05_sessaoid = c.dm05_sessaoid
           and dm05_msgid = 1) as Hora_inicio_Sessao,
       (select max(dm05_msgdata) from mercanet_prd.mdm05 c
         where a.dm05_guid = c.dm05_guid
           and a.dm05_sessaoid = c.dm05_sessaoid) as Hora_Fim_Sessao,           
       round(((select max(dm05_msgdata) from mercanet_prd.mdm05 c
         where a.dm05_guid = c.dm05_guid
           and a.dm05_sessaoid = c.dm05_sessaoid) -           
       (select dm05_msgdata from mercanet_prd.mdm05 c
         where a.dm05_guid = c.dm05_guid
           and a.dm05_sessaoid = c.dm05_sessaoid
           and dm05_msgid = 1))*1440,2) as "DIFF(Minutos)"    
 FROM MERCANET_PRD.MDM05 A , MERCANET_PRD.MDM03 B
WHERE DM05_MSGDATA BETWEEN
       TO_DATE('02/09/2016 00:00:00', 'DD/MM/YYYY HH24:MI:SS') AND
       TO_DATE('05/09/2016 14:20:00', 'DD/MM/YYYY HH24:MI:SS')
  AND DM03_GUID = DM05_GUID
group by B.DM03_SERVICO, 
       B.DM03_DESCRICAO, 
       A.DM05_GUID, 
       A.DM05_SESSAOID) 
group by DM03_SERVICO, DM03_DESCRICAO, DM05_GUID
