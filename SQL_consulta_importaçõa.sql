----------------------------------------------------------------------------------------------------------------------
-- consulta quando ha geração de pedidos

SELECT A.DB_PED_NRO,
       A.DB_PED_NRO_ORIG,
       A.DB_PED_SITUACAO,
       A.DB_PED_SITCORP,
       A.DB_PED_NRO,
       A.DB_PED_CLIENTE,
       B.DB_PEDT_DTIMP,
       C.DB_EDIP_VAN,
       C.*
  FROM DB_PEDIDO A, DB_PEDIDO_DISTR B, DB_EDI_PEDIDO C, DB_EDI_LOTE_DISTR D
 WHERE A.DB_PED_NRO = B.DB_PEDT_PEDIDO
   AND A.DB_PED_NRO = C.DB_EDIP_PEDMERC
   AND D.DB_EDILD_SEQ = C.DB_EDIP_LOTE
   AND D.db_edild_usuario = 'DSALES' -- USUARIO QUE REALIZOU A IMPORTAÇÃO DOS ARQUIVOS
   AND TO_CHAR(B.DB_PEDT_DTIMP, 'DD/MM/YYYY') BETWEEN '17/06/2011' AND '20/07/2011' --DATA DA IMPORTAÇÃO DOS ARQUIVOS
   AND DB_EDIP_VAN IN ('501') -- CODIGO DA VAN 
   
   
----------------------------------------------------------------------------------------------------------------------



--consulta quando não ja geração de pedidos

  SELECT C.*
          FROM DB_EDI_PEDIDO C, DB_EDI_LOTE_DISTR D
         WHERE D.DB_EDILD_SEQ = C.DB_EDIP_LOTE
           AND C.DB_EDIP_PEDMERC IS NULL
           AND D.DB_EDILD_USUARIO = 'DSALES'
           AND DB_EDIP_VAN IN ('501') -- codigo da van
           AND TO_CHAR(D.DB_EDILD_DATA, 'DD/MM/YYYY') BETWEEN '17/06/2011' AND '20/07/2011' --DATA DA IMPORTAÇÃO DOS ARQUIVOS
      