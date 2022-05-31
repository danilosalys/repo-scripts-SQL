select  IBLITM, IMDSC1,IBPRP1  , IBPRP2,IBSHCN , IBSHCM   , IBSRP8 , IBSRP3 , IBSRP5 , IBPRP3 , IBSRP2 , IBPRP0
FROM PRODDTA.F4102, PRODDTA.F4101
WHERE IBITM = IMITM

AND IBSRP1 = 'DIF' 
AND IBPRP5 IN ('PER' , 'MED')
AND IBMCU =  '    DIFARCAT'
AND   IBSTKT = 'P'
--AND IBSHCN IN ('STG')
--AND   IBPRP2 BETWEEN 092 AND 101
--AND   IBSHCM IN ('OL','AAA')
--AND   IBSRP8 IN (/*'P','C',*/'L')   
--AND IBSRP3 = 'NEU' --'POS', 'NEG'
--AND IBSRP5 ='AA' 
--AND IBPRP3 = 'AA' -- <> 'AA'
--AND IBSRP2 ='AA'   -- = 'KIT' ,='P05',
--AND IBPRP0 = '28917' --= '28918'

AND IBLITM IN ( )
ORDER BY IBLITM




------------------------------------------------------

/*SELECT DISTINCT iblitm , ITITM, ITBCLF 
  FROM proddta.F76411 , proddta.f4102
 WHERE  ibitm = ititm 
 and ITITM = 1154
 ORDER BY ITITM*/
 
 ----- este SQL consulta a Classificação fiscal do item , mas para isso é necessario ter o numero do ITM pois a F76411 não possui o campo LITM
