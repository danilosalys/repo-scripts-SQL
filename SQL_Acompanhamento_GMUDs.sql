
/*Data: 24/03/2014
Assunto: Acompanhamento de mudanças realizadas no sistema
Analista: Danilo Sales*/

--SQLs de Acompanhamento 

--Após a compilação dos objetos do Banco de Dados verificar:



--VERIFICA JOBS DE RETORNO E ENVIO DOS PEDIDOS PARADOS
--POSSIVEIS PROBLEMAS: 
--1) BANCO DE DADOS FORA
  --SOMENTE FORAM FILTRADOS OS JOBS DE ENVIO DOS PEDIDOS E RETORNO DO JDE

select a.job as "Id Job",
       case
         when a.broken = 'N' then
          null
         else
          'Parado'
       end as "Status Job",
       case
         when a.what like '%20%' or a.what like '%87%' then
          'Cliente,Rede'
         else
          case
            when a.what like '%21%' then
             'Cliente Atrib'
            else
             case
               when a.what like '%29%' then
                'Cliente e Repres'
               else
                case
                  when a.what like '%30%' then
                   'Retorno Pedido'
                  else
                   case
                     when a.what like '%35%' then
                      'Retorno NF'
                     else
                      case
                        when a.what like '%90007%' then
                         'Retorno NF Lote'
                        else
                         case
                           when a.what like '%40%' then
                            'Produto'
                           else
                            case
                              when a.what like '%42%' then
                               'Preco'
                              else
                               case
                                 when a.what like '%41%' then
                                  'Cod Barra'
                                 else
                                  case
                                    when a.what like '%8005%' then
                                     'Representante'
                                    else
                                     case
                                       when a.what like '%8004%' or a.what like '%49%' or
                                            a.what like '%48%' or a.what like '%8003%' then
                                        'Familia,tpprod,marca,grupo'
                                       else
                                        case
                                          when a.what like '%90001%' then
                                           'Produto Atrib'
                                          else
                                           case
                                             when a.what like '%90006%' then
                                              'Atributos'
                                             else
                                              case
                                                when a.what like '%90004%' then
                                                 'Cliente Obs'
                                                else
                                                 case
                                                   when a.what like '%54%' then
                                                    'Estoque'
                                                   else
                                                    case
                                                      when a.what like '%MERCP_CONCORRENTE_EXPORT%' then
                                                       'Exp Ped Merc p/ Jde'
                                                      else
                                                       case
                                                         when a.what like '%MERCP_LIMPA_INTERFACE%' then
                                                          'Limpeza Interfaces'
                                                       end
                                                    end
                                                 end
                                              end
                                           end
                                        end
                                     end
                                  end
                               end
                            end
                         end
                      end
                   end
                end
             end
          end
       end as "Job",
       a.last_date as "Data Ultima Exec",
       a.this_date as "Data Executando",
       a.next_date as "Data Prox Exec",
       a.what as "Procedure"
  from dba_jobs a
 where a.schema_user = 'MERCANET_PRD'; -- Schema


--Pedidos parados no Mercanet, não enviados ao JDE

-- PEDIDOS NÃO ENVIADOS AO JDE 
-- POSSIVEIS PROBLEMAS: 1) API ENVIO DOS PEDIDOS PARADA
--        2) PEDIDO SEM CONDIÇAO DE PAGAMENTO 
--        3) PEDIDO SEM CODIGO DE REPRESENTANTE 
-- SE RETORNAR LINHAS, ANALISA-LAS
SELECT COUNT(1)  FROM MERCANET_PRD.DB_PEDIDO,
       MERCANET_PRD.DB_EDI_PEDIDO,
       MERCANET_PRD.DB_EDI_LOTE_DISTR
 WHERE DB_PED_NRO = DB_EDIP_PEDMERC
   AND DB_EDIP_LOTE = DB_EDILD_SEQ
   AND DB_EDILD_DATA > SYSDATE - 3
   AND DB_PED_DATA_ENVIO < SYSDATE - 0.01  
   AND NOT EXISTS (SELECT *
          FROM MERCANET_PRD.F5547011
         WHERE RPAD(TO_CHAR(DB_PED_NRO),25,' ') = SAVR01
           AND SAOORN = 'MERCANET');


--Pedidos parados no JDE, não retornados ao Mercanet.

-- PEDIDOS PROCESSADOS NÃO RETORNADOS DO JDE
-- POSSIVEIS PROBLEMAS: 1) INTEGRATOR DE PEDIDOS PARADO
--                      2) API DE PEDIDOS PARADA
--                      3) Faturamento não inciado - Pedido travado no status inicial (520-535)
--                      4) Pedido sem linha (ZON) preenchido
-- SE RETORNAR LINHAS, ANALISA-LAS
SELECT COUNT(1)
  FROM MERCANET_PRD.DB_PEDIDO         T1,
       MERCANET_PRD.DB_EDI_PEDIDO     T2,
       MERCANET_PRD.DB_EDI_LOTE_DISTR T3
 WHERE T1.DB_PED_NRO = T2.DB_EDIP_PEDMERC   
   AND T2.DB_EDIP_LOTE = T3.DB_EDILD_SEQ
   AND T3.DB_EDILD_DATA > SYSDATE - 3
   AND EXISTS (SELECT *
          FROM MERCANET_PRD.F5547011
         WHERE RPAD(TO_CHAR(T1.DB_PED_NRO),25,' ') = SAVR01
           AND SAOORN = 'MERCANET'
           AND SAEDSP <> ' '
           AND SAKCOO <> '    ')
   AND T1.DB_PED_DATA_ENVIO < SYSDATE - 0.01
   AND EXISTS (SELECT 1 
                 FROM MERCANET_PRD.DB_PEDIDO_DISTR T4
                WHERE T1.DB_PED_NRO = T4.DB_PEDT_PEDIDO
                  AND T4.DB_PEDT_DTDISP IS NULL); -- APROX 15 MINUTOS


-- PEDIDOS ENVIADOS POREM NÃO PROCESSADOS NO JDE
-- POSSIVEIS PROBLEMAS:  1) R5542200 PARADO 
--         2) PROCESSOS DO FATURAMENTO PARADOS
-- SE RETORNAR LINHAS, ANALISA-LAS
SELECT COUNT(1)
  FROM MERCANET_PRD.DB_PEDIDO,
       MERCANET_PRD.DB_EDI_PEDIDO,
       MERCANET_PRD.DB_EDI_LOTE_DISTR,
       MERCANET_PRD.DB_PEDIDO_DISTR
 WHERE DB_PED_NRO = DB_EDIP_PEDMERC
   AND DB_EDIP_LOTE = DB_EDILD_SEQ
   AND DB_EDILD_DATA > SYSDATE - 3
   AND DB_PED_NRO = DB_PEDT_PEDIDO
   AND DB_PEDT_DTDISP IS NULL
   AND EXISTS (SELECT *
          FROM MERCANET_PRD.F5547011
         WHERE RPAD(TO_CHAR(DB_PED_NRO),25,' ') = SAVR01
           AND SAOORN = 'MERCANET'
           AND SAEDSP = ' '
           AND SAKCOO = '    '
           AND SAEDBT = ' ' )
   AND DB_PED_DATA_ENVIO < SYSDATE - 0.01; -- APROX 15 MINUTOS

--SE RETORNAR LINHAS PARA O PROCESSAMENTO DE PEDIDOS DA SEVEN PDV E REMOVER O ARQUIVO DA PASTA DE TRANSACAO
SELECT COUNT(1) AS "PEDIDOS DUPLICADOS"
  FROM MERCANET_PRD.DB_PEDIDO
 WHERE NOT EXISTS (SELECT *
          FROM MERCANET_PRD.DB_EDI_PEDIDO
         WHERE DB_EDIP_PEDMERC = DB_PED_NRO)
   AND DB_PED_DT_EMISSAO > TO_CHAR(SYSDATE-2,'DD/MM/YYYY')
   and db_ped_tipo = 'OL';

--SE RETORNAR LINHAS PARA O PROCESSAMENTO DE PEDIDOS DA SEVEN PDV E REMOVER O ARQUIVO DA PASTA DE TRANSACAO
SELECT COUNT(1) AS "PEDIDOS DUPLICADOS"
  FROM MERCANET_PRD.DB_PEDIDO
 WHERE DB_PED_NRO IN
       (SELECT SUBSTR(DM05_MSG, 44, 8)
          FROM MERCANET_PRD.MDM05
         WHERE DM05_GUID = 183
           AND DM05_MSGDATA > TO_CHAR(SYSDATE-2,'DD/MM/YYYY')
           AND DM05_MSG LIKE '%Pedido Mercanet%'
           AND NOT EXISTS
         (SELECT *
                  FROM MERCANET_PRD.DB_EDI_PEDIDO
                 WHERE DB_EDIP_PEDMERC = SUBSTR(DM05_MSG, 44, 8)));


-- SE RETORNAR LINHAS VERIFICAR OS PEDIDOS QUE NÃO FORAM SETADOS COMO IMPORTADOS, ABRIR O GRAPHQL FEEN E EXECUTAR
-- A MUTATION PARA SETA-LOS. 

SELECT COUNT(1) 
  FROM MERCANET_PRD.DB_EDI_LOTE_DISTR T1,  
       MERCANET_PRD.DB_EDI_LDISTR_LOG T2
 WHERE T1.DB_EDILD_SEQ = T2.DB_EDILL_SEQ_LOTE
   AND T1.DB_EDILD_DISTR = 543
   AND T1.DB_EDILD_DATA > SYSDATE - 2
   AND UPPER(T2.DB_EDILL_TXTLOG) LIKE '%JSON%';
                 

-- CONSULTA EXECUÇÃO DOS AGENDAMENTOS NAS INSTANCIAS

SELECT DM03_SERVICO AS INSTANCIA,
       DM03_DESCRICAO AS "DESCRICAO DO AGENDAMENTO",
       DM03_GUID AS "CODIGO DO AGENDAMENTO",
       DM03_GRUPO AS "GRUPO",
       DM03_INTERVALO AS "INTERVALO",
       DM03_OBSERVACAO AS "SERVIDOR",
       t2.dm03_horaini,
       t2.dm03_horafim,
	     CASE WHEN SUBSTR(DM03_CONFIGSTRING,1,1) = '1' THEN SUBSTR(DM03_CONFIGSTRING,8,3) ELSE NULL END AS VAN,
       MAX(DM05_MSGDATA) AS "ULTIMA EXECUCAO",
       (CASE
         WHEN (UPPER(DM03_DESCRICAO) LIKE UPPER('%PREÇO%') OR
              UPPER(DM03_DESCRICAO) LIKE UPPER('%PRODUTO%') OR
              UPPER(DM03_DESCRICAO) LIKE UPPER('%CONCILIACAO%') OR
              UPPER(DM03_GRUPO) LIKE UPPER('%PREÇO%') OR
              UPPER(DM03_GRUPO) LIKE UPPER('%PRODUTO%') OR
              UPPER(DM03_GRUPO) LIKE UPPER('%CONCILIACAO%')) AND
              MAX(DM05_MSGDATA) < SYSDATE - 1 THEN
          'WARMING'
         ELSE
          CASE
            WHEN UPPER(DM03_DESCRICAO) NOT LIKE UPPER('%PREÇO%') AND
                 UPPER(DM03_DESCRICAO) NOT LIKE UPPER('%PRODUTO%') AND
                 UPPER(DM03_DESCRICAO) NOT LIKE UPPER('%CONCILIACAO%') AND
                 UPPER(DM03_GRUPO) NOT LIKE UPPER('%PREÇO%') AND
                 UPPER(DM03_GRUPO) NOT LIKE UPPER('%PRODUTO%') AND
                 UPPER(DM03_GRUPO) NOT LIKE UPPER('%CONCILIACAO%') AND
                 MAX(DM05_MSGDATA) < SYSDATE - 0.1 THEN
             'WARMING'
            ELSE
             'RODANDO'
          END
       END) STATUS, 
       DM03_CONFIGSTRING AS CONFIGURACAO
  FROM MERCANET_PRD.MDM05 t1, MERCANET_PRD.MDM03 t2
 WHERE DM05_GUID(+) = DM03_GUID
   AND DM05_SERVICO(+) = DM03_SERVICO
   AND DM03_STATUS = 1
 GROUP BY DM03_SERVICO, DM03_DESCRICAO, DM03_GRUPO, DM03_GUID,DM03_CONFIGSTRING,DM03_INTERVALO, DM03_OBSERVACAO,  t2.dm03_horaini,
       t2.dm03_horafim
 ORDER BY DM03_SERVICO, DM03_GUID;
 

select *
  from mercanet_prd.interface_db_preco p1
 where p1.data_atualizacao is null;
 
 
select dbs_erros_objeto objeto,
       max(dbs_erros_data) data,
       max(dbs_erros_erro) mensagem,
       count(1)
  from mercanet_prd.dbs_erros_triggers
/*where dbs_erros_data between to_date('03/05/2017 00:00:00','dd/mm/yyyy hh24:mi:ss') and
to_date('03/05/2017 23:59:00','dd/mm/yyyy hh24:mi:ss')*/
 group by dbs_erros_objeto
