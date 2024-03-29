SELECT T4.IBLITM,
       T4.IBITM,
       T2.IMDSC1,
       (SUM(T4.LIPQOH - (T4.LIPCOM + T4.LIHCOM))) - MAX(T4.IBSAFE) AS ESTOQUE,
       T1.ABALPH,
       MAX(T3.IVCITM ) AS EAN, 
       T4.IBPRP5,
       T4.IBSRP8,
       T4.IBPRP1,
       T4.IBSRP3,
       T4.IBPRP2,
       T4.IBPRP4, 
       T4.IBSHCN, 
       T4.IBPRP9,
       CASE WHEN NVL((SELECT P1.FPLITM FROM QADTA.F55410P P1
         WHERE P1.FPLITM = T4.IBLITM),0) = 0 THEN 'N�O' ELSE 'SIM' END AS "FARM�CIA POPULAR",  
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR1) = 0 THEN 0 ELSE MAX(TBTXR1)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'SP'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS EST SPxSP",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR2) = 0 THEN 0 ELSE MAX(TBTXR2)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'SP'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS INTER SPxSP",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBIRF) = 0 THEN 0 ELSE MAX(TBBIRF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'SP'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ICMS SPxSP",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISF) = 0 THEN 0 ELSE MAX(TBBISF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'SP'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ST SPxSP",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISR) = 0 THEN 0 ELSE MAX(TBBISR)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'SP'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ST SPxSP",
-----
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR1) = 0 THEN 0 ELSE MAX(TBTXR1)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'RJ'
           AND TBADDS = 'RJ'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS EST RJxRJ",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR2) = 0 THEN 0 ELSE MAX(TBTXR2)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'RJ'
           AND TBADDS = 'RJ'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS INTER RJxRJ",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBIRF) = 0 THEN 0 ELSE MAX(TBBIRF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'RJ'
           AND TBADDS = 'RJ'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ICMS RJxRJ",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISF) = 0 THEN 0 ELSE MAX(TBBISF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'RJ'
           AND TBADDS = 'RJ'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ST RJxRJ",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISR) = 0 THEN 0 ELSE MAX(TBBISR)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'RJ'
           AND TBADDS = 'RJ'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ST RJxRJ",           
-----
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR1) = 0 THEN 0 ELSE MAX(TBTXR1)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'PR'
           AND TBADDS = 'PR'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS EST PRxPR",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR2) = 0 THEN 0 ELSE MAX(TBTXR2)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'PR'
           AND TBADDS = 'PR'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS INTER PRxPR",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBIRF) = 0 THEN 0 ELSE MAX(TBBIRF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'PR'
           AND TBADDS = 'PR'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ICMS PRxPR",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISF) = 0 THEN 0 ELSE MAX(TBBISF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'PR'
           AND TBADDS = 'PR'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ST PRxPR",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISR) = 0 THEN 0 ELSE MAX(TBBISR)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'PR'
           AND TBADDS = 'PR'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ST PRxPR",       
----           
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR1) = 0 THEN 0 ELSE MAX(TBTXR1)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'MG'
           AND TBADDS = 'MG'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS EST MGxMG",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR2) = 0 THEN 0 ELSE MAX(TBTXR2)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'MG'
           AND TBADDS = 'MG'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS INTER MGxMG",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBIRF) = 0 THEN 0 ELSE MAX(TBBIRF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'MG'
           AND TBADDS = 'MG'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ICMS MGxMG",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISF) = 0 THEN 0 ELSE MAX(TBBISF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'MG'
           AND TBADDS = 'MG'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ST MGxMG",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISR) = 0 THEN 0 ELSE MAX(TBBISR)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'MG'
           AND TBADDS = 'MG'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ST MGxMG",   
----           
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR1) = 0 THEN 0 ELSE MAX(TBTXR1)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'GO'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS EST GOxGO",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR2) = 0 THEN 0 ELSE MAX(TBTXR2)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'GO'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS INTER GOxGO",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBIRF) = 0 THEN 0 ELSE MAX(TBBIRF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'GO'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ICMS GOxGO",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISF) = 0 THEN 0 ELSE MAX(TBBISF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'GO'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ST GOxGO",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISR) = 0 THEN 0 ELSE MAX(TBBISR)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'GO'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ST GOxGO",   
----
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR1) = 0 THEN 0 ELSE MAX(TBTXR1)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'DF'
           AND TBADDS = 'DF'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS EST DFxDF",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR2) = 0 THEN 0 ELSE MAX(TBTXR2)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'DF'
           AND TBADDS = 'DF'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS INTER DFxDF",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBIRF) = 0 THEN 0 ELSE MAX(TBBIRF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'DF'
           AND TBADDS = 'DF'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ICMS DFxDF",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISF) = 0 THEN 0 ELSE MAX(TBBISF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'DF'
           AND TBADDS = 'DF'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ST DFxDF",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISR) = 0 THEN 0 ELSE MAX(TBBISR)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'DF'
           AND TBADDS = 'DF'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ST DFxDF",   
----
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR1) = 0 THEN 0 ELSE MAX(TBTXR1)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS EST GOxSP",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR2) = 0 THEN 0 ELSE MAX(TBTXR2)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS INTER GOxSP",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBIRF) = 0 THEN 0 ELSE MAX(TBBIRF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ICMS GOxSP",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISF) = 0 THEN 0 ELSE MAX(TBBISF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ST GOxSP",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISR) = 0 THEN 0 ELSE MAX(TBBISR)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ST GOxSP",   
----
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR1) = 0 THEN 0 ELSE MAX(TBTXR1)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'RJ'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS EST GOxRJ",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR2) = 0 THEN 0 ELSE MAX(TBTXR2)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'RJ'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ICMS INTER GOxRJ",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBIRF) = 0 THEN 0 ELSE MAX(TBBIRF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'RJ'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ICMS GOxRJ",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISF) = 0 THEN 0 ELSE MAX(TBBISF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'RJ'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "ST GOxRJ",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISR) = 0 THEN 0 ELSE MAX(TBBISR)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'RJ'
           AND TBAC76 IN ('*','VEN'))),'N/A') AS "REDUCAO ST GOxRJ", 
           
---------
---------
       
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR1) = 0 THEN 0 ELSE MAX(TBTXR1)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'SP'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('CON'))),'N/A') AS "ICMS EST SPxSP N�o CONTRIB",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR2) = 0 THEN 0 ELSE MAX(TBTXR2)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'SP'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('CON'))),'N/A') AS "ICMS INTER SPxSP N�o CONTRIB",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBIRF) = 0 THEN 0 ELSE MAX(TBBIRF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'SP'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('CON'))),'N/A') AS "REDUCAO ICMS SPxSP N�o CONTRIB",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISF) = 0 THEN 0 ELSE MAX(TBBISF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'SP'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('CON'))),'N/A') AS "ST SPxSP N�o CONTRIB",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISR) = 0 THEN 0 ELSE MAX(TBBISR)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'SP'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('CON'))),'N/A') AS "REDUCAO ST SPxSP N�o CONTRIB",
-----
       NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR1) = 0 THEN 0 ELSE MAX(TBTXR1)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('CON'))),'N/A') AS "ICMS EST GOxSP N�o CONTRIB",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBTXR2) = 0 THEN 0 ELSE MAX(TBTXR2)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('CON'))),'N/A') AS "ICMS INTER GOxSP N�o CONTRIB",
        NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBIRF) = 0 THEN 0 ELSE MAX(TBBIRF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('CON'))),'N/A') AS "REDUCAO ICMS GOxSP N�o CONTRIB",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISF) = 0 THEN 0 ELSE MAX(TBBISF)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('CON'))),'N/A') AS "ST GOxSP N�o CONTRIB",
         NVL(TO_CHAR((SELECT (CASE WHEN MAX(TBBISR) = 0 THEN 0 ELSE MAX(TBBISR)/1000 END)   FROM QADTA.F7608B
         WHERE TBITM = T4.IBITM
           AND TBSHST = 'GO'
           AND TBADDS = 'SP'
           AND TBAC76 IN ('CON'))),'N/A') AS "REDUCAO ST GOxSP N�o CONTRIB"   
  
  from QADTA.F0101 T1,
       QADTA.F4101 T2,
       QADTA.F4104 T3,
       (select *
          from QADTA.f4102 P1, QADTA.f41021 P2
           where trim(P1.ibmcu) = 'DIFARCAT'
           and P1.ibitm = P2.liitm 
           and P2.lilocn NOT IN ('ENTRADA', 'VENCIDO', 'DEVOL')
           and P1.ibstkt != 'O'
           and P1.ibshcn <> 'TMB' --MEDICAMENTOS E PERFUMARIAS ARMAZENADOS NO DEPOSITO
        union
        SELECT *
          from QADTA.f4102 P1,QADTA.f41021 P2
           where trim(P1.ibmcu) = 'DIFARCAT'
           and P1.ibitm = P2.liitm 
           and P2.lilocn = 'ENTRADA'
           and P1.ibstkt != 'O'
           and P2.lilotn = ' ' 
           and P1.IBSHCN <> 'TMB' --MEDICAMENTOS E PERFUMARIAS ARMAZENADOS NO DEPOSITO
        union 
          select *
          from QADTA.f4102 P1, QADTA.f41021 P2
           where trim(P1.ibmcu) = 'DIFARMA'
           and P1.ibitm = P2.liitm 
           and P2.lilocn NOT IN ('ENTRADA', 'VENCIDO', 'DEVOL')
           and P1.ibstkt != 'O'
           and P1.ibshcn = 'TMB' --MEDICAMENTOS DE ARMAZENAMENTO EM GELADEIRA
        union
        SELECT *
          from QADTA.f4102 P1,QADTA.f41021 P2
           where trim(P1.ibmcu) = 'DIFARMA'
           and P1.ibitm = P2.liitm 
           and P2.lilocn = 'ENTRADA'
           and P1.ibstkt != 'O'
           and P2.lilotn = ' ' 
           and P1.ibshcn = 'TMB' --MEDICAMENTOS DE ARMAZENAMENTO EM GELADEIRA
         ) T4
 WHERE T2.IMANPL = T1.ABAN8
   AND T2.IMITM = T4.IBITM
   AND T2.IMLITM = T3.IVLITM
   AND T3.IVXRT = 'VN' -- Ref. Cruzada: Cod Ean do Produto
   --and T4.IBLITM = '30174'
   and T3.IVEXDJ >= TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000 --Data de Vigencia do Ean 
 GROUP BY T4.IBLITM,T4.IBITM, T1.ABALPH,T4.IBPRP5,T4.IBSRP8,T4.IBPRP1,T4.IBSRP3,T4.IBPRP2,T4.IBPRP4,T2.IMDSC1,T4.IBSHCN,T4.IBPRP9
 ORDER BY T4.IBLITM ASC;
