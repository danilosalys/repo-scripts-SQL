update crpdta.f55mcn01
set fhev01 = ' '
WHERE fhbnnf = 1266
and fhn001 = 99197 
and fhbser = '01'
and fhdct = 'NS'


SELECT FHUKID,
       FHBNNF,
       FHBSER,
       FHN001,
       FHDCT,
       FHEFTB,
       FHBEGT,
       FHEV01,
       FHUSER,
       FHPID,
       FHJOBN,
       FHUPMJ,
       FHTDAY, 
       COUNT(FHBNNF) 
    FROM crpdta.f55mcn01
WHERE 
FHBNNF IN ('1257','1257','1258','1259','1262','1263','1264','1265','1266')
GROUP BY FHUKID,FHBNNF,FHBSER,FHN001,FHDCT,FHEFTB,FHBEGT,FHEV01,FHUSER,FHPID,FHJOBN,FHUPMJ,FHTDAY




/*fhbnnf = 1257
and fhn001 = 99188 
and fhbser = '01'
and fhdct = 'NS'*/


