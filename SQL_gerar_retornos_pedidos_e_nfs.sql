
                                  --Limpeza das tabelas para regerar o retorno de pedidos



begin

update db_edi_pedido set db_edip_dtenvio=null where DB_EDIP_PEDMERC in ('80012004');

update db_pedido_distr set DB_PEDT_DTRET=null where DB_PEDT_PEDIDO in ('80012004');

end;

 

-- Formato de limpeza em que deixo o data_envio null nas tabelas db_edi_pedido e db_pedido_distr conforme data de envio do retorno e VAN.

begin

update db_edi_pedido set db_edip_dtenvio=null where db_edip_dtenvio >= to_date('11/08/2011') and DB_EDIP_VAN ='504';

update db_pedido_distr set DB_PEDT_DTRET=null where DB_PEDT_DTRET >= to_date('11/08/2011') and db_pedt_distr ='504';

end;

 

-- Formato de limpeza em que deixo o data_envio null nas tabelas db_edi_pedido e db_pedido_distr conforme VAN e recebimento dos arquivos. 

begin

update db_edi_pedido a set a.db_edip_dtenvio=null where a.DB_EDIP_VAN ='511' and exists (

select * from db_edi_lote_distr b where a.db_edip_lote=b.db_edild_seq and b.db_edild_data >= to_date('12/05/2011'));

update db_pedido_distr a set a.DB_PEDT_DTRET=null where a.db_pedt_distr ='511' and exists (

select * from db_edi_pedido b where a.DB_PEDT_PEDIDO=b.DB_EDIP_PEDMERC and exists (

select * from db_edi_lote_distr c where b.db_edip_lote=c.db_edild_seq and c.db_edild_data >= to_date('12/05/2011')));

end;


--REGERAR RETORNO DE NOTAS FISCAIS
 
update db_nota_fiscal
   set db_nota_dt_envio = NULL
 where db_nota_nro in
       (660683, 660685, 660679, 660678, 660681, 660682, 660680);




--APAGAR LOG DE EXPORTAÇÃO

DELETE FROM DB_EDI_LOG_EXP
 WHERE DB_EDILE_EDIA_CODI = 'SEVENPDV_RET'
   AND EXISTS (SELECT *
          FROM DB_EDI_PEDIDO
         WHERE DB_EDIP_NRO       = DB_EDILE_EDIP_NRO
           AND DB_EDIP_COMPRADOR = DB_EDILE_EDIP_COMP
           AND DB_EDIP_LOTE BETWEEN 9009 AND 9009)
           
           
           
           
           
           /*
           SELECT * FROM DB_EDI_LOG_EXP
           WHERE DB_EDILE_EDIP_NRO IN ('0000549785',
'0000549968',
'0000549215',
'0000549450',
'0000549494',
'0000550410',
'0000552534')*/