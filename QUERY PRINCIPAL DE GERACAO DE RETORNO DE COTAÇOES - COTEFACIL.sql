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
       MAX(DB_EDIP_CLIENTE) AS CQ1,
       MAX(NVL(DB_EDIP_OBS1, 0)) AS CQ2,
       (SELECT MAX(TO_CHAR(SYSDATE + MEM01.EM01_LEADTIME, 'DDMMYYYY'))
          FROM MEM01, DB_EDI_PEDIDO EDIPED
         WHERE EDIPED.DB_EDIP_VAN = MEM01.EM01_CODIGO
           AND EDIPED.DB_EDIP_NRO = DB_EDIP_NRO
           AND EDIPED.DB_EDIP_COMPRADOR = DB_EDIP_COMPRADOR
           AND EDIPED.DB_EDIP_LOTE = DB_EDIP_LOTE) AS CQ4,
       (select db_tbpgto_przmed
          from db_tb_cpgto tab1, db_pedido
         where tab1.db_tbpgto_cod = db_pedido.db_ped_cond_pgto
           and db_edip_pedmerc = db_pedido.db_ped_nro) AS CQ5,
       MAX(NVL(Db_EDII_Produto, 0)) AS CQ7,
       NVL(MAX((select NVL(db_pedi_qtde_atend, 0)
                 from db_pedido_prod, db_pedido_distr_it
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
           0) AS CQ8,
       NVL(MAX((SELECT (REPLACE(ROUND((NVL(DB_PEDI_PRECO_LIQ, 0)), 2),
                               ',',
                               '.'))
                 FROM DB_PEDIDO_PROD, DB_PEDIDO_DISTR_IT
                WHERE DB_PEDIDO_PROD.DB_PEDI_PEDIDO =
                      DB_PEDIDO_DISTR_IT.DB_PDIT_PEDIDO
                  AND DB_PEDIDO_PROD.DB_PEDI_PRODUTO =
                      DB_PEDIDO_DISTR_IT.DB_PDIT_PRODUTO
                  AND DB_PEDIDO_DISTR_IT.DB_PDIT_PEDIDO =
                      DB_EDI_PEDPROD.DB_EDII_PEDMERC
                  AND DB_EDI_PEDPROD.DB_EDII_SEQ =
                      DB_PEDIDO_DISTR_IT.DB_PDIT_EDII_SEQ
                  AND DB_EDI_PEDPROD.DB_EDII_PEDMERC =
                      DB_EDI_PEDIDO.DB_EDIP_PEDMERC)),
           0) AS CQ9,
       NVL(MAX((select ROUND(NVL(db_pedi_float2, 0))
                 from db_pedido_prod, db_pedido_distr_it
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
           0) AS CQ11,
       NVL(MAX((select (replace(ROUND((NVL(db_pedi_preco_unit, 0)), 2),
                               ',',
                               '.'))
                 from db_pedido_prod, db_pedido_distr_it
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
           0) AS CQ12,
       NVL(MAX((SELECT (CASE
                        WHEN DB_PROD_CLASFIS = 'POS' THEN
                         'P'
                        ELSE
                         CASE
                           WHEN DB_PROD_CLASFIS = 'NEU' THEN
                            '0'
                           ELSE
                            CASE
                              WHEN DB_PROD_CLASFIS = 'NEG' THEN
                               'N'
                              ELSE
                               ' '
                            END
                         END
                      END)
                 FROM DB_PEDIDO_PROD, DB_PEDIDO_DISTR_IT, DB_PRODUTO
                WHERE DB_PEDIDO_PROD.DB_PEDI_PEDIDO =
                      DB_PEDIDO_DISTR_IT.DB_PDIT_PEDIDO
                  AND DB_PEDIDO_PROD.DB_PEDI_PRODUTO =
                      DB_PRODUTO.DB_PROD_CODIGO
                  AND DB_PEDIDO_PROD.DB_PEDI_PRODUTO =
                      DB_PEDIDO_DISTR_IT.DB_PDIT_PRODUTO
                  AND DB_PEDIDO_DISTR_IT.DB_PDIT_PEDIDO =
                      DB_EDI_PEDPROD.DB_EDII_PEDMERC
                  AND DB_EDI_PEDPROD.DB_EDII_SEQ =
                      DB_PEDIDO_DISTR_IT.DB_PDIT_EDII_SEQ
                  AND DB_EDI_PEDPROD.DB_EDII_PEDMERC =
                      DB_EDI_PEDIDO.DB_EDIP_PEDMERC)),
           ' ') AS CQ13,
       NVL(MAX((SELECT (CASE
                        WHEN DB_PRODA_VALOR IN ('C', 'V') THEN
                         'M'
                        ELSE
                         'L'
                      END)
                 FROM DB_PEDIDO_PROD,
                      DB_PEDIDO_DISTR_IT,
                      DB_PRODUTO,
                      DB_PRODUTO_ATRIB
                WHERE DB_PEDIDO_PROD.DB_PEDI_PEDIDO =
                      DB_PEDIDO_DISTR_IT.DB_PDIT_PEDIDO
                  AND DB_PEDIDO_PROD.DB_PEDI_PRODUTO =
                      DB_PRODUTO.DB_PROD_CODIGO
                  AND DB_PRODUTO.DB_PROD_CODIGO =
                      DB_PRODUTO_ATRIB.DB_PRODA_CODIGO
                  AND DB_PRODUTO_ATRIB.DB_PRODA_ATRIB = 2008
                  AND DB_PEDIDO_PROD.DB_PEDI_PRODUTO =
                      DB_PEDIDO_DISTR_IT.DB_PDIT_PRODUTO
                  AND DB_PEDIDO_DISTR_IT.DB_PDIT_PEDIDO =
                      DB_EDI_PEDPROD.DB_EDII_PEDMERC
                  AND DB_EDI_PEDPROD.DB_EDII_SEQ =
                      DB_PEDIDO_DISTR_IT.DB_PDIT_EDII_SEQ
                  AND DB_EDI_PEDPROD.DB_EDII_PEDMERC =
                      DB_EDI_PEDIDO.DB_EDIP_PEDMERC)),
           ' ') AS CQ14,
       (NVL((Select count(1)
              From Db_PEdido_Distr_IT Distr
             Where Distr.Db_PDIT_Pedido = Db_Edi_Pedido.Db_EDiP_PedMerc
               and Distr.Db_PDIT_QtdeAtd > 0),
            0)) AS CQ18,
       AS CQ24
  from db_edi_pedido, db_edi_Pedprod
 where db_edip_comprador = Db_Edii_Comprador
   and db_edip_nro = db_edii_nro
   and DB_EDIP_VAN = 529
   and exists (select 1
          from db_Pedido
         where db_edip_pedmerc = db_ped_nro
           and db_ped_nro IN (80072009))
   and Db_EDiP_Tipo = 1
   AND Db_EDiP_DtEnvio Between
       to_date('2013-06-13 00:00:00', 'yyyy-mm-dd hh24:mi:ss') And
       to_date('2013-06-13 23:59:59', 'yyyy-mm-dd hh24:mi:ss')
   and NVL((select (Case
                    When (Db_Pedt_Dtdisp is not null) Then
                     (1)
                    Else
                     (0)
                  End)
             From db_pedido_Distr
            where db_pedt_pedido = db_edip_pedmerc),
           1) = 1
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
