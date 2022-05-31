select t1.db_clicr_codigo as CLIENTE, 'R$ ' || TRIM(TO_CHAR(REPLACE(TO_CHAR(NVL(t1.DB_CLICR_LIMCREDAP, 0),
                                             '99999999990.99'),
                                     '.',
                                     ','))) as "LIMITE DE CRÉDITO",
       'R$ ' || TRIM(REPLACE(TO_CHAR(NVL(t1.DB_CLICR_PEDABERTO, 0) +
                                     NVL(t1.DB_CLICR_TITABERTO, 0),
                                     '99999999990.99'),
                             '.',
                             ',')) as "CRÉDITO UTILIZADO",
       'R$ ' || TRIM(REPLACE(TO_CHAR(NVL(t1.DB_CLICR_LIMCREDAP, 0) -
                                     (NVL(t1.DB_CLICR_PEDABERTO, 0) +
                                      NVL(t1.DB_CLICR_TITABERTO, 0)),
                                     '99999999990.99'),
                             '.',
                             ',')) as "CRÉDITO DISPONÍVEL"
  from mercanet_prd.db_cliente_credito t1; 
