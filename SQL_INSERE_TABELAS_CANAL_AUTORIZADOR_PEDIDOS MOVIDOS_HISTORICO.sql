/* SELECT *
 FROM PRODDTA.F554201C
      ,PRODDTA.F554211C
 WHERE CHUKID = CDUKID
 AND CHDOCO = CDDOCO
 AND CHEV02 = ' '
 AND CHEV01 = 'Y'
 AND CHTRDJ >= 122314
 AND EXISTS (SELECT * 
               FROM PRODDTA.F55NFE03
                    ,PRODDTA.F7611B
              WHERE NEDOCO = CHDOCO
                AND NERCD1 = '100'
                AND NEBNNF = FDBNNF 
                AND NEBSER = FDBSER
                AND NEN001 = FDN001
                AND NEDCT  = FDDCT
                AND FDLITM = CDLITM)
    */
 
                 
SELECT CHUKID
       ,CHDOCO
       ,CHTRDJ
       ,CDLITM
       ,'UPDATE PRODDTA.F554211C SET '
       ||'CDAEXP  = '||T3.FDAEXP                 ||','
       ||'CDAN08  = '||(T3.FDAEXP + T3.FDBVIS)   ||','
       ||'CDUPRC  = '||T3.FDUPRC                 ||','
       ||'CDAN02  = '||T3.FDBBCL                 ||','
       ||'CDAN03  = '||T3.FDBBIS                 ||','
       ||'CDTXR1  = '||T3.FDTXR1                 ||','
       ||'CDTXR2  = '||T3.FDTXR2                 ||','
       ||'CDAN04  = '||T3.FDBICM                 ||','
       ||'CDAN05  = '||T3.FDBVIS                 ||','
       ||'CDBRNOP = '||''''||(SELECT DPBRNOP 
                                FROM PRODDTA.F76B200 
                               WHERE DPBNOP = T3.FDBNOP 
                                 AND DPBSOP = T3.FDBSOP 
                                 AND DPFCO = T3.FDFCO)  ||''','
       ||'CDBIST  = '||''''||DECODE(TRIM(T3.FDBIST),
                                     '10', 'S', 
                                     '60', 'S', 
                                     '00','N', 
                                     '20', 'N', 
                                     'I') ||''','
       ||'CDFLAG  = '||''''||(SELECT DECODE(TRIM(SDSRP3), 
                                     'POS', 'P', 
                                     'NEG', 'N', 
                                     'NEU', '0', 
                                     '0') 
                                FROM PRODDTA.F42119 X1
                               WHERE X1.SDDOCO = T2.CDDOCO
                                 AND X1.SDDOCO = T1.CHDOCO
                                 AND X1.SDKCOO = T1.CHKCOO 
                                 AND X1.SDLNID = T2.CDLNID
                                 AND X1.SDLITM = T2.CDLITM)||''','
       ||'CDAN07  = '||T6.EDAN07||','
       ||'CDBSTT  = '||''''||T3.FDBSTT||''','
       ||'CDSRP8  = '||''''||(SELECT DECODE(TRIM(IBSRP8), 
                                                'C', 'M', 
                                                'P', 'L', 
                                             IBSRP8) 
                                FROM PRODDTA.F4102 
                               WHERE IBLITM = T2.CDLITM 
                                 AND ROWNUM = 1)||''','
       ||'CDEV02  = '||''''||'P'||''''||       
 ' WHERE CDUKID = '||T2.CDUKID|| 
     ' AND CDDOCO = '||T2.CDDOCO||
     ' AND CDDCTO = '||''''||T2.CDDCTO||''''|| 
     ' AND CDLNID = '||T2.CDLNID||
     ';' || chr(10) || chr(10) ||
     
     'UPDATE PRODDTA.F554211I SET '
       ||'IDAEXP  = '||T3.FDAEXP                 ||','
       ||'IDAN08  = '||(T3.FDAEXP + T3.FDBVIS)   ||','
       ||'IDUPRC  = '||T3.FDUPRC                 ||','
       ||'IDAN02  = '||T3.FDBBCL                 ||','
       ||'IDAN03  = '||T3.FDBBIS                 ||','
       ||'IDTXR1  = '||T3.FDTXR1                 ||','
       ||'IDTXR2  = '||T3.FDTXR2                 ||','
       ||'IDAN04  = '||T3.FDBICM                 ||','
       ||'IDAN05  = '||T3.FDBVIS                 ||','
       ||'IDBRNOP = '||''''||(SELECT DPBRNOP 
                                FROM PRODDTA.F76B200 
                               WHERE DPBNOP = T3.FDBNOP 
                                 AND DPBSOP = T3.FDBSOP 
                                 AND DPFCO = T3.FDFCO)  ||''','
       ||'IDBIST  = '||''''||DECODE(TRIM(T3.FDBIST),
                                     '10', 'S', 
                                     '60', 'S', 
                                     '00','N', 
                                     '20', 'N', 
                                     'I') ||''','
       ||'IDFLAG  = '||''''||(SELECT DECODE(TRIM(SDSRP3), 
                                     'POS', 'P', 
                                     'NEG', 'N', 
                                     'NEU', '0', 
                                     '0') 
                                FROM PRODDTA.F42119 X1
                               WHERE X1.SDDOCO = T2.CDDOCO
                                 AND X1.SDDOCO = T1.CHDOCO
                                 AND X1.SDKCOO = T1.CHKCOO 
                                 AND X1.SDLNID = T2.CDLNID
                                 AND X1.SDLITM = T2.CDLITM)||''','
       ||'IDAN07  = '||T6.EDAN07||','
       ||'IDBSTT  = '||''''||T3.FDBSTT||''','
       ||'IDSRP8  = '||''''||(SELECT DECODE(TRIM(IBSRP8), 
                                                'C', 'M', 
                                                'P', 'L', 
                                             IBSRP8) 
                                FROM PRODDTA.F4102 
                               WHERE IBLITM = T2.CDLITM 
                                 AND ROWNUM = 1)||''','
       ||'IDEV02  = '||''''||'P'||''''||       
 ' WHERE IDUKID = '||T2.CDUKID|| 
     ' AND IDDOCO = '||T2.CDDOCO||
     ' AND IDDCTO = '||''''||T2.CDDCTO||''''|| 
     ' AND IDLNID = '||T2.CDLNID||
     ';' || chr(10) ||chr(10)||
     
' UPDATE PRODDTA.F554201C SET ' 
       ||'CHBNNF  = '||T4.FHBNNF              ||','
       ||'CHBSER  = '||T4.FHBSER              ||','
       ||'CHN001  = '||T4.FHN001              ||','
       ||'CHDCT   = '||''''||T4.FHDCT||''''   ||','
       ||'CHBSR0  = '||''''||T4.FHBSR0||''''  ||','
       ||'CHBBRCD = '||''''||T5.NEBBRCD||'''' ||','
       ||'CHISSU  = '||T4.FHISSU              ||','
       ||'CHBVTN  = '||(T3.FDAEXP + T3.FDBVIS)||','
       ||'CHBVTM  = '||(T3.FDAEXP)            ||','
       ||'CHBDES  = '||(T6.EDAN05 - T6.EDAN07)||','
       ||'CHBBCL  = '||(T3.FDBBCL)            ||','
       ||'CHBBIS  = '||(T3.FDBBIS)            ||','
       ||'CHBICM  = '||(T3.FDBICM)            ||','
       ||'CHBREP  = '||(T6.EDAN07)            ||','
       ||'CHTOQN  = '||(T4.FHTOQN)            ||','
       ||'CHAN01  = '||(T3.FDBVIS)            ||','
       ||'CHEV02  = '||'''P'''||              
 ' WHERE CHUKID = '|| CDUKID ||';' || chr(10) ||chr(10)||
 
 ' UPDATE PRODDTA.F554201I SET ' 
       ||'IHBNNF  = '||T4.FHBNNF              ||','
       ||'IHBSER  = '||T4.FHBSER              ||','
       ||'IHN001  = '||T4.FHN001              ||','
       ||'IHDCT   = '||''''||T4.FHDCT||''''   ||','
       ||'IHBSR0  = '||''''||T4.FHBSR0||''''  ||','
       ||'IHBBRCD = '||''''||T5.NEBBRCD||'''' ||','
       ||'IHISSU  = '||T4.FHISSU              ||','
       ||'IHBVTN  = '||(T3.FDAEXP + T3.FDBVIS)||','
       ||'IHBVTM  = '||(T3.FDAEXP)            ||','
       ||'IHBDES  = '||(T6.EDAN05 - T6.EDAN07)||','
       ||'IHBBCL  = '||(T3.FDBBCL)            ||','
       ||'IHBBIS  = '||(T3.FDBBIS)            ||','
       ||'IHBICM  = '||(T3.FDBICM)            ||','
       ||'IHBREP  = '||(T6.EDAN07)            ||','
       ||'IHTOQN  = '||(T4.FHTOQN)            ||','
       ||'IHAN01  = '||(T3.FDBVIS)            ||','
       ||'IHEV02  = '||'''P'''||              
 ' WHERE IHUKID = '|| CDUKID ||';'  
  FROM PRODDTA.F554201C   T1
       ,PRODDTA.F554211C  T2
       ,PRODDTA.F7611B   T3
       ,PRODDTA.F7601B   T4
       ,PRODDTA.F55NFE03 T5
       ,PRODDTA.F555511  T6
       ,PRODDTA.F42119    T7
 WHERE T1.CHUKID = T2.CDUKID
   AND T2.CDDOCO = T3.FDDOCO
   AND T2.CDLNID = T3.FDLNID
   AND T3.FDBNNF = T4.FHBNNF 
   AND T3.FDBSER = T4.FHBSER
   AND T3.FDN001 = T4.FHN001
   AND T3.FDDCT  = T4.FHDCT
   AND T3.FDDOCO = T5.NEDOCO
   AND T3.FDPDCT = T5.NEDCTO
   AND T3.FDBNNF = T5.NEBNNF
   AND T3.FDBSER = T5.NEBSER
   AND T3.FDN001 = T5.NEN001
   AND T3.FDBNNF = T6.EDBNNF
   AND T3.FDBSER = T6.EDBSER
   AND T3.FDN001 = T6.EDN001
   AND T3.FDDCT  = T6.EDDCT
   AND T3.FDLNID = T6.EDLNID 
   AND T1.CHEV02 = ' '
   AND T1.CHEV01 = 'Y'
   AND T1.CHTRDJ >= 122314  
   AND T5.NERCD1 = '100'
   AND T3.FDDOCO = T7.SDDOCO 
   AND T3.FDLNID = T7.SDLNID
   AND T7.SDLTTR < = 620 
   AND T7.SDLTTR > = 600;



--pedidos cancelados
 SELECT CHUKID
        ,CHDOCO
        ,CDLITM
        ,CDLNID 
        ,'UPDATE PRODDTA.F554211C SET CDEV01 = ''C'' WHERE CDUKID = '||CHUKID ||' AND CDLNID = '||CDLNID ||';'|| CHR(10)||CHR(10)||
        'UPDATE PRODDTA.F554211I SET IDEV01 = ''C'' WHERE IDUKID = '||CHUKID ||' AND IDLNID = '||CDLNID ||';'|| CHR(10)||CHR(10)||
        'UPDATE PRODDTA.F554201C SET CHEV01 = ''C'' WHERE CHUKID = '||CHUKID ||';'|| CHR(10)||CHR(10)||
        'UPDATE PRODDTA.F554201I SET IHEV01 = ''C'' WHERE IHUKID = '||CHUKID ||';'|| CHR(10)||CHR(10)
 FROM PRODDTA.F554201C
      ,PRODDTA.F554211C
 WHERE CHUKID = CDUKID
 AND CHDOCO = CDDOCO
 AND CHEV02 = ' '
 AND CHEV01 = 'Y'
 AND CHTRDJ >= 122314
 AND EXISTS (SELECT * FROM PRODDTA.F42119 
              WHERE SDDOCO = CDDOCO
                AND SDLITM = CDLITM
                AND SDLNID = CDLNID
                AND SDLTTR BETWEEN '980' AND '989'); 
