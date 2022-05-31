---DATA: 05/07/2016 
---DANILO SALES
---TITULO: GERADOR DE ARQUIVOS DE PEDIDOS PARA TESTES
---OBS: EXECUTAR NO COMMAND WINDOW

set feedback off
set echo off
set trimspool on
set termout off
set serveroutput on size 2048000 format wrapped
set lines 2048000
set pages 0

-- CRIA O ARQUIVO BAT PARA SER EXECUTO POSTERIORMENTE
spool C:\temp\Gera_arquivos.BAT

-- Created on 05/07/2016 by DSALES 
DECLARE
  numero_pedido number(6) := to_number(replace(replace(to_char(sysdate,'dd/miss'),':',null),'/',null))+to_number(replace(replace(to_char(sysdate,'dd/ssss'),':',null),'/',null));
  cont_itens    number := 0;
  header1       varchar2(1000);
  header2       varchar2(1000);
  header3       varchar2(1000);
  header4       varchar2(1000);
  detail1       varchar2(1000);
  registro4     varchar2(1000);
  trailer       varchar2(1000);
  diretorio     varchar2(100) := '&Diretório'; --CADASTRE O DIRETORIO ONDE ARQUIVOS SERÃO INSERIDOS
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

  FOR LAYOUT_ARQUIVO IN (SELECT DISTINCT VAN
                           FROM CENARIOS) LOOP
                           
    IF LAYOUT_ARQUIVO.VAN = '529' THEN
    
      FOR Head1 IN (SELECT DISTINCT ID_ARQUIVO,
                                    CNPJ_FILIAL,
                                    CNPJ_CLIENTE,
                                    DB_CLI_ESTADO,
                                    NVL((SELECT MAX(DB_CLIR_COND_PGTO)
                                           FROM MERCANET_QA.DB_CLIENTE_REPRES
                                          WHERE DB_CLIR_SITUACAO = 0
                                            AND DB_CLIR_CLIENTE = DB_CLI_CODIGO),0) AS CONDICAO_PAGTO
                      FROM CENARIOS, MERCANET_QA.DB_CLIENTE
                     WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                       AND VAN = LAYOUT_ARQUIVO.VAN
                       AND CNPJ_CLIENTE <> 0   
                     ORDER BY ID_ARQUIVO) LOOP
        header1 := 'echo 1;' || Head1.CNPJ_CLIENTE || ';SP;' ||
                   TO_CHAR(SYSDATE, 'DDMMYYYY HH24MI') || ';' ||
                   numero_pedido || Head1.ID_ARQUIVO || ';V;N;0;' ||
                   TO_CHAR(SYSDATE, 'DDMMYYYY') || ';00000000;' ||Head1.Condicao_Pagto||';'||Head1.Cnpj_filial||
                   ' >> COTACAO_' || numero_pedido || '_' ||
                   Head1.ID_ARQUIVO || '.txt'; --INSERE O HEADER1 NO ARQUIVO
        dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
        FOR Detail IN (SELECT CODIGO_PRODUTO,
                              MAX(DB_PRDEMB_CODBARRA) AS CODBARRA
                         FROM CENARIOS, MERCANET_QA.DB_PRODUTO_EMBAL
                        WHERE ID_ARQUIVO = Head1.Id_Arquivo
                          AND CNPJ_CLIENTE = Head1.Cnpj_Cliente
                          AND CODIGO_PRODUTO = DB_PRDEMB_PRODUTO
                        GROUP BY CODIGO_PRODUTO) LOOP
          detail1 := 'echo 2;' || LPAD(Detail.Codbarra, 13, ' ') || ';' ||
                     ROUND(DBMS_RANDOM.VALUE(1, 20)) || ';0.0 >> COTACAO_' ||
                     numero_pedido || '_' || Head1.ID_ARQUIVO || '.txt'; --INSERE O DETAIL NO ARQUIVO
        
          update CENARIOS a
             set a.pedido = numero_pedido || Head1.ID_ARQUIVO||'-'||LAYOUT_ARQUIVO.VAN
           where a.id_arquivo = head1.id_arquivo
             and a.codigo_produto = detail.codigo_produto;
        
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
                        FROM CENARIOS, MERCANET_QA.DB_CLIENTE
                       WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                         AND VAN = LAYOUT_ARQUIVO.VAN
                         AND CNPJ_CLIENTE <> 0 
                       ORDER BY ID_ARQUIVO) LOOP
        
          header1 := 'echo 1;' || Head1.CNPJ_CLIENTE || ';;' ||
                     Head1.cnpj_filial || ';;;' || numero_pedido ||
                     Head1.ID_ARQUIVO || ';7.00' || ' >> PEDIDO_' ||
                     lpad(numero_pedido||Head1.ID_ARQUIVO,10,'0') || '_' || Head1.cnpj_filial ||
                     '_GSK.txt'; --INSERE O HEADER1 NO ARQUIVO
          dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
          FOR Detail IN (SELECT CODIGO_PRODUTO,
                                MAX(DB_PRDEMB_CODBARRA) AS CODBARRA
                           FROM CENARIOS, MERCANET_QA.DB_PRODUTO_EMBAL
                          WHERE ID_ARQUIVO = Head1.Id_Arquivo
                            AND CNPJ_CLIENTE = Head1.Cnpj_Cliente
                            AND CODIGO_PRODUTO = DB_PRDEMB_PRODUTO
                          GROUP BY CODIGO_PRODUTO) LOOP
            detail1 := 'echo 2;' || LPAD(Detail.Codbarra, 13, ' ') || ';' ||
                       ROUND(DBMS_RANDOM.VALUE(1, 20)) || ';15.00;;' ||
                       ' >> PEDIDO_' ||  lpad(numero_pedido||Head1.ID_ARQUIVO,10,'0') || '_' ||
                       Head1.cnpj_filial || '_GSK.txt'; --INSERE O DETAIL NO ARQUIVO
            dbms_output.put_line(detail1); --IMPRIME O COMANDO NA TELA
            cont_itens := cont_itens + 1; ---CONTAGEM DE ITENS INSERIDOS NO ARQUIVO (UTILIZADO NO TRAILER)
          
            update CENARIOS a
               set a.pedido = lpad(numero_pedido||Head1.ID_ARQUIVO,10,'0')||'-'||LAYOUT_ARQUIVO.VAN
             where a.id_arquivo = head1.id_arquivo
               and a.codigo_produto = detail.codigo_produto;
          END LOOP;
          dbms_output.put_line('echo 9;' || cont_itens --DADOS DO HEADER9
                               || ' >> PEDIDO_' ||  lpad(numero_pedido||Head1.ID_ARQUIVO,10,'0') || '_' ||
                               Head1.Cnpj_Filial || '_GSK.txt');
          dbms_output.put_line('MOVE ' || 'PEDIDO_' ||  lpad(numero_pedido||Head1.ID_ARQUIVO,10,'0') || '_' ||
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
                                        DB_CLI_ESTADO,
                                        NVL((SELECT MAX(DB_CLIR_COND_PGTO)
                                               FROM MERCANET_QA.DB_CLIENTE_REPRES
                                              WHERE DB_CLIR_SITUACAO = 0
                                                AND DB_CLIR_CLIENTE = DB_CLI_CODIGO),0) AS CONDICAO_PAGTO
                          FROM CENARIOS, MERCANET_QA.DB_CLIENTE
                         WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                           AND VAN = LAYOUT_ARQUIVO.VAN
                           AND CNPJ_CLIENTE <> 0
                         ORDER BY ID_ARQUIVO) LOOP
          
            hora_nome_arq := sysdate + 1;
          
            header1 := 'echo 019  001' || lpad(numero_pedido ||Head1.Id_Arquivo,10,'0')||
                       '                              201502130402201502130402201502130402                              7898950258014789893536347478989353645707898935363474' ||
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
                             FROM CENARIOS,
                                  MERCANET_QA.DB_PRODUTO_EMBAL
                            WHERE ID_ARQUIVO = Head1.Id_Arquivo
                              AND CNPJ_CLIENTE = Head1.Cnpj_Cliente
                              AND CODIGO_PRODUTO = DB_PRDEMB_PRODUTO
                            GROUP BY CODIGO_PRODUTO) LOOP
              detail1 := 'echo 04000000000   EN ' ||
                         LPAD(Detail.Codbarra, 13, '0') ||
                         '                                                             EA 00001000000000000' ||
                         ROUND(DBMS_RANDOM.VALUE(1, 9)) ||
                         '00000000000000000000000000000000   0000000000000000000000000000000000000000000000000000000000000000000000   0000000000000000000000000000000000000000000000000000000000000000000000000000000000000' ||
                         ' >> ' || Head1.cnpj_filial ||
                         to_char(hora_nome_arq, 'ddmmyyyyhh24mi') ||
                         Head1.ID_ARQUIVO || '.ped'; --INSERE O detail NO ARQUIVO
              dbms_output.put_line(detail1); --IMPRIME O COMANDO NA TELA
              cont_itens := cont_itens + 1; ---CONTAGEM DE ITENS INSERIDOS NO ARQUIVO (UTILIZADO NO TRAILER)
             
             update CENARIOS a
                 set a.pedido = lpad(numero_pedido||Head1.ID_ARQUIVO,10,'0')||'-'||LAYOUT_ARQUIVO.VAN
               where a.id_arquivo = head1.id_arquivo
                 and a.codigo_produto = detail.codigo_produto;
            
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
                                          DB_CLI_ESTADO,
                                          DB_CLI_CODIGO,
                                          NVL((SELECT MAX(DB_CLIR_COND_PGTO)
                                                 FROM MERCANET_QA.DB_CLIENTE_REPRES
                                                WHERE DB_CLIR_SITUACAO = 0
                                                  AND DB_CLIR_CLIENTE = DB_CLI_CODIGO),0) AS CONDICAO_PAGTO
                            FROM CENARIOS, MERCANET_QA.DB_CLIENTE
                           WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                             AND VAN = LAYOUT_ARQUIVO.VAN
                             AND CNPJ_CLIENTE <> 0 
                           ORDER BY ID_ARQUIVO) LOOP
            
              header1 := 'echo 10' || Head1.CNPJ_CLIENTE || 
                         lpad(numero_pedido||Head1.Id_Arquivo,10,'0') || '0000000000' ||
                         TO_CHAR(SYSDATE, 'DDMMYYYY') || CASE
                           WHEN Head1.Db_Cli_Estado = 'SP' and Head1.Cnpj_Filial = '05156966000102' then
                            'I'
                           else
                            'E'
                         end || 'C0' || Head1.cnpj_filial || '000000' ||
                         ' >> PEDFAR_' || lpad(numero_pedido||Head1.Id_Arquivo,10,'0') ||
                         '0000000000.txt'; --INSERE O HEADER1 NO ARQUIVO
              dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
            
              FOR Detail IN (SELECT CODIGO_PRODUTO,
                                    MAX(DB_PRDEMB_CODBARRA) AS CODBARRA
                               FROM CENARIOS,
                                    MERCANET_QA.DB_PRODUTO_EMBAL
                              WHERE ID_ARQUIVO = Head1.Id_Arquivo
                                AND CNPJ_CLIENTE = Head1.Cnpj_Cliente
                                AND CODIGO_PRODUTO = DB_PRDEMB_PRODUTO
                              GROUP BY CODIGO_PRODUTO) LOOP
                detail1 := 'echo 2' || lpad(numero_pedido||Head1.Id_Arquivo,10,'0') || '0000000000' ||
                           LPAD(Detail.Codbarra, 13, ' ') ||
                           LPAD(ROUND(DBMS_RANDOM.VALUE(1, 10)), 5, '0') ||
                           '00000020000'|| Head1.Condicao_Pagto ||'00' || ' >> PEDFAR_' ||
                           lpad(numero_pedido||Head1.Id_Arquivo,10,'0') || '0000000000.txt'; --INSERE O DETAIL NO ARQUIVO
                dbms_output.put_line(detail1); --IMPRIME O COMANDO NA TELA
                cont_itens := cont_itens + 1; ---CONTAGEM DE ITENS INSERIDOS NO ARQUIVO (UTILIZADO NO TRAILER)
                
                update CENARIOS a
                   set a.pedido = numero_pedido || Head1.ID_ARQUIVO||'-'||LAYOUT_ARQUIVO.VAN
                 where a.id_arquivo = head1.id_arquivo
                   and a.codigo_produto = detail.codigo_produto;
                   
              END LOOP;
                            
              dbms_output.put_line('echo 3' || lpad(numero_pedido||Head1.Id_Arquivo,10,'0') ||
                                   '0000000000' ||
                                   LPAD(cont_itens, 5, '0') ||
                                   '0000000000' --DADOS DO HEADER9
                                   || ' >> PEDFAR_' || lpad(numero_pedido||Head1.Id_Arquivo,10,'0') ||
                                   '0000000000.txt');
              cont_itens := 0; -- ZERA CONTAGEM PARA O PROXIMO ARQUIVO
              dbms_output.put_line('MOVE ' || 'PEDFAR_' ||
                                   lpad(numero_pedido||Head1.Id_Arquivo,10,'0') || '0000000000.txt  ' ||
                                   diretorio); --MOVE ARQUIVO PARA DIRETORIO     
              numero_pedido := numero_pedido + 1; --INCREMENTA O NUMERO DO PEDIDO
            
            END LOOP;
            dbms_output.put_line('echo');
          ELSE
            IF LAYOUT_ARQUIVO.VAN = '540' THEN
            
              FOR Head1 IN (SELECT DISTINCT ID_ARQUIVO,
                                            CNPJ_FILIAL,
                                            CNPJ_CLIENTE,
                                            DB_CLI_ESTADO,
                                            NVL((SELECT MAX(DB_CLIR_COND_PGTO)
                                                   FROM MERCANET_QA.DB_CLIENTE_REPRES
                                                  WHERE DB_CLIR_SITUACAO = 0
                                                    AND DB_CLIR_CLIENTE = DB_CLI_CODIGO),0) AS CONDICAO_PAGTO
                              FROM CENARIOS, MERCANET_QA.DB_CLIENTE
                             WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                               AND VAN = LAYOUT_ARQUIVO.VAN
                               AND CNPJ_CLIENTE <> 0 
                             ORDER BY ID_ARQUIVO) LOOP
              
                header1 := 'echo 01221' || TO_CHAR(Head1.CNPJ_CLIENTE) ||
                           TO_CHAR(Head1.CNPJ_CLIENTE) || CASE
                             WHEN Head1.Db_Cli_Estado = 'SP' and Head1.Cnpj_Filial = '05156966000102' then
                              '02'
                             else
                              '01'
                           end || '00PHLINK' || '0013' ||
                           '0000000000000000000000000000000000000000000000' ||
                           ' >> PHL0013' || Head1.Cnpj_Filial ||
                            lpad(numero_pedido||Head1.Id_Arquivo,10,'0') ||
                           TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '.TXT';
              
                header2 := 'echo 02X  ' ||  lpad(numero_pedido||Head1.Id_Arquivo,10,'0') ||
                           '0000000000' || '000000000000000' ||
                           Head1.Cnpj_Filial ||
                           '000000000000000000000000000000000000000' ||
                           ' >> PHL0013' || Head1.Cnpj_Filial ||
                            lpad(numero_pedido||Head1.Id_Arquivo,10,'0') ||
                           TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '.TXT';
              
                header3 := 'echo 03' || '02' || '0000' || '000' ||
                           '0000000000000000000000000000000000000000000000000000000000000000000000000000000000' ||
                           ' >> PHL0013' || Head1.Cnpj_Filial ||
                            lpad(numero_pedido||Head1.Id_Arquivo,10,'0') ||
                           TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '.TXT';
              
                header4 := 'echo 04' ||
                           TO_CHAR(SYSDATE, 'DDMMYYYYHH24MISS') ||
                           TO_CHAR(SYSDATE, 'DDMMYYYYHH24MISS') ||
                           TO_CHAR(SYSDATE, 'DDMMYYYYHH24MISS') ||
                           TO_CHAR(SYSDATE, 'DDMMYYYY') ||
                           '00000000000000000000000000000000000000000' ||
                           ' >> PHL0013' || Head1.Cnpj_Filial ||
                            lpad(numero_pedido||Head1.Id_Arquivo,10,'0') ||
                           TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '.TXT';
              
                dbms_output.put_line(header1); --IMPRIME O COMANDO NA TELA
                dbms_output.put_line(header2); --IMPRIME O COMANDO NA TELA
                dbms_output.put_line(header3); --IMPRIME O COMANDO NA TELA              
                dbms_output.put_line(header4); --IMPRIME O COMANDO NA TELA              
              
                FOR Detail IN (SELECT CODIGO_PRODUTO,
                                      MAX(DB_PRDEMB_CODBARRA) AS CODBARRA
                                 FROM CENARIOS,
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
                             ' >> PHL0013' || Head1.Cnpj_Filial ||
                              lpad(numero_pedido||Head1.Id_Arquivo,10,'0') ||
                             TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '.TXT'; --INSERE O DETAIL NO ARQUIVO
                  dbms_output.put_line(detail1); --IMPRIME O COMANDO NA TELA
                  cont_itens := cont_itens + 1; ---CONTAGEM DE ITENS INSERIDOS NO ARQUIVO (UTILIZADO NO TRAILER)
                
                  update CENARIOS a
                     set a.pedido = numero_pedido || Head1.ID_ARQUIVO||'-'||LAYOUT_ARQUIVO.VAN
                   where a.id_arquivo = head1.id_arquivo
                     and a.codigo_produto = detail.codigo_produto;
                
                END LOOP;
                dbms_output.put_line('echo 06' || LPAD(cont_itens, 5, '0') ||
                                     '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000' ||
                                     ' >> PHL0013' || Head1.Cnpj_Filial ||
                                      lpad(numero_pedido||Head1.Id_Arquivo,10,'0') ||
                                     TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') ||
                                     '.TXT'); --INSERE O DETAIL NO ARQUIVO
                cont_itens := 0; -- ZERA CONTAGEM PARA O PROXIMO ARQUIVO
                dbms_output.put_line('MOVE ' || 'PHL0013' ||
                                     Head1.Cnpj_Filial ||
                                     lpad(numero_pedido||Head1.Id_Arquivo,10,'0') ||
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
                                              DB_CLI_ESTADO,
                                              NVL((SELECT MAX(DB_CLIR_COND_PGTO)
                                                     FROM MERCANET_QA.DB_CLIENTE_REPRES
                                                    WHERE DB_CLIR_SITUACAO = 0
                                                      AND DB_CLIR_CLIENTE = DB_CLI_CODIGO),0) AS CONDICAO_PAGTO
                                FROM CENARIOS, MERCANET_QA.DB_CLIENTE
                               WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                                 AND VAN = LAYOUT_ARQUIVO.VAN
                                 AND CNPJ_CLIENTE <> 0 
                               ORDER BY ID_ARQUIVO) LOOP
                
                  FOR Detail IN (SELECT CODIGO_PRODUTO,
                                        MAX(DB_PRDEMB_CODBARRA) AS CODBARRA
                                   FROM CENARIOS,
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
                  
                    update CENARIOS a
                       set a.pedido = numero_pedido
                     where a.id_arquivo = head1.id_arquivo
                       and a.codigo_produto = detail.codigo_produto;
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
  COMMIT;
END;
/
spool off;--TERMINA A GRAVACAO DO ARQUIVO BAT

host C:\temp\Gera_arquivos.BAT --ABRE O ARQUIVO BAT
