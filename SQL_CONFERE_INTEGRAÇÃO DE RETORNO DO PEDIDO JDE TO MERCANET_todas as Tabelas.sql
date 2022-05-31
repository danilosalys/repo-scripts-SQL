   
select db_edii_seq,
       db_edii_produto,
       db_edii_qtde_vda,
       db_edii_perc_dcto,
       db_edii_bonif
  from mercanet_qa.db_edi_pedprod@dc12.drogacenter.com.br
 where db_edii_pedmerc = 80072111;
select db_pdit_seq, db_pdit_produto, db_pdit_qtdeenv, db_pdit_edii_seq
  from mercanet_qa.db_pedido_distr_it@dc12.drogacenter.com.br
 where db_pdit_pedido = 80072111;
select db_pedi_sequencia, db_pedi_produto, db_pedi_qtde_solic
  from mercanet_qa.db_pedido_prod@dc12.drogacenter.com.br
 where db_pedi_pedido = 80072111;
select sbukid,
       sbseq,
       sblitm,
       sbuorg,
       sbuom,
       sbstdslpr || sbuprc,
       trunc(sblnid / 1000)
  from qadta.f5547012 a
 where sbukid in
       (select saukid from qadta.f5547011 where savr01 = '80072111');
select distinct max(sdlnid),
                max(sdlitm),
                sum(sduorg),
                max(sddoco),
                max(sdoorn)
  from (select sum(FLOOR(sdlnid / 1000)) as sdlnid,
               sdlitm,
               sduorg,
               sddoco,
               sdoorn
          from qadta.f4211
         where sdoorn = '80072111'
         group by sdlnid, sdlitm, sduorg, sddoco, sdoorn
         order by sdlnid)
 group by sdlnid
