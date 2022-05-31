SELECT 
'1;'||'154510;'||TO_CHAR(SYSDATE, 'YYYY-MM-DD')||';'||
TO_CHAR(SYSDATE, 'HH24:MI:SS')||';'||MAX(to_char(db_nota_fiscal.db_nota_dt_emissao,'YYYY-MM-DD'))||';'||
(select db_tb_empresa.db_tbemp_cnpj from mercanet_prd.db_tb_empresa where db_tbemp_codigo = db_nota_empresa)||';'||chr(10)||--header 1
'2;'||MAX(db_nota_nro)||';'||TRIM(TO_CHAR(NVL(MAX(ROUND((SELECT sum(nfp.DB_NOTAP_BSUB_ICMS) from mercanet_prd.db_nota_prod nfp
 where nfp.DB_NOTAP_NRO = db_nota_fiscal.DB_NOTA_NRO and nfp.DB_NOTAP_EMPRESA = db_nota_fiscal.DB_NOTA_EMPRESA 
 and nfp.DB_NOTAP_SERIE = db_nota_fiscal.DB_NOTA_SERIE),2)),0),'999990.99'))||';'
 ||TRIM(TO_CHAR(NVL(MAX(ROUND((SELECT sum(nfp.DB_NOTAP_BASE_ICMS) from mercanet_prd.db_nota_prod nfp 
 where nfp.DB_NOTAP_NRO = db_nota_fiscal.DB_NOTA_NRO and nfp.DB_NOTAP_EMPRESA = db_nota_fiscal.DB_NOTA_EMPRESA 
 and nfp.DB_NOTAP_SERIE = db_nota_fiscal.DB_NOTA_SERIE),2)),0),'999990.99'))||';'||'55'||';'
 ||NVL(MAX(substr(db_nota_observ,45,2)),'')||';'||NVL(MAX(substr(db_nota_observ,1,44)),0)||';'||chr(10)||--header 2
'3;'||TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTA_vlr_total,2)),0),'999999990.99'))||';'||'0.00'||';'
||TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTA_CDV,2)),0),'999999990.99'))||';'
||TRIM(TO_CHAR(NVL(MAX(ROUND(db_nota_vlr_prod,2)),0),'999999990.99'))||';'||'0.00'||';'||'0.00'||';'||'0.00'||';'||chr(10)--header 3  
AS HEADER_1_2_3_CABECALHO,
'4;'||NVL(MAX(DB_NOTAP_NROSERIE),0)
    ||';'
    ||nvl(MAX(db_nota_prod.db_notap_qtde),0)
    ||';'
    ||TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTAP_ALIQ_RP,2)),0),'999999990.99'))
    ||';'
    ||TRIM(TO_CHAR(NVL(MAX(DB_NOTAP_VLR_RP),0),'999999990.99'))
    ||';'
    ||TRIM(TO_CHAR(MAX((Select MAX(DB_PEDI_PRECO_UNIT - DB_NOTAP_VLR_RP) From mercanet_prd.DB_Pedido_Prod Where Db_Pedi_Pedido = Db_Nota_Ped_Merc And Db_PEdI_Produto = Db_NotaP_Produto)),'999999990.99'))
    ||';'
    ||TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTAP_BASE_ICMS,2)),0),'999999990.99'))
    ||';'
    ||TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTAP_BSUB_ICMS,2)),0),'999999990.99'))
    ||';'
    ||TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTAP_ALIQ_ICMS,2)),0),'999999990.99'))
    ||';'
    ||'0.00'
    ||';'
    ||TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTAP_VLR_ICMS,2)),0),'999999990.99'))
    ||';'
    ||TRIM(TO_CHAR(NVL(MAX(ROUND(case when (DB_NOTAP_VLR_SUBST = 0) and (select db_proda_valor from mercanet_prd.db_produto_atrib where db_proda_codigo = db_notap_produto and db_proda_atrib = 2008) in ('C', 'V') then DB_NOTAP_VLR_DESCT else 0 end,2)),0),'999999990.99'))
    ||';'
    ||'0.00'
    ||';'
    ||max(NVL(db_notap_operacao,NULL))
    ||';'
    ||max(case when (DB_NOTAP_CDEPOSITO = '10' or DB_NOTAP_CDEPOSITO = '60' or DB_NOTAP_CDEPOSITO = '70') then 'S'  else  case when (DB_NOTAP_CDEPOSITO = '40' or DB_NOTAP_CDEPOSITO = '41') then  'I'  else 'N'  end end)
    ||';'
    ||(select (decode(DB_PROD_clasfis,'POS','P','NEG','N','NEU','O','')) from mercanet_prd.db_produto where db_nota_prod.db_notap_produto = db_produto.DB_PROD_CODIGO)
    ||';'
    ||'0'
    ||';'
    ||'1'
    ||';'
    ||''
    ||';'
    ||'0.00'
    ||';'
    ||TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTAP_VALOR,2)),0),'999999990.99'))
    ||';'
    ||TRIM(TO_CHAR(NVL(MAX(ROUND(DB_NOTAP_VALOR,2)),0),'999999990.99'))
    ||';'
    ||NVL(MAX(DB_NOTAP_CDEPOSITO),'')
    ||';'
    ||'0.00'
    ||';'
    ||'0.00'
    ||';'
    ||(select (decode(DB_PRODA_VALOR, 'L' , 'L' , 'M' )) from mercanet_prd.db_produto_atrib where db_produto_atrib.DB_PRODA_ATRIB = 2008 and  db_nota_prod.db_notap_produto = db_produto_atrib.DB_PRODA_CODIGO)
    ||';'
    ||chr(10)||
'4.1;'||NVL(MAX(DB_NOTAP_NROSERIE),0)||';'||NVL(MAX(DB_NPI_LOTE),'')||';'||NVL(MAX(DB_NPI_QTDE),0)||';'||NVL(MAX(TO_CHAR(DB_NPI_DATA_VCTO, 'YYYY-MM-DD')),null)||';'||chr(10) AS "DETALHE_4_e_4.1",

'5;0.00;'||TRIM(TO_CHAR(NVL(MAX(ROUND((SELECT sum(nfp.DB_NOTAP_BASE_ICMS) from mercanet_prd.db_nota_prod nfp where nfp.DB_NOTAP_NRO = db_nota_fiscal.DB_NOTA_NRO and nfp.DB_NOTAP_EMPRESA = db_nota_fiscal.DB_NOTA_EMPRESA and nfp.DB_NOTAP_SERIE = db_nota_fiscal.DB_NOTA_SERIE),2)),0),'999990.99'))
||';'||(select trim(to_char(round(SUM(NVL(nfp.db_notap_vlr_icms, 0)), 2),'999999990.99'))
  from mercanet_prd.db_nota_prod nfp
 where nfp.DB_NOTAP_NRO = db_nota_fiscal.DB_NOTA_NRO
   and nfp.DB_NOTAP_EMPRESA = db_nota_fiscal.DB_NOTA_EMPRESA
   and nfp.DB_NOTAP_SERIE = db_nota_fiscal.DB_NOTA_SERIE)||';'||chr(10)||
'6;'||(select trim(to_char(round(SUM(NVL(nfp.db_notap_vlr_icms, 0)), 2),'999999990.99'))
  from mercanet_prd.db_nota_prod nfp
 where nfp.DB_NOTAP_NRO = db_nota_fiscal.DB_NOTA_NRO
   and nfp.DB_NOTAP_EMPRESA = db_nota_fiscal.DB_NOTA_EMPRESA
   and nfp.DB_NOTAP_SERIE = db_nota_fiscal.DB_NOTA_SERIE)||';0.00;'||MAX(NVL(DB_NOTA_VOLUMES,0))||';'||chr(10)||
'8;;;0.00;;0.00;0.00;0.00;0.00;0.00;;;;0.00;'||chr(10)||
'9;'||(((select count(*) 
          from mercanet_prd.db_nota_prod
         where db_notap_nro = db_nota_nro
           and db_notap_serie = db_nota_serie
           and db_notap_empresa = db_nota_empresa          
           and db_notap_ident is null) +           
       (select count(*) 
          from mercanet_prd.db_nota_prod_it, mercanet_prd.db_nota_prod
         where db_notap_nro = db_nota_nro
           and db_notap_serie = db_nota_serie
           and db_notap_empresa = db_nota_empresa          
           and db_notap_ident is null     
           and db_notap_nro = db_npi_nro
           and db_notap_serie = db_npi_serie
           and db_notap_empresa = db_npi_empresa
           and db_notap_seq = db_npi_notapseq          
          )) + 7)||';'||chr(10) as TRAILER_5_6_8_9 
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
 left JOIN mercanet_prd.DB_Edi_Pedido
    ON DB_Edi_Pedido.DB_EdiP_PedMerc = DB_Pedido.DB_Ped_Nro
  LEFT JOIN mercanet_prd.DB_Nota_Prod_IT
    ON DB_Nota_Prod_IT.DB_NPI_Empresa = DB_Nota_Prod.DB_NotaP_Empresa
   AND DB_Nota_Prod_IT.DB_NPI_Nro = DB_Nota_Prod.DB_NotaP_Nro
   AND DB_Nota_Prod_IT.DB_NPI_Serie = DB_Nota_Prod.DB_NotaP_Serie
   AND DB_Nota_Prod_IT.DB_NPI_NotaPSeq = DB_Nota_Prod.DB_NotaP_Seq
 WHERE/* db_pedt_distr = 511
   AND */(EXISTS (SELECT 1
                  FROM mercanet_prd.Db_Tb_TpPedido
                 WHERE Db_TbTPe_Codigo = Db_Ped_Tipo
                   AND Db_TbTPe_OperLog = 1))
  -- AND (Db_NotaP_Ident IS NULL OR Db_NotaP_Ident = 0)
 AND DB_Nota_Ped_Merc IN (88081739)
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

