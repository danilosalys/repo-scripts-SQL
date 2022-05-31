--TABELA DE DETALHE COMPLEMENTAR- F554211C

INSERT INTO CRPDTA.F554211C
  (CDUKID, --UKID
   CDKCOO, --COMPANHIA
   CDDOCO, --PEDIDO - DOCO
   CDDCTO, --TIPO DO PEDIDO
   CDLNID, --LNID
   CDCITM, --EAN DO PRODUTO
   CDUORG, --QTDE SOLICITADA
   CDLITM, --CODIGO DO ITEM
   CDSOQS, --QTDE ATENDIDA
   CDPERCENT, --PERCENTUAL DO DESCONTO EM NOTA FISCAL
   CDDCPC, --PERCENTUAL DO DESCONTO FINANCEIRO - BOLETO
   CDAN01, --VALOR DO DESCONTO EM NOTA FISCAL
   CDBDFN, --VALOR DO DESCONTO FINANCEIRO - BOLETO
   CDAA10, --SIGLA DA INDUSTRIA - CODIGO DO PROJETO
   CDEV01 --FLAG - STATUS DE INTEGRACAO DO PRODUTO
   )
  SELECT (SELECT MAX(CHUKID) FROM CRPDTA.F554201C) AS "UKID", -- MESMO UKID GRAVADO NA TABELA DE CABE�ALHO
         F4211.SDKCOO AS "KCOO (PK)  Companhia",
         F4211.SDDOCO AS "DOCO (PK)  PED DCENTER",
         F4211.SDDCTO AS "DCTO (PK)  Tipo do Ped",
         F4211.SDLNID AS "LNID (PK)  ",
         TRIM(F4104.IVCITM) AS "CITM - EAN do produto",
         F4211.SDUORG AS "UORG - QTDE SOLIC",
         F4211.SDLITM AS "LITM - C�digo do Item",
         F4211.SDSOQS AS "SOQS - QTDE ATEND",
         CASE
           WHEN F5542099.CCCW01 < 0 THEN
            F5542099.CCCW01
           ELSE
            CASE
              WHEN F5542099.CCCW03 < 0 THEN
               F5542099.CCCW03
              ELSE
               CASE
                 WHEN F5542099.CCCW05 < 0 THEN
                  F5542099.CCCW05
                 ELSE
                  0
               END
            END
         END AS "PERCENT - PERC DESCTO",
         CASE
           WHEN F5542099.CCCW02 < 0 THEN
            F5542099.CCCW02
           ELSE
            CASE
              WHEN F5542099.CCCW04 < 0 THEN
               F5542099.CCCW04
              ELSE
               CASE
                 WHEN F5542099.CCCW06 < 0 THEN
                  F5542099.CCCW06
                 ELSE
                  0
               END
            END
         END AS "PERCENT - PERC DESCTO FIN",
         F5542099.CCAN01 AS "AN01 - VALOR DO DESC NF", --CAMPO AINDA SER� CRIADO NA TABELA F5542099
         F5542099.CCAN03 AS "AN02 - VALOR DO DESC FIN", --CAMPO AINDA SER� CRIADO NA TABELA F5542099
         F5542095.CIAA10 AS "AA10 -  Sigla da Ind�stria",
         'P' AS "EV01 - Status de Int Prod"
    FROM CRPDTA.F4211    F4211,
         CRPDTA.F5542099 F5542099,
         CRPDTA.F7611B   F7611B,
         CRPDTA.F5542095 F5542095,
         CRPDTA.F4104    F4104
   WHERE F4211.SDDOCO = F5542099.CCDOCO
     AND F4211.SDDCTO = F5542099.CCDCTO
     AND F4211.SDKCOO = F5542099.CCKCOO
     AND F4211.SDLNID = F5542099.CCLNID
     AND F4211.SDDOCO = F7611B.FDDOCO
     AND F4211.SDDCTO = F7611B.FDPDCT
     AND F4211.SDKCOO = F7611B.FDKCOO
     AND F4211.SDLNID = F7611B.FDLNID
     AND F5542099.CCUKID = F5542095.CIUKID
     AND F5542099.CCPUKID = F5542095.CIPUKID
     AND F4211.SDVEND = F5542095.CIVEND
     AND F4211.SDITM = F4104.IVITM
     AND F4104.IVXRT = 'VN'
     AND F4104.IVDSC2 = 'E'
     AND F4104.IVEFTJ <= to_number(to_char(sysdate, 'YYYYDDD') - 1900000)
     AND F4104.IVEXDJ >= to_number(to_char(sysdate, 'YYYYDDD') - 1900000)
     AND F5542099.CCPUKID = 2
     AND F4211.SDNXTR >= 600
     AND F4211.SDLTTR NOT BETWEEN 980 AND 989
     AND F5542099.CCEV03 = 'S'
     AND F5542099.CCSEC = '0'
     AND F4211.SDDOCO = 156062
   ORDER BY F4211.SDDOCO, F5542099.CCFDA2, F4211.SDLNID;

 
--TABELA DE CABE�ALHO COMPLEMENTAR

INSERT INTO CRPDTA.F554201C
  (CHUKID, --UKID
   CHKCOO, --COMPANHIA
   CHDOCO, --PEDIDO - DOCO
   CHDCTO, --TIPO DO PEDIDO
   CHUOR2, --TOTAL DE PRODUTOS NO PEDIDO
   CHAC01, --REGI�O DO CLIENTE
   CHAN8, --CODIGO DO CLIENTE
   CHBCGT, --CNPJ DO CLIENTE
   CHBCGF, --CNPJ DA FILIAL
   CHAA05, --CONDICAO COMERCIAL
   CHEV01 --FLAG DE INTEGRACAO DO PEDIDO
   )
  SELECT (SELECT UKUKID FROM CRPDTA.F00022 WHERE UKOBNM = 'F554201C') AS "UKID",
         F4211.SDKCOO AS "KCOO  - Companhia",
         F4211.SDDOCO AS "DOCO  - N� Ped Drogacenter",
         F4211.SDDCTO AS "DCTO  - Tipo do Pedido",
         COUNT(DISTINCT F4211.SDLITM) AS "UOR2 - TOTAL PROD ENVIADOS CA",
         F0101.ABAC01 AS "AC01  - Regi�o do Cliente",
         F4211.SDAN8 AS "AN8   - C�digo do Cliente",
         TRIM(F0101.ABTAX) AS "BCGT  - CNPJ do cliente PDV",
         (SELECT SQ2.ABTAX
            FROM CRPDTA.F0006 SQ1, CRPDTA.F0101 SQ2
           WHERE F4211.SDEMCU = SQ1.MCMCU
             AND SQ1.MCAN8 = SQ2.ABAN8) AS "BCGF  - CNPJ da filial",
         F5542099.CCFDA2 AS "AA05  - Condi��o comercial",
         'P' AS "EV01  - Status de Integra��o"
    FROM CRPDTA.F4211 F4211, CRPDTA.F5542099 F5542099, CRPDTA.F0101 F0101
   WHERE F4211.SDDOCO = F5542099.CCDOCO
     AND F4211.SDDCTO = F5542099.CCDCTO --
     AND F4211.SDKCOO = F5542099.CCKCOO
     AND F4211.SDLNID = F5542099.CCLNID
     AND F4211.SDAN8 = F0101.ABAN8
     AND F4211.SDDOCO IN (156062)
     AND F4211.SDNXTR >= 600
     AND F4211.SDLTTR NOT BETWEEN 980 AND 989
     AND F5542099.CCEV03 = 'S'
     AND F5542099.CCSEC = '0'
     AND F4211.SDDOCO = 156062
   GROUP BY F4211.SDKCOO,
            F4211.SDDOCO,
            F4211.SDDCTO,
            F0101.ABAC01,
            F4211.SDAN8,
            F0101.ABTAX,
            F5542099.CCFDA2,
            F4211.SDEMCU
   ORDER BY F4211.SDDOCO, F5542099.CCFDA2;

--TABELA DE CABE�ALHO DE INTEGRA��O - F554201I

INSERT INTO CRPDTA.F554201I
  (IHUKID, --UKID
   IHKCOO, --COMPANHIA
   IHDOCO, --PEDIDO - DOCO
   IHDCTO, --TIPO DO PEDIDO
   IHUOR2, --QUANTIDADE DE PRODUTOS NO PEDIDO
   IHAN8, --CODIGO DO CLIENTE
   IHBCGT, --CNPJ DO CLIENTE
   IHBCGF, --CNPJ DA FILIAL
   IHAA05, --CONDI��O COMERCIAL
   IHEV01) --STATUS DE INTEGRACAO DO PEDIDO
  SELECT (SELECT MAX(CHUKID) FROM CRPDTA.F554201C) AS "UKID", --MESMO UKID GRAVADO NA TABELA F554201C
         F4211.SDKCOO AS "KCOO  - Companhia",
         F4211.SDDOCO AS "DOCO  - N� Ped Drogacenter",
         F4211.SDDCTO AS "DCTO  - Tipo do Pedido",
         COUNT(DISTINCT F4211.SDLITM) AS "UOR2  - TOTAL PROD ENVIADOS CA", --ALTERAR PARA INT01
         F4211.SDAN8 AS "AN8   - C�digo do Cliente",
         TRIM(F0101.ABTAX) AS "BCGT  - CNPJ do cliente PDV",
         (SELECT SQ2.ABTAX
            FROM CRPDTA.F0006 SQ1, CRPDTA.F0101 SQ2
           WHERE F4211.SDEMCU = SQ1.MCMCU
             AND SQ1.MCAN8 = SQ2.ABAN8) AS "BCGF  - CNPJ da filial",
         F5542099.CCFDA2 AS "AA05  - Condi��o comercial", -- FALTA CRIAR CAMPO NA F5542099 - TESTES: CRIAR ACAO COM ABB
         'P' AS "EV01  - Status de Integra��o" --'STATUS AP�S DE-PARA'
    FROM CRPDTA.F4211 F4211, CRPDTA.F5542099 F5542099, CRPDTA.F0101 F0101
   WHERE F4211.SDDOCO = F5542099.CCDOCO
     AND F4211.SDDCTO = F5542099.CCDCTO
     AND F4211.SDKCOO = F5542099.CCKCOO
     AND F4211.SDLNID = F5542099.CCLNID
     AND F4211.SDAN8 = F0101.ABAN8
     AND F4211.SDDOCO IN (156062)
     AND F4211.SDNXTR >= 600
     AND F4211.SDLTTR NOT BETWEEN 980 AND 989
     AND F5542099.CCEV03 = 'S'
     AND F5542099.CCSEC = '0'
     AND F4211.SDDOCO = 156062
   GROUP BY F4211.SDKCOO,
            F4211.SDDOCO,
            F4211.SDDCTO,
            F4211.SDAN8,
            F0101.ABTAX,
            F5542099.CCFDA2,
            F4211.SDEMCU
   ORDER BY F4211.SDDOCO, F5542099.CCFDA2;

--SELECT * FROM CRPDTA.F554201I


--TABELA DE DETALHE DE INTEGRA��O - F554211I

INSERT INTO CRPDTA.F554211I
  (IDUKID, --CRIAR CAMPO NA TABELA
   IDKCOO, --COMPANHIA
   IDDOCO, --PEDIDO - DOCO
   IDDCTO, --TIPO DO PEDIDO
   IDLNID, --LNID
   IDCITM, --EAN
   IDUORG, --QTDE SOLICITADA
   IDLITM, --CODIGO DO ITEM
   IDSOQS, --QTDE ATENDIDA
   IDDCPC, --PERCENTUAL DO DESCONTO FINANCEIRO - BOLETO
   IDAN01, --VALOR DO DESCONTO EM NOTA FISCAL
   IDBDFN, --VALOR DO DESCONTO FINANCEIRO - BOLETO
   IDAA10, --SIGLA DA INDUSTRIA
   IDEV01 --STATUS DE INTEGRACAO DO PRODUTO
   )
  SELECT (SELECT MAX(CHUKID) FROM CRPDTA.F554201C), -- MESMO UKID DA TABELA F554201C
         SDKCOO AS "KCOO (PK)  Companhia",
         SDDOCO AS "DOCO (PK)  PED DCENTER",
         SDDCTO AS "DCTO (PK)  Tipo do Ped",
         SDLNID AS "LNID (PK)  ",
         TRIM(IVCITM) AS "CITM - EAN do produto",
         SDUORG AS "UORG - QTDE SOLIC",
         SDLITM AS "LITM - C�digo do Item",
         SDSOQS AS "SOQS - QTDE ATEND",
         CASE
           WHEN F5542099.CCCW01 < 0 THEN
            F5542099.CCCW01
           ELSE
            CASE
              WHEN F5542099.CCCW03 < 0 THEN
               F5542099.CCCW03
              ELSE
               CASE
                 WHEN F5542099.CCCW05 < 0 THEN
                  F5542099.CCCW05
                 ELSE
                  0
               END
            END
         END AS "PERCENT - PERC DESCTO",
         CASE
           WHEN F5542099.CCCW02 < 0 THEN
            F5542099.CCCW02
           ELSE
            CASE
              WHEN F5542099.CCCW04 < 0 THEN
               F5542099.CCCW04
              ELSE
               CASE
                 WHEN F5542099.CCCW06 < 0 THEN
                  F5542099.CCCW06
                 ELSE
                  0
               END
            END
         END AS "PERCENT - PERC DESCTO FIN",
         F5542099.CCAN01 AS "AN01 - VALOR DO DESC NF", --CAMPO AINDA SER� CRIADO NA TABELA F5542099
         F5542099.CCAN03 AS "AN02 - VALOR DO DESC FIN", --CAMPO AINDA SER� CRIADO NA TABELA F5542099
         T4.CIAA10 AS "AA10 -  Sigla da Ind�stria",
         'P' AS "EV01 - Status de Int Prod"
    FROM CRPDTA.F4211    F4211,
         CRPDTA.F5542099 F5542099,
         CRPDTA.F7611B   T3,
         CRPDTA.F5542095 T4,
         CRPDTA.F4104    T5
   WHERE F4211.SDDOCO = F5542099.CCDOCO
     AND F4211.SDDCTO = F5542099.CCDCTO
     AND F4211.SDKCOO = F5542099.CCKCOO
     AND F4211.SDLNID = F5542099.CCLNID
     AND F4211.SDDOCO = T3.FDDOCO
     AND F4211.SDDCTO = T3.FDPDCT
     AND F4211.SDKCOO = T3.FDKCOO
     AND F4211.SDLNID = T3.FDLNID
     AND F5542099.CCUKID = T4.CIUKID
     AND F5542099.CCPUKID = T4.CIPUKID
     AND F4211.SDVEND = T4.CIVEND
     AND F4211.SDITM = T5.IVITM
     AND T5.IVXRT = 'VN'
     AND T5.IVDSC2 = 'E'
     AND T5.IVEFTJ <= to_number(to_char(sysdate, 'YYYYDDD') - 1900000)
     AND T5.IVEXDJ >= to_number(to_char(sysdate, 'YYYYDDD') - 1900000)
     AND F5542099.CCPUKID = 2
     AND F4211.SDNXTR >= 600
     AND F4211.SDLTTR NOT BETWEEN 980 AND 989
     AND F5542099.CCEV03 = 'S'
     AND F5542099.CCSEC != '0'
     AND F4211.SDDOCO = 156062
   ORDER BY F4211.SDDOCO, F5542099.CCFDA2, F4211.SDLNID;

--SELE��O DOS DADOS DE DETALHE DA NOTA 

SELECT T1.CDLNID,
       (SELECT MAX(CHUKID) FROM CRPDTA.F554201C),
       T2.FDAEXP AS "AEXP - Valor Total Prod",
       T2.FDAEXP + T2.FDBVIS AS "AN08 - Valor total Prod + Imp",
       T2.FDUPRC AS "Valor Liq Unit",
       T1.CDPERCENT AS "PERCENT - Perc Dcto",
       T1.CDDCPC AS "AN01 - Valor Unit Desc",
       T2.FDBBCL AS "AN02 - Base c�lculo ICMS",
       T2.FDBBIS AS "AN03 - Base Calc ICMS ST",
       T2.FDTXR1 AS "TXR1 - Perc  Al�q ICMS",
       T2.FDTXR2 AS "TXR2  Percentual Al�q IPI",
       T2.FDBICM AS "AN04 - Valor do ICMS",
       T2.FDBVIS AS "AN05 - Valor da ST",
       0 AS "AN06 - Valor do ICMS Repassado",
       (SELECT DPBRNOP
          FROM CRPDTA.F76B200
         WHERE DPBNOP = T2.FDBNOP
           AND DPBSOP = T2.FDBSOP
           AND DPFCO = T2.FDFCO) AS "BRNOP - CFOP",
       DECODE(TRIM(T2.FDBSTT),
              '10',
              'S',
              '60',
              'S',
              '00',
              'N',
              '20',
              'N',
              'I') AS "BSTT FLAG ST", --BIST  Flag de Substitui��o Tribut�ria (S = Substitui��o / N = Normal / I = Isento) 
       DECODE(TRIM(T3.SDSRP3), 'POS', 'P', 'NEG', 'N', 'NEU', '0', '0') as "FLAG - Ident Lista", --Identificador da lista positiva (P = Positiva / N = Negativa / O = Neutro)
       T3.SDPTC AS "PTC - Prazo do produto",
       0 AS "DCPC - Perc Desc Fin", 
       CDBDFN AS "BDFN - Valor Unit Desc Fin", 
       T6.EDAN07 AS "AN07 - Valor do Repasse", 
       T2.FDBSTT AS "BSTT - C�d da Situa��o Trib", 
       '' AS "UK02 - Classif do Prod", --AGUARDANDO PARECER DA FIDELIZE SOBRE QUAL VALOR INFORMAR
       T1.CDAA10 AS "AA10 - Sigla da Ind�stria",
       '' AS "DL01 -     DCB",
       DECODE(TRIM(T4.IBSRP8), 'C', 'M', 'P', 'L', T4.IBSRP8) AS "SRP8 - Tipo de produto", --(M = Monitorado / L = Liberado)
       0 AS "AN09 - Valor do Reembolso",
       'P' AS "EV02 - Status de Integracao NF",
       T2.FDUORG AS "TRQT - Quantidade do Lote",
       T2.FDLOTN AS "LOTN - Identifica��o do Lote",
       T5.IOMMEJ AS "MMEJ - Data de Venc do Lote"
  FROM CRPDTA.F554211C T1,
       CRPDTA.F7611B   T2,
       CRPDTA.F4211    T3,
       CRPDTA.F4102    T4,
       CRPDTA.F4108    T5,
       CRPDTA.F555511  T6
 WHERE T1.CDDOCO = T2.FDDOCO
   AND T1.CDDCTO = T2.FDPDCT
   AND T1.CDKCOO = T2.FDKCOO
   AND T1.CDLNID = T2.FDLNID
   AND T2.FDKCOO = T3.SDKCOO
   AND T2.FDDOCO = T3.SDDOCO
   AND T2.FDPDCT = T3.SDDCTO
   AND T2.FDLNID = T3.SDLNID
   AND T3.SDITM = T4.IBITM
   AND T3.SDMCU = T4.IBMCU
   AND T2.FDMCU = T5.IOMCU
   AND T2.FDITM = T5.IOITM
   AND T2.FDLOTN = T5.IOLOTN
   AND T2.FDBNNF = T6.EDBNNF
   AND T2.FDN001 = T6.EDN001
   AND T2.FDBSER = T6.EDBSER
   AND T2.FDDCT = T6.EDDCT
   AND T2.FDLNID = T6.EDLNID
   AND T1.CDEV01 = 'Y'


--SELE��O DOS DADOS DE CABE�ALHO DA NOTA 


--CABE�ALHO DA NOTA

SELECT T3.FHBNNF AS "BNNF - NUMERO DA NF",
       T3.FHBSER AS "BSER - SERIE DA NF", 
       T3.FHN001 AS "N001",
       T7.NEBBRCD AS "BBRCD - CHAVE DO DANFE",
       T3.FHISSU AS "ISSU - DATA EMISSAO DA NF",
       SUM(T2.FDAEXP + T2.FDBVIS) AS "BVTN - VALOR TOTAL DA NOTA",
       SUM(T2.FDAEXP) AS "BVTM - VALOR TOTAL PROD",
       SUM(T6.EDAN05 - T6.EDAN07) AS  "BDES - VALOR DO DESC NF",
       SUM(T2.FDBBCL) AS "BBCL - Base c�lculo ICMS",
       SUM(T2.FDBBIS) AS "BBIS - Base Calc ICMS ST",
       SUM(T2.FDBICM) AS "BICM - Valor do ICMS",
       SUM(T2.FDBVIS) AS "AN01 - Valor da ST",
       SUM(T6.EDAN07) AS "BREP - Valor do Repasse",
       SUM(T3.FHTOQN) AS "TOQN - QUANTIDADE DE VOLUMES", 
       'P' AS "EV02 - Status de Integracao NF"
  FROM CRPDTA.F554211C T1,
       CRPDTA.F7611B   T2,
       CRPDTA.F7601B   T3,
       CRPDTA.F555511  T6,
       CRPDTA.F55NFE03 T7
WHERE T1.CDDOCO = T2.FDDOCO
   AND T1.CDDCTO = T2.FDPDCT
   AND T1.CDKCOO = T2.FDKCOO
  AND T1.CDLNID = T2.FDLNID
   AND T2.FDBNNF = T3.FHBNNF
   AND T2.FDN001 = T3.FHN001
   AND T2.FDBSER = T3.FHBSER
   AND T2.FDDCT  = T3.FHDCT
   AND T2.FDBNNF = T6.EDBNNF
   AND T2.FDN001 = T6.EDN001
   AND T2.FDBSER = T6.EDBSER
   AND T2.FDDCT = T6.EDDCT
   AND T2.FDLNID = T6.EDLNID
   AND T2.FDBNNF = T7.NEBNNF
   AND T2.FDBSER = T7.NEBSER
   AND T2.FDDCT = T7.NEDCT
   AND T2.FDN001 = T7.NEN001
   --AND T1.CDEV01 = 'P' --CASO N�O TENHA REGISTROS DE PEDIDO AUTORIZADO, MUDAR PARA 'P' PARA TESTAR A QUERY
GROUP BY T1.CDUKID, T3.FHBNNF, T3.FHBSER, T3.FHN001,T3.FHISSU, T7.NEBBRCD
