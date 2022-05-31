  SELECT CASE WHEN (NVL((SELECT COUNT(*) FROM DB_CLIENTE 
   WHERE DB_CLI_CGCMF IN(
       (select TO_CHAR(substr(SUB.DB_EDILD_CONTEUDO_REG4,
                              instr(SUB.DB_EDILD_CONTEUDO_REG4, ';', 1, 1) + 1,
                              (instr(SUB.DB_EDILD_CONTEUDO_REG4, ';', 1, 2)) -
                              (instr(SUB.DB_EDILD_CONTEUDO_REG4, ';', 1, 1) + 1))) CNPJ
          from (select substr(DB_EDILD_CONTEUDO,
                              instr(DB_EDILD_CONTEUDO, chr(10) || '4', 1, 1) + 1,
                              (instr(DB_EDILD_CONTEUDO,
                                     chr(10),
                                     instr(DB_EDILD_CONTEUDO,
                                           chr(10) || '4',
                                           1,
                                           1) + 1,
                                     1) - 1) -
                              (instr(DB_EDILD_CONTEUDO, chr(10) || '4', 1, 1) + 1)) DB_EDILD_CONTEUDO_REG4,
                       DB_EDILD_SEQ
                  from DB_EDI_LOTE_DISTR) SUB
         where DB_EDIP_LOTE = SUB.DB_EDILD_SEQ))),0)) > 0 THEN 'S' ELSE 'N' END
FROM DB_EDI_PEDIDO 
WHERE DB_EDIP_LOTE = 83539