select *--sdemcu,sddcto,count(1)
  from (select distinct savr01,
                         (select ABALPH from QADTA.f0101 where aban8 = sdan8) as nome_cliente,
                        trim((select abac16 from QADTA.f0101 where aban8 =  (select mcan8 from QADTA.f0006 where mcmcu = sdemcu))) ||'x'|| trim((select abac16 from QADTA.f0101 where aban8 = sdan8)) AS ORIGEM_DESTINO,
                        sddoco,
                        sdnxtr,
                        sdlttr,
                        sdeuse,
                        shhold,
                        sdzon,
                        sddcto,
                        sdemcu,
                        --'rename '|| nota ||' '|| 'NF_'||fdbnnf||'-'||fdbser||'_'||trim((select abac16 from QADTA.f0101 where aban8 =  (select mcan8 from QADTA.f0006 where mcmcu = sdemcu))) ||'x'|| trim((select abac16 from QADTA.f0101 where aban8 = sdan8)) ||'.pdf;'  as Origem_DESTINO,
                        case when sdivd = 0 then null else to_date(sdivd + 1900000, 'YYYYDDD') end as "Data de Emissão",
                        to_date(sdtrdj + 1900000, 'YYYYDDD') as "Data de Emissão do Pedido",
                        (select tgflag 
                           from QADTA.f5542456
                         where tgdoco = sddoco) as "Status da Integracao p/ Merc",
                        (select fhev01 from QADTA.F55MCN01 
                          where fhbnnf = fdbnnf 
                            and fhbser = fdbser
                            and fhn001 = fdn001) as "Status da Integracao da NF",
                        fdbnnf,
                        fdbser,
                        fdn001,
                        --nota,
                         case when fdissu = 0 then null else  to_date(fdissu + 1900000, 'YYYYDDD') end  as "Data de Emissão da Nota",
                        case
                          when xxvod = '1' then
                           'NF impressa'
                          else
                           case
                             when xxvod = '8' then
                              'NF marcada para Impressão'
                             else
                              case
                                when xxvod = ' ' then
                                 'Não impressa'
                                else
                                 'Nota não enviada para Spool'
                              end
                           end
                        end as Spool,
                        case
                          when needsp is null then
                           'Carregar nota - Rodar R55nfe04'
                          else
                           case
                             when needsp is null and xxvod <> 1 then
                              'Aguardando Spool'
                             else
                              'Nota carregada'
                           end
                        end as R55NFE04,
                        
                        case
                          when needsp = 0 then
                           'Pendente de envio p/ Sefaz'
                          else
                           case
                             when needsp = 1 then
                              'Enviado para Sefaz'
                             else
                              'Nota não carregada'
                           end
                        end as R55NFE30,
                        trim(replace(upper(max(xmdrpt)),
                                     'C:',
                                     '\\' || trim(max(xmjobn)))) as "Arquivo enviado p/ Sefaz",
                        max(xmjobn) as Servidor,
                        case
                          when needsp = 1 and ntnxtev1 is null and
                               nercd1 is null then
                           'Pendente retorno da Sefaz'
                          else
                           case
                             when needsp = 1 and ntnxtev1 = '100' and
                                  nercd1 = '100' then
                              'Nota autorizada na Sefaz'
                             else
                              case
                                when needsp = 1 and ntnxtev1 <> '100' or
                                     nercd1 = '22' then
                                 'Nota Rejeitada: Chave de acesso diverge da chave anterior'
                                else
                                 case
                                   when needsp = 1 and ntnxtev1 <> '100' or
                                        nercd1 = '225' then
                                    'Nota Rejeitada: Falha no Schema XML do lote de NFe'
                                   else
                                    case
                                      when needsp = 1 and ntnxtev1 <> '100' or
                                           nercd1 = '228' then
                                       'Nota Rejeitada: Data de Emissao muito atrasada Anterior a 10 dias'
                                      else
                                       case
                                         when needsp = 1 and ntnxtev1 <> '100' or
                                              nercd1 = '233' then
                                          'Nota Rejeitada: IE do destinatario nao cadastrada'
                                         else
                                          case
                                            when needsp = 1 and ntnxtev1 <> '100' or
                                                 nercd1 = '806' then
                                             'Nota Rejeitada: IE do destinatario nao cadastrada'
                                          
                                            else
                                             case
                                               when needsp = 1 and /*ntnxtev1 is not null and*/
                                                    ntnxtev1 <> '100' or nercd1 = '205' then
                                                'Nota Rejeitada: Denegada na base da SEFAZ'
                                                else
                                             case
                                               when needsp = 1 and /*ntnxtev1 is not null and*/
                                                    ntnxtev1 <> '100' or nercd1 = '234' then
                                                'IE do destinatario nao vinculada ao CNPJ : IE do destinatário baixada no Cadastro de Contribuintes'
                                                                                               else
                                                case
                                                  when needsp = 1 and /*ntnxtev1 is not null and*/
                                                       ntnxtev1 <> '100' or nercd1 <> '100' and nercd1 <> ' ' then
                                                   'Nota Rejeitada'
                                                
                                                  else
                                                   case
                                                     when needsp is null and ntnxtev1 is null then
                                                      'Nota não carregada ou não gerada'
                                                     else
                                                      'Nota Não Retornada da Sefaz'
                                                   end
                                                end
                                             end
                                          end
                                       end
                                    end
                                 end
                              end
                           end
                        end end as "RETORNO SEFAZ",
                        nercd1, 
                        (select distinct Np.fdbnnf
                   from QADTA.f7611b Np
                  where sddoco = Np.Fddoco
                    and sddcto = Np.Fdpdct) as "Nota de Venda",
                
                (select distinct Np.fdbser
                   from QADTA.f7611b Np
                  where sddoco = Np.Fddoco
                    and sddcto = Np.Fdpdct) as "Serie Nota de Venda",
                
                (select distinct t.vtdoc1
                   from QADTA.f554241 t
                  where sddoco = t.vtdoco
                    and sddcto = t.vtdcto
                    and t.vtdct1 in('VU','ZU')
                    and rownum = 1) "Pedido Tranf",
                
                (select distinct t.vtdct1
                   from QADTA.f554241 t
                  where sddoco = t.vtdoco
                    and sddcto = t.vtdcto
                    and t.vtdct1 in('VU','ZU')) "Tipo Ped Tranf",
                
                (select distinct Nt.Fdbnnf
                   from QADTA.f554241 t, QADTA.f7611b Nt
                  where sddoco = t.vtdoco
                    and sddcto = t.vtdcto
                    and t.vtdct1 in('VU','ZU')
                    and t.vtdoc1 = Nt.Fddoco
                    and rownum = 1) "Nota Tranf",
                
                (select distinct Nt.Fdbser
                   from QADTA.f554241 t, QADTA.f7611b Nt
                  where sddoco = t.vtdoco
                    and sddcto = t.vtdcto
                    and t.vtdct1 in ('VU','ZU')
                    and t.vtdoc1 = Nt.Fddoco
                    and rownum = 1) "Serie Nota Tranf",
                
                (select distinct r.vtdoc1
                   from QADTA.f554241 r
                  where vtdoco = (select distinct t.vtdoc1
                                    from QADTA.f554241 t
                                   where sddoco = t.vtdoco
                                     and sddcto = t.vtdcto
                                     and t.vtdct1 in ('VU','ZU')
                                     and rownum = 1)
                    and vtdct1 = 'U4') "Pedido de Remessa",
                
                (select distinct rem.vtdct1
                   from QADTA.f554241 rem
                  where vtdoco = (select distinct t.vtdoc1
                                    from QADTA.f554241 t
                                   where sddoco = t.vtdoco
                                     and sddcto = t.vtdcto
                                     and t.vtdct1 in('VU','ZU')
                                     and rownum = 1)
                    and vtdct1 = 'U4') "Tipo Ped Remessa",
                
                (select distinct Nrem.fdbnnf
                   from QADTA.f7611b Nrem
                  where Nrem.fddoco =
                        (select distinct rem.vtdoc1
                           from QADTA.f554241 rem
                          where vtdoco = (select distinct t.vtdoc1
                                            from QADTA.f554241 t
                                           where sddoco = t.vtdoco
                                             and sddcto = t.vtdcto
                                             and t.vtdct1 in('VU','ZU')
                                             and rownum = 1)
                            and rem.vtdct1 = 'U4')) "Nota de Remessa",
                
                (select distinct Nrem.fdbser
                   from QADTA.f7611b Nrem
                  where Nrem.fddoco =
                        (select distinct rem.vtdoc1
                           from QADTA.f554241 rem
                          where vtdoco = (select distinct t.vtdoc1
                                            from QADTA.f554241 t
                                           where sddoco = t.vtdoco
                                             and sddcto = t.vtdcto
                                             and t.vtdct1 in('VU','ZU')
                                             and rownum = 1)
                            and rem.vtdct1 = 'U4')) "Serie Nota de Remessa",
                
                (select distinct ret.vtdoc1
                   from QADTA.f554241 ret
                  where sddoco = ret.vtdoco
                    and sddcto = ret.vtdcto
                    and ret.vtdct1 = 'U3') "Pedido Retorno",
                
                (select distinct ret.vtdct1
                   from QADTA.f554241 ret
                  where sddoco = ret.vtdoco
                    and sddcto = ret.vtdcto
                    and ret.vtdct1 = 'U3') "Tipo Ped Retorno",
                
                (select distinct Nret.Fdbnnf
                   from QADTA.f554241 ret, QADTA.f7611b Nret
                  where sddoco = ret.vtdoco
                    and sddcto = ret.vtdcto
                    and ret.vtdct1 = 'U3'
                    and ret.vtdoc1 = Nret.Fddoco) "Nota Retorno",
                
                (select distinct Nret.Fdbser
                   from QADTA.f554241 ret, QADTA.f7611b Nret
                  where sddoco = ret.vtdoco
                    and sddcto = ret.vtdcto
                    and ret.vtdct1 = 'U3'
                    and ret.vtdoc1 = Nret.Fddoco) "Serie Nota Retorno"/**/
          from QADTA.f5547011,
               QADTA.F4211,
               QADTA.f4201,
               QADTA.f7611b,
               QADTA.f5503004,
               QADTA.f55nfe03,
               QADTA.f55nfe02,
               QADTA.f55nfe01,
               QADTA.f5555net/*,
               A*/
         where sadoco = sddoco (+)
           --and sdeuse not in ('CTC')
           and sddoco = shdoco(+)
           and sddcto = shdcto(+)
           and sdlnty = 'BS'
           and saoorn = 'MERCANET'
           --and saz55ori = 'ZHR'
           and shhold = ' '
           and sdlttr < = '620'
           and sddoco = fddoco(+)
           and sdlnid = fdlnid(+)
           and sdlitm = fdlitm(+)
           and fdbnnf = xxbnnf(+)
           and fdbser = xxbser(+)
           and fdpdct = xxdcto(+)
           and fddoco = nedoco(+)
           and fdbnnf = nebnnf(+)
           and fdbser = nebser(+)
           and fdn001 = nen001(+)
           and fdbnnf = ntbnnf(+)
           and fdbser = ntbser(+)
           and fdn001 = ntn001(+)
           and fddoco = ntdoco(+)
           and fdbnnf = ncbnnf(+)
           and fdbser = ncbser(+)
           and fdn001 = ncn001(+)
           and ncseq = xmseq(+)
           --and saupmj >  119232
           --and instr(nota,fdbnnf,23,1) > 1 
           and sddoco in (10252556)
           --and sddcto = 'VO'
           --and sdnxtr = '528'    
           -- and savr01 in ('81444473','81444474')
            group by savr01,sddoco,sdnxtr,sdlttr,sdeuse,shhold,sdzon,sddcto,sdemcu,sdivd,sdtrdj,fdbnnf,
                  fdbser,fdn001,fdissu,xxvod,needsp,ntnxtev1,nercd1,/*nota,*/sdan8,sdmcu
         order by sdnxtr,sdlttr,sdeuse,sddoco)
--where "RETORNO SEFAZ" = 'Nota Rejeitada'


                      
