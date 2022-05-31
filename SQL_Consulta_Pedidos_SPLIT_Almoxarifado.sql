select fdbnnf, fdn001, fdlitm, fddsc1, fddoco, count(*)
  from crpdta.f7611b
 where fdissu = 111196
   and fdpdct = 'OL'
   and fddct = 'NS'
 group by fdbnnf, fdn001, fdlitm, fddoco, fddsc1
having count(*) > 1