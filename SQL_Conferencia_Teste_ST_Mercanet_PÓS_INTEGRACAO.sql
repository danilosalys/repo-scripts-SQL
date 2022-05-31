select ARQ.id_arquivo AS ID_ARQ,
       NVL(EDIP.db_edip_pedmerc, 0) AS COD_PEDIDO_MERC,
       NVL(SD.sddoco, 0) AS COD_PEDIDO_JDE,
       ARQ.id_produto as ID_PRODUTO,
       ARQ.codigo_produto AS COD_PRODUTO,
       NVL(TO_CHAR(FD.fdbnnf || ' - ' || FD.fdbser), 0) AS NUMERO_NF,
       '' AS OBSERVACAO,
       '' AS STATUS,
       NVL((select sum(PEDD.db_pedd_desconto)
             from mercanet_qa.db_pedido_desconto@dc12.drogacenter.com.br PEDD
            where PEDD.db_pedd_tpdesc = 0
              and PEDD.db_pedd_nro = PEDI.db_pedi_pedido
              and PEDD.db_pedd_seqit = PEDI.db_pedi_sequencia),
           0) AS DESC_UNIT_MERC,
       NVL(ROUND(PEDI.db_pedi_float1/ PEDI.db_pedi_qtde_solic, 2), 0) AS FLOAT1_ST_ANTEC,
       NVL(ROUND(PEDI.db_pedi_vlr_subst / PEDI.db_pedi_qtde_solic, 2), 0) AS VALOR_ST_MERC,
       NVL(PEDI.db_pedi_preco_unit, 0) AS PRECO_BRUTO_MERC,
       NVL(PEDI.db_pedi_preco_liq, 0) AS PRECO_LIQ_MERC,
/*       NVL((SELECT SUM(AL.alfvtr)
             FROM QADTA.f4074 AL
            WHERE AL.aldoco = SD.sddoco
              AND AL.allnid = SD.sdlnid
              AND AL.albscd not in ('8', ' ')
              AND AL.alfvtr * (-1) > 0
              and AL.alast not in ('V0000339','V0000131','V0000133')),
           0) / 10000 * (-1) as DESC_UNIT_JDE,*/
       NVL((NVL((SELECT SUM(AL.alfvtr)
              FROM QADTA.f4074 AL
             WHERE AL.aldoco = SD.sddoco
               AND AL.allnid = SD.sdlnid
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
                    WHERE AL2.aldoco = SD.sddoco
                      AND AL2.allnid = SD.sdlnid
                      AND AL2.aloseq = NVL((SELECT MAX(AL3.aloseq)
                                             FROM QADTA.F4074 AL3
                                            WHERE AL3.almded = 'Y'
                                              AND AL3.aldoco = AL2.aldoco
                                              AND AL3.allnid = AL2.allnid),
                                           0)) /
                 (SELECT (AL4.aluprc)
                     FROM QADTA.f4074 AL4
                    WHERE AL4.aldoco = SD.sddoco
                      AND AL4.allnid = SD.sdlnid
                      AND AL4.aloseq = 0)) * 100 - 100) * (-1),
           0),0) as DESC_UNIT_JDE,
       CASE
         WHEN NVL((SELECT CASE
                           WHEN SUM(AL.aluprc) <= 0 THEN
                            0
                           ELSE
                            SUM(AL.aluprc) / 10000
                         END
                    FROM QADTA.F4074 AL
                   WHERE AL.aldoco = SD.sddoco
                     AND AL.allnid = SD.sdlnid
                     AND ((SD.SDEUSE NOT IN ('PRP', 'PBM', 'ZHR') AND
                         AL.ALAST IN ('V0000225',
                                        'V0000190',
                                        'V0000350',
                                        'V0000221',
                                        'V0000351')) OR
                         (SD.SDEUSE IN ('PRP', 'PBM', 'ZHR') AND
                         AL.ALAST IN ('V0000238',
                                        'V0000353',
                                        'V0000226',
                                        'V0000222',
                                        'V0000352',
                                        'V0000310',
                                        'V0000319',
                                        'V0000318')))
                  /*AND AL.alast in ('V0000190',
                  'V0000221',
                  'V0000222',
                  'V0000225',
                  'V0000226',
                  'V0000238',
                  'V0000350',
                  'V0000351',
                  'V0000352',
                  'V0000353')*/
                   GROUP BY allnid),
                  0) <> 0 THEN
          NVL((SELECT CASE
                       WHEN SUM(AL.aluprc) <= 0 THEN
                        0
                       ELSE
                        SUM(AL.aluprc) / 10000
                     END
                FROM QADTA.F4074 AL
               WHERE AL.aldoco = SD.sddoco
                 AND AL.allnid = SD.sdlnid
                 AND ((SD.SDEUSE NOT IN ('PRP', 'PBM', 'ZHR') AND
                     AL.ALAST IN ('V0000225',
                                    'V0000190',
                                    'V0000350',
                                    'V0000221',
                                    'V0000351')) OR
                     (SD.SDEUSE IN ('PRP', 'PBM', 'ZHR') AND
                     AL.ALAST IN ('V0000238',
                                    'V0000353',
                                    'V0000226',
                                    'V0000222',
                                    'V0000352',
                                    'V0000310',
                                    'V0000319',
                                    'V0000318')))
              /*AND AL.alast in ('V0000190',
              'V0000221',
              'V0000222',
              'V0000225',
              'V0000226',
              'V0000238',
              'V0000350',
              'V0000351',
              'V0000352',
              'V0000353')*/
               GROUP BY allnid),
              0)
         ELSE
          NVL(round(FDEF.fdbvis / FDEF.fduorg) / 100, 0)
       END AS VALOR_ST_JDE,
       NVL(SD.sdlprc / 10000, 0) AS PRECO_BRUTO_JDE,
       CASE
         WHEN NVL(SD.sdsoqs, 0) = 0 then
          0
         ELSE
          NVL((SD.sdaexp / SD.sdsoqs) / 100, 0)
       END AS PRECO_LIQ_JDE,
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
            WHERE A.tbitm = SD.sditm
              AND SD.sddoco = SD.sddoco
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
           'SEM ST') AS TIPO_ST,
       ' ',
       ' ',
       ' ',
       ' ',
       ' ',
       NVL(ED.edan04 / 100, 0) AS DESC_UNIT_DANFE,
       CASE
         WHEN NVL(round(FD.fdbvis / FD.fduorg) / 100, 0) <> 0 THEN
          NVL(round(FD.fdbvis / FD.fduorg) / 100, 0)
         ELSE
          NVL(ROUND(ED.edm010 / 100, 2) / FD.FDUORG, 0)
       END AS VALOR_ST_DANFE,
       NVL(ED.eduprc / 10000, 0) AS PRECO_LIQ_DANFE,
       NVL(SAEF.savr01, 0) AS COD_PED_EFET_MERC,
       NVL(SAEF.sadoco, 0) AS COD_PED_EFET_JDE,
       NVL(TO_CHAR(FDEF.fdbnnf || ' - ' || FDEF.fdbser), 0) AS NUMERO_NF_EFET,
       NVL(EDEF.edan04 / 100, 0) AS DESC_UNIT_DANFE_EFET,
       CASE
         WHEN NVL(round(FDEF.fdbvis / FDEF.fduorg) / 100, 0) <> 0 THEN
          NVL(round(FDEF.fdbvis / FDEF.fduorg) / 100, 0)
         ELSE
          NVL(ROUND(EDEF.edm010 / 100, 2) / FDEF.FDUORG, 0)
       END AS VALOR_ST_DANFE_EFET,
       NVL(EDEF.eduprc / 10000, 0) AS PRECO_LIQ_DANFE_EFET, 

       
  from dsales.monta_arquivo@DC12.DROGACENTER.COM.BR ARQ
  left join mercanet_qa.db_edi_pedido@dc12.drogacenter.com.br EDIP
    on ARQ.ped_mercanet = EDIP.db_edip_pedmerc
   and ARQ.cnpj_cliente = EDIP.db_edip_comprador
  left join (select *
               from mercanet_qa.db_edi_pedprod@dc12.drogacenter.com.br,
                    mercanet_qa.db_produto_embal@dc12.drogacenter.com.br
              where db_edii_produto = db_prdemb_codbarra) EDII
    on TRIM(ARQ.codigo_produto) = EDII.db_prdemb_produto
   and EDIP.db_edip_nro = EDII.db_edii_nro
   and EDIP.db_edip_comprador = EDII.db_edii_comprador
   and EDIP.db_edip_pedmerc = EDII.db_edii_pedmerc
  left join mercanet_qa.db_pedido_distr@dc12.drogacenter.com.br PEDT
    on PEDT.db_pedt_pedido = EDIP.db_edip_pedmerc
  left join mercanet_qa.db_pedido_distr_it@dc12.drogacenter.com.br PDIT
    on PDIT.db_pdit_pedido = PEDT.db_pedt_pedido
   and PDIT.db_pdit_produto = EDII.db_prdemb_produto
   and PDIT.db_pdit_pedido = EDII.db_edii_pedmerc
   and PDIT.db_pdit_pedido = ARQ.ped_mercanet
  left join mercanet_qa.db_pedido_prod@dc12.drogacenter.com.br PEDI
    on PEDI.db_pedi_pedido = PDIT.db_pdit_pedido
   and PEDI.db_pedi_produto = PDIT.db_pdit_produto
   and PEDI.db_pedi_pedido = ARQ.ped_mercanet
  left join qadta.f5547011 SA
    on TO_CHAR(PEDI.db_pedi_pedido) = TRIM(SA.savr01)
  left join qadta.f5547012 SB
    on SB.sbukid = SA.saukid
   and trim(SB.sblitm) = to_char(PEDI.db_pedi_produto)
  left join qadta.f4211 SD
    on SD.sddoco = SA.sadoco
   and SD.sdlitm = SB.sblitm
  left join qadta.f7611b FD
    on SD.sddoco = FD.fddoco
   and SD.sdlnid = FD.fdlnid
  left join qadta.f555511 ED
    on FD.fdbnnf = ED.edbnnf
   and FD.fdbser = ED.edbser
   and FD.fdn001 = ED.edn001
   and FD.fdlnid = ED.edlnid
  left join qadta.f5547011 SAEF
    on SA.sadocd = SAEF.sadocd
   and SAEF.saz55ori = 'PTC'
  left join qadta.f4211 SDEF
    on SAEF.sadoco = SDEF.sddoco
   and SD.sddoco = SDEF.sdoorn
   and SD.sddcto = SDEF.sdocto
   and SD.sdlnid = SDEF.sdogno
  left join qadta.f7611b FDEF
    on SDEF.sddoco = FDEF.fddoco
   and SDEF.sdlnid = FDEF.fdlnid
  left join qadta.f555511 EDEF
    on FDEF.fdbnnf = EDEF.edbnnf
   and FDEF.fdbser = EDEF.edbser
   and FDEF.fdn001 = EDEF.edn001
   and FDEF.fdlnid = EDEF.edlnid
 where TO_NUMBER(ARQ.id_arquivo) BETWEEN 1 and 1
   and ((mod(nvl(SD.sdlnid,0),1000) = 0 and mod(nvl(SDEF.sdlnid,0),1000) = 0))
 order by TO_NUMBER(id_arquivo), TO_NUMBER(id_produto);
 
