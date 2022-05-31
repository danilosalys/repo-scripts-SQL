--Data de Criação do Script: 04/07/2013
--Por: Danilo Sales
--Importante: 1) A principio, a query somente retornará os valores após o término da execução do Integrator de Pedidos, 
--               pois há joins com o campo LNID.
--            2) Esta sendo executada a partir do Banco DC10. Caso queira executar a partir dos bancos DC12 e DC09, trocar
--               os DBLinks. 
--            3) Ao adicionar colunas, colocar a função MAX(), pois é feito o agrupamento somente pelo campo LNID em função
--               dos produtos que são processados com Split de Almoxarifado.
--            4) Adicionar os Numeros dos Pedidos Mercanet onde há o comentário indicando 

select *
  from (select distinct max(db_edii_seq),
                        max(db_edii_produto),
                        max(db_edii_qtde_vda),
                        max(db_edii_bonif),
                        max(db_pdit_seq),
                        max(db_pdit_produto),
                        max(db_pdit_qtdeenv),
                        max(db_pdit_edii_seq),
                        max(db_pedi_sequencia),
                        max(db_pedi_produto),
                        max(db_pedi_qtde_solic),
                        max(savr01),
                        max(sbukid),
                        max(sbseq),
                        max(sblitm),
                        max(sbuorg),
                        max(sbuom),
                        max(sbstdslpr || sbuprc),
                        max(FLOOR(sblnid / 1000)),
                        max(sdlnid),
                        max(sdlitm),
                        sum(sduorg),
                        max(sddoco),
                        max(sdoorn)
          from mercanet_qa.db_edi_pedprod@dc12.drogacenter.com.br,
               mercanet_qa.db_pedido_distr_it@dc12.drogacenter.com.br,
               mercanet_qa.db_pedido_prod@dc12.drogacenter.com.br,
               qadta.f5547012,
               qadta.f5547011,
               (select sum(FLOOR(sdlnid / 1000)) as sdlnid,
                       sdlitm,
                       sduorg,
                       sddoco,
                       sdoorn
                  from qadta.f4211
                 where sdoorn in to_char(&"'PEDIDO'") --// <-- Inserir o Numero do Pedido Mercanet
                 group by sdlnid, sdlitm, sduorg, sddoco, sdoorn
                 order by sdlnid)
         where db_edii_pedmerc in (&"'PEDIDO'") --// <-- Inserir o Numero do Pedido Mercanet
           and db_edii_pedmerc = db_pdit_pedido
           and db_edii_seq = db_pdit_edii_seq
           and db_edii_qtde_vda = db_pdit_qtdeenv
           and db_pdit_pedido = db_pedi_pedido
           and db_pdit_produto = db_pedi_produto
           and db_pdit_qtdeenv = db_pedi_qtde_solic
           and to_char(db_pedi_pedido) = trim(savr01)
           and saukid = sbukid
           and db_pedi_produto = trim(sblitm)
           and db_pedi_sequencia = sbseq
           and (case
                 when sadcto <> 'OL' then
                  0
                 else
                  FLOOR(sblnid / 1000)
               end) = (case
                 when sadcto <> 'OL' then
                  0
                 else
                  sdlnid
               end)
           and sblitm = sdlitm
           and trim(sdoorn) = trim(savr01)
           and sadoco = sddoco
         group by sdlnid);
/*      
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
*/
