--Data: 17/10/2014
--Por: Danilo Sales
--versão 5

SELECT DB_EDIP_LOTE AS "LOTE - CONTROLE INTERNO",
       DB_EDILD_DATA AS "DATA DE PROCESSAMENTO",
       TO_NUMBER(DB_EDIP_TXT1) AS "PEDIDO EXTERNO",
       DB_EDIP_PEDMERC AS "PEDIDO DROGACENTER",
       (SELECT DB_PED_NRO_ORIG
          FROM MERCANET_PRD.DB_PEDIDO
         WHERE DB_PED_NRO = DB_EDIP_PEDMERC) AS "PEDIDO ERP FATURADO",
       DECODE((SELECT DB_PED_SITUACAO
          FROM MERCANET_PRD.DB_PEDIDO
         WHERE DB_PED_NRO = DB_EDIP_PEDMERC),'4','FATURADO','2','FATURADO PARCIAL','9','CANCELADO') AS "SITUACAO PEDIDO",
       DB_EDILD_NOMEARQ AS "ARQUIVO DE PEDIDO",
       REPLACE((SELECT CASE
                 WHEN nvl(MAX(DB_EDILE_ARQUIVO), 'Não gerado') = 'Não gerado' THEN
                  'Não gerado'
                 ELSE
                  MAX(DB_EDILE_ARQUIVO)               
               END
          FROM (SELECT *
                  FROM (SELECT DB_EDILE_ID,
                               DB_EDILE_EDIP_COMP,
                               DB_EDILE_EDIP_NRO,
                               DB_EDILE_EDIA_CODI,
                               DB_EDILE_PASTAGER,
                               DB_EDILE_PASTABKP,
                               DB_EDILE_ARQUIVO
                          FROM MERCANET_PRD.DB_EDI_LOG_EXP
                        UNION
                        SELECT DB_EDILE_ID,
                               DB_EDILE_EDIP_COMP,
                               DB_EDILE_EDIP_NRO,
                               DB_EDILE_EDIA_CODI,
                               DB_EDILE_PASTAGER,
                               DB_EDILE_PASTABKP,
                               DB_EDILE_ARQUIVO
                          FROM MERCANET_PRD.DB_EDI_LOG_EXP_HIST))
         WHERE DB_EDIP_NRO = DB_EDILE_EDIP_NRO
           AND DB_EDIP_COMPRADOR = DB_EDILE_EDIP_COMP
           AND DB_EDILE_EDIA_CODI =
               (SELECT EM01_LARQPED
                  FROM MERCANET_PRD.MEM01
                 WHERE EM01_CODIGO = DB_EDIP_VAN)
           AND ROWNUM = 1),'.TEMP',NULL) AS "ARQ DE RETORNO PED",
       DB_EDIP_DTENVIO AS "DATA DE RETORNO DO PED",
              replace((SELECT CASE
                 WHEN nvl(MAX(DB_EDILE_ARQUIVO), 'Não gerado') = 'Não gerado' THEN
                  'Não gerado'
                 ELSE
                  MAX(DB_EDILE_ARQUIVO)
               END
          FROM (SELECT *
                  FROM (SELECT DB_EDILE_ID,
                               DB_EDILE_EDIP_COMP,
                               DB_EDILE_EDIP_NRO,
                               DB_EDILE_EDIA_CODI,
                               DB_EDILE_PASTAGER,
                               DB_EDILE_PASTABKP,
                               DB_EDILE_ARQUIVO
                          FROM MERCANET_PRD.DB_EDI_LOG_EXP
                        UNION
                        SELECT DB_EDILE_ID,
                               DB_EDILE_EDIP_COMP,
                               DB_EDILE_EDIP_NRO,
                               DB_EDILE_EDIA_CODI,
                               DB_EDILE_PASTAGER,
                               DB_EDILE_PASTABKP,
                               DB_EDILE_ARQUIVO
                          FROM MERCANET_PRD.DB_EDI_LOG_EXP_HIST))
         WHERE DB_EDIP_NRO = DB_EDILE_EDIP_NRO
           AND DB_EDIP_COMPRADOR = DB_EDILE_EDIP_COMP
           AND DB_EDILE_EDIA_CODI =
               (SELECT EM01_LARQNF
                  FROM MERCANET_PRD.MEM01
                 WHERE EM01_CODIGO = DB_EDIP_VAN)
           AND ROWNUM = 1),'.TEMP',null) AS "ARQUIVO DE RETORNO NF",
       nvl((SELECT DB_NOTA_DT_ENVIO
             FROM MERCANET_PRD.DB_NOTA_FISCAL
            WHERE DB_NOTA_PED_MERC = DB_EDIP_PEDMERC
              and rownum = 1),
           NULL) as "DATA DE ENVIO DA NOTA"

  FROM MERCANET_PRD.DB_EDI_LOTE_DISTR,
       MERCANET_PRD.DB_EDI_PEDIDO,
       MERCANET_PRD.MEM01
 WHERE DB_EDILD_SEQ = DB_EDIP_LOTE
   AND DB_EDIP_VAN = EM01_CODIGO
   AND (DB_EDIP_NRO IN ('0001276476-540',
                        '0001276492-540',
                        '0001284240-540',
                        '0001284440-540',
                        '0001285239-540',
                        '0001293843-540',
                        '0001295288-540',
                        '0001295456-540',
                        '0001301228-540',
                        '0001303201-540',
                        '0001304024-540') OR
       DB_EDILD_NOMEARQ IN (''
                             
                             ))
