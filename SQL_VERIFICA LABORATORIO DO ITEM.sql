/*SELECT * FROM DB_CLIENTE A WHERE A.DB_CLI_CGCMF = '78019304000198';*/

SELECT  A.DB_PRDEMB_PRODUTO,
                A.DB_PRDEMB_CODBARRA,
                B.db_prod_familia,
                c.db_tbfam_descricao,
                (CASE
                     WHEN (DB_PROD_FAMILIA IN (7286, 8227)) THEN '33'                 
                 ELSE
                     CASE
                         WHEN (DB_PROD_FAMILIA IN (5355)) THEN '27'
                     ELSE
                         CASE
                             WHEN (DB_PROD_FAMILIA IN (6351, 5003,5052)) THEN '31'
                         ELSE
                             CASE 
                                  WHEN (DB_PROD_FAMILIA IN(5333)) THEN '30'
                             ELSE
                                 CASE 
                                      WHEN (DB_PROD_FAMILIA IN (6391,8200)) THEN '24'
                                 ELSE
                                     CASE 
                                         WHEN (DB_PROD_FAMILIA IN (6376)) THEN '23'
                                     END
                                 END
                             END                             
                         END 
                     END 
                 END) PROJETO
                
  FROM DB_PRODUTO_EMBAL A, DB_PRODUTO B, DB_TB_FAMILIA C
 WHERE A.DB_PRDEMB_PRODUTO = B.DB_PROD_CODIGO
   AND B.DB_PROD_FAMILIA = C.DB_TBFAM_CODIGO
  AND A.DB_PRDEMB_CODBARRA in ('7891268148350')
  ORDER BY DB_PRDEMB_CODBARRA ASC  


