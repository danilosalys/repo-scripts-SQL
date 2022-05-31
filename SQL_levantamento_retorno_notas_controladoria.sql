--DC01
--create table NOTAS_CONTROLADORIA(nf NUMBER,cnpj VARCHAR2(14), codigocliente NUMBER, datanf DATE)
select t1.nf NOTA_FISCAL,
       t3.fdan8 CODIGO_CLIENTE,
       t1.datanf DATA_NF,
       t3.fddoco PEDIDO_JDE,
       t4.sdoorn PEDIDO_MERCANET,
       ltrim(t5.db_edip_obs1, '0') "NUMERO_ARQUIVO_SP(SEVENPDV)",
       case
         when t5.db_edip_van = 508 then
          t5.db_edip_obs1 
         else 
           case
             when t5.db_edip_van = 543 then
              t5.db_edip_nro
             else
              LTRIM(SUBSTR(t5.DB_EDIP_NRO,
                           1,
                           INSTR(t5.DB_EDIP_NRO, '-', 1, 1) - 1),
                    '0')
       end end as PEDIDO_VAN,
       REPLACE(t6.db_edile_arquivo,'.TEMP','') AS "ARQUIVO RETORNO ENVIADO A VAN",
     (select db_nota_dt_envio  
        from mercanet_prd.db_nota_fiscal@dc09
       where t5.db_edip_pedmerc = db_nota_ped_merc
         and rownum = 1) as "DATA DE ENVIO DA NOTA P/ VAN"
  from notas_controladoria t1,
       proddta.f7601b t2,
       proddta.f7611b t3,
       proddta.f42119 t4,
       (select *
          from (select *
                  from mercanet_hist.db_edi_pedido_hist@dch9
                union all
                select * from mercanet_prd.db_edi_pedido@dc09)) t5,
       (select *
          from (select db_edile_edip_comp,
                       db_edile_edip_nro,
                       db_edile_edia_codi,
                       db_edile_arquivo
                  from mercanet_prd.db_edi_log_exp@dc09
                union
                select db_edile_edip_comp,
                       db_edile_edip_nro,
                       db_edile_edia_codi,
                       db_edile_arquivo
                  from mercanet_prd.db_edi_log_exp_hist@dc09
                union
                select db_edile_edip_comp,
                       db_edile_edip_nro,
                       db_edile_edia_codi,
                       db_edile_arquivo
                  from mercanet_prd.db_edi_log_exp_hist@dc09)) t6
 where t2.fhbnnf = t1.nf
 --  and t2.fhan8 = t1.codigocliente
   and t2.fhissu between
       to_number(to_char(t1.DATANF, 'YYYYDDD') - 1900000) - 4 and
       to_number(to_char(t1.DATANF, 'YYYYDDD') - 1900000) + 4
   and t2.fhdct = 'NS'
   and t2.fhbnnf = t3.fdbnnf
   and t2.fhbser = t3.fdbser
   and t2.fhn001 = t3.fdn001
   and t2.fhdct = t3.fddct
   and t3.fddoco = t4.sddoco
   and t3.fdpdct = t4.sddcto
   and t3.fdkcoo = t4.sdkcoo
   and t3.fdlnid = t4.sdlnid
   and t4.sdoorn = TO_CHAR(t5.db_edip_pedmerc)
   and t5.db_edip_comprador = t6.db_edile_edip_comp(+)
   and t5.db_edip_nro = t6.db_edile_edip_nro (+)
   --and t6.db_edile_edia_codi = (SELECT EM01_LARQNF FROM MERCANET_PRD.MEM01@DC09 WHERE T5.DB_EDIP_VAN = EM01_CODIGO)
   and t5.db_edip_pedmerc in (94815895,94815727,94816003,94815824,94876354,95034959)
 group by t1.nf,
          t1.codigocliente,
          t1.datanf,
          t3.fddoco,
          t4.sdoorn,
          t3.fdan8,
          t5.db_edip_obs1,
          t5.db_edip_van,
          t5.DB_EDIP_NRO,
          t6.db_edile_arquivo,
          t5.db_edip_pedmerc
  
-- SELECT * FROM notas_controladoria - seven

SELECT DB_EDILE_ARQUIVO,
       DB_EDII_COMPRADOR||
       DB_EDII_PRODUTO||
       NVL((DB_EDIP_OBS1),' ')||
       'A'||
       '000'||
       lpad(to_char(fduorg),4,'0')||
       (LPAD(TO_CHAR(fdbnnf),15,'0'))||
       TO_CHAR(TO_DATE(TO_CHAR(FDISSU + 1900000), 'YYYYDDD') , 'YYYYMMDD')||
       LPAD(REPLACE(TRIM(TO_CHAR(ROUND(DB_EDII_PERC_DCTO, 2), '9999.99')),'.',''),5,'0')||
       DB_EDII_PROJETO||
       NVL((DB_EDIP_ORDCOMPRA),'000000000000000') 
       
  FROM dsales.notas_seven@dc09,
       proddta.f7601b t2,
       proddta.f7611b t3,
       proddta.f42119 t4
 WHERE  t2.fhdct = 'NS'
   and t2.fhbnnf = t3.fdbnnf
   and t2.fhbser = t3.fdbser
   and t2.fhn001 = t3.fdn001
   and t2.fhdct = t3.fddct
   and t3.fddoco = t4.sddoco
   and t3.fdpdct = t4.sddcto
   and t3.fdkcoo = t4.sdkcoo
   and t3.fdlnid = t4.sdlnid
   and t3.fddoco in  (51977461,51977097,51977765,51977268,52137240,52503080)
   and t4.sdoorn = TO_CHAR(db_edip_pedmerc)
   and trim(t4.sdlitm) = to_char(db_pedi_produto)
   
