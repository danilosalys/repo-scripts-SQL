1.  CARREGAR OS DADOS PEDIDOS_PLANILHA - INSERIR A CHAVE DOS PEDIDOS
--2.  RECUPERAR TABELAS QUE CONTEM CLOB DO HISTORICO


--RETORNOS DE PEDIDOS COM CNPJ E NUMERO DO PEDIDO
insert into db_edi_log_exp_analise  
select *
  from mercanet_prd.db_edi_log_exp_hist t1
  where (db_edile_edip_comp,db_edile_edip_nro) in 
    (select db_edip_comprador, db_edip_nro  from dsales.pedidos_seven_analise) 
    --and db_edile_edia_codi = 'SEVENPDV_NOT'
 union all
select *
  from mercanet_prd.db_edi_log_exp t1
  where (db_edile_edip_comp,db_edile_edip_nro) in 
    (select  db_edip_comprador, db_edip_nro  from dsales.pedidos_seven_analise)
    --and db_edile_edia_codi = 'SEVENPDV_NOT'
union all

insert into db_edi_log_exp_analise  
(select *
  from mercanet_hist.db_edi_log_exp_hist@dch9 t1
  where (db_edile_edip_comp,db_edile_edip_nro) in 
    (select db_edip_comprador, db_edip_nro from dsales.pedidos_seven_analise))
    --and db_edile_edia_codi = 'SEVENPDV_NOT'

    ;

/*
--RETORNO DE PEDIDOS COM CNPJ E LOTE SEVEN
CREATE table db_edi_log_exp_analise as 
select *
  from mercanet_hist.db_edi_log_exp_hist@dch9 t1
  where (db_edile_edip_comp,db_edile_edip_nro) in 
       (select  db_edip_comprador, db_edip_nro  from dsales.pedidos_seven_analise)
    and db_edile_edia_codi = 'SEVENPDV_NOT'
 union 
select *
  from mercanet_hist.db_edi_log_exp_hist t1
  where (db_edile_edip_comp,db_edile_edip_nro) in 
    (select  db_edip_comprador, db_edip_nro  from dsales.pedidos_seven_analise)
    and db_edile_edia_codi = 'SEVENPDV_NOT'
 union 
select *
  from mercanet_prd.db_edi_log_exp t1
  where (db_edile_edip_comp,db_edile_edip_nro) in 
    (select  db_edip_comprador, db_edip_nro  from dsales.pedidos_seven_analise)
    and db_edile_edia_codi = 'SEVENPDV_NOT'    


    */

--3. CARREGAR TABELA COM DADOS DA PLANILHA
/*CREATE TABLE PLANILHA_CONTROLADORIA (
PBM_OU_OL     VARCHAR2(100),
VAN           VARCHAR2(100),
PROJETO       VARCHAR2(100),  
COD_DE_PARA   VARCHAR2(100),
RAZAO_DE_PARA VARCHAR2(100),
CLIENTE       VARCHAR2(100),  
RAZÃO_CLIENTE VARCHAR2(100), 
CNPJ          VARCHAR2(100),
CIDADE        VARCHAR2(100),
ESTADO        VARCHAR2(100),
DATA_NF       VARCHAR2(100),
DOCUMENTO     VARCHAR2(100),
COD_PRODUTO   VARCHAR2(100),
DESCRICAO     VARCHAR2(100),
QUANTIDADE    VARCHAR2(100),
CNPJ_DISTR    VARCHAR2(100),  
CÓD_AJUSTE    VARCHAR2(100),
DIVISÃO       VARCHAR2(100),
PRECO_FABRICA VARCHAR2(100), 
EAN           VARCHAR2(100),
LOTE_SEVEN    VARCHAR2(100),
PEDIDO_VAN    VARCHAR2(100),
CHAVE_NFe     VARCHAR2(100),
DESCONTO      VARCHAR2(100),
MECÂNICA      VARCHAR2(100),
TOTAL         VARCHAR2(100)) */

--4. CARREGAR A TABELA

--SELECT * FROM DSALES.PLANILHA_CONTROLADORIA /*WHERE 1 = 0*/ FOR UPDATE

/*UPDATE DSALES.PLANILHA_CONTROLADORIA
SET CNPJ = LPAD(CNPJ,14,'0'),
    CNPJ_DISTR = LPAD(CNPJ_DISTR,14,'0'),
    LOTE_SEVEN = LPAD(LOTE_SEVEN,6,'0')
    */

--5. EXECUTAR SCRIPT 
SELECT * FROM (
SELECT T1.*,
       T2.DB_EDILE_ARQUIVO AS NOME_ARQ_NOTA_POSTADO_FTP,
       TO_DATE(TO_CHAR(SUBSTR(T2.DB_EDILE_ARQUIVO,20,12)),'YYYYMMDDHH24MI') AS "DATA_HORA_POSTAGEM_RP.DAT",
       TO_CHAR(SUBSTR(T2.DB_EDILE_CONTEUDO,
                      INSTR(T2.DB_EDILE_CONTEUDO,
                            T1.CNPJ || LPAD(T1.EAN, 13, '0'),
                            1,
                            1),
                      86)) AS "CONTEUDO_LINHA_ARQ_RP.DAT"
  FROM DSALES.PLANILHA_CONTROLADORIA T1,
       DSALES.DB_EDI_LOG_EXP_ANALISE T2,
       MERCANET_PRD.DB_EDI_PEDIDO    T3
 WHERE INSTR(T2.DB_EDILE_CONTEUDO, T1.CNPJ) > 0
   AND INSTR(T2.DB_EDILE_CONTEUDO, T1.EAN) > 0
   AND INSTR(T2.DB_EDILE_CONTEUDO, T1.LOTE_SEVEN) > 0
   --AND INSTR(T2.DB_EDILE_CONTEUDO, T1.DOCUMENTO) > 0
   --AND INSTR(T2.DB_EDILE_CONTEUDO, LPAD(T1.QUANTIDADE,4,'0')) > 0 
   AND T1.CNPJ = T2.DB_EDILE_EDIP_COMP
   AND T1.PEDIDO_VAN = T2.DB_EDILE_EDIP_NRO
   AND T2.DB_EDILE_EDIP_COMP = DB_EDIP_COMPRADOR
   AND T2.DB_EDILE_EDIP_NRO = DB_EDIP_NRO
UNION ALL 
SELECT T1.*,
       T2.DB_EDILE_ARQUIVO AS NOME_ARQ_NOTA_POSTADO_FTP,
       TO_DATE(TO_CHAR(SUBSTR(T2.DB_EDILE_ARQUIVO,20,12)),'YYYYMMDDHH24MI') AS "DATA_HORA_POSTAGEM_RP.DAT",
       TO_CHAR(SUBSTR(T2.DB_EDILE_CONTEUDO,
                      INSTR(T2.DB_EDILE_CONTEUDO,
                            T1.CNPJ || LPAD(T1.EAN, 13, '0'),
                            1,
                            1),
                      86)) AS "CONTEUDO_LINHA_ARQ_RP.DAT"
  FROM DSALES.PLANILHA_CONTROLADORIA T1,
       DSALES.DB_EDI_LOG_EXP_ANALISE T2,
       MERCANET_HIST.DB_EDI_PEDIDO_HIST@DCH9    T3
 WHERE INSTR(T2.DB_EDILE_CONTEUDO, T1.CNPJ) > 0
   AND INSTR(T2.DB_EDILE_CONTEUDO, T1.EAN) > 0
   AND INSTR(T2.DB_EDILE_CONTEUDO, T1.LOTE_SEVEN) > 0
  -- AND INSTR(T2.DB_EDILE_CONTEUDO, T1.DOCUMENTO) > 0
  -- AND INSTR(T2.DB_EDILE_CONTEUDO, LPAD(T1.QUANTIDADE,4,'0')) > 0 
   AND T1.CNPJ = T2.DB_EDILE_EDIP_COMP
   AND T1.PEDIDO_VAN = T2.DB_EDILE_EDIP_NRO
   AND T2.DB_EDILE_EDIP_COMP = DB_EDIP_COMPRADOR
   AND T2.DB_EDILE_EDIP_NRO = DB_EDIP_NRO)
 ORDER BY "DATA_HORA_POSTAGEM_RP.DAT", 
          NOME_ARQ_NOTA_POSTADO_FTP,
          CNPJ,
          EAN
          
          
