SELECT DB_EDILD_NOMEARQ as "Arquivo de Pedido",
       DB_EDILD_DATA    as "Data/Hora Processamento", 
       DB_EDIP_COMPRADOR as "CNPJ do Cliente",
       CASE WHEN DB_PED_SITCORP IS NULL THEN 'Pedido Drogacenter nao gerado' 
         ELSE CASE WHEN DB_PED_SITCORP = '1' THEN 'Não alcançou Valor Mínimo'
           ELSE CASE WHEN DB_PED_SITCORP = '2' THEN 'Cliente sem Credito'
             ELSE CASE WHEN DB_PED_SITCORP = '9' THEN 'Pedido Não Faturado' 
               ELSE CASE WHEN DB_PED_SITCORP IN (0,3,4) THEN '--'end end end end end as "Motivo do Cancelamento", 
       TO_NUMBER(DB_EDIP_TXT1) as "Pedido",
       CASE WHEN DB_PED_SITUACAO IS NULL THEN 'Pedido Drogacenter nao gerado' 
           ELSE CASE WHEN DB_PED_SITUACAO = 9 THEN 'Pedido Cancelado' 
             ELSE CASE WHEN DB_PED_SITUACAO = 2 THEN 'Faturado Parcial' 
               ELSE CASE WHEN DB_PED_SITUACAO = 4 THEN 'Faturado Total' end end end end AS "Situação do Pedido" 
  FROM mercanet_hml.DB_EDI_LOTE_DISTR,
       mercanet_hml.DB_EDI_PEDIDO,
       mercanet_hml.DB_PEDIDO
 WHERE DB_EDILD_SEQ = DB_EDIP_LOTE
   AND DB_EDIP_PEDMERC = DB_PED_NRO(+)
   AND db_edip_pedmerc in ('50012736','50012737','50012738','50012739','50012740');
