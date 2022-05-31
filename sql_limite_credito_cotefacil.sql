------ LIMITE DE CRÉDITO POR FILIAL DA COTACAO 
 SELECT  
 db_cli_codigo,
 db_cli_vinculo,
 db_edipc_txt1,
 (select
       TRIM(REPLACE(TO_CHAR(NVL(CLICR.DB_CLICR_LIMCREDAP, 0) -
                            (NVL(CLICR.DB_CLICR_PEDABERTO, 0) +
                             NVL(CLICR.DB_CLICR_TITABERTO, 0)),
                            '99999999990.99'),
                    '.',
                    ',')) as "CRÉDITO DISPONÍVEL"
  from mercanet_prd.db_cliente_credito clicr, mercanet_prd.db_cliente cli
 where clicr.db_clicr_codigo = cli.db_cli_codigo
   and cli.db_cli_cgcmf  = db_edipc_txt1) 
   
   FROM MERCANET_PRD.DB_EDI_PED_COMPL , MERCANET_PRD.DB_CLIENTE
  WHERE DB_EDIPC_NRO = '375267-529'
   AND DB_EDIPC_TXT1 = DB_CLI_CGCMF ;
   
---------- LIMITE DE CREDITO : MATRIZ - POR CLIENTE   
   
 select db_cli_codigo,
        DB_CLICR_LIMCREDAP,
        DB_CLICR_PEDABERTO,
        DB_CLICR_TITABERTO,
        TRIM(REPLACE(TO_CHAR(NVL(CLICR.DB_CLICR_LIMCREDAP, 0) -
                             (NVL(CLICR.DB_CLICR_PEDABERTO, 0) +
                              NVL(CLICR.DB_CLICR_TITABERTO, 0)),
                             '99999999990.99'),
                     '.',
                     ',')) as "CRÉDITO DISPONÍVEL"
   from mercanet_prd.db_cliente_credito clicr, mercanet_prd.db_cliente cli
  where clicr.db_clicr_codigo = 27282
    and clicr.db_clicr_codigo = cli.db_cli_codigo
