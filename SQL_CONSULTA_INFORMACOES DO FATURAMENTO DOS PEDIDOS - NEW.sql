select distinct db_edild_nomearq, db_ped_data_envio,db_edip_dtenvio, db_edip_pedmerc, 
                sddoco,sddcto,sdlnty,sdan8,sdzon,sdlttr,sdnxtr,sdemcu,sdmcu,sddct,sddoc,
                sdurat,sdurab,shhold, fdbnnf, fdbser, fdn001 , ncrcd1, ncud
  from mercanet_prd.db_edi_lote_distr@dc09 a,
       mercanet_prd.db_edi_pedido@dc09 b,
       mercanet_prd.db_pedido@dc09 c,
       proddta.f5547011 d,
       proddta.f4201 e,
       proddta.f4211 f,
       proddta.f7611b g,
       proddta.f55nfe02
 where db_edip_pedmerc = db_ped_nro
   and sadoco = shdoco
   and shdoco = sddoco
   and sdlnty = 'BS'
   and fddoco = sddoco
   and ncbnnf = fdbnnf
   and ncbser = fdbser
   and ncn001 = fdn001
   and ncrcd1 != '   '
   and db_edild_seq = db_edip_lote
   and to_char(db_ped_nro) = trim(savr01)
   and db_edild_nomearq in
       ('PEDIDO_2013042400001043441H_06112317000104.txt',
        'PEDIDO_2013042400001043451H_02740058000105.txt')
       union 
select distinct db_edild_nomearq, db_ped_data_envio,db_edip_dtenvio, db_edip_pedmerc, 
                sddoco,sddcto,sdlnty,sdan8,sdzon,sdlttr,sdnxtr,sdemcu,sdmcu,sddct,sddoc,
                sdurat,sdurab,shhold, fdbnnf, fdbser, fdn001 , ncrcd1, ncud
  from mercanet_prd.db_edi_lote_distr@dc09 a,
       mercanet_prd.db_edi_pedido@dc09 b,
       mercanet_prd.db_pedido@dc09 c,
       proddta.f5547011 d,
       proddta.f42019 e,
       proddta.f42119 f,
       proddta.f7611b g,
       proddta.f55nfe02
 where db_edip_pedmerc = db_ped_nro
   and sadoco = shdoco
   and shdoco = sddoco
   and sdlnty = 'BS'
   and fddoco = sddoco
   and ncbnnf = fdbnnf
   and ncbser = fdbser
   and ncn001 = fdn001
   and ncrcd1 != '   '
   and db_edild_seq = db_edip_lote
   and to_char(db_ped_nro) = trim(savr01)
   and db_edild_nomearq in
       ('PEDIDO_2013042400001043441H_06112317000104.txt',
        'PEDIDO_2013042400001043451H_02740058000105.txt')
union 
select distinct db_edild_nomearq, db_ped_data_envio,db_edip_dtenvio, db_edip_pedmerc, 
                sddoco,sddcto,sdlnty,sdan8,sdzon,sdlttr,sdnxtr,sdemcu,sdmcu,sddct,sddoc,
                sdurat,sdurab,shhold, null, null, null , null, null
  from mercanet_prd.db_edi_lote_distr@dc09 a,
       mercanet_prd.db_edi_pedido@dc09 b,
       mercanet_prd.db_pedido@dc09 c,
       proddta.f5547011 d,
       proddta.f4201 e,
       proddta.f4211 f
 where db_edip_pedmerc = db_ped_nro
   and sadoco = shdoco
   and shdoco = sddoco
   and sdlnty = 'BS'
   and db_edild_seq = db_edip_lote
   and to_char(db_ped_nro) = trim(savr01)
   and db_edild_nomearq in
       ('PEDIDO_2013042400001043441H_06112317000104.txt',
        'PEDIDO_2013042400001043451H_02740058000105.txt')
        union
select distinct db_edild_nomearq, db_ped_data_envio,db_edip_dtenvio, db_edip_pedmerc, 
                sddoco,sddcto,sdlnty,sdan8,sdzon,sdlttr,sdnxtr,sdemcu,sdmcu,sddct,sddoc,
                sdurat,sdurab,shhold, null, null, null , null, null
  from mercanet_prd.db_edi_lote_distr@dc09 a,
       mercanet_prd.db_edi_pedido@dc09 b,
       mercanet_prd.db_pedido@dc09 c,
       proddta.f5547011 d,
       proddta.f4201 e,
       proddta.f42119 f
 where db_edip_pedmerc = db_ped_nro
   and sadoco = shdoco
   and shdoco = sddoco
   and sdlnty = 'BS'
   and db_edild_seq = db_edip_lote
   and to_char(db_ped_nro) = trim(savr01)
   and db_edild_nomearq in
       ('PEDIDO_2013042400001043441H_06112317000104.txt',
        'PEDIDO_2013042400001043451H_02740058000105.txt')
  union
select distinct db_edild_nomearq, db_ped_data_envio,db_edip_dtenvio, db_edip_pedmerc, 
                sddoco,sddcto,sdlnty,sdan8,sdzon,sdlttr,sdnxtr,sdemcu,sdmcu,sddct,sddoc,
                sdurat,sdurab,shhold, null, null, null , null, null
  from mercanet_prd.db_edi_lote_distr@dc09 a,
       mercanet_prd.db_edi_pedido@dc09 b,
       mercanet_prd.db_pedido@dc09 c,
       proddta.f5547011 d,
       proddta.f42019 e,
       proddta.f42119 f
 where db_edip_pedmerc = db_ped_nro
   and sadoco = shdoco
   and shdoco = sddoco
   and sdlnty = 'BS'
   and db_edild_seq = db_edip_lote
   and to_char(db_ped_nro) = trim(savr01)
   and db_edild_nomearq in
       ('PEDIDO_2013042400001043441H_06112317000104.txt',
        'PEDIDO_2013042400001043451H_02740058000105.txt')




