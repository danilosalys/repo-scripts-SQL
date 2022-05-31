SELECT DB_PROG_CODIGO AS CODIGO_PROGRAMACAO,
       DB_PROG_DESCRICAO AS DESCRICAO_PROGRAMACAO,
       DB_PROGP_SEQAPLIC AS SEQUENCIA_APLIC_POLITICA,
       DB_PROGP_POLITICA AS CODIGO_POLITICA,
       --DB_PROGC_CLIENTE AS CLIENTE_PROGRAMACAO,
       DESCRICAO, 
       "FILTROS UTILIZADOS",
       "VALORES FILTRADOS",
       "MENSAGEM DA RESTRICAO",
       "DATA ULTIMA ALTERACAO NA REGRA",
       "STATUS DA REGRA"
        FROM (SELECT *
  FROM MERCANET_PRD.DB_PROG_AJUSTE,
       MERCANET_PRD.DB_PROGA_POLITICAS,
       --MERCANET_PRD.DB_PROGA_CLIENTES,
       (WITH TAB1 AS (SELECT PV05_CONTROLE,
                       rtrim(xmlagg(xmlelement(e, trim(pv05_tagfiltro) || '#') ORDER BY PV05_SEQ)
                             .extract('//text()'),
                             ',') filtros
                        FROM MERCANET_PRD.MPV05 TB_FILTROS
                       GROUP BY PV05_CONTROLE), 
             TAB2 AS (SELECT DISTINCT PV06_POLITICA,
                                     PV06_CONTROLE,
                                     PV06_TIPO,
                                     PV06_IDENT,
                                     PV06_QTDEMIN,
                                     PV06_QTDEMAX,
                                     PV06_VALMIN,
                                     PV06_VALMAX,
                                     PV06_DATA_ALTER,
                                     PV06_MSGERRO
                           FROM MERCANET_PRD.MPV06
                          WHERE PV06_TIPO IN ('R'))
         SELECT TAB2.PV06_POLITICA AS "POLITICA",
                TAB5.DB_RES_DESC AS "DESCRICAO",
                REPLACE(SUBSTR(TAB1.FILTROS, 1, LENGTH(TAB1.FILTROS) - 1),
                        '#',
                        ' | ') || (CASE
                                     WHEN (SELECT COUNT(1)
                                             FROM MERCANET_PRD.MPV06 T1
                                            WHERE T1.PV06_POLITICA = TAB2.PV06_POLITICA
                                              AND T1.PV06_QTDEMIN > 0) > 0 THEN
                                      ' | QTDE MIN | QTDE MAX'
                                     ELSE
                                      CASE
                                        WHEN (SELECT COUNT(1)
                                                FROM MERCANET_PRD.MPV06 T1
                                               WHERE T1.PV06_POLITICA = TAB2.PV06_POLITICA
                                                 AND T1.PV06_PRAZOMIN > 0) > 0 THEN
                                         ' | PRAZO MIN | PRAZO MAX'
                                        ELSE
                                         CASE
                                           WHEN (SELECT COUNT(1)
                                                   FROM MERCANET_PRD.MPV06 T1
                                                  WHERE T1.PV06_POLITICA = TAB2.PV06_POLITICA
                                                    AND T1.PV06_VALMIN > 0) > 0 THEN
                                            ' | VALOR MIN | VALOR MAX'
                                         END
                                      END
                                   END) AS "FILTROS UTILIZADOS",
                REPLACE(TAB2.PV06_IDENT, '#', ' | ') ||
                (CASE
                   WHEN (SELECT COUNT(1)
                           FROM MERCANET_PRD.MPV06 T1
                          WHERE T1.PV06_POLITICA = TAB2.PV06_POLITICA
                            AND T1.PV06_QTDEMIN > 0) > 0 THEN
                    (SELECT ' | ' || trim(to_char(PV06_QTDEMIN)) || ' | ' ||
                            trim(to_char(PV06_QTDEMAX))
                       FROM MERCANET_PRD.MPV06 T2
                      WHERE T2.PV06_POLITICA = TAB2.PV06_POLITICA
                        AND T2.PV06_IDENT = TAB2.PV06_IDENT
                        AND T2.PV06_CONTROLE = TAB2.PV06_CONTROLE
                        AND T2.PV06_TIPO = TAB2.PV06_TIPO
                        AND ROWNUM = 1)
                   ELSE
                    CASE
                      WHEN (SELECT COUNT(1)
                              FROM MERCANET_PRD.MPV06 T1
                             WHERE T1.PV06_POLITICA = TAB2.PV06_POLITICA
                               AND T1.PV06_PRAZOMIN > 0) > 0 THEN
                       (SELECT ' | ' || trim(to_char(PV06_PRAZOMIN)) || ' | ' ||
                               trim(to_char(PV06_PRAZOMAX))
                          FROM MERCANET_PRD.MPV06 T2
                         WHERE T2.PV06_POLITICA = TAB2.PV06_POLITICA
                           AND T2.PV06_IDENT = TAB2.PV06_IDENT
                           AND T2.PV06_CONTROLE = TAB2.PV06_CONTROLE
                           AND T2.PV06_TIPO = TAB2.PV06_TIPO
                           AND ROWNUM = 1)
                      ELSE
                       CASE
                         WHEN (SELECT COUNT(1)
                                 FROM MERCANET_PRD.MPV06 T1
                                WHERE T1.PV06_POLITICA = TAB2.PV06_POLITICA
                                  AND T1.PV06_VALMIN > 0) > 0 THEN
                          (SELECT ' | ' || trim(to_char(PV06_VALMIN, '9990D99')) ||
                                  ' | ' || trim(to_char(PV06_VALMAX, '9990D99'))
                             FROM MERCANET_PRD.MPV06 T2
                            WHERE T2.PV06_POLITICA = TAB2.PV06_POLITICA
                              AND T2.PV06_IDENT || T2.PV06_VALMIN || T2.PV06_VALMAX =
                                  TAB2.PV06_IDENT || TAB2.PV06_VALMIN ||
                                  TAB2.PV06_VALMAX
                              AND T2.PV06_CONTROLE = TAB2.PV06_CONTROLE
                              AND T2.PV06_TIPO = TAB2.PV06_TIPO
                              AND ROWNUM = 1)
                         ELSE
                          NULL
                       END
                    END
                 END) AS "VALORES FILTRADOS",
                 TAB2.PV06_MSGERRO AS "MENSAGEM DA RESTRICAO",
                length(REPLACE(SUBSTR(TAB1.FILTROS,
                                      1,
                                      LENGTH(TAB1.FILTROS) - 1),
                               '#',
                               ' | ')) -
                length(replace(REPLACE(SUBSTR(TAB1.FILTROS,
                                              1,
                                              LENGTH(TAB1.FILTROS) - 1),
                                       '#',
                                       ' | '),
                               '|',
                               null)) + 1 AS "Total DE Filtros",
                length(REPLACE(TAB2.PV06_IDENT, '#', ' | ')) -
                length(replace(REPLACE(TAB2.PV06_IDENT, '#', ' | '),
                               '|',
                               null)) + 1 AS "Total DE Valores Filtrados",
                pv06_data_alter AS "DATA ULTIMA ALTERACAO NA REGRA",
                CASE
                  WHEN TAB5.DB_RES_DTINI < SYSDATE AND
                       TAB5.DB_RES_DTFIM > SYSDATE THEN
                   'VIGENTE'
                  ELSE
                   'INATIVA'
                END AS "STATUS DA REGRA"
           FROM TAB1, 
                TAB2, 
                MERCANET_PRD.DB_RESTRICAO TAB5
          WHERE TAB2.PV06_POLITICA = TAB5.DB_RES_CODIGO
            AND TAB2.PV06_CONTROLE = TAB1.PV05_CONTROLE
            AND TAB1.FILTROS LIKE REPLACE('%#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101901]',17)||'#%','%##%','%')
            AND TAB1.FILTROS LIKE REPLACE('%#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101902]',17)||'#%','%##%','%')
            AND TAB1.FILTROS LIKE REPLACE('%#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101903]',17)||'#%','%##%','%')
            AND TAB1.FILTROS LIKE REPLACE('%#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101904]',17)||'#%','%##%','%')
            AND TAB1.FILTROS LIKE REPLACE('%#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101905]',17)||'#%','%##%','%')
               
            AND (PV06_IDENT LIKE REPLACE('%#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101906]',15)||'#%','%##%','%')
     AND (CASE WHEN MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101901]',17) IS NULL OR 
					(MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101901]',17) IS NOT NULL AND 
					 MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101906]',15) IS NULL) THEN 1 ELSE 
         ((LENGTH(TAB1.FILTROS)-LENGTH(REPLACE(TAB1.FILTROS,'#',NULL)))-
         (LENGTH(SUBSTR(TAB1.FILTROS,INSTR(TAB1.FILTROS,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101901]',17)||'#'),LENGTH(TAB1.FILTROS)))-LENGTH(REPLACE(SUBSTR(TAB1.FILTROS,INSTR(TAB1.FILTROS,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101901]',17)||'#'),LENGTH(TAB1.FILTROS)),'#',NULL)))) END) 
         = 
         (CASE WHEN MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101901]',17) IS NULL OR 
					(MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101901]',17) IS NOT NULL AND 
					 MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101906]',15) IS NULL) THEN 1 ELSE
         ((LENGTH(PV06_IDENT)-LENGTH(REPLACE(PV06_IDENT,'#',NULL)))-
         (LENGTH(SUBSTR(PV06_IDENT,INSTR(PV06_IDENT,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101906]',15)||'#'),LENGTH(PV06_IDENT)))-LENGTH(REPLACE(SUBSTR(PV06_IDENT,INSTR(PV06_IDENT,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101906]',15)||'#'),LENGTH(PV06_IDENT)),'#',NULL))))END))
AND (PV06_IDENT LIKE REPLACE('%#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101907]',15)||'#%','%##%','%')
     AND (CASE WHEN MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101902]',17) IS NULL OR 
					(MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101902]',17) IS NOT NULL AND 
					 MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101907]',15) IS NULL) THEN 1 ELSE 
         ((LENGTH(TAB1.FILTROS)-LENGTH(REPLACE(TAB1.FILTROS,'#',NULL)))-
         (LENGTH(SUBSTR(TAB1.FILTROS,INSTR(TAB1.FILTROS,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101902]',17)||'#'),LENGTH(TAB1.FILTROS)))-LENGTH(REPLACE(SUBSTR(TAB1.FILTROS,INSTR(TAB1.FILTROS,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101902]',17)||'#'),LENGTH(TAB1.FILTROS)),'#',NULL)))) END) 
         = 
         (CASE WHEN MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101902]',17) IS NULL OR 
					(MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101902]',17) IS NOT NULL AND 
					 MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101907]',15) IS NULL) THEN 1 ELSE
         ((LENGTH(PV06_IDENT)-LENGTH(REPLACE(PV06_IDENT,'#',NULL)))-
         (LENGTH(SUBSTR(PV06_IDENT,INSTR(PV06_IDENT,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101907]',15)||'#'),LENGTH(PV06_IDENT)))-LENGTH(REPLACE(SUBSTR(PV06_IDENT,INSTR(PV06_IDENT,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101907]',15)||'#'),LENGTH(PV06_IDENT)),'#',NULL))))END))
AND (PV06_IDENT LIKE REPLACE('%#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101908]',15)||'#%','%##%','%')
     AND (CASE WHEN MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101903]',17) IS NULL OR 
					(MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101903]',17) IS NOT NULL AND 
					 MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101908]',15) IS NULL) THEN 1 ELSE 
         ((LENGTH(TAB1.FILTROS)-LENGTH(REPLACE(TAB1.FILTROS,'#',NULL)))-
         (LENGTH(SUBSTR(TAB1.FILTROS,INSTR(TAB1.FILTROS,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101903]',17)||'#'),LENGTH(TAB1.FILTROS)))-LENGTH(REPLACE(SUBSTR(TAB1.FILTROS,INSTR(TAB1.FILTROS,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101903]',17)||'#'),LENGTH(TAB1.FILTROS)),'#',NULL)))) END) 
         = 
         (CASE WHEN MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101903]',17) IS NULL OR 
					(MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101903]',17) IS NOT NULL AND 
					 MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101908]',15) IS NULL) THEN 1 ELSE
         ((LENGTH(PV06_IDENT)-LENGTH(REPLACE(PV06_IDENT,'#',NULL)))-
         (LENGTH(SUBSTR(PV06_IDENT,INSTR(PV06_IDENT,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101908]',15)||'#'),LENGTH(PV06_IDENT)))-LENGTH(REPLACE(SUBSTR(PV06_IDENT,INSTR(PV06_IDENT,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101908]',15)||'#'),LENGTH(PV06_IDENT)),'#',NULL))))END))
AND (PV06_IDENT LIKE REPLACE('%#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101909]',15)||'#%','%##%','%')
     AND (CASE WHEN MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101904]',17) IS NULL OR 
					(MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101904]',17) IS NOT NULL AND 
					 MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101909]',15) IS NULL) THEN 1 ELSE 
         ((LENGTH(TAB1.FILTROS)-LENGTH(REPLACE(TAB1.FILTROS,'#',NULL)))-
         (LENGTH(SUBSTR(TAB1.FILTROS,INSTR(TAB1.FILTROS,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101904]',17)||'#'),LENGTH(TAB1.FILTROS)))-LENGTH(REPLACE(SUBSTR(TAB1.FILTROS,INSTR(TAB1.FILTROS,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101904]',17)||'#'),LENGTH(TAB1.FILTROS)),'#',NULL)))) END) 
         = 
         (CASE WHEN MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101904]',17) IS NULL OR 
					(MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101904]',17) IS NOT NULL AND 
					 MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101909]',15) IS NULL) THEN 1 ELSE
         ((LENGTH(PV06_IDENT)-LENGTH(REPLACE(PV06_IDENT,'#',NULL)))-
         (LENGTH(SUBSTR(PV06_IDENT,INSTR(PV06_IDENT,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101909]',15)||'#'),LENGTH(PV06_IDENT)))-LENGTH(REPLACE(SUBSTR(PV06_IDENT,INSTR(PV06_IDENT,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101909]',15)||'#'),LENGTH(PV06_IDENT)),'#',NULL))))END))
AND (PV06_IDENT LIKE REPLACE('%#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101910]',15)||'#%','%##%','%')
     AND (CASE WHEN MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101905]',17) IS NULL OR 
					(MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101905]',17) IS NOT NULL AND 
					 MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101910]',15) IS NULL) THEN 1 ELSE 
         ((LENGTH(TAB1.FILTROS)-LENGTH(REPLACE(TAB1.FILTROS,'#',NULL)))-
         (LENGTH(SUBSTR(TAB1.FILTROS,INSTR(TAB1.FILTROS,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101905]',17)||'#'),LENGTH(TAB1.FILTROS)))-LENGTH(REPLACE(SUBSTR(TAB1.FILTROS,INSTR(TAB1.FILTROS,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101905]',17)||'#'),LENGTH(TAB1.FILTROS)),'#',NULL)))) END) 
         = 
         (CASE WHEN MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101905]',17) IS NULL OR 
					(MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101905]',17) IS NOT NULL AND 
					 MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101910]',15) IS NULL) THEN 1 ELSE
         ((LENGTH(PV06_IDENT)-LENGTH(REPLACE(PV06_IDENT,'#',NULL)))-
         (LENGTH(SUBSTR(PV06_IDENT,INSTR(PV06_IDENT,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101910]',15)||'#'),LENGTH(PV06_IDENT)))-LENGTH(REPLACE(SUBSTR(PV06_IDENT,INSTR(PV06_IDENT,'#'||MERCANET_PRD.FNC_PESQUISA_HASH_REL_1020('[101910]',15)||'#'),LENGTH(PV06_IDENT)),'#',NULL))))END))

          ORDER BY TAB2.PV06_POLITICA, TAB2.PV06_CONTROLE, TAB2.PV06_IDENT)
          WHERE "POLITICA" = DB_PROGP_POLITICA
            --AND DB_PROG_CODIGO = DB_PROGC_CODIGO
            AND DB_PROG_CODIGO = DB_PROGP_CODIGO
            AND DB_PROG_CODIGO = '&PROGRAMACAO_AJUSTE'
            --AND DB_PROGC_CLIENTE = '&CLIENTE'
          ORDER BY DB_PROG_CODIGO,DB_PROGP_SEQAPLIC, "VALORES FILTRADOS")
