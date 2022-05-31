 SELECT  T0.CDUKID                     AS UKID
        ,T0.CDKCOO                     AS KCOO
        ,T0.CDDOCO                     AS NUMERO_PEDIDO
        ,T0.CDDCTO                     AS TIPO_DOCUMENTO
        ,T1.CHUK01                     AS ID_FIDELIZE
        ,T0.CDLNID                     AS SEQUENCIA_ITEM
        ,T0.CDLITM                     AS NUMERO_PRODUTO
        ,T0.CDCITM                     AS CODIGO_BARRA
        ,T0.CDSOQS                     AS QUANTIDADE_ATENDIDA
        ,T0.CDAEXP/100                 AS VALOR_TOTAL
        ,T0.CDUPRC/10000               AS VALOR_UNITARIO
        ,T0.CDPERCENT/100*-1           AS DESCONTO_PNV
        ,T0.CDPTC                      AS CONDICAO_PAGAMENTO
        ,T0.CDAN09/100                 AS VALOR_REEMBOLSO_INDUSTRIA
        ,(SELECT DPQ10A
           FROM PRODDTA.F550005B
          WHERE UPPER(DPDSC1) 
                LIKE UPPER('%PEDIDO%')
            AND DPDL011 = T0.CDDL011
            AND ROWNUM = 1)  AS DESCRICAO_STATUS_PEDIDO
        ,T0.CDEV01                     AS STATUS_PEDIDO
        ,T0.CDEV02                     AS STATUS_NOTA_FISCAL
        ,(SELECT DPQ10A
           FROM PRODDTA.F550005B
          WHERE UPPER(DPDSC1) 
                LIKE UPPER('%NOTA%')
            AND DPDL011 = T0.CDQ100
            AND ROWNUM = 1)   AS DESCRICAO_STATUS_NOTA
        ,T0.CDUK05                     AS TIPO_ACAO
        ,T0.CDUK06                     AS CODIGO_ACAO
        ,(SELECT CAALPH 
            FROM PRODDTA.F5542094 
           WHERE CAPUKID = 2 
             AND CAUKID = CDUK06)      AS DESCRICAO_ACAO
        ,T0.CDUK07                     AS PLAN_ID_ITEM
        ,T1.CHAN8                      AS CODIGO_CLIENTE
        ,T1.CHBCGT                     AS CNPJ_CLIENTE
        ,T1.CHAA05                     AS CODIGO_CONDICAO_COMERCIAL
        ,T1.CHBNNF                     AS NUMERO_NOTA_FISCAL
        ,T1.CHBSER                     AS SERIE_NOTA_FISCAL
        , TO_DATE(TO_CHAR(T1.CHISSU 
          + 1900000), 'YYYYDDD')       AS DATA_EMISSAO_NOTA
        , TO_DATE(TO_CHAR(T1.CHTRDJ 
          + 1900000), 'YYYYDDD')       AS DATA_EMISSAO_PEDIDO
        --,T1.CHAN01                   AS VALOR_DESCONTO_PNV
        ,T1.CHGS1A                     AS PROJETO
        ,T2.ABALPH                     AS RAZAO_SOCIAL   
        ,T2.ABAC01                     AS REGIAO
        ,T2.ABAC07                     AS SETOR
   FROM PRODDTA.F554211C T0, 
        PRODDTA.F554201C T1, 
        PRODDTA.F0101    T2
  WHERE T1.CHTRDJ <= 122059 
    AND T1.CHTRDJ >= 122032
    AND T0.CDUK06 IN (121342,108825)
    AND T1.CHUKID = T0.CDUKID 
    AND T1.CHKCOO = T0.CDKCOO 
    AND T1.CHDOCO = T0.CDDOCO 
    AND T1.CHDCTO = T0.CDDCTO 
    AND T2.ABAN8 =  T1.CHAN8
  ORDER BY T1.CHTRDJ ASC, 
           T0.CDDOCO ASC, 
           T0.CDDCTO ASC


