select db_edild_distr,CASE WHEN DB_EDILD_DISTR = 501 THEN 'COPY /Y Y:\pharmalink\backups\' ||  ELSE 
                       CASE WHEN DB_EDILD_DISTR = 504 THEN 'COPY /Y Y:\most\backups\' ELSE 
                        CASE WHEN DB_EDILD_DISTR = 505 THEN 'COPY /Y Y:\entire\backups\' ELSE 
                         CASE WHEN DB_EDILD_DISTR = 506 THEN 'COPY /Y X:\focopdv\backups\' ELSE 
                          CASE WHEN DB_EDILD_DISTR = 508 THEN 'COPY /Y Y:\sevenpdv\backups\' ELSE 
                           CASE WHEN DB_EDILD_DISTR = 509 THEN 'COPY /Y X:\canonne\backups\' ELSE 
                            CASE WHEN DB_EDILD_DISTR = 517 THEN 'COPY /Y X:\fidelize\backups\' ELSE 
                             CASE WHEN DB_EDILD_DISTR = 520 THEN 'COPY /Y X:\mercanet\backups\' ELSE 
                              CASE WHEN DB_EDILD_DISTR = 531 THEN 'COPY /Y X:\nissei\backups\'
                                END END END END END END END END END                                 
                                 || db_edild_nomearq || ' ' || 'C:\Users\danilo\Desktop\testes' || ';' AS "Arquivo de Pedido"
  from mercanet_prd.db_edi_lote_distr 
 where db_edild_data between to_date('07/10/2014 00:00:00','dd/mm/yyyy hh24:mi:ss')
                      and to_date('07/10/2014 23:59:00','dd/mm/yyyy hh24:mi:ss')
   and exists (select * from mercanet_prd.db_edi_pedido ,mercanet_prd.db_pedido 
                where db_edip_pedmerc = db_ped_nro
                 and db_edip_lote = db_edild_seq 
                 and db_edip_van not in (529,530)) 
order by db_edild_distr 
 
