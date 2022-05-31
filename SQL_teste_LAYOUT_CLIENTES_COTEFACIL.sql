DECLARE
  numero_pedido number(6) := 454500;
  cont_itens       number := 0;
  header1          varchar2(500);
  detail1          varchar2(500);
  registro4        varchar2(500);
  trailer          varchar2(500);
  cnpj_filial      varchar2(14);
  hora_nome_arq    date;
BEGIN
  
  FOR LAYOUT_ARQUIVO IN (SELECT * FROM MERCANET_QA.DB_CLIENTE WHERE DB_CLI_SITUACAO = 0) 
    LOOP
                FOR Head1 IN (SELECT DISTINCT ID_ARQUIVO, CNPJ_CLIENTE, DB_CLI_ESTADO  
                                  FROM MONTA_ARQUIVO, MERCANET_QA.DB_CLIENTE
                                WHERE CNPJ_CLIENTE = DB_CLI_CGCMF
                                  AND LAYOUT = LAYOUT_ARQUIVO.LAYOUT
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
                            detail1 := 'echo 2;' || Detail.Codbarra || ';' ||ROUND(DBMS_RANDOM.VALUE(1, 20)) 
                                    || ';0.0 >> COTACAO_' || numero_pedido ||'_'|| Head1.ID_ARQUIVO || '.txt'; --INSERE O DETAIL NO ARQUIVO
                            dbms_output.put_line(detail1);--IMPRIME O COMANDO NA TELA
                            cont_itens := cont_itens + 1; ---CONTAGEM DE ITENS INSERIDOS NO ARQUIVO (UTILIZADO NO TRAILER)
                          END LOOP;
                    dbms_output.put_line('echo 4;' || Head1.Cnpj_Cliente ||';'||Head1.Db_Cli_Estado --DADOS DO HEADER4
                         ||';0 >> COTACAO_' ||numero_pedido ||'_'|| Head1.ID_ARQUIVO || '.txt');
                    dbms_output.put_line('echo 9;' || cont_itens --DADOS DO HEADER9
                         || ';3.1 >> COTACAO_' ||numero_pedido ||'_'|| Head1.ID_ARQUIVO || '.txt');
                    cont_itens     := 0; -- ZERA CONTAGEM PARA O PROXIMO ARQUIVO
                    numero_pedido := numero_pedido + 1; --INCREMENTA O NUMERO DO PEDIDO
                  END LOOP;
                  
     END LOOP;
  dbms_output.put_line('echo');
END;

/*A procedure irá retornar os comandos de criação do arquivo. Abrir o MS-DOS, escolher uma pasta destino e colar os comandos 
retornados pela procedure para que os arquivos sejam criados. */

