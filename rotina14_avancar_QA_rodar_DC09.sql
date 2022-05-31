----------------------------------------------------------
-- MEDICAMENTO E PERFUMARIA --> NFE
---------------------------------------------------------
DECLARE      
   V_UKID  QADTA.F00022.UKUKID@DC10%TYPE; 
BEGIN
  BEGIN
    FOR VPEDNF IN (SELECT DISTINCT SDDOCO, SDDCTO, SDDCT, SDDOC, SDNXTR, SDLNTY, NTBNNF, NTBSER, NTN001, NTDCT
                     FROM QADTA.F5555NET@DC10, QADTA.F4211@DC10
                    WHERE NTDOCO = SDDOCO
                      AND NTDCTO = SDDCTO
                      AND NTKCOO = SDKCOO
                      AND SDDCTO IN ('VO', 'ZO', 'VK', 'ZK', 'OL', 'ZL')
                      AND SDDOC = CONCAT(NTBNNF, NTBSER)
                      AND NTDCT = SDDCT
                      AND NTNXTEV1 = '100' -- Status de danfe autorizada no sefaz                      
                      AND SDNXTR = '604'
                      AND SDLNTY = 'BS') LOOP
      UPDATE QADTA.F4211@DC10
         SET SDNXTR = '605',
             SDUSER = 'SQLNFE',
             SDPID  = 'SQL',
             SDJOBN = 'SQL',
             SDUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             SDTDAY = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE SDDOCO = VPEDNF.SDDOCO
         AND SDDCTO = VPEDNF.SDDCTO
         AND SDDCT = VPEDNF.SDDCT
         AND SDDOC = CONCAT(VPEDNF.NTBNNF, VPEDNF.NTBSER)
         AND SDNXTR = '604'
         AND SDLNTY = 'BS';
    
      UPDATE QADTA.F7611B@DC10
         SET FDNXTR = '617',
             FDUSER = 'SQLNFE',
             FDPID  = 'SQL',
             FDJOBN = 'SQL',
             FDUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             FDTDAY = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE FDBNNF = VPEDNF.NTBNNF
         AND FDBSER = VPEDNF.NTBSER
         AND FDN001 = VPEDNF.NTN001
         AND FDDCT = VPEDNF.NTDCT
         AND FDNXTR = '616';

      ----------------------------------------------------------
      -- ENVIO NF PARA O MERCANET
      ---------------------------------------------------------
      --Adicionado Joice: 05/07/11  
      SELECT UKUKID INTO V_UKID FROM QADTA.F00022@DC10 WHERE UKOBNM = 'F55MCN01';
      UPDATE QADTA.F00022@DC10 SET UKUKID = UKUKID + 1 ;                     
    
      INSERT INTO QADTA.F55MCN01@DC10
      VALUES
        (V_UKID,
         VPEDNF.NTBNNF,
         VPEDNF.NTBSER,
         VPEDNF.NTN001,
         VPEDNF.NTDCT,
         TO_NUMBER(TO_CHAR(sysdate, 'YYYYDDD') - 1900000),
         TO_CHAR(SYSDATE, 'HH24MISS'),
         ' ',
         'SQLNFE',
         'ROTINA14',
         'SQL',
         TO_NUMBER(TO_CHAR(sysdate, 'YYYYDDD') - 1900000),
         TO_CHAR(SYSDATE, 'HH24MISS'));


      COMMIT;
    END LOOP;
  exception
    when others then
      null;
  END;

  ----------------------------------------------------------
  -- MEDICAMENTO THERMOLAB --> NFE
  ---------------------------------------------------------
  BEGIN
    FOR VPEDNF IN (SELECT DISTINCT SDDOCO, SDDCTO, SDDCT, SDDOC, SDNXTR, SDLNTY, NTBNNF, NTBSER, NTN001, NTDCT
                     FROM QADTA.F5555NET@DC10, QADTA.F4211@DC10
                    WHERE NTDOCO = SDDOCO
                      AND NTDCTO = SDDCTO
                      AND NTKCOO = SDKCOO
                      AND SDDCTO IN ('ZN')
                      AND SDDOC = CONCAT(NTBNNF, NTBSER)
                      AND NTDCT = SDDCT
                      AND NTNXTEV1 = '100' -- Status de danfe autorizada no sefaz
                      AND SDNXTR = '599'
                      AND SDLNTY = 'BS') LOOP
      UPDATE QADTA.F4211@DC10
         SET SDNXTR = '605',
             SDUSER = 'SQLNFE',
             SDPID  = 'SQL',
             SDJOBN = 'SQL',
             SDUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             SDTDAY = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE SDDOCO = VPEDNF.SDDOCO
         AND SDDCTO = VPEDNF.SDDCTO
         AND SDDCT = VPEDNF.SDDCT
         AND SDDOC = CONCAT(VPEDNF.NTBNNF, VPEDNF.NTBSER)
         AND SDNXTR = '599'
         AND SDLNTY = 'BS';
    
      UPDATE QADTA.F7611B@DC10
         SET FDNXTR = '617',
             FDUSER = 'SQLNFE',
             FDPID  = 'SQL',
             FDJOBN = 'SQL',
             FDUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             FDTDAY = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE FDBNNF = VPEDNF.NTBNNF
         AND FDBSER = VPEDNF.NTBSER
         AND FDN001 = VPEDNF.NTN001
         AND FDDCT = VPEDNF.NTDCT
         AND FDNXTR = '616';

      ----------------------------------------------------------
      -- ENVIO NF PARA O MERCANET
      ---------------------------------------------------------
      --Adicionado Joice: 04/11/11
      SELECT UKUKID INTO V_UKID FROM QADTA.F00022@DC10 WHERE UKOBNM = 'F55MCN01';
      UPDATE QADTA.F00022@DC10 SET UKUKID = UKUKID + 1 ;                     
    
      INSERT INTO QADTA.F55MCN01@DC10
      VALUES
        (V_UKID,
         VPEDNF.NTBNNF,
         VPEDNF.NTBSER,
         VPEDNF.NTN001,
         VPEDNF.NTDCT,
         TO_NUMBER(TO_CHAR(sysdate, 'YYYYDDD') - 1900000),
         TO_CHAR(SYSDATE, 'HH24MISS'),
         ' ',
         'SQLNFE',
         'ROTINA14',
         'SQL',
         TO_NUMBER(TO_CHAR(sysdate, 'YYYYDDD') - 1900000),
         TO_CHAR(SYSDATE, 'HH24MISS'));


      COMMIT;
    END LOOP;
  exception
    when others then
      null;
  END;
  
  
  ---------------------------------------------------------------------------------------
  -- Avança status dos pedidos da nota relativa que ja possuem transferencia e remessa --
  ---------------------------------------------------------------------------------------  
  BEGIN
    FOR VPEDNF IN (SELECT /*+ INDEX(A, F5555NET_1) */
                    *
                     FROM QADTA.F5555NET@DC10 A, QADTA.F4211@DC10
                    WHERE NTDOCO = SDDOCO
                      AND NTDCTO = SDDCTO
                      AND NTKCOO = SDKCOO
                      AND SDDCTO IN ('VO', 'ZO', 'VK', 'ZK', 'OL', 'ZL','ZN')  -- Incluido ZN em 05/01/2012
                      AND SDNXTR = '599' --pedido aguardando transferencia                
                      AND SDLNTY = 'BS'
                      AND NTNXTEV1 = '100' -- Status de danfe autorizada no sefaz  
                      AND EXISTS
                    (SELECT *
                             FROM QADTA.F5555NET@DC10 C
                            WHERE C.NTDOCO = A.NTDOCO
                              AND C.NTDCTO = A.NTDCTO
                              AND C.NTKCOO = A.NTKCOO
                              AND trim(C.NTNXTEV2) = '20')) LOOP
      -- Status de danfe abortada no sefaz  
      UPDATE QADTA.F4211@DC10
         SET SDLTTR = VPEDNF.SDNXTR,
             SDNXTR = '605',
             SDUSER = 'SQLNFEPR',
             SDPID  = 'SQL',
             SDJOBN = 'SQL',
             SDUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             SDTDAY = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE SDDOCO = VPEDNF.SDDOCO
         AND SDDCTO = VPEDNF.SDDCTO
         AND SDKCOO = VPEDNF.SDKCOO
         AND SDDCT = VPEDNF.SDDCT
         AND SDDOC = CONCAT(VPEDNF.NTBNNF, VPEDNF.NTBSER)
         AND SDLNTY = 'BS';
    
      UPDATE QADTA.F7611B@DC10
         SET FDNXTR = '617',
             FDUSER = 'SQLNFE',
             FDPID  = 'SQL',
             FDJOBN = 'SQL',
             FDUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             FDTDAY = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE FDBNNF = VPEDNF.NTBNNF
         AND FDBSER = VPEDNF.NTBSER
         AND FDN001 = VPEDNF.NTN001
         AND FDDCT = VPEDNF.NTDCT
         AND FDNXTR = '616';
         
      ----------------------------------------------------------
      -- ENVIO NF PARA O MERCANET
      ---------------------------------------------------------
      --Adicionado Joice: 02/01/12	
      SELECT UKUKID INTO V_UKID FROM QADTA.F00022@DC10 WHERE UKOBNM = 'F55MCN01';
      UPDATE QADTA.F00022@DC10 SET UKUKID = UKUKID + 1 ;                     
          
      INSERT INTO QADTA.F55MCN01@DC10
      VALUES
        (V_UKID,
         VPEDNF.NTBNNF,
         VPEDNF.NTBSER,
         VPEDNF.NTN001,
         VPEDNF.NTDCT,
         TO_NUMBER(TO_CHAR(sysdate, 'YYYYDDD') - 1900000),
         TO_CHAR(SYSDATE, 'HH24MISS'),
         ' ',
         'SQLNFEPR',
         'ROTINA14',
         'SQL',
         TO_NUMBER(TO_CHAR(sysdate, 'YYYYDDD') - 1900000),
         TO_CHAR(SYSDATE, 'HH24MISS'));
       
    
      COMMIT;
      
    END LOOP;
  exception
    when others then
      null;
  END;

END;
