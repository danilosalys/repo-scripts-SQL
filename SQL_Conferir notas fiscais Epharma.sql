--Data de Criação do Script: 04/07/2013
--Por: Danilo Sales
--Importante: 1) A principio, a query somente retornará os valores após o término da execução do Integrator de Pedidos, 
--               pois há joins com o campo LNID.
--            2) Esta sendo executada a partir do Banco DC01. Caso queira executar a partir dos bancos DC12 e DC09, trocar
--               os DBLinks. 
--            3) Ao adicionar colunas, colocar a função MAX(), pois é feito o agrupamento somente pelo campo LNID em função
--               dos produtos que são processados com Split de Almoxarifado.
--            4) Adicionar os Numeros dos Pedidos Mercanet onde há o comentário indicando 







select distinct savr01  "Pedido Mercanet",
                        sddoco "Pedido JDE",
                        sbukid "UKID",
                        case when (db_edii_bonif) = 1 then 'SIM' else 'NÃO' END "BONIF?",
                        db_edii_produto "PRODUTO Edi PedProd",
                        db_pdit_produto "PRODUTO Distr IT",
                        db_pedi_produto "PRODUTO Pedido Prod",
                        sblitm "PRODUTO F5547012",
                        sdlitm "PRODUTO F4211",
                        db_edii_seq "Seq EDI PedProd",
                        db_pdit_edii_seq "Seq PedProd em DistrIT",
                        db_pdit_seq "Seq Distr IT",
                        db_pedi_sequencia "Seq Pedido Prod",
                        sbseq "Seq F5547012",
                        db_notap_seq "Seq Nota Prod",
                        FLOOR(sblnid / 1000) "LNID F5547012",
                        sdlnid "LNID F4211",
                        db_edii_qtde_vda "QTDE SOLIC Edi PedProd",
                        db_pdit_qtdeenv "QTDE SOLIC Distr IT",
                        db_pedi_qtde_solic "QTDE SOLIC Pedido Prod",
                        sbuorg "QTDE SOLIC F5547012",
                        sduorg "QTDE SOLICT F4211",                        
                        db_edii_perc_dcto "DESC Edi PedProd",
                        db_pdit_dcto "DESC Distr IT",
                        db_pedi_desctop "DESC Pedido Prod",
                        sbuom||(sbstdslpr||sbuprc)/100 as "DESC F5547012",
                        db_edii_valor1/100 "Desconto Arq Pedido",
                        NVL((case
                                  when (select count(1)
                                          from mercanet_prd.db_pedido_distr_it@dc09,
                                               mercanet_prd.db_edi_pedprod@dc09,
                                               mercanet_prd.db_pedido_prod@dc09
                                         where db_nota_ped_merc = db_pedi_pedido
                                           and db_notap_seq = db_pedi_sequencia
                                           and db_pedi_pedido = db_pdit_pedido
                                           and db_pedi_sequencia = db_pdit_seq
                                           and db_pedi_produto = db_pdit_produto
                                           and db_pdit_pedido = db_edii_pedmerc
                                           and db_pdit_edii_seq = db_edii_seq
                                           and db_edii_bonif = 1) > 0 then
                                   100
                                  else
                                   NVL(DB_NOTAP_ALIQ_RP, 0)
                                end),
                                0) "Desconto no Arq Ret NF"
          from mercanet_prd.db_edi_pedprod@dc09,
               mercanet_prd.db_pedido_distr_it@dc09,
               mercanet_prd.db_pedido_prod@dc09,
               mercanet_prd.db_nota_prod@dc09,
               mercanet_prd.db_nota_fiscal@dc09,
               proddta.f5547012,
               proddta.f5547011,
               (select sum(FLOOR(sdlnid / 1000)) as sdlnid,
                       sdlitm,
                       sduorg,
                       sddoco,
                       sdoorn
                  from proddta.f42119 , proddta.f5547011
                 where sddoco = sadoco 
                 and exists (select * from mercanet_prd.db_edi_pedido@dc09, mercanet_prd.db_edi_lote_distr@dc09
                             where db_edip_lote = db_edild_seq
                             and db_edip_pedmerc > 0
                             and to_char(db_edip_pedmerc) = trim(savr01)
                             and to_CHAR(db_edild_data,'ddmmyyyy')  =  &"DATA")
                 group by sdlnid, sdlitm, sduorg, sddoco, sdoorn
                 order by sdlnid) F4211
         where exists (select * from mercanet_prd.db_edi_pedido@dc09, mercanet_prd.db_edi_lote_distr@dc09
                             where db_edip_lote = db_edild_seq
                             and db_edip_pedmerc > 0
                             and to_CHAR(db_edild_data,'ddmmyyyy')  = &"DATA")
           and db_edii_pedmerc = db_pdit_pedido
           and db_edii_seq = db_pdit_edii_seq
           and db_edii_qtde_vda = db_pdit_qtdeenv
           and db_pdit_pedido = db_pedi_pedido
           and db_pdit_produto = db_pedi_produto
           and db_pdit_qtdeenv = db_pedi_qtde_solic
           and to_char(db_pedi_pedido) = trim(savr01)
           and saukid = sbukid
           and to_char(db_pedi_produto) = trim(sblitm)
           and db_pedi_sequencia = sbseq
          -- and     FLOOR(sblnid / 1000) = sdlnid
           and sblitm = sdlitm
           and trim(sdoorn) = trim(savr01)
           and sadoco = sddoco
           and db_pedi_pedido = db_nota_ped_merc
           and db_nota_nro = db_notap_nro
           and db_nota_serie = db_notap_serie
           and db_pedi_sequencia = db_notap_seq
           and db_pedi_produto = db_notap_produto
     --    group by sdlnid
    
union

select distinct savr01  "Pedido Mercanet",
                        sddoco "Pedido JDE",
                        sbukid "UKID",
                        case when (db_edii_bonif) = 1 then 'SIM' else 'NÃO' END "BONIF?",
                        db_edii_produto "PRODUTO Edi PedProd",
                        db_pdit_produto "PRODUTO Distr IT",
                        db_pedi_produto "PRODUTO Pedido Prod",
                        sblitm "PRODUTO F5547012",
                        sdlitm "PRODUTO F4211",
                        db_edii_seq "Seq EDI PedProd",
                        db_pdit_edii_seq "Seq PedProd em DistrIT",
                        db_pdit_seq "Seq Distr IT",
                        db_pedi_sequencia "Seq Pedido Prod",
                        sbseq "Seq F5547012",
                        db_notap_seq "Seq Nota Prod",
                        FLOOR(sblnid / 1000) "LNID F5547012",
                        sdlnid "LNID F4211",
                        db_edii_qtde_vda "QTDE SOLIC Edi PedProd",
                        db_pdit_qtdeenv "QTDE SOLIC Distr IT",
                        db_pedi_qtde_solic "QTDE SOLIC Pedido Prod",
                        sbuorg "QTDE SOLIC F5547012",
                        sduorg "QTDE SOLICT F4211",                        
                        db_edii_perc_dcto "DESC Edi PedProd",
                        db_pdit_dcto "DESC Distr IT",
                        db_pedi_desctop "DESC Pedido Prod",
                        sbuom||(sbstdslpr||sbuprc)/100 as "DESC F5547012",
                        db_edii_valor1/100 "Desconto Arq Pedido",
                        NVL((case
                                  when (select count(1)
                                          from mercanet_prd.db_pedido_distr_it@dc09,
                                               mercanet_prd.db_edi_pedprod@dc09,
                                               mercanet_prd.db_pedido_prod@dc09
                                         where db_nota_ped_merc = db_pedi_pedido
                                           and db_notap_seq = db_pedi_sequencia
                                           and db_pedi_pedido = db_pdit_pedido
                                           and db_pedi_sequencia = db_pdit_seq
                                           and db_pedi_produto = db_pdit_produto
                                           and db_pdit_pedido = db_edii_pedmerc
                                           and db_pdit_edii_seq = db_edii_seq
                                           and db_edii_bonif = 1) > 0 then
                                   100
                                  else
                                   NVL(DB_NOTAP_ALIQ_RP, 0)
                                end),
                                0) "Desconto no Arq Ret NF"
          from mercanet_prd.db_edi_pedprod@dc09,
               mercanet_prd.db_pedido_distr_it@dc09,
               mercanet_prd.db_pedido_prod@dc09,
               mercanet_prd.db_nota_prod@dc09,
               mercanet_prd.db_nota_fiscal@dc09,
               proddta.f5547012,
               proddta.f5547011,
               (select sum(FLOOR(sdlnid / 1000)) as sdlnid,
                       sdlitm,
                       sduorg,
                       sddoco,
                       sdoorn
                  from proddta.f42119 , proddta.f5547011
                 where sddoco = sadoco 
                 and savr01 in ('81273999','81274000','81274001','81274002','81274003','81274004','81274005','81274006','81274007',
                                  '81274008','81274009','81274010','81274011','81274012','81274013','81274014','81274015','81274016',
                                  '81274017','81274018','81274019','81274020','81274021','81274022','81274023','81274024','81274025',
                                  '81274026','81274027','81274028','81274029','81274030','81274031','81274032','81274033','81274034',
                                  '81274035','81274036','81274037','81274038','81274039','81274040','81274041','81274042','81274043',
                                  '81274044','81274045','81274046','81274047','81274048','81274049','81274050','81274051','81274052',
                                  '81274053','81274054','81274055','81274056','81274057','81274058','81274059','81274060','81274061') --// <-- Inserir o Numero do Pedido Mercanet
                 group by sdlnid, sdlitm, sduorg, sddoco, sdoorn
                 order by sdlnid) F42119
         where db_edii_pedmerc in (81273999 , 81274000, 81274001 , 81274002 , 81274003  , 81274004 , 81274005 , 81274006 , 81274007 ,
                                   81274008 , 81274009 , 81274010 , 81274011 , 81274012 , 81274013 , 81274014 , 81274015 , 81274016 ,
                                   81274017 , 81274018 , 81274019 , 81274020 , 81274021 , 81274022 , 81274023 , 81274024 , 81274025 ,
                                   81274026 , 81274027 , 81274028 , 81274029 , 81274030 , 81274031 , 81274032 , 81274033 , 81274034 ,
                                   81274035 , 81274036 , 81274037 , 81274038 , 81274039 , 81274040 , 81274041 , 81274042 , 81274043 ,
                                   81274044 , 81274045 , 81274046 , 81274047 , 81274048 , 81274049 , 81274050 , 81274051 , 81274052 ,
                                   81274053 , 81274054 , 81274055 , 81274056 , 81274057 , 81274058 , 81274059 , 81274060 , 81274061 ) --// <-- Inserir o Numero do Pedido Mercanet
           and db_edii_pedmerc = db_pdit_pedido
           and db_edii_seq = db_pdit_edii_seq
           and db_edii_qtde_vda = db_pdit_qtdeenv
           and db_pdit_pedido = db_pedi_pedido
           and db_pdit_produto = db_pedi_produto
           and db_pdit_qtdeenv = db_pedi_qtde_solic
           and to_char(db_pedi_pedido) = trim(savr01)
           and saukid = sbukid
           and to_char(db_pedi_produto) = trim(sblitm)
           and db_pedi_sequencia = sbseq
          -- and     FLOOR(sblnid / 1000) = sdlnid
           and sblitm = sdlitm
           and trim(sdoorn) = trim(savr01)
           and sadoco = sddoco
           and db_pedi_pedido = db_nota_ped_merc
           and db_nota_nro = db_notap_nro
           and db_nota_serie = db_notap_serie
           and db_pedi_sequencia = db_notap_seq
           and db_pedi_produto = db_notap_produto
     --    group by sdlnid
        
