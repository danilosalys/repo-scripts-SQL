SELECT EDIP.DB_EDIP_VAN,
       'COPY /Y ' || REPLACE(UPPER(EM01_PASTABKP),
                             'D:',
                             CASE
                               WHEN EDILD.DB_EDILD_DISTR IN
                                    (501, 502, 503, 504, 505, 508, 513, 521, 517, 514) THEN
                                '\\srvdc43'
                               ELSE
                                '\\srvdc40'
                             END) || '\' || EDILD.db_edild_nomearq || ' ' || CASE
         WHEN EDIP.DB_EDIP_VAN = 502 THEN
          '\\SRVDC39\MERCANET\EDI\OL\entire\transacao_sandoz'
         ELSE
          CASE
            WHEN EDIP.DB_EDIP_VAN = 503 THEN
             '\\SRVDC39\MERCANET\EDI\OL\prodoctor\transacao'
            ELSE
             CASE
               WHEN EDIP.DB_EDIP_VAN = 504 THEN
                '\\SRVDC39\MERCANET\EDI\OL\most\transacao'
               ELSE
                CASE
                  WHEN EDIP.DB_EDIP_VAN = 505 THEN
                   '\\SRVDC39\MERCANET\EDI\OL\entire\transacao'
                  ELSE
                   CASE
                     WHEN EDIP.DB_EDIP_VAN = 508 THEN
                      '\\SRVDC39\MERCANET\EDI\OL\sevenpdv\transacao_sp'
                     ELSE
                      CASE
                        WHEN EDIP.DB_EDIP_VAN = 509 THEN
                         '\\SRVDC39\MERCANET\EDI\OL\canonne\transacao'
                        ELSE
                         CASE
                           WHEN EDIP.DB_EDIP_VAN = 510 THEN
                            '\\SRVDC39\MERCANET\EDI\OL\vialivre\transacao'
                           ELSE
                            CASE
                              WHEN EDIP.DB_EDIP_VAN = 511 THEN
                               '\\SRVDC39\MERCANET\EDI\OL\epharma\transacao'
                              ELSE
                               CASE
                                 WHEN EDIP.DB_EDIP_VAN = 513 THEN
                                  '\\SRVDC39\MERCANET\EDI\OL\visao\transacao'
                                 ELSE
                                  CASE
                                    WHEN EDIP.DB_EDIP_VAN = 514 THEN
                                     '\\SRVDC39\MERCANET\EDI\OL\running\transacao'
                                    ELSE
                                     CASE
                                       WHEN EDIP.DB_EDIP_VAN = 515 THEN
                                        '\\SRVDC39\MERCANET\EDI\OL\vidalink\transm'
                                       ELSE
                                        CASE
                                          WHEN EDIP.DB_EDIP_VAN = 516 THEN
                                           '\\SRVDC39\MERCANET\EDI\OL\entire\transacao_abbott'
                                          ELSE
                                           CASE
                                             WHEN EDIP.DB_EDIP_VAN = 517 THEN
                                              '\\SRVDC39\MERCANET\EDI\OL\fidelize\transacao'
                                             ELSE
                                              CASE
                                                WHEN EDIP.DB_EDIP_VAN = 520 THEN
                                                 '\\SRVDC39\MERCANET\EDI\OL\mercanet\transacao'
                                                ELSE
                                                 CASE
                                                   WHEN EDIP.DB_EDIP_VAN = 521 THEN
                                                    '\\SRVDC39\MERCANET\EDI\OL\varejo\transacao'
                                                   ELSE
                                                    CASE
                                                      WHEN EDIP.DB_EDIP_VAN = 531 THEN
                                                       '\\SRVDC39\MERCANET\EDI\OL\nissei\transacao'
                                                      ELSE
                                                       CASE
                                                         WHEN EDIP.DB_EDIP_VAN = 540 THEN
                                                          '\\SRVDC39\MERCANET\EDI\OL\pharmalink_3_0\transacao'
                                                         ELSE
                                                          ' '
                                                       END
                                                    END
                                                 END
                                              END
                                           END
                                        END
                                     END
                                  END
                               END
                            END
                         END
                      END
                   END
                END
             END
          END
       END || ';' AS "COMANDO P/ OBTER ARQUIVO"
  FROM MERCANET_PRD.DB_EDI_LOTE_DISTR EDILD,
       MERCANET_PRD.DB_EDI_PEDIDO     EDIP,
       MERCANET_PRD.MEM01             EM01
 WHERE EDILD.DB_EDILD_SEQ = EDIP.DB_EDIP_LOTE
   AND EDIP.DB_EDIP_VAN = EM01.EM01_CODIGO
   AND EDILD.DB_EDILD_DATA BETWEEN '13/09/2017' AND '15/09/2017'
 ORDER BY EDILD.DB_EDILD_DATA, EDIP.DB_EDIP_NRO
