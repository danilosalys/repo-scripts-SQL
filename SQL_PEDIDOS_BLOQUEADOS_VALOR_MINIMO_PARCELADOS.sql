--RELATORIO JOYCE
SELECT *
  FROM (SELECT EDI_PED.DB_EDIP_DT_EMISSAO DATA_EMISSAO_PEDIDO,
               EDI_PED.DB_EDIP_VAN AS CODIGO_VAN,
               VAN.EM01_EAN AS DESCRICAO_VAN,
               PED.DB_PED_CLIENTE AS CODIGO_CLIENTE,
               EDI_PED.DB_EDIP_COMPRADOR AS CNPJ_CLIENTE,
               REP.REP_CODIGO AS CODIGO_REPRESENTANTE,
               REP.REP_DESCRI AS NOME_REPRESENTANTE,
               REP.GEA_CODIGO AS CODIGO_GERENTE_AREA,
               REP.GEA_DESCRI AS NOME_GERENTE_AREA,
               REP.GER_CODIGO AS CODIGO_GERENTE_REGIONAL,
               REP.GER_DESCRI AS NOME_GERENTE_REGIONAL,
               EDI_PED.DB_EDIP_PEDMERC AS PEDIDO_MERCANET,
               CAB_PED_JDE.SHDOCO AS PEDIDO_JDE,
               PED.DB_PED_COND_PGTO AS COND_PGTO_MERCANET,
               COND_PGTO.DB_TBPGTO_DESCR AS DESCRICAO_COND_PGTO,
               COND_PGTO.DB_TBPGTO_NPARC AS NUMERO_PARCELAS,
               COND_PGTO.DB_TBPGTO_NPARC * 100 AS VALOR_MINIMO_PEDIDO,
               (SELECT SUM((SDUPRC / 10000) * SDUORG)
                  FROM (SELECT *
                          FROM PRODDTA.F4211@DC01
                        UNION ALL
                        SELECT * FROM PRODDTA.F42119@DC01) DET_PED_JDE
                 WHERE DET_PED_JDE.SDDOCO = CAB_PED_JDE.SHDOCO) AS VALOR_TOTAL_BRUTO_PEDIDO
          FROM MERCANET_PRD.DB_PEDIDO PED,
               PRODDTA.F42019@DC01 CAB_PED_JDE,
               MERCANET_PRD.DB_EDI_PEDIDO EDI_PED,
               MERCANET_PRD.MEM01 VAN,
               MERCANET_PRD.DB_TB_CPGTO COND_PGTO,
               (SELECT *
                  FROM (SELECT NULL AS EMP_IDENTI,
                               C1.ABAN8 AS CLI_CODIGO,
                               R.ABAN8 AS REP_CODIGO,
                               TRIM(R.ABALPH) AS REP_DESCRI,
                               TRIM(R.ABALKY) AS REP_NRPALM,
                               'MED' AS REP_TIPREP,
                               GV.ABAN8 AS GEA_CODIGO,
                               TRIM(GV.ABALPH) AS GEA_DESCRI,
                               GR.ABAN8 AS GER_CODIGO,
                               TRIM(GR.ABALPH) AS GER_DESCRI
                          FROM PRODDTA.F0101@DC01 C1,
                               PRODDTA.F0101@DC01 R,
                               PRODDTA.F0101@DC01 GV,
                               PRODDTA.F0101@DC01 GR,
                               PRODDTA.F0101@DC01 GN,
                               PRODDTA.F0101@DC01 DC
                         WHERE C1.ABSIC = 'DIF'
                           AND C1.ABAC07 = R.ABAC07(+)
                           AND R.ABAT1(+) = 'R'
                           AND R.ABALPH(+) NOT LIKE '%REGIAO%'
                           AND C1.ABAC07 <> 'AA'
                           AND GV.ABAT1 = 'GV'
                           AND C1.ABAC01 = GV.ABAC01
                           AND GR.ABAT1 = 'GR'
                           AND GV.ABAC06 = GR.ABAC06
                           AND GN.ABAT1 = 'GN'
                           AND GR.ABAC18 = GN.ABAC18
                           AND DC.ABAT1 = 'DC'
                           AND GN.ABAC19 = DC.ABAC19
                        UNION
                        SELECT NULL AS EMP_IDENTI,
                               C1.ABAN8 AS CLI_CODIGO,
                               R.ABAN8 AS REP_CODIGO,
                               TRIM(R.ABALPH) AS REP_DESCRI,
                               TRIM(R.ABALKY) AS REP_NRPALM,
                               'HPC' AS REP_TIPREP,
                               GV.ABAN8 AS GEA_CODIGO,
                               TRIM(GV.ABALPH) AS GEA_DESCRI,
                               GR.ABAN8 AS GER_CODIGO,
                               TRIM(GR.ABALPH) AS GER_DESCRI
                          FROM PRODDTA.F0101@DC01 C1,
                               PRODDTA.F0101@DC01 R,
                               PRODDTA.F0101@DC01 GV,
                               PRODDTA.F0101@DC01 GR,
                               PRODDTA.F0101@DC01 GN,
                               PRODDTA.F0101@DC01 DC
                         WHERE C1.ABSIC = 'DIF'
                           AND C1.ABAC27 = R.ABAC07
                           AND R.ABAT1 = 'R'
                           AND R.ABALPH NOT LIKE '%REGIAO%'
                           AND C1.ABAC27 <> 'AA'
                           AND GV.ABAT1 = 'GV'
                           AND R.ABAC01 = GV.ABAC01
                           AND GR.ABAT1 = 'GR'
                           AND GV.ABAC06 = GR.ABAC06
                           AND GN.ABAT1 = 'GN'
                           AND GR.ABAC18 = GN.ABAC18
                           AND DC.ABAT1 = 'DC'
                           AND GN.ABAC19 = DC.ABAC19)) REP
         WHERE DECODE(PED.DB_PED_NRO_ORIG,
                      'CANCEL',
                      '0',
                      PED.DB_PED_NRO_ORIG) = TO_CHAR(CAB_PED_JDE.SHDOCO)
           AND TO_CHAR(PED.DB_PED_NRO) = TRIM(CAB_PED_JDE.SHOORN)
           AND PED.DB_PED_CLIENTE = CAB_PED_JDE.SHAN8
           AND PED.DB_PED_NRO = EDI_PED.DB_EDIP_PEDMERC
           AND EDI_PED.DB_EDIP_VAN = VAN.EM01_CODIGO
           AND PED.DB_PED_COND_PGTO = COND_PGTO.DB_TBPGTO_COD
           AND PED.DB_PED_COND_PGTO > 800
           AND EDI_PED.DB_EDIP_DT_EMISSAO >= '01/09/2017'
           AND PED.DB_PED_SITUACAO = 9
           AND CAB_PED_JDE.SHHOLD = 'MN'
           AND REP.CLI_CODIGO = DB_PED_CLIENTE)
 WHERE VALOR_TOTAL_BRUTO_PEDIDO < VALOR_MINIMO_PEDIDO
UNION ALL
SELECT *
  FROM (SELECT EDI_PED.DB_EDIP_DT_EMISSAO DATA_EMISSAO_PEDIDO,
               EDI_PED.DB_EDIP_VAN AS CODIGO_VAN,
               VAN.EM01_EAN AS DESCRICAO_VAN,
               PED.DB_PED_CLIENTE AS CODIGO_CLIENTE,
               EDI_PED.DB_EDIP_COMPRADOR AS CNPJ_CLIENTE,
               REP.REP_CODIGO AS CODIGO_REPRESENTANTE,
               REP.REP_DESCRI AS NOME_REPRESENTANTE,
               REP.GEA_CODIGO AS CODIGO_GERENTE_AREA,
               REP.GEA_DESCRI AS NOME_GERENTE_AREA,
               REP.GER_CODIGO AS CODIGO_GERENTE_REGIONAL,
               REP.GER_DESCRI AS NOME_GERENTE_REGIONAL,
               EDI_PED.DB_EDIP_PEDMERC AS PEDIDO_MERCANET,
               CAB_PED_JDE.SHDOCO AS PEDIDO_JDE,
               PED.DB_PED_COND_PGTO AS COND_PGTO_MERCANET,
               COND_PGTO.DB_TBPGTO_DESCR AS DESCRICAO_COND_PGTO,
               COND_PGTO.DB_TBPGTO_NPARC AS NUMERO_PARCELAS,
               COND_PGTO.DB_TBPGTO_NPARC * 100 AS VALOR_MINIMO_PEDIDO,
               (SELECT SUM((SDUPRC / 10000) * SDUORG)
                  FROM (SELECT *
                          FROM PRODDTA.F4211@DC01
                        UNION ALL
                        SELECT * FROM PRODDTA.F42119@DC01) DET_PED_JDE
                 WHERE DET_PED_JDE.SDDOCO = CAB_PED_JDE.SHDOCO) AS VALOR_TOTAL_BRUTO_PEDIDO
          FROM MERCANET_PRD.DB_PEDIDO PED,
               PRODDTA.F4201@DC01 CAB_PED_JDE,
               MERCANET_PRD.DB_EDI_PEDIDO EDI_PED,
               MERCANET_PRD.MEM01 VAN,
               MERCANET_PRD.DB_TB_CPGTO COND_PGTO,
               (SELECT *
                  FROM (SELECT NULL AS EMP_IDENTI,
                               C1.ABAN8 AS CLI_CODIGO,
                               R.ABAN8 AS REP_CODIGO,
                               TRIM(R.ABALPH) AS REP_DESCRI,
                               TRIM(R.ABALKY) AS REP_NRPALM,
                               'MED' AS REP_TIPREP,
                               GV.ABAN8 AS GEA_CODIGO,
                               TRIM(GV.ABALPH) AS GEA_DESCRI,
                               GR.ABAN8 AS GER_CODIGO,
                               TRIM(GR.ABALPH) AS GER_DESCRI
                          FROM PRODDTA.F0101@DC01 C1,
                               PRODDTA.F0101@DC01 R,
                               PRODDTA.F0101@DC01 GV,
                               PRODDTA.F0101@DC01 GR,
                               PRODDTA.F0101@DC01 GN,
                               PRODDTA.F0101@DC01 DC
                         WHERE C1.ABSIC = 'DIF'
                           AND C1.ABAC07 = R.ABAC07(+)
                           AND R.ABAT1(+) = 'R'
                           AND R.ABALPH(+) NOT LIKE '%REGIAO%'
                           AND C1.ABAC07 <> 'AA'
                           AND GV.ABAT1 = 'GV'
                           AND C1.ABAC01 = GV.ABAC01
                           AND GR.ABAT1 = 'GR'
                           AND GV.ABAC06 = GR.ABAC06
                           AND GN.ABAT1 = 'GN'
                           AND GR.ABAC18 = GN.ABAC18
                           AND DC.ABAT1 = 'DC'
                           AND GN.ABAC19 = DC.ABAC19
                        UNION
                        SELECT NULL AS EMP_IDENTI,
                               C1.ABAN8 AS CLI_CODIGO,
                               R.ABAN8 AS REP_CODIGO,
                               TRIM(R.ABALPH) AS REP_DESCRI,
                               TRIM(R.ABALKY) AS REP_NRPALM,
                               'HPC' AS REP_TIPREP,
                               GV.ABAN8 AS GEA_CODIGO,
                               TRIM(GV.ABALPH) AS GEA_DESCRI,
                               GR.ABAN8 AS GER_CODIGO,
                               TRIM(GR.ABALPH) AS GER_DESCRI
                          FROM PRODDTA.F0101@DC01 C1,
                               PRODDTA.F0101@DC01 R,
                               PRODDTA.F0101@DC01 GV,
                               PRODDTA.F0101@DC01 GR,
                               PRODDTA.F0101@DC01 GN,
                               PRODDTA.F0101@DC01 DC
                         WHERE C1.ABSIC = 'DIF'
                           AND C1.ABAC27 = R.ABAC07
                           AND R.ABAT1 = 'R'
                           AND R.ABALPH NOT LIKE '%REGIAO%'
                           AND C1.ABAC27 <> 'AA'
                           AND GV.ABAT1 = 'GV'
                           AND R.ABAC01 = GV.ABAC01
                           AND GR.ABAT1 = 'GR'
                           AND GV.ABAC06 = GR.ABAC06
                           AND GN.ABAT1 = 'GN'
                           AND GR.ABAC18 = GN.ABAC18
                           AND DC.ABAT1 = 'DC'
                           AND GN.ABAC19 = DC.ABAC19)) REP
         WHERE DECODE(PED.DB_PED_NRO_ORIG,
                      'CANCEL',
                      '0',
                      PED.DB_PED_NRO_ORIG) = TO_CHAR(CAB_PED_JDE.SHDOCO)
           AND TO_CHAR(PED.DB_PED_NRO) = TRIM(CAB_PED_JDE.SHOORN)
           AND PED.DB_PED_CLIENTE = CAB_PED_JDE.SHAN8
           AND PED.DB_PED_NRO = EDI_PED.DB_EDIP_PEDMERC
           AND EDI_PED.DB_EDIP_VAN = VAN.EM01_CODIGO
           AND PED.DB_PED_COND_PGTO = COND_PGTO.DB_TBPGTO_COD
           AND PED.DB_PED_COND_PGTO > 800
           AND EDI_PED.DB_EDIP_DT_EMISSAO >= '01/09/2017'
           AND PED.DB_PED_SITUACAO = 9
           AND CAB_PED_JDE.SHHOLD = 'MN'
           AND REP.CLI_CODIGO = DB_PED_CLIENTE)
 WHERE VALOR_TOTAL_BRUTO_PEDIDO < VALOR_MINIMO_PEDIDO
