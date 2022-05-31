SELECT DB_Edip_Projeto AS Projeto,
       DB_Nota_Nro,
       DB_Nota_Empresa,
       DB_Nota_Serie,
       DB_Nota_Prod.DB_NotaP_Seq,
       DB_NotaP_Produto,
       DB_ped_nro,
       Db_Ped_Empresa,
       DB_edip_lote,
       Db_EdiP_OrdCompra,
       Db_EdiP_Nro,
       DB_EDIP_COMPRADOR,
       Db_EdiP_NrPedSeq,
       Db_EdiP_OBS2,
       DB_Nota_Prod_IT.DB_NPI_SeqLote,
       Db_EdiP_Txt1,
       Db_EdiP_Txt2,
       Db_EdiP_Txt3,
       MAX(db_nota_nro) AS CQ2,
       MAX(db_nota_fiscal.db_nota_serie) AS CQ3,
       COUNT(DB_NOTA_NRO) AS CQ6,
       nvl(MAX((Select db_cliente.db_cli_cgcmf
                 from mercanet_prd.db_cliente
                where db_cliente.db_cli_codigo =
                      db_nota_fiscal.db_nota_entregador)),
           '              ') AS CQ7,
       nvl(MAX((Select db_cliente.db_cli_cgcmf
                 from mercanet_prd.db_cliente
                where db_cliente.db_cli_codigo =
                      db_nota_fiscal.db_nota_entregador)),
           '              ') AS CQ8,
       max(nvl((select db_tb_empresa.db_tbemp_cnpj
                 from mercanet_prd.db_tb_empresa
                where db_tbemp_codigo = db_nota_empresa),
               0)) AS CQ9,
       (SELECT MAX(DB_EDIP_PROJETO)
          FROM mercanet_prd.DB_EDI_PEDIDO
         WHERE DB_EDIP_PEDMERC = DB_PED_NRO) AS CQ10,
       MAX(DB_EDIP_TXT3) AS CQ11,
       MAX(DB_EDIP_nro) AS CQ12,
       LPAD(NVL(MAX(db_nota_observ), 0), 50, 0) AS CQ14,
       TO_CHAR(MAX(DB_NOTA_DT_EMISSAO) +
               MAX((SELECT MAX(DIA)
                     FROM (SELECT DB_TBPGTO_COD, DB_TBPGTO_DIAS1 AS DIA
                             FROM mercanet_prd.DB_TB_CPGTO
                           UNION
                           SELECT DB_TBPGTO_COD, DB_TBPGTO_DIAS2 AS DIA
                             FROM mercanet_prd.DB_TB_CPGTO
                           UNION
                           SELECT DB_TBPGTO_COD, DB_TBPGTO_DIAS3 AS DIA
                             FROM mercanet_prd.DB_TB_CPGTO
                           UNION
                           SELECT DB_TBPGTO_COD, DB_TBPGTO_DIAS4 AS DIA
                             FROM mercanet_prd.DB_TB_CPGTO
                           UNION
                           SELECT DB_TBPGTO_COD, DB_TBPGTO_DIAS5 AS DIA
                             FROM mercanet_prd.DB_TB_CPGTO
                           UNION
                           SELECT DB_TBPGTO_COD, DB_TBPGTO_DIAS6 AS DIA
                             FROM mercanet_prd.DB_TB_CPGTO
                           UNION
                           SELECT DB_TBPGTO_COD, DB_TBPGTO_DIAS7 AS DIA
                             FROM mercanet_prd.DB_TB_CPGTO
                           UNION
                           SELECT DB_TBPGTO_COD, DB_TBPGTO_DIAS8 AS DIA
                             FROM mercanet_prd.DB_TB_CPGTO
                           UNION
                           SELECT DB_TBPGTO_COD, DB_TBPGTO_DIAS9 AS DIA
                             FROM mercanet_prd.DB_TB_CPGTO
                           UNION
                           SELECT DB_TBPGTO_COD, DB_TBPGTO_DIAS10 AS DIA
                             FROM mercanet_prd.DB_TB_CPGTO
                           UNION
                           SELECT DB_TBPGTO_COD, DB_TBPGTO_DIAS11 AS DIA
                             FROM mercanet_prd.DB_TB_CPGTO
                           UNION
                           SELECT DB_TBPGTO_COD, DB_TBPGTO_DIAS12 AS DIA
                             FROM mercanet_prd.DB_TB_CPGTO)
                    WHERE DB_NOTA_COND_PGTO = DB_TBPGTO_COD
                    GROUP BY DB_TBPGTO_COD)),
               'DDMMYYYY') AS CQ17,
       TO_CHAR(CURRENT_DATE, 'DDMMYYYY') AS CQ18,
       TO_CHAR(SYSDATE, 'HH24MISS') AS CQ19,
       max(TO_CHAR(db_nota_dt_emb, 'DDMMYYYY')) AS CQ20,
       MAX(db_nota_hr_emb) AS CQ21,
       MAX(to_char(db_nota_fiscal.db_nota_dt_emissao, 'DDMMYYYY')) AS CQ22,
       MAX(db_nota_vlr_prod) AS CQ24,
       (select sum(tab1.db_notap_incentivo)
          from mercanet_prd.db_nota_prod tab1
         where tab1.db_notap_empresa = db_nota_fiscal.db_nota_empresa
           and tab1.db_notap_nro = db_nota_fiscal.db_nota_nro
           and tab1.db_notap_serie = db_nota_fiscal.db_nota_serie) AS CQ25,
       MAX(DB_NOTA_VLR_TOTAL) AS CQ26,
       NVL(MAX(DB_NOTAP_NROSERIE), 0) AS CQ29,
       (select db_nota_prod.db_notap_produto
          from mercanet_prd.db_produto
         where db_prod_codigo = db_notap_produto) AS CQ30,
       (select db_nota_prod.db_notap_produto
          from mercanet_prd.db_produto
         where db_prod_codigo = db_notap_produto) AS CQ31,
       nvl(MAX(db_nota_prod.db_notap_qtde), 0) AS CQ32,
       (Select db_produto.db_prod_unid_medid
          from mercanet_prd.db_produto
         where db_prod_codigo = db_notap_produto) AS CQ33,
       MAX(NVL(DB_NOTAP_ALIQ_RP, 0)) AS CQ34,
       Max((Select MAX(DB_PEDI_PRECO_UNIT)
             From mercanet_prd.DB_Pedido_Prod
            Where Db_Pedi_Pedido = Db_Nota_Ped_Merc
              And Db_PEdI_Produto = Db_NotaP_Produto)) AS CQ36,
       MAX(NVL(db_nota_prod.DB_NOTAP_VLR_RP, 0)) AS CQ37,
       Max((Select MAX(DB_PEDI_PRECO_UNIT - DB_NOTAP_VLR_RP)
             From mercanet_prd.DB_Pedido_Prod
            Where Db_Pedi_Pedido = Db_Nota_Ped_Merc
              And Db_PEdI_Produto = Db_NotaP_Produto)) AS CQ38,
       max(nvl(((SELECT max(DB_PEDI_PRECO_UNIT)
                   FROM mercanet_prd.DB_PEDIDO_PROD tab1
                  WHERE TAB1.DB_PEDI_PEDIDO =
                        DB_NOTA_FISCAL.DB_NOTA_PED_MERC
                    AND tab1.DB_PEDI_PRODUTO = DB_NOTA_PROD.DB_NOTAP_PRODUTO) *
               db_nota_prod.db_notap_qtde),
               0)) AS CQ39,
       Max((Select MAX(DB_PEDI_PRECO_UNIT - DB_NOTAP_VLR_RP) * DB_NOTAP_QTDE
             From mercanet_prd.DB_Pedido_Prod
            Where Db_Pedi_Pedido = Db_Nota_Ped_Merc
              And Db_PEdI_Produto = Db_NotaP_Produto)) AS CQ40,
       ((select count(*)
           from mercanet_prd.db_NOTA_PROD NOTAP
          where NOTAP.DB_NOTAP_NRO = DB_NOTA_NRO
            and NOTAP.DB_NOTAP_SERIE = DB_NOTAP_SERIE)) AS CQ43,
       ((select SUM(NOTAP.DB_NOTAP_QTDE)
           from mercanet_prd.db_NOTA_PROD NOTAP
          where NOTAP.DB_NOTAP_NRO = DB_NOTA_NRO
            and NOTAP.DB_NOTAP_SERIE = DB_NOTAP_SERIE)) AS CQ44
  FROM mercanet_prd.DB_Nota_Fiscal
 INNER JOIN mercanet_prd.DB_Nota_Prod
    ON DB_Nota_Fiscal.DB_Nota_Empresa = DB_Nota_Prod.DB_NotaP_Empresa
   AND DB_Nota_Fiscal.DB_Nota_Nro = DB_Nota_Prod.DB_NotaP_Nro
   AND DB_Nota_Fiscal.DB_nota_serie = DB_Nota_Prod.DB_NotaP_Serie
 INNER JOIN mercanet_prd.DB_Pedido
    ON DB_Pedido.DB_Ped_Nro = DB_Nota_Fiscal.DB_Nota_Ped_Merc
 INNER JOIN mercanet_prd.DB_Pedido_Distr
    ON DB_Pedido_Distr.DB_Pedt_Pedido = DB_Pedido.DB_Ped_Nro
 INNER JOIN mercanet_prd.MEM01
    ON MEM01.EM01_Codigo = DB_Pedido_Distr.DB_Pedt_Distr
 INNER JOIN mercanet_prd.DB_Pedido_Compl
    ON DB_Pedido_Compl.DB_PedC_Nro = DB_Pedido.DB_Ped_Nro
 INNER JOIN mercanet_prd.DB_Edi_Pedido
    ON DB_Edi_Pedido.DB_EdiP_PedMerc = DB_Pedido.DB_Ped_Nro
  LEFT JOIN mercanet_prd.DB_Nota_Prod_IT
    ON DB_Nota_Prod_IT.DB_NPI_Empresa = DB_Nota_Prod.DB_NotaP_Empresa
   AND DB_Nota_Prod_IT.DB_NPI_Nro = DB_Nota_Prod.DB_NotaP_Nro
   AND DB_Nota_Prod_IT.DB_NPI_Serie = DB_Nota_Prod.DB_NotaP_Serie
   AND DB_Nota_Prod_IT.DB_NPI_NotaPSeq = DB_Nota_Prod.DB_NotaP_Seq
 WHERE db_pedt_distr = 540
   AND (EXISTS (SELECT 1
                  FROM mercanet_prd.Db_Tb_TpPedido
                 WHERE Db_TbTPe_Codigo = Db_Ped_Tipo
                   AND Db_TbTPe_OperLog = 1))
   AND (Db_NotaP_Ident IS NULL OR Db_NotaP_Ident = 0)
   AND NVL(DB_NOTA_FATUR, 0) <> 3
   AND db_nota_dt_envio Between
       to_date('2017-09-16 00:00:00', 'yyyy-mm-dd hh24:mi:ss') And
       to_date('2017-09-16 23:59:59', 'yyyy-mm-dd hh24:mi:ss')
 GROUP BY DB_Nota_Nro,
          Db_Nota_Serie,
          Db_Nota_Empresa,
          Db_Nota_Cliente,
          Db_NotaP_Produto,
          DB_Nota_Prod.DB_NotaP_Seq,
          Db_Ped_Nro,
          Db_Ped_Empresa,
          db_edip_lote,
          db_edip_projeto,
          Db_EdiP_OrdCompra,
          Db_EdiP_Nro,
          DB_EDIP_COMPRADOR,
          Db_EdiP_NrPedSeq,
          Db_EdiP_OBS2,
          DB_Nota_Prod_IT.DB_NPI_SeqLote,
          Db_EdiP_Txt1,
          Db_EdiP_Txt2,
          Db_EdiP_Txt3
 order by db_edip_lote, db_nota_nro
