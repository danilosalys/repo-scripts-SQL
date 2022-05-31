BEGIN
  FOR VANS IN (SELECT EM01_CODIGO, EM01_EAN,DECODE(EM01_CODIGO,
                 502,
                 'TRANSACAO_SANDOZ',
                 508,
                 'TRANSACAO_SP',
                 515,
                 'TRANSM',
                 516,
                 'TRANSACAO_ABBOTT',
                 'TRANSACAO') AS DIRETORIO
                 FROM MERCANET_PRD.MEM01
                ORDER BY EM01_CODIGO) LOOP
    dbms_output.put_line(VANS.EM01_CODIGO || '-' || VANS.EM01_EAN);
  
    FOR GERA_ARQ IN (SELECT GET_ARQUIVO_PEDIDO
                       FROM (SELECT DB_EDILD_DISTR,
                                    DB_EDIP_COMPRADOR, 
                                    NVL((SELECT CASE
                                                 WHEN DB_PED_SITCORP = 0 THEN
                                                 /*DB_PED_SITCORP ||
                                                 ' - */
                                                     'FATURADO'
                                                    ELSE
                                                     CASE
                                                       WHEN DB_PED_SITCORP = 1 THEN
                                                       /*DB_PED_SITCORP || ' -*/
                                                     'BLOQUEADO VALOR MINIMO'
                                                    ELSE
                                                     CASE
                                                       WHEN DB_PED_SITCORP = 2 THEN
                                                       /*DB_PED_SITCORP || ' -*/
                                                           'BLOQUEADO LIMITE DE CREDITO'
                                                          ELSE
                                                           CASE
                                                             WHEN DB_PED_SITCORP = 3 THEN
                                                             /*DB_PED_SITCORP || ' - */
                                                           'FATURADO PARCIAL'
                                                          ELSE
                                                           CASE
                                                             WHEN DB_PED_SITCORP = 5 THEN
                                                             /*DB_PED_SITCORP || ' -*/
                                                                 'CANCEL BLOQ DO CLIENTE'
                                                                ELSE
                                                                 CASE
                                                                   WHEN (SELECT COUNT(1)
                                                                           FROM (SELECT *
                                                                                   FROM MERCANET_PRD.DB_PEDIDO_DISTR
                                                                                 /*UNION ALL
                                                                                 SELECT *
                                                                                   FROM MERCANET_HIST.DB_PEDIDO_DISTR_HIST@DCH9*/)
                                                                          WHERE DB_PEDT_PEDIDO =
                                                                                DB_PED_NRO
                                                                            AND DB_PEDT_DTDISP IS NOT NULL) = 0 THEN
                                                                    'EM PROCESSAMENTO'
                                                                   ELSE
                                                                   /*DB_PED_SITCORP || ' -*/
                                                                 'CANCELADO'
                                                              END
                                                           END
                                                        END
                                                     END
                                                  END
                                               END
                                          FROM MERCANET_PRD.DB_PEDIDO
                                         WHERE DB_PED_NRO =
                                               EDIP.DB_EDIP_PEDMERC),
                                        'NÃO ATENDIDO') "SITUACAO DO PEDIDO",
                                    'COPY /Y ' || REPLACE(UPPER(EM01_PASTABKP),
                                                          'D:',
                                                          CASE
                                                            WHEN DB_EDILD_DISTR IN
                                                                 (501,
                                                                  502,
                                                                  503,
                                                                  504,
                                                                  505,
                                                                  508,
                                                                  513,
                                                                  521,
                                                                  517,
                                                                  514,
                                                                  518) THEN
                                                             '\\srvdc43'
                                                            ELSE
                                                             '\\srvdc40'
                                                          END) || '\' ||
                                    DB_EDILD_NOMEARQ || ' ' ||
                                    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(EM01_PASTABKP),
                                                                            'D:',
                                                                            '\\SRVDC39'),
                                                                    '\\SRVDC40',
                                                                    '\\SRVDC39'),
                                                            '\\SRVDC43',
                                                            '\\SRVDC39'),
                                                    'BACKUPS',
                                                    ''),
                                            'BKP',
                                            '') ||VANS.DIRETORIO|| ';' AS GET_ARQUIVO_PEDIDO
                               FROM MERCANET_PRD.DB_EDI_LOTE_DISTR EDILD,
                                    MERCANET_PRD.DB_EDI_PEDIDO     EDIP,
                                    MERCANET_PRD.MEM01             EM01
                              WHERE EDILD.DB_EDILD_SEQ = EDIP.DB_EDIP_LOTE
                                AND EDIP.DB_EDIP_VAN = EM01.EM01_CODIGO
                                AND EDILD.DB_EDILD_DISTR = VANS.EM01_CODIGO
                                AND EDILD.DB_EDILD_DATA > '01/01/2020' -- COLOCAR A DATA DOS ARQUIVOS
                                AND EDILD.DB_EDILD_DATA < '30/01/2020'
                                --AND EDILD.DB_EDILD_DISTR in (505, 540)
                                AND EXISTS (SELECT 1 FROM MERCANET_PRD.DB_PEDIDO 
                                             WHERE DB_PED_NRO = DB_EDIP_PEDMERC 
                                               AND DB_PED_SITUACAO NOT IN (9))
                                --AND EDIP.DB_EDIP_CLIENTE = '05651966000617'
                                --AND EDIP.DB_EDIP_CLIENTE = '05651966000966'
                                AND EXISTS (SELECT * 
                                      FROM MERCANET_QA.DB_CLIENTE@DC12 
                                     WHERE DB_CLI_CGCMF = DB_EDIP_COMPRADOR
                                       AND DB_CLI_SITUACAO = 0)
                                AND NOT EXISTS (SELECT * FROM MERCANET_QA.DB_EDI_LOTE_DISTR@DC12 a
                                                 WHERE EDILD.DB_EDILD_NOMEARQ = a.DB_EDILD_NOMEARQ)       
/*                                AND EXISTS (SELECT * FROM QADTA.F03012@DC10, QADTA.F0101@DC10
                                     WHERE TRIM(ABTAX) = DB_EDIP_COMPRADOR
                                       AND ABAN8 = AIAN8
                                       AND AIHOLD = ' ') */
                               /* AND EXISTS (SELECT DB_EDII_PEDMERC, COUNT(DISTINCT DB_PRODA_VALOR) 
                                              FROM MERCANET_PRD.DB_EDI_PEDPROD,
                                                   MERCANET_PRD.DB_PRODUTO_EMBAL,
                                                   MERCANET_PRD.DB_PRODUTO_ATRIB
                                             WHERE EDIP.DB_EDIP_COMPRADOR = DB_EDII_COMPRADOR
                                               AND EDIP.DB_EDIP_NRO = DB_EDII_NRO
                                               AND DB_EDII_PRODUTO = DB_PRDEMB_CODBARRA
                                               AND DB_PRDEMB_PRODUTO = DB_PRODA_CODIGO
                                               AND DB_PRODA_ATRIB = 2012
                                             GROUP BY DB_EDII_PEDMERC
                                             HAVING COUNT(DISTINCT DB_PRODA_VALOR) > 1) */                
                                     
                              ORDER BY EDILD.DB_EDILD_DATA DESC
                              )
                      WHERE ROWNUM <= 10 -- QUANTIDADE DE ARQUIVOS DESEJADO
                     ) LOOP
      dbms_output.put_line(GERA_ARQ.GET_ARQUIVO_PEDIDO);
    
    END LOOP;
    dbms_output.put_line('_____________');
  END LOOP;
END;















