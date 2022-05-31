---PRONTO!VERSÃO FINAL_%DESCONTO
SELECT SAVR01,
       SADOCO,
       SBLITM,
       SBLNID,
      CASE
         WHEN SADCTO = 'OL' THEN
          TO_NUMBER(CASE
                      WHEN SBHOLD IS NOT NULL OR SBHOLD <> 0 THEN
                       TRIM(SBUOM) || ',' || TRIM(SBHOLD)
                      ELSE
                       TRIM(SBUOM)
                    END)
         ELSE
          0
       END +
       NVL((SELECT NVL(SUM(CASE
                         WHEN (SELECT TRIM(DRDL01)
                                 FROM PRODDTA.F0005
                                WHERE DRSY = '55'
                                  AND DRRT = 'RA'
                                  AND TRIM(DRKY) =
                                      'REP' || (SELECT TRIM(ALADDS)
                                                  FROM PRODDTA.F0116
                                                 WHERE ALAN8 = B1.SDAN8)) = 'N' AND
                              A1.ALAST = (SELECT TRIM(REPLACE(DRKY, 'RE', NULL))
                                            FROM PRODDTA.F0005
                                           WHERE DRSY = '55'
                                             AND DRRT = 'RS'
                                             AND DRKY = 'RE' || A1.ALAST) THEN
                          0
                         ELSE
                          ABS(A1.ALFVTR / 10000)
                       END),
                   0) AS "DESC_JDE_C/REGRA_REPASSE"
          FROM PRODDTA.F4074 A1,
               (SELECT *
                  FROM PRODDTA.F4211
                UNION
                SELECT * FROM PRODDTA.F42119) B1
         WHERE A1.ALDOCO = B1.SDDOCO
           AND A1.ALLNID = B1.SDLNID
           AND A1.ALDOCO = SADOCO
           AND A1.ALLNID = SBLNID
           AND A1.ALUPRC < 0
           AND A1.ALACNT = '1'
           AND A1.ALOSEQ >=
               (SELECT A2.ALOSEQ
                  FROM PRODDTA.F4074 A2
                 WHERE A2.ALDOCO = B1.SDDOCO
                   AND A2.ALLNID = B1.SDLNID
                   AND NVL(TRIM(A2.ALAST), ' ') = (CASE
                         WHEN (SELECT AIASN
                                 FROM PRODDTA.F03012
                                WHERE B1.SDAN8 = AIAN8) = 'VDIFBOL' THEN
                          (SELECT TRIM(DRDL01)
                             FROM PRODDTA.F0005
                            WHERE DRSY = '55'
                              AND DRRT = 'DA'
                              AND DRKY = 'PMC' || B1.SDEUSE || 'BOL')
                         ELSE
                          CASE
                            WHEN NVL((SELECT TRIM(DRDL01)
                                       FROM PRODDTA.F0005
                                      WHERE DRSY = '55'
                                        AND DRRT = 'DA'
                                        AND TRIM(DRKY) = 'PMC' || B1.SDEUSE),
                                     ' ') <> ' ' THEN
                             (SELECT TRIM(DRDL01)
                                FROM PRODDTA.F0005
                               WHERE DRSY = '55'
                                 AND DRRT = 'DA'
                                 AND TRIM(DRKY) = 'PMC' || B1.SDEUSE)
                            ELSE
                             ' '
                          END
                       END))
         GROUP BY ALLNID),0) AS "DESCONTO PERCENTUAL"
  FROM PRODDTA.F5547011, 
       PRODDTA.F5547012/*, 
       (SELECT *
          FROM PRODDTA.F4211
        UNION
        SELECT * FROM PRODDTA.F42119),
        PRODDTA.F7611B,
        PRODDTA.F555511*/
 WHERE SAUKID = SBUKID
   AND SADOCO = 25235856
  /* AND ((SADCTO = 'OL' AND SBLNID = SDLNID) OR
       ( SADCTO <> 'OL' AND SBLITM = SDLITM))
   AND SDDOCO = FDDOCO
   AND SDLNID = FDLNID
   AND FDBNNF = EDBNNF
   AND FDBSER = EDBSER
   AND FDN001 = EDN001
   AND FDLNID = EDLNID */; 
   
   
