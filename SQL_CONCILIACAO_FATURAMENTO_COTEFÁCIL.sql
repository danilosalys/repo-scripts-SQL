
SELECT DB_PED_CLIENTE AS CODIGO_CLIENTE,
       DB_EDIP_COMPRADOR AS CNPJ,
       DB_EDIP_LOTE AS CODIGO_LOTE_DCENTER,
       DB_CLIA_VALOR || ' - ' ||
       (SELECT AT03_DESCRICAO
          FROM MERCANET_PRD.MAT03
         WHERE AT03_ATRIB = DB_CLIA_ATRIB


           AND AT03_CODIGO = DB_CLIA_VALOR) AS REGIAO_COMERCIAL,
       PEDCOT AS PEDIDO_COTEFACIL,
       DB_PED_NRO AS PEDIDO_DROGACENTER,
       CASE
         WHEN DB_PED_SITUACAO = 0 THEN
          'LIBERADO'
         ELSE
          CASE
            WHEN DB_PED_SITUACAO = 1 THEN
             'BLOQUEADO'
            ELSE
             CASE
               WHEN DB_PED_SITUACAO = 2 THEN
                'FATURADO PARCIAL'
               ELSE
                CASE
                  WHEN DB_PED_SITUACAO = 4 THEN
                   'FATURADO'
                  ELSE
                   CASE
                     WHEN DB_PED_SITUACAO = 9 THEN
                      'CANCELAD0'
                     ELSE
                      CASE
                        WHEN DB_EDIP_COMPRADOR IS NULL AND DB_EDIP_LOTE IS NULL THEN
                         'ID PEDIDO NÃO ENCONTRADO NA BASE DROGACENTER - COTEFÁCIL REVISAR'
                        ELSE
                         CASE
                           WHEN DB_PED_CLIENTE IS NULL THEN
                            'PEDIDO CANCELADO - NÃO HOUVE FATURAMENTO'
                           ELSE
                            NULL
                         END
                      END
                   END
                END
             END
          END
       END AS SITUACAO_PEDIDO,
       VALFATCOT AS VALOR_TOTAL_COTEFACIL ,
       SUM(DB_NOTA_VLR_TOTAL) AS VALOR_TOTAL_NOTA,
       NVL((SELECT SUM(Case
                        When NVL(A.DB_NOTAP_VLR_SUBST, 0) = 0 Then
                         NVL(A.DB_NOTAP_VLR_DESCT, 0)
                        Else
                         NVL(A.DB_NOTAP_VLR_SUBST, 0)
                      End)
             FROM MERCANET_PRD.DB_NOTA_PROD   A,
                  MERCANET_PRD.DB_NOTA_FISCAL B
            WHERE A.DB_NOTAP_NRO = B.DB_NOTA_NRO
              AND A.DB_NOTAP_SERIE = B.DB_NOTA_SERIE
              AND A.DB_NOTAP_EMPRESA = B.DB_NOTA_EMPRESA
              AND B.DB_NOTA_PED_MERC = DB_PED_NRO),
           0) AS VALOR_TOTAL_TRIBUTACAO,
       CASE
         WHEN VALFATCOT = SUM(DB_NOTA_VLR_TOTAL) OR
              MOD(VALFATCOT, SUM(DB_NOTA_VLR_TOTAL)) < 0.2 THEN
          'OK - CONCILIADO'
         ELSE
          CASE
            WHEN VALFATCOT < SUM(DB_NOTA_VLR_TOTAL) THEN
             'VALOR DA NOTA MAIOR DO QUE VALOR COTEFÁCIL - ANALISAR'
            ELSE
             CASE
               WHEN VALFATCOT > SUM(DB_NOTA_VLR_TOTAL) OR
                    MOD(VALFATCOT, SUM(DB_NOTA_VLR_TOTAL)) > 0.2 THEN
                'VALOR FATURADO MENOR DO QUE VALOR COTEFÁCIL - HOUVE CANCELAMENTO DE ITENS NO FATURAMENTO'
               ELSE
                ''
             END
          END
       END AS "ANALISE"   
  FROM DSALES.CONCILIACAO_COTEFACIL_AGOSTO,
       MERCANET_PRD.DB_EDI_PEDIDO,
       MERCANET_PRD.DB_PEDIDO,
       MERCANET_PRD.DB_CLIENTE_ATRIB ,
       MERCANET_PRD.DB_NOTA_FISCAL
 WHERE PEDCOT = DB_EDIP_NRO(+)
   AND DB_EDIP_PEDMERC = DB_PED_NRO(+)
   AND DB_PED_CLIENTE = DB_CLIA_CODIGO(+)
   AND DB_CLIA_ATRIB(+) = 1001  
   AND DB_PED_NRO = DB_NOTA_PED_MERC(+)
   AND DB_NOTA_FATUR(+) <> 3
 GROUP BY DB_PED_CLIENTE,
          DB_EDIP_COMPRADOR,
          DB_EDIP_LOTE,
          DB_CLIA_ATRIB,
          DB_CLIA_VALOR,
          PEDCOT,
          VALFATCOT,
          DB_PED_NRO,
          DB_PED_SITUACAO,
          DB_PED_SITCORP
 ORDER BY PEDCOT
