----------------------------------------------------------
-- MEDICAMENTO E PERFUMARIA --> NFE
---------------------------------------------------------
DECLARE      
   V_UKID  CRPDTA.F00022.UKUKID%TYPE; 
BEGIN
  BEGIN
    FOR VPEDNF IN (SELECT DISTINCT SDDOCO, SDDCTO, SDDCT, SDDOC, SDNXTR, SDLNTY, NTBNNF, NTBSER, NTN001, NTDCT
                     FROM CRPDTA.F5555NET, CRPDTA.F4211
                    WHERE NTDOCO = SDDOCO
                      AND NTDCTO = SDDCTO
                      AND NTKCOO = SDKCOO
                      AND SDDCTO IN ('VO', 'ZO', 'VK', 'ZK', 'OL', 'ZL')
                      AND SDDOC = CONCAT(NTBNNF, NTBSER)
                      AND NTDCT = SDDCT
                      AND NTNXTEV1 = '100' -- Status de danfe autorizada no sefaz                      
                      AND SDNXTR = '604'
                      AND SDLNTY = 'BS') LOOP
      UPDATE CRPDTA.F4211
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
    
      UPDATE CRPDTA.F7611B
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
      SELECT UKUKID INTO V_UKID FROM CRPDTA.F00022 WHERE UKOBNM = 'F55MCN01';
      UPDATE CRPDTA.F00022 SET UKUKID = UKUKID + 1 ;                     
    
      INSERT INTO CRPDTA.F55MCN01
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
                     FROM CRPDTA.F5555NET, CRPDTA.F4211
                    WHERE NTDOCO = SDDOCO
                      AND NTDCTO = SDDCTO
                      AND NTKCOO = SDKCOO
                      AND SDDCTO IN ('ZN')
                      AND SDDOC = CONCAT(NTBNNF, NTBSER)
                      AND NTDCT = SDDCT
                      AND NTNXTEV1 = '100' -- Status de danfe autorizada no sefaz
                      AND SDNXTR = '599'
                      AND SDLNTY = 'BS') LOOP
      UPDATE CRPDTA.F4211
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
    
      UPDATE CRPDTA.F7611B
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
      SELECT UKUKID INTO V_UKID FROM CRPDTA.F00022 WHERE UKOBNM = 'F55MCN01';
      UPDATE CRPDTA.F00022 SET UKUKID = UKUKID + 1 ;                     
    
      INSERT INTO CRPDTA.F55MCN01
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
  -- BOLETO
  ---------------------------------------------------------
  BEGIN
    FOR VPEDNF IN (SELECT *
                     FROM CRPDTA.F5555NET, CRPDTA.F4211
                    WHERE NTDOCO = SDDOCO
                      AND NTDCTO = SDDCTO
                      AND NTKCOO = SDKCOO
                      AND SDDCTO IN
                          ('VO', 'ZO', 'VK', 'ZK', 'OL', 'ZL', 'ZN')
                      AND SDDOC = CONCAT(NTBNNF, NTBSER)
                      AND NTDCT = SDDCT
                      AND NTNXTEV1 = '100' -- Status de danfe autorizada no sefaz
                      AND SDNXTR = '529'
                      AND SDLNTY = 'BD') LOOP
      UPDATE CRPDTA.F4211
         SET SDNXTR = '610',
             SDUSER = 'SQLNFE',
             SDPID  = 'SQL',
             SDJOBN = 'SQL',
             SDUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             SDTDAY = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE SDDOCO = VPEDNF.SDDOCO
         AND SDDCTO = VPEDNF.SDDCTO
         AND SDDCT = VPEDNF.SDDCT
         AND SDDOC = CONCAT(VPEDNF.NTBNNF, VPEDNF.NTBSER)
         AND SDNXTR = '529'
         AND SDLNTY = 'BD';
      COMMIT;
    END LOOP;
  exception
    when others then
      null;
  END;

  ----------------------------------------------------------
  -- TABLÓIDE
  ---------------------------------------------------------
  BEGIN
    FOR VPEDNF IN (SELECT DISTINCT SDDOCO, SDDCTO, SDDCT, SDDOC, SDNXTR, SDLNTY, NTBNNF, NTBSER, NTN001, NTDCT
                     FROM CRPDTA.F5555NET, CRPDTA.F4211
                    WHERE NTDOCO = SDDOCO
                      AND NTDCTO = SDDCTO
                      AND NTKCOO = SDKCOO
                      AND SDDCTO = 'VO'
                      AND SDDOC = CONCAT(NTBNNF, NTBSER)
                      AND NTDCT = SDDCT
                      AND NTNXTEV1 = '100' -- Status de danfe autorizada no sefaz                      
                      AND SDNXTR = '604'
                      AND SDLNTY = 'BD') LOOP
      UPDATE CRPDTA.F4211
         SET SDNXTR = '610',
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
         AND SDLNTY = 'BD';
    
      UPDATE CRPDTA.F7611B
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
      COMMIT;
    END LOOP;
  exception
    when others then
      null;
  END;

  ----------------------------------------------------------
  -- TRANSFERÊNCIA 
  ---------------------------------------------------------
  BEGIN
    FOR VPEDNF IN (SELECT DISTINCT SDDOCO, SDDCTO, SDDCT, SDDOC, SDNXTR, SDLNTY, NTBNNF, NTBSER, NTN001, NTDCT
                     FROM CRPDTA.F5555NET, CRPDTA.F4211
                    WHERE NTDOCO = SDDOCO
                      AND NTDCTO = SDDCTO
                      AND NTKCOO = SDKCOO
                      AND SDDCTO in ('VU', 'ZU')
                      AND SDDOC = CONCAT(NTBNNF, NTBSER)
                      AND NTDCT = SDDCT
                      AND NTNXTEV1 = '100' -- Status de danfe autorizada no sefaz
                      AND SDNXTR = '605'
                      AND SDEMCU = '    DIFARCAT') LOOP
      UPDATE CRPDTA.F4211
         SET SDNXTR = '617',
             SDUSER = 'SQLNFE',
             SDPID  = 'SQL',
             SDJOBN = 'SQL',
             SDUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             SDTDAY = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE SDDOCO = VPEDNF.SDDOCO
         AND SDDCTO = VPEDNF.SDDCTO
         AND SDDCT = VPEDNF.SDDCT
         AND SDDOC = CONCAT(VPEDNF.NTBNNF, VPEDNF.NTBSER)
         AND SDNXTR = '605';
    
      UPDATE CRPDTA.F7611B
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
         AND FDNXTR = '616'
         AND FDAN8V = 103;
      COMMIT;
    END LOOP;
  exception
    when others then
      null;
  END;

  ----------------------------------------------------------
  -- REMESSA A ORDEM E RETORNO DO ARMAZÉM DIFARMA
  ---------------------------------------------------------
  BEGIN
    FOR VPEDNF IN (SELECT DISTINCT SDDOCO, SDDCTO, SDDCT, SDDOC, SDNXTR, SDLNTY, NTBNNF, NTBSER, NTN001, NTDCT
                     FROM CRPDTA.F5555NET, CRPDTA.F4211
                    WHERE NTDOCO = SDDOCO
                      AND NTDCTO = SDDCTO
                      AND NTKCOO = SDKCOO
                      AND SDDCTO in ('U3', 'U4')
                      AND SDDOC = CONCAT(NTBNNF, NTBSER)
                      AND NTDCT = SDDCT
                      AND NTNXTEV1 = '100' -- Status de danfe autorizada no sefaz                      
                      AND SDNXTR = '599'
                     /* AND SDAN8 IN
                          ('101', '102', '103', '116', '113', '105')*/ --- ADS 27/10/10.--desativado Clicia: 31/08/2011
                      AND SDEMCU IN ('     DICONOL', '   DIFARMAOL')) LOOP
      UPDATE CRPDTA.F4211
         SET SDNXTR = '617',
             SDUSER = 'SQLNFE',
             SDPID  = 'SQL',
             SDJOBN = 'SQL',
             SDUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             SDTDAY = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE SDDOCO = VPEDNF.SDDOCO
         AND SDDCTO = VPEDNF.SDDCTO
         AND SDDCT = VPEDNF.SDDCT
         AND SDDOC = CONCAT(VPEDNF.NTBNNF, VPEDNF.NTBSER)
         AND SDNXTR = '599';
    
      UPDATE CRPDTA.F7611B
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
         /*AND FDAN8 IN ('101', '102', '103', '116', '113', '105');*/ --- ADS 27/10/10. --desativado Clicia: 31/08/2011                 
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
                     FROM CRPDTA.F5555NET A, CRPDTA.F4211
                    WHERE NTDOCO = SDDOCO
                      AND NTDCTO = SDDCTO
                      AND NTKCOO = SDKCOO
                      AND SDDCTO IN ('VO', 'ZO', 'VK', 'ZK', 'OL', 'ZL','ZN')  -- Incluido ZN em 05/01/2012
                      AND SDNXTR = '599' --pedido aguardando transferencia                
                      AND SDLNTY = 'BS'
                      AND NTNXTEV1 = '100' -- Status de danfe autorizada no sefaz  
                      AND EXISTS
                    (SELECT *
                             FROM CRPDTA.F5555NET C
                            WHERE C.NTDOCO = A.NTDOCO
                              AND C.NTDCTO = A.NTDCTO
                              AND C.NTKCOO = A.NTKCOO
                              AND trim(C.NTNXTEV2) = '20')) LOOP
      -- Status de danfe abortada no sefaz  
      UPDATE CRPDTA.F4211
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
    
      UPDATE CRPDTA.F7611B
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
      SELECT UKUKID INTO V_UKID FROM CRPDTA.F00022 WHERE UKOBNM = 'F55MCN01';
      UPDATE CRPDTA.F00022 SET UKUKID = UKUKID + 1 ;                     
          
      INSERT INTO CRPDTA.F55MCN01
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

  ----------------------------------------------------------------------
  -- Avança status dos pedidos que ja possuem remessa --
  ----------------------------------------------------------------------  
  BEGIN
    FOR VPEDNF IN (SELECT /*+ INDEX(A, F5555NET_1) */
                    *
                     FROM CRPDTA.F5555NET A, CRPDTA.F4211
                    WHERE NTDOCO = SDDOCO
                      AND NTDCTO = SDDCTO
                      AND NTKCOO = SDKCOO
                      AND SDDCTO IN ('VU', 'ZU')
                      AND SDNXTR = '599' --pedido aguardando transferencia                
                      AND NTNXTEV1 = '100' -- Status de danfe autorizada no sefaz  
                      AND EXISTS
                    (SELECT *
                             FROM CRPDTA.F5555NET C
                            WHERE C.NTDOCO = A.NTDOCO
                              AND C.NTDCTO = A.NTDCTO
                              AND C.NTKCOO = A.NTKCOO
                              AND trim(C.NTNXTEV2) = '20')) LOOP
      -- Status de danfe abortada no sefaz  
      UPDATE CRPDTA.F4211
         SET SDLTTR = VPEDNF.SDNXTR,
             SDNXTR = '617',
             SDUSER = 'SQLNFEPR',
             SDPID  = 'SQL',
             SDJOBN = 'SQL',
             SDUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             SDTDAY = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE SDDOCO = VPEDNF.SDDOCO
         AND SDDCTO = VPEDNF.SDDCTO
         AND SDKCOO = VPEDNF.SDKCOO
         AND SDDCT = VPEDNF.SDDCT
         AND SDDOC = CONCAT(VPEDNF.NTBNNF, VPEDNF.NTBSER);
    
      UPDATE CRPDTA.F7611B
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
    
      COMMIT;
    END LOOP;
  exception
    when others then
      null;
  END;
  --------------------------------------------------------------------------------------
  -- Atualiza registros para que uma nova NF possa ser gerada apartir do mesmo pedido --
  -- quando esta nota for abortada --
  -- ATENÇÃO: esse processo funcionará apenas para os pedidos de venda que já possuem --
  -- tranferencia e remessa--DC5541032
  --------------------------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- MEDICAMENTOS --
  ----------------------------------------------------------------------  
  BEGIN
    FOR V01 IN (SELECT *
                  FROM CRPDTA.F5555NET, CRPDTA.F4211
                 WHERE NTDOCO = SDDOCO
                   AND NTDCTO = SDDCTO
                   AND NTDCT = SDDCT
                   AND NTNXTEV2 = '20' -- Status de danfe abortada no sefaz
                   AND SDDOC = CONCAT(NTBNNF, NTBSER)
                   AND SDDCTO IN ('VO', 'ZO', 'VK', 'ZK', 'OL', 'ZL')
                   AND SDNXTR = '604'
                   AND SDLNTY = 'BS') LOOP
    
      UPDATE CRPDTA.F4211 -- PEDIDO
         SET SDLTTR = SDNXTR,
             SDNXTR = '595',
             SDDOC  = 0,
             SDDCT  = '',
             SDKCO  = '',
             SDIVD  = 0,
             SDUSER = 'SQLNFEPR',
             SDPID  = 'SQL',
             SDJOBN = 'SQL',
             SDUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             SDTDAY = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE SDDOCO = V01.SDDOCO
         AND SDDCTO = V01.SDDCTO
         AND SDDCT = V01.SDDCT
         AND SDDOC = CONCAT(V01.NTBNNF, V01.NTBSER)
         AND SDNXTR = '604'
         AND SDLNTY = 'BS';
    
      UPDATE CRPDTA.F554611A -- PRÉ-NOTA
         SET PNAAID = 0,
             PNISSU = 0,
             PNAA   = 0,
             PNUSER = 'SQLNFEPR',
             PNPID  = 'SQL',
             PNJOBN = 'SQL',
             PNUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             PNUPMT = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE PNDOCO = V01.SDDOCO
         AND PNDCTO = V01.SDDCTO
         AND PNLNID = V01.SDLNID;
    
      UPDATE CRPDTA.F5503003 -- BOLETO
         SET XXVOD = 3 -- NOTA ABORTADA NO SEFAZ
       WHERE XXBNNF = V01.NTBNNF
         AND XXBSER = V01.NTBSER
         AND XXDCT = V01.NTDCT
         AND XXMCU = V01.NTMCU;
      COMMIT;
    
      DELETE FROM CRPDTA.F4211
       WHERE SDDOCO = V01.SDDOCO
         AND SDDCTO = V01.SDDCTO
         AND SDDCT = V01.SDDCT
         AND SDDOC = CONCAT(V01.NTBNNF, V01.NTBSER)
         AND SDLNTY = 'BD';
      COMMIT;
	  
   END LOOP;
  
  exception
    when others then
      null;
  END;

  ----------------------------------------------------------------------
  -- THERMOLAB --
  ----------------------------------------------------------------------  
  BEGIN
    FOR V01 IN (SELECT *
                  FROM CRPDTA.F5555NET, CRPDTA.F4211
                 WHERE NTDOCO = SDDOCO
                   AND NTDCTO = SDDCTO
                   AND NTDCT = SDDCT
                   AND NTNXTEV2 = '20' -- Status de danfe abortada no sefaz
                   AND SDDOC = CONCAT(NTBNNF, NTBSER)
                   AND SDDCTO IN ('ZN')
                   AND SDNXTR = '599'
                   AND SDLNTY = 'BS') LOOP
    
      UPDATE CRPDTA.F4211 -- PEDIDO
         SET SDLTTR = SDNXTR,
             SDNXTR = '595',
             SDDOC  = 0,
             SDDCT  = '',
             SDKCO  = '',
             SDIVD  = 0,
             SDUSER = 'SQLNFEPR',
             SDPID  = 'SQL',
             SDJOBN = 'SQL',
             SDUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             SDTDAY = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE SDDOCO = V01.SDDOCO
         AND SDDCTO = V01.SDDCTO
         AND SDDCT = V01.SDDCT
         AND SDDOC = CONCAT(V01.NTBNNF, V01.NTBSER)
         AND SDNXTR = '599'
         AND SDLNTY = 'BS';
    
      UPDATE CRPDTA.F554611A -- PRÉ-NOTA
         SET PNAAID = 0,
             PNISSU = 0,
             PNAA   = 0,
             PNUSER = 'SQLNFEPR',
             PNPID  = 'SQL',
             PNJOBN = 'SQL',
             PNUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             PNUPMT = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE PNDOCO = V01.SDDOCO
         AND PNDCTO = V01.SDDCTO
         AND PNLNID = V01.SDLNID;
    
      UPDATE CRPDTA.F5503003 -- BOLETO
         SET XXVOD = 3 -- NOTA ABORTADA NO SEFAZ
       WHERE XXBNNF = V01.NTBNNF
         AND XXBSER = V01.NTBSER
         AND XXDCT = V01.NTDCT
         AND XXMCU = V01.NTMCU;
      COMMIT;
    
      DELETE FROM CRPDTA.F4211
       WHERE SDDOCO = V01.SDDOCO
         AND SDDCTO = V01.SDDCTO
         AND SDDCT = V01.SDDCT
         AND SDDOC = CONCAT(V01.NTBNNF, V01.NTBSER)
         AND SDLNTY = 'BD';
      COMMIT;
	    
    END LOOP;
  
  exception
    when others then
      null;
  END;
  ----------------------------------------------------------
  -- TRANSFERÊNCIA 
  ---------------------------------------------------------
  BEGIN
    FOR V02 IN (SELECT *
                  FROM CRPDTA.F5555NET, CRPDTA.F4211
                 WHERE NTDOCO = SDDOCO
                   AND NTDCTO = SDDCTO
                   AND NTKCOO = SDKCOO
                   AND SDDCTO in ('VU', 'ZU')
                   AND SDDOC = CONCAT(NTBNNF, NTBSER)
                   AND NTDCT = SDDCT
                   AND NTNXTEV2 = '20' -- Status de danfe ABORTADA no sefaz
                   AND SDNXTR = '605'
                   AND SDEMCU = '    DIFARCAT') LOOP
      UPDATE CRPDTA.F4211 -- PEDIDO
         SET SDLTTR = SDNXTR,
             SDNXTR = '595',
             SDDOC  = 0,
             SDDCT  = '',
             SDKCO  = '',
             SDIVD  = 0,
             SDUSER = 'SQLNFEPR',
             SDPID  = 'SQL',
             SDJOBN = 'SQL',
             SDUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             SDTDAY = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE SDDOCO = V02.SDDOCO
         AND SDDCTO = V02.SDDCTO
         AND SDDCT = V02.SDDCT
         AND SDDOC = CONCAT(V02.NTBNNF, V02.NTBSER)
         AND SDNXTR = '605';
      COMMIT;
    END LOOP;
  exception
    when others then
      null;
  END;

  ----------------------------------------------------------
  -- REMESSA A ORDEM E RETORNO DO ARMAZÉM DIFARMA
  ---------------------------------------------------------  
  BEGIN
    FOR V02 IN (SELECT *
                  FROM CRPDTA.F5555NET, CRPDTA.F4211
                 WHERE NTDOCO = SDDOCO
                   AND NTDCTO = SDDCTO
                   AND NTKCOO = SDKCOO
                   AND SDDCTO in ('U3', 'U4')
                   AND SDDOC = CONCAT(NTBNNF, NTBSER)
                   AND NTDCT = SDDCT
                   AND NTNXTEV2 = '20' -- Status de danfe abortada no sefaz
                   AND SDNXTR = '599'
                   /*AND SDAN8 IN ('101', '102', '103', '116', '113', '105')*/ --desativado Clicia: 31/08/2011
                   AND SDEMCU IN ('     DICONOL', '   DIFARMAOL')) LOOP
      UPDATE CRPDTA.F4211 -- PEDIDO
         SET SDLTTR = SDNXTR,
             SDNXTR = '595',
             SDDOC  = 0,
             SDDCT  = '',
             SDKCO  = '',
             SDIVD  = 0,
             SDUSER = 'SQLNFEPR',
             SDPID  = 'SQL',
             SDJOBN = 'SQL',
             SDUPMJ = TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000,
             SDTDAY = TO_CHAR(SYSDATE, 'HH24MISS')
       WHERE SDDOCO = V02.SDDOCO
         AND SDDCTO = V02.SDDCTO
         AND SDDCT = V02.SDDCT
         AND SDDOC = CONCAT(V02.NTBNNF, V02.NTBSER)
         AND SDNXTR = '599';
      COMMIT;
    END LOOP;
  exception
    when others then
      null;
  END;

END;


