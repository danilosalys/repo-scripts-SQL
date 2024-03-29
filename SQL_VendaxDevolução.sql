--PRIMEIRA PARTE:  RODAR PARA OBTER OS PEDIDOS DE DEVOLU�AO

SELECT DISTINCT PDVEN_D.SDDOCO AS PEDIDO_DROGACENTER,
                SAAA25 AS PED_EFETIVACAO,
                TO_DATE(NFVEN_D.FDISSU + 1900000, 'YYYYDDD') AS DATA_EMISSAO_NF,
                NFVEN_H.FHBNNF AS NOTA_VENDA,
                NFVEN_H.FHBSER AS SERIE,
                NFVEN_H.FHBVTN AS VALOR_TOTAL_NOTA_VENDA,
                PDVEN_D.SDEUSE AS COD_ORIGEM_PED,
                NFDEV_D.FDDOCO AS PEDIDO_DEVOLUCAO,
                TO_DATE(NFDEV_H.FHADDJ + 1900000, 'YYYYDDD') AS DATA_ENTRADA_DEVOLUCAO,
                TO_DATE(NFDEV_D.FDISSU + 1900000, 'YYYYDDD') AS DATA_EMISSAO_NOTA_DEVOLUCAO,
                NFDEV_H.FHBNNF AS NOTA_DEVOLUCAO,
                NFDEV_H.FHBSER AS SERIE,
                NFDEV_H.FHN001 AS SEQUENCIA,
                NFDEV_H.FHDCT AS TIPO_NOTA_DEVOLUCAO,
                NFDEV_H.FHBVTN AS VALOR_TOTAL_NOTA_DEVOLUCAO
  FROM PRODDTA.F7601B   NFVEN_H,
       PRODDTA.F7611B   NFVEN_D,
       PRODDTA.F42119   PDVEN_D,
       PRODDTA.F42119   PDDEV_D,
       PRODDTA.F42199   VINC,
       PRODDTA.F7601B   NFDEV_H,
       PRODDTA.F7611B   NFDEV_D,
       PRODDTA.F5547011
 WHERE
-- NFVEN_H (F7601B) X NFVEN_D (F7611B)
 NFVEN_H.FHBNNF = NFVEN_D.FDBNNF
 AND NFVEN_H.FHBSER = NFVEN_D.FDBSER
 AND NFVEN_H.FHN001 = NFVEN_D.FDN001
 AND NFVEN_H.FHDCT = NFVEN_D.FDDCT
-- NFDEV_H (F7601B) X NFDEV_D (F7611B)
 AND NFDEV_H.FHBNNF = NFDEV_D.FDBNNF
 AND NFDEV_H.FHBSER = NFDEV_D.FDBSER
 AND NFDEV_H.FHN001 = NFDEV_D.FDN001
 AND NFDEV_H.FHDCT = NFDEV_D.FDDCT
-- NFVEN_D (F7611B) X PDVEN_D (F42119)
 AND NFVEN_D.FDKCOO = PDVEN_D.SDKCOO
 AND NFVEN_D.FDDOCO = PDVEN_D.SDDOCO
 AND NFVEN_D.FDPDCT = PDVEN_D.SDDCTO
 AND NFVEN_D.FDLNID = PDVEN_D.SDLNID
 AND NFVEN_D.FDLITM = PDVEN_D.SDLITM
-- PDVEN_D (F42119) X PDDEV_D (F42119)
 AND PDVEN_D.SDDOC = PDDEV_D.SDODOC
 AND TRIM(PDVEN_D.SDDCT) = TRIM(PDDEV_D.SDODCT)
 AND TRIM(PDVEN_D.SDITM) = PDDEV_D.SDITM
 AND PDDEV_D.SDLTTR NOT BETWEEN '980' AND '989'
-- VINC (F42199) X PDDEV_D (F42119)
 AND VINC.SLKCOO = PDDEV_D.SDOKCO
 AND VINC.SLDOCO = NVL(TRIM(PDDEV_D.SDOORN), 0)
 AND VINC.SLDCTO = PDDEV_D.SDOCTO
 AND VINC.SLLNID = PDDEV_D.SDOGNO
-- VINC (F42199) X NFVEN_D (F7611B)
 AND VINC.SLRKCO = NFVEN_D.FDKCOO
 AND NVL(TRIM(VINC.SLRORN), 0) = NFVEN_D.FDDOCO
 AND VINC.SLRCTO = NFVEN_D.FDPDCT
 AND VINC.SLRLLN = NFVEN_D.FDLNID
 AND VINC.SLITM = NFVEN_D.FDITM
-- NFDEV_D (F7611B) X PDDEV_D (F42119)
 AND NFDEV_D.FDKCOO = PDDEV_D.SDKCOO
 AND NFDEV_D.FDDOCO = PDDEV_D.SDDOCO
 AND NFDEV_D.FDPDCT = PDDEV_D.SDDCTO
 AND NFDEV_D.FDLNID = PDDEV_D.SDLNID
 AND NFDEV_D.FDLITM = PDDEV_D.SDLITM
--
 AND NFDEV_H.FHADDJ BETWEEN 115182 AND 115212
 AND PDVEN_D.SDEUSE = 'PTC'
 AND PDVEN_D.SDDOCO = SADOCO
 AND PDVEN_D.SDTRDJ > 115181
 AND PDVEN_D.SDUPMJ > 115180
 AND TRIM(SAVR01) IN
 (SELECT TO_CHAR(DB_EDIP_PEDMERC)
    FROM MERCANET_PRD.DB_EDI_PEDIDO@DC09
   WHERE DB_EDIP_NRO IN
         (SELECT PEDCOT FROM DSALES.CONCILIACAO_COTEFACIL_JULHO@DC09));


-----
--SEGUNDA PARTE: RODAR PARA OBTER OS VALORES DAS TRIBUTA��ES DOS PEDIDOS DE DEVOLU��O, PASSANDO O PEDIDO DE DEVOLU��O NA SELE��O DE DADOS


SELECT PDVEN_D.SDDOCO AS PEDIDO_DROGACENTER,
       SAAA25 AS PED_EFETIVACAO,
       TO_DATE(NFVEN_D.FDISSU + 1900000, 'YYYYDDD') AS DATA_EMISSAO_NF,
       NFVEN_H.FHBNNF AS NOTA_VENDA,
       NFVEN_H.FHBSER AS SERIE,
       NFVEN_H.FHBVTN/100 AS VALOR_TOTAL_NOTA_VENDA,
       PDVEN_D.SDEUSE AS COD_ORIGEM_PED,
       NFDEV_D.FDDOCO AS PEDIDO_DEVOLUCAO,
       TO_DATE(NFDEV_H.FHADDJ + 1900000, 'YYYYDDD') AS DATA_ENTRADA_DEVOLUCAO,
       TO_DATE(NFDEV_D.FDISSU + 1900000, 'YYYYDDD') AS DATA_EMISSAO_NOTA_DEVOLUCAO,
       NFDEV_H.FHBNNF AS NOTA_DEVOLUCAO,
       NFDEV_H.FHBSER AS SERIE,
       NFDEV_H.FHN001 AS SEQUENCIA,
       NFDEV_H.FHDCT AS TIPO_NOTA_DEVOLUCAO,
       NFDEV_H.FHBVTN /100 AS VALOR_TOTAL_NOTA_DEVOLUCAO,
       SUM(ROUND(((CASE
                   WHEN NFVEN_D.FDBVIS = 0 THEN
                    (SELECT EDM010 / 100
                       FROM PRODDTA.F555511
                      WHERE NFVEN_D.FDBNNF = EDBNNF
                        AND NFVEN_D.FDBSER = EDBSER
                        AND NFVEN_D.FDN001 = EDN001
                        AND NFVEN_D.FDLNID = EDLNID)
                   ELSE
                    NFVEN_D.FDBVIS
                 END / NFVEN_D.FDUORG) * NFDEV_D.FDUORG),
                 2)) as VALOR_TOTAL_ST_DEVOLUCAO
  FROM PRODDTA.F7601B   NFVEN_H,
       PRODDTA.F7611B   NFVEN_D,
       PRODDTA.F42119   PDVEN_D,
       PRODDTA.F42119   PDDEV_D,
       PRODDTA.F42199   VINC,
       PRODDTA.F7601B   NFDEV_H,
       PRODDTA.F7611B   NFDEV_D,
       PRODDTA.F5547011
 WHERE
-- NFVEN_H (F7601B) X NFVEN_D (F7611B)
 NFVEN_H.FHBNNF = NFVEN_D.FDBNNF
 AND NFVEN_H.FHBSER = NFVEN_D.FDBSER
 AND NFVEN_H.FHN001 = NFVEN_D.FDN001
 AND NFVEN_H.FHDCT = NFVEN_D.FDDCT
-- NFDEV_H (F7601B) X NFDEV_D (F7611B)
 AND NFDEV_H.FHBNNF = NFDEV_D.FDBNNF
 AND NFDEV_H.FHBSER = NFDEV_D.FDBSER
 AND NFDEV_H.FHN001 = NFDEV_D.FDN001
 AND NFDEV_H.FHDCT = NFDEV_D.FDDCT
-- NFVEN_D (F7611B) X PDVEN_D (F42119)
 AND NFVEN_D.FDKCOO = PDVEN_D.SDKCOO
 AND NFVEN_D.FDDOCO = PDVEN_D.SDDOCO
 AND NFVEN_D.FDPDCT = PDVEN_D.SDDCTO
 AND NFVEN_D.FDLNID = PDVEN_D.SDLNID
 AND NFVEN_D.FDLITM = PDVEN_D.SDLITM
-- PDVEN_D (F42119) X PDDEV_D (F42119)
 AND PDVEN_D.SDDOC = PDDEV_D.SDODOC
 AND TRIM(PDVEN_D.SDDCT) = TRIM(PDDEV_D.SDODCT)
 AND TRIM(PDVEN_D.SDITM) = PDDEV_D.SDITM
 AND PDDEV_D.SDLTTR NOT BETWEEN '980' AND '989'
-- VINC (F42199) X PDDEV_D (F42119)
 AND VINC.SLKCOO = PDDEV_D.SDOKCO
 AND VINC.SLDOCO = NVL(TRIM(PDDEV_D.SDOORN), 0)
 AND VINC.SLDCTO = PDDEV_D.SDOCTO
 AND VINC.SLLNID = PDDEV_D.SDOGNO
-- VINC (F42199) X NFVEN_D (F7611B)
 AND VINC.SLRKCO = NFVEN_D.FDKCOO
 AND NVL(TRIM(VINC.SLRORN), 0) = NFVEN_D.FDDOCO
 AND VINC.SLRCTO = NFVEN_D.FDPDCT
 AND VINC.SLRLLN = NFVEN_D.FDLNID
 AND VINC.SLITM = NFVEN_D.FDITM
-- NFDEV_D (F7611B) X PDDEV_D (F42119)
 AND NFDEV_D.FDKCOO = PDDEV_D.SDKCOO
 AND NFDEV_D.FDDOCO = PDDEV_D.SDDOCO
 AND NFDEV_D.FDPDCT = PDDEV_D.SDDCTO
 AND NFDEV_D.FDLNID = PDDEV_D.SDLNID
 AND NFDEV_D.FDLITM = PDDEV_D.SDLITM
--
 AND NFDEV_H.FHADDJ BETWEEN 115182 AND 115212
 AND PDVEN_D.SDEUSE = 'PTC'
 AND PDVEN_D.SDDOCO = SADOCO
 AND NFDEV_D.FDDOCO IN (343536,341983,341984,341973,341950,341985,24631602,24632230,24653766,24653892,342136,342137,344455,342048,24653776,
                 342045,342128,342608,342138,342133,342135,342046,342399,24729356,343648,342398,342567,24729360,342572,342961,342902,
                 342903,342400,342574,24729368,24729374,342904,24750268,24749285,24750279,343437,24822638,343788,344150,343820,344035,
                 24863816,24863441,343944,24771217,24822175,343841,24863837,24863851,24863828,344071,343978,24863451,24863860,342966,
                 24606017,24729973,341777,343413,342490,343404,343365,24653429,24752180,24653406,342501,342829,342527,24633861,
                 342899,342850,343223,343518,24729137,24788568,342430,342551,343691,344045,342927,343494,342849,343509,342830,342546,
                 343364,343097,24806271,24822031,343662,24749345,342948,343923,343640,24824615,343361,343523,343362,343583,343917,
                 24806641,343370,343555,343748,343956,24824628,344115,343646,24863110,344175,343901,24862818,24863341,344180,344244)
GROUP BY PDVEN_D.SDDOCO ,SAAA25, NFVEN_D.FDISSU,NFVEN_H.FHBNNF,NFVEN_H.FHBSER,NFVEN_H.FHBVTN,
         PDVEN_D.SDEUSE ,NFDEV_D.FDDOCO,NFDEV_H.FHADDJ,NFDEV_D.FDISSU,NFDEV_H.FHBNNF,NFDEV_H.FHBSER,
         NFDEV_H.FHN001, NFDEV_H.FHDCT,NFDEV_H.FHBVTN
ORDER BY SAAA25, NFDEV_H.FHBNNF
