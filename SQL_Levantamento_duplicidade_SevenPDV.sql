SELECT DB_PED_NRO AS "PEDIDO MERCANET",
       DB_PED_CLIENTE AS "CODIGO DO CLIENTE",
       (SELECT DM05_MSGDATA FROM MERCANET_PRD.MDM05 WHERE INSTR(DM05_MSG,DB_PED_NRO) > 1 AND DM05_GUID = 183) AS "DATA-HORA PROC MERCANET",
       (SELECT SUM(DB_PEDI_QTDE_SOLIC) FROM MERCANET_PRD.DB_PEDIDO_PROD WHERE DB_PEDI_PEDIDO  = DB_PED_NRO ) AS  "SOMA_QTDE_SOLIC",
       (SELECT COUNT(DB_PEDI_PRODUTO) FROM MERCANET_PRD.DB_PEDIDO_PROD WHERE DB_PEDI_PEDIDO  = DB_PED_NRO ) AS "QTDE_PRODUTOS",
       (SELECT RTRIM(XMLAGG(XMLELEMENT(e, DB_PEDI_PRODUTO||',' )).extract('//text()'),',') 
          FROM MERCANET_PRD.DB_PEDIDO_PROD WHERE DB_PEDI_PEDIDO  = DB_PED_NRO) AS "PRODUTOS",
       DB_PED_NRO_ORIG AS "PEDIDO JDE",
       '' AS "STATUS DO PROCESSAMENTO",
       DB_PED_SITUACAO AS "STATUS DO PEDIDO",
       '' AS "LINHA",
       DB_PED_EMPRESA AS "FILIAL"
  FROM MERCANET_PRD.DB_PEDIDO
 WHERE DB_PED_NRO IN
       (SELECT SUBSTR(DM05_MSG, 44, 8)
          FROM MERCANET_PRD.MDM05
         WHERE DM05_GUID = 183
           AND DM05_MSGDATA > '01/06/2020'
           AND DM05_MSG LIKE '%Pedido Mercanet%'
           AND NOT EXISTS
         (SELECT *
                  FROM MERCANET_PRD.DB_EDI_PEDIDO
                 WHERE DB_EDIP_PEDMERC = SUBSTR(DM05_MSG, 44, 8)));


-----------------



SELECT *
  FROM (SELECT 'NÃO EXISTE DB_EDI_PEDIDO' AS "DADOS EDI",
               DB_PED_NRO AS "PEDIDO MERCANET",
               DB_PED_CLIENTE AS "CODIGO DO CLIENTE",
               (SELECT DM05_MSGDATA
                  FROM MERCANET_PRD.MDM05
                 WHERE INSTR(DM05_MSG, DB_PED_NRO) > 1
                   AND DM05_GUID = 183
                   AND DM05_MSGDATA > '01/06/2020'
                   AND DM05_SESSAOID = 133836) AS "DATA-HORA PROC MERCANET",
               (SELECT SUM(DB_PEDI_QTDE_SOLIC)
                  FROM MERCANET_PRD.DB_PEDIDO_PROD
                 WHERE DB_PEDI_PEDIDO = DB_PED_NRO) AS "SOMA_QTDE_SOLIC",
               (SELECT COUNT(DB_PEDI_PRODUTO)
                  FROM MERCANET_PRD.DB_PEDIDO_PROD
                 WHERE DB_PEDI_PEDIDO = DB_PED_NRO) AS "QTDE_PRODUTOS",
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e, DB_PEDI_PRODUTO || ','))
                             .extract('//text()'),
                             ',')
                  FROM MERCANET_PRD.DB_PEDIDO_PROD
                 WHERE DB_PEDI_PEDIDO = DB_PED_NRO) AS "PRODUTOS",
               DB_PED_NRO_ORIG AS "PEDIDO JDE",
               '' AS "STATUS DO PROCESSAMENTO",
               DB_PED_SITUACAO AS "STATUS DO PEDIDO",
               '' AS "LINHA",
               DB_PED_EMPRESA AS "FILIAL"
          FROM MERCANET_PRD.DB_PEDIDO
         WHERE DB_PED_NRO IN
               (SELECT SUBSTR(DM05_MSG, 44, 8)
                  FROM MERCANET_PRD.MDM05
                 WHERE DM05_GUID = 183
                   AND DM05_MSGDATA > '01/06/2020'
                   AND DM05_MSG LIKE '%Pedido Mercanet%'
                   AND NOT EXISTS
                 (SELECT *
                          FROM MERCANET_PRD.DB_EDI_PEDIDO
                         WHERE DB_EDIP_PEDMERC = SUBSTR(DM05_MSG, 44, 8)))
        UNION
        SELECT 'NÃO EXISTE DB_EDI_PEDIDO' AS "DADOS EDI",
               DB_PED_NRO AS "PEDIDO MERCANET",
               DB_PED_CLIENTE AS "CODIGO DO CLIENTE",
               (SELECT DB_PEDT_DTCOLET
                  FROM MERCANET_PRD.DB_PEDIDO_DISTR
                 WHERE DB_PEDT_PEDIDO = DB_PED_NRO) AS "DATA-HORA PROC MERCANET",
               (SELECT SUM(DB_PEDI_QTDE_SOLIC)
                  FROM MERCANET_PRD.DB_PEDIDO_PROD
                 WHERE DB_PEDI_PEDIDO = DB_PED_NRO) AS "SOMA_QTDE_SOLIC",
               (SELECT COUNT(DB_PEDI_PRODUTO)
                  FROM MERCANET_PRD.DB_PEDIDO_PROD
                 WHERE DB_PEDI_PEDIDO = DB_PED_NRO) AS "QTDE_PRODUTOS",
               (SELECT RTRIM(XMLAGG(XMLELEMENT(e, DB_PEDI_PRODUTO || ','))
                             .extract('//text()'),
                             ',')
                  FROM MERCANET_PRD.DB_PEDIDO_PROD
                 WHERE DB_PEDI_PEDIDO = DB_PED_NRO) AS "PRODUTOS",
               DB_PED_NRO_ORIG AS "PEDIDO JDE",
               '' AS "STATUS DO PROCESSAMENTO",
               DB_PED_SITUACAO AS "STATUS DO PEDIDO",
               '' AS "LINHA",
               DB_PED_EMPRESA AS "FILIAL"
          FROM MERCANET_PRD.DB_PEDIDO
         WHERE NOT EXISTS (SELECT *
                  FROM MERCANET_PRD.DB_EDI_PEDIDO
                 WHERE DB_EDIP_PEDMERC = DB_PED_NRO)
           AND DB_PED_TIPO = 'OL'
           AND DB_PED_DT_EMISSAO = '01/06/2020'
        UNION
        SELECT *
          FROM (SELECT 'EXISTE DB_EDI_PEDIDO' AS "DADOS EDI",
                       DB_PED_NRO AS "PEDIDO MERCANET",
                       DB_PED_CLIENTE AS "CODIGO DO CLIENTE",
                       (SELECT DB_PEDT_DTCOLET
                          FROM MERCANET_PRD.DB_PEDIDO_DISTR
                         WHERE DB_PEDT_PEDIDO = DB_PED_NRO) AS "DATA-HORA PROC MERCANET",
                       (SELECT SUM(DB_PEDI_QTDE_SOLIC)
                          FROM MERCANET_PRD.DB_PEDIDO_PROD
                         WHERE DB_PEDI_PEDIDO = DB_PED_NRO) AS "SOMA_QTDE_SOLIC",
                       (SELECT COUNT(DB_PEDI_PRODUTO)
                          FROM MERCANET_PRD.DB_PEDIDO_PROD
                         WHERE DB_PEDI_PEDIDO = DB_PED_NRO) AS "QTDE_PRODUTOS",
                       (SELECT RTRIM(XMLAGG(XMLELEMENT(e, DB_PEDI_PRODUTO || ','))
                                     .extract('//text()'),
                                     ',')
                          FROM MERCANET_PRD.DB_PEDIDO_PROD
                         WHERE DB_PEDI_PEDIDO = DB_PED_NRO) AS "PRODUTOS",
                       DB_PED_NRO_ORIG AS "PEDIDO JDE",
                       '' AS "STATUS DO PROCESSAMENTO",
                       DB_PED_SITUACAO AS "STATUS DO PEDIDO",
                       '' AS "LINHA",
                       DB_PED_EMPRESA AS "FILIAL"
                  FROM MERCANET_PRD.DB_PEDIDO, MERCANET_PRD.DB_EDI_PEDIDO
                 WHERE DB_EDIP_PEDMERC = DB_PED_NRO
                   /*AND DB_EDIP_LOTE = 51702879*/))
 ORDER BY "CODIGO DO CLIENTE", "PEDIDO MERCANET", "PRODUTOS"; 
 
