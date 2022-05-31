select db_edii_seq,
       db_edii_produto,
       db_edii_qtde_vda,
       db_edii_perc_dcto,
       db_edii_bonif,
       db_edii_valor1 / 100
  from MERCANET_PRD.db_edi_pedprod@DC09
 where db_edii_pedmerc = 81298930
;

select db_pdit_seq,
       db_pdit_produto,
       db_pdit_qtdeenv,
       db_pdit_qtdeatd,
       db_pdit_edii_seq,
       db_pdit_dcto
  from MERCANET_PRD.db_pedido_distr_it@DC09
 where db_pdit_pedido = 81298930
;

select db_pedi_sequencia,
       db_pedi_produto,
       db_pedi_qtde_solic,
       db_pedi_qtde_atend,
       db_pedi_qtde_canc,
       db_pedi_desctop
  from MERCANET_PRD.db_pedido_prod@DC09
 where db_pedi_pedido = 81298930
;

select sbukid,
       sbseq,
       sblitm,
       sbuorg,
       sbuom,
       sbstdslpr || sbuprc,
       trunc(sblnid / 1000)
  from PRODDTA.f5547012 a
 where sbukid in
       (select saukid from PRODDTA.f5547011 where savr01 = '81298930');

SELECT DISTINCT  SDLNID , SDLITM, SUM(SDUORG), SUM(SDSOQS),SUM(SDSOCN), SDDOCO, SDOORN  
FROM 
(select distinct sdlnid,
                sdlitm,
                sduorg,
                sdsoqs,
                sdsocn,
               sddoco,
                sdoorn
  from (select sum(FLOOR(sdlnid / 1000)) as sdlnid,
               sdlitm,
               sduorg,
               sddoco,
               sdoorn,
               sdsoqs,
               sdsocn
          from PRODDTA.f42119
         where sdoorn = '81298930'
         group by sdlnid, sdlitm, sduorg, sddoco, sdoorn, sdsocn, sdsoqs
         order by sdlnid)
UNION
select distinct sdlnid,
                sdlitm,
                sduorg,
                sdsoqs,
                sdsocn,
               sddoco,
                sdoorn
  from (select sum(FLOOR(sdlnid / 1000)) as sdlnid,
               sdlitm,
               sduorg,
               sddoco,
               sdoorn,
               sdsoqs,
               sdsocn
          from PRODDTA.f4211
         where sdoorn = '81298930'
         group by sdlnid, sdlitm, sduorg, sddoco, sdoorn, sdsocn, sdsoqs
         order by sdlnid)) GROUP BY SDLNID , SDLITM,SDDOCO, SDOORN  
;

select db_notap_nro,
       db_notap_serie,
       db_nota_ped_merc,
       db_notap_seq,
       db_notap_produto,
       db_notap_nroserie,
       db_notap_qtde,
       db_notap_aliq_rp
  from mercanet_prd.db_nota_fiscal@dc09, mercanet_prd.db_nota_prod@dc09
 where db_nota_nro = db_notap_nro
   and db_nota_serie = db_notap_serie
   and db_nota_ped_merc = 81298930
