select a.saan8 as Cliente,
       a.saptc as Cond_Pgto,
       a.savr01 as Ped_Merc,
       sddoco as Ped_JDE,
       a.samcu  as Empresa,
       trim(b.sblitm) as Produto,
       pol.db_pedi_qtde_solic as QTDE_Solic_OL,
       (select sum(db_pedd_desconto) from mercanet_qa.db_pedido_desconto@dc12.drogacenter.com.br peddesc
         where peddesc.db_pedd_nro = pol.db_pedi_pedido 
           and peddesc.db_pedd_seqit = pol.db_pedi_sequencia
           and peddesc.db_pedd_tpdesc <> 1) as Desc_Comercial_CQOPerlog1,
---       pol.db_pedi_desctop||'%' as Desc_Comercial_CQOPerlog2,
       pol.db_pedi_vlr_subst/pol.db_pedi_qtde_solic as StMerc,
      (select sum(hdem.alfvtr)
          from qadta.f4074 hdem
         where hdem.aldoco  = x.aldoco
           and hdem.allnid = x.allnid
           and hdem.alfvtr < 0
           and hdem.albscd not in ('8', ' '))/10000*(-1)||'%' as Desc_Comercial_JDE,
       aluprc / 10000 as StJde,
        allnid, alfvtr, aluprc
 from qadta.f4211,
      qadta.f4074 x,
      qadta.f5547011 a,
      qadta.f5547012 b,
      mercanet_qa.db_edi_pedido@dc12.drogacenter.com.br ediol,
      mercanet_qa.db_edi_pedprod@dc12.drogacenter.com.br ediiol,
      mercanet_qa.db_pedido_distr@dc12.drogacenter.com.br pedtol,
      mercanet_qa.db_pedido_distr_it@dc12.drogacenter.com.br pditol,
      mercanet_qa.db_pedido_prod@dc12.drogacenter.com.br pol
where sddoco = a.sadoco -- Informar Pedido Cac
  and sddoco = x.aldoco
  and sdlnid = x.allnid
  and trim(a.savr01) = to_char(pol.db_pedi_pedido)
  and trim(sdlitm) = pol.db_pedi_produto
  and x.alast in ('V0000190','V0000225')
  and sdsoqs > 0
  and a.savr01 in ('80077306') -- Informar Pedido Mercanet
  and a.saukid = b.sbukid
  and b.sban03 in (0, 100) --ST Isento e Atenc.
  and b.sblitm = sdlitm
  and pol.db_pedi_pedido = ediol.db_edip_pedmerc
  and ediol.db_edip_comprador= ediiol.db_edii_comprador
  and ediol.db_edip_pedmerc = pedtol.db_pedt_pedido
  and pedtol.db_pedt_pedido = pditol.db_pdit_pedido
  and pditol.db_pdit_edii_seq = ediiol.db_edii_seq
  and pditol.db_pdit_pedi_seq = pol.db_pedi_sequencia
  and ediol.db_edip_nro= ediiol.db_edii_nro
  and sdlitm = '43138'
order by a.savr01; 


