SELECT * FROM 
(SELECT T4.IBLITM AS CODIGO_PRODUTO,
       T4.IBITM AS CODIGO_CURTO,
       T2.IMDSC1 AS DESCRICAO,
       (SUM(T4.LIPQOH - (T4.LIPCOM + T4.LIHCOM))) - MAX(T4.IBSAFE) AS ESTOQUE,
       T1.ABALPH AS LABORATORIO,
       MAX(T3.IVCITM) AS EAN,
       T4.IBPRP5 AS PRP5,
       T4.IBSRP8 AS SRP8,
       T4.IBPRP1 AS PRP1,
       T4.IBPRP2 AS PRP2,
       T4.IBPRP3 AS PRP3,
       T4.IBSRP2 AS SRP2,
       T4.IBSRP3 AS SRP3,
       T4.IBPRP4 AS PRP4,
       T4.IBSHCN AS SHCN,
       T4.IBPRP9 AS PRP9,
       T4.IBSHCM AS SHCM,
(SELECT QTDE_LOTES FROM 
(SELECT IBLITM, LIITM, COUNT(DISTINCT LILOTN) QTDE_LOTES
 FROM 
(select *
          from QADTA.f4102@DC10 P1, QADTA.f41021@DC10 P2
         where trim(P1.ibmcu) = 'DIFARCAT'
           and P1.ibitm = P2.liitm
           and P2.lilocn NOT IN ('ENTRADA', 'VENCIDO', 'DEVOL')
           and P1.ibstkt != 'O'
           and P1.ibshcn <> 'TMB' --MEDICAMENTOS E PERFUMARIAS ARMAZENADOS NO DEPOSITO
        union
        SELECT *
          from QADTA.f4102@DC10 P1, QADTA.f41021@DC10 P2
         where trim(P1.ibmcu) = 'DIFARCAT'
           and P1.ibitm = P2.liitm
           and P2.lilocn = 'ENTRADA'
           and P1.ibstkt != 'O'
           and P2.lilotn = ' '
           and P1.IBSHCN <> 'TMB' --MEDICAMENTOS E PERFUMARIAS ARMAZENADOS NO DEPOSITO
        union
        select *
          from QADTA.f4102@DC10 P1, QADTA.f41021@DC10 P2
         where trim(P1.ibmcu) = 'DIFARMA'
           and P1.ibitm = P2.liitm
           and P2.lilocn NOT IN ('ENTRADA', 'VENCIDO', 'DEVOL')
           and P1.ibstkt != 'O'
           and P1.ibshcn = 'TMB' --MEDICAMENTOS DE ARMAZENAMENTO EM GELADEIRA
        union
        SELECT *
          from QADTA.f4102@DC10 P1, QADTA.f41021@DC10 P2
         where trim(P1.ibmcu) = 'DIFARMA'
           and P1.ibitm = P2.liitm
           and P2.lilocn = 'ENTRADA'
           and P1.ibstkt != 'O'
           and P2.lilotn = ' '
           and P1.ibshcn = 'TMB' --MEDICAMENTOS DE ARMAZENAMENTO EM GELADEIRA
        ) T4
WHERE (T4.LIPQOH - (T4.LIPCOM + T4.LIHCOM)) > 0 
GROUP BY IBLITM, LIITM) TAB_LOTES
WHERE T4.IBITM = TAB_LOTES.LIITM) AS QTDE_LOTES_DISPONIVEIS
  from QADTA.F0101@DC10 T1,
       QADTA.F4101@DC10 T2,
       QADTA.F4104@DC10 T3,
       (select *
          from QADTA.f4102@DC10 P1, QADTA.f41021@DC10 P2
         where trim(P1.ibmcu) = 'DIFARCAT'
           and P1.ibitm = P2.liitm
           and P2.lilocn NOT IN ('ENTRADA', 'VENCIDO', 'DEVOL')
           and P1.ibstkt != 'O'
           and P1.ibshcn <> 'TMB' --MEDICAMENTOS E PERFUMARIAS ARMAZENADOS NO DEPOSITO
        union
        SELECT *
          from QADTA.f4102@DC10 P1, QADTA.f41021@DC10 P2
         where trim(P1.ibmcu) = 'DIFARCAT'
           and P1.ibitm = P2.liitm
           and P2.lilocn = 'ENTRADA'
           and P1.ibstkt != 'O'
           and P2.lilotn = ' '
           and P1.IBSHCN <> 'TMB' --MEDICAMENTOS E PERFUMARIAS ARMAZENADOS NO DEPOSITO
        union
        select *
          from QADTA.f4102@DC10 P1, QADTA.f41021@DC10 P2
         where trim(P1.ibmcu) = 'DIFARMA'
           and P1.ibitm = P2.liitm
           and P2.lilocn NOT IN ('ENTRADA', 'VENCIDO', 'DEVOL')
           and P1.ibstkt != 'O'
           and P1.ibshcn = 'TMB' --MEDICAMENTOS DE ARMAZENAMENTO EM GELADEIRA
        union
        SELECT *
          from QADTA.f4102@DC10 P1, QADTA.f41021@DC10 P2
         where trim(P1.ibmcu) = 'DIFARMA'
           and P1.ibitm = P2.liitm
           and P2.lilocn = 'ENTRADA'
           and P1.ibstkt != 'O'
           and P2.lilotn = ' '
           and P1.ibshcn = 'TMB' --MEDICAMENTOS DE ARMAZENAMENTO EM GELADEIRA
        ) T4
 WHERE T2.IMANPL = T1.ABAN8
   AND T2.IMITM = T4.IBITM
   AND T2.IMLITM = T3.IVLITM
   AND T3.IVXRT = 'VN' -- Ref. Cruzada: Cod Ean do Produto
   and T3.IVEXDJ >= TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000 --Data de Vigencia do Ean 
 GROUP BY T4.IBLITM,
          T4.IBITM,
          T1.ABALPH,
          T4.IBPRP5,
          T4.IBSRP8,
          T4.IBPRP1,
          T4.IBSRP3,
          T4.IBPRP2,
          T4.IBPRP4,
          T2.IMDSC1,
          T4.IBSHCN,
          T4.IBPRP9,
          T2.IMSRP8,
          T4.IBPRP3,
          T4.IBSRP2,
          T4.IBSHCM
)
WHERE CODIGO_PRODUTO IN ('11795');


--VERSÃO INTEGRATOR 
SELECT (SELECT SUM(LIPQOH - LIHCOM)
          FROM qadta.F41021
         WHERE LIMCU = IBMCU
           AND LIITM = IBITM
           AND LIPBIN = 'S'
           AND LILOTS = ' '
         GROUP BY LIITM) - (SELECT SUM(LIPQOH - LIPCOM)
                              FROM qadta.F41021
                             WHERE LIMCU = IBMCU
                               AND LIITM = IBITM
                               AND LIPBIN = 'P'
                               AND LILOCN = 'ENTRADA'
                             GROUP BY LIITM) * -1 - IBSAFE  AS SALDO_ESTOQUE
  FROM qadta.F4102
WHERE IBLITM = '11795'
   AND TRIM(IBMCU) IN DECODE(IBSHCN,'TMB','DIFARMA', NVL((SELECT TRIM(DRDL01)
                                                           FROM qadta.F0005
                                                          WHERE DRSY = '55'
                                                            AND DRRT = 'ZS'
                                                            AND TRIM(DRKY) = TRIM(IBSHCN)),'DIFARCAT'))


