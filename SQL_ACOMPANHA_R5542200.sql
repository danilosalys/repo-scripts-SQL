SELECT SAZ55ORI,
       NVL((SELECT COUNT(1)
             FROM CRPDTA.F5547011 U1
            WHERE U1.SAEDBT = ' '
              AND U1.SAEDSP = ' '
              AND U1.SADOCO = 0
              AND U1.SAKCOO = ' '
              AND U1.SAZ55ORI = T1.SAZ55ORI
              AND U1.SAOORN = T1.SAOORN
              AND U1.SAUPMJ > 118240
              AND U1.SAOORN = 'MERCANET'
              AND U1.SAZ55ORI <> 'MPR'
            GROUP BY U1.SAZ55ORI),
           0) AS "A PROCESSAR",
       NVL((SELECT COUNT(1)
             FROM CRPDTA.F5547011 U1
            WHERE U1.SAEDBT != ' '
              AND U1.SAEDBT != 'E'
              AND U1.SAEDSP IN (' ', 'U')
              AND U1.SADOCO = 0
              AND U1.SAKCOO = ' '
              AND U1.SAZ55ORI = T1.SAZ55ORI
              AND U1.SAOORN = T1.SAOORN
              AND U1.SAUPMJ > 118240
              AND U1.SAOORN = 'MERCANET'
              AND U1.SAZ55ORI <> 'MPR'
            GROUP BY U1.SAZ55ORI),
           0) AS "EM PROCESSAMENTO",
       NVL((SELECT COUNT(1)
             FROM CRPDTA.F5547011 U1
            WHERE U1.SAEDBT != ' '
              AND (U1.SAEDSP != ' ' OR
                  (U1.SAEDBT = 'E' AND U1.SAEDSP = ' '))
              AND (U1.SAKCOO != ' ' OR
                  (U1.SAEDBT = 'E' AND U1.SAKCOO = ' '))
              AND U1.SAZ55ORI = T1.SAZ55ORI
              AND U1.SAOORN = T1.SAOORN
              AND U1.SAUPMJ > 118240
              AND U1.SAOORN = 'MERCANET'
              AND U1.SAZ55ORI <> 'MPR'
            GROUP BY U1.SAZ55ORI),
           0) as "PROCESSADOS"
  FROM CRPDTA.F5547011 T1
 WHERE T1.SAUPMJ > 118242
   AND T1.SAOORN = 'MERCANET'
   AND T1.SAZ55ORI <> 'MPR'
 GROUP BY T1.SAZ55ORI, T1.SAOORN
 


