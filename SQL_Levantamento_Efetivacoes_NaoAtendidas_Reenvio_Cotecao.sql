select edildcot.db_edild_seq as Lote_Cotação,
       edildcot.db_edild_distr as Num_Van_Cotação,
       edildcot.db_edild_data as DataHora_ProcessArqCOT,
       edildcot.db_edild_nomearq as NomeArquivo_Cotação,
       to_date(to_char(substr(edildcot.db_edild_conteudo,21,13)),'dd/mm/yyyy hh24:mi:ss') as DataHora_Vencimento_COT,      
       edipcot.db_edip_pedmerc as PedidoMercanet_Cotação,
       pedcot.db_ped_data_envio as DataHora_envio_para_JDE_COT,
       jdecot.saukid as UKID_Cotação,
       jdecot.saedbt as Codigo_Processamento_COT,
       jdecot.saedsp as Status_Processamento_COT,
       jdecot.saupmj as Data_Processamento_COT,
       jdecot.satday as Hora_Processamento_COT,
       edildefet.db_edild_seq as Lote_Efetivação,
       edildefet.db_edild_distr as Lote_Efetivação,
       edildefet.db_edild_data as DataHora_ProcessArqEFET,
       edildefet.db_edild_nomearq as NomeArquivo_Efetivação,
       edipefet.db_edip_pedmerc as PedidoMercanet_Efetivação,
       pedefet.db_ped_data_envio as DataHora_envio_para_JDE_EFET,     
       jdeefet.saukid as UKID_Efetivação,
       jdeefet.saedbt as Codigo_Processamento_EFET,
       jdeefet.saedsp as Status_Processamento_EFET,
       jdeefet.saupmj as Data_Processamento_EFET,
       jdeefet.satday as Hora_Processamento_EFET

  from mercanet_prd.db_edi_lote_distr edildcot
  left join mercanet_prd.db_edi_pedido edipcot
    on edildcot.db_edild_seq = edipcot.db_edip_lote
   and edipcot.db_edip_van = 529
  left join mercanet_prd.db_edi_pedido edipefet
    on edipcot.db_edip_txt1 = edipefet.db_edip_txt1
   and edipefet.db_edip_van = 530
  left join mercanet_prd.db_edi_lote_distr edildefet
   on edipefet.db_edip_lote = edildefet.db_edild_seq
  left join mercanet_prd.db_pedido pedcot
   on edipcot.db_edip_pedmerc = pedcot.db_ped_nro 
  left join mercanet_prd.db_pedido pedefet
   on edipefet.db_edip_pedmerc = pedefet.db_ped_nro
  left join mercanet_prd.f5547011 jdecot
    on edipcot.db_edip_txt1 =  jdecot.sadocd 
   and to_char(pedcot.db_ped_nro) = trim(jdecot.savr01)
   and jdecot.saz55ori = 'CTC'
  left join mercanet_prd.f5547011 jdeefet
    on jdeefet.sadocd =  jdecot.sadocd 
   and to_char(pedefet.db_ped_nro) = trim(jdeefet.savr01)
   and jdeefet.saz55ori = 'PTC' 
 where exists (select edild.db_edild_nomearq, count(1)
          from mercanet_prd.db_edi_lote_distr edild
         where edild.db_edild_layout = 'COTFACIL_COT'
           and edild.db_edild_data >
               TO_DATE('03/04/2015 00:00:00', 'DD/MM/YYYY hh24:mi:ss')
           and edild.db_edild_nomearq = edildcot.db_edild_nomearq
         group by db_edild_nomearq
        having count(1) > 1)
   --and edildcot.db_edild_nomearq = 'COTACAO_196104.txt'
order by edildcot.db_edild_data, edildcot.db_edild_nomearq 
  

   
