SELECT DISTINCT EM01_CODIGO as "COD_VAN", 
                EM01_EAN as "NOME_VAN", 
                (SUBSTR(DM03_CONFIGSTRING,
                    INSTR(DM03_CONFIGSTRING, '\\', 1, 1)+2,
                    INSTR(DM03_CONFIGSTRING, '\', 1, 3) -
                    INSTR(DM03_CONFIGSTRING, '\\', 1, 1)-2))as "SERVIDOR",
                DM03_SERVICO as "INSTANCIA/SERVIÇO", 
                DM03_GUID as "CODIGO_AGENDAMENTO",
                DM03_DESCRICAO as "DESCRICAO_AGENDAMENTO"                
  FROM MERCANET_PRD.MDM03 a, MERCANET_PRD.MEM01
 WHERE DM03_GRUPO = 'IMPORT OL'
   AND DM03_ULTIMAEXEC > '01/01/2013'
   AND UPPER(SUBSTR(EM01_PASTABKP,
                    1,
                    INSTR(EM01_PASTABKP, '\', 1, 7) -
                    INSTR(EM01_PASTABKP, '\\', 1, 1))) =
       UPPER(SUBSTR(DM03_CONFIGSTRING,
                    INSTR(DM03_CONFIGSTRING, '\\', 1, 1),
                    INSTR(DM03_CONFIGSTRING, '\', 1, 7) -
                    INSTR(DM03_CONFIGSTRING, '\\', 1, 1)))
