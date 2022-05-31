----------------------INSERT LINHA A LINHA 

SELECT DISTINCT FDDOCO,
                FDPDCT,
                'INSERT INTO PRODDTA.F55MCN01 VALUES (' || (920 + ROWNUM) || ',' ||
                FDBNNF || ',''' || FDBSER || ''',' || FDN001 || ',' ||
                '''NS''' || ',' || '116166' || ',' || '173400' || ',' ||
                ''' ''' || ',' || '''DSALES''' || ',' || '''SQL''' || ',' ||
                '''DANILOTHIN''' || ',' || '116166' || ',' || '165800' || ');'
  FROM (select DISTINCT FDBNNF, FDBSER, FDN001, FDDOCO, FDPDCT
          from PRODDTA.F7611B
         where NOT EXISTS (SELECT *
                  FROM PRODDTA.F55MCN01
                 WHERE FDBNNF = FHBNNF
                   AND FDBSER = FHBSER
                   AND FDN001 = FHN001)
           AND FDDOCO IN ())
union
SELECT DISTINCT FDDOCO,
                FDPDCT,
                'INSERT INTO PRODDTA.F55MCN01 VALUES (' || (2181 + ROWNUM) || ',' ||
                FDBNNF || ',''' || FDBSER || ''',' || FDN001 || ',' ||
                '''NS''' || ',' || '116163' || ',' || '173400' || ',' ||
                ''' ''' || ',' || '''DSALES''' || ',' || '''SQL''' || ',' ||
                '''DANILOTHIN''' || ',' || '116166' || ',' || '165800' || ');'
  FROM (select DISTINCT FDBNNF, FDBSER, FDN001, FDDOCO, FDPDCT
          from PRODDTA.F7611B
         where NOT EXISTS (SELECT *
                  FROM PRODDTA.F55MCN01
                 WHERE FDBNNF = FHBNNF
                   AND FDBSER = FHBSER
                   AND FDN001 = FHN001)
           AND FDDOCO IN ())
 ORDER BY FDDOCO, FDPDCT;



----------------------INSERT COM SCRIPT 
DECLARE
  V_UKID PRODDTA.F00022.UKUKID%TYPE;
BEGIN
  BEGIN
    FOR VPEDNF IN (SELECT DISTINCT SDDOCO,
                                   SDDCTO,
                                   SDDCT,
                                   SDDOC,
                                   SDNXTR,
                                   SDLNTY,
                                   NTBNNF,
                                   NTBSER,
                                   NTN001,
                                   NTDCT
                     FROM PRODDTA.F5555NET, PRODDTA.F42119
                    WHERE NTDOCO = SDDOCO
                      AND NTDCTO = SDDCTO
                      AND NTKCOO = SDKCOO
                     -- AND SDDCTO = 'ZN'
                      AND SDDOC = CONCAT(NTBNNF, NTBSER)
                      AND NTDCT = SDDCT
                      AND NTNXTEV1 = '100' -- Status de danfe autorizada no sefaz                                           
                      AND SDLNTY = 'BS'
                      AND SDDOCO in (12256455)) LOOP
    
      ----------------------------------------------------------
      -- ENVIO NF PARA O MERCANET
      ---------------------------------------------------------      
      SELECT UKUKID
        INTO V_UKID
        FROM PRODDTA.F00022
       WHERE UKOBNM = 'F55MCN01';
      UPDATE PRODDTA.F00022 SET UKUKID = UKUKID + 1;
    
      INSERT INTO PRODDTA.F55MCN01
      VALUES
        (V_UKID,
         VPEDNF.NTBNNF,
         VPEDNF.NTBSER,
         VPEDNF.NTN001,
         VPEDNF.NTDCT,
         TO_NUMBER(TO_CHAR(sysdate, 'YYYYDDD') - 1900000),
         TO_CHAR(SYSDATE, 'HH24MISS'),
         ' ',
         'DSALES',
         'SQL',
         'DANILO-THI',
         TO_NUMBER(TO_CHAR(sysdate, 'YYYYDDD') - 1900000),
         TO_CHAR(SYSDATE, 'HH24MISS'));
   commit; 
     
    END LOOP;
  exception
    when others then
      null;
  END;
END;
