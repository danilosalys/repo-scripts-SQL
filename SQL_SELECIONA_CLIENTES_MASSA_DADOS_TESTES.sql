SELECT DB_CLI_CODIGO,
       DB_CLI_CGCMF,
       DB_CLI_ESTADO,
       DB_CLI_NOME,
       AT1000.DB_CLIA_VALOR AS "ATRIB-1000",
       AT1005.DB_CLIA_VALOR AS "ATRIB-1005",
       AT1012.DB_CLIA_VALOR AS "ATRIB-1012",
       AT1013.DB_CLIA_VALOR AS "ATRIB-1013",
       AT1015.DB_CLIA_VALOR AS "ATRIB-1015",
       AT1018.DB_CLIA_VALOR AS "ATRIB-1018",
       AT1029.DB_CLIA_VALOR AS "ATRIB-1029",
       AT1030.DB_CLIA_VALOR AS "ATRIB-1030"
  FROM MERCANET_QA.DB_CLIENTE,
       MERCANET_QA.DB_CLIENTE_ATRIB AT1000,
       MERCANET_QA.DB_CLIENTE_ATRIB AT1005,
       MERCANET_QA.DB_CLIENTE_ATRIB AT1012,
       MERCANET_QA.DB_CLIENTE_ATRIB AT1013,
       MERCANET_QA.DB_CLIENTE_ATRIB AT1018,
       MERCANET_QA.DB_CLIENTE_ATRIB AT1029,
       MERCANET_QA.DB_CLIENTE_ATRIB AT1030,
       MERCANET_QA.DB_CLIENTE_ATRIB AT1015
 WHERE DB_CLI_SITUACAO = 0
   AND DB_CLI_CODIGO = AT1000.DB_CLIA_CODIGO
   AND AT1000.DB_CLIA_ATRIB = 1000
   AND DB_CLI_CODIGO = AT1005.DB_CLIA_CODIGO
   AND AT1005.DB_CLIA_ATRIB = 1005
   AND DB_CLI_CODIGO = AT1012.DB_CLIA_CODIGO
   AND AT1012.DB_CLIA_ATRIB = 1012
   AND DB_CLI_CODIGO = AT1013.DB_CLIA_CODIGO
   AND AT1013.DB_CLIA_ATRIB = 1013
   AND DB_CLI_CODIGO = AT1018.DB_CLIA_CODIGO
   AND AT1018.DB_CLIA_ATRIB = 1018
   AND DB_CLI_CODIGO = AT1029.DB_CLIA_CODIGO
   AND AT1029.DB_CLIA_ATRIB = 1029
   AND DB_CLI_CODIGO = AT1030.DB_CLIA_CODIGO
   AND AT1030.DB_CLIA_ATRIB = 1030
   AND DB_CLI_CODIGO = AT1015.DB_CLIA_CODIGO
   AND AT1015.DB_CLIA_ATRIB = 1015
   AND EXISTS (SELECT 1
          FROM QADTA.F03012@DC10
         WHERE AIAN8 = DB_CLI_CODIGO
           AND AIHOLD = ' ')
   AND EXISTS (SELECT LCAN8,
       LCPA8,
       LCAT1,
       LCTAX,
       LCARTO,
       LCHOLD,
       LCACL,
       LCAPRC,
       LCAAP,
       (((LCACL * 100) - LCAPRC - LCAAP)/100) AS LCAMTU
  FROM (SELECT A.ABAN8 AS LCAN8,
               NVL(B.MAPA8, A.ABAN8) AS LCPA8,
               ABAT1 AS LCAT1,
               ABTAX AS LCTAX,
               C.AIARTO AS LCARTO,
               C.AIHOLD AS LCHOLD,
               CASE
                 WHEN C.AIARTO = 'P' THEN
                  NVL((SELECT D.AIACL
                        FROM qadta.F03012@dc10 D
                       WHERE D.AIAN8 = NVL(B.MAPA8, A.ABAN8)
                         AND D.AICO = '00000'),
                      0)
                 ELSE
                  NVL(C.AIACL, 0)
               END AS LCACL,
               CASE
                 WHEN C.AIARTO = 'P' THEN
                  NVL((SELECT SUM(E.AIAPRC)
                        FROM qadta.F03012@dc10 E, qadta.F0150@dc10 F
                       WHERE E.AIAN8 = F.MAAN8
                         AND E.AIAN8 != F.MAPA8
                         AND E.AICO = '00000'
                         AND F.MAPA8 = NVL(B.MAPA8, A.ABAN8)),
                      0) + NVL((SELECT K.AIAPRC
                                 FROM qadta.F03012@dc10 K
                                WHERE K.AIAN8 = NVL(B.MAPA8, A.ABAN8)
                                  AND K.AICO = '00000'),
                               0)
                 ELSE
                  C.AIAPRC
               END AS LCAPRC,
               CASE
                 WHEN C.AIARTO = 'P' THEN
                  NVL((SELECT SUM(G.RPAAP)
                        FROM qadta.F03B11@dc10 G, qadta.F0150@dc10 H
                       WHERE G.RPAN8 = H.MAAN8
                         AND G.RPAN8 != H.MAPA8
                         AND G.RPPST NOT IN ('P', 'S')
                         AND H.MAPA8 = NVL(B.MAPA8, A.ABAN8)),
                      0) + NVL((SELECT SUM(J.RPAAP)
                                 FROM qadta.F03B11@dc10 J
                                WHERE J.RPAN8 = NVL(B.MAPA8, A.ABAN8)
                                  AND J.RPPST NOT IN ('P', 'S')),
                               0)
                 ELSE
                  NVL((SELECT SUM(J.RPAAP)
                        FROM qadta.F03B11@dc10 J
                       WHERE J.RPAN8 = A.ABAN8
                         AND J.RPPST NOT IN ('P', 'S')),
                      0)
               END AS LCAAP
          FROM qadta.F0101@dc10 A, qadta.F0150@dc10 B, qadta.F03012@dc10 C
         WHERE B.MAAN8(+) = A.ABAN8
           AND C.AIAN8 = A.ABAN8
           AND C.AICO = '00000')
WHERE LCAT1 = 'C'
AND LCHOLD = ' '
AND LCAN8 = DB_CLI_CODIGO
AND (((LCACL * 100) - LCAPRC - LCAAP)/100) > 5000)

