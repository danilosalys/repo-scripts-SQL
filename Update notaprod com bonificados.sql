
SELECT FDLITM DB_NOTAP_PRODUTO, 
       FDUORG DB_NOTAP_QTDE , 
       FDAEXP/100 DB_NOTAP_VALOR,
       FDBICM/100 DB_NOTAP_VLR_ICMS ,
       sduncs/10000 DB_NOTAP_CUSTO,
       EDAN05/100 db_notap_incentivo,
       EDAN05/100 DB_NOTAP_DESPESAS,
       FDBBCL/100 DB_NOTAP_BASE_ICMS,
       FDBBIS/10000 DB_NOTAP_BSUB_ICMS,
       EDAN04/100 DB_NOTAP_DCTO_FIN ,
       round((((sdlprc/10000)*to_number(trim(sbuom)||','|| trim(nvl(sbhold,0))))/100),2) DB_NOTAP_VLR_RP
FROM CRPDTA.F7611B,CRPDTA.F4211,CRPDTA.F555511 a ,CRPDTA.F5547012, CRPDTA.F5547011
WHERE SAUKID = SBUKID 
AND SADOCO = SDDOCO 
AND TRIM(SBLITM) = TRIM(SDLITM)
AND SDUORG = SBUORG 
AND FDBNNF = 10465
AND FDBSER = 03
AND sddoco = fddoco 
and Sddcto = fdpdct 
and Sdlitm  = fdlitm  
and Sdlnid  = fdlnid 
and Sdlnty  = 'BS'
and fdbnnf = a.edbnnf
and fdbser = a.edbser
and fdn001 = a.edn001
and fdlnid = a.edlnid
