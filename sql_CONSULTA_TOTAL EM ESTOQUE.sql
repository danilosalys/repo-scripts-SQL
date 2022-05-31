--OPÇÃO 1 
  SELECT IBLITM,(SUM(LIPQOH - (LIPCOM + LIHCOM))) - MAX(IBSAFE) DISPONIBILIDADE
       from (
     select *
       from qadta.f4102, qadta.f41021
      where IBLITM in ('&ITEM')
        and trim(ibmcu) = 'DIFARCAT'
        and liitm = ibitm
        and lilocn NOT IN ('ENTRADA', 'VENCIDO', 'DEVOL')
     union 
     SELECT *
       from qadta.f4102, qadta.f41021
      where IBLITM in ('&ITEM')
        and trim(ibmcu) = 'DIFARCAT'
        and liitm = ibitm
        and lilocn =  'ENTRADA'
        and lilotn = ' ')
      GROUP BY IBLITM


--OPÇÃO 2

/*SELECT (SUM(SUM(LIPQOH) - (SUM(LIPCOM) + SUM(LIHCOM))) - MAX(IBSAFE))  "TOTAL NO ESTOQUE" 
       from (
     select * 
       from qadta.f4102, qadta.f41021
      where LIITM = 2594
        and trim(ibmcu) = 'DIFARCAT'
        and liitm = ibitm
        and lilocn NOT IN ('ENTRADA', 'VENCIDO', 'DEVOL')
     union 
     SELECT *
       from qadta.f4102, qadta.f41021
      where LIITM = 2594
        and trim(ibmcu) = 'DIFARCAT'
        and liitm = ibitm
        and lilocn =  'ENTRADA'
        and lilotn = ' ')
      GROUP BY IBSAFE*/