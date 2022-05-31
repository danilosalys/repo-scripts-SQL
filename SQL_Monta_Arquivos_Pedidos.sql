--------SCRIPT QUE MONTA COMANDOS DO DOS PARA CRIAR ARQUIVOS PARA TESTES DE PEDIDOS OL NO MERCANET
--------
--------
--1º) CRIAR UMA TABELA CONTENDO COLUNAS COM AS INFORMAÇÕES VARIAVEIS DO ARQUIVO, CONFORME ABAIXO.
--------
/*
--DROP TABLE MONTA_ARQUIVO;
CREATE TABLE MONTA_ARQUIVO 
       (LAYOUT NUMBER, 
        ID_ARQUIVO NUMBER, 
        CNPJ_FILIAL VARCHAR2(14),
        CNPJ_CLIENTE VARCHAR2(14), 
        ID_PRODUTO NUMBER, 
        CODIGO_PRODUTO VARCHAR2(15), 
        PED_MERCANET NUMBER ); 

alter table MONTA_ARQUIVO
  add constraint AAA primary key (ID_ARQUIVO, ID_PRODUTO);
  grant select on MONTA_ARQUIVO to dblink_dc10;  
 
Exemplo: Inserção de informações ref. a Três arquivos para teste:

INSERT INTO MONTA_ARQUIVO VALUES (529,1,'56016371000116',1,'14035');
INSERT INTO MONTA_ARQUIVO VALUES (529,1,'56016371000116',2,'10013');
INSERT INTO MONTA_ARQUIVO VALUES (529,1,'56016371000116',3,'13852');
INSERT INTO MONTA_ARQUIVO VALUES (529,2,'60184751002695',1,'12956');
INSERT INTO MONTA_ARQUIVO VALUES (529,2,'60184751002695',2,'43392');
INSERT INTO MONTA_ARQUIVO VALUES (529,2,'60184751002695',3,'13843');
INSERT INTO MONTA_ARQUIVO VALUES (529,3,'45100138000281',1,'38005');
INSERT INTO MONTA_ARQUIVO VALUES (529,3,'45100138000281',2,'42744');
INSERT INTO MONTA_ARQUIVO VALUES (529,3,'45100138000281',36,'40447');
INSERT INTO MONTA_ARQUIVO VALUES (517,4,'60204401000195',1,'40277');
INSERT INTO MONTA_ARQUIVO VALUES (517,4,'60204401000195',2,'5036');	
INSERT INTO MONTA_ARQUIVO VALUES (517,4,'60204401000195',3,'14463');	
INSERT INTO MONTA_ARQUIVO VALUES (517,5,'48628366000217',1,'40220');	
INSERT INTO MONTA_ARQUIVO VALUES (517,5,'48628366000217',2,'10002');	
INSERT INTO MONTA_ARQUIVO VALUES (517,5,'48628366000217',3,'11169');	
INSERT INTO MONTA_ARQUIVO VALUES (531,6,'79430682023688',1,'12909');
INSERT INTO MONTA_ARQUIVO VALUES (531,6,'79430682023688',2,'31562');	
INSERT INTO MONTA_ARQUIVO VALUES (531,6,'79430682023688',3,'45423');
INSERT INTO MONTA_ARQUIVO VALUES (531,7,'79430682023505',1,'40220');
INSERT INTO MONTA_ARQUIVO VALUES (531,7,'79430682023505',2,'10002');
INSERT INTO MONTA_ARQUIVO VALUES (531,7,'79430682023505',3,'11169');

Obs: Na coluna Codigo_produto, coloquei o codigo porque é a informação que tenho no meu teste, no entanto caso deseje 
já inserir direto o codigo de barras é uma opção melhor. Neste caso não seria necessário fazer o Join com a tabela de codigo 
de barras no Loop do Detail

SELECT * FROM MONTA_ARQUIVO;
Após inserir as informações na tabela, executar a procedure abaixo:*/

--DROP TABLE GERA_ARQUIVO; 
--CREATE TABLE GERA_ARQUIVO (LINHA  long); 

set feedback off
set echo off
set trimspool on
set termout off
set serveroutput on size 100000 format wrapped
set lines 500
set pages 0

-- create the bat file to be executed later:
spool C:\Users\danilo\Desktop\Utilidades\windows_commands.bat


-- Created on 10/02/2015 by DSALES 
DECLARE
  numero_pedido number(6) := 454500;
  cont_itens       number := 0;
  header1          varchar2(500);
  detail1          varchar2(500);
  registro4        varchar2(500);
  trailer          varchar2(500);
  diretorio        varchar2(100 ):= '&Diretório';      
  hora_nome_arq    date;
BEGIN
  FOR LAYOUT_ARQUIVO IN (SELECT DISTINCT VAN FROM MONTA_ARQUIVO) 
    LOOP
            IF LAYOUT_ARQUIVO.VAN = '529' THEN
              
                  FOR Head1 IN (SELECT DISTINCT ID_ARQUIVO,CNPJ_FILIAL, CNPJ_CLIENTE, DB_CLI_ESTADO  
                                  FROM MONTA_ARQUIVO, MERCANET_QA.DB_CLIENTE
                                WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                                  AND VAN = LAYOUT_ARQUIVO.VAN
                                ORDER BY ID_ARQUIVO) LOOP
                     header1 := 'echo 1;' || Head1.CNPJ_CLIENTE || ';SP;' ||TO_CHAR(SYSDATE, 'DDMMYYYY HH24MI') || ';' || numero_pedido ||Head1.ID_ARQUIVO || ';V;N;0;' ||TO_CHAR(SYSDATE, 'DDMMYYYY') || ';00000000'
                             ||' >> COTACAO_' || numero_pedido ||'_'|| Head1.ID_ARQUIVO ||'.txt'; --INSERE O HEADER1 NO ARQUIVO
                    dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
                          FOR Detail IN (SELECT CODIGO_PRODUTO,
                                                MAX(DB_PRDEMB_CODBARRA) AS CODBARRA
                                           FROM MONTA_ARQUIVO, MERCANET_QA.DB_PRODUTO_EMBAL
                                          WHERE ID_ARQUIVO = Head1.Id_Arquivo
                                            AND CNPJ_CLIENTE = Head1.Cnpj_Cliente
                                            AND CODIGO_PRODUTO = DB_PRDEMB_PRODUTO
                                          GROUP BY CODIGO_PRODUTO) LOOP
                            detail1 := 'echo 2;' || LPAD(Detail.Codbarra,13,' ') || ';' ||ROUND(DBMS_RANDOM.VALUE(1, 20)) 
                                    || ';0.0 >> COTACAO_' || numero_pedido ||'_'|| Head1.ID_ARQUIVO || '.txt'; --INSERE O DETAIL NO ARQUIVO
                            dbms_output.put_line(detail1);--IMPRIME O COMANDO NA TELA
                            cont_itens := cont_itens + 1; ---CONTAGEM DE ITENS INSERIDOS NO ARQUIVO (UTILIZADO NO TRAILER)
                          END LOOP;
                    dbms_output.put_line('echo 4;' || Head1.Cnpj_Cliente ||';'||Head1.Db_Cli_Estado --DADOS DO HEADER4
                         ||';0 >> COTACAO_' ||numero_pedido ||'_'|| Head1.ID_ARQUIVO || '.txt');
                    dbms_output.put_line('echo 9;' || cont_itens --DADOS DO HEADER9
                         || ';3.1 >> COTACAO_' ||numero_pedido ||'_'|| Head1.ID_ARQUIVO || '.txt');
                    dbms_output.put_line('MOVE '||'COTACAO_' ||numero_pedido ||'_'|| Head1.ID_ARQUIVO || '.txt '|| diretorio);--MOVE ARQUIVO PARA DIRETORIO     
                    cont_itens     := 0; -- ZERA CONTAGEM PARA O PROXIMO ARQUIVO
                    numero_pedido := numero_pedido + 1; --INCREMENTA O NUMERO DO PEDIDO
                  END LOOP;
                  
            ELSE IF LAYOUT_ARQUIVO.VAN = '517' THEN

                  FOR Head1 IN (SELECT DISTINCT ID_ARQUIVO,CNPJ_FILIAL,CNPJ_CLIENTE, DB_CLI_ESTADO
                                  FROM MONTA_ARQUIVO, MERCANET_QA.DB_CLIENTE
                                WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                                  AND VAN = LAYOUT_ARQUIVO.VAN
                                ORDER BY ID_ARQUIVO) LOOP

                    header1 := 'echo 1;' || Head1.CNPJ_CLIENTE || ';;' ||Head1.cnpj_filial|| ';;;' || numero_pedido ||Head1.ID_ARQUIVO || ';7.00'
                             ||' >> PEDIDO_0000' || numero_pedido ||'_'|| Head1.cnpj_filial ||'_GSK.txt'; --INSERE O HEADER1 NO ARQUIVO
                    dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
                          FOR Detail IN (SELECT CODIGO_PRODUTO,
                                                MAX(DB_PRDEMB_CODBARRA) AS CODBARRA
                                           FROM MONTA_ARQUIVO, MERCANET_QA.DB_PRODUTO_EMBAL
                                          WHERE ID_ARQUIVO = Head1.Id_Arquivo
                                            AND CNPJ_CLIENTE = Head1.Cnpj_Cliente
                                            AND CODIGO_PRODUTO = DB_PRDEMB_PRODUTO
                                          GROUP BY CODIGO_PRODUTO) LOOP
                            detail1 := 'echo 2;' || Detail.Codbarra || ';' ||ROUND(DBMS_RANDOM.VALUE(1, 20)) || ';15.00;;' 
                                    ||' >> PEDIDO_0000' || numero_pedido ||'_'|| Head1.cnpj_filial ||'_GSK.txt'; --INSERE O DETAIL NO ARQUIVO
                            dbms_output.put_line(detail1);--IMPRIME O COMANDO NA TELA
                            cont_itens := cont_itens + 1; ---CONTAGEM DE ITENS INSERIDOS NO ARQUIVO (UTILIZADO NO TRAILER)
                          END LOOP;
                    dbms_output.put_line('echo 9;' || cont_itens --DADOS DO HEADER9
                         ||' >> PEDIDO_0000' || numero_pedido ||'_'|| Head1.Cnpj_Filial||'_GSK.txt');
                    cont_itens     := 0; -- ZERA CONTAGEM PARA O PROXIMO ARQUIVO
                    numero_pedido := numero_pedido + 1; --INCREMENTA O NUMERO DO PEDIDO
                  END LOOP;
                dbms_output.put_line('echo');
                
               ELSE IF LAYOUT_ARQUIVO.VAN = '531' THEN

                  FOR Head1 IN (SELECT DISTINCT ID_ARQUIVO,CNPJ_FILIAL,CNPJ_CLIENTE, DB_CLI_ESTADO
                                  FROM MONTA_ARQUIVO, MERCANET_QA.DB_CLIENTE
                                WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                                  AND VAN = LAYOUT_ARQUIVO.VAN
                                ORDER BY ID_ARQUIVO) LOOP

                    hora_nome_arq := sysdate+1;

                    header1 := 'echo 019  001'||numero_pedido||'                                  201502130402201502130402201502130402                              7898950258014789893536347478989353645707898935363474'||Head1.cnpj_filial||Head1.CNPJ_CLIENTE|| '7943068200306779430682004896   00000000000000                              CIF'
                             ||' >> '||Head1.cnpj_filial||to_char(hora_nome_arq,'ddmmyyyyhh24mi')||Head1.ID_ARQUIVO||'.ped'; --INSERE O HEADER1 NO ARQUIVO
                    dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
                    dbms_output.put_line('echo 021  5  1  CD 0632015041700000000001586310000' --DADOS DO HEADER2
                             ||' >> '||Head1.cnpj_filial||to_char(hora_nome_arq,'ddmmyyyyhh24mi')||Head1.ID_ARQUIVO||'.ped'); --INSERE O HEADER2 NO ARQUIVO
                    dbms_output.put_line('echo 03000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' --DADOS DO HEADER2
                             ||' >> '||Head1.cnpj_filial||to_char(hora_nome_arq,'ddmmyyyyhh24mi')||Head1.ID_ARQUIVO||'.ped'); --INSERE O HEADER2 NO ARQUIVO
                          FOR Detail IN (SELECT CODIGO_PRODUTO,
                                                MAX(DB_PRDEMB_CODBARRA) AS CODBARRA
                                           FROM MONTA_ARQUIVO, MERCANET_QA.DB_PRODUTO_EMBAL
                                          WHERE ID_ARQUIVO = Head1.Id_Arquivo
                                            AND CNPJ_CLIENTE = Head1.Cnpj_Cliente
                                            AND CODIGO_PRODUTO = DB_PRDEMB_PRODUTO
                                          GROUP BY CODIGO_PRODUTO) LOOP
                            detail1 := 'echo 04000000000   EN ' || LPAD(Detail.Codbarra,13,' ') || '                                                             EA 00001000000000000'||ROUND(DBMS_RANDOM.VALUE(1, 9)) || '00000000000000000000000000000000   0000000000000000000000000000000000000000000000000000000000000000000000   0000000000000000000000000000000000000000000000000000000000000000000000000000000000000' 
                                    ||' >> '||Head1.cnpj_filial||to_char(hora_nome_arq,'ddmmyyyyhh24mi')||Head1.ID_ARQUIVO||'.ped'; --INSERE O detail NO ARQUIVO
                            dbms_output.put_line(detail1);--IMPRIME O COMANDO NA TELA
                            cont_itens := cont_itens + 1; ---CONTAGEM DE ITENS INSERIDOS NO ARQUIVO (UTILIZADO NO TRAILER)
                          END LOOP;
                    dbms_output.put_line('echo 09000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' || cont_itens --DADOS DO HEADER9
                         ||' >> '||Head1.cnpj_filial||to_char(hora_nome_arq,'ddmmyyyyhh24mi')||Head1.ID_ARQUIVO||'.ped'); --INSERE O trailer NO ARQUIVO
                    cont_itens     := 0; -- ZERA CONTAGEM PARA O PROXIMO ARQUIVO
                    numero_pedido := numero_pedido + 1; --INCREMENTA O NUMERO DO PEDIDO
                  END LOOP;
                dbms_output.put_line('echo');
                ELSE 
                  dbms_output.put_line('echo');
            END IF;
            END IF; 
            END IF;
     END LOOP;
  dbms_output.put_line('echo');
END;
/
spool off;

/*A procedure irá retornar os comandos de criação do arquivo. Abrir o MS-DOS, escolher uma pasta destino e colar os comandos 
retornados pela procedure para que os arquivos sejam criados. */


/* 
--------------------
--------------------
PARA EFETUAR AS COMBINAÇÕES DE TODOS OS CENÁRIOS DO TESTE CRIAR UMA TABELA CONTENDO UM SEQUENCIAL E O NOME DO OBJETO DE TESTE 
A SER COMBINADO. POR EXEMPLO: 

PARA EFETUAR AS COMBINAÇÕES DE  1 e 2  com A e B com * e @

TABELA Numeros (id1,1,2)
TABELA Letras (id1,A , B)
TABELA Simbolos(id1,*,@)

Efetuar o join entre as três tabelas a partir do campo id (que é igual pra todos).Isto resultará em um Produto Cartesiano contendo 
todas as combinações. A partir disto basta extrair os cenários a serem testados. 
---------------------
---------------------

--OUTRO EXEMPLO: 

CREATE TABLE CLIENTE (seq number, cliente varchar2(20)) ; 

CREATE TABLE CANAL_CAPTACAO(seq number, canal varchar2(10)); 

CREATE TABLE PERFIL_VENDA(seq number, perfil_venda varchar2(10)); 

CREATE TABLE TIPO_PRODUTO (seq number, tipo_produto varchar2(15));

CREATE TABLE TIPO_PRODUTO_SRP8 (seq number, srp8 varchar2(15));

CREATE TABLE CLASSIFICACAO_PRODUTO (seq number, classificacao varchar2(50));


select * 
  from cliente a,
       canal_captacao b, 
       perfil_venda c, 
       tipo_produto d, 
       tipo_produto_srp8 e, 
       classificacao_produto f
where a.seq = b.seq
  and b.seq = c.seq
  and c.seq = d.seq
  and d.seq = e.seq
  and e.seq = f.seq
order by a.cliente, b.canal , c.perfil_venda, d.tipo_produto,e.srp8, f.classificacao
*/

