----- sql 1 -- por nota

select distinct fdan8, fddoco , fdbnnf, fdbser, fdn001, fdpdct, fdissu, sdoorn , db_edile_edia_codi, db_edile_arquivo
from proddta.f7611b, proddta.f42119, mercanet_prd.db_edi_pedido@dc09, mercanet_prd.db_edi_log_exp@dc09
where fdbnnf in (410583,413354,423735)
and fdan8 in (34958,31266,34958)
and fdlitm = '24076'
and fdissu > 114065
and fddoco = sddoco
and trim(sdoorn) = to_char(db_edip_pedmerc)
and db_edip_nro = db_edile_edip_nro
and db_edip_comprador = db_edile_edip_comp
and db_edile_edia_codi = 'FIDELIZE_NOT'
and fddoco = sddoco
and trim(sdoorn) = to_char(db_edip_pedmerc)
and db_edip_nro = db_edile_edip_nro
and db_edip_comprador = db_edile_edip_comp; 




------ sql 2 --pesquisa interior do arquivo de retorono
SELECT db_edip_comprador,
       (NVL(nvl(substr(db_edip_nro, 1, instr(db_edip_nro, '-', 1, 1) - 1),
                db_edip_nro),
            0)) "Pedido Fidelize",
       db_nota_ped_merc as "Pedido Mercanet",
       db_nota_ped_orig as "Pedido JDE",
       db_nota_nro as "Numero da Nota",
       db_nota_serie as "Serie",
       db_nota_tipodoc as "Tipo da Nota",
       db_nota_dt_emissao as "Data de Emissão",
       to_number(substr(db_edile_conteudo,
                        instr(db_edile_conteudo, ';', 1, 7) + 1,
                        (instr(db_edile_conteudo, ';', 1, 8) - 2) -
                        instr(db_edile_conteudo, ';', 1, 7) + 1)) as "Num Nota no Arquivo",
       db_edile_arquivo as "Arquivo Retornado a Fidelize",
       db_nota_dt_envio as "Data/Hora de Envio do Arquivo"

  FROM MERCANET_PRD.DB_NOTA_FISCAL,
       MERCANET_PRD.DB_EDI_PEDIDO,
       MERCANET_PRD.DB_EDI_LOG_EXP
 WHERE DB_EDIP_PEDMERC = DB_NOTA_PED_MERC
   AND DB_EDIP_VAN = 517
   AND DB_EDIP_NRO = DB_EDILE_EDIP_NRO
   AND DB_EDIP_COMPRADOR = DB_EDILE_EDIP_COMP
   AND DB_EDILE_EDIA_CODI = 'FIDELIZE_NOT'
   and to_number(substr(db_edile_conteudo,
                        instr(db_edile_conteudo, ';', 1, 7) + 1,
                        (instr(db_edile_conteudo, ';', 1, 8) - 2) -
                        instr(db_edile_conteudo, ';', 1, 7) + 1)) =
       db_nota_nro
   AND DB_NOTA_PED_ORIG IN (17896991,17903999,17908141,17909398,17910815,17932409,17932423,17932427,17932433,17932437,17932441,17932445)
