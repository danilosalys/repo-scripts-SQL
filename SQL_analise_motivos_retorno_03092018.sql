SELECT TB0.DB_EDILD_DATA /*...........................................*/ AS DATA_PROCESSAMENTO, 
       TB0.DB_EDILD_NOMEARQ /*........................................*/ AS ARQUIVO_PEDIDO, 
       TB1.DB_EDIP_VAN /*.............................................*/ AS VAN, 
       TB1.DB_EDIP_LOTE /*............................................*/ AS LOTE,  
       TB1.DB_EDIP_PEDMERC /*.........................................*/ AS PEDIDO_MERCANET,  
       TB1.DB_EDIP_NRO /*.............................................*/ AS PEDIDO_VAN,
       TB3.DB_PEDT_DTDISP /*..........................................*/ AS DATA_RETORNO_JDE,
       TB4.DB_PED_SITUACAO /*.........................................*/ AS SITUACAO_PEDIDO,
       CASE
         WHEN TB4.DB_PED_SITUACAO = 0 THEN
          'LIBERADO'
         ELSE
          CASE
         WHEN TB4.DB_PED_SITUACAO = 1 THEN
          'BLOQUEADO'
         ELSE
          CASE
         WHEN TB4.DB_PED_SITUACAO = 2 THEN
          'FATURADO PARCIAL'
         ELSE
           CASE
         WHEN TB4.DB_PED_SITUACAO = 4 THEN
          'FATURADO'
         ELSE
          'CANCELADO'
       END END END END /*.............................................*/ AS DESCRICAO_SITUACAO_PED,
       TB4.DB_PED_SITCORP /*..........................................*/ AS SITUACAO_CORPORATIVO,
       CASE
         WHEN TB4.DB_PED_SITCORP = 0 THEN
          'LIBERADO'
         ELSE
          CASE
         WHEN TB4.DB_PED_SITCORP = 1 THEN
          'BLOQUEADO MN'
         ELSE
          CASE
         WHEN TB4.DB_PED_SITCORP = 2 THEN
          'BLOQUEADO C2'
         ELSE
          CASE
         WHEN TB4.DB_PED_SITCORP = 3 THEN
          'FATURADO PARCIAL'
         ELSE
          CASE
         WHEN TB4.DB_PED_SITCORP = 5 THEN
          'CANCEL BLOQ DO CLIENTE'
         ELSE
          CASE 
            WHEN TB4.DB_PED_SITCORP IS NULL THEN 
          'LIBERADO' 
          ELSE 'CANCELADO'
       END END END END END END /*.........................................*/ AS DESCRICAO_SITCORP,
       TB2.DB_EDII_PRODUTO /*.........................................*/ AS COD_BARRA,
       TB6.DB_PEDI_PRODUTO /*.........................................*/ AS COD_PRODUTO,
       TB6.DB_PEDI_SITUACAO /*........................................*/ AS SITUACAO_PRODUTO,
       CASE
         WHEN TB6.DB_PEDI_SITUACAO = 0 THEN
          'LIBERADO'
         ELSE
          CASE
         WHEN TB6.DB_PEDI_SITUACAO = 1 THEN
          'FATURADO PARCIAL'
         ELSE
          CASE
         WHEN TB6.DB_PEDI_SITUACAO = 2 THEN
          'FATURADO'
         ELSE
          'CANCELADO'
       END END END /*.................................................*/ AS DESCRICAO_SITUACAO_PROD,
       TB6.DB_PEDI_MOTCANC /*.........................................*/ AS MOTIVO_CANCELAMENTO,
       TB6.DB_PEDI_SITCORP1 /*........................................*/ AS ULTIMO_STATUS,
       TB6.DB_PEDI_SITCORP2 /*........................................*/ AS PROXIMO_STATUS,
       (SELECT (SELECT SUM(LIPQOH - LIHCOM)
                  FROM qadta.F41021
                 WHERE LIMCU = IBMCU
                   AND LIITM = IBITM
                   AND LIPBIN = 'S'
                   AND LILOTS = ' '
                 GROUP BY LIITM) 
                 - 
               (SELECT SUM(LIPQOH - LIPCOM)
                  FROM qadta.F41021
                 WHERE LIMCU = IBMCU
                   AND LIITM = IBITM
                   AND LIPBIN = 'P'
                   AND LILOCN = 'ENTRADA'
                 GROUP BY LIITM) * -1 - IBSAFE  AS SALDO_ESTOQUE
          FROM QADTA.F4102
         WHERE IBLITM = RPAD(DB_PEDI_PRODUTO,25,' ')
           AND TRIM(IBMCU) 
               IN 
               DECODE(IBSHCN,'TMB','DIFARMA', 
                      NVL((SELECT TRIM(DRDL01)
                             FROM qadta.F0005
                            WHERE DRSY = '55'
                              AND DRRT = 'ZS'
                              AND TRIM(DRKY) 
                              = 
                              TRIM(IBSHCN)),'DIFARCAT'))) /*..........*/ AS ESTOQUE,
        TB2.DB_EDII_MOTIVORET AS MOTIVO_RETORNO,                      
       (SELECT TB2.DB_EDII_MOTIVORET||' - '||DB_MOTR_DESCR
          FROM MERCANET_QA.DB_MOTIVO_RETDISTR@DC12.DROGACENTER.COM.BR
         WHERE DB_EDII_MOTIVORET = DB_MOTR_CODIGO) /*.................*/ AS MOTIVO_COM_DESCRICAO, 
       (CASE WHEN DB_EDIP_VAN = 503 
          THEN NVL(((CASE WHEN SUBSTR(db_edii_motivoret,3,2) in('03','11','12','21') THEN '  '  ELSE  CASE WHEN SUBSTR(db_edii_motivoret,3,2) = '52' and db_edip_pedmerc is null THEN ' ' ELSE  CASE WHEN SUBSTR(db_edii_motivoret,3,2) = '52' THEN '13' ELSE SUBSTR(db_edii_motivoret,3,2) END END END)),'  ') ELSE
        CASE WHEN DB_EDIP_VAN = 504 
          THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
        CASE WHEN DB_EDIP_VAN IN (502,505) 
          THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
        CASE WHEN DB_EDIP_VAN = 506 
          THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
        CASE WHEN DB_EDIP_VAN = 508 
          THEN (SUBSTR(db_edii_motivoret,3,3)) ELSE
        CASE WHEN DB_EDIP_VAN = 509 
          THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
        CASE WHEN DB_EDIP_VAN = 510 
          THEN (SUBSTR(db_edii_motivoret,3,3)) ELSE
        CASE WHEN DB_EDIP_VAN = 511 
          THEN NVL(DECODE(SUBSTR(db_edii_motivoret,3,2),'03','PROBLEMAS CADASTRAIS','04','PRODUTO NÃO CADASTRADO/DESATIVADO','05','FALTA DE LIMITE DE CREDITO','06','FALTA NO ESTOQUE','07','PRODUTO BLOQUEADO','13','PRODUTO OK','14','PRODUTO ATENDIDO PARCIALMENTE','52','PEDIDO NÃO ALCANÇOU O VALOR MÍNIMO','21','CLIENTE INVALIDO','11','PRODUTO BLOQUEADO',' '),' ') ELSE
        CASE WHEN DB_EDIP_VAN = 513 
          THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
        CASE WHEN DB_EDIP_VAN = 514 
          THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
        CASE WHEN DB_EDIP_VAN = 515 
          THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
        CASE WHEN DB_EDIP_VAN = 516 
          THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
        CASE WHEN DB_EDIP_VAN = 517 
          THEN DECODE((SUBSTR(db_edii_motivoret,3,4)),'002',(case when (select count(1) from MERCANET_QA.db_pedido_distr_it@DC12.DROGACENTER.COM.BR t1, MERCANET_QA.db_pedido_prod@DC12.DROGACENTER.COM.BR t2 where TB1.db_edip_pedmerc = t1.db_pdit_pedido and TB2.db_edii_seq = t1.db_pdit_edii_seq and t1.db_pdit_pedido = t2.db_pedi_pedido and t1.db_pdit_pedi_seq = t2.db_pedi_sequencia and t1.db_pdit_produto = t2.db_pedi_produto and t2.db_pedi_sitcorp1 = '520') > 0 then '004' else '201' end),(SUBSTR(db_edii_motivoret,3,4))) ELSE
        CASE WHEN DB_EDIP_VAN = 518 
          THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
        CASE WHEN DB_EDIP_VAN = 520 
          THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
        CASE WHEN DB_EDIP_VAN = 521 
          THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
        CASE WHEN DB_EDIP_VAN = 531 
          THEN (SUBSTR(db_edii_motivoret,3,3)) ELSE
        CASE WHEN DB_EDIP_VAN = 540 
          THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE 'MOTIVO RETORNO' 
        END
        END
        END
        END
        END
        END
        END
        END
        END
        END
        END
        END
        END
        END
        END
        END
        END
        END) /*......................................................*/  AS MOTIVO_INFORMADO_ARQUIVO, 
       TB1.DB_EDIP_DTENVIO /*.........................................*/ AS DATA_RETORNO_VAN       
  FROM MERCANET_QA.DB_EDI_LOTE_DISTR@DC12.DROGACENTER.COM.BR   TB0,
       MERCANET_QA.DB_EDI_PEDIDO@DC12.DROGACENTER.COM.BR       TB1,
       MERCANET_QA.DB_EDI_PEDPROD@DC12.DROGACENTER.COM.BR      TB2,
       MERCANET_QA.DB_PEDIDO_DISTR@DC12.DROGACENTER.COM.BR     TB3,
       MERCANET_QA.DB_PEDIDO@DC12.DROGACENTER.COM.BR           TB4,
       MERCANET_QA.DB_PEDIDO_DISTR_IT@DC12.DROGACENTER.COM.BR  TB5,
       MERCANET_QA.DB_PEDIDO_PROD@DC12.DROGACENTER.COM.BR      TB6
 WHERE TB0.DB_EDILD_SEQ = TB1.DB_EDIP_LOTE
   AND TB1.DB_EDIP_NRO = TB2.DB_EDII_NRO      
   AND TB1.DB_EDIP_COMPRADOR = TB2.DB_EDII_COMPRADOR
   AND TB0.DB_EDILD_DATA > TO_DATE('06/06/2018 17:00:00','DD/MM/YYYY HH24:MI:SS')
--   AND TB1.DB_EDIP_DTENVIO IS NULL--(TB1.DB_EDIP_DTENVIO NOT IN ('31/12/9999') OR TB1.DB_EDIP_DTENVIO IS NOT NULL)
   AND TB1.DB_EDIP_PEDMERC = TB3.DB_PEDT_PEDIDO (+)
   AND TB3.DB_PEDT_PEDIDO = TB4.DB_PED_NRO (+)
   AND TB2.DB_EDII_PEDMERC = TB5.DB_PDIT_PEDIDO (+)
   AND TB2.DB_EDII_SEQ = TB5.DB_PDIT_EDII_SEQ (+)
   AND TB5.DB_PDIT_PEDIDO = TB6.DB_PEDI_PEDIDO (+)
   AND TB5.DB_PDIT_PRODUTO = TB6.DB_PEDI_PRODUTO (+)
 --  and tb1.db_edip_van = 516
ORDER BY TB1.DB_EDIP_DTENVIO, TB1.DB_EDIP_VAN
   
