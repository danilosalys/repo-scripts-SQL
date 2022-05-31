select db_edild_nomearq,
       nvl((select case
                    when db_edild_situacao = 1 and
                         count(edipefet.db_edip_nro) = 0 then --Cota��o sendo Processada
                     '1 - Mover Arquivo para Backup'
                    else
                     case
                       when db_edild_situacao = 0 and
                            count(edipefet.db_edip_nro) > 0 then -- Cota��o h� Efetivada
                        '2 - Mover Arquivo para Backup'
                       else
                        case
                          when db_edild_situacao = 0 and
                               count(edipefet.db_edip_nro) = 0 then --Cota��o pode ser substituida
                           '3 - Apagar Cota��o Anterior'
                          else
                           '4 - Importar cota��o'
                        end
                     end
                  end as ACAO
             from mercanet_prd.db_edi_lote_distr lotecot,
                  mercanet_prd.db_edi_pedido     edipcot,
                  mercanet_prd.db_edi_pedido     edipefet
            where edipcot.db_edip_lote = lotecot.db_edild_seq
              and lotecot.db_edild_nomearq =
                  db_edi_lote_distr.db_edild_nomearq
              and edipefet.db_edip_obs1(+) = edipcot.db_edip_obs1
              and edipefet.db_edip_van(+) = 530 -- trocar pelo parametro do layout
            group by lotecot.db_edild_nomearq, lotecot.db_edild_situacao),
           '5-Importar Cota��o')
  from mercanet_prd.db_edi_lote_distr
 where db_edild_data >
       to_date('27/08/2014 15:50:00', 'dd/mm/yyyy hh24:mi:ss')
