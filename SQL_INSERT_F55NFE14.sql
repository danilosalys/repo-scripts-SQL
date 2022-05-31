INSERT INTO CRPDTA.F55NFE14
select ROWNUM AS NRUKID, TAB.* --sdemcu,sddcto,count(1)
  from (select distinct --ROWNUM AS NRUKID,
                        FDBNNF AS NRBNNF,
                        FDBSER AS NRBSER,
                        FDN001 AS NRN001,
                        SDDCTO AS NRDCT,
                        SDDOCO AS NRDOCO,
                        SDDCTO AS NRDCTO,
                        FDKCOO AS NRKCOO,
                        SDEMCU AS NRMCU,
                        SDZON AS NRZON,
                        SDDOC AS NRDOC,
                        FDFCO AS NRFCO,
                        100 AS NRRCD1,
                        '' AS NRRCD2,
                        '1' AS NRTDIS,
                        '' AS NRAA03,
                        '' AS NRAA10,
                        '' AS NREV01,
                        '' AS NRURCD,
                        '0' AS NRURDT,
                        '0' AS NRURAT,
                        '0' AS NRURAB,
                        '' AS NRURRF,
                        '' AS NRTORG,
                        '' AS NRUSER,
                        '' AS NRPID,
                        '' AS NRJOBN,
                        118138 AS NRUPMJ,
                        '' AS NRTDAY
        
          from crpdta.f5547011,
               crpdta.F4211,
               crpdta.f4201,
               crpdta.f7611b,
               crpdta.f5503004,
               crpdta.f55nfe03,
               crpdta.f55nfe02,
               crpdta.f55nfe01,
               crpdta.f5555net
         where sadoco = sddoco
              --and sdeuse not in ('CTC')
           and sddoco = shdoco
           and sddcto = shdcto
           and shhold = ' '
           and sdlttr < = '620'
           and sddoco = fddoco(+)
           and sdlnid = fdlnid(+)
           and sdlitm = fdlitm(+)
           and fdbnnf = xxbnnf(+)
           and fdbser = xxbser(+)
           and fdpdct = xxdcto(+)
           and fddoco = nedoco(+)
           and fdbnnf = nebnnf(+)
           and fdbser = nebser(+)
           and fdn001 = nen001(+)
           and fdbnnf = ntbnnf(+)
           and fdbser = ntbser(+)
           and fdn001 = ntn001(+)
           and fddoco = ntdoco(+)
           and fdbnnf = ncbnnf(+)
           and fdbser = ncbser(+)
           and fdn001 = ncn001(+)
           and ncseq = xmseq(+)
           and saupmj > = 118135
              /*and sddoco in
              ()*/
              -- and sddcto = 'VO'
           and sdnxtr = '599'
         group by sdoorn,
                  sddoco,
                  sdnxtr,
                  sdlttr,
                  sdeuse,
                  shhold,
                  sdzon,
                  sddcto,
                  sdemcu,
                  sdivd,
                  sdtrdj,
                  fdbnnf,
                  fdbser,
                  fdn001,
                  fdissu,
                  fdkcoo,
                  xxvod,
                  needsp,
                  sddoc,
                  fdfco,
                  ntnxtev1,
                  nercd1
         order by  sddoco, sddcto) TAB
--where R55NFE30 <> 'Enviado para Sefaz'
--group by sdemcu,sddcto
