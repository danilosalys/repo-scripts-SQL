select 'INSERT INTO MERCANET_HML.DB_EDI_LREGISTRO VALUES'||
       '(''NEOGRID_PED'','|| DB_EDIR_TIPO||','||DB_EDIR_SEQ||','||
       ''''||DB_EDIR_CAMPO||''','||DB_EDIR_POSI||','||DB_EDIR_POSF||','||
       DB_EDIR_FORMATO||','||DB_EDIR_NRODEL||','||
       CASE WHEN DB_EDIR_CONDICAO IS NULL THEN 'NULL' ELSE ''''||DB_EDIR_CONDICAO||'''' END ||','||
       DB_EDIR_UTILIZACAO||','||DB_EDIR_ORIGEM||');'       
FROM mercanet_HML.db_edi_lregistro
where db_edir_codigo = 'NISSEI_PED';