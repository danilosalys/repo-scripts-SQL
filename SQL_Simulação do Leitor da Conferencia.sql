INSERT INTO  SCMDEV.ENTLOTLTI
SELECT DISTINCT SDDOCO,
                1,
                TO_DATE(sddrqj + 1900000, 'YYYYDDD') AS sddrqj,
                trim((select MAX(IVCITM)
                       from QADTA.f4104
                      where sdlitm = ivlitm
                        and ivxrt = 'VN')) AS CodBarra,
                SDLOTN,
                SDLITM,
                sum(SDSOQS),
                USUARIO AS 'DSALES',
                SYSDATE
  FROM QADTA.F4211
 WHERE SDDOCO IN (10163121,10163124,10163122,10163123,10163125,10163128,10163130,10163126,
                  10163129,10163127,10163132,10163134,10163135,10163133,10163131,10163136)
 AND SDNXTR NOT IN ('999')
 AND SDLTTR NOT IN ('980','982')
 group by SDDOCO,sddrqj,SDLOTN,SDLITM
  ORDER BY SDDOCO;