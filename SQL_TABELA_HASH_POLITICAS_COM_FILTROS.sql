WITH TAB1 AS
 (SELECT /*+ MATERIALIZE */
   PV05_CONTROLE,
   rtrim(xmlagg(xmlelement(e, trim(pv05_tagfiltro) || '#'))
         .extract('//text()'),
         ',') filtros
    FROM MERCANET_QA.MPV05 TB_FILTROS
   GROUP BY PV05_CONTROLE),
TAB2 AS
 (SELECT /*+ MATERIALIZE */
  DISTINCT PV06_POLITICA, PV06_CONTROLE, PV06_TIPO, PV06_IDENT
    FROM MERCANET_QA.MPV06
   WHERE PV06_TIPO = 'A')
SELECT PV06_POLITICA AS "POLITICA",
       PV06_CONTROLE AS "CONTROLE",
       REPLACE(SUBSTR(TAB1.FILTROS, 1, LENGTH(TAB1.FILTROS) - 1),'#',' | ') AS "FILTROS UTILIZADOS",
       REPLACE (TAB2.PV06_IDENT,'#',' | ') AS "VALORES FILTRADOS"
  FROM TAB2, TAB1
 WHERE PV06_TIPO = 'A'
   AND PV06_CONTROLE = TAB1.PV05_CONTROLE
 ORDER BY PV06_POLITICA, PV06_CONTROLE, PV06_IDENT
 -- COMPARATIVO DE TOTAL DE FILTROS COM TOTAL DE VALORES FILTRADOS
       length(REPLACE(SUBSTR(TAB1.FILTROS,
      1,
      LENGTH(TAB1.FILTROS) - 1),
      '#',
      ' | ')) - length(replace(REPLACE(SUBSTR(TAB1.FILTROS,
      1,
      LENGTH(TAB1.FILTROS) - 1),
      '#',
      ' | '),
      '|',
      null)) + 1 AS "Total DE Filtros",
      length(REPLACE(TAB2.PV06_IDENT,
      '#',
      ' | ')) - length(replace(REPLACE(TAB2.PV06_IDENT,
      '#',
      ' | '),
      '|',
      null)) + 1 AS "Total DE Valores Filtrados" 
 

