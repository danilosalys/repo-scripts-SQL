--ACOMPANHAMENTO DE PEDIDOS OL 
select ARQ.*,
       EDIP.db_edip_nro as CODIGO_PEDIDO_VAN,
       EDIP.db_edip_pedmerc as PEDIDO_MERC,
       SA.sadoco as PEDIDO_JDE,
       -----------DATAS DE RETORNOS
       PED.db_ped_data_envio as DATA_ENVIO_JDE,
       PEDT.db_pedt_dtdisp as DATA_RETORNO_JDE,
       EDIP.db_edip_dtenvio as DATA_RETORNO_VAN,
       -----------DATAS DE RETORNOS
       PED.db_ped_data_envio as DATA_ENVIO_JDE,
       PEDT.db_pedt_dtdisp as DATA_RETORNO_JDE,
       EDIP.db_edip_dtenvio as DATA_RETORNO_VAN,
       -----------EAN, QUANTIDADES E STATUS NO MERCANET
       EDII.db_edii_produto as EAN,
       EDII.db_edii_qtde_vda as QTDE_SOLIC_EDII,
       PEDI.db_pedi_qtde_solic as QTDE_SOLIC_PEDI,
       PEDI.db_pedi_qtde_atend as QTDE_ATEND_PEDI,
       PEDI.db_pedi_qtde_canc as QTDE_CANC_PEDI,
       PEDI.db_pedi_situacao as SITUACAO_ITEM,
       PEDI.db_pedi_sitcorp1 as LTTR_PEDI,
       PEDI.db_pedi_sitcorp2 as NXTR_PEDI,
       -----------QUANTIDADES E STATUS NO JDE
       SD.sduorg as QTDE_SOLIC_JDE,
       SD.sdsoqs as QTDE_ATEND_JDE,
       SD.sdsocn as QTDE_CANC_JDE,
       SD.sdlttr as LTTR_JDE,
       SD.sdnxtr as NXTR_JDE,
       -----------COMPARAÇÃO MERCANET X JDE : PREÇO BRUTO
       NVL(PEDI.db_pedi_preco_unit, 0) AS PRECO_BRUTO_MERC,
       NVL(SD.sdlprc / 10000, 0) AS PRECO_BRUTO_JDE,
       '' AS COMPARACAO,
       -----------COMPARAÇÃO MERCANET X JDE: PERCENTUAL DE DESCONTO
       NVL((select sum(PEDD.db_pedd_desconto)
             from mercanet_prd.db_pedido_desconto@dc09 PEDD
            where PEDD.db_pedd_tpdesc = 0
              and PEDD.db_pedd_nro = PEDI.db_pedi_pedido
              and PEDD.db_pedd_seqit = PEDI.db_pedi_sequencia),
           0) AS DESC_UNIT_MERC,
       NVL((NVL((SELECT SUM(AL.alfvtr)
                  FROM proddta.f4074 AL
                 WHERE AL.aldoco = SD.sddoco
                   AND AL.allnid = SD.sdlnid
                   AND AL.albscd not in ('8', ' ')
                   AND AL.alfvtr * (-1) > 0
                   and AL.alast not in ('V0000339', 'V0000131', 'V0000133')
                   and AL.aloseq >= nvl((select max(aloseq)
                                          from proddta.F4074 AL2
                                         where AL2.almded = 'Y'
                                           and AL2.aldoco = AL.aldoco
                                           and AL2.allnid = AL.allnid),
                                        0)),
                0) / 10000 * (-1)) +
           NVL(ROUND(((SELECT (AL2.aluprc)
                         FROM proddta.f4074 AL2
                        WHERE AL2.aldoco = SD.sddoco
                          AND AL2.allnid = SD.sdlnid
                          AND AL2.aloseq =
                              NVL((SELECT MAX(AL3.aloseq)
                                    FROM proddta.F4074 AL3
                                   WHERE AL3.almded = 'Y'
                                     AND AL3.aldoco = AL2.aldoco
                                     AND AL3.allnid = AL2.allnid),
                                  0)) /
                     (SELECT (AL4.aluprc)
                         FROM proddta.f4074 AL4
                        WHERE AL4.aldoco = SD.sddoco
                          AND AL4.allnid = SD.sdlnid
                          AND AL4.aloseq = 0)) * 100 - 100) * (-1),
               0),
           0) as DESC_UNIT_JDE,
           '' AS COMPARACAO,
       -----------COMPARAÇÃO MERCANET X JDE: ST UNITÁRIA
       NVL(ROUND(PEDI.db_pedi_float1 / PEDI.db_pedi_qtde_solic, 2), 0) AS FLOAT1_ST_UNIT_ANT_MERC,
       NVL(ROUND(PEDI.db_pedi_vlr_subst / PEDI.db_pedi_qtde_solic, 2), 0) AS VALOR_ST_UNIT_MERC,
       CASE
         WHEN NVL((SELECT CASE
                           WHEN SUM(AL.aluprc) <= 0 THEN
                            0
                           ELSE
                            SUM(AL.aluprc) / 10000
                         END
                    FROM proddta.F4074 AL
                   WHERE AL.aldoco = SD.sddoco
                     AND AL.allnid = SD.sdlnid
                     AND ((SD.sdeuse NOT IN ('PRP', 'PBM', 'ZHR') AND
                         AL.alast IN ('V0000225',
                                        'V0000190',
                                        'V0000350',
                                        'V0000221',
                                        'V0000351')) OR
                         (SD.sdeuse IN ('PRP', 'PBM', 'ZHR') AND
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
                FROM proddta.F4074 AL
               WHERE AL.aldoco = SD.sddoco
                 AND AL.allnid = SD.sdlnid
                 AND ((SD.sdeuse NOT IN ('PRP', 'PBM', 'ZHR') AND
                     AL.alast IN ('V0000225',
                                    'V0000190',
                                    'V0000350',
                                    'V0000221',
                                    'V0000351')) OR
                     (SD.sdeuse IN ('PRP', 'PBM', 'ZHR') AND
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
          NVL(round(FD.fdbvis / FD.fduorg) / 100, 0)
       END AS VALOR_ST_UNIT_JDE,
       '' AS COMPARACAO,
       -----------COMPARAÇÃO MERCANET X JDE: PREÇO LIQUIDO UNITARIO
       NVL(PEDI.db_pedi_preco_liq, 0) AS PRECO_LIQ_UNIT_MERC,
       CASE
         WHEN NVL(SD.sdsoqs, 0) = 0 then
          0
         ELSE
          NVL((SD.sdaexp / SD.sdsoqs) / 100, 0)
       END AS PRECO_LIQ_UNIT_JDE,
       '' AS COMPARACAO,
       ------------STATUS DO TESTE
       '' AS STATUS_DO_TESTE,
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
             FROM proddta.F7608B A, proddta.F0101 C
            WHERE A.tbitm = SD.sditm
              AND SD.sdan8 = C.aban8
              AND A.tbitm = SD.sditm
              AND TRIM(A.tbadds) = (CASE
                    WHEN SD.sdemcu IN ('     DIFARMA', '    DIFARSUM') THEN
                     'SP'
                    ELSE
                     CASE
                       WHEN SD.sdemcu = '    DIFARARC' THEN
                        'MG'
                       ELSE
                        CASE
                          WHEN SD.sdemcu = '    DIFARRIO' THEN
                           'RJ'
                          ELSE
                           CASE
                             WHEN SD.sdemcu = '    DIFARCAT' THEN
                              'GO'
                             ELSE
                              CASE
                                WHEN SD.sdemcu = '    DIFARBRA' THEN
                                 'DF'
                                ELSE
                                 CASE
                                   WHEN SD.sdemcu = '   DIFARCAMB' THEN
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
  from (select db_edild_nomearq,
               db_edip_pedmerc  as ped_mercanet,
               db_pedi_produto  as codigo_produto
          from mercanet_prd.db_edi_lote_distr@dc09,
               mercanet_prd.db_edi_pedido@dc09,
               mercanet_prd.db_pedido_prod@dc09
         where db_edild_data >
               to_date('23/04/2015 00:00:00', 'dd/mm/yyyy hh24:mi:ss')
           and db_edild_distr not in (529,530)
           and db_edild_seq = db_edip_lote
           and db_edip_pedmerc = db_pedi_pedido) ARQ
  left join mercanet_prd.db_edi_pedido@dc09 EDIP
    on ARQ.ped_mercanet = EDIP.db_edip_pedmerc
  left join (select *
               from mercanet_prd.db_edi_pedprod@dc09,
                    mercanet_prd.db_produto_embal@dc09
              where db_edii_produto = db_prdemb_codbarra) EDII
    on TRIM(ARQ.codigo_produto) = EDII.db_prdemb_produto
   and EDIP.db_edip_nro = EDII.db_edii_nro
   and EDIP.db_edip_comprador = EDII.db_edii_comprador
   and EDIP.db_edip_pedmerc = EDII.db_edii_pedmerc
  left join mercanet_prd.db_pedido_distr@dc09 PEDT
    on PEDT.db_pedt_pedido = EDIP.db_edip_pedmerc
  left join mercanet_prd.db_pedido_distr_it@dc09 PDIT
    on PDIT.db_pdit_pedido = PEDT.db_pedt_pedido
   and PDIT.db_pdit_produto = EDII.db_prdemb_produto
   and PDIT.db_pdit_pedido = EDII.db_edii_pedmerc
   and PDIT.db_pdit_pedido = ARQ.ped_mercanet
  left join mercanet_prd.db_pedido@dc09 PED
    on PED.db_ped_nro = PEDT.db_pedt_pedido
  left join mercanet_prd.db_pedido_prod@dc09 PEDI
    on PEDI.db_pedi_pedido = PDIT.db_pdit_pedido
   and PEDI.db_pedi_produto = PDIT.db_pdit_produto
  left join proddta.f5547011 SA
    on TO_CHAR(PED.db_ped_nro) = TRIM(SA.savr01)
  left join proddta.f5547012 SB
    on SB.sbukid = SA.saukid
   and trim(SB.sblitm) = to_char(PEDI.db_pedi_produto)
  left join proddta.f4211 SD
    on SD.sddoco = SA.sadoco
   and SD.sdlitm = SB.sblitm
  left join proddta.f7611b FD
    on SD.sddoco = FD.fddoco
   and SD.sdlnid = FD.fdlnid
  left join proddta.f555511 ED
    on FD.fdbnnf = ED.edbnnf
   and FD.fdbser = ED.edbser
   and FD.fdn001 = ED.edn001
   and FD.fdlnid = ED.edlnid
 where EDIP.db_edip_pedmerc = 83744568
   and PEDI.db_pedi_situacao <> 9 
 order by EDIP.db_edip_pedmerc ,PEDI.db_pedi_produto
