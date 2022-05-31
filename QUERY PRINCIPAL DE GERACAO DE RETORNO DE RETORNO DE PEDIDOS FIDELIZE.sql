--QUERY PRINCIPAL RETORNO PD FIDELIZE
select db_edip_Comprador || db_edip_Nro Pedido,
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
       MAX(DB_EDIP_TXT1) AS CQ1,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') AS CQ2,
       (select nvl(max(case
                         when (db_tbpgto_przmed = 7) then
                          0
                         else
                          db_tbpgto_przmed
                       end),
                   0)
          from mercanet_qa.db_tb_cpgto tab1, mercanet_qa.db_pedido
         where tab1.db_tbpgto_cod = db_pedido.db_ped_cond_pgto
           and db_edip_pedmerc = db_ped_nro) AS CQ4,
       NVL(MAX(Db_EDII_Produto), 0) AS CQ6,
       NVL(MAX((select NVL(db_pedi_qtde_atend, 0)
                 from mercanet_qa.db_pedido_prod, mercanet_qa.db_pedido_distr_it
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
           0) AS CQ7,
       NVL(MAX(TRIM(TO_CHAR(ROUND(DB_EDII_PERC_DCTO, 2), '9990.99'))),
           '0.00') AS CQ8,
       TRIM(TO_CHAR(NVL(MAX(ROUND((SELECT (db_pedi_preco_unit *
                                         DB_EDII_PERC_DCTO) / 100
                                    FROM mercanet_qa.DB_PEDIDO_PROD, mercanet_qa.DB_PEDIDO_DISTR_IT
                                   WHERE DB_PEDI_PEDIDO = DB_EDII_PEDMERC
                                     AND DB_PDIT_PEDIDO = DB_PEDI_PEDIDO
                                     AND DB_PDIT_EDII_SEQ = DB_EDII_SEQ
                                     AND DB_PDIT_PRODUTO = DB_PEDI_PRODUTO
                                     AND DB_PEDI_QTDE_ATEND > 0),
                                  2)),
                        0),
                    '9990.99')) AS CQ9,
       TRIM(TO_CHAR(NVL(MAX(ROUND((SELECT db_pedi_preco_unit
                                    FROM mercanet_qa.DB_PEDIDO_PROD, mercanet_qa.DB_PEDIDO_DISTR_IT
                                   WHERE DB_PEDI_PEDIDO = DB_EDII_PEDMERC
                                     AND DB_PDIT_PEDIDO = DB_PEDI_PEDIDO
                                     AND DB_PDIT_EDII_SEQ = DB_EDII_SEQ
                                     AND DB_PDIT_PRODUTO = DB_PEDI_PRODUTO
                                     AND DB_PEDI_QTDE_ATEND > 0),
                                  2)),
                        0),
                    '9990.99')) AS CQ10,
       max((case
             when (decode((select db_pedi_motcanc
                            from mercanet_qa.db_pedido_distr_it, mercanet_qa.db_pedido_prod
                           where db_pedi_pedido = db_pdit_pedido
                             and db_pedi_sequencia = db_pdit_pedi_seq
                             and db_pdit_pedido = db_edii_pedmerc
                             and db_pdit_edii_seq = db_edii_seq
                             and db_pedi_sitcorp1 is null),
                          'FTEST',
                          '004',
                          '9',
                          '999',
                          db_edii_motivoret)) is null then
              (case
                when (db_edii_produto) is null and (db_edii_motivoret) is null then
                 '001'
              end)
             else
              (decode((select db_pedi_motcanc
                        from mercanet_qa.db_pedido_distr_it, mercanet_qa.db_pedido_prod
                       where db_pedi_pedido = db_pdit_pedido
                         and db_pedi_sequencia = db_pdit_pedi_seq
                         and db_pdit_pedido = db_edii_pedmerc
                         and db_pdit_edii_seq = db_edii_seq
                         and db_pedi_sitcorp1 is null),
                      'FTEST',
                      '004',
                      '9',
                      '999',
                      db_edii_motivoret))
           end)) AS CQ11,
       NVL(MAX(Db_EDII_Produto), 0) AS CQ12,
       NVL(max((Select replace(round(SUM(Db_Pedi_Preco_Liq *
                                        (Db_Pedi_Qtde_Solic -
                                        NVL(Db_Pedi_qtde_Canc, 0))),
                                    2),
                              ',',
                              '.')
                 From mercanet_qa.Db_PedidO_Prod
                Where Db_pedi_Pedido = DB_EdiP_PedMerc)),
           '0.00') AS CQ14,
       (select NVL(REPLACE(ROUND(SUM(((db_pedi_preco_unit *
                                     DB_EDII_PERC_DCTO) / 100) *
                                     (Db_Pedi_Qtde_Solic -
                                     NVL(Db_Pedi_qtde_Canc, 0))),
                                 2),
                           ',',
                           '.'),
                   '0.00')
          FROM mercanet_qa.DB_PEDIDO_PROD, mercanet_qa.DB_PEDIDO_DISTR_IT, mercanet_qa.db_edi_pedprod
         WHERE DB_PEDI_PEDIDO = DB_EDII_PEDMERC
           AND DB_PDIT_PEDIDO = DB_PEDI_PEDIDO
           AND DB_PDIT_EDII_SEQ = DB_EDII_SEQ
           AND DB_PDIT_PRODUTO = DB_PEDI_PRODUTO
           AND DB_PEDI_QTDE_ATEND > 0
           AND DB_EDII_PEDMERC = DB_EDIP_PEDMERC) AS CQ15
  from mercanet_qa.db_edi_pedido, mercanet_qa.db_edi_Pedprod
 where db_edip_comprador = Db_Edii_Comprador
   and db_edip_nro = db_edii_nro
   and DB_EDIP_VAN = 517
   and Db_EDiP_Tipo = 1
   and Db_EDiP_DtEnvio IS NULL
   and NVL((select (Case
                    When (Db_Pedt_Dtdisp is not null) Then
                     (1)
                    Else
                     (0)
                  End)
             From mercanet_qa.db_pedido_Distr
            where db_pedt_pedido = db_edip_pedmerc),
           1) = 1
   AND NOT EXISTS
 (SELECT 1
          FROM mercanet_qa.db_edi_pedido ped
         Where ped.db_edip_lote = db_edi_pedido.db_edip_lote
           and NVL((select (Case
                            When (distr.Db_Pedt_Dtdisp is not null) Then
                             (1)
                            Else
                             (0)
                          End)
                     From mercanet_qa.db_pedido_Distr distr
                    where distr.db_pedt_pedido = ped.db_edip_pedmerc),
                   1) <> 1)
 Group By db_edip_Pedmerc,
          Db_ediP_Comprador,
          Db_ediP_Nro,
          Db_edii_Produto,
          db_edip_projeto,
          Db_EdiP_Empresa,
          db_edip_lote,
          Db_EdiP_OrdCompra,
          Db_EdiP_Nro,
          Db_EdiP_NrPedSeq,
          Db_EdiP_OBS2,
          Db_EdiI_Seq,
          Db_EdiP_Txt1,
          Db_EdiP_Txt2,
          Db_EdiP_Txt3
 Order By db_edip_lote, 1
