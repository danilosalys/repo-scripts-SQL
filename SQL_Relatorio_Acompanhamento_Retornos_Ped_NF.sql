--RELATORIO ACOMPANHAMENTO DO RETORNO DE PEDIDOS E NOTAS FISCAL
--Data: 13/09/2017
--Por: Danilo Sales
--versão 9
SELECT EDILD.db_edild_data as "DATA ENVIO DO PEDIDO",
       EDILD.db_edild_seq as "LOTE",
       EDILD.db_edild_nomearq as "NOMENCLATURA ARQ DE PEDIDO",
       (select upper(db_lab_descricao)
          from MERCANET_PRD.DB_LABORATORIO
         where db_lab_codigo = EDIP.db_edip_labcod) "PROJETO",
       DECODE(DB_EDIP_VAN,'540',LTRIM(SUBSTR(DB_EDIP_NRO,1,INSTR(DB_EDIP_NRO, '-', 1, 1) - 1),'0')) as "EDI_PEDIDO_NRO",
       (DECODE(DB_EDIP_VAN,508,ltrim(EDIP.db_edip_obs1, '0'),540,SUBSTR(LTRIM(SUBSTR(DB_EDIP_NRO,1,INSTR(DB_EDIP_NRO, '-', 1, 1) - 1),'0'),4,10),SUBSTR(DB_EDIP_NRO,1,INSTR(DB_EDIP_NRO, '-', 1, 1) - 1))
       )as NUM_PEDIDO_VAN,
       nvl(EDIP.db_edip_pedmerc, 0) as "Nº PEDIDO SISTEMA CAPTACAO",
       REPLACE(NVL((SELECT db_ped_nro_orig
                     FROM (SELECT *
                             FROM MERCANET_PRD.DB_PEDIDO
                           UNION ALL
                           SELECT * FROM MERCANET_HIST.DB_PEDIDO_HIST@DCH9)
                    WHERE DB_PED_NRO = EDIP.DB_EDIP_PEDMERC),
                   0),
               'CANCEL',
               0) AS "Nº PEDIDO NO FATURAMENTO",
       EDIP.db_edip_comprador as "CNPJ DO CLIENTE",
       nvl((select db_tbemp_nome
             from MERCANET_PRD.DB_TB_EMPRESA
            where db_tbemp_cnpj = EDIP.db_edip_cliente),
           'S/ Filial - Pedido cancelado') as "FILIAL DROGACENTER",
       NVL((SELECT CASE
                    WHEN DB_PED_SITCORP = 0 THEN
                     /*DB_PED_SITCORP ||
                     ' - */'FATURADO'
                    ELSE
                     CASE
                       WHEN DB_PED_SITCORP = 1 THEN
                        /*DB_PED_SITCORP || ' -*/ 'BLOQUEADO VALOR MINIMO'
                       ELSE
                        CASE
                          WHEN DB_PED_SITCORP = 2 THEN
                           /*DB_PED_SITCORP || ' -*/ 'BLOQUEADO LIMITE DE CREDITO'
                          ELSE
                           CASE
                             WHEN DB_PED_SITCORP = 3 THEN
                              /*DB_PED_SITCORP || ' - */'FATURADO PARCIAL'
                             ELSE
                              CASE
                                WHEN DB_PED_SITCORP = 5 THEN
                                 /*DB_PED_SITCORP || ' -*/ 'CANCEL BLOQ DO CLIENTE'
                                ELSE
                                 CASE
                                   WHEN (SELECT COUNT(1)
                                           FROM (SELECT *
                                                   FROM MERCANET_PRD.DB_PEDIDO_DISTR
                                                 UNION ALL
                                                 SELECT *
                                                   FROM MERCANET_HIST.DB_PEDIDO_DISTR_HIST@DCH9)
                                          WHERE DB_PEDT_PEDIDO = DB_PED_NRO
                                            AND DB_PEDT_DTDISP IS NOT NULL) = 0 THEN
                                    'EM PROCESSAMENTO'
                                   ELSE
                                    /*DB_PED_SITCORP || ' -*/'CANCELADO'
                                 END
                              END
                           END
                        END
                     END
                  END
             FROM (SELECT *
                     FROM MERCANET_PRD.DB_PEDIDO
                   UNION ALL
                   SELECT * FROM MERCANET_HIST.DB_PEDIDO_HIST@DCH9)
            WHERE DB_PED_NRO = EDIP.DB_EDIP_PEDMERC),
           'NÃO ATENDIDO') "SITUACAO DO PEDIDO",
       ----
       CASE
         WHEN 'R' =
              UPPER('&"' S '- Ver Situação do Ped no JDE (mais lento) ou ' R
                    ' - Reenviar Arqs de Retorno"') THEN
          'Não consultado'
         ELSE
          NVL((CASE
                WHEN EDIP.DB_EDIP_VAN = 529 THEN
                 'COTACAO'
                ELSE
                 CASE
                   WHEN nvl(EDIP.db_edip_pedmerc, 0) > 0 AND
                        (SELECT COUNT(1)
                           FROM (SELECT *
                                   FROM MERCANET_PRD.DB_PEDIDO_DISTR
                                 UNION ALL
                                 SELECT * FROM MERCANET_HIST.DB_PEDIDO_DISTR_HIST@DCH9)
                          WHERE DB_PEDT_PEDIDO = EDIP.DB_EDIP_PEDMERC
                            AND DB_PEDT_DTDISP IS NOT NULL) = 0 THEN
                    'EM PROCESSAMENTO'
                   ELSE
                    CASE
                      WHEN (SELECT COUNT(1)
                              FROM PRODDTA.F4211@DC01,
                                   (SELECT *
                                      FROM MERCANET_PRD.DB_PEDIDO
                                    UNION ALL
                                    SELECT * FROM MERCANET_HIST.DB_PEDIDO_HIST@DCH9)
                             WHERE DB_PED_NRO = EDIP.DB_EDIP_PEDMERC
                               AND TO_NUMBER(TRANSLATE(NVL(DB_PED_NRO_ORIG, 0),
                                                       'CANCEL',
                                                       0)) = SDDOCO
                               AND SDLTTR < = '620'
                             GROUP BY SDDOCO) > 0 THEN
                       (SELECT CASE
                                 WHEN MAX(SDLTTR) = '620' THEN
                                  'FATURAMENTO CONCLUIDO'
                                 ELSE
                                  CASE
                                    WHEN MAX(SDLTTR) >= '535' AND MAX(SDLTTR) < '620' AND
                                         NOT EXISTS
                                     (SELECT *
                                            FROM MERCANET_PRD.DB_NOTA_FISCAL
                                           WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                     'PEDIDO EM PROCESSO DE FATURAMENTO'
                                    ELSE
                                     CASE
                                       WHEN MAX(SDLTTR) >= '599' AND MAX(SDLTTR) <= '620' AND
                                            EXISTS
                                        (SELECT *
                                               FROM MERCANET_PRD.DB_NOTA_FISCAL
                                              WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                        'FATURAMENTO CONCLUIDO'
                                       ELSE
                                        'PEDIDO NÃO ATENDIDO'
                                     END
                                  END
                               END
                          FROM PRODDTA.F4211@DC01,
                               (SELECT *
                                  FROM MERCANET_PRD.DB_PEDIDO
                                UNION ALL
                                SELECT * FROM MERCANET_HIST.DB_PEDIDO_HIST@DCH9)
                         WHERE DB_PED_NRO = EDIP.DB_EDIP_PEDMERC
                           AND TO_NUMBER(TRANSLATE(NVL(DB_PED_NRO_ORIG, 0), 'CANCEL', 0)) =
                               SDDOCO
                           AND SDLTTR < = '620'
                         GROUP BY SDDOCO)
                      ELSE
                       (SELECT CASE
                                 WHEN MAX(SDLTTR) = '620' THEN
                                  'FATURAMENTO CONCLUIDO'
                                 ELSE
                                  CASE
                                    WHEN MAX(SDLTTR) >= '535' AND MAX(SDLTTR) < '620' AND
                                         NOT EXISTS
                                     (SELECT *
                                            FROM MERCANET_PRD.DB_NOTA_FISCAL
                                           WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                     'PEDIDO EM PROCESSO DE FATURAMENTO'
                                    ELSE
                                     CASE
                                       WHEN MAX(SDLTTR) >= '599' AND MAX(SDLTTR) <= '620' AND
                                            EXISTS
                                        (SELECT *
                                               FROM MERCANET_PRD.DB_NOTA_FISCAL
                                              WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                        'FATURAMENTO CONCLUIDO'
                                       ELSE
                                        'PEDIDO NÃO ATENDIDO'
                                     END
                                  END
                               END
                          FROM PRODDTA.F42119@DC01,
                               (SELECT *
                                  FROM MERCANET_PRD.DB_PEDIDO
                                UNION ALL
                                SELECT * FROM MERCANET_HIST.DB_PEDIDO_HIST@DCH9)
                         WHERE DB_PED_NRO = EDIP.DB_EDIP_PEDMERC
                           AND TO_NUMBER(TRANSLATE(NVL(DB_PED_NRO_ORIG, 0), 'CANCEL', 0)) =
                               SDDOCO
                           AND SDLTTR < = '620'
                         GROUP BY SDDOCO)
                    END
                 END
              END),
              'PEDIDO NÃO ATENDIDO')
       END AS "STATUS DO FATURAMENTO",
       ----
       CASE
         WHEN EDIP.DB_EDIP_DTENVIO IS NULL THEN
          'Aguardando Geração Do Arquivo'
         ELSE
          'Arquivo Enviado Via Ftp'
       END AS "STATUS DE ENVIO DO RET PED",
       EDIP.DB_EDIP_DTENVIO AS "DATA ENVIO ARQ RET DO PEDIDO",
       NVL(REPLACE((SELECT DB_EDILE_ARQUIVO
                     FROM (SELECT *
                             FROM (SELECT DB_EDILE_ID,
                                          DB_EDILE_EDIP_COMP,
                                          DB_EDILE_EDIP_NRO,
                                          DB_EDILE_EDIA_CODI,
                                          DB_EDILE_PASTAGER,
                                          DB_EDILE_PASTABKP,
                                          DB_EDILE_ARQUIVO
                                     FROM MERCANET_PRD.DB_EDI_LOG_EXP
                                   UNION ALL
                                   SELECT DB_EDILE_ID,
                                          DB_EDILE_EDIP_COMP,
                                          DB_EDILE_EDIP_NRO,
                                          DB_EDILE_EDIA_CODI,
                                          DB_EDILE_PASTAGER,
                                          DB_EDILE_PASTABKP,
                                          DB_EDILE_ARQUIVO
                                     FROM MERCANET_PRD.DB_EDI_LOG_EXP_HIST
                                   UNION ALL
                                   SELECT DB_EDILE_ID,
                                          DB_EDILE_EDIP_COMP,
                                          DB_EDILE_EDIP_NRO,
                                          DB_EDILE_EDIA_CODI,
                                          DB_EDILE_PASTAGER,
                                          DB_EDILE_PASTABKP,
                                          DB_EDILE_ARQUIVO
                                     FROM MERCANET_HIST.DB_EDI_LOG_EXP_HIST@DCH9)
                            ORDER BY DB_EDILE_ID DESC)
                    WHERE EDIP.DB_EDIP_NRO = DB_EDILE_EDIP_NRO
                      AND EDIP.DB_EDIP_COMPRADOR = DB_EDILE_EDIP_COMP
                      AND DB_EDILE_EDIA_CODI =
                          (SELECT EM01_LARQRETPED
                             FROM MERCANET_PRD.MEM01
                            WHERE EM01_CODIGO = EDIP.DB_EDIP_VAN)
                      AND ROWNUM = 1),
                   '.TEMP',
                   NULL),
           'Arquivo não gerado') AS "NOMENCLATURA ARQ RET DO PEDIDO",
       ----------------          
       CASE
         WHEN 'R' =
              UPPER('&"' S '- Ver Situação do Ped no JDE (mais lento) ou ' R
                    ' - Reenviar Arqs de Retorno"') THEN
          'Não consultado'
         ELSE
          CASE
            WHEN NVL((CASE
                       WHEN EDIP.DB_EDIP_VAN = 529 THEN
                        'COTACAO'
                       ELSE
                        CASE
                          WHEN nvl(EDIP.db_edip_pedmerc, 0) > 0 AND
                               (SELECT COUNT(1)
                                  FROM (SELECT *
                                          FROM MERCANET_PRD.DB_PEDIDO_DISTR
                                        UNION ALL
                                        SELECT * FROM MERCANET_HIST.DB_PEDIDO_DISTR_HIST@DCH9)
                                 WHERE DB_PEDT_PEDIDO = EDIP.DB_EDIP_PEDMERC
                                   AND DB_PEDT_DTDISP IS NOT NULL) = 0 THEN
                           'EM PROCESSAMENTO'
                          ELSE
                           CASE
                             WHEN (SELECT COUNT(1)
                                     FROM PRODDTA.F4211@DC01,
                                          (SELECT *
                                             FROM MERCANET_PRD.DB_PEDIDO
                                           UNION ALL
                                           SELECT * FROM MERCANET_HIST.DB_PEDIDO_HIST@DCH9)
                                    WHERE DB_PED_NRO = EDIP.DB_EDIP_PEDMERC
                                      AND TO_NUMBER(TRANSLATE(NVL(DB_PED_NRO_ORIG, 0),
                                                              'CANCEL',
                                                              0)) = SDDOCO
                                      AND SDLTTR < = '620'
                                    GROUP BY SDDOCO) > 0 THEN
                              (SELECT CASE
                                        WHEN MAX(SDLTTR) = '620' THEN
                                         'FATURAMENTO CONCLUIDO'
                                        ELSE
                                         CASE
                                           WHEN MAX(SDLTTR) >= '535' AND MAX(SDLTTR) < '620' AND
                                                NOT EXISTS
                                            (SELECT *
                                                   FROM MERCANET_PRD.DB_NOTA_FISCAL
                                                  WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                            'PEDIDO EM PROCESSO DE FATURAMENTO'
                                           ELSE
                                            CASE
                                              WHEN MAX(SDLTTR) >= '599' AND MAX(SDLTTR) <= '620' AND
                                                   EXISTS
                                               (SELECT *
                                                      FROM MERCANET_PRD.DB_NOTA_FISCAL
                                                     WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                               'FATURAMENTO CONCLUIDO'
                                              ELSE
                                               'PEDIDO NÃO ATENDIDO'
                                            END
                                         END
                                      END
                                 FROM PRODDTA.F4211@DC01,
                                      (SELECT *
                                         FROM MERCANET_PRD.DB_PEDIDO
                                       UNION ALL
                                       SELECT * FROM MERCANET_HIST.DB_PEDIDO_HIST@DCH9)
                                WHERE DB_PED_NRO = EDIP.DB_EDIP_PEDMERC
                                  AND TO_NUMBER(TRANSLATE(NVL(DB_PED_NRO_ORIG, 0), 'CANCEL', 0)) =
                                      SDDOCO
                                  AND SDLTTR < = '620'
                                GROUP BY SDDOCO)
                             ELSE
                              (SELECT CASE
                                        WHEN MAX(SDLTTR) = '620' THEN
                                         'FATURAMENTO CONCLUIDO'
                                        ELSE
                                         CASE
                                           WHEN MAX(SDLTTR) >= '535' AND MAX(SDLTTR) < '620' AND
                                                NOT EXISTS
                                            (SELECT *
                                                   FROM MERCANET_PRD.DB_NOTA_FISCAL
                                                  WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                            'PEDIDO EM PROCESSO DE FATURAMENTO'
                                           ELSE
                                            CASE
                                              WHEN MAX(SDLTTR) >= '599' AND MAX(SDLTTR) <= '620' AND
                                                   EXISTS
                                               (SELECT *
                                                      FROM MERCANET_PRD.DB_NOTA_FISCAL
                                                     WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                               'FATURAMENTO CONCLUIDO'
                                              ELSE
                                               'PEDIDO NÃO ATENDIDO'
                                            END
                                         END
                                      END
                                 FROM PRODDTA.F42119@DC01,
                                      (SELECT *
                                         FROM MERCANET_PRD.DB_PEDIDO
                                       UNION ALL
                                       SELECT * FROM MERCANET_HIST.DB_PEDIDO_HIST@DCH9)
                                WHERE DB_PED_NRO = EDIP.DB_EDIP_PEDMERC
                                  AND TO_NUMBER(TRANSLATE(NVL(DB_PED_NRO_ORIG, 0), 'CANCEL', 0)) =
                                      SDDOCO
                                  AND SDLTTR < = '620'
                                GROUP BY SDDOCO)
                           END
                        END
                     END),
                     'PEDIDO NÃO ATENDIDO') IN
                 ('EM PROCESSAMENTO', 'PEDIDO EM PROCESSO DE FATURAMENTO') THEN
             'Nota Ainda Não Gerada - Pedido Em Faturamento'
            ELSE
             CASE
               WHEN NVL((CASE
                          WHEN EDIP.DB_EDIP_VAN = 529 THEN
                           'COTACAO'
                          ELSE
                           CASE
                             WHEN nvl(EDIP.db_edip_pedmerc, 0) > 0 AND
                                  (SELECT COUNT(1)
                                     FROM (SELECT *
                                             FROM MERCANET_PRD.DB_PEDIDO_DISTR
                                           UNION ALL
                                           SELECT * FROM MERCANET_HIST.DB_PEDIDO_DISTR_HIST@DCH9)
                                    WHERE DB_PEDT_PEDIDO = EDIP.DB_EDIP_PEDMERC
                                      AND DB_PEDT_DTDISP IS NOT NULL) = 0 THEN
                              'EM PROCESSAMENTO'
                             ELSE
                              CASE
                                WHEN (SELECT COUNT(1)
                                        FROM PRODDTA.F4211@DC01,
                                             (SELECT *
                                                FROM MERCANET_PRD.DB_PEDIDO
                                              UNION ALL
                                              SELECT * FROM MERCANET_HIST.DB_PEDIDO_HIST@DCH9)
                                       WHERE DB_PED_NRO = EDIP.DB_EDIP_PEDMERC
                                         AND TO_NUMBER(TRANSLATE(NVL(DB_PED_NRO_ORIG, 0),
                                                                 'CANCEL',
                                                                 0)) = SDDOCO
                                         AND SDLTTR < = '620'
                                       GROUP BY SDDOCO) > 0 THEN
                                 (SELECT CASE
                                           WHEN MAX(SDLTTR) = '620' THEN
                                            'FATURAMENTO CONCLUIDO'
                                           ELSE
                                            CASE
                                              WHEN MAX(SDLTTR) >= '535' AND MAX(SDLTTR) < '620' AND
                                                   NOT EXISTS
                                               (SELECT *
                                                      FROM MERCANET_PRD.DB_NOTA_FISCAL
                                                     WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                               'PEDIDO EM PROCESSO DE FATURAMENTO'
                                              ELSE
                                               CASE
                                                 WHEN MAX(SDLTTR) >= '599' AND MAX(SDLTTR) <= '620' AND
                                                      EXISTS
                                                  (SELECT *
                                                         FROM MERCANET_PRD.DB_NOTA_FISCAL
                                                        WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                                  'FATURAMENTO CONCLUIDO'
                                                 ELSE
                                                  'PEDIDO NÃO ATENDIDO'
                                               END
                                            END
                                         END
                                    FROM PRODDTA.F4211@DC01,
                                         (SELECT *
                                            FROM MERCANET_PRD.DB_PEDIDO
                                          UNION ALL
                                          SELECT * FROM MERCANET_HIST.DB_PEDIDO_HIST@DCH9)
                                   WHERE DB_PED_NRO = EDIP.DB_EDIP_PEDMERC
                                     AND TO_NUMBER(TRANSLATE(NVL(DB_PED_NRO_ORIG, 0), 'CANCEL', 0)) =
                                         SDDOCO
                                     AND SDLTTR < = '620'
                                   GROUP BY SDDOCO)
                                ELSE
                                 (SELECT CASE
                                           WHEN MAX(SDLTTR) = '620' THEN
                                            'FATURAMENTO CONCLUIDO'
                                           ELSE
                                            CASE
                                              WHEN MAX(SDLTTR) >= '535' AND MAX(SDLTTR) < '620' AND
                                                   NOT EXISTS
                                               (SELECT *
                                                      FROM MERCANET_PRD.DB_NOTA_FISCAL
                                                     WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                               'PEDIDO EM PROCESSO DE FATURAMENTO'
                                              ELSE
                                               CASE
                                                 WHEN MAX(SDLTTR) >= '599' AND MAX(SDLTTR) <= '620' AND
                                                      EXISTS
                                                  (SELECT *
                                                         FROM MERCANET_PRD.DB_NOTA_FISCAL
                                                        WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                                  'FATURAMENTO CONCLUIDO'
                                                 ELSE
                                                  'PEDIDO NÃO ATENDIDO'
                                               END
                                            END
                                         END
                                    FROM PRODDTA.F42119@DC01,
                                         (SELECT *
                                            FROM MERCANET_PRD.DB_PEDIDO
                                          UNION ALL
                                          SELECT * FROM MERCANET_HIST.DB_PEDIDO_HIST@DCH9)
                                   WHERE DB_PED_NRO = EDIP.DB_EDIP_PEDMERC
                                     AND TO_NUMBER(TRANSLATE(NVL(DB_PED_NRO_ORIG, 0), 'CANCEL', 0)) =
                                         SDDOCO
                                     AND SDLTTR < = '620'
                                   GROUP BY SDDOCO)
                              END
                           END
                        END),
                        'PEDIDO NÃO ATENDIDO') = 'FATURAMENTO CONCLUIDO' AND
                    (SELECT MAX(DB_NOTA_DT_ENVIO)
                       FROM MERCANET_PRD.DB_NOTA_FISCAL
                      WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC
                        AND ROWNUM = 1) = NULL THEN
                'Faturamento Concluido - Nota Será Gerada'
               ELSE
                CASE
                  WHEN NVL((CASE
                             WHEN EDIP.DB_EDIP_VAN = 529 THEN
                              'COTACAO'
                             ELSE
                              CASE
                                WHEN nvl(EDIP.db_edip_pedmerc, 0) > 0 AND
                                     (SELECT COUNT(1)
                                        FROM (SELECT *
                                                FROM MERCANET_PRD.DB_PEDIDO_DISTR
                                              UNION ALL
                                              SELECT * FROM MERCANET_HIST.DB_PEDIDO_DISTR_HIST@DCH9)
                                       WHERE DB_PEDT_PEDIDO = EDIP.DB_EDIP_PEDMERC
                                         AND DB_PEDT_DTDISP IS NOT NULL) = 0 THEN
                                 'EM PROCESSAMENTO'
                                ELSE
                                 CASE
                                   WHEN (SELECT COUNT(1)
                                           FROM PRODDTA.F4211@DC01,
                                                (SELECT *
                                                   FROM MERCANET_PRD.DB_PEDIDO
                                                 UNION ALL
                                                 SELECT * FROM MERCANET_HIST.DB_PEDIDO_HIST@DCH9)
                                          WHERE DB_PED_NRO = EDIP.DB_EDIP_PEDMERC
                                            AND TO_NUMBER(TRANSLATE(NVL(DB_PED_NRO_ORIG, 0),
                                                                    'CANCEL',
                                                                    0)) = SDDOCO
                                            AND SDLTTR < = '620'
                                          GROUP BY SDDOCO) > 0 THEN
                                    (SELECT CASE
                                              WHEN MAX(SDLTTR) = '620' THEN
                                               'FATURAMENTO CONCLUIDO'
                                              ELSE
                                               CASE
                                                 WHEN MAX(SDLTTR) >= '535' AND MAX(SDLTTR) < '620' AND
                                                      NOT EXISTS
                                                  (SELECT *
                                                         FROM MERCANET_PRD.DB_NOTA_FISCAL
                                                        WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                                  'PEDIDO EM PROCESSO DE FATURAMENTO'
                                                 ELSE
                                                  CASE
                                                    WHEN MAX(SDLTTR) >= '599' AND MAX(SDLTTR) <= '620' AND
                                                         EXISTS
                                                     (SELECT *
                                                            FROM MERCANET_PRD.DB_NOTA_FISCAL
                                                           WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                                     'FATURAMENTO CONCLUIDO'
                                                    ELSE
                                                     'PEDIDO NÃO ATENDIDO'
                                                  END
                                               END
                                            END
                                       FROM PRODDTA.F4211@DC01,
                                            (SELECT *
                                               FROM MERCANET_PRD.DB_PEDIDO
                                             UNION ALL
                                             SELECT * FROM MERCANET_HIST.DB_PEDIDO_HIST@DCH9)
                                      WHERE DB_PED_NRO = EDIP.DB_EDIP_PEDMERC
                                        AND TO_NUMBER(TRANSLATE(NVL(DB_PED_NRO_ORIG, 0), 'CANCEL', 0)) =
                                            SDDOCO
                                        AND SDLTTR < = '620'
                                      GROUP BY SDDOCO)
                                   ELSE
                                    (SELECT CASE
                                              WHEN MAX(SDLTTR) = '620' THEN
                                               'FATURAMENTO CONCLUIDO'
                                              ELSE
                                               CASE
                                                 WHEN MAX(SDLTTR) >= '535' AND MAX(SDLTTR) < '620' AND
                                                      NOT EXISTS
                                                  (SELECT *
                                                         FROM MERCANET_PRD.DB_NOTA_FISCAL
                                                        WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                                  'PEDIDO EM PROCESSO DE FATURAMENTO'
                                                 ELSE
                                                  CASE
                                                    WHEN MAX(SDLTTR) >= '599' AND MAX(SDLTTR) <= '620' AND
                                                         EXISTS
                                                     (SELECT *
                                                            FROM MERCANET_PRD.DB_NOTA_FISCAL
                                                           WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC) THEN
                                                     'FATURAMENTO CONCLUIDO'
                                                    ELSE
                                                     'PEDIDO NÃO ATENDIDO'
                                                  END
                                               END
                                            END
                                       FROM PRODDTA.F42119@DC01,
                                            (SELECT *
                                               FROM MERCANET_PRD.DB_PEDIDO
                                             UNION ALL
                                             SELECT * FROM MERCANET_HIST.DB_PEDIDO_HIST@DCH9)
                                      WHERE DB_PED_NRO = EDIP.DB_EDIP_PEDMERC
                                        AND TO_NUMBER(TRANSLATE(NVL(DB_PED_NRO_ORIG, 0), 'CANCEL', 0)) =
                                            SDDOCO
                                        AND SDLTTR < = '620'
                                      GROUP BY SDDOCO)
                                 END
                              END
                           END),
                           'PEDIDO NÃO ATENDIDO') = 'FATURAMENTO CONCLUIDO' AND
                       (SELECT MAX(DB_NOTA_DT_ENVIO)
                          FROM MERCANET_PRD.DB_NOTA_FISCAL
                         WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC
                           AND ROWNUM = 1) IS NOT NULL THEN
                   'Faturamento Concluido - Nota Enviada Via Ftp'
                  ELSE
                   'Pedido Não Atendido - Nota Não Será Gerada'
                END
             END
          END
       END "STATUS DE ENVIO DO RET NOTA",
       
       ------------------- 
       NVL((SELECT MAX(DB_NOTA_NRO)
             FROM MERCANET_PRD.DB_NOTA_FISCAL
            WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC
              AND ROWNUM = 1),
           NULL) AS "NUMERO DA NOTA",
       
       NVL((SELECT MAX(DB_NOTA_DT_ENVIO)
             FROM MERCANET_PRD.DB_NOTA_FISCAL
            WHERE DB_NOTA_PED_MERC = EDIP.DB_EDIP_PEDMERC
              AND ROWNUM = 1),
           NULL) AS "DATA ENVIO ARQ RET DA NOTA",
       
       NVL(REPLACE((SELECT DB_EDILE_ARQUIVO
                     FROM (SELECT *
                             FROM (SELECT DB_EDILE_ID,
                                          DB_EDILE_EDIP_COMP,
                                          DB_EDILE_EDIP_NRO,
                                          DB_EDILE_EDIA_CODI,
                                          DB_EDILE_PASTAGER,
                                          DB_EDILE_PASTABKP,
                                          DB_EDILE_ARQUIVO
                                     FROM MERCANET_PRD.DB_EDI_LOG_EXP
                                   UNION ALL
                                   SELECT DB_EDILE_ID,
                                          DB_EDILE_EDIP_COMP,
                                          DB_EDILE_EDIP_NRO,
                                          DB_EDILE_EDIA_CODI,
                                          DB_EDILE_PASTAGER,
                                          DB_EDILE_PASTABKP,
                                          DB_EDILE_ARQUIVO
                                     FROM MERCANET_PRD.DB_EDI_LOG_EXP_HIST
                                   UNION ALL
                                   SELECT DB_EDILE_ID,
                                          DB_EDILE_EDIP_COMP,
                                          DB_EDILE_EDIP_NRO,
                                          DB_EDILE_EDIA_CODI,
                                          DB_EDILE_PASTAGER,
                                          DB_EDILE_PASTABKP,
                                          DB_EDILE_ARQUIVO
                                     FROM MERCANET_HIST.DB_EDI_LOG_EXP_HIST@DCH9)
                            ORDER BY DB_EDILE_ID DESC)
                    WHERE EDIP.DB_EDIP_NRO = DB_EDILE_EDIP_NRO
                      AND EDIP.DB_EDIP_COMPRADOR = DB_EDILE_EDIP_COMP
                      AND DB_EDILE_EDIA_CODI =
                          (SELECT EM01_LARQNF
                             FROM MERCANET_PRD.MEM01
                            WHERE EM01_CODIGO = EDIP.DB_EDIP_VAN)
                      AND ROWNUM = 1),
                   '.TEMP',
                   NULL),
           ' ') AS "NOMENCLATURA ARQ RET DA NOTA",
       CASE WHEN EDIP.DB_EDIP_DTENVIOC IS NOT NULL THEN 'Arquivo Enviado Via Ftp' ELSE NULL END AS "STATUS DE ENVIO DO RET CANC",
       EDIP.DB_EDIP_DTENVIOC AS "DATA DE ENVIO ARQ CANCELAMENTO",
       NVL(REPLACE((SELECT DB_EDILE_ARQUIVO
                     FROM (SELECT *
                             FROM (SELECT DB_EDILE_ID,
                                          DB_EDILE_EDIP_COMP,
                                          DB_EDILE_EDIP_NRO,
                                          DB_EDILE_EDIA_CODI,
                                          DB_EDILE_PASTAGER,
                                          DB_EDILE_PASTABKP,
                                          DB_EDILE_ARQUIVO
                                     FROM MERCANET_PRD.DB_EDI_LOG_EXP
                                   UNION ALL
                                   SELECT DB_EDILE_ID,
                                          DB_EDILE_EDIP_COMP,
                                          DB_EDILE_EDIP_NRO,
                                          DB_EDILE_EDIA_CODI,
                                          DB_EDILE_PASTAGER,
                                          DB_EDILE_PASTABKP,
                                          DB_EDILE_ARQUIVO
                                     FROM MERCANET_PRD.DB_EDI_LOG_EXP_HIST
                                   UNION ALL
                                   SELECT DB_EDILE_ID,
                                          DB_EDILE_EDIP_COMP,
                                          DB_EDILE_EDIP_NRO,
                                          DB_EDILE_EDIA_CODI,
                                          DB_EDILE_PASTAGER,
                                          DB_EDILE_PASTABKP,
                                          DB_EDILE_ARQUIVO
                                     FROM MERCANET_HIST.DB_EDI_LOG_EXP_HIST@DCH9)
                            ORDER BY DB_EDILE_ID DESC)
                    WHERE EDIP.DB_EDIP_NRO = DB_EDILE_EDIP_NRO
                      AND EDIP.DB_EDIP_COMPRADOR = DB_EDILE_EDIP_COMP
                      AND DB_EDILE_EDIA_CODI =
                          (SELECT EM01_LARQRETPEDCANC
                             FROM MERCANET_PRD.MEM01
                            WHERE EM01_CODIGO = EDIP.DB_EDIP_VAN)
                      AND ROWNUM = 1),
                   '.TEMP',
                   NULL),
           ' ') AS "NOMENCLATURA ARQ RET CANC",
       ' ' AS "SEPARADOR",
       ' ' AS "SEPARADOR",
       ' ' AS "SEPARADOR",
       (SELECT 'COPY /Y ' || REPLACE(UPPER(EM01_PASTABKP),
                                     'D:',
                                     CASE
                                       WHEN DB_EDILD_DISTR IN
                                            (501, 502, 503, 504, 505, 508, 513, 521, 517, 514,518) THEN
                                        '\\srvdc43'
                                       ELSE
                                        '\\srvdc40'
                                     END) || '\' || DB_EDILE_ARQUIVO || ' ' ||
               REPLACE(UPPER(EM01.EM01_PASTAGER),
                       'D:',
                       CASE
                         WHEN DB_EDILD_DISTR IN
                              (501, 502, 503, 504, 505, 508, 513, 521, 517, 514,518) THEN
                          '\\srvdc43'
                         ELSE
                          '\\srvdc40'
                       END) || ';'
          FROM (SELECT *
                  FROM (SELECT DB_EDILE_ID,
                               DB_EDILE_EDIP_COMP,
                               DB_EDILE_EDIP_NRO,
                               DB_EDILE_EDIA_CODI,
                               DB_EDILE_PASTAGER,
                               DB_EDILE_PASTABKP,
                               DB_EDILE_ARQUIVO
                          FROM MERCANET_PRD.DB_EDI_LOG_EXP
                        UNION ALL
                        SELECT DB_EDILE_ID,
                               DB_EDILE_EDIP_COMP,
                               DB_EDILE_EDIP_NRO,
                               DB_EDILE_EDIA_CODI,
                               DB_EDILE_PASTAGER,
                               DB_EDILE_PASTABKP,
                               DB_EDILE_ARQUIVO
                          FROM MERCANET_PRD.DB_EDI_LOG_EXP_HIST
                        UNION ALL
                        SELECT DB_EDILE_ID,
                               DB_EDILE_EDIP_COMP,
                               DB_EDILE_EDIP_NRO,
                               DB_EDILE_EDIA_CODI,
                               DB_EDILE_PASTAGER,
                               DB_EDILE_PASTABKP,
                               DB_EDILE_ARQUIVO
                          FROM MERCANET_HIST.DB_EDI_LOG_EXP_HIST@DCH9)
                 ORDER BY DB_EDILE_ID DESC)
         WHERE EDIP.DB_EDIP_NRO = DB_EDILE_EDIP_NRO
           AND EDIP.DB_EDIP_COMPRADOR = DB_EDILE_EDIP_COMP
           AND DB_EDILE_EDIA_CODI =
               (SELECT EM01_LARQRETPED
                  FROM MERCANET_PRD.MEM01
                 WHERE EM01_CODIGO = EDIP.DB_EDIP_VAN)
           AND ROWNUM = 1) AS "COMANDO P/ REENVIO RET PEDIDO",
       (SELECT 'COPY /Y ' || REPLACE(UPPER(EM01.EM01_PASTABKP),
                                     'D:',
                                     CASE
                                       WHEN EDILD.DB_EDILD_DISTR IN
                                            (501, 502, 503, 504, 505, 508, 513, 521, 517, 514,518) THEN
                                        '\\srvdc43'
                                       ELSE
                                        '\\srvdc40'
                                     END) || '\' || DB_EDILE_ARQUIVO || ' ' ||
               REPLACE(UPPER(EM01.EM01_PASTAGER),
                       'D:',
                       CASE
                         WHEN EDILD.DB_EDILD_DISTR IN
                              (501, 502, 503, 504, 505, 508, 513, 521, 517, 514,518) THEN
                          '\\srvdc43'
                         ELSE
                          '\\srvdc40'
                       END) || ';'
          FROM (SELECT *
                  FROM (SELECT *
                          FROM MERCANET_PRD.DB_EDI_LOG_EXP
                        UNION ALL
                        SELECT * FROM MERCANET_PRD.DB_EDI_LOG_EXP_HIST)
                 ORDER BY DB_EDILE_ID DESC)
         WHERE EDIP.DB_EDIP_NRO = DB_EDILE_EDIP_NRO
           AND EDIP.DB_EDIP_COMPRADOR = DB_EDILE_EDIP_COMP
           AND DB_EDILE_EDIA_CODI =
               (SELECT EM01_LARQNF
                  FROM MERCANET_PRD.MEM01
                 WHERE EM01_CODIGO = EDIP.DB_EDIP_VAN)
           AND ROWNUM = 1) AS "COMANDO P/ REENVIO RET NOTA",
       (SELECT 'COPY /Y ' || REPLACE(UPPER(EM01.EM01_PASTABKP),
                                     'D:',
                                     CASE
                                       WHEN EDILD.DB_EDILD_DISTR IN
                                            (501, 502, 503, 504, 505, 508, 513, 521, 517, 514,518) THEN
                                        '\\srvdc43'
                                       ELSE
                                        '\\srvdc40'
                                     END) || '\' || DB_EDILE_ARQUIVO || ' ' ||
               REPLACE(UPPER(EM01.EM01_PASTAGER),
                       'D:',
                       CASE
                         WHEN EDILD.DB_EDILD_DISTR IN
                              (501, 502, 503, 504, 505, 508, 513, 521, 517, 514, 518) THEN
                          '\\srvdc43'
                         ELSE
                          '\\srvdc40'
                       END) || ';'
          FROM (SELECT *
                  FROM (SELECT DB_EDILE_ID,
                               DB_EDILE_EDIP_COMP,
                               DB_EDILE_EDIP_NRO,
                               DB_EDILE_EDIA_CODI,
                               DB_EDILE_PASTAGER,
                               DB_EDILE_PASTABKP,
                               DB_EDILE_ARQUIVO
                          FROM MERCANET_PRD.DB_EDI_LOG_EXP
                        UNION ALL
                        SELECT DB_EDILE_ID,
                               DB_EDILE_EDIP_COMP,
                               DB_EDILE_EDIP_NRO,
                               DB_EDILE_EDIA_CODI,
                               DB_EDILE_PASTAGER,
                               DB_EDILE_PASTABKP,
                               DB_EDILE_ARQUIVO
                          FROM MERCANET_PRD.DB_EDI_LOG_EXP_HIST
                        UNION ALL
                        SELECT DB_EDILE_ID,
                               DB_EDILE_EDIP_COMP,
                               DB_EDILE_EDIP_NRO,
                               DB_EDILE_EDIA_CODI,
                               DB_EDILE_PASTAGER,
                               DB_EDILE_PASTABKP,
                               DB_EDILE_ARQUIVO
                          FROM MERCANET_HIST.DB_EDI_LOG_EXP_HIST@DCH9)
                 ORDER BY DB_EDILE_ID DESC)
         WHERE EDIP.DB_EDIP_NRO = DB_EDILE_EDIP_NRO
           AND EDIP.DB_EDIP_COMPRADOR = DB_EDILE_EDIP_COMP
           AND DB_EDILE_EDIA_CODI =
               (SELECT EM01_LARQRETPEDCANC
                  FROM MERCANET_PRD.MEM01
                 WHERE EM01_CODIGO = EDIP.DB_EDIP_VAN)
           AND ROWNUM = 1) AS "COMANDO P/ REENVIO RET CANC"
  FROM (SELECT *
          FROM (SELECT DB_EDILD_SEQ,
                       DB_EDILD_DISTR,
                       DB_EDILD_TIPO,
                       DB_EDILD_DATA,
                       DB_EDILD_USUARIO,
                       DB_EDILD_SITUACAO,
                       DB_EDILD_DATA_CONS,
                       DB_EDILD_LAYOUT,
                       DB_EDILD_NOMEARQ
                  FROM MERCANET_HIST.DB_EDI_LOTE_DISTR_HIST@DCH9
                UNION ALL
                SELECT DB_EDILD_SEQ,
                       DB_EDILD_DISTR,
                       DB_EDILD_TIPO,
                       DB_EDILD_DATA,
                       DB_EDILD_USUARIO,
                       DB_EDILD_SITUACAO,
                       DB_EDILD_DATA_CONS,
                       DB_EDILD_LAYOUT,
                       DB_EDILD_NOMEARQ
                  FROM MERCANET_PRD.DB_EDI_LOTE_DISTR)) EDILD,
       (SELECT *
          FROM (SELECT *
                  FROM MERCANET_HIST.DB_EDI_PEDIDO_HIST@DCH9
                UNION ALL
                SELECT * FROM MERCANET_PRD.DB_EDI_PEDIDO)) EDIP,
       MERCANET_PRD.MEM01 EM01
 WHERE EDILD.DB_EDILD_SEQ = EDIP.DB_EDIP_LOTE
    AND EDIP.DB_EDIP_VAN = EM01.EM01_CODIGO
    -- AND EDIP.DB_EDIP_VAN = 508
    -- AND EDIP.DB_EDIP_COMPRADOR IN ('')
     --AND EDIP.DB_EDIP_CLIENTE IN('05651966001265')
   AND (
        LTRIM(SUBSTR(EDIP.DB_EDIP_NRO,1,INSTR(EDIP.DB_EDIP_NRO, '-', 1, 1) - 1),'0') 
        IN ('') --FILTRAR OS PEDIDOS DA VAN
       OR EDILD.DB_EDILD_NOMEARQ IN ('PEDPDV_05651966000455_00000004495185.TXT',
'PEDPDV_05651966000455_00000004496725.TXT',
'PEDPDV_05651966000455_00000004500530.TXT',
'PEDPDV_05651966000455_00000004500541.TXT',
'PEDPDV_05651966000455_00000004500554.TXT',
'PEDPDV_11323800000160_00000004501886.TXT',
'PEDPDV_05651966000455_00000004502218.TXT',
'PEDPDV_05651966000455_00000004502831.TXT',
'PEDPDV_05651966000455_00000004502839.TXT',
'PEDPDV_05651966000455_00000004503236.TXT',
'PEDPDV_05651966000455_00000004503240.TXT') --FILTRAR PELO NOME DOS ARQUIVOS
       OR EDIP.DB_EDIP_PEDMERC IN ('') --FILTRAR PELO PEDIDO MERCANET
       OR EDILD.DB_EDILD_SEQ IN ('') --FILTRAR PELO NUMERO DO LOTE MERCANET
       OR EDIP.DB_EDIP_OBS1 IN ('')
       OR EDIP.DB_EDIP_TXT1 IN ('')) --FILTRAR PELO NUMERO DO LOTE DA SEVEN PDV
 ORDER BY EDILD.DB_EDILD_DATA, EDIP.DB_EDIP_NRO;
 
 


