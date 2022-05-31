select db_edip_lote,
       db_edip_pedmerc,
       db_edip_comprador,
       db_edip_dt_emissao,
       db_edip_projeto,
       db_edip_van
  from db_edi_pedido
 where db_edip_pedmerc in ('80011465','80011467','80011466');
-------------------------------------------------------------------------------
 
  SELECT * from db_edi_pedido
 where  DB_EDIP_VAN in ('512' , '502')-- VAN UTILIZADA PARA IMPORTA플O
 and db_edip_dt_emissao > '06/04/2011'
;
 
-------------------------------------------------------------------------------- 
 SELECT A.*
   FROM db_edi_pedprod A, db_edi_pedido B
  WHERE A.db_edii_pedmerc = B.db_edip_pedmerc
    AND B.db_edip_dt_emissao = '12/04/2011' --DATA DA IMPORTA플O 
    AND B.db_edip_van = '512' --VAN DE IMPORT플O 
  ORDER BY A.DB_EDII_PEDMERC;
----------------------------------------------------------------------------------- 
 
 SELECT *
  FROM DB_EDI_LOTE_DISTR
 WHERE DB_EDILD_DISTR IN ('512')
   AND TO_CHAR(DB_EDILD_DATA, 'dd/mm/yyyy') = '12/04/2011' ;
--------------------------------------------------------------------------------------   
   
   SELECT DB_PED_SITCORP,A.* FROM DB_PEDIDO A
   WHERE DB_PED_NRO IN ('80011494',
'80011495',
'80011493');

-----------------------------------------------------------------------------------------
SELECT * FROM CRPDTA.F5547011
WHERE SAZ55ORI IN  ('ZHR' , 'HRY')
AND SAUPMJ = 111102 -- INFORMAR A DATA DO DIA DA EXPORTA플O PARA O JDR
AND SAUSER = 'DSALES'
/*AND SADOCO = 0
AND SADCTO = 'OL'
AND SAEDBT <> ' '
AND SAEDSP <> ' '    */

-----------------------------------------------------------------------------------------