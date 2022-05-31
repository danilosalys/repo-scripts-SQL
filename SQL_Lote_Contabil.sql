
SELECT DISTINCT SDDOCO,
                SDDCTO,
                SDLTTR,
                SDNXTR,
                sdlnty,
                SDEMCU,
                abac16,
                sdzon,
                SHZON,
                sddoc,
                sddct,
                to_date(floor(sdivd / 1000) + 1900 || '0101', 'yyyymmdd') +
                MOD(sdivd, 1000) - 1 AS DATA_FATURA,
                To_date(floor(sdtrdj / 1000) + 1900 || '0101', 'yyyymmdd') +
                MOD(sdtrdj, 1000) - 1 AS DATA_PEDIDO,
                SDAN8,
                ABALPH,
                ABAC01,
                ABAC07,
                T3RMK,
                glicu LOTE_CONTABIL,
                glicut TIPO
  FROM qadta.F4211, qadta.F4201, qadta.F0101, qadta.F00092, qadta.f0911
WHERE SDDOCO = SHDOCO
   AND SDDCTO = SHDCTO
   and aban8 = sdan8
   and aban8 = shan8
   and sddoco IN
       (243308, 243338, 243587, 243617, 243634, 243655, 243722, 243774,
        243847, 243883, 243895, 244554, 244688, 244729, 244764, 244765,
        244766, 244846, 244890, 16532092, 16532098)
      -- AND SHHOLD = ' '
   and sdlttr NOT IN ('980', '982')
   --AND SDLNTY = 'CD'
   AND ABAN8 = T3SBN1(+)
   AND T3SDB(+) = 'CTE'
   AND T3TYDT(+) = 'EX'
   and glan8 = sdan8
   and gldoc = sddoc
   and gldct = sddct
--and sdnxtr > '604'
ORDER BY SDNXTR ASC;

