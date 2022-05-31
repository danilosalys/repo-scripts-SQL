select ARQ.*,
       EDIPCOT.db_edip_nro as CODIGO_COT,
       SACOT.sadoco as PEDIDO_JDE_COT,
       -----------DATAS DE RETORNOS DA COTACAO
       PEDCOT.db_ped_data_envio as DATA_ENVIO_JDE_COT,
       PEDTCOT.db_pedt_dtdisp as DATA_RETORNO_JDE_COT,
       EDIPCOT.db_edip_dtenvio as DATA_RETORNO_VAN_COT,
       -----------INFORMAÇÕES DE CABEÇALHO DA EFETIVAÇAO NO JDE
       EDIPEFET.db_edip_pedmerc as PEDIDO_MERC_EFET,
       EDIPEFET.db_edip_nro as CODIGO_EFET,
       SDEFET.sddoco as PEDJDE_EFET,
       SDEFET.sdlnid as LNID_EFET,
       SDEFET.sdoorn as PEDJDE_COT,
       SDEFET.sdogno as LNID_COT,
       -----------DATAS DE RETORNOS DA EFETIVAÇÃO
       PEDEFET.db_ped_data_envio as DATA_ENVIO_JDE_EFET,
       PEDTEFET.db_pedt_dtdisp as DATA_RETORNO_JDE_EFET,
       EDIPEFET.db_edip_dtenvio as DATA_RETORNO_VAN_EFET,
       -----------EAN, QUANTIDADES E STATUS: COTAÇÃO NO MERCANET
       EDIICOT.db_edii_produto as EAN_COT,
       EDIICOT.db_edii_qtde_vda as QTDE_SOLIC_EDII_COT,
       PEDICOT.db_pedi_qtde_solic as QTDE_SOLIC_PEDI_COT,
       PEDICOT.db_pedi_qtde_atend as QTDE_ATEND_PEDI_COT,
       PEDICOT.db_pedi_qtde_canc as QTDE_CANC_PEDI_COT,
       PEDICOT.db_pedi_situacao as SITUACAO_ITEM_COT,
       PEDICOT.db_pedi_sitcorp1 as LTTR_PEDI_COT,
       PEDICOT.db_pedi_sitcorp2 as NXTR_PEDI_COT,
       -----------EAN , QUANTIDADES E STATUS: EFETIVAÇÃO NO MERCANET
       EDIIEFET.db_edii_produto as EAN_EFET,
       EDIIEFET.db_edii_qtde_vda as QTDE_SOLIC_EDII_EFET,
       PEDIEFET.db_pedi_qtde_solic as QTDE_SOLIC_PEDI_EFET,
       PEDIEFET.db_pedi_qtde_atend as QTDE_ATEND_PEDI_EFET,
       PEDIEFET.db_pedi_qtde_canc as QTDE_CANC_PEDI_EFET,
       PEDIEFET.db_pedi_situacao as SITUACAO_ITEM_COT,
       PEDIEFET.db_pedi_sitcorp1 as LTTR_PEDI_COT,
       PEDIEFET.db_pedi_sitcorp2 as NXTR_PEDI_COT,
       -----------QUANTIDADES E STATUS: COTAÇÃO NO JDE 
       SDCOT.sduorg as QTDE_SOLIC_JDE_COT,
       SDCOT.sdsoqs as QTDE_ATEND_JDE_COT,
       SDCOT.sdsocn as QTDE_CANC_JDE_COT,
       SDCOT.sdlttr as LTTR_JDE_COT,
       SDCOT.sdnxtr as NXTR_JDE_COT,
       -----------QUANTIDADES E STATUS: EFETIVAÇÃO NO JDE
       SDEFET.sduorg as QTDE_SOLIC_JDE_EFET,
       SDEFET.sdsoqs as QTDE_ATEND_JDE_EFET,
       SDEFET.sdsocn as QTDE_CANC_JDE_EFET,
       SDEFET.sdlttr as LTTR_JDE_EFET,
       SDEFET.sdnxtr as NXTR_JDE_EFET,
       -----------COMPARAÇÃO MERCANET X JDE : PREÇO BRUTO DA COTAÇÃO
       NVL(PEDICOT.db_pedi_preco_unit, 0) AS PRECO_BRUTO_MERC_COT,
       NVL(SDCOT.sdlprc / 10000, 0) AS PRECO_BRUTO_JDE_COT,
       '' AS COMPARACAO,
       -----------COMPARAÇÃO MERCANET X JDE: PERCENTUAL DE DESCONTO DA COTAÇÃO
       NVL((select sum(PEDD.db_pedd_desconto)
             from mercanet_qa.db_pedido_desconto@dc12.drogacenter.com.br PEDD
            where PEDD.db_pedd_tpdesc = 0
              and PEDD.db_pedd_nro = PEDICOT.db_pedi_pedido
              and PEDD.db_pedd_seqit = PEDICOT.db_pedi_sequencia),
           0) AS DESC_UNIT_MERC_COT,
       NVL((NVL((SELECT SUM(AL.alfvtr)
                  FROM QADTA.f4074 AL
                 WHERE AL.aldoco = SDCOT.sddoco
                   AND AL.allnid = SDCOT.sdlnid
                   AND AL.albscd not in ('8', ' ')
                   AND AL.alfvtr * (-1) > 0
                   and AL.alast not in ('V0000339', 'V0000131', 'V0000133')
                   and AL.aloseq >= nvl((select max(aloseq)
                                          from QADTA.F4074 AL2
                                         where AL2.almded = 'Y'
                                           and AL2.aldoco = AL.aldoco
                                           and AL2.allnid = AL.allnid),
                                        0)),
                0) / 10000 * (-1)) +
           NVL(ROUND(((SELECT (AL2.aluprc)
                         FROM QADTA.f4074 AL2
                        WHERE AL2.aldoco = SDCOT.sddoco
                          AND AL2.allnid = SDCOT.sdlnid
                          AND AL2.aloseq =
                              NVL((SELECT MAX(AL3.aloseq)
                                    FROM QADTA.F4074 AL3
                                   WHERE AL3.almded = 'Y'
                                     AND AL3.aldoco = AL2.aldoco
                                     AND AL3.allnid = AL2.allnid),
                                  0)) /
                     (SELECT (AL4.aluprc)
                         FROM QADTA.f4074 AL4
                        WHERE AL4.aldoco = SDCOT.sddoco
                          AND AL4.allnid = SDCOT.sdlnid
                          AND AL4.aloseq = 0)) * 100 - 100) * (-1),
               0),
           0) as DESC_UNIT_JDE_COT,
           '' AS COMPARACAO,
       -----------COMPARAÇÃO MERCANET X JDE: ST UNITÁRIA DA COTAÇÃO       
       NVL(ROUND(PEDICOT.db_pedi_float1 / PEDICOT.db_pedi_qtde_solic, 2), 0) AS FLOAT1_ST_UNIT_ANT_MERC_COT,
       NVL(ROUND(PEDICOT.db_pedi_vlr_subst / PEDICOT.db_pedi_qtde_solic, 2), 0) AS VALOR_ST_UNIT_MERC_COT,
       CASE
         WHEN NVL((SELECT CASE
                           WHEN SUM(AL.aluprc) <= 0 THEN
                            0
                           ELSE
                            SUM(AL.aluprc) / 10000
                         END
                    FROM QADTA.F4074 AL
                   WHERE AL.aldoco = SDCOT.sddoco
                     AND AL.allnid = SDCOT.sdlnid
                     AND ((SDCOT.sdeuse NOT IN ('PRP', 'PBM', 'ZHR') AND
                         AL.alast IN ('V0000225',
                                        'V0000190',
                                        'V0000350',
                                        'V0000221',
                                        'V0000351')) OR
                         (SDCOT.sdeuse IN ('PRP', 'PBM', 'ZHR') AND
                         AL.alast IN ('V0000238',
                                        'V0000353',
                                        'V0000226',
                                        'V0000222',
                                        'V0000352',
                                        'V0000310',
                                        'V0000319',
                                        'V0000318')))
                   GROUP BY AL.allnid),
                  0) <> 0 THEN
          NVL((SELECT CASE
                       WHEN SUM(AL.aluprc) <= 0 THEN
                        0
                       ELSE
                        SUM(AL.aluprc) / 10000
                     END
                FROM QADTA.F4074 AL
               WHERE AL.aldoco = SDCOT.sddoco
                 AND AL.allnid = SDCOT.sdlnid
                 AND ((SDCOT.sdeuse NOT IN ('PRP', 'PBM', 'ZHR') AND
                     AL.alast IN ('V0000225',
                                    'V0000190',
                                    'V0000350',
                                    'V0000221',
                                    'V0000351')) OR
                     (SDCOT.sdeuse IN ('PRP', 'PBM', 'ZHR') AND
                     AL.alast IN ('V0000238',
                                    'V0000353',
                                    'V0000226',
                                    'V0000222',
                                    'V0000352',
                                    'V0000310',
                                    'V0000319',
                                    'V0000318')))
               GROUP BY AL.allnid),
              0)
         ELSE
          NVL(round(FDEFET.fdbvis / FDEFET.fduorg) / 100, 0)
       END AS VALOR_ST_UNIT_JDE_COT,
       '' AS COMPARACAO,
       -----------COMPARAÇÃO MERCANET X JDE: PREÇO LIQUIDO UNITARIO DA COTAÇÃO        
       NVL(PEDICOT.db_pedi_preco_liq, 0) AS PRECO_LIQ_UNIT_MERC_COT,
       CASE
         WHEN NVL(SDCOT.sdsoqs, 0) = 0 then
          0
         ELSE
          NVL((SDCOT.sdaexp / SDCOT.sdsoqs) / 100, 0)
       END AS PRECO_LIQ_UNIT_JDE_COT,
       '' AS COMPARACAO,
       ------------STATUS DO TESTE DE COTAÇÃO
       '' AS STATUS_DO_TESTE_COTACAO, 
       '' AS OBSERVACAO,
       -----------COMPARAÇÃO MERCANET X JDE : PREÇO BRUTO DA EFETIVAÇÃO
       NVL(PEDIEFET.db_pedi_preco_unit, 0) AS PRECO_BRUTO_MERC_EFET,
       NVL(SDEFET.sdlprc / 10000, 0) AS PRECO_BRUTO_JDE_EFET,
       '' AS COMPARACAO,
       -----------COMPARAÇÃO MERCANET X JDE: PERCENTUAL DE DESCONTO DA EFETIVAÇÃO
       NVL((select sum(PEDD.db_pedd_desconto)
             from mercanet_qa.db_pedido_desconto@dc12.drogacenter.com.br PEDD
            where PEDD.db_pedd_tpdesc = 0
              and PEDD.db_pedd_nro = PEDIEFET.db_pedi_pedido
              and PEDD.db_pedd_seqit = PEDIEFET.db_pedi_sequencia),
           0) AS DESC_UNIT_MERC_EFET,
       NVL((NVL((SELECT SUM(AL.alfvtr)
                  FROM QADTA.f4074 AL
                 WHERE AL.aldoco = SDEFET.sddoco
                   AND AL.allnid = SDEFET.sdlnid
                   AND AL.albscd not in ('8', ' ')
                   AND AL.alfvtr * (-1) > 0
                   and AL.alast not in ('V0000339', 'V0000131', 'V0000133')
                   and AL.aloseq >= nvl((select max(aloseq)
                                          from QADTA.F4074 AL2
                                         where AL2.almded = 'Y'
                                           and AL2.aldoco = AL.aldoco
                                           and AL2.allnid = AL.allnid),
                                        0)),
                0) / 10000 * (-1)) +
           NVL(ROUND(((SELECT (AL2.aluprc)
                         FROM QADTA.f4074 AL2
                        WHERE AL2.aldoco = SDEFET.sddoco
                          AND AL2.allnid = SDEFET.sdlnid
                          AND AL2.aloseq =
                              NVL((SELECT MAX(AL3.aloseq)
                                    FROM QADTA.F4074 AL3
                                   WHERE AL3.almded = 'Y'
                                     AND AL3.aldoco = AL2.aldoco
                                     AND AL3.allnid = AL2.allnid),
                                  0)) /
                     (SELECT (AL4.aluprc)
                         FROM QADTA.f4074 AL4
                        WHERE AL4.aldoco = SDEFET.sddoco
                          AND AL4.allnid = SDEFET.sdlnid
                          AND AL4.aloseq = 0)) * 100 - 100) * (-1),
               0),
           0) as DESC_UNIT_JDE_EFET,
           '' AS COMPARACAO,
       -----------COMPARAÇÃO MERCANET X JDE: ST UNITÁRIA DA EFETIVAÇÃO       
       NVL(ROUND(PEDIEFET.db_pedi_float1 / PEDIEFET.db_pedi_qtde_solic, 2), 0) AS FLOAT1_ST_UNIT_ANT_MERC_EFET,
       NVL(ROUND(PEDIEFET.db_pedi_vlr_subst / PEDIEFET.db_pedi_qtde_solic, 2), 0) AS VALOR_ST_UNIT_MERC_EFET,
       CASE
         WHEN NVL((SELECT CASE
                           WHEN SUM(AL.aluprc) <= 0 THEN
                            0
                           ELSE
                            SUM(AL.aluprc) / 10000
                         END
                    FROM QADTA.F4074 AL
                   WHERE AL.aldoco = SDEFET.sddoco
                     AND AL.allnid = SDEFET.sdlnid
                     AND ((SDEFET.sdeuse NOT IN ('PRP', 'PBM', 'ZHR') AND
                         AL.alast IN ('V0000225',
                                        'V0000190',
                                        'V0000350',
                                        'V0000221',
                                        'V0000351')) OR
                         (SDEFET.sdeuse IN ('PRP', 'PBM', 'ZHR') AND
                         AL.alast IN ('V0000238',
                                        'V0000353',
                                        'V0000226',
                                        'V0000222',
                                        'V0000352',
                                        'V0000310',
                                        'V0000319',
                                        'V0000318')))
                   GROUP BY AL.allnid),
                  0) <> 0 THEN
          NVL((SELECT CASE
                       WHEN SUM(AL.aluprc) <= 0 THEN
                        0
                       ELSE
                        SUM(AL.aluprc) / 10000
                     END
                FROM QADTA.F4074 AL
               WHERE AL.aldoco = SDEFET.sddoco
                 AND AL.allnid = SDEFET.sdlnid
                 AND ((SDEFET.sdeuse NOT IN ('PRP', 'PBM', 'ZHR') AND
                     AL.alast IN ('V0000225',
                                    'V0000190',
                                    'V0000350',
                                    'V0000221',
                                    'V0000351')) OR
                     (SDEFET.sdeuse IN ('PRP', 'PBM', 'ZHR') AND
                     AL.alast IN ('V0000238',
                                    'V0000353',
                                    'V0000226',
                                    'V0000222',
                                    'V0000352',
                                    'V0000310',
                                    'V0000319',
                                    'V0000318')))
               GROUP BY AL.allnid),
              0)
         ELSE
          NVL(round(FDEFET.fdbvis / FDEFET.fduorg) / 100, 0)
       END AS VALOR_ST_UNIT_JDE_EFET,
       '' AS COMPARACAO,
       -----------COMPARAÇÃO MERCANET X JDE: PREÇO LIQUIDO UNITARIO DA EFETIVAÇÃO        
       NVL(PEDIEFET.db_pedi_preco_liq, 0) AS PRECO_LIQ_UNIT_MERC_EFET,
       CASE
         WHEN NVL(SDEFET.sdsoqs, 0) = 0 then
          0
         ELSE
          NVL((SDEFET.sdaexp / SDEFET.sdsoqs) / 100, 0)
       END AS PRECO_LIQ_UNIT_JDE_EFET,
       '' AS COMPARACAO,
       ------------STATUS DO TESTE DE COTAÇÃO
       '' AS STATUS_DO_TESTE_COTACAO, 
       '' AS OBSERVACAO, 
       -----------TIPO DA ST DOS PRODUTOS
       NVL((SELECT CASE
                    WHEN A.tbac76 = '*' AND A.tbbisf > 0 THEN
                     'STANT'
                    ELSE
                     CASE
                       WHEN A.tbac76 = 'VEN' AND A.tbbisf > 0 THEN
                        'STPÓS'
                       ELSE
                        CASE
                          WHEN A.tbac76 = '*' AND A.tbbisf = 0 THEN
                           'SEM ST REGRA DO ITEM'
                          ELSE
                           CASE
                             WHEN A.tbac76 = '*' AND A.tbbisf = 0 THEN
                              'SEM ST REGRA DO ITEM'
                             ELSE
                              'SEM ST REGRA GERAL'
                           END
                        END
                     END
                  END
             FROM QADTA.F7608B A, QADTA.F0101 C
            WHERE A.tbitm = SDCOT.sditm
              AND SDCOT.sdan8 = C.aban8
              AND A.tbitm = SDCOT.sditm
              AND TRIM(A.tbadds) = (CASE
                    WHEN SDCOT.sdemcu IN ('     DIFARMA', '    DIFARSUM') THEN
                     'SP'
                    ELSE
                     CASE
                       WHEN SDCOT.sdemcu = '    DIFARARC' THEN
                        'MG'
                       ELSE
                        CASE
                          WHEN SDCOT.sdemcu = '    DIFARRIO' THEN
                           'RJ'
                          ELSE
                           CASE
                             WHEN SDCOT.sdemcu = '    DIFARCAT' THEN
                              'GO'
                             ELSE
                              CASE
                                WHEN SDCOT.sdemcu = '    DIFARBRA' THEN
                                 'DF'
                                ELSE
                                 CASE
                                   WHEN SDCOT.sdemcu = '   DIFARCAMB' THEN
                                    'PR'
                                   ELSE
                                    'ERRO'
                                 END
                              END
                           END
                        END
                     END
                  END)
              AND TRIM(A.tbshst) = TRIM(C.abac16)
              AND A.tbac76 IN ('*', 'VEN')
              AND rownum = 1),
           'SEM ST') AS TIPO_ST
  from dsales.teste_integracao_st@DC12.DROGACENTER.COM.BR ARQ
  left join mercanet_qa.db_edi_pedido@dc12.drogacenter.com.br EDIPCOT
    on ARQ.ped_mercanet = EDIPCOT.db_edip_pedmerc
  left join mercanet_qa.db_edi_pedido@dc12.drogacenter.com.br EDIPEFET
    on EDIPCOT.db_edip_obs1 = EDIPEFET.db_edip_obs1
   and EDIPEFET.db_edip_van = 530
  left join (select *
               from mercanet_qa.db_edi_pedprod@dc12.drogacenter.com.br,
                    mercanet_qa.db_produto_embal@dc12.drogacenter.com.br
              where db_edii_produto = db_prdemb_codbarra) EDIICOT
    on TRIM(ARQ.codigo_produto) = EDIICOT.db_prdemb_produto
   and EDIPCOT.db_edip_nro = EDIICOT.db_edii_nro
   and EDIPCOT.db_edip_comprador = EDIICOT.db_edii_comprador
   and EDIPCOT.db_edip_pedmerc = EDIICOT.db_edii_pedmerc
  left join mercanet_qa.db_edi_pedprod@dc12.drogacenter.com.br EDIIEFET
    on EDIPEFET.db_edip_nro = EDIIEFET.db_edii_nro
   and EDIPEFET.db_edip_comprador = EDIIEFET.db_edii_comprador
   and EDIICOT.db_edii_produto = EDIIEFET.db_edii_produto
  left join mercanet_qa.db_pedido_distr@dc12.drogacenter.com.br PEDTCOT
    on PEDTCOT.db_pedt_pedido = EDIPCOT.db_edip_pedmerc
  left join mercanet_qa.db_pedido_distr@dc12.drogacenter.com.br PEDTEFET
    on PEDTEFET.db_pedt_pedido = EDIPEFET.db_edip_pedmerc
  left join mercanet_qa.db_pedido_distr_it@dc12.drogacenter.com.br PDITCOT
    on PDITCOT.db_pdit_pedido = PEDTCOT.db_pedt_pedido
   and PDITCOT.db_pdit_produto = EDIICOT.db_prdemb_produto
   and PDITCOT.db_pdit_pedido = EDIICOT.db_edii_pedmerc
   and PDITCOT.db_pdit_pedido = ARQ.ped_mercanet
  left join mercanet_qa.db_pedido_distr_it@dc12.drogacenter.com.br PDITEFET
    on PDITEFET.db_pdit_pedido = PEDTEFET.db_pedt_pedido
   and PDITEFET.db_pdit_produto = EDIICOT.db_prdemb_produto
  left join mercanet_qa.db_pedido@dc12.drogacenter.com.br PEDCOT
    on PEDCOT.db_ped_nro = PEDTCOT.db_pedt_pedido
  left join mercanet_qa.db_pedido@dc12.drogacenter.com.br PEDEFET
    on PEDEFET.db_ped_nro = PEDTEFET.db_pedt_pedido
  left join mercanet_qa.db_pedido_prod@dc12.drogacenter.com.br PEDICOT
    on PEDICOT.db_pedi_pedido = PDITCOT.db_pdit_pedido
   and PEDICOT.db_pedi_produto = PDITCOT.db_pdit_produto
  left join mercanet_qa.db_pedido_prod@dc12.drogacenter.com.br PEDIEFET
    on PEDIEFET.db_pedi_pedido = PDITEFET.db_pdit_pedido
   and PEDIEFET.db_pedi_produto = PDITEFET.db_pdit_produto
  left join qadta.f5547011 SACOT
    on TO_CHAR(PEDCOT.db_ped_nro) = TRIM(SACOT.savr01)
  left join qadta.f5547011 SAEFET
    on TO_CHAR(PEDEFET.db_ped_nro) = TRIM(SAEFET.savr01)
   and SAEFET.sadocd = SACOT.sadocd
   and SAEFET.saz55ori = 'PTC'
  left join qadta.f5547012 SBCOT
    on SBCOT.sbukid = SACOT.saukid
   and trim(SBCOT.sblitm) = to_char(PEDICOT.db_pedi_produto)
  left join qadta.f5547012 SBEFET
    on SBEFET.sbukid = SAEFET.saukid
   and trim(SBEFET.sblitm) = to_char(PEDIEFET.db_pedi_produto)
   and trim(SBEFET.sblitm) = to_char(PEDICOT.db_pedi_produto)
  left join qadta.f4211 SDCOT
    on SDCOT.sddoco = SACOT.sadoco
   and SDCOT.sdlitm = SBCOT.sblitm
  left join qadta.f4211 SDEFET
    on SDEFET.sddoco = SAEFET.sadoco
   and SDEFET.sdlitm = SBEFET.sblitm
   and SDEFET.sdoorn = SDCOT.sddoco
   and SDEFET.sdogno = SDCOT.sdlnid
   and SDEFET.sdocto = SDCOT.sddcto
  left join qadta.f7611b FDEFET
    on SDEFET.sddoco = FDEFET.fddoco
   and SDEFET.sdlnid = FDEFET.fdlnid
  left join qadta.f555511 EDEFET
    on FDEFET.fdbnnf = EDEFET.edbnnf
   and FDEFET.fdbser = EDEFET.edbser
   and FDEFET.fdn001 = EDEFET.edn001
   and FDEFET.fdlnid = EDEFET.edlnid
  ---where id_arquivo = 1
  where codigo_produto <> 'Não se aplica'
    and EDIPCOT.db_edip_pedmerc > 0 
    and EDIPCOT.db_edip_pedmerc is not null 
 order by TO_NUMBER(id_arquivo), TO_NUMBER(id_produto);






