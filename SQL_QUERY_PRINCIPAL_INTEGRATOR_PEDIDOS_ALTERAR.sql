SELECT SDDOCO,
       SDDCTO,
       SDEMCU,
       SDMCU,
       SDITM,
       SDLITM,
       /*SDSO08, Rever qdo voltar brindes */
       SDUPRC,
       SDLPRC,
       SUM(SDAEXP) SDAEXP,
       SDUOM4,
       SDUOM,
       SUM(SDUORG) SDUORG,
       SUM(SDSOQS) SDSOQS,
       SUM(SDSOCN) SDSOCN,
       TO_DATE(SDPDDJ + 1900000, 'YYYYDDD'),
       Case --------------------------INICIO
         when sdprp5 = 'MED' and sdaexp > 0 then
          round((1 - ((sdaexp / 100 -
                case trim(sdemcu)
                  when 'DIFARARC' then
                   (round((select (aluprc / 10000) /
                                 (case sduom4
                                   when 'CX' then
                                    (select umconv / 10000000
                                       from proddta.f41002
                                      where trim(ummcu) = 'DIFARCAT'
                                        and sditm = umitm
                                        and sduom4 = umum
                                        and umrum = sduom)
                                   else
                                    1
                                 end)
                            from proddta.f4074
                           where sddoco = aldoco(+)
                             and sddcto = aldcto(+)
                             and sdlnid = allnid(+)
                             and alast(+) = 'V0000221'),
                          2) * sdsoqs)
                  when 'DIFARMA' then
                   (round((select (aluprc / 10000) /
                                 (case sduom4
                                   when 'CX' then
                                    (select umconv / 10000000
                                       from proddta.f41002
                                      where trim(ummcu) = 'DIFARCAT'
                                        and sditm = umitm
                                        and sduom4 = umum
                                        and umrum = sduom)
                                   else
                                    1
                                 end)
                            from proddta.f4074
                           where sddoco = aldoco(+)
                             and sddcto = aldcto(+)
                             and sdlnid = allnid(+)
                             and alast(+) = 'V0000225'),
                          2) * sdsoqs)
                  when 'DIFARCAMB' then
                   (case (select ibsrp8
                        from proddta.f4102
                       where trim(ibmcu) = 'DIFARCAT'
                         and iblitm = sdlitm)
                     when 'P' then
                      (round((select (aluprc / 10000) /
                                    (case sduom4
                                      when 'CX' then
                                       (select umconv / 10000000
                                          from proddta.f41002
                                         where trim(ummcu) = 'DIFARCAT'
                                           and sditm = umitm
                                           and sduom4 = umum
                                           and umrum = sduom)
                                      else
                                       1
                                    end)
                               from proddta.f4074
                              where sddoco = aldoco(+)
                                and sddcto = aldcto(+)
                                and sdlnid = allnid(+)
                                and alast(+) = 'V0000182'),
                             2) * sdsoqs)
                     when 'L' then
                      (round((select (aluprc / 10000) /
                                    (case sduom4
                                      when 'CX' then
                                       (select umconv / 10000000
                                          from proddta.f41002
                                         where trim(ummcu) = 'DIFARCAT'
                                           and sditm = umitm
                                           and sduom4 = umum
                                           and umrum = sduom)
                                      else
                                       1
                                    end)
                               from proddta.f4074
                              where sddoco = aldoco(+)
                                and sddcto = aldcto(+)
                                and sdlnid = allnid(+)
                                and alast(+) = 'V0000182'),
                             2) * sdsoqs)
                     when 'Y' then
                      (round((select (aluprc / 10000) /
                                    (case sduom4
                                      when 'CX' then
                                       (select umconv / 10000000
                                          from proddta.f41002
                                         where trim(ummcu) = 'DIFARCAT'
                                           and sditm = umitm
                                           and sduom4 = umum
                                           and umrum = sduom)
                                      else
                                       1
                                    end)
                               from proddta.f4074
                              where sddoco = aldoco(+)
                                and sddcto = aldcto(+)
                                and sdlnid = allnid(+)
                                and alast(+) = 'V0000182'),
                             2) * sdsoqs)
                     when 'Z' then
                      (round((select (aluprc / 10000) /
                                    (case sduom4
                                      when 'CX' then
                                       (select umconv / 10000000
                                          from proddta.f41002
                                         where trim(ummcu) = 'DIFARCAT'
                                           and sditm = umitm
                                           and sduom4 = umum
                                           and umrum = sduom)
                                      else
                                       1
                                    end)
                               from proddta.f4074
                              where sddoco = aldoco(+)
                                and sddcto = aldcto(+)
                                and sdlnid = allnid(+)
                                and alast(+) = 'V0000182'),
                             2) * sdsoqs)
                     else
                      0
                   end)
                  Else
                   0
                end) / (sdlprc / 10000 * sdsoqs))),
                2) * 100
         else
          0
       end PercDesc --------------- FIM
 FROM (SELECT * FROM PRODDTA.F4211 UNION SELECT * FROM PRODDTA.F42119)
 WHERE SDLNTY = 'BS'
   AND SDDOCO = &PEDIDO -- Buscar pelo numero do pedido que estiver exportado da F5542201 na  integração INTERFACE_DB_TB_PEDIDO
   AND SDDCTO != 'SQ'
 group by SDDOCO,
          SDDCTO,
          SDEMCU,
          SDMCU,
          SDITM,
          SDLITM,
          SDUPRC,
          SDLPRC,
          SDUOM4,
          SDUOM,
          SDPDDJ,
          sdprp5,--
          sdaexp,--
          sdlnid,--
          sdsoqs --
UNION
SELECT SDDOCO,
       SDDCTO,
       SDEMCU,
       SDMCU,
       SDITM,
       SDLITM,
       /*SDSO08, Rever qdo voltar brindes */
       SDUPRC,
       SDLPRC,
       SUM(SDAEXP) SDAEXP,
       SDUOM4,
       SDUOM,
       SUM(SDUORG) SDUORG,
       SUM(lipqoh - lihcom - lipcom) - ibsafe SDSOQS,
       0 SDSOCN,
       TO_DATE(SDPDDJ + 1900000, 'YYYYDDD'),
       case
         when sdprp5 = 'MED' and sdaexp > 0 then
          round((1 - ((sdaexp / 100 -
                case trim(sdemcu)
                  when 'DIFARARC' then
                   (round((select (aluprc / 10000) /
                                 (case sduom4
                                   when 'CX' then
                                    (select umconv / 10000000
                                       from proddta.f41002
                                      where trim(ummcu) = 'DIFARCAT'
                                        and sditm = umitm
                                        and sduom4 = umum
                                        and umrum = sduom)
                                   else
                                    1
                                 end)
                            from proddta.f4074
                           where sddoco = aldoco(+)
                             and sddcto = aldcto(+)
                             and sdlnid = allnid(+)
                             and alast(+) = 'V0000221'),
                          2) * sdsoqs)
                  when 'DIFARMA' then
                   (round((select (aluprc / 10000) /
                                 (case sduom4
                                   when 'CX' then
                                    (select umconv / 10000000
                                       from proddta.f41002
                                      where trim(ummcu) = 'DIFARCAT'
                                        and sditm = umitm
                                        and sduom4 = umum
                                        and umrum = sduom)
                                   else
                                    1
                                 end)
                            from proddta.f4074
                           where sddoco = aldoco(+)
                             and sddcto = aldcto(+)
                             and sdlnid = allnid(+)
                             and alast(+) = 'V0000225'),
                          2) * sdsoqs)
                  when 'DIFARCAMB' then
                   (case (select ibsrp8
                        from proddta.f4102
                       where trim(ibmcu) = 'DIFARCAT'
                         and iblitm = sdlitm)
                     when 'P' then
                      (round((select (aluprc / 10000) /
                                    (case sduom4
                                      when 'CX' then
                                       (select umconv / 10000000
                                          from proddta.f41002
                                         where trim(ummcu) = 'DIFARCAT'
                                           and sditm = umitm
                                           and sduom4 = umum
                                           and umrum = sduom)
                                      else
                                       1
                                    end)
                               from proddta.f4074
                              where sddoco = aldoco(+)
                                and sddcto = aldcto(+)
                                and sdlnid = allnid(+)
                                and alast(+) = 'V0000182'),
                             2) * sdsoqs)
                     when 'L' then
                      (round((select (aluprc / 10000) /
                                    (case sduom4
                                      when 'CX' then
                                       (select umconv / 10000000
                                          from proddta.f41002
                                         where trim(ummcu) = 'DIFARCAT'
                                           and sditm = umitm
                                           and sduom4 = umum
                                           and umrum = sduom)
                                      else
                                       1
                                    end)
                               from proddta.f4074
                              where sddoco = aldoco(+)
                                and sddcto = aldcto(+)
                                and sdlnid = allnid(+)
                                and alast(+) = 'V0000182'),
                             2) * sdsoqs)
                     when 'Y' then
                      (round((select (aluprc / 10000) /
                                    (case sduom4
                                      when 'CX' then
                                       (select umconv / 10000000
                                          from proddta.f41002
                                         where trim(ummcu) = 'DIFARCAT'
                                           and sditm = umitm
                                           and sduom4 = umum
                                           and umrum = sduom)
                                      else
                                       1
                                    end)
                               from proddta.f4074
                              where sddoco = aldoco(+)
                                and sddcto = aldcto(+)
                                and sdlnid = allnid(+)
                                and alast(+) = 'V0000182'),
                             2) * sdsoqs)
                     when 'Z' then
                      (round((select (aluprc / 10000) /
                                    (case sduom4
                                      when 'CX' then
                                       (select umconv / 10000000
                                          from proddta.f41002
                                         where trim(ummcu) = 'DIFARCAT'
                                           and sditm = umitm
                                           and sduom4 = umum
                                           and umrum = sduom)
                                      else
                                       1
                                    end)
                               from proddta.f4074
                              where sddoco = aldoco(+)
                                and sddcto = aldcto(+)
                                and sdlnid = allnid(+)
                                and alast(+) = 'V0000182'),
                             2) * sdsoqs)
                     else
                      0
                   end)
                  Else
                   0
                end) / (sdlprc / 10000 * sdsoqs))),
                2) * 100
         else
          0
       end PercDesc
  FROM (SELECT * FROM PRODDTA.F4211 UNION SELECT * FROM PRODDTA.F42119), proddta.f41021, proddta.f4102
 WHERE SDLNTY = 'BS'
   AND SDDCTO = 'SQ'
   AND SDDOCO = &PEDIDO
   and limcu = '    DIFARCAT'
   and limcu = ibmcu
   and ibitm = liitm
   and sditm = liitm
   and lilots = ' '
   and ibshcn != 'TMB'
 group by SDDOCO,
          SDDCTO,
          SDEMCU,
          SDMCU,
          SDITM,
          SDLITM,
          SDUPRC,
          SDLPRC,
          SDUOM4,
          SDUOM,
          SDPDDJ,
          IBSAFE,
          sdprp5,--
          sdaexp,--
          sdlnid,--
          sdsoqs --
union

SELECT SDDOCO,
       SDDCTO,
       SDEMCU,
       SDMCU,
       SDITM,
       SDLITM,
       /*SDSO08, Rever qdo voltar brindes */
       SDUPRC,
       SDLPRC,
       SUM(SDAEXP) SDAEXP,
       SDUOM4,
       SDUOM,
       SUM(SDUORG) SDUORG,
       SUM(lipqoh - lihcom - lipcom) - ibsafe SDSOQS,
       0 SDSOCN,
       TO_DATE(SDPDDJ + 1900000, 'YYYYDDD'),
       case
         when sdprp5 = 'MED' and sdaexp > 0 then
          round((1 - ((sdaexp / 100 -
                case trim(sdemcu)
                  when 'DIFARARC' then
                   (round((select (aluprc / 10000) /
                                 (case sduom4
                                   when 'CX' then
                                    (select umconv / 10000000
                                       from proddta.f41002
                                      where trim(ummcu) = 'DIFARCAT'
                                        and sditm = umitm
                                        and sduom4 = umum
                                        and umrum = sduom)
                                   else
                                    1
                                 end)
                            from proddta.f4074
                           where sddoco = aldoco(+)
                             and sddcto = aldcto(+)
                             and sdlnid = allnid(+)
                             and alast(+) = 'V0000221'),
                          2) * sdsoqs)
                  when 'DIFARMA' then
                   (round((select (aluprc / 10000) /
                                 (case sduom4
                                   when 'CX' then
                                    (select umconv / 10000000
                                       from proddta.f41002
                                      where trim(ummcu) = 'DIFARCAT'
                                        and sditm = umitm
                                        and sduom4 = umum
                                        and umrum = sduom)
                                   else
                                    1
                                 end)
                            from proddta.f4074
                           where sddoco = aldoco(+)
                             and sddcto = aldcto(+)
                             and sdlnid = allnid(+)
                             and alast(+) = 'V0000225'),
                          2) * sdsoqs)
                  when 'DIFARCAMB' then
                   (case (select ibsrp8
                        from proddta.f4102
                       where trim(ibmcu) = 'DIFARCAT'
                         and iblitm = sdlitm)
                     when 'P' then
                      (round((select (aluprc / 10000) /
                                    (case sduom4
                                      when 'CX' then
                                       (select umconv / 10000000
                                          from proddta.f41002
                                         where trim(ummcu) = 'DIFARCAT'
                                           and sditm = umitm
                                           and sduom4 = umum
                                           and umrum = sduom)
                                      else
                                       1
                                    end)
                               from proddta.f4074
                              where sddoco = aldoco(+)
                                and sddcto = aldcto(+)
                                and sdlnid = allnid(+)
                                and alast(+) = 'V0000182'),
                             2) * sdsoqs)
                     when 'L' then
                      (round((select (aluprc / 10000) /
                                    (case sduom4
                                      when 'CX' then
                                       (select umconv / 10000000
                                          from proddta.f41002
                                         where trim(ummcu) = 'DIFARCAT'
                                           and sditm = umitm
                                           and sduom4 = umum
                                           and umrum = sduom)
                                      else
                                       1
                                    end)
                               from proddta.f4074
                              where sddoco = aldoco(+)
                                and sddcto = aldcto(+)
                                and sdlnid = allnid(+)
                                and alast(+) = 'V0000182'),
                             2) * sdsoqs)
                     when 'Y' then
                      (round((select (aluprc / 10000) /
                                    (case sduom4
                                      when 'CX' then
                                       (select umconv / 10000000
                                          from proddta.f41002
                                         where trim(ummcu) = 'DIFARCAT'
                                           and sditm = umitm
                                           and sduom4 = umum
                                           and umrum = sduom)
                                      else
                                       1
                                    end)
                               from proddta.f4074
                              where sddoco = aldoco(+)
                                and sddcto = aldcto(+)
                                and sdlnid = allnid(+)
                                and alast(+) = 'V0000182'),
                             2) * sdsoqs)
                     when 'Z' then
                      (round((select (aluprc / 10000) /
                                    (case sduom4
                                      when 'CX' then
                                       (select umconv / 10000000
                                          from proddta.f41002
                                         where trim(ummcu) = 'DIFARCAT'
                                           and sditm = umitm
                                           and sduom4 = umum
                                           and umrum = sduom)
                                      else
                                       1
                                    end)
                               from proddta.f4074
                              where sddoco = aldoco(+)
                                and sddcto = aldcto(+)
                                and sdlnid = allnid(+)
                                and alast(+) = 'V0000182'),
                             2) * sdsoqs)
                     else
                      0
                   end)
                  Else
                   0
                end) / (sdlprc / 10000 * sdsoqs))),
                2) * 100
         else
          0
       end PercDesc

  FROM (SELECT * FROM PRODDTA.F4211 UNION SELECT * FROM PRODDTA.F42119), proddta.f41021, proddta.f4102
 WHERE SDLNTY = 'BS'
   AND SDDOCO = &PEDIDO
   AND SDDCTO = 'SQ'
   and limcu = '     DIFARMA'
   and limcu = ibmcu
   and ibitm = liitm
   and sditm = liitm
   and lilots = ' '
   and ibshcn = 'TMB'
 group by SDDOCO,
          SDDCTO,
          SDEMCU,
          SDMCU,
          SDITM,
          SDLITM,
          SDUPRC,
          SDLPRC,
          SDUOM4,
          SDUOM,
          SDPDDJ,
          IBSAFE,
          sdprp5,--
          sdaexp,--
          sdlnid,--
          sdsoqs --
          
