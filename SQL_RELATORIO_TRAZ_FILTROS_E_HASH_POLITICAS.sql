WITH TAB1 AS 
(SELECT /*+ MATERIALIZE */ PV05_CONTROLE,
      rtrim(xmlagg(xmlelement(e,
      trim(pv05_tagfiltro) || '#') ORDER BY
 PV05_SEQ) .extract('//text()'),
      ',')
      filtros 
FROM MPV05 TB_FILTROS GROUP BY
 PV05_CONTROLE),
      TAB2 AS 
(SELECT /*+ MATERIALIZE */ DISTINCT PV06_POLITICA,
      PV06_CONTROLE,
      PV06_TIPO,
      PV06_IDENT,
      PV06_IDREGRA 
FROM MPV06 
WHERE PV06_TIPO = 'A') SELECT TAB3.DB_ORDP_SEQUENCIA AS "ORDEM DE BUSCA",
      TAB2.PV06_POLITICA AS "POLITICA",
      REPLACE(SUBSTR(TAB1.FILTROS,
      1,
      LENGTH(TAB1.FILTROS) - 1),
      '#',
      ' | ') AS "FILTROS UTILIZADOS",
      REPLACE(TAB2.PV06_IDENT,
      '#',
      ' | ') AS "VALORES FILTRADOS",
      TAB4.DB_CPO_TAGATRIB AS "CAMPO ATRIBUIDO",
      TAB4.DB_CPO_VALORINF AS "VALOR ATRIBUIDO",
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

FROM TAB1,
      TAB2,
      DB_ORDEM_POLITICAS TAB3,
      DB_CPO_ATRIB TAB4 
WHERE TAB2.PV06_TIPO = 'A' 
AND TAB2.PV06_CONTROLE = TAB1.PV05_CONTROLE 
AND TAB2.PV06_POLITICA = TAB3.DB_ORDP_POLITICA 
AND TAB2.PV06_POLITICA = TAB4.DB_CPO_CODIGO 
AND TAB2.PV06_IDREGRA = TAB4.DB_CPO_RES_PAI 
--AND PV06_IDENT LIKE REPLACE(REPLACE(TRANSLATE('[10]', '())', ' '),' ',''),SUBSTR(REPLACE(TRANSLATE('[10]', '())', ' '),' ',''),1,15),'%')||'%'
--AND TAB1.FILTROS LIKE REPLACE(REPLACE(TRANSLATE('[11]', '())', ' '),' ',''),SUBSTR(REPLACE(TRANSLATE('[11]', '())', ' '),' ',''),1,17),'%')||'%'
--AND TAB4.DB_CPO_TAGATRIB LIKE REPLACE(REPLACE(TRANSLATE('[12]', '())', ' '),' ',''),SUBSTR(REPLACE(TRANSLATE('[12]', '())', ' '),' ',''),1,25),'%')||'%'
--AND TAB4.DB_CPO_VALORINF LIKE REPLACE(REPLACE(TRANSLATE('[13]', '())', ' '),' ',''),SUBSTR(REPLACE(TRANSLATE('[13]', '())', ' '),' ',''),1,25),'%')||'%'
ORDER BY
 TAB3.DB_ORDP_SEQUENCIA,
 TAB2.PV06_POLITICA,
 TAB2.PV06_CONTROLE,
 TAB2.PV06_IDENT
