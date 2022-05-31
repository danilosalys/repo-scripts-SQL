SELECT SAVR01,
       SAZ55ORI,
       SADCTO,
       SADOCO,
       FDBNNF,
       FDBSER,
       FDN001,
       SBLITM,
       SBLNID,
       SDPRP5,
       CASE --JA ESTA NO CODIGO
         WHEN ((SELECT IBPRP5
                  FROM PRODDTA.F4102
                 WHERE IBMCU = '    DIFARCAT'
                   AND IBLITM = SBLITM) = 'MED' AND SDAEXP > 0 AND
              SDSOQS > 0) THEN
          (CASE --ADICIONAR NO CODIGO
            WHEN (SELECT ABAC05 FROM PRODDTA.F0101 WHERE ABAN8 = SDAN8) <>
                 'DRO' THEN
             ((CASE
               WHEN SADCTO = 'OL' THEN
                TO_NUMBER(CASE
                            WHEN SBHOLD IS NOT NULL OR SBHOLD <> 0 THEN
                             TRIM(SBUOM) || ',' || TRIM(SBHOLD)
                            ELSE
                             TRIM(SBUOM)
                          END)
               ELSE
                0
             END) +
             NVL((SELECT NVL(SUM(CASE
                                   WHEN (SELECT TRIM(DRDL01)
                                           FROM PRODDTA.F0005
                                          WHERE DRSY = '55'
                                            AND DRRT = 'RA'
                                            AND TRIM(DRKY) =
                                                'REP' ||
                                                (SELECT TRIM(ALADDS)
                                                   FROM PRODDTA.F0116
                                                  WHERE ALAN8 = B1.SDAN8)) = 'N' AND
                                        A1.ALAST =
                                        (SELECT TRIM(REPLACE(DRKY, 'RE', NULL))
                                           FROM PRODDTA.F0005
                                          WHERE DRSY = '55'
                                            AND DRRT = 'RS'
                                            AND DRKY = 'RE' || A1.ALAST) THEN
                                    0
                                   ELSE
                                    ABS(A1.ALFVTR / 10000)
                                 END),
                             0)
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
                                                  AND TRIM(DRKY) =
                                                      'PMC' || B1.SDEUSE),
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
                   GROUP BY ALLNID),
                  0))
            ELSE
            --CALCULAR DESCONTO SOMENTE PARA MEDICAMENTOS ATENDIDOS NO PEDIDO
             ROUND((CASE
                     WHEN ( -- POR PMC - ITENS CONTROLADOS
                          (CASE
                            WHEN ((SELECT IBSRP8
                                     FROM PRODDTA.F4102
                                    WHERE IBMCU = '    DIFARCAT'
                                      AND IBLITM = SBLITM) in ('C', 'V')) THEN
                            --UDC 55 | DA | ZHR | STPMC        
                            --RETIREI A VALIDAÇÃO DE CLIENTES <> DROGÃO PORQUE SOMENTE PEDIDOS DROGÃO IRÁ PASSAR POR ESTE TRECHO
                             (CASE
                               WHEN NVL((SELECT DRDL02
                                          FROM PRODDTA.F0005, PRODDTA.F0101
                                         WHERE DRSY = '55'
                                           AND DRRT = 'DA'
                                           AND DRSPHD = '1'
                                           AND ABAN8 = SDAN8
                                           AND SUBSTR(TRIM(DRKY), 1, 3) = TRIM(SAZ55ORI)
                                           AND SUBSTR(TRIM(DRKY), 4, 2) IN
                                               (SELECT TRIM(ABAC16)
                                                  FROM PRODDTA.F0101, PRODDTA.F0006
                                                 WHERE MCMCU = LPAD(SDEMCU, 12, ' ')
                                                   AND MCAN8 = ABAN8)
                                           AND SUBSTR(TRIM(DRKY), 4, 2) = TRIM(ABAC16)
                                           AND SUBSTR(TRIM(DRKY), 6, 5) = 'STPMC'),
                                        ' ') = ' ' THEN
                               --UDC 00 | 28
                                NVL((SELECT DRDL01 AJUSTE
                                      FROM PRODDTA.F0005, PRODDTA.F0006
                                     WHERE DRSY = '00'
                                       AND DRRT = '28'
                                       AND DRSPHD = '1'
                                       AND TRIM(DRKY) = TRIM(MCRP28)
                                       AND MCMCU = LPAD(SDEMCU, 12, ' ')),
                                    '')
                               ELSE
                                NVL((SELECT DRDL02 AJUSTE
                                      FROM PRODDTA.F0005, PRODDTA.F0101
                                     WHERE DRSY = '55'
                                       AND DRRT = 'DA'
                                       AND DRSPHD = '1'
                                       AND ABAN8 = SDAN8
                                       AND SUBSTR(TRIM(DRKY), 1, 3) = TRIM(SAZ55ORI)
                                       AND SUBSTR(TRIM(DRKY), 4, 2) IN
                                           (SELECT TRIM(ABAC16)
                                              FROM PRODDTA.F0101, PRODDTA.F0006
                                             WHERE MCMCU = LPAD(SDEMCU, 12, ' ')
                                               AND MCAN8 = ABAN8)
                                       AND SUBSTR(TRIM(DRKY), 4, 2) = TRIM(ABAC16)
                                       AND SUBSTR(TRIM(DRKY), 6, 5) = 'STPMC'),
                                    ' ')
                             END)
                            ELSE
                            --Por MVA - itens liberados
                            --UDC 55 | DA | ZHR | ST 
                            --RETIREI A VALIDAÇÃO DE CLIENTES <> DROGÃO PORQUE SOMENTE PEDIDOS DROGÃO IRÁ PASSAR POR ESTE TRECHO
                             (CASE
                               WHEN NVL((SELECT DRDL02 AJUSTE
                                          FROM PRODDTA.F0005, PRODDTA.F0101
                                         WHERE DRSY = '55'
                                           AND DRRT = 'DA'
                                           AND DRSPHD = '1'
                                           AND ABAN8 = SDAN8
                                           AND SUBSTR(TRIM(DRKY), 1, 3) = TRIM(SAZ55ORI)
                                           AND SUBSTR(TRIM(DRKY), 4, 2) IN
                                               (SELECT TRIM(ABAC16)
                                                  FROM PRODDTA.F0101, PRODDTA.F0006
                                                 WHERE MCMCU = LPAD(SDEMCU, 12, ' ')
                                                   AND MCAN8 = ABAN8)
                                           AND SUBSTR(TRIM(DRKY), 4, 2) = TRIM(ABAC16)
                                           AND SUBSTR(TRIM(DRKY), 6, 5) = 'ST'),
                                        ' ') = ' ' THEN
                               -- UDC 00 | 29 
                                NVL((select drdl01 AJUSTE
                                      from PRODDTA.f0005, PRODDTA.f0006
                                     where drsy = '00'
                                       and drrt = '29'
                                       and drsphd = '1'
                                       and trim(drky) = trim(mcrp29)
                                       and mcmcu = lpad(SDEMCU, 12, ' ')),
                                    ' ')
                               ELSE
                                NVL((SELECT DRDL02 AJUSTE
                                      FROM PRODDTA.F0005, PRODDTA.F0101
                                     WHERE DRSY = '55'
                                       AND DRRT = 'DA'
                                       AND DRSPHD = '1'
                                       AND ABAN8 = SDAN8
                                       AND SUBSTR(TRIM(DRKY), 1, 3) = TRIM(SAZ55ORI)
                                       AND SUBSTR(TRIM(DRKY), 4, 2) IN
                                           (SELECT TRIM(ABAC16)
                                              FROM PRODDTA.F0101, PRODDTA.F0006
                                             WHERE MCMCU = LPAD(SDEMCU, 12, ' ')
                                               AND MCAN8 = ABAN8)
                                       AND SUBSTR(TRIM(DRKY), 4, 2) = TRIM(ABAC16)
                                       AND SUBSTR(TRIM(DRKY), 6, 5) = 'ST'),
                                    ' ')
                             END)
                          END)) <> ' ' THEN
                      (CASE
                        WHEN ((SDUOM <> SDUOM4) AND
                             NVL((Select umconv / 10000000
                                    From PRODDTA.f41002, PRODDTA.f0005
                                   Where trim(ummcu) = trim(drky)
                                     and Umitm = SDITM
                                     and Umum = SDUOM4
                                     and drsy = '55'
                                     and drrt = 'OF'
                                     and drsphd = '1'
                                     and umrum = 'UN'
                                     and rownum = 1),
                                  0) <> 0) THEN
                         NVL((SELECT ROUND(ALUPRC / 10000, 2) ALUPRC
                               FROM PRODDTA.F4074
                              WHERE ALDOCO = SDDOCO
                                AND ALDCTO = SDDCTO
                                AND TRUNC(ALLNID / 1000) = TRUNC(SDLNID / 1000)
                                AND ALAST = TRIM -- POR PMC - ITENS CONTROLADOS
                                    (CASE
                                               WHEN ((SELECT IBSRP8
                                                        FROM PRODDTA.F4102
                                                       WHERE IBMCU = '    DIFARCAT'
                                                         AND IBLITM = SBLITM) in ('C', 'V')) THEN
                                               --UDC 55 | DA | ZHR | STPMC        
                                               --RETIREI A VALIDAÇÃO DE CLIENTES <> DROGÃO PORQUE SOMENTE PEDIDOS DROGÃO IRÁ PASSAR POR ESTE TRECHO
                                                (CASE
                                                  WHEN NVL((SELECT DRDL02
                                                             FROM PRODDTA.F0005, PRODDTA.F0101
                                                            WHERE DRSY = '55'
                                                              AND DRRT = 'DA'
                                                              AND DRSPHD = '1'
                                                              AND ABAN8 = SDAN8
                                                              AND SUBSTR(TRIM(DRKY), 1, 3) =
                                                                  TRIM(SAZ55ORI)
                                                              AND SUBSTR(TRIM(DRKY), 4, 2) IN
                                                                  (SELECT TRIM(ABAC16)
                                                                     FROM PRODDTA.F0101, PRODDTA.F0006
                                                                    WHERE MCMCU = LPAD(SDEMCU, 12, ' ')
                                                                      AND MCAN8 = ABAN8)
                                                              AND SUBSTR(TRIM(DRKY), 4, 2) =
                                                                  TRIM(ABAC16)
                                                              AND SUBSTR(TRIM(DRKY), 6, 5) = 'STPMC'),
                                                           ' ') = ' ' THEN
                                                  --UDC 00 | 28
                                                   NVL((SELECT DRDL01 AJUSTE
                                                         FROM PRODDTA.F0005, PRODDTA.F0006
                                                        WHERE DRSY = '00'
                                                          AND DRRT = '28'
                                                          AND DRSPHD = '1'
                                                          AND TRIM(DRKY) = TRIM(MCRP28)
                                                          AND MCMCU = LPAD(SDEMCU, 12, ' ')),
                                                       '')
                                                  ELSE
                                                   NVL((SELECT DRDL02 AJUSTE
                                                         FROM PRODDTA.F0005, PRODDTA.F0101
                                                        WHERE DRSY = '55'
                                                          AND DRRT = 'DA'
                                                          AND DRSPHD = '1'
                                                          AND ABAN8 = SDAN8
                                                          AND SUBSTR(TRIM(DRKY), 1, 3) = TRIM(SAZ55ORI)
                                                          AND SUBSTR(TRIM(DRKY), 4, 2) IN
                                                              (SELECT TRIM(ABAC16)
                                                                 FROM PRODDTA.F0101, PRODDTA.F0006
                                                                WHERE MCMCU = LPAD(SDEMCU, 12, ' ')
                                                                  AND MCAN8 = ABAN8)
                                                          AND SUBSTR(TRIM(DRKY), 4, 2) = TRIM(ABAC16)
                                                          AND SUBSTR(TRIM(DRKY), 6, 5) = 'STPMC'),
                                                       ' ')
                                                END)
                                               ELSE
                                               --Por MVA - itens liberados
                                               --UDC 55 | DA | ZHR | ST 
                                               --RETIREI A VALIDAÇÃO DE CLIENTES <> DROGÃO PORQUE SOMENTE PEDIDOS DROGÃO IRÁ PASSAR POR ESTE TRECHO
                                                (CASE
                                                  WHEN NVL((SELECT DRDL02 AJUSTE
                                                             FROM PRODDTA.F0005, PRODDTA.F0101
                                                            WHERE DRSY = '55'
                                                              AND DRRT = 'DA'
                                                              AND DRSPHD = '1'
                                                              AND ABAN8 = SDAN8
                                                              AND SUBSTR(TRIM(DRKY), 1, 3) =
                                                                  TRIM(SAZ55ORI)
                                                              AND SUBSTR(TRIM(DRKY), 4, 2) IN
                                                                  (SELECT TRIM(ABAC16)
                                                                     FROM PRODDTA.F0101, PRODDTA.F0006
                                                                    WHERE MCMCU = LPAD(SDEMCU, 12, ' ')
                                                                      AND MCAN8 = ABAN8)
                                                              AND SUBSTR(TRIM(DRKY), 4, 2) =
                                                                  TRIM(ABAC16)
                                                              AND SUBSTR(TRIM(DRKY), 6, 5) = 'ST'),
                                                           ' ') = ' ' THEN
                                                  -- UDC 00 | 29 
                                                   NVL((select drdl01 AJUSTE
                                                         from PRODDTA.f0005, PRODDTA.f0006
                                                        where drsy = '00'
                                                          and drrt = '29'
                                                          and drsphd = '1'
                                                          and trim(drky) = trim(mcrp29)
                                                          and mcmcu = lpad(SDEMCU, 12, ' ')),
                                                       ' ')
                                                  ELSE
                                                   NVL((SELECT DRDL02 AJUSTE
                                                         FROM PRODDTA.F0005, PRODDTA.F0101
                                                        WHERE DRSY = '55'
                                                          AND DRRT = 'DA'
                                                          AND DRSPHD = '1'
                                                          AND ABAN8 = SDAN8
                                                          AND SUBSTR(TRIM(DRKY), 1, 3) = TRIM(SAZ55ORI)
                                                          AND SUBSTR(TRIM(DRKY), 4, 2) IN
                                                              (SELECT TRIM(ABAC16)
                                                                 FROM PRODDTA.F0101, PRODDTA.F0006
                                                                WHERE MCMCU = LPAD(SDEMCU, 12, ' ')
                                                                  AND MCAN8 = ABAN8)
                                                          AND SUBSTR(TRIM(DRKY), 4, 2) = TRIM(ABAC16)
                                                          AND SUBSTR(TRIM(DRKY), 6, 5) = 'ST'),
                                                       ' ')
                                                END)
                                             END)
                              GROUP BY ALDOCO, ALUPRC),
                             0) / NVL((Select umconv / 10000000
                                        From PRODDTA.f41002, PRODDTA.f0005
                                       Where trim(ummcu) = trim(drky)
                                         and Umitm = SDITM
                                         and Umum = SDUOM4
                                         and drsy = '55'
                                         and drrt = 'OF'
                                         and drsphd = '1'
                                         and umrum = 'UN'
                                         and rownum = 1),
                                      0)
                        ELSE
                         (1 -
                         ((SDAEXP / 100) -
                         (NVL((SELECT --ALDOCO,
                                 ROUND(ALUPRC / 10000, 2) ALUPRC
                                  FROM PRODDTA.F4074
                                 WHERE ALDOCO = SDDOCO
                                   AND ALDCTO = SDDCTO
                                   AND TRUNC(ALLNID / 1000) = TRUNC(SDLNID / 1000)
                                   AND ALAST = TRIM( -- POR PMC - ITENS CONTROLADOS
                                                    (CASE
                                                      WHEN ((SELECT IBSRP8
                                                               FROM PRODDTA.F4102
                                                              WHERE IBMCU = '    DIFARCAT'
                                                                AND IBLITM = SBLITM) in ('C', 'V')) THEN
                                                      --UDC 55 | DA | ZHR | STPMC        
                                                      --RETIREI A VALIDAÇÃO DE CLIENTES <> DROGÃO PORQUE SOMENTE PEDIDOS DROGÃO IRÁ PASSAR POR ESTE TRECHO
                                                       (CASE
                                                         WHEN NVL((SELECT DRDL02
                                                                    FROM PRODDTA.F0005, PRODDTA.F0101
                                                                   WHERE DRSY = '55'
                                                                     AND DRRT = 'DA'
                                                                     AND DRSPHD = '1'
                                                                     AND ABAN8 = SDAN8
                                                                     AND SUBSTR(TRIM(DRKY), 1, 3) =
                                                                         TRIM(SAZ55ORI)
                                                                     AND SUBSTR(TRIM(DRKY), 4, 2) IN
                                                                         (SELECT TRIM(ABAC16)
                                                                            FROM PRODDTA.F0101, PRODDTA.F0006
                                                                           WHERE MCMCU =
                                                                                 LPAD(SDEMCU, 12, ' ')
                                                                             AND MCAN8 = ABAN8)
                                                                     AND SUBSTR(TRIM(DRKY), 4, 2) =
                                                                         TRIM(ABAC16)
                                                                     AND SUBSTR(TRIM(DRKY), 6, 5) = 'STPMC'),
                                                                  ' ') = ' ' THEN
                                                         --UDC 00 | 28
                                                          NVL((SELECT DRDL01 AJUSTE
                                                                FROM PRODDTA.F0005, PRODDTA.F0006
                                                               WHERE DRSY = '00'
                                                                 AND DRRT = '28'
                                                                 AND DRSPHD = '1'
                                                                 AND TRIM(DRKY) = TRIM(MCRP28)
                                                                 AND MCMCU = LPAD(SDEMCU, 12, ' ')),
                                                              '')
                                                         ELSE
                                                          NVL((SELECT DRDL02 AJUSTE
                                                                FROM PRODDTA.F0005, PRODDTA.F0101
                                                               WHERE DRSY = '55'
                                                                 AND DRRT = 'DA'
                                                                 AND DRSPHD = '1'
                                                                 AND ABAN8 = SDAN8
                                                                 AND SUBSTR(TRIM(DRKY), 1, 3) =
                                                                     TRIM(SAZ55ORI)
                                                                 AND SUBSTR(TRIM(DRKY), 4, 2) IN
                                                                     (SELECT TRIM(ABAC16)
                                                                        FROM PRODDTA.F0101, PRODDTA.F0006
                                                                       WHERE MCMCU = LPAD(SDEMCU, 12, ' ')
                                                                         AND MCAN8 = ABAN8)
                                                                 AND SUBSTR(TRIM(DRKY), 4, 2) = TRIM(ABAC16)
                                                                 AND SUBSTR(TRIM(DRKY), 6, 5) = 'STPMC'),
                                                              ' ')
                                                       END)
                                                      ELSE
                                                      --Por MVA - itens liberados
                                                      --UDC 55 | DA | ZHR | ST 
                                                      --RETIREI A VALIDAÇÃO DE CLIENTES <> DROGÃO PORQUE SOMENTE PEDIDOS DROGÃO IRÁ PASSAR POR ESTE TRECHO
                                                       (CASE
                                                         WHEN NVL((SELECT DRDL02 AJUSTE
                                                                    FROM PRODDTA.F0005, PRODDTA.F0101
                                                                   WHERE DRSY = '55'
                                                                     AND DRRT = 'DA'
                                                                     AND DRSPHD = '1'
                                                                     AND ABAN8 = SDAN8
                                                                     AND SUBSTR(TRIM(DRKY), 1, 3) =
                                                                         TRIM(SAZ55ORI)
                                                                     AND SUBSTR(TRIM(DRKY), 4, 2) IN
                                                                         (SELECT TRIM(ABAC16)
                                                                            FROM PRODDTA.F0101, PRODDTA.F0006
                                                                           WHERE MCMCU =
                                                                                 LPAD(SDEMCU, 12, ' ')
                                                                             AND MCAN8 = ABAN8)
                                                                     AND SUBSTR(TRIM(DRKY), 4, 2) =
                                                                         TRIM(ABAC16)
                                                                     AND SUBSTR(TRIM(DRKY), 6, 5) = 'ST'),
                                                                  ' ') = ' ' THEN
                                                         -- UDC 00 | 29 
                                                          NVL((select drdl01 AJUSTE
                                                                from PRODDTA.f0005, PRODDTA.f0006
                                                               where drsy = '00'
                                                                 and drrt = '29'
                                                                 and drsphd = '1'
                                                                 and trim(drky) = trim(mcrp29)
                                                                 and mcmcu = lpad(SDEMCU, 12, ' ')),
                                                              ' ')
                                                         ELSE
                                                          NVL((SELECT DRDL02 AJUSTE
                                                                FROM PRODDTA.F0005, PRODDTA.F0101
                                                               WHERE DRSY = '55'
                                                                 AND DRRT = 'DA'
                                                                 AND DRSPHD = '1'
                                                                 AND ABAN8 = SDAN8
                                                                 AND SUBSTR(TRIM(DRKY), 1, 3) =
                                                                     TRIM(SAZ55ORI)
                                                                 AND SUBSTR(TRIM(DRKY), 4, 2) IN
                                                                     (SELECT TRIM(ABAC16)
                                                                        FROM PRODDTA.F0101, PRODDTA.F0006
                                                                       WHERE MCMCU = LPAD(SDEMCU, 12, ' ')
                                                                         AND MCAN8 = ABAN8)
                                                                 AND SUBSTR(TRIM(DRKY), 4, 2) = TRIM(ABAC16)
                                                                 AND SUBSTR(TRIM(DRKY), 6, 5) = 'ST'),
                                                              ' ')
                                                       END)
                                                    END))
                                 GROUP BY ALDOCO, ALUPRC),
                                0) * SDSOQS)) / ((SDLPRC / 10000) * SDSOQS)) * 100
                      END)
                     ELSE
                      (((SDLPRC / 10000) * SDSOQS) - (SDAEXP / 100)) /
                      ((SDLPRC / 10000) * SDSOQS) * 100
                   END),
                   2)
          END)
         ELSE
          0
       END AS DESCONTO_PERCENTUAL,
       PRODDTA.F555511.EDAN04 / 100 AS DESC_DANFE
  FROM PRODDTA.F5547011,
       PRODDTA.F5547012,
       (SELECT *
          FROM (SELECT *
                  FROM PRODDTA.F4211
                UNION
                SELECT * FROM PRODDTA.F42119)),
       PRODDTA.F7611B,
       PRODDTA.F555511
 WHERE SAUKID = SBUKID
   AND SDTRDJ BETWEEN 115229 AND 115243
   AND SDDCTO IN ('VO', 'OL', 'ZL', 'ZN')
      --   AND SDEUSE IN ('PRP', 'ZHR', 'HRY', 'PBM')
      --  AND SDEUSE = 'PTC'
   AND SAOORN = 'MERCANET'
   and SDDOCO = &PEDIDO
   AND SADOCO = SDDOCO
   AND SBLNID = SDLNID
   AND SBLITM = SDLITM
   AND SDDOCO = FDDOCO
   AND SDLNID = FDLNID
   AND SDLITM = FDLITM
   AND FDBNNF = EDBNNF
   AND FDBSER = EDBSER
   AND FDN001 = EDN001
   AND FDLNID = EDLNID;
