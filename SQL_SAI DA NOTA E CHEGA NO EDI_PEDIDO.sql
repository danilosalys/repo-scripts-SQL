SELECT DB_NOTAP_NRO
             FROM DB_NOTA_PROD, DB_NOTA_FISCAL
             WHERE DB_NOTA_EMPRESA = DB_NOTAP_EMPRESA
             AND DB_NOTA_NRO   =  DB_NOTAP_NRO 
             AND DB_NOTA_SERIE = DB_NOTAP_SERIE
             AND EXISTS 
                        (SELECT * FROM DB_PEDIDO, DB_PEDIDO_PROD
                         WHERE DB_PED_NRO = DB_PEDI_PEDIDO 
                           AND DB_NOTA_PED_ORIG = DB_PED_NRO_ORIG
                           AND DB_NOTAP_PRODUTO = DB_PEDI_PRODUTO
                           AND EXISTS 
                                      (SELECT * FROM DB_PEDIDO_DISTR, DB_PEDIDO_DISTR_IT
                                       WHERE DB_PEDT_PEDIDO = DB_PDIT_PEDIDO 
                                       AND DB_PED_NRO = DB_PEDT_PEDIDO
                                       AND DB_PEDI_PRODUTO = DB_PDIT_PRODUTO
                                       AND EXISTS 
                                                  (SELECT * FROM DB_EDI_PEDIDO, DB_EDI_PEDPROD
                                                    WHERE DB_EDIP_COMPRADOR = DB_EDII_COMPRADOR 
                                                    AND DB_EDIP_NRO = DB_EDII_NRO
                                                    AND DB_PEDT_PEDIDO = DB_EDIP_PEDMERC
                                                    AND DB_PDIT_EDII_SEQ = DB_EDII_SEQ)))     
                        