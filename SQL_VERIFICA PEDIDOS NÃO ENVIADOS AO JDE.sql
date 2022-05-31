--28/06/2013
--Por Danilo Sales

--Pedidos com Data de Envio Populada sem Registro no JDE
--Motivos: Pedido s/ Condição de Pagamento
--         Pedido s/ Representante
select '1' as "CASE", a.*, b.*
  from mercanet_prd.db_pedido a,
       mercanet_prd.db_edi_pedido b,
       mercanet_prd.db_edi_lote_distr c
 where db_ped_data_envio is not null
   and db_ped_nro = db_edip_pedmerc
   and db_edip_lote = db_edild_seq
   and db_edild_data > to_date(sysdate - 30, 'dd/mm/yy')
   and not exists (select *
          from mercanet_prd.f5547011
         where to_char(db_ped_nro) = trim(savr01)
           and saoorn = 'MERCANET')
union
--Pedidos c/ Data de Envio Nula
select '2' as "Case", a.*, b.*
  from mercanet_prd.db_pedido a,
       mercanet_prd.db_edi_pedido b,
       mercanet_prd.db_edi_lote_distr c
 where db_ped_data_envio is null
   and db_ped_nro = db_edip_pedmerc
   and db_edip_lote = db_edild_seq
   and db_edild_data between to_date(sysdate - 30, 'dd/mm/yy') and to_date(sysdate-1, 'dd/mm/yy')


--Teste da rotina 
SELECT *
  FROM MERCANET_prd.DB_PEDIDO_COMPL, MERCANET_prd.DB_PEDIDO
 WHERE DB_PED_DATA_ENVIO IS NULL
   AND DB_PED_NRO = DB_PEDC_NRO
   AND (DB_PED_SITUACAO = 0 OR
       (DB_PED_SITUACAO = 1 AND EXISTS
        (SELECT 1
            FROM MERCANET_prd.DB_TB_TPPEDIDO
           WHERE DB_TBTPE_CODIGO = DB_PED_TIPO
             AND DB_TBTPE_OPERLOG = 1)))
