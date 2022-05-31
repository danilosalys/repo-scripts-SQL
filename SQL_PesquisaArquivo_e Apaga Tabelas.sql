--EXECUTAR NO BANCO DC09 - MERCANET_PRD

SET SERVEROUTPUT ON;

BEGIN 

--1
delete from mercanet_prd.db_edi_log_exp
where exists (select *
          from mercanet_prd.db_edi_pedido
         where db_edip_nro = db_edile_edip_nro 
           and db_edip_comprador = db_edile_edip_comp
           and db_edip_lote in (12025954,12026251,12035593)); 

DBMS_OUTPUT.put_line ('Script 1, Linhas afetadas: '|| SQL%ROWCOUNT);
           
--2
delete from mercanet_prd.db_pedido_prod a
where exists
(select *
          from mercanet_prd.db_pedido b
         where exists
         (select *
                  from mercanet_prd.db_edi_pedido c
                 where c.db_edip_pedmerc = b.db_ped_nro
                   and c.db_edip_lote in (12025954,12026251,12035593)) 
           and b.db_ped_nro = a.db_pedi_pedido);

DBMS_OUTPUT.put_line ('Script 2, Linhas afetadas: '|| SQL%ROWCOUNT);

--3
delete from mercanet_prd.db_pedido a
where exists (select *
          from mercanet_prd.db_edi_pedido b
         where b.db_edip_pedmerc = a.db_ped_nro
           and b.db_edip_lote in (12025954,12026251,12035593)); 
           
DBMS_OUTPUT.put_line ('Script 3, Linhas afetadas: '|| SQL%ROWCOUNT);

--4
delete from mercanet_prd.db_pedido_distr_it a
where exists (select *
          from mercanet_prd.db_pedido_distr b
         where exists (select *
                  from mercanet_prd.db_edi_pedido c
                 where c.db_edip_pedmerc = b.db_pedt_pedido
                   and c.db_edip_lote in (12025954,12026251,12035593)) 
           and b.db_pedt_pedido = a.db_pdit_pedido);
           
DBMS_OUTPUT.put_line ('Script 4, Linhas afetadas: '|| SQL%ROWCOUNT);

--5
delete from mercanet_prd.db_pedido_distr a
where exists (select *
          from mercanet_prd.db_edi_pedido b
         where b.db_edip_pedmerc = a.db_pedt_pedido
           and b.db_edip_lote in (12025954,12026251,12035593)); 
           
DBMS_OUTPUT.put_line ('Script 5, Linhas afetadas: '|| SQL%ROWCOUNT);           
           
--6
delete from mercanet_prd.db_edi_pedprod
where exists (select *
          from mercanet_prd.db_edi_pedido
         where db_edip_lote in (12025954,12026251,12035593) 
           and db_edip_comprador = db_edii_comprador
           and db_edip_nro = db_edii_nro);

DBMS_OUTPUT.put_line ('Script 6, Linhas afetadas: '|| SQL%ROWCOUNT);

--7
delete from mercanet_prd.db_edi_pedido where db_edip_lote in (12025954,12026251,12035593); 

DBMS_OUTPUT.put_line ('Script 7, Linhas afetadas: '|| SQL%ROWCOUNT);

--8
delete from mercanet_prd.db_edi_lote_distr where db_edild_seq in (12025954,12026251,12035593); 

DBMS_OUTPUT.put_line ('Script 8, Linhas afetadas: '|| SQL%ROWCOUNT);

--9
delete from mercanet_prd.db_edi_ldistr_log where db_edill_seq_lote in (12025954,12026251,12035593);

DBMS_OUTPUT.put_line ('Script 9, Linhas afetadas: '|| SQL%ROWCOUNT);

END;
/
