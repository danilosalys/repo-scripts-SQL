 select *
  from CRPDTA.F7601B ,CRPDTA.F4211 
 where floor(SDDOC/100)         = FHBNNF
  and sddoco                 in ('87336', '87339', '87344')
   and lpad(mod(SDdoc,100),2,0) = FHBSER
  and sddcto                   = 'OL'
  and fhdct = 'NS'
  AND SDLITM <> 'BOLETO'
  AND FHAN8 IN (479028,455694,30303) 
   
   
   
   
SELECT * FROM CRPDTA.F5542456
   
SELECT * FROM DB_NOTA_FISCAL
WHERE TO_CHAR(DB_NOTA_DT_ENVIO, 'DD/MM/YYYY') = '02/06/2011'

SELECT * FROM DB_NOTA_PROD a
where a.db_notap_ped_orig in ()


select savr01 , sadoco from crpdta.f5547011 where savr01 in ('80012248',
                                        '80012249',
                                        '80012250',
                                        '80012251',
                                        '80012252',
                                        '80012253',
                                        '80012254',
                                        '80012255',
                                        '80012256',
                                        '80012257',
                                        '80012258',
                                        '80012259',
                                        '80012260',
                                        '80012261',
                                        '80012236',
                                        '80012237', 
                                        '80012238') 

