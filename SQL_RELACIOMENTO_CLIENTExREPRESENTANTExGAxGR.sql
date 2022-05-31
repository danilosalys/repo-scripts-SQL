--RELACIONAMENTO MERCANET
SELECT T1.DB_CLI_CODIGO    CODIGO_CLIENTE_MERC,
       T1.DB_CLI_NOME      NOME_CLIENTE_MERC,
       T2.DB_TBREP_CODIGO  AS REP_MERC,
       T2.DB_TBREP_CODORIG AS CODJDE_REP_MERC,
       T2.DB_TBREP_NOME    AS NOME_REP_MERC,
       T3.DB_TBREP_CODIGO  AS GA_MERC,
       T3.DB_TBREP_CODORIG AS CODJDE_GA_MERC,
       T3.DB_TBREP_NOME    AS NOME_GA_MERC,
       T4.DB_TBREP_CODIGO  AS GR_MERC,
       T4.DB_TBREP_CODORIG AS CODJDE_GR_MERC,
       T4.DB_TBREP_NOME AS NOME_GR_MERC
  FROM mercanet_prd.DB_CLIENTE   T1,
       mercanet_prd.DB_TB_REPRES T2,
       mercanet_prd.DB_TB_REPRES T3,
       mercanet_prd.DB_TB_REPRES T4
 WHERE DECODE(T1.DB_CLI_REPRES(+),
              3,
              NVL((SELECT MIN(DB_CLIR_REPRES)
                    FROM MERCANET_PRD.DB_CLIENTE_REPRES
                   WHERE DB_CLIR_CLIENTE = T1.DB_CLI_CODIGO
                     AND DB_CLIR_PADRAO = 1
                     AND DB_CLIR_REPRES <> 3
                     AND DB_CLIR_SITUACAO = 0),
                  3),
              T1.DB_CLI_REPRES(+)) = T2.DB_TBREP_CODIGO
   AND T2.DB_TBREP_SUPERIOR(+) = T3.DB_TBREP_CODIGO
   AND T3.DB_TBREP_SUPERIOR(+) = T4.DB_TBREP_CODIGO
   AND T1.DB_CLI_SITUACAO = 0
------------------------------------------------------------------------
---NOVO SQL - RELACIONAMENTO TABELAS JDE
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
                   AND GN.ABAC19 = DC.ABAC19))
