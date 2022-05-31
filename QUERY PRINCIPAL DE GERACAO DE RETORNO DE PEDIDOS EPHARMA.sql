--QUERY PRINCIPAL RETORNO PD EPHARMA 
select (SELECT DECODE(INSTR(NVL(RTRIM(XMLAGG(XMLELEMENT(e,DECODE(DB_EDII_MOTIVORET,'E03','E','E05','E','E11','E','E12','E','E21','E','E52','E'))).extract('//text()'),','),'50'),'E'),1,DECODE(INSTR(RTRIM(XMLAGG(XMLELEMENT(e,DB_EDII_MOTIVORET)).extract('//text()'),','),'E52'),0,DECODE(INSTR(RTRIM(XMLAGG(XMLELEMENT(e,DB_EDII_MOTIVORET)).extract('//text()'),','),'E11'),0,DECODE(INSTR(RTRIM(XMLAGG(XMLELEMENT(e,DB_EDII_MOTIVORET)).extract('//text()'),','),'E05'),0,DECODE(INSTR(RTRIM(XMLAGG(XMLELEMENT(e,DB_EDII_MOTIVORET)).extract('//text()'),','),'E03'),0,DECODE(INSTR(RTRIM(XMLAGG(XMLELEMENT(e,DB_EDII_MOTIVORET)).extract('//text()'),','),'E21'),0,DECODE(INSTR(RTRIM(XMLAGG(XMLELEMENT(e,DB_EDII_MOTIVORET)).extract('//text()'),','),'E12'),0,'ERRO','12'),'21'),'03'),'05'),'11'),'52'),'50') FROM MERCANET_QA.DB_EDI_PEDIDO A,MERCANET_QA.DB_EDI_PEDPROD B WHERE A.DB_EDIP_COMPRADOR=B.DB_EDII_COMPRADOR AND A.DB_EDIP_NRO=B.DB_EDII_NRO AND A.DB_EDIP_COMPRADOR=DB_EDI_PEDIDO.DB_EDIP_COMPRADOR AND A.DB_EDIP_NRO=DB_EDI_PEDIDO.DB_EDIP_NRO GROUP BY A.DB_EDIP_NRO) AS MOTIVO_CABECALHO,
       DB_EDIP_NRO,
--       NVL(MAX(DB_EDIP_CLIENTE),DECODE(MAX(DB_EDIP_TXT3),'SP','05651966000455','MG','05651966000617','GO','05651966000102','RJ','05651966000960','PR','05651966001184','SC','05651966001184','DF','05651966001265')) AS FILIAL_FATURAMETNTO,
       SUBSTR(MAX(DECODE(DB_EDII_MOTIVORET,
                  'E03',
                  'E13',
                  'E05',
                  'E13',
                  'E11',
                  'E13',
                  'E12',
                  'E13',
                  'E21',
                  'E13',
                  'E52',
                  (CASE
                    WHEN (SELECT COUNT(1)
                            FROM MERCANET_QA.DB_PEDIDO_DISTR_IT,
                                 MERCANET_QA.DB_PEDIDO_PROD
                           WHERE DB_EDI_PEDPROD.DB_EDII_PEDMERC = DB_PDIT_PEDIDO
                             AND DB_EDI_PEDPROD.DB_EDII_SEQ = DB_PDIT_EDII_SEQ
                             AND DB_PDIT_PEDIDO = DB_PEDI_PEDIDO
                             AND DB_PDIT_PEDI_SEQ = DB_PEDI_SEQUENCIA
                             AND DB_PDIT_PRODUTO = DB_PEDI_PRODUTO
                             AND DB_PEDI_SITCORP1 IN ('980', '982', '984')) > 0 THEN
                     'E06'
                    ELSE
                     'E13'
                  END),
                  DB_EDII_MOTIVORET)),2) AS MOTIVO_RETORNO,
       (SELECT RTRIM(XMLAGG(XMLELEMENT(e, DB_EDII_MOTIVORET))
                     .extract('//text()'),
                     ',')
          FROM MERCANET_QA.DB_EDI_PEDIDO T1, MERCANET_QA.DB_EDI_PEDPROD T2
         WHERE T1.DB_EDIP_COMPRADOR = T2.DB_EDII_COMPRADOR
           AND T1.DB_EDIP_NRO = T2.DB_EDII_NRO
           AND T1.DB_EDIP_VAN = 511
           AND T1.DB_EDIP_COMPRADOR = DB_EDI_PEDIDO.DB_EDIP_COMPRADOR
           AND T1.DB_EDIP_NRO = DB_EDI_PEDIDO.DB_EDIP_NRO
         GROUP BY T1.DB_EDIP_PEDMERC, T1.DB_EDIP_NRO) MOTIVOS_DETALHE,
       db_edip_Comprador || db_edip_Nro Pedido,
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
       TO_CHAR(CURRENT_DATE, 'DDMMYYYY') AS CQ3,
       MAX(db_edip_comprador) AS CQ6,
       MAX(NVL(SUBSTR((NVL(nvl(substr(db_edip_nro,
                                      1,
                                      instr(db_edip_nro, '-', 1, 1) - 1),
                               db_edip_nro),
                           0)),
                      14,
                      12),
               db_edip_nro)) AS CQ7,
       TO_CHAR(CURRENT_DATE, 'DDMMYYYY') AS CQ8,
       TO_CHAR(SYSDATE, 'HH24MISS') AS CQ10,
       CASE
         WHEN max(DB_EDIP_PEDMERC) IS NULL THEN
          lpad(max(nvl(substr(DB_EDIP_LOTE, 1, 6), 0)), 12, 0)
         ELSE
          CASE
            WHEN max(DB_EDIP_PEDMERC) = 0 THEN
             lpad(max(nvl(substr(DB_EDIP_LOTE, 1, 6), 0)), 12, 0)
            ELSE
             lpad(max(nvl(substr(DB_EDIP_PEDMERC, 3, 6), 0)), 12, 0)
          END
       END AS CQ12,
       NVL(max(CASE
                 WHEN (SELECT COUNT(1)
                         FROM mercanet_qa.db_edi_pedprod P
                        WHERE P.DB_EDII_NRO = DB_EDIP_NRO
                          AND P.DB_EDII_COMPRADOR = DB_EDIP_COMPRADOR
                          AND P.db_edii_motivoret in ('05', '52', '03', '21', '11')
                          AND ROWNUM = 1) > 0 THEN
                  db_edii_motivoret
                 ELSE
                  CASE
                    WHEN (SELECT COUNT(1)
                            FROM mercanet_qa.db_edi_pedprod P
                           WHERE P.DB_EDII_NRO = DB_EDIP_NRO
                             AND P.DB_EDII_COMPRADOR = DB_EDIP_COMPRADOR
                             AND P.DB_EDII_MOTIVORET NOT IN
                                 ('05', '52', '03', '21', '11')
                             AND P.DB_EDII_MOTIVORET IN ('04', '06', '07', '13', '14')) > 0 THEN
                     '50'
                    ELSE
                     '50'
                  END
               END),
           '50') AS CQ13,
       NVL(MAX(Db_EDII_Produto), 0) AS CQ15,
       NVL(MAX((select NVL(max(db_pedi_qtde_atend), 0)
                 from mercanet_qa.db_pedido_prod,
                      mercanet_qa.db_pedido_distr_it
                where db_pedido_prod.db_pedi_pedido =
                      db_pedido_distr_it.db_pdit_pedido
                  and db_pedido_prod.db_pedi_sequencia =
                      db_pedido_distr_it.db_pdit_pedi_seq
                  and db_pedido_distr_it.db_pdit_pedido =
                      db_edi_pedprod.db_edii_pedmerc
                  and db_pedido_distr_it.db_pdit_edii_seq =
                      db_edi_pedprod.db_edii_seq
                  and db_pedido_prod.db_pedi_qtde_atend > 0)),
           0) AS CQ16,
       (SUM(NVL(db_edii_qtde_vda, 0)) -
       SUM(NVL((Select NVL(pdt.db_pdit_qtdeatd, 0)
                  from mercanet_qa.Db_PedidO_Distr_IT pdt
                 where pdt.db_pdit_pedido = db_edii_pedmerc
                   and pdt.db_pdit_edii_seq = db_edii_seq),
                0))) AS CQ17,
       MAX(DB_EDII_VALOR1) / 100 AS CQ18,
       MAX(db_edii_motivoret) AS CQ19,
       MAX(NVL(SUBSTR((NVL(nvl(substr(db_edip_nro,
                                      1,
                                      instr(db_edip_nro, '-', 1, 1) - 1),
                               db_edip_nro),
                           0)),
                      14,
                      12),
               db_edip_nro)) AS CQ22,
       (NVL(((select count(*)
                from mercanet_qa.db_edi_pedprod
               where db_edii_nro = db_edip_nro
                 and db_edii_comprador = db_edip_comprador)),
            0) + 2) AS CQ23,
       (NVL(MAX((Select sum(NVL(Distr.Db_PDIT_QtdeAtd, 0))
                  From mercanet_qa.Db_PEdido_Distr_IT Distr
                 Where Distr.Db_PDIT_Pedido = Db_Edi_Pedido.Db_EDiP_PedMerc)),
            0)) AS CQ24,
       MAX((((select sum(edii.Db_EDiI_Qtde_Vda)
                from mercanet_qa.db_edi_pedprod edii
               where edii.db_edii_comprador =
                     db_edi_pedido.db_edip_Comprador
                 and edii.db_edii_nro = db_edi_pedido.db_edip_nro) -
           NVL((Select Sum(NVL(Distr.Db_PDIT_QtdeAtd, 0))
                   From mercanet_qa.Db_PEdido_Distr_IT Distr
                  Where Distr.Db_PDIT_Pedido =
                        Db_Edi_Pedido.Db_EDiP_PedMerc),
                 0)))) AS CQ25,
       lpad((select count(distinct t1.db_edip_comprador || t1.db_edip_nro)
              from mercanet_qa.db_edi_pedido t1
             where t1.db_edip_lote = db_edi_pedido.db_edip_lote),
            6,
            '0') AS CQ29,
       (select count(t2.db_edii_seq) + count(distinct t1.db_edip_nro) * 2 + 2
          from mercanet_qa.db_edi_pedido t1, mercanet_qa.db_edi_pedprod t2
         where t1.db_edip_nro = t2.db_edii_nro
           and t1.db_edip_comprador = t2.db_edii_comprador
           and t1.db_edip_lote = db_edi_pedido.db_edip_lote) AS CQ30,
       (select sum(NVL(t3.Db_PDIT_QtdeAtd, 0))
          from mercanet_qa.db_edi_pedido      t1,
               mercanet_qa.db_edi_pedprod     t2,
               mercanet_qa.db_pedido_distr_it t3
         where t1.db_edip_nro = t2.db_edii_nro
           and t1.db_edip_comprador = t2.db_edii_comprador
           and t2.db_edii_pedmerc = t3.db_pdit_pedido
           and t2.db_edii_seq = t3.db_pdit_edii_seq
           and t1.db_edip_lote = db_edi_pedido.db_edip_lote) AS CQ31,
       (select sum(NVL(t2.db_edii_qtde_vda, 0))
          from mercanet_qa.db_edi_pedido t1, mercanet_qa.db_edi_pedprod t2
         where t1.db_edip_nro = t2.db_edii_nro
           and t1.db_edip_comprador = t2.db_edii_comprador
           and t1.db_edip_lote = db_edi_pedido.db_edip_lote) -
       (select sum(NVL(t3.Db_PDIT_QtdeAtd, 0))
          from mercanet_qa.db_edi_pedido      t1,
               mercanet_qa.db_edi_pedprod     t2,
               mercanet_qa.db_pedido_distr_it t3
         where t1.db_edip_nro = t2.db_edii_nro
           and t1.db_edip_comprador = t2.db_edii_comprador
           and t2.db_edii_pedmerc = t3.db_pdit_pedido
           and t2.db_edii_seq = t3.db_pdit_edii_seq
           and t1.db_edip_lote = db_edi_pedido.db_edip_lote) AS CQ32
  from mercanet_qa.db_edi_pedido, mercanet_qa.db_edi_Pedprod
 where db_edip_comprador = Db_Edii_Comprador
   and db_edip_nro = db_edii_nro
   and DB_EDIP_VAN = 511
   and Db_EDiP_Tipo = 1
   AND DB_EDIP_LOTE > 311760
      /*   AND Db_EDiP_DtEnvio Between
      to_date('2017-09-28 00:00:00', 'yyyy-mm-dd hh24:mi:ss') And
      to_date('2017-09-28 23:59:59', 'yyyy-mm-dd hh24:mi:ss')*/
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
 Group By db_edip_lote,
          Db_ediP_Nro,
          db_edip_Pedmerc,
          Db_ediP_Comprador,
          Db_edii_Produto,
          db_edip_projeto,
          Db_EdiP_Empresa,
          Db_EdiP_OrdCompra,
          Db_EdiP_Nro,
          Db_EdiP_NrPedSeq,
          Db_EdiP_OBS2,
          Db_EdiI_Seq,
          Db_EdiP_Txt1,
          Db_EdiP_Txt2,
          Db_EdiP_Txt3
 Order By db_edip_lote, 2;

