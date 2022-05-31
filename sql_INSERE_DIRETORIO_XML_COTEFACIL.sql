/*CREATE TABLE CLIENTES_ANALISE_XML(XMLCNPJ VARCHAR2(14) PRIMARY KEY, XMLAN8 NUMBER) ;*/

/*--Inserir os cnpj e codigo do clients
SELECT  * FROM CLIENTES_ANALISE_XML FOR UPDATE;*/

--PROBLEMAS DE CADASTRO DE ENDEREÇOS ELETRONICOS C/ AS RESPECTIVAS TRATATIVAS
SELECT ABAN8 as CODIGO_CLIENTE, ABAT1, ABTAX CNPJ, ABALPH RAZAO_SOCIAL, ABAC16 ESTADO , TRATATIVA /*, 
 'insert into proddta.f01151 values ('||ABAN8||*/
  FROM PRODDTA.F0101, 
(
select xmlan8,
       'Não possui cadastro nenhuma na tela de Endereços Eletrônicos: CADASTRAR DIRETORIO' AS "TRATATIVA"
  from CLIENTES_ANALISE_XML
 where xmlan8 not in
       (SELECT distinct eaan8
          FROM PRODDTA.f01151
         WHERE EAAN8 IN (select XMLAN8 from CLIENTES_ANALISE_XML))
UNION
select xmlan8,
       'Não possui o diretório C:\XML\COTEFACIL cadastrado na tela de Endereços Eletrônicos: CADASTRAR DIRETÓRIO ' AS "TRATATIVA"
  from CLIENTES_ANALISE_XML
 where xmlan8 in
       (SELECT distinct eaan8
          FROM PRODDTA.f01151
         WHERE EAAN8 IN (select XMLAN8 from CLIENTES_ANALISE_XML)
           AND eaan8 NOT IN
               (SELECT distinct eaan8
                  FROM PRODDTA.f01151
                 WHERE EAAN8 IN (select XMLAN8 from CLIENTES_ANALISE_XML)
                   AND TRIM(EAETP) = 'D'))
UNION
select xmlan8,
       'Possui diretorio diferente de "c:\xml\cotefacil" na tela de E-Mails: TROCAR DIRETORIO, OU ENVIAR MANUALMENTE OS ARQUIVOS' as "TRATATIVA"
  from CLIENTES_ANALISE_XML
 where xmlan8 in
       (SELECT distinct eaan8
          FROM PRODDTA.f01151
         WHERE EAAN8 IN (select XMLAN8 from CLIENTES_ANALISE_XML)
           AND eaan8 in
               (SELECT distinct eaan8
                  FROM PRODDTA.f01151
                 WHERE EAAN8 IN (select XMLAN8 from CLIENTES_ANALISE_XML)
                   AND TRIM(EAETP) = 'D')
           AND eaan8 NOT IN
               (SELECT distinct eaan8
                  FROM PRODDTA.f01151
                 WHERE EAAN8 IN (select XMLAN8 from CLIENTES_ANALISE_XML)
                   AND TRIM(EAETP) = 'D'
                   AND upper(EAEMAL) LIKE upper('%cot%')))) CLIENTES_PROBLEMA
where aban8 = xmlan8
  and ABALPH not like '%UNIMED%'
  and ABALPH not like '%USIMED%'
  and abac05 <> 'DRO'; 


/*--Após analisar, apagar a tabela temporária 
DROP TABLE CLIENTES_ANALISE_XML;
*/

--COMANDO DE INSERT DO DIRETORIO

/*'insert into proddta.f01151 
     values ( '||eaan8 || ', 0 ,'|| TO_CHAR(max(earck7)+1) || ', ''D   '' , 
              ''C:\xml\cotefacil\'' , ''DSALES'' , ''SQL       '' , 
              ''116174'' , ''Manual    '' , ''160000'');'*/




