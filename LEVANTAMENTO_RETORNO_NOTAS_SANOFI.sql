select "CNPJ do Cliente",
       "Pedido",
       "Pedido Drogacenter",
       case
         when db_nota_nro is null then
          (select max(NVL(nvl(substr(db_pedi_atd_dcto,
                                     1,
                                     instr(db_pedi_atd_dcto, '-', 1, 1) - 1),
                              db_pedi_atd_dcto),
                          0))
             from mercanet_prd.db_pedido_prod
            where "Pedido Drogacenter" = db_pedi_pedido)
         else
          to_char(db_nota_nro)
       end as "Numero da Nota",
       case
         when db_nota_serie is null then
          (select max(NVL(nvl(substr(db_pedi_atd_dcto,
                                     instr(db_pedi_atd_dcto, '-', 1, 1) + 1,
                                     2),
                              db_pedi_atd_dcto),
                          0))
             from mercanet_prd.db_pedido_prod
            where "Pedido Drogacenter" = db_pedi_pedido)
         else
          to_char(db_nota_serie)
       end as "Serie",
           "Arquivo de Retorno da Nota",
          to_date(substr("Arquivo de Retorno da Nota", 21, 14),
                  'yyyymmdd hh24miss')as "Data Envio Retorno da Nota"
  from (SELECT DB_EDILE_EDIP_COMP as "CNPJ do Cliente",
               (NVL(nvl(substr(db_edile_edip_nro,
                               1,
                               instr(db_edile_edip_nro, '-', 1, 1) - 1),
                        db_edile_edip_nro),
                    0)) "Pedido",
               DB_EDIP_PEDMERC as "Pedido Drogacenter",
               substr(db_edile_arquivo, 1, length(db_edile_arquivo) - 5) as "Arquivo de Retorno da Nota"
          FROM MERCANET_PRD.DB_EDI_LOG_EXP_HIST, MERCANET_PRD.DB_EDI_PEDIDO
         WHERE DB_EDIP_NRO = DB_EDILE_EDIP_NRO
           AND DB_EDIP_COMPRADOR = DB_EDILE_EDIP_COMP
           AND DB_EDILE_EDIA_CODI = 'PHL_NF'
           AND DB_EDIP_PEDMERC in
               (select pedido_merc from Analise_Notas_Sanofi)
        UNION
        SELECT DB_EDILE_EDIP_COMP as "CNPJ do Cliente",
               (NVL(nvl(substr(db_edile_edip_nro,
                               1,
                               instr(db_edile_edip_nro, '-', 1, 1) - 1),
                        db_edile_edip_nro),
                    0)) "Pedido",
               DB_EDIP_PEDMERC as "Pedido Drogacenter",
               substr(db_edile_arquivo, 1, length(db_edile_arquivo) - 5)
          FROM MERCANET_PRD.DB_EDI_LOG_EXP, MERCANET_PRD.DB_EDI_PEDIDO
         WHERE DB_EDIP_NRO = DB_EDILE_EDIP_NRO
           AND DB_EDIP_COMPRADOR = DB_EDILE_EDIP_COMP
           AND DB_EDILE_EDIA_CODI = 'PHL_NF'
           AND DB_EDIP_PEDMERC in
               (select pedido_merc from Analise_Notas_Sanofi)),
       mercanet_prd.db_nota_fiscal a
 where db_nota_ped_merc(+) = "Pedido Drogacenter"
