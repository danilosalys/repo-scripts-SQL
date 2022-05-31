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
               EDI_PED.DB_EDIP_NRO AS PEDIDO_VAN, 
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
                 WHERE DET_PED_JDE.SDDOCO = CAB_PED_JDE.SHDOCO) AS VALOR_TOTAL_BRUTO_PEDIDO,
                  'BLOQUEADO NO JDE' AS SISTEMA_BLOQUEIO
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
           AND EDI_PED.DB_EDIP_DT_EMISSAO >= '01/01/2018'
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
               EDI_PED.DB_EDIP_NRO AS PEDIDO_VAN,
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
                 WHERE DET_PED_JDE.SDDOCO = CAB_PED_JDE.SHDOCO) AS VALOR_TOTAL_BRUTO_PEDIDO,
                  'BLOQUEADO NO JDE' AS SISTEMA_BLOQUEIO
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
           AND EDI_PED.DB_EDIP_DT_EMISSAO >= '01/01/2018'
           AND PED.DB_PED_SITUACAO = 9
           AND CAB_PED_JDE.SHHOLD = 'MN'
           AND REP.CLI_CODIGO = DB_PED_CLIENTE)
 WHERE VALOR_TOTAL_BRUTO_PEDIDO < VALOR_MINIMO_PEDIDO
UNION ALL 
SELECT *
  FROM (SELECT EDI_PED.DB_EDIP_DT_EMISSAO DATA_EMISSAO_PEDIDO,
               EDI_PED.DB_EDIP_VAN AS CODIGO_VAN,
               VAN.EM01_EAN AS DESCRICAO_VAN,
               (SELECT DB_CLI_CODIGO 
                  FROM MERCANET_PRD.DB_CLIENTE
                 WHERE DB_EDIP_COMPRADOR = DB_CLI_CGCMF AND ROWNUM = 1) AS CODIGO_CLIENTE,
               EDI_PED.DB_EDIP_COMPRADOR AS CNPJ_CLIENTE,
               REP.REP_CODIGO AS CODIGO_REPRESENTANTE,
               REP.REP_DESCRI AS NOME_REPRESENTANTE,
               REP.GEA_CODIGO AS CODIGO_GERENTE_AREA,
               REP.GEA_DESCRI AS NOME_GERENTE_AREA,
               REP.GER_CODIGO AS CODIGO_GERENTE_REGIONAL,
               REP.GER_DESCRI AS NOME_GERENTE_REGIONAL,
               EDI_PED.DB_EDIP_NRO AS PEDIDO_VAN, 
               EDI_PED.DB_EDIP_PEDMERC AS PEDIDO_MERCANET,
               0 AS PEDIDO_JDE,
               EDI_PED.DB_EDIP_CONDPGTO AS COND_PGTO_MERCANET,
               COND_PGTO.DB_TBPGTO_DESCR AS DESCRICAO_COND_PGTO,
               COND_PGTO.DB_TBPGTO_NPARC AS NUMERO_PARCELAS,
               COND_PGTO.DB_TBPGTO_NPARC * 100 AS VALOR_MINIMO_PEDIDO,
               
               NVL((select ROUND((SUM((db_precop_valor*db_edii_qtde_vda)*(1-(NVL(db_edii_perc_dcto,0)/100)))),2)
                  from mercanet_prd.db_edi_pedprod, 
                       mercanet_prd.db_cliente, 
                       mercanet_prd.db_cliente_atrib,
                       mercanet_prd.db_produto_embal,
                       mercanet_prd.db_preco_prod
                 where db_edii_nro = EDI_PED.DB_EDIP_NRO
                   and db_edii_comprador = EDI_PED.DB_EDIP_COMPRADOR
                   AND db_cli_cgcmf  = EDI_PED.DB_EDIP_COMPRADOR
                   and db_edii_produto = db_prdemb_codbarra 
                   and db_cli_codigo = db_clia_codigo
                   and db_clia_atrib = 1023 
                   and db_clia_valor = db_precop_codigo
                   and db_precop_produto = db_prdemb_produto
                 GROUP BY DB_EDII_NRO),0) AS VALOR_TOTAL_BRUTO_PEDIDO, 
                 'BLOQUEADO NO MERCANET' AS SISTEMA_BLOQUEIO
          FROM MERCANET_PRD.DB_EDI_PEDIDO EDI_PED,
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
                               TRIM(GR.ABALPH) AS GER_DESCRI,
                               C1.ABTAX AS CNPJ
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
                               TRIM(GR.ABALPH) AS GER_DESCRI,
                               C1.ABTAX AS CNPJ 
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
         WHERE EDI_PED.DB_EDIP_VAN = VAN.EM01_CODIGO
           AND EDI_PED.DB_EDIP_CONDPGTO = COND_PGTO.DB_TBPGTO_COD
           AND EDI_PED.DB_EDIP_CONDPGTO > 800
           AND EDI_PED.DB_EDIP_PEDMERC IS NULL 
           AND EDI_PED.DB_EDIP_DT_EMISSAO >= '01/01/2018'
           AND EXISTS (SELECT * 
                         FROM MERCANET_PRD.DB_EDI_PEDPROD T1,MERCANET_PRD.MEM07 T2
                        WHERE EDI_PED.DB_EDIP_COMPRADOR = T1.DB_EDII_COMPRADOR 
                          AND EDI_PED.DB_EDIP_NRO = T1.DB_EDII_NRO
                          AND EDI_PED.DB_EDIP_VAN = T2.EM07_DISTR
                          AND T2.EM07_CODRESTRICAO = 983
                          AND T1.DB_EDII_MOTIVORET = T2.EM07_CODMOTIVO)
           AND TRIM(REP.CNPJ) = EDI_PED.DB_EDIP_COMPRADOR)
