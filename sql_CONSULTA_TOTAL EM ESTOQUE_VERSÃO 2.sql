SELECT IBLITM,
       (SUM(LIPQOH - (LIPCOM + LIHCOM))) - MAX(IBSAFE) DISPONIBILIDADE,
       ABALPH,
       IVCITM
  from QADTA.F0101,
       QADTA.F4101,
       QADTA.F4104,
       (SELECT * FROM (select *
          from QADTA.f4102, QADTA.f41021
         where trim(ibmcu) = 'DIFARCAT'
           and liitm = ibitm
           and lilocn NOT IN ('ENTRADA', 'VENCIDO', 'DEVOL')
           and ibstkt != 'O'
        union
        SELECT *
          from QADTA.f4102,QADTA.f41021
         where trim(ibmcu) = 'DIFARCAT'
           and liitm = ibitm
           and lilocn = 'ENTRADA'
           and ibstkt != 'O'
           and lilotn = ' '
        union 
        select *
          from QADTA.f4102, QADTA.f41021
         where trim(ibmcu) = 'DIFARES'
           and ibshcn = 'ES'
           and liitm = ibitm
           and lilocn NOT IN ('ENTRADA', 'VENCIDO', 'DEVOL')
           and ibstkt != 'O'
        union
        SELECT *
          from QADTA.f4102,QADTA.f41021
         where trim(ibmcu) = 'DIFARES'
           and ibshcn = 'ES'
           and liitm = ibitm
           and lilocn = 'ENTRADA'
           and ibstkt != 'O'
           and lilotn = ' '
         union 
         select *
          from QADTA.f4102, QADTA.f41021
         where trim(ibmcu) = 'DIFARMA'
           and ibshcn = 'COL'
           and liitm = ibitm
           and lilocn NOT IN ('ENTRADA', 'VENCIDO', 'DEVOL')
           and ibstkt != 'O'
        union
        SELECT *
          from QADTA.f4102,QADTA.f41021
         where trim(ibmcu) = 'DIFARMA'
           and ibshcn = 'COL'
           and liitm = ibitm
           and lilocn = 'ENTRADA'
           and ibstkt != 'O'
           and lilotn = ' ')
         WHERE IBITM IN (select imitm from qadta.f4101 where imshcn NOT IN ('ES','COL')))
 WHERE IMANPL = ABAN8
   AND IMITM = IBITM
   AND IMLITM = IVLITM
   AND IVXRT = 'VN'
 GROUP BY IBLITM, ABALPH, IVCITM
 ORDER BY IBLITM ASC
 
 
