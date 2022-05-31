
SELECT DB_RESR_SEQPAI,
       RTRIM(XMLAGG(XMLELEMENT(e, DB_RESR_VALOR || ';') ORDER BY DB_RESR_SEQ)
             .extract('//text()'),
             ',') || (SELECT DB_CPO_VALORINF
                        FROM MERCANET_PRD.DB_CPO_ATRIB
                       WHERE DB_CPO_CODIGO = DB_RESR_CODIGO
                         AND DB_CPO_RES_PAI = DB_RESR_SEQPAI)
  FROM MERCANET_PRD.DB_RESTR_REGRAS T1
 WHERE T1.DB_RESR_CODIGO = 1035
 GROUP BY DB_RESR_CODIGO, DB_RESR_SEQPAI