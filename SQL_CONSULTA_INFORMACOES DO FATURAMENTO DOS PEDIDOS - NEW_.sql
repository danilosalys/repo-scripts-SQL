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
       ('PEDIDO_2012080600001040011H_12113472000130.txt',
        'PEDIDO_2012080600001040051H_02137966000109.txt',
        'PEDIDO_2012080600001040062H_04116437000146.txt',
        'PEDIDO_2012080600001040071H_54518220000130.txt',
        'PEDIDO_2012080600001040481H_12699305000112.txt',
        'PEDIDO_2012080700001040021H_01197441000198.txt',
        'PEDIDO_2012080700001040021H_13122598000133.txt',
        'PEDIDO_2012080700001040031H_22020994000302.txt',
        'PEDIDO_2012080700001040041H_22020994000655.txt',
        'PEDIDO_2012080700001040052H_12907198000170.txt',
        'PEDIDO_2012080700001040082H_50093442000106.txt',
        'PEDIDO_2012080700001040101H_03123210000327.txt',
        'PEDIDO_2012080700001040211H_22020994000140.txt',
        'PEDIDO_2012080700001040221H_21504311000168.txt',
        'PEDIDO_2012080700001040231H_22020994000493.txt',
        'PEDIDO_2012080700001040241H_22020994000817.txt',
        'PEDIDO_2012080700001040251H_22020994001031.txt',
        'PEDIDO_2012080700001040261H_22020994000906.txt',
        'PEDIDO_2012080700001040271H_06121153000173.txt',
        'PEDIDO_2012080800001040011H_04720731000162.txt',
        'PEDIDO_2012080800001040021H_19606664000127.txt',
        'PEDIDO_2012080800001040051H_38583332000119.txt')
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
       ('PEDIDO_2012080600001040011H_12113472000130.txt',
        'PEDIDO_2012080600001040051H_02137966000109.txt',
        'PEDIDO_2012080600001040062H_04116437000146.txt',
        'PEDIDO_2012080600001040071H_54518220000130.txt',
        'PEDIDO_2012080600001040481H_12699305000112.txt',
        'PEDIDO_2012080700001040021H_01197441000198.txt',
        'PEDIDO_2012080700001040021H_13122598000133.txt',
        'PEDIDO_2012080700001040031H_22020994000302.txt',
        'PEDIDO_2012080700001040041H_22020994000655.txt',
        'PEDIDO_2012080700001040052H_12907198000170.txt',
        'PEDIDO_2012080700001040082H_50093442000106.txt',
        'PEDIDO_2012080700001040101H_03123210000327.txt',
        'PEDIDO_2012080700001040211H_22020994000140.txt',
        'PEDIDO_2012080700001040221H_21504311000168.txt',
        'PEDIDO_2012080700001040231H_22020994000493.txt',
        'PEDIDO_2012080700001040241H_22020994000817.txt',
        'PEDIDO_2012080700001040251H_22020994001031.txt',
        'PEDIDO_2012080700001040261H_22020994000906.txt',
        'PEDIDO_2012080700001040271H_06121153000173.txt',
        'PEDIDO_2012080800001040011H_04720731000162.txt',
        'PEDIDO_2012080800001040021H_19606664000127.txt',
        'PEDIDO_2012080800001040051H_38583332000119.txt')
        
ORDER BY DB_EDILD_NOMEARQ
