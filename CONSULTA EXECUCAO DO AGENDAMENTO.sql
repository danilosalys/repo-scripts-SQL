select DM05_SERVICO,
       DM03_DESCRICAO,
       DM03_ULTIMAEXEC,
       DM05_GUID,
       DM05_SESSAOID,
       DM05_MSGID,
       DM05_MSGDATA,
       DM05_MSG,
       DM05_MSGTIPO
  from mercanet_prd.mdm05, mercanet_prd.mdm03
 where dm05_msgdata >
       TO_DATE('22/10/2012 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
   and dm03_guid = dm05_guid
   and dm03_grupo in ('IMPORT OL')
   AND DM05_SERVICO = 'DataManagerService05'
   AND DM05_SESSAOID = 3274
  -- AND DM05_MSG LIKE '%Ocorreu%'
   --AND DM05_GUID = 183 --INSERIR CODIGO DA GUID
 order by dm05_servico, dm05_guid, dm05_sessaoid, dm05_msgid
