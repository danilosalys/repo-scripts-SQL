DROP TABLE MONTA_ARQUIVO;

CREATE TABLE MONTA_ARQUIVO 
       (VAN NUMBER, 
        ID_ARQUIVO NUMBER, 
        CNPJ_FILIAL VARCHAR2(14),
        CNPJ_CLIENTE VARCHAR2(14), 
        ID_PRODUTO NUMBER, 
        CODIGO_PRODUTO VARCHAR2(15)); 
alter table MONTA_ARQUIVO
  add constraint AAA primary key (ID_ARQUIVO, ID_PRODUTO);
  grant select on MONTA_ARQUIVO to dblink_dc10;  

INSERT INTO MONTA_ARQUIVO VALUES (529,1,'05651966001265','03344528000176',1,'11860');
INSERT INTO MONTA_ARQUIVO VALUES (529,1,'05651966001265','03344528000176',2,'12152');
INSERT INTO MONTA_ARQUIVO VALUES (529,1,'05651966001265','03344528000176',3,'12500');
INSERT INTO MONTA_ARQUIVO VALUES (529,2,'05651966000102','37614336000154',1,'10196');
INSERT INTO MONTA_ARQUIVO VALUES (529,2,'05651966000102','37614336000154',2,'10444');
INSERT INTO MONTA_ARQUIVO VALUES (529,2,'05651966000102','37614336000154',3,'11795');
INSERT INTO MONTA_ARQUIVO VALUES (529,3,'05651966000617','41737271000101',2,'11747');
INSERT INTO MONTA_ARQUIVO VALUES (529,3,'05651966000617','41737271000101',3,'11795');
INSERT INTO MONTA_ARQUIVO VALUES (529,3,'05651966000617','41737271000101',4,'12152');
INSERT INTO MONTA_ARQUIVO VALUES (529,4,'05651966000960','00100374002041',1,'10196');
INSERT INTO MONTA_ARQUIVO VALUES (529,4,'05651966000960','00100374002041',2,'11747');
INSERT INTO MONTA_ARQUIVO VALUES (529,4,'05651966000960','00100374002041',3,'30653');
/*
Obs: Na coluna Codigo_produto, coloquei o codigo porque é a informação que tenho no meu teste, no entanto caso deseje 
já inserir direto o codigo de barras é uma opção melhor. Neste caso não seria necessário fazer o Join com a tabela de codigo 
de barras no Loop do Detail
*/
set feedback off
set echo off
set trimspool on
set termout off
set serveroutput on size 100000 format wrapped
set lines 500
set pages 0

-- create the bat file to be executed later:
spool '&Pasta_Geração_Comandos'

-- Created on 10/02/2015 by DSALES 
DECLARE
  numero_pedido number(6) := 585800;
  cont_itens    number := 0;
  header1       varchar2(1000);
  header2       varchar2(1000);
  header3       varchar2(1000);
  header4       varchar2(1000);
  detail1       varchar2(1000);
  registro4     varchar2(1000);
  trailer       varchar2(1000);
  diretorio     varchar2(100) := '&Diretório';
  hora_nome_arq date;
  type tVetor is varray(6) of number;
  qtde_linhas_seven tVetor;
  nomearqsp_seven   varchar2(1000);
  nomearqgo_seven   varchar2(1000);
  nomearqmg_seven   varchar2(1000);
  nomearqrj_seven   varchar2(1000);
  nomearqpr_seven   varchar2(1000);
  nomearqdf_seven   varchar2(1000);

BEGIN

  FOR LAYOUT_ARQUIVO IN (SELECT DISTINCT VAN FROM MONTA_ARQUIVO) LOOP
    IF LAYOUT_ARQUIVO.VAN = '529' THEN
    
      FOR Head1 IN (SELECT DISTINCT ID_ARQUIVO,
                                    CNPJ_FILIAL,
                                    CNPJ_CLIENTE,
                                    DB_CLI_ESTADO
                      FROM MONTA_ARQUIVO, MERCANET_QA.DB_CLIENTE
                     WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                       AND VAN = LAYOUT_ARQUIVO.VAN
                     ORDER BY ID_ARQUIVO) LOOP
        header1 := 'echo 1;' || Head1.CNPJ_CLIENTE || ';SP;' ||
                   TO_CHAR(SYSDATE, 'DDMMYYYY HH24MI') || ';' ||
                   numero_pedido || Head1.ID_ARQUIVO || ';V;N;0;' ||
                   TO_CHAR(SYSDATE, 'DDMMYYYY') || ';00000000' ||
                   ' >> COTACAO_' || numero_pedido || '_' ||
                   Head1.ID_ARQUIVO || '.txt'; --INSERE O HEADER1 NO ARQUIVO
        dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
        FOR Detail IN (SELECT CODIGO_PRODUTO,
                              MAX(DB_PRDEMB_CODBARRA) AS CODBARRA
                         FROM MONTA_ARQUIVO, MERCANET_QA.DB_PRODUTO_EMBAL
                        WHERE ID_ARQUIVO = Head1.Id_Arquivo
                          AND CNPJ_CLIENTE = Head1.Cnpj_Cliente
                          AND CODIGO_PRODUTO = DB_PRDEMB_PRODUTO
                        GROUP BY CODIGO_PRODUTO) LOOP
          detail1 := 'echo 2;' || LPAD(Detail.Codbarra, 13, ' ') || ';' ||
                     ROUND(DBMS_RANDOM.VALUE(1, 20)) || ';0.0 >> COTACAO_' ||
                     numero_pedido || '_' || Head1.ID_ARQUIVO || '.txt'; --INSERE O DETAIL NO ARQUIVO
          dbms_output.put_line(detail1); --IMPRIME O COMANDO NA TELA
          cont_itens := cont_itens + 1; ---CONTAGEM DE ITENS INSERIDOS NO ARQUIVO (UTILIZADO NO TRAILER)
        END LOOP;
        dbms_output.put_line('echo 4;' || Head1.Cnpj_Cliente || ';' ||
                             Head1.Db_Cli_Estado --DADOS DO HEADER4
                             || ';0 >> COTACAO_' || numero_pedido || '_' ||
                             Head1.ID_ARQUIVO || '.txt');
        dbms_output.put_line('echo 9;' || cont_itens --DADOS DO HEADER9
                             || ';3.1 >> COTACAO_' || numero_pedido || '_' ||
                             Head1.ID_ARQUIVO || '.txt');
        dbms_output.put_line('MOVE ' || 'COTACAO_' || numero_pedido || '_' ||
                             Head1.ID_ARQUIVO || '.txt ' || diretorio); --MOVE ARQUIVO PARA DIRETORIO     
        cont_itens    := 0; -- ZERA CONTAGEM PARA O PROXIMO ARQUIVO
        numero_pedido := numero_pedido + 1; --INCREMENTA O NUMERO DO PEDIDO
      END LOOP;
    
    ELSE
      IF LAYOUT_ARQUIVO.VAN = '517' THEN
        FOR Head1 IN (SELECT DISTINCT ID_ARQUIVO,
                                      CNPJ_FILIAL,
                                      CNPJ_CLIENTE,
                                      DB_CLI_ESTADO
                        FROM MONTA_ARQUIVO, MERCANET_QA.DB_CLIENTE
                       WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                         AND VAN = LAYOUT_ARQUIVO.VAN
                       ORDER BY ID_ARQUIVO) LOOP
        
          header1 := 'echo 1;' || Head1.CNPJ_CLIENTE || ';;' ||
                     Head1.cnpj_filial || ';;;' || numero_pedido ||
                     Head1.ID_ARQUIVO || ';7.00' || ' >> PEDIDO_0000' ||
                     numero_pedido || '_' || Head1.cnpj_filial ||
                     '_GSK.txt'; --INSERE O HEADER1 NO ARQUIVO
          dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
          FOR Detail IN (SELECT CODIGO_PRODUTO,
                                MAX(DB_PRDEMB_CODBARRA) AS CODBARRA
                           FROM MONTA_ARQUIVO, MERCANET_QA.DB_PRODUTO_EMBAL
                          WHERE ID_ARQUIVO = Head1.Id_Arquivo
                            AND CNPJ_CLIENTE = Head1.Cnpj_Cliente
                            AND CODIGO_PRODUTO = DB_PRDEMB_PRODUTO
                          GROUP BY CODIGO_PRODUTO) LOOP
            detail1 := 'echo 2;' || LPAD(Detail.Codbarra, 13, ' ') || ';' ||
                       ROUND(DBMS_RANDOM.VALUE(1, 20)) || ';15.00;;' ||
                       ' >> PEDIDO_0000' || numero_pedido || '_' ||
                       Head1.cnpj_filial || '_GSK.txt'; --INSERE O DETAIL NO ARQUIVO
            dbms_output.put_line(detail1); --IMPRIME O COMANDO NA TELA
            cont_itens := cont_itens + 1; ---CONTAGEM DE ITENS INSERIDOS NO ARQUIVO (UTILIZADO NO TRAILER)
          END LOOP;
          dbms_output.put_line('echo 9;' || cont_itens --DADOS DO HEADER9
                               || ' >> PEDIDO_0000' || numero_pedido || '_' ||
                               Head1.Cnpj_Filial || '_GSK.txt');
          dbms_output.put_line('MOVE ' || 'PEDIDO_0000' || numero_pedido || '_' ||
                               Head1.cnpj_filial || '_GSK.txt ' ||
                               diretorio); --MOVE ARQUIVO PARA DIRETORIO
          cont_itens    := 0; -- ZERA CONTAGEM PARA O PROXIMO ARQUIVO
          numero_pedido := numero_pedido + 1; --INCREMENTA O NUMERO DO PEDIDO
        END LOOP;
        dbms_output.put_line('echo');
      
      ELSE
        IF LAYOUT_ARQUIVO.VAN = '531' THEN
        
          FOR Head1 IN (SELECT DISTINCT ID_ARQUIVO,
                                        CNPJ_FILIAL,
                                        CNPJ_CLIENTE,
                                        DB_CLI_ESTADO
                          FROM MONTA_ARQUIVO, MERCANET_QA.DB_CLIENTE
                         WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                           AND VAN = LAYOUT_ARQUIVO.VAN
                         ORDER BY ID_ARQUIVO) LOOP
          
            hora_nome_arq := sysdate + 1;
          
            header1 := 'echo 019  001' || numero_pedido ||
                       '                                  201502130402201502130402201502130402                              7898950258014789893536347478989353645707898935363474' ||
                       Head1.cnpj_filial || Head1.CNPJ_CLIENTE ||
                       '7943068200306779430682004896   00000000000000                              CIF' ||
                       ' >> ' || Head1.cnpj_filial ||
                       to_char(hora_nome_arq, 'ddmmyyyyhh24mi') ||
                       Head1.ID_ARQUIVO || '.ped'; --INSERE O HEADER1 NO ARQUIVO
            dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
            dbms_output.put_line('echo 021  5  1  CD 0632015041700000000001586310000' --DADOS DO HEADER2
                                 || ' >> ' || Head1.cnpj_filial ||
                                 to_char(hora_nome_arq, 'ddmmyyyyhh24mi') ||
                                 Head1.ID_ARQUIVO || '.ped'); --INSERE O HEADER2 NO ARQUIVO
            dbms_output.put_line('echo 03000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' --DADOS DO HEADER2
                                 || ' >> ' || Head1.cnpj_filial ||
                                 to_char(hora_nome_arq, 'ddmmyyyyhh24mi') ||
                                 Head1.ID_ARQUIVO || '.ped'); --INSERE O HEADER2 NO ARQUIVO
            FOR Detail IN (SELECT CODIGO_PRODUTO,
                                  MAX(DB_PRDEMB_CODBARRA) AS CODBARRA
                             FROM MONTA_ARQUIVO,
                                  MERCANET_QA.DB_PRODUTO_EMBAL
                            WHERE ID_ARQUIVO = Head1.Id_Arquivo
                              AND CNPJ_CLIENTE = Head1.Cnpj_Cliente
                              AND CODIGO_PRODUTO = DB_PRDEMB_PRODUTO
                            GROUP BY CODIGO_PRODUTO) LOOP
              detail1 := 'echo 04000000000   EN ' ||
                         LPAD(Detail.Codbarra, 13, ' ') ||
                         '                                                             EA 00001000000000000' ||
                         ROUND(DBMS_RANDOM.VALUE(1, 9)) ||
                         '00000000000000000000000000000000   0000000000000000000000000000000000000000000000000000000000000000000000   0000000000000000000000000000000000000000000000000000000000000000000000000000000000000' ||
                         ' >> ' || Head1.cnpj_filial ||
                         to_char(hora_nome_arq, 'ddmmyyyyhh24mi') ||
                         Head1.ID_ARQUIVO || '.ped'; --INSERE O detail NO ARQUIVO
              dbms_output.put_line(detail1); --IMPRIME O COMANDO NA TELA
              cont_itens := cont_itens + 1; ---CONTAGEM DE ITENS INSERIDOS NO ARQUIVO (UTILIZADO NO TRAILER)
            END LOOP;
            dbms_output.put_line('echo 09000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' ||
                                 cont_itens --DADOS DO HEADER9
                                 || ' >> ' || Head1.cnpj_filial ||
                                 to_char(hora_nome_arq, 'ddmmyyyyhh24mi') ||
                                 Head1.ID_ARQUIVO || '.ped'); --INSERE O trailer NO ARQUIVO
            cont_itens := 0; -- ZERA CONTAGEM PARA O PROXIMO ARQUIVO
            dbms_output.put_line('MOVE ' || Head1.cnpj_filial ||
                                 to_char(hora_nome_arq, 'ddmmyyyyhh24mi') ||
                                 Head1.ID_ARQUIVO || '.ped  ' || diretorio); --MOVE ARQUIVO PARA DIRETORIO     
            numero_pedido := numero_pedido + 1; --INCREMENTA O NUMERO DO PEDIDO
          END LOOP;
          dbms_output.put_line('echo');
        ELSE
          IF LAYOUT_ARQUIVO.VAN = '504' THEN
          
            FOR Head1 IN (SELECT DISTINCT ID_ARQUIVO,
                                          CNPJ_FILIAL,
                                          CNPJ_CLIENTE,
                                          DB_CLI_ESTADO
                            FROM MONTA_ARQUIVO, MERCANET_QA.DB_CLIENTE
                           WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                             AND VAN = LAYOUT_ARQUIVO.VAN
                           ORDER BY ID_ARQUIVO) LOOP
            
              header1 := 'echo 10' || Head1.CNPJ_CLIENTE || '0000' ||
                         numero_pedido || '0000000000' ||
                         TO_CHAR(SYSDATE, 'DDMMYYYY') || CASE
                           WHEN Head1.Db_Cli_Estado = 'SP' and Head1.Cnpj_Filial = '05156966000102' then
                            'I'
                           else
                            'E'
                         end || 'C0' || Head1.cnpj_filial || '000000' ||
                         ' >> PEDFAR_0000' || numero_pedido ||
                         '0000000000.txt'; --INSERE O HEADER1 NO ARQUIVO
              dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
              FOR Detail IN (SELECT CODIGO_PRODUTO,
                                    MAX(DB_PRDEMB_CODBARRA) AS CODBARRA
                               FROM MONTA_ARQUIVO,
                                    MERCANET_QA.DB_PRODUTO_EMBAL
                              WHERE ID_ARQUIVO = Head1.Id_Arquivo
                                AND CNPJ_CLIENTE = Head1.Cnpj_Cliente
                                AND CODIGO_PRODUTO = DB_PRDEMB_PRODUTO
                              GROUP BY CODIGO_PRODUTO) LOOP
                detail1 := 'echo 20000' || numero_pedido || '0000000000' ||
                           LPAD(Detail.Codbarra, 13, ' ') ||
                           LPAD(ROUND(DBMS_RANDOM.VALUE(1, 10)), 5, '0') ||
                           '0000002000035ZZ' || ' >> PEDFAR_0000' ||
                           numero_pedido || '0000000000.txt'; --INSERE O DETAIL NO ARQUIVO
                dbms_output.put_line(detail1); --IMPRIME O COMANDO NA TELA
                cont_itens := cont_itens + 1; ---CONTAGEM DE ITENS INSERIDOS NO ARQUIVO (UTILIZADO NO TRAILER)
              END LOOP;
              dbms_output.put_line('echo 30000' || numero_pedido ||
                                   '0000000000' ||
                                   LPAD(cont_itens, 5, '0') ||
                                   '0000000000' --DADOS DO HEADER9
                                   || ' >> PEDFAR_0000' || numero_pedido ||
                                   '0000000000.txt');
              cont_itens := 0; -- ZERA CONTAGEM PARA O PROXIMO ARQUIVO
              dbms_output.put_line('MOVE ' || 'PEDFAR_0000' ||
                                   numero_pedido || '0000000000.txt  ' ||
                                   diretorio); --MOVE ARQUIVO PARA DIRETORIO     
              numero_pedido := numero_pedido + 1; --INCREMENTA O NUMERO DO PEDIDO
            END LOOP;
            dbms_output.put_line('echo');
          ELSE
            IF LAYOUT_ARQUIVO.VAN = '540' THEN
            
              FOR Head1 IN (SELECT DISTINCT ID_ARQUIVO,
                                            CNPJ_FILIAL,
                                            CNPJ_CLIENTE,
                                            DB_CLI_ESTADO
                              FROM MONTA_ARQUIVO, MERCANET_QA.DB_CLIENTE
                             WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                               AND VAN = LAYOUT_ARQUIVO.VAN
                             ORDER BY ID_ARQUIVO) LOOP
              
                header1 := 'echo 01221' || TO_CHAR(Head1.CNPJ_CLIENTE) ||
                           TO_CHAR(Head1.CNPJ_CLIENTE) || CASE
                             WHEN Head1.Db_Cli_Estado = 'SP' and Head1.Cnpj_Filial = '05156966000102' then
                              '02'
                             else
                              '01'
                           end || '00PHLINK' || '0090' ||
                           '0000000000000000000000000000000000000000000000' ||
                           ' >> PHL0090' || Head1.Cnpj_Filial ||
                           LPAD(numero_pedido, 10, 0) ||
                           TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '.TXT';
              
                header2 := 'echo 02X  ' || LPAD(numero_pedido, 10, '0') ||
                           '0000000000' || '000000000000000' ||
                           Head1.Cnpj_Filial ||
                           '000000000000000000000000000000000000000' ||
                           ' >> PHL0090' || Head1.Cnpj_Filial ||
                           LPAD(numero_pedido, 10, '0') ||
                           TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '.TXT';
              
                header3 := 'echo 03' || '02' || '0000' || '000' ||
                           '0000000000000000000000000000000000000000000000000000000000000000000000000000000000' ||
                           ' >> PHL0090' || Head1.Cnpj_Filial ||
                           LPAD(numero_pedido, 10, '0') ||
                           TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '.TXT';
              
                header4 := 'echo 04' ||
                           TO_CHAR(SYSDATE, 'DDMMYYYYHH24MISS') ||
                           TO_CHAR(SYSDATE, 'DDMMYYYYHH24MISS') ||
                           TO_CHAR(SYSDATE, 'DDMMYYYYHH24MISS') ||
                           TO_CHAR(SYSDATE, 'DDMMYYYY') ||
                           '00000000000000000000000000000000000000000' ||
                           ' >> PHL0090' || Head1.Cnpj_Filial ||
                           LPAD(numero_pedido, 10, '0') ||
                           TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '.TXT';
              
                dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
                dbms_output.put_line(header2); --IMPRIME O COMANDO NA TELA
                dbms_output.put_line(header3); --IMPRIME O COMANDO NA TELA              
                dbms_output.put_line(header4); --IMPRIME O COMANDO NA TELA              
              
                FOR Detail IN (SELECT CODIGO_PRODUTO,
                                      MAX(DB_PRDEMB_CODBARRA) AS CODBARRA
                                 FROM MONTA_ARQUIVO,
                                      MERCANET_QA.DB_PRODUTO_EMBAL
                                WHERE ID_ARQUIVO = Head1.Id_Arquivo
                                  AND CNPJ_CLIENTE = Head1.Cnpj_Cliente
                                  AND CODIGO_PRODUTO = DB_PRDEMB_PRODUTO
                                GROUP BY CODIGO_PRODUTO) LOOP
                  detail1 := 'echo 05' || LPAD(Detail.Codbarra, 13, ' ') ||
                             '00000000000000000000000000' ||
                             LPAD(ROUND(DBMS_RANDOM.VALUE(1, 10)), 10, '0') ||
                             '    ' || '02000' ||
                             '000000000000000000000000000000000' ||
                             ' >> PHL0090' || Head1.Cnpj_Filial ||
                             LPAD(numero_pedido, 10, '0') ||
                             TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '.TXT'; --INSERE O DETAIL NO ARQUIVO
                  dbms_output.put_line(detail1); --IMPRIME O COMANDO NA TELA
                  cont_itens := cont_itens + 1; ---CONTAGEM DE ITENS INSERIDOS NO ARQUIVO (UTILIZADO NO TRAILER)
                END LOOP;
                dbms_output.put_line('echo 06' || LPAD(cont_itens, 5, '0') ||
                                     '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000' ||
                                     ' >> PHL0090' || Head1.Cnpj_Filial ||
                                     LPAD(numero_pedido, 10, '0') ||
                                     TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') ||
                                     '.TXT'); --INSERE O DETAIL NO ARQUIVO
                cont_itens := 0; -- ZERA CONTAGEM PARA O PROXIMO ARQUIVO
                dbms_output.put_line('MOVE ' || 'PHL0090' ||
                                     Head1.Cnpj_Filial ||
                                     LPAD(numero_pedido, 10, '0') ||
                                     TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') ||
                                     '.TXT ' || diretorio); --MOVE ARQUIVO PARA DIRETORIO     
                numero_pedido := numero_pedido + 1; --INCREMENTA O NUMERO DO PEDIDO
              END LOOP;
              dbms_output.put_line('echo');
            ELSE
              IF LAYOUT_ARQUIVO.VAN = '508' THEN
              
                qtde_linhas_seven := tVetor(0, 0, 0, 0, 0, 0); --REINICIALIZA A CONTAGEM DE QTDE DE LINHAS SEVENPDV
              
                --Pos1 = Qtde Linhas arquivo filial 05651966000455 - SP
                --Pos2 = Qtde Linhas arquivo filial 05651966000102 - GO
                --Pos3 = Qtde Linhas arquivo filial 05651966000617 - MG
                --Pos4 = Qtde Linhas arquivo filial 05651966000960 - RJ
                --Pos5 = Qtde Linhas arquivo filial 05651966001184 - PR
                --Pos6 = Qtde Linhas arquivo filial 05651966001265 - DF
              
                FOR Head1 IN (SELECT DISTINCT ID_ARQUIVO,
                                              CNPJ_FILIAL,
                                              CNPJ_CLIENTE,
                                              DB_CLI_ESTADO
                                FROM MONTA_ARQUIVO, MERCANET_QA.DB_CLIENTE
                               WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                                 AND VAN = LAYOUT_ARQUIVO.VAN
                               ORDER BY ID_ARQUIVO) LOOP
                
                  FOR Detail IN (SELECT CODIGO_PRODUTO,
                                        MAX(DB_PRDEMB_CODBARRA) AS CODBARRA
                                   FROM MONTA_ARQUIVO,
                                        MERCANET_QA.DB_PRODUTO_EMBAL
                                  WHERE ID_ARQUIVO = Head1.Id_Arquivo
                                    AND CNPJ_CLIENTE = Head1.Cnpj_Cliente
                                    AND CODIGO_PRODUTO = DB_PRDEMB_PRODUTO
                                  GROUP BY CODIGO_PRODUTO) LOOP
                  
                    IF Head1.Db_Cli_Estado = 'SP' THEN
                    
                      nomearqsp_seven := ' SP' || numero_pedido ||
                                         Head1.Cnpj_Filial || 'LGX' ||
                                         TO_CHAR(SYSDATE, 'YYYYMMDDHH24MI_') ||
                                         '000000' || '.TTT';
                      header1 := 'echo ' || Head1.Cnpj_Cliente ||
                                 LPAD(Detail.Codbarra, 13, ' ') || '24' ||
                                 LPAD(ROUND(DBMS_RANDOM.VALUE(1, 10)),
                                      4,
                                      '0') || '0200002000' ||
                                 'A99000000000000000' || ' >> ' ||
                                 nomearqsp_seven; --INSERE A LINHA NO ARQUIVO
                      qtde_linhas_seven(1) := qtde_linhas_seven(1) + 1;
                    
                      dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
                      dbms_output.put_line('COPY /Y ' || nomearqsp_seven || ' ' ||
                                           diretorio); --MOVE ARQUIVO PARA DIRETORIO    
                    
                    ELSE
                      IF Head1.Db_Cli_Estado = 'GO' THEN
                        nomearqgo_seven := ' SP' || numero_pedido ||
                                           Head1.Cnpj_Filial || 'LGX' ||
                                           TO_CHAR(SYSDATE,
                                                   'YYYYMMDDHH24MI_') ||
                                           '000000' || '.TTT';
                        header1 := 'echo ' || Head1.Cnpj_Cliente ||
                                   LPAD(Detail.Codbarra, 13, ' ') || '24' ||
                                   LPAD(ROUND(DBMS_RANDOM.VALUE(1, 10)),
                                        4,
                                        '0') || '0200002000' ||
                                   'A99000000000000000' || ' >> ' ||
                                   nomearqgo_seven; --INSERE A LINHA NO ARQUIVO
                        qtde_linhas_seven(2) := qtde_linhas_seven(2) + 1;
                      
                        dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
                      
                        dbms_output.put_line('COPY /Y ' || nomearqgo_seven || ' ' ||
                                             diretorio); --MOVE ARQUIVO PARA DIRETORIO       
                      ELSE
                        IF Head1.Db_Cli_Estado = 'MG' THEN
                          nomearqmg_seven := ' SP' || numero_pedido ||
                                             Head1.Cnpj_Filial || 'LGX' ||
                                             TO_CHAR(SYSDATE,
                                                     'YYYYMMDDHH24MI_') ||
                                             '000000' || '.TTT';
                          header1 := 'echo ' || Head1.Cnpj_Cliente ||
                                     LPAD(Detail.Codbarra, 13, ' ') || '24' ||
                                     LPAD(ROUND(DBMS_RANDOM.VALUE(1, 10)),
                                          4,
                                          '0') || '0200002000' ||
                                     'A99000000000000000' || ' >> ' ||
                                     nomearqmg_seven; --INSERE A LINHA NO ARQUIVO
                          qtde_linhas_seven(3) := qtde_linhas_seven(3) + 1;
                          dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
                          dbms_output.put_line('COPY /Y ' ||
                                               nomearqmg_seven || ' ' ||
                                               diretorio); --MOVE ARQUIVO PARA DIRETORIO     
                        ELSE
                          IF Head1.Db_Cli_Estado = 'RJ' THEN
                            nomearqrj_seven := ' SP' || numero_pedido ||
                                               Head1.Cnpj_Filial || 'LGX' ||
                                               TO_CHAR(SYSDATE,
                                                       'YYYYMMDDHH24MI_') ||
                                               '000000' || '.TTT';
                            header1 := 'echo ' || Head1.Cnpj_Cliente ||
                                       LPAD(Detail.Codbarra, 13, ' ') || '24' ||
                                       LPAD(ROUND(DBMS_RANDOM.VALUE(1, 10)),
                                            4,
                                            '0') || '0200002000' ||
                                       'A99000000000000000' || ' >> ' ||
                                       nomearqrj_seven; --INSERE A LINHA NO ARQUIVO
                            qtde_linhas_seven(4) := qtde_linhas_seven(4) + 1;
                            dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
                            dbms_output.put_line('COPY /Y ' ||
                                                 nomearqrj_seven || ' ' ||
                                                 diretorio); --MOVE ARQUIVO PARA DIRETORIO    
                          ELSE
                            IF Head1.Db_Cli_Estado = 'PR' THEN
                              nomearqpr_seven := ' SP' || numero_pedido ||
                                                 Head1.Cnpj_Filial || 'LGX' ||
                                                 TO_CHAR(SYSDATE,
                                                         'YYYYMMDDHH24MI_') ||
                                                 '000000' || '.TTT';
                              header1 := 'echo ' || Head1.Cnpj_Cliente ||
                                         LPAD(Detail.Codbarra, 13, ' ') || '24' ||
                                         LPAD(ROUND(DBMS_RANDOM.VALUE(1, 10)),
                                              4,
                                              '0') || '0200002000' ||
                                         'A99000000000000000' || ' >> ' ||
                                         nomearqpr_seven; --INSERE A LINHA NO ARQUIVO
                              qtde_linhas_seven(5) := qtde_linhas_seven(5) + 1;
                              dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
                              dbms_output.put_line('COPY /Y ' ||
                                                   nomearqpr_seven || ' ' ||
                                                   diretorio); --MOVE ARQUIVO PARA DIRETORIO    
                            ELSE
                              IF Head1.Db_Cli_Estado = 'DF' THEN
                                nomearqdf_seven := ' SP' || numero_pedido ||
                                                   Head1.Cnpj_Filial ||
                                                   'LGX' ||
                                                   TO_CHAR(SYSDATE,
                                                           'YYYYMMDDHH24MI_') ||
                                                   '000000' || '.TTT';
                                header1 := 'echo ' || Head1.Cnpj_Cliente ||
                                           LPAD(Detail.Codbarra, 13, ' ') || '24' ||
                                           LPAD(ROUND(DBMS_RANDOM.VALUE(1,
                                                                        10)),
                                                4,
                                                '0') || '0200002000' ||
                                           'A99000000000000000' || ' >> ' ||
                                           nomearqdf_seven; --INSERE A LINHA NO ARQUIVO
                                qtde_linhas_seven(6) := qtde_linhas_seven(6) + 1;
                                dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
                                dbms_output.put_line('COPY /Y ' ||
                                                     nomearqdf_seven || ' ' ||
                                                     diretorio); --MOVE ARQUIVO PARA DIRETORIO    
                              
                              ELSE
                                dbms_output.put_line('echo');
                              END IF;
                            END IF;
                          END IF;
                        END IF;
                      END IF;
                    END IF;
                  
                  END LOOP;
                  numero_pedido := numero_pedido + 1; --INCREMENTA O NUMERO DO PEDIDO
                END LOOP;
                dbms_output.put_line('echo');
              
              ELSE
                dbms_output.put_line('echo');
              END IF;
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END LOOP;
  dbms_output.put_line('echo');
END;

/
spool off;

host C:\Users\danilo\Desktop\Utilidades\windows_commands.bat

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
