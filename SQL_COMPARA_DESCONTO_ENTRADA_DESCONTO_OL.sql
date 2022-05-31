SELECT SAVR01,
       SADOCO,
       TO_DATE(SAUPMJ + 1900000, 'YYYYDDD') SAUPMJ,
       IMDSC1,
       IMITM,
       IMLITM,
       IBSTKT,
       IBSHCM,
       to_number(replace(TRIM(DRDL01), '%', null)) AS DESC_ENTRADA,
       SBUOM AS DESC_OL,
       CAST((to_number(replace(TRIM(DRDL01), '%', null)) + SBUOM) AS
            NUMBER(5)) AS DESC_SOMADOS
  FROM PRODDTA.F5547011,
       PRODDTA.F4102 A,
       PRODDTA.F4101,
       PRODDTA.f0005,
       PRODDTA.F5547012
 WHERE IBMCU = '    DIFARCAT'
   AND IBSTKT IN ('P', 'U')
   AND IBSHCM NOT IN ('AAA', ' ')
   AND IBSRP8 IN ('C', 'L', 'P', 'V', 'Y', 'Z')
   AND IBITM = IMITM
   AND DRSY = '41'
   AND DRRT = 'E'
   AND IBPRP1 <> 'MGN' --para produtos genéricos o Desc de Entrada nao deve ser aplicado (ajuste V...315)
   AND TRIM(DRKY) = TRIM(IBSHCM)
   AND SAOORN = 'MERCANET'
   AND SAZ55ORI IN ('ZHR', 'HRY', 'PBM')
   AND EXISTS (SELECT *
          FROM PRODDTA.F0101
         WHERE ABAN8 = SAAN8
           AND ABAC05 = 'DRO')
   AND SBUKID = SAUKID
   AND SAUPMJ > 115096 --data dos pedidos
   AND SBLITM = IBLITM
   
   
