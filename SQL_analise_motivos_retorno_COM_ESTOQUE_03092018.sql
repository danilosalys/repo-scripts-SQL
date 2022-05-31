SELECT DB_EDIP_VAN, 
       (SELECT DB_EDIP_PROJETO || ' - ' || DB_LAB_DESCRICAO 
          FROM MERCANET_QA.DB_LABORATORIO@DC12.DROGACENTER.COM.BR
         WHERE DB_EDIP_LABCOD = DB_LAB_CODIGO) AS LABORATORIO, 
       DB_PEDI_PEDIDO,
       DB_PEDI_PRODUTO,
       DB_PED_SITUACAO,
       CASE
         WHEN DB_PED_SITUACAO = 0 THEN
          'LIBERADO'
         ELSE
          CASE
         WHEN DB_PED_SITUACAO = 1 THEN
          'BLOQUEADO'
         ELSE
          CASE
         WHEN DB_PED_SITUACAO = 2 THEN
          'FATURADO PARCIAL'
         ELSE
           CASE
         WHEN DB_PED_SITUACAO = 4 THEN
          'FATURADO'
         ELSE
          'CANCELADO'
       END END END END PED_SITUACAO,
       DB_PED_SITCORP,
       CASE
         WHEN DB_PED_SITCORP = 0 THEN
          'LIBERADO'
         ELSE
          CASE
         WHEN DB_PED_SITCORP = 1 THEN
          'BLOQUEADO MN'
         ELSE
          CASE
         WHEN DB_PED_SITCORP = 2 THEN
          'BLOQUEADO C2'
         ELSE
          CASE
         WHEN DB_PED_SITCORP = 3 THEN
          'FATURADO PARCIAL'
         ELSE
          CASE
         WHEN DB_PED_SITCORP = 5 THEN
          'CANCEL BLOQ DO CLIENTE'
         ELSE
          'CANCELADO'
       END END END END END SITCORP,
       DB_PEDI_SITUACAO,
       CASE
         WHEN DB_PEDI_SITUACAO = 0 THEN
          'LIBERADO'
         ELSE
          CASE
         WHEN DB_PEDI_SITUACAO = 1 THEN
          'FATURADO PARCIAL'
         ELSE
          CASE
         WHEN DB_PEDI_SITUACAO = 2 THEN
          'FATURADO'
         ELSE
          'CANCELADO'
       END END END PEDI_SITUACAO,
       DB_PEDI_SITCORP1,
       DB_PEDI_SITCORP2,
       DB_PEDI_QTDE_SOLIC, 
       DB_PEDI_QTDE_ATEND, 
       DB_PEDI_MOTCANC,
       (SELECT DISPONIBILIDADE 
          FROM (SELECT IBLITM ,( (SUM(LIPQOH - (LIPCOM + LIHCOM))) - MAX(IBSAFE)) AS  DISPONIBILIDADE
                    from 
                   QADTA.F4101,
                   (SELECT * FROM (select *
                      from QADTA.f4102, QADTA.f41021
                     where trim(ibmcu) = 'DIFARCAT'
                       and liitm = ibitm
                       and lilocn NOT IN ('ENTRADA', 'VENCIDO', 'DEVOL')
                       and ibstkt != 'O'
                    union
                    SELECT *
                      from QADTA.f4102,QADTA.f41021
                     where trim(ibmcu) = 'DIFARCAT'
                       and liitm = ibitm
                       and lilocn = 'ENTRADA'
                       and ibstkt != 'O'
                       and lilotn = ' '
                    union 
                    select *
                      from QADTA.f4102, QADTA.f41021
                     where trim(ibmcu) = 'DIFARES'
                       and ibshcn = 'ES'
                       and liitm = ibitm
                       and lilocn NOT IN ('ENTRADA', 'VENCIDO', 'DEVOL')
                       and ibstkt != 'O'
                    union
                    SELECT *
                      from QADTA.f4102,QADTA.f41021
                     where trim(ibmcu) = 'DIFARES'
                       and ibshcn = 'ES'
                       and liitm = ibitm
                       and lilocn = 'ENTRADA'
                       and ibstkt != 'O'
                       and lilotn = ' '
                     union 
                     select *
                      from QADTA.f4102, QADTA.f41021
                     where trim(ibmcu) = 'DIFARMA'
                       and ibshcn = 'COL'
                       and liitm = ibitm
                       and lilocn NOT IN ('ENTRADA', 'VENCIDO', 'DEVOL')
                       and ibstkt != 'O'
                    union
                    SELECT *
                      from QADTA.f4102,QADTA.f41021
                     where trim(ibmcu) = 'DIFARMA'
                       and ibshcn = 'COL'
                       and liitm = ibitm
                       and lilocn = 'ENTRADA'
                       and ibstkt != 'O'
                       and lilotn = ' ')
                     WHERE IBITM IN (select imitm from QADTA.f4101 where imshcn NOT IN ('ES','COL')))
             WHERE IMITM = IBITM
             GROUP BY IBLITM) 
         WHERE IBLITM = RPAD(DB_PEDI_PRODUTO,25,' '))AS ESTOQUE,
                 (SELECT DB_EDII_MOTIVORET || ' - ' || DB_MOTR_DESCR
                    FROM MERCANET_QA.DB_EDI_PEDPROD@DC12.DROGACENTER.COM.BR, 
                         MERCANET_QA.DB_PEDIDO_DISTR_IT@DC12.DROGACENTER.COM.BR,MERCANET_QA.DB_MOTIVO_RETDISTR@DC12.DROGACENTER.COM.BR
                   WHERE DB_PEDI_PEDIDO = DB_PDIT_PEDIDO 
                     AND DB_PEDI_PRODUTO = DB_PDIT_PRODUTO
                     AND DB_PDIT_PEDIDO = DB_EDII_PEDMERC
                     AND DB_PDIT_EDII_SEQ = DB_EDII_SEQ
                     AND DB_EDII_MOTIVORET = DB_MOTR_CODIGO) AS MOTIVO_INTEGRADO,
                   (SELECT (CASE WHEN DB_EDIP_VAN = 503 THEN NVL(((CASE WHEN SUBSTR(db_edii_motivoret,3,2) in('03','11','12','21') THEN '  '  ELSE  CASE WHEN SUBSTR(db_edii_motivoret,3,2) = '52' and db_edip_pedmerc is null THEN ' ' ELSE  CASE WHEN SUBSTR(db_edii_motivoret,3,2) = '52' THEN '13' ELSE SUBSTR(db_edii_motivoret,3,2) END END END)),'  ') ELSE
CASE WHEN DB_EDIP_VAN = 504 THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
CASE WHEN DB_EDIP_VAN IN (502,505) THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
CASE WHEN DB_EDIP_VAN = 506 THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
CASE WHEN DB_EDIP_VAN = 508 THEN (SUBSTR(db_edii_motivoret,3,3)) ELSE
CASE WHEN DB_EDIP_VAN = 509 THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
CASE WHEN DB_EDIP_VAN = 510 THEN (SUBSTR(db_edii_motivoret,3,3)) ELSE
CASE WHEN DB_EDIP_VAN = 511 THEN NVL(DECODE(SUBSTR(db_edii_motivoret,3,2),'03','PROBLEMAS CADASTRAIS','04','PRODUTO NÃO CADASTRADO/DESATIVADO','05','FALTA DE LIMITE DE CREDITO','06','FALTA NO ESTOQUE','07','PRODUTO BLOQUEADO','13','PRODUTO OK','14','PRODUTO ATENDIDO PARCIALMENTE','52','PEDIDO NÃO ALCANÇOU O VALOR MÍNIMO','21','CLIENTE INVALIDO','11','PRODUTO BLOQUEADO',' '),' ') ELSE
CASE WHEN DB_EDIP_VAN = 513 THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
CASE WHEN DB_EDIP_VAN = 514 THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
CASE WHEN DB_EDIP_VAN = 515 THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
CASE WHEN DB_EDIP_VAN = 516 THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
CASE WHEN DB_EDIP_VAN = 517 THEN DECODE((SUBSTR(db_edii_motivoret,3,4)),'002',(case when (select count(1) from MERCANET_QA.db_pedido_distr_it@DC12.DROGACENTER.COM.BR t1, MERCANET_QA.db_pedido_prod@DC12.DROGACENTER.COM.BR t2 where X1.db_edip_pedmerc = t1.db_pdit_pedido and X2.db_edii_seq = t1.db_pdit_edii_seq and t1.db_pdit_pedido = t2.db_pedi_pedido and t1.db_pdit_pedi_seq = t2.db_pedi_sequencia and t1.db_pdit_produto = t2.db_pedi_produto and t2.db_pedi_sitcorp1 = '520') > 0 then '004' else '201' end),(SUBSTR(db_edii_motivoret,3,4))) ELSE
CASE WHEN DB_EDIP_VAN = 518 THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
CASE WHEN DB_EDIP_VAN = 520 THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
CASE WHEN DB_EDIP_VAN = 521 THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE
CASE WHEN DB_EDIP_VAN = 531 THEN (SUBSTR(db_edii_motivoret,3,3)) ELSE
CASE WHEN DB_EDIP_VAN = 540 THEN (SUBSTR(db_edii_motivoret,3,2)) ELSE 'MOTIVO RETORNO' 
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
END)
 AS MOTIVO_INFORMADO_ARQUIVO
             FROM MERCANET_QA.DB_EDI_PEDIDO@DC12.DROGACENTER.COM.BR  X1, 
                  MERCANET_QA.DB_EDI_PEDPROD@DC12.DROGACENTER.COM.BR X2, 
                  MERCANET_QA.db_pedido_distr_it@DC12.DROGACENTER.COM.BR X3, 
                  MERCANET_QA.DB_PEDIDO_PROD@DC12.DROGACENTER.COM.BR X4, 
                  MERCANET_QA.DB_MOTIVO_RETDISTR@DC12.DROGACENTER.COM.BR X5
            WHERE X1.DB_EDIP_COMPRADOR = X2.DB_EDII_COMPRADOR
            AND X1.DB_EDIP_NRO = X2.DB_EDII_NRO
            AND DB_EDII_PEDMERC = X3.DB_PDIT_PEDIDO
            AND X2.DB_EDII_SEQ = X3.DB_PDIT_EDII_SEQ
            AND X3.DB_PDIT_PEDIDO = X4.DB_PEDI_PEDIDO 
            AND X3.DB_PDIT_PRODUTO = X4.DB_PEDI_PRODUTO
            AND X2.DB_EDII_MOTIVORET = X5.DB_MOTR_CODIGO
            AND X1.DB_EDIP_PEDMERC = TB5.DB_PED_NRO
            AND X4.DB_PEDI_PRODUTO = TB4.DB_PEDI_PRODUTO
            AND X4.DB_PEDI_SEQUENCIA = TB4.DB_PEDI_SEQUENCIA) AS MOTIVO_INFORMADO_ARQUIVO
 FROM MERCANET_QA.DB_EDI_PEDIDO@DC12.DROGACENTER.COM.BR TB1, 
     -- MERCANET_QA.DB_EDI_PEDPROD@DC12.DROGACENTER.COM.BR TB2,
      --MERCANET_QA.DB_PEDIDO_DISTR_IT@DC12.DROGACENTER.COM.BR TB3,
      MERCANET_QA.DB_PEDIDO_PROD@DC12.DROGACENTER.COM.BR TB4, 
      MERCANET_QA.DB_PEDIDO@DC12.DROGACENTER.COM.BR TB5     
 WHERE TB5.DB_PED_NRO = TB4.DB_PEDI_PEDIDO 
   AND TB5.DB_PED_DT_EMISSAO > '05/06/2018'
   --AND TB4.DB_PEDI_QTDE_ATEND = 0 
   AND TB1.DB_EDIP_PEDMERC = TB5.DB_PED_NRO(+)
   --AND TB1.DB_EDIP_NRO = TB2.DB_EDII_NRO
   --AND TB1.DB_EDIP_COMPRADOR = TB2.DB_EDII_COMPRADOR
   --AND TB2.DB_EDII_PEDMERC = TB3.
