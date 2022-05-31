--86400 
--UPDATE ANALISE_PROCESS SET ID_PROC = ROWNUM

ANALISE_PROCESS

DECLARE 
     N_DATA DATE ;
     N_DIFF NUMBER;
     N_COUNTER NUMBER := 0;
BEGIN
  
FOR X IN (SELECT  ID_PROC
                 ,TO_DATE(DATA_INICIO_GRAVACAO_ARQ||' '||HORA_INICIO_GRAVACAO_ARQ,'DD/MM/YYYY HH24:MI:SS') AS PROC_LOTE   
            FROM ANALISE_PROCESS      
            ORDER BY 2
          )
          LOOP  
            
            IF N_COUNTER = 0 THEN 
               N_DATA    := X.PROC_LOTE;             
               N_COUNTER := 10000;
            END IF;            
          
            N_DIFF := ROUND((X.PROC_LOTE - N_DATA)*86400);
          
            N_DATA := X.PROC_LOTE;
                       
            
            IF N_DIFF > 60 THEN              
               N_COUNTER := N_COUNTER + 1;
               UPDATE ANALISE_PROCESS UP
               SET UP.ID_PROC = N_COUNTER
               WHERE UP.ID_PROC = X.ID_PROC;
            ELSE
               UPDATE ANALISE_PROCESS UP
               SET UP.ID_PROC = N_COUNTER
               WHERE UP.ID_PROC = X.ID_PROC;          
            END IF;

          END LOOP;
 END ;     
 
 
/* SELECT  TRUNC((FIM - INICIO) * 1440)
  FROM (
 SELECT TO_DATE('09/01/2014 14:00:00','DD/MM/YYYY HH24:MI:SS') AS INICIO,
        TO_DATE('09/01/2014 14:01:50','DD/MM/YYYY HH24:MI:SS') AS FIM
 FROM DUAL)*/
 
--SELECT * FROM ANALISE_PROCESS ORDER BY 1    
