select DB_EDIS_CODIGO,
       DB_EDIS_SREG,
       DB_EDIS_TIPO,
       DB_EDIS_CAMPO,
       DB_EDIS_POSI,
       DB_EDIS_POSF,
       DB_EDIS_FORMATO,
       DB_EDIS_CONTEUDO
  from db_edi_lregsai
 WHERE DB_EDIS_CODIGO = ('PHL_PED')