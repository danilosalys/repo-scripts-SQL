----CONSULTA 
select fhbnnf,
       fhbser,
       fhdct,
       fhn001,
       fhissu,
       fhan8,
       TO_DATE(FHISSU + 1900000, 'YYYYDDD')
  from proddta.f7601b@dch9 a
 where fhbnnf in (32364)
   and fhdct in ('NS')
   and (fhan8 in ('564939') OR TO_DATE(FHISSU+1900000,'YYYYDDD') BETWEEN '05/11/2012' AND '05/11/2012')
   and not exists (select *
          from proddta.f7601b b
         where fhbnnf in (32364)
           and fhdct in ('NS')
           and (TO_DATE(FHISSU+1900000,'YYYYDDD') BETWEEN '05/11/2012' AND '05/11/2012'
             or fhan8 in ('564939'))
           and a.fhbnnf = b.fhbnnf
           and a.fhn001 = b.fhn001);

---INSERIR
----------------------------------------------------------------------------------------------------------------------           
 insert into proddta.f7601b
  select *
          from proddta.f7601b@dch9 a
         where fhbnnf in (32364)
           and FHN001 in (14727216)
           and not exists (select *
                  from proddta.f7601b b
                 where fhbnnf in (32364)
                   and FHN001 in (14727216)
                   and a.fhbnnf = b.fhbnnf
                   and a.fhn001 = b.fhn001);

insert into proddta.f7611b
  select *
    from proddta.f7611b@dch9 a
   where fdbnnf in (32364)
     and FDN001 IN (14727216)
     and not exists (select distinct fdbnnf, fdbser, fdn001, fddoco
            from proddta.f7611b b
           where fdbnnf in (32364)
             and FDN001 IN (14727216)
             and a.fdbnnf = b.fdbnnf
             and a.fdn001 = b.fdn001);

insert into proddta.f42119 a
  select *
    from proddta.f42119@dch9 b
   where b.sddoco in (12085773, 18893113,12768907)
     and not exists
   (select * from proddta.f42119 c where b.sddoco = c.sddoco);

insert into proddta.f42019 a
  select *
    from proddta.f42019@dch9 b
   where b.shdoco in (12085773, 18893113,12768907)
     and not exists
   (select * from proddta.f42019 c where b.shdoco = c.shdoco)
