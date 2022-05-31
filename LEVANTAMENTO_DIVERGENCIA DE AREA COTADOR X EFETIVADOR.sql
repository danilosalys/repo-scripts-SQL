WITH VENDAS_COTEFACIL AS  (SELECT 'COTAÇÃO' as "Tipo arquivo1",
                                   CLICOT.DB_CLI_CODIGO as "Cod Cliente COT",
                                   CLICOT.DB_CLI_CGCMF as "CNPJ COT",
                                   CLICOT.DB_CLI_NOME as "Razão Social COT",
                                   EDIPCOT.DB_EDIP_DT_EMISSAO as "Data da Cotacao",
                                   EDIPCOT.db_edip_nro as "Nro Cotacao",
                                   EDIPCOT.DB_EDIP_PEDMERC as "Ped Mercanet COT",
                                   PEDCOT.DB_PED_NRO_ORIG as "Ped JDE COT",
                                   PEDCOT.DB_PED_COND_PGTO as "Cond Pgto COT",
                                   CADCLICOT.AIZON as "COD AREA COTADOR",
                                   'EFETIVAÇÃO' as "Tipo arquivo",
                                   CLIEFE.DB_CLI_CODIGO as "Cod Cliente",
                                   CLIEFE.DB_CLI_CGCMF as "CNPJ",
                                   CLIEFE.DB_CLI_NOME as "Razão Social",
                                   EDIPEFE.DB_EDIP_DT_EMISSAO as "Data da Efetivacao",
                                   EDIPEFE.DB_EDIP_NRO as "Nro Efetivacao",
                                   EDIPEFE.DB_EDIP_PEDMERC as "Ped Mercanet",
                                   PEDEFE.DB_PED_NRO_ORIG as "Ped JDE",
                                   PEDEFE.DB_PED_COND_PGTO as "Cond Pgto",
                                   CADCLIEFE.AIZON as "COD AREA EFETIVADOR"
                              FROM MERCANET_PRD.DB_EDI_PEDIDO@DC09 EDIPCOT,
                                   MERCANET_PRD.DB_EDI_PEDIDO@DC09 EDIPEFE,
                                   MERCANET_PRD.DB_PEDIDO@DC09  PEDCOT,
                                   MERCANET_PRD.DB_PEDIDO@DC09  PEDEFE,
                                   MERCANET_PRD.DB_CLIENTE@DC09  CLICOT,
                                   MERCANET_PRD.DB_CLIENTE@DC09  CLIEFE, 
                                   PRODDTA.F03012                CADCLICOT,
                                   PRODDTA.F03012                CADCLIEFE
                             WHERE EDIPCOT.DB_EDIP_OBS1 = EDIPEFE.DB_EDIP_OBS1(+)
                               AND EDIPCOT.DB_EDIP_VAN = 529
                               AND EDIPEFE.DB_EDIP_VAN(+) = 530
                               AND EDIPCOT.DB_EDIP_PEDMERC = PEDCOT.DB_PED_NRO(+)
                               AND EDIPEFE.DB_EDIP_PEDMERC = PEDEFE.DB_PED_NRO(+)
                               AND EDIPCOT.DB_EDIP_COMPRADOR = CLICOT.DB_CLI_CGCMF
                               AND EDIPEFE.DB_EDIP_COMPRADOR = CLIEFE.DB_CLI_CGCMF(+)
                               AND CLICOT.DB_CLI_CODIGO = CADCLICOT.AIAN8
                               AND CLIEFE.DB_CLI_CODIGO = CADCLIEFE.AIAN8) 
SELECT * FROM VENDAS_COTEFACIL
WHERE "COD AREA COTADOR" <> "COD AREA EFETIVADOR"
