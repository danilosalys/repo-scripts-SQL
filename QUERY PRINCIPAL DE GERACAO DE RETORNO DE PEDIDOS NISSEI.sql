SELECT (db_edip_Comprador || db_edip_Nro) Pedido,
       db_edip_Pedmerc db_ped_nro,
       db_Edip_Nro,
       db_edip_comprador,
       db_edip_projeto Projeto,
       db_edip_empresa Db_Ped_Empresa,
       db_edi_pedido.db_edip_lote,
       Db_EdiP_OrdCompra,
       Db_EdiP_Nro,
       Db_EdiP_NrPedSeq,
       Db_EdiP_OBS2,
       Db_EdiI_Seq,
       Db_EdiP_Txt1,
       Db_EdiP_Txt2,
       Db_EdiP_Txt3,
       TO_CHAR(SYSDATE, 'YYYYMMDDHH24MI') AS CQ4,
       MAX(NVL(db_edip_nro, 0)) AS CQ6,
       MAX(NVL(DB_EDIP_OBS1, 0)) AS CQ9,
       MAX(NVL(DB_EDIP_TXT1, 0)) AS CQ10,
       MAX(DB_EDIP_CLIENTE) AS CQ11,
       MAX(db_edip_comprador) AS CQ12,
       MAX(db_edip_comprador) AS CQ13,
       MAX(nvl(db_edip_condpgto, 0)) AS CQ21,
       max(NVL((Select ROUND(SUM(Db_Pedi_Preco_liq *
                                (Db_Pedi_Qtde_Solic -
                                NVL(Db_Pedi_qtde_Canc, 0))),
                            2)
                 From MERCANET_QA.Db_PedidO_Prod
                Where Db_pedi_Pedido = DB_EdiP_PedMerc),
               '0000000000000')) AS CQ23,
       NVL(MAX((select (NVL(db_pedi_float2, 0))
                 from MERCANET_QA.db_pedido_prod,
                      MERCANET_QA.db_pedido_distr_it
                where db_pedido_prod.db_pedi_pedido =
                      db_pedido_distr_it.db_pdit_pedido
                  and db_pedido_prod.db_pedi_produto =
                      db_pedido_distr_it.db_pdit_produto
                  and db_pedido_distr_it.db_pdit_pedido =
                      db_edi_pedprod.db_edii_pedmerc
                  and db_edi_pedprod.db_edii_seq =
                      db_pedido_distr_it.db_pdit_edii_seq
                  and db_edi_pedprod.db_edii_pedmerc =
                      db_edi_pedido.db_edip_pedmerc)),
           0) AS CQ28,
       MAX(NVL(DB_EDII_VALOR1, 0)) AS CQ39,
       MAX(NVL(DB_EDII_VALOR2, '00000')) AS CQ40,
       MAX(NVL(Db_EDII_Produto, 0)) AS CQ43,
       MAX(db_edii_qtde_vda) AS CQ48,
       NVL(MAX((select NVL(db_pedi_qtde_atend, 0)
                 from MERCANET_QA.db_pedido_prod,
                      MERCANET_QA.db_pedido_distr_it
                where db_pedido_prod.db_pedi_pedido =
                      db_pedido_distr_it.db_pdit_pedido
                  and db_pedido_prod.db_pedi_produto =
                      db_pedido_distr_it.db_pdit_produto
                  and db_pedido_distr_it.db_pdit_pedido =
                      db_edi_pedprod.db_edii_pedmerc
                  and db_edi_pedprod.db_edii_seq =
                      db_pedido_distr_it.db_pdit_edii_seq
                  and db_edi_pedprod.db_edii_pedmerc =
                      db_edi_pedido.db_edip_pedmerc
                  and db_pedido_prod.db_pedi_qtde_atend > 0)),
           0) AS CQ49,
       NVL(MAX((select (replace(ROUND((NVL(db_pedi_preco_unit, 0)), 2),
                               ',',
                               ''))
                 from MERCANET_QA.db_pedido_prod,
                      MERCANET_QA.db_pedido_distr_it
                where db_pedido_prod.db_pedi_pedido =
                      db_pedido_distr_it.db_pdit_pedido
                  and db_pedido_prod.db_pedi_produto =
                      db_pedido_distr_it.db_pdit_produto
                  and db_pedido_distr_it.db_pdit_pedido =
                      db_edi_pedprod.db_edii_pedmerc
                  and db_edi_pedprod.db_edii_seq =
                      db_pedido_distr_it.db_pdit_edii_seq
                  and db_edi_pedprod.db_edii_pedmerc =
                      db_edi_pedido.db_edip_pedmerc)),
           0) AS CQ52,
       
       NVL(MAX((select (replace(ROUND((NVL(db_pedi_preco_liq, 0)), 2),
                               ',',
                               ''))
                 from MERCANET_QA.db_pedido_prod,
                      MERCANET_QA.db_pedido_distr_it
                where db_pedido_prod.db_pedi_pedido =
                      db_pedido_distr_it.db_pdit_pedido
                  and db_pedido_prod.db_pedi_produto =
                      db_pedido_distr_it.db_pdit_produto
                  and db_pedido_distr_it.db_pdit_pedido =
                      db_edi_pedprod.db_edii_pedmerc
                  and db_edi_pedprod.db_edii_seq =
                      db_pedido_distr_it.db_pdit_edii_seq
                  and db_edi_pedprod.db_edii_pedmerc =
                      db_edi_pedido.db_edip_pedmerc)),
           0),
       MAX(Case
             when (select max(nvl(db_pedi_qtde_atend, 0))
                     from MERCANET_QA.db_pedido_prod,
                          MERCANET_QA.db_pedido_distr_it
                    where db_pedido_prod.db_pedi_pedido =
                          db_pedido_distr_it.db_pdit_pedido
                      and db_pedido_prod.db_pedi_produto =
                          db_pedido_distr_it.db_pdit_produto
                      and db_pedido_distr_it.db_pdit_pedido =
                          db_edi_pedprod.db_edii_pedmerc
                      and db_edi_pedprod.db_edii_seq =
                          db_pedido_distr_it.db_pdit_edii_seq
                      and db_edi_pedprod.db_edii_pedmerc =
                          db_edi_pedido.db_edip_pedmerc) = 0 then
              '0'
             else
              NVL((select (replace(ROUND((NVL(db_pedi_preco_unit /
                                             db_pedi_qtde_atend,
                                             0)),
                                        2),
                                  ',',
                                  ''))
                    from MERCANET_QA.db_pedido_prod,
                         MERCANET_QA.db_pedido_distr_it
                   where db_pedido_prod.db_pedi_pedido =
                         db_pedido_distr_it.db_pdit_pedido
                     and db_pedido_prod.db_pedi_produto =
                         db_pedido_distr_it.db_pdit_produto
                     and db_pedido_distr_it.db_pdit_pedido =
                         db_edi_pedprod.db_edii_pedmerc
                     and db_edi_pedprod.db_edii_seq =
                         db_pedido_distr_it.db_pdit_edii_seq
                     and db_edi_pedprod.db_edii_pedmerc =
                         db_edi_pedido.db_edip_pedmerc),
                  0)
           end),
       
       MAX(Case
             when (select max(nvl(db_pedi_qtde_atend, 0))
                     from MERCANET_QA.db_pedido_prod,
                          MERCANET_QA.db_pedido_distr_it
                    where db_pedido_prod.db_pedi_pedido =
                          db_pedido_distr_it.db_pdit_pedido
                      and db_pedido_prod.db_pedi_produto =
                          db_pedido_distr_it.db_pdit_produto
                      and db_pedido_distr_it.db_pdit_pedido =
                          db_edi_pedprod.db_edii_pedmerc
                      and db_edi_pedprod.db_edii_seq =
                          db_pedido_distr_it.db_pdit_edii_seq
                      and db_edi_pedprod.db_edii_pedmerc =
                          db_edi_pedido.db_edip_pedmerc) = 0 then
              '0'
             else
              NVL((select (replace(ROUND((NVL(db_pedi_preco_liq /
                                             db_pedi_qtde_atend,
                                             0)),
                                        2),
                                  ',',
                                  ''))
                    from MERCANET_QA.db_pedido_prod,
                         MERCANET_QA.db_pedido_distr_it
                   where db_pedido_prod.db_pedi_pedido =
                         db_pedido_distr_it.db_pdit_pedido
                     and db_pedido_prod.db_pedi_produto =
                         db_pedido_distr_it.db_pdit_produto
                     and db_pedido_distr_it.db_pdit_pedido =
                         db_edi_pedprod.db_edii_pedmerc
                     and db_edi_pedprod.db_edii_seq =
                         db_pedido_distr_it.db_pdit_edii_seq
                     and db_edi_pedprod.db_edii_pedmerc =
                         db_edi_pedido.db_edip_pedmerc),
                  0)
           end),
       MAX(NVL(((select (replace(ROUND((NVL((db_pedi_preco_unit *
                                            db_edii_perc_dcto) / 100,
                                            0)),
                                       2),
                                 ',',
                                 ''))
                   from MERCANET_QA.db_pedido_prod,
                        MERCANET_QA.db_pedido_distr_it
                  where db_pedido_prod.db_pedi_pedido =
                        db_pedido_distr_it.db_pdit_pedido
                    and db_pedido_prod.db_pedi_produto =
                        db_pedido_distr_it.db_pdit_produto
                    and db_pedido_distr_it.db_pdit_pedido =
                        db_edi_pedprod.db_edii_pedmerc
                    and db_edi_pedprod.db_edii_seq =
                        db_pedido_distr_it.db_pdit_edii_seq
                    and db_edi_pedprod.db_edii_pedmerc =
                        db_edi_pedido.db_edip_pedmerc)),
               0)),
       MAX(NVL(DB_EDII_PERC_DCTO, 0)),
       (SUM(NVL(db_edii_qtde_vda, 0)) -
       SUM(NVL((Select NVL(pdt.db_pdit_qtdeatd, 0)
                  from MERCANET_QA.Db_PedidO_Distr_IT pdt
                 where pdt.db_pdit_pedido = db_edii_pedmerc
                   and pdt.db_pdit_edii_seq = db_edii_seq),
                0))),
       MAX(db_edii_motivoret),
       max(NVL((Select ROUND(SUM(Db_Pedi_Preco_UNIT *
                                (Db_Pedi_Qtde_Solic -
                                NVL(Db_Pedi_qtde_Canc, 0))),
                            2)
                 From MERCANET_QA.Db_PedidO_Prod
                Where Db_pedi_Pedido = DB_EdiP_PedMerc),
               '0000000000000')),
       replace(ROUND((sum(NVL(((select DB_PEDI_DESCTOP
                                  from MERCANET_QA.db_pedido_prod, MERCANET_QA.db_pedido_distr_it
                                 where db_pedido_prod.db_pedi_pedido =
                                       db_pedido_distr_it.db_pdit_pedido
                                   and db_pedido_prod.db_pedi_produto =
                                       db_pedido_distr_it.db_pdit_produto
                                   and db_pedido_distr_it.db_pdit_pedido =
                                       db_edi_pedprod.db_edii_pedmerc
                                   and db_edi_pedprod.db_edii_seq =
                                       db_pedido_distr_it.db_pdit_edii_seq
                                   and db_edi_pedprod.db_edii_pedmerc =
                                       db_edi_pedido.db_edip_pedmerc)),
                              0))),
                     2),
               ',',
               ''),
       max(NVL((Select ROUND(SUM(Db_Pedi_Preco_liq *
                                (Db_Pedi_Qtde_Solic -
                                NVL(Db_Pedi_qtde_Canc, 0))),
                            2)
                 From MERCANET_QA.Db_PedidO_Prod
                Where Db_pedi_Pedido = DB_EdiP_PedMerc),
               '0000000000000'))
  FROM MERCANET_QA.DB_EDI_PEDIDO, MERCANET_QA.DB_EDI_PEDPROD
 WHERE DB_EDIP_COMPRADOR = DB_EDII_COMPRADOR
   AND DB_EDIP_NRO = DB_EDII_NRO
   AND DB_EDIP_PEDMERC in (80063691,80063693)
 group by db_edip_Comprador,
          db_edip_Nro,
          db_edip_Pedmerc,
          db_edip_projeto,
          db_edip_empresa,
          db_edi_pedido.db_edip_lote,
          Db_EdiP_OrdCompra,
          Db_EdiP_Nro,
          Db_EdiP_NrPedSeq,
          Db_EdiP_OBS2,
          Db_EdiI_Seq,
          Db_EdiP_Txt1,
          Db_EdiP_Txt2,
          Db_EdiP_Txt3
