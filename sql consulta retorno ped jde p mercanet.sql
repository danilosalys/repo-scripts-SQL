--SQL DE CONSULTA AOS PEDIDOS QUE OBTIVERAM RETORNO DO JDE -- 

SELECT  edild.DB_EDILD_SEQ,
        edild.DB_EDILD_NOMEARQ,
        edild.DB_EDILD_LAYOUT,
        edild.DB_EDILD_USUARIO,
        edild.DB_EDILD_DATA,
        edild.DB_EDILD_DISTR || ' - ' || (van.EM01_EAN),
        edip.DB_EDIP_LABcod,
        edip.DB_EDIP_PEDMERC,
        edip.DB_EDIP_CLIENTE,
        edip.DB_EDIP_COMPRADOR,
        edip.DB_EDIP_NRO,
        edip.DB_EDIP_DT_EMISSAO,
        edip.DB_EDIP_CONDPGTO,
        edip.DB_EDIP_PROJETO,
        edii.DB_EDII_MOTIVORET,
        ped.db_ped_sitcorp
  FROM db_edi_lote_distr edild,
       db_edi_pedido     edip,
       db_edi_pedprod    edii,
       mem01             van,
       db_pedido         ped
 where edild.DB_EDILD_SEQ     =     edip.DB_EDIP_LOTE
   and edii.DB_EDII_COMPRADOR =     edip.DB_EDIP_COMPRADOR
   and edii.DB_EDII_NRO       =     edip.DB_EDIP_NRO
   and edild.DB_EDILD_DISTR   =     van.EM01_CODIGO
   and ped.db_ped_nro         =     edip.db_edip_pedmerc
   and ped.db_ped_sitcorp     IS NOT NULL         -- CAMPO INSERIDO SOMENTE QDO O PEDIDO É RETORNADO DO JDE
   and edip.db_edip_van       in    ('508')       -- Informe a VAN
   and edip.db_edip_pedmerc  BETWEEN '90020249' AND '90020310'  -- ou os numeros de pedido no Mercanet
;

--CONSULTA RETORNO DO JDE PARA O MERCANET QUANDO HÁ SPLIT DE PEDIDO

-- SE O SQL NAO RETORNAR NENHUMA LINHA:--> TODOS OS ITENS FORAM ENVIADOS DO JDE PARA O MERCANET
--SENÃO:--> É MOSTRADO OS ITENS QUE NÃO FORAM ENVIADOS DO JDE


SELECT *
  FROM DB_PEDIDO_PROD A
 WHERE A.DB_PEDI_PEDIDO BETWEEN '90020249' AND '90020306' -- LISTA DOS PEDIDOS MERCANET
   AND NOT EXISTS
                  (SELECT *        
                       FROM INTERFACE_DB_PEDIDO_PROD B
                      WHERE A.DB_PEDI_PEDIDO = B.DB_PEDI_PEDIDO
                        AND A.DB_PEDI_PRODUTO = B.DB_PEDI_PRODUTO)
                        

