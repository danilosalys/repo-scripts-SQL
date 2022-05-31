select distinct ibvend,
                abalph,
                sadoco,
                saan8,
                samcu,
                saoorn,
                to_date(floor(saupmj / 1000) + 1900 || '0101', 'yyyymmdd') +
                MOD(saupmj, 1000) - 1
  from proddta.f5547011, proddta.f0101 a, proddta.f4102, proddta.f5547012
 where aban8 in
       (6391,8200, 6372)--laboratorios Pfizer 
   and saupmj between  111143 and 111147
   and ibvend = aban8
   and saukid = sbukid
   and iblitm = sblitm
   and ibmcu = '    DIFARCAT'
   and sadcto = 'OL'
   and sadoco > 0
   and saoorn = '50'
   and saan8 not in (select b.aban8
                       from proddta.f0101 b
                      where saan8 = b.aban8
                        and b.abac05 = 'DRO')
                        and saedbt != 'E'