

--CONSULTA ULTIMOS SQLS EXECUTADOS - QUE AINDA ESTÃO NA MEMORIA ACESSIVEL DO ORACLE
select * from v$sql
where parsing_schema_name = 'MERCANET_QA'
and module = 'Mercador.exe'
order by last_active_time desc;


--===================== FUNÇÃO RETORNA O MAIOR / MENOR ======================================
--

SELECT GREATEST(1,50) FROM DUAL; --RETORNA MAIOR

SELECT LEAST(30,60) FROM DUAL; --RETORNA MENOR 

--===================== AGRUPAR LINHAS EM UNICA COLUNA ======================================

SELECT RTRIM(XMLAGG(XMLELEMENT(e, CAMPO||'delimitador' )).extract('//text()'),',') 
FROM (SELECT 1 AS CAMPO FROM DUAL
       UNION
      SELECT 2 AS CAMPO FROM DUAL
       UNION 
      SELECT 3 AS CAMPO FROM DUAL);
      
      
     
--CONCATENAR GRANDES TEXTOS:  XMLElement("DEMANDS",XMLAGG(XMLELEMENT(e, GC02_SQL )ORDER BY GC02_SEQ ).extract('//text()')).getClobVal()
      
--============================= CONVERSÃO DE DATAS ==========================================
--JULIANO PARA GREGORIANO

select TO_DATE(TO_CHAR(CAMPO_DATA_JULIANO + 1900000), 'YYYYDDD') FROM DUAL


from qadta.f5547011

--GREGORIANO PARA JULIANO 

----passando a data como parametro
select to_number(to_char(to_date('15/12/2014','dd/mm/yyyy'),'YYYYDDD')-1900000) as from dual 

----passando um campo data como parametro
select to_number(to_char(CAMPO_DATA,'YYYYDDD')-1900000) as from dual


--=========== VERIFICA SE O CAMPO CONTÉM VALORES NUMERICOS OU ALFANUMERICO ===================

--SE RETORNAR NULL É NUMERICO, SENÃO É ALFANUMERICO

SELECT  LENGTH(TRIM(TRANSLATE('123456A', ' +-.0123456789', ' '))) FROM DUAL
       
       
       
--=========== CONTAGEM DE NUMERO DE CARACTERES EM UMA CADEIRA DE CARACTERES ==================

select (length('abracadabra') - length(replace('abracadabra', 'a')))
  from dual;