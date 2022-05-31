--RELACIONA VENDA X TRANF X REMESSA ORDEM X RETORNO SIMBOLICO

select distinct p.sddoco,
                p.sdemcu,
                p.sddcto,
                (select distinct Np.fdbnnf
                   from qadta.f7611b Np
                  where p.sddoco = Np.Fddoco
                    and p.sddcto = Np.Fdpdct) as "Nota de Venda",
                
                (select distinct Np.fdbser
                   from qadta.f7611b Np
                  where p.sddoco = Np.Fddoco
                    and p.sddcto = Np.Fdpdct) as "Serie Nota de Venda",
                
                (select distinct t.vtdoc1
                   from qadta.f554241 t
                  where p.sddoco = t.vtdoco
                    and p.sddcto = t.vtdcto
                    and t.vtdct1 in('VU','ZU')) "Pedido Tranf",
                
                (select distinct t.vtdct1
                   from qadta.f554241 t
                  where p.sddoco = t.vtdoco
                    and p.sddcto = t.vtdcto
                    and t.vtdct1 in('VU','ZU')) "Tipo Ped Tranf",
                
                (select distinct Nt.Fdbnnf
                   from qadta.f554241 t, qadta.f7611b Nt
                  where p.sddoco = t.vtdoco
                    and p.sddcto = t.vtdcto
                    and t.vtdct1 in('VU','ZU')
                    and t.vtdoc1 = Nt.Fddoco) "Nota Tranf",
                
                (select distinct Nt.Fdbser
                   from qadta.f554241 t, qadta.f7611b Nt
                  where p.sddoco = t.vtdoco
                    and p.sddcto = t.vtdcto
                    and t.vtdct1 in ('VU','ZU')
                    and t.vtdoc1 = Nt.Fddoco) "Serie Nota Tranf",
                
                (select distinct r.vtdoc1
                   from qadta.f554241 r
                  where vtdoco = (select distinct t.vtdoc1
                                    from qadta.f554241 t
                                   where p.sddoco = t.vtdoco
                                     and p.sddcto = t.vtdcto
                                     and t.vtdct1 in ('VU','ZU'))
                    and vtdct1 = 'U4') "Pedido de Remessa",
                
                (select distinct rem.vtdct1
                   from qadta.f554241 rem
                  where vtdoco = (select distinct t.vtdoc1
                                    from qadta.f554241 t
                                   where p.sddoco = t.vtdoco
                                     and p.sddcto = t.vtdcto
                                     and t.vtdct1 in('VU','ZU'))
                    and vtdct1 = 'U4') "Tipo Ped Remessa",
                
                (select distinct Nrem.fdbnnf
                   from qadta.f7611b Nrem
                  where Nrem.fddoco =
                        (select distinct rem.vtdoc1
                           from qadta.f554241 rem
                          where vtdoco = (select distinct t.vtdoc1
                                            from qadta.f554241 t
                                           where p.sddoco = t.vtdoco
                                             and p.sddcto = t.vtdcto
                                             and t.vtdct1 in('VU','ZU'))
                            and rem.vtdct1 = 'U4')) "Nota de Remessa",
                
                (select distinct Nrem.fdbser
                   from qadta.f7611b Nrem
                  where Nrem.fddoco =
                        (select distinct rem.vtdoc1
                           from qadta.f554241 rem
                          where vtdoco = (select distinct t.vtdoc1
                                            from qadta.f554241 t
                                           where p.sddoco = t.vtdoco
                                             and p.sddcto = t.vtdcto
                                             and t.vtdct1 in('VU','ZU'))
                            and rem.vtdct1 = 'U4')) "Serie Nota de Remessa",
                
                (select distinct ret.vtdoc1
                   from qadta.f554241 ret
                  where p.sddoco = ret.vtdoco
                    and p.sddcto = ret.vtdcto
                    and ret.vtdct1 = 'U3') "Pedido Retorno",
                
                (select distinct ret.vtdct1
                   from qadta.f554241 ret
                  where p.sddoco = ret.vtdoco
                    and p.sddcto = ret.vtdcto
                    and ret.vtdct1 = 'U3') "Tipo Ped Retorno",
                
                (select distinct Nret.Fdbnnf
                   from qadta.f554241 ret, qadta.f7611b Nret
                  where p.sddoco = ret.vtdoco
                    and p.sddcto = ret.vtdcto
                    and ret.vtdct1 = 'U3'
                    and ret.vtdoc1 = Nret.Fddoco) "Nota Retorno",
                
                (select distinct Nret.Fdbser
                   from qadta.f554241 ret, qadta.f7611b Nret
                  where p.sddoco = ret.vtdoco
                    and p.sddcto = ret.vtdcto
                    and ret.vtdct1 = 'U3'
                    and ret.vtdoc1 = Nret.Fddoco) "Serie Nota Retorno"
  from qadta.f4211 p, qadta.f4201
 where p.sddoco in (10173789,10173790,10173791,10173792)
 and p.sddoco = shdoco
and shhold = ' '
    and sdlttr < 980 
Order by sddoco






