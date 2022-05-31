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
       MAX((Select nvl(substr(db_edip_nro,
                             1,
                             instr(db_edip_nro, '-', 1, 1) - 1),
                      db_edip_nro)
             from mercanet_hml.Db_Edi_Pedido
            Where Db_Edi_Pedido.Db_EdiP_PEdMerc = DB_Ped_Nro)) AS CQ1,
       TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD') AS CQ2,
       TO_CHAR(CURRENT_DATE, 'HH24:MI') AS CQ3,
       MAX(to_char(db_nota_fiscal.db_nota_dt_emissao, 'YYYY-MM-DD')) AS CQ4,
       (select db_tb_empresa.db_tbemp_cnpj
          from mercanet_hml.db_tb_empresa
         where db_tbemp_codigo = db_nota_empresa) AS CQ5,
       MAX(db_nota_nro) AS CQ7,
       TRIM(TO_CHAR(NVL(MAX(ROUND((SELECT sum(nfp.DB_NOTAP_BSUB_ICMS)
                                    from mercanet_hml.db_nota_prod nfp
                                   where nfp.DB_NOTAP_NRO =
                                         db_nota_fiscal.DB_NOTA_NRO
                                     and nfp.DB_NOTAP_EMPRESA =
                                         db_nota_fiscal.DB_NOTA_EMPRESA
                                     and nfp.DB_NOTAP_SERIE =
                                         db_nota_fiscal.DB_NOTA_SERIE),
                                  2)),
                        0),
                    '999990.99')) AS CQ8,
       TRIM(TO_CHAR(NVL(MAX(ROUND((SELECT sum(nfp.DB_NOTAP_BASE_ICMS)
                                    from mercanet_hml.db_nota_prod nfp
                                   where nfp.DB_NOTAP_NRO =
                                         db_nota_fiscal.DB_NOTA_NRO
                                     and nfp.DB_NOTAP_EMPRESA =
                                         db_nota_fiscal.DB_NOTA_EMPRESA
                                     and nfp.DB_NOTAP_SERIE =
                                         db_nota_fiscal.DB_NOTA_SERIE),
                                  2)),
                        0),
                    '999990.99')) AS CQ9,
       NVL(MAX(substr(db_nota_observ, 45, 1)), '') AS CQ11,
       NVL(MAX(substr(db_nota_observ, 1, 44)), 0) AS CQ12,
       TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTA_vlr_total, 2)), 0),
                    '999999990.99')) AS CQ14,
       TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTA_CDV, 2)), 0), '999999990.99')) AS CQ16,
       TRIM(TO_CHAR(NVL(MAX(ROUND(db_nota_vlr_prod, 2)), 0), '999999990.99')) AS CQ17,
       NVL(MAX(DB_NOTAP_NROSERIE), 0) AS CQ22,
       MAX(db_nota_prod.db_notap_qtde) AS CQ23,
       TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTAP_DCTO_FIN, 2)), 0),
                    '999999990.99')) AS CQ24,
       TRIM(TO_CHAR(NVL(MAX(ROUND(((DB_NOTAP_VALOR / DB_NOTAP_QTDE) *
                                  (Select MAX(DB_NOTAP_DCTO_FIN)
                                      From mercanet_hml.DB_Pedido_Prod
                                     Where Db_Pedi_Pedido = Db_Nota_Ped_Merc
                                       And Db_PEdI_Produto =
                                           Db_NotaP_Produto)) / 100,
                                  2)),
                        0),
                    '9990.99')) AS CQ25,
       TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTAP_VALOR / DB_NOTAP_QTDE, 2)), 0),
                    '999999990.99')) AS CQ26,
       TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTAP_BASE_ICMS, 2)), 0),
                    '999999990.99')) AS CQ27,
       TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTAP_BSUB_ICMS, 2)), 0),
                    '999999990.99')) AS CQ28,
       TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTAP_ALIQ_ICMS, 2)), 0),
                    '999999990.99')) AS CQ29,
       TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTAP_VLR_ICMS, 2)), 0),
                    '999999990.99')) AS CQ31,
       TRIM(TO_CHAR(NVL(MAX(ROUND(case
                                    when (DB_NOTAP_VLR_SUBST = 0) then
                                     DB_NOTAP_VLR_DESCT
                                    else
                                     0
                                  end,
                                  2)),
                        0),
                    '999999990.99')) AS CQ32,
       max(NVL(db_notap_operacao, NULL)) AS CQ34,
       max(case
             when (DB_NOTAP_CDEPOSITO = '10' or DB_NOTAP_CDEPOSITO = '60' or
                  DB_NOTAP_CDEPOSITO = '70') then
              'S'
             else
              case
                when (DB_NOTAP_CDEPOSITO = '40' or DB_NOTAP_CDEPOSITO = '41') then
                 'I'
                else
                 'N'
              end
           end) AS CQ35,
       (select (decode(DB_PROD_clasfis,
                       'POS',
                       'P',
                       'NEG',
                       'N',
                       'NEU',
                       'O',
                       ''))
          from mercanet_hml.db_produto
         where db_nota_prod.db_notap_produto = db_produto.DB_PROD_CODIGO) AS CQ36,
       TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTAP_VALOR, 2)), 0), '999999990.99')) AS CQ41,
       TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTAP_VALOR, 2)), 0), '999999990.99')) AS CQ42,
       NVL(MAX(DB_NOTAP_CDEPOSITO), '') AS CQ43,
       (select (decode(DB_PRODA_VALOR, 'L', 'L', 'C'))
          from mercanet_hml.db_produto_atrib
         where db_produto_atrib.DB_PRODA_ATRIB = 2008
           and db_nota_prod.db_notap_produto =
               db_produto_atrib.DB_PRODA_CODIGO) AS CQ46,
       TRIM(TO_CHAR(NVL(MAX(ROUND((SELECT sum(nfp.DB_NOTAP_BASE_ICMS)
                                    from mercanet_hml.db_nota_prod nfp
                                   where nfp.DB_NOTAP_NRO =
                                         db_nota_fiscal.DB_NOTA_NRO
                                     and nfp.DB_NOTAP_EMPRESA =
                                         db_nota_fiscal.DB_NOTA_EMPRESA
                                     and nfp.DB_NOTAP_SERIE =
                                         db_nota_fiscal.DB_NOTA_SERIE),
                                  2)),
                        0),
                    '999990.99')) AS CQ49,
       (select trim(to_char(round(SUM(NVL(nfp.db_notap_vlr_icms, 0)), 2),
                            '999999990.99'))
          from mercanet_hml.db_nota_prod nfp
         where nfp.DB_NOTAP_NRO = db_nota_fiscal.DB_NOTA_NRO
           and nfp.DB_NOTAP_EMPRESA = db_nota_fiscal.DB_NOTA_EMPRESA
           and nfp.DB_NOTAP_SERIE = db_nota_fiscal.DB_NOTA_SERIE) AS CQ50,
       (select trim(to_char(round(SUM(NVL(nfp.db_notap_vlr_icms, 0)), 2),
                            '999999990.99'))
          from mercanet_hml.db_nota_prod nfp
         where nfp.DB_NOTAP_NRO = db_nota_fiscal.DB_NOTA_NRO
           and nfp.DB_NOTAP_EMPRESA = db_nota_fiscal.DB_NOTA_EMPRESA
           and nfp.DB_NOTAP_SERIE = db_nota_fiscal.DB_NOTA_SERIE) AS CQ52,
       MAX(NVL(DB_NOTA_VOLUMES, 0)) AS CQ54,
       (select count(*)
          from mercanet_hml.db_nota_prod
         where db_notap_nro = db_nota_nro
           and db_notap_serie = db_nota_serie
           and db_notap_empresa = db_nota_empresa
           and db_notap_ident is null) +
       (select count(*)
          from mercanet_hml.db_nota_prod_it, mercanet_hml.db_nota_prod
         where db_notap_nro = db_nota_nro
           and db_notap_serie = db_nota_serie
           and db_notap_empresa = db_nota_empresa
           and db_notap_ident is null
           and db_notap_nro = db_npi_nro
           and db_notap_serie = db_npi_serie
           and db_notap_empresa = db_npi_empresa
           and db_notap_seq = db_npi_notapseq) + 7 AS CQ70,
       NVL(MAX(DB_NOTAP_NROSERIE), 0) AS CQ72,
       NVL(MAX(DB_NPI_LOTE), '') AS CQ73,
       NVL(MAX(DB_NPI_QTDE), 0) AS CQ74,
       NVL(MAX(TO_CHAR(DB_NPI_DATA_VCTO, 'YYYY-MM-DD')), null) AS CQ75
  FROM mercanet_hml.DB_Nota_Fiscal
 INNER JOIN mercanet_hml.DB_Nota_Prod
    ON DB_Nota_Fiscal.DB_Nota_Empresa = DB_Nota_Prod.DB_NotaP_Empresa
   AND DB_Nota_Fiscal.DB_Nota_Nro = DB_Nota_Prod.DB_NotaP_Nro
   AND DB_Nota_Fiscal.DB_nota_serie = DB_Nota_Prod.DB_NotaP_Serie
 INNER JOIN mercanet_hml.DB_Pedido
    ON DB_Pedido.DB_Ped_Nro = DB_Nota_Fiscal.DB_Nota_Ped_Merc
 INNER JOIN mercanet_hml.DB_Pedido_Distr
    ON DB_Pedido_Distr.DB_Pedt_Pedido = DB_Pedido.DB_Ped_Nro
 INNER JOIN mercanet_hml.MEM01
    ON MEM01.EM01_Codigo = DB_Pedido_Distr.DB_Pedt_Distr
 INNER JOIN mercanet_hml.DB_Pedido_Compl
    ON DB_Pedido_Compl.DB_PedC_Nro = DB_Pedido.DB_Ped_Nro
 INNER JOIN mercanet_hml.DB_Edi_Pedido
    ON DB_Edi_Pedido.DB_EdiP_PedMerc = DB_Pedido.DB_Ped_Nro
  LEFT JOIN mercanet_hml.DB_Nota_Prod_IT
    ON DB_Nota_Prod_IT.DB_NPI_Empresa = DB_Nota_Prod.DB_NotaP_Empresa
   AND DB_Nota_Prod_IT.DB_NPI_Nro = DB_Nota_Prod.DB_NotaP_Nro
   AND DB_Nota_Prod_IT.DB_NPI_Serie = DB_Nota_Prod.DB_NotaP_Serie
   AND DB_Nota_Prod_IT.DB_NPI_NotaPSeq = DB_Nota_Prod.DB_NotaP_Seq
 WHERE/* db_pedt_distr = 511
   AND */(EXISTS (SELECT 1
                  FROM mercanet_hml.Db_Tb_TpPedido
                 WHERE Db_TbTPe_Codigo = Db_Ped_Tipo
                   AND Db_TbTPe_OperLog = 1))
   AND (Db_NotaP_Ident IS NULL OR Db_NotaP_Ident = 0)
   AND db_nota_dt_envio Between
       to_date('2013-06-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss') And
       to_date('2013-06-14 23:59:59', 'yyyy-mm-dd hh24:mi:ss')
 AND DB_Nota_Ped_Merc IN (80013537)
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
