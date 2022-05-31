SELECT DISTINCT (TRIM(FILTRO_SOZINHO))
  FROM (SELECT regexp_substr(PV06_IDENT, separador, 1, LEVEL) FILTRO_SOZINHO
          FROM (SELECT PV06_IDENT, '[^#]+' separador FROM MERCANET_QA.MPV06 WHERE PV06_POLITICA = 1029)
        CONNECT BY regexp_substr(PV06_IDENT, separador, 1, LEVEL) IS NOT NULL)
 WHERE 1 = 1
   AND TRIM(FILTRO_SOZINHO) = '25'


--EXPLICAÇAO DO COMANDO
--CREATE TABLE EMP (INFO VARCHAR2(100))
/*--select info from emp for update  ;
--INSERT INTO EMP VALUES( '2222;333;666;888;999;888;77;')

SELECT DISTINCT INFO FROM (
SELECT regexp_substr(info, separador, 1, LEVEL) info
FROM (SELECT info, '[^;]+' separador FROM emp)
CONNECT BY regexp_substr(info, separador, 1, LEVEL) IS NOT NULL)*/
