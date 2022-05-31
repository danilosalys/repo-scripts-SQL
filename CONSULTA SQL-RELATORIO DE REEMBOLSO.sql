select DRDL01 "PBM OU OL",
       DRDL02 "VAN",
       SAOORN "PROJETO",
       sdvend "Fornecedor",
       trim(a.abalph) "Razão Fornecedor",
       sdan8 "Cliente",
       trim(b.abalph) "Razão Cliente",
       b.abtax "CNPJ",
       (select trim(alcty1)
          from proddta.f0116 t1
         where t1.alan8 = sdan8
           and rownum = 1) "Cidade",
       (select aladds
          from proddta.f0116 t1
         where t1.alan8 = sdan8
           and rownum = 1) "Estado",
       decode(sdivd, 0, null, TO_DATE(sdivd + 1900000, 'YYYYDDD')) "Data NF",
       sddoc "Documento",
       trim(sdlitm) "Cód. Produto",
       trim(trim(sddsc1) || ' ' || trim(sddsc2)) "Descrição",
       sdsoqs "Quantidade",
       sdlotn "Lote",
       sduom "U/M",
       alast "Cód. Ajuste",
       (sdlprc - aluprc) / 10000 "Reembolso",
       aluprc / 10000 "Valor Ajuste",
       sduprc / 10000 "Preço Pedido",
       sdlprc / 10000 "Preço Fábrica",
       concat(lpad(sbstdslpr,5,0), lpad((sbuprc / 100), 8, 0)) "EAN",
       b.abac01 "Regiao",
       sdemcu "Filial Venda",
       case trim(SDEMCU) when 'DIFARMA'   then '05.651.966/0004-55'
                         when 'DIFARARC'  then '05.651.966/0006-17'
                         when 'DIFARCAT'  then '05.651.966/0001-02'
                         when 'DIFARCAMB' then '05.651.966/0011-84'
                         when 'DIFARBRA'  then '05.651.966/0012-65'
                         when 'DIFARRIO'  then '05.651.966/0009-60' else SDEMCU end "CNPJ Filial Venda",
       case trim(DRDL02) when 'Seven PDV' then savr01 else ' ' end "Lote Seven",
       sddoco "Pedido Jde",
       sddcto "Tipo Ped Jde",
       'ELE JDE'
  from proddta.f42119,
       proddta.f4074 j,
       proddta.f4102,
       proddta.f0101 a,
       proddta.f0101 b,
       PRODCTL.F0005,
       PRODDTA.F5547011,
       PRODDTA.F5547012
 where sdivd between
       TO_CHAR(to_date('&"Data Inicial (DD/MM/AA)"', 'DD/MM/YY'), 'YYYYDDD') -
       1900000 and TO_CHAR(to_date('&"Data Final (DD/MM/AA)"', 'DD/MM/YY'),
                           'YYYYDDD') - 1900000
   and alast = 'V0000076'
   and aldoco = sddoco
   and aldcto = sddcto
   and alkcoo = sdkcoo
   and allnid = sdlnid
   and ibitm = sditm
   and ibmcu = '    DIFARCAT'
   and a.aban8 = sdvend
   and b.aban8 = sdan8
   AND SADOCO = SDDOCO
   AND SAOORN != 'MERCANET'
   AND DRSY(+) = '55'
   AND DRRT(+) = 'OL'
   AND DRKY(+) = SAOORN
   AND saukid = sbukid
   AND sdlitm = sblitm
--and sdvend = 7297 -- nº do fornecedor
UNION ALL
SELECT ' ' ,
       ' ',
       ' ',
       sdvend "Fornecedor",
       trim(a.abalph) "Razão Fornecedor",
       sdan8 "Cliente",
       trim(b.abalph) "Razão Cliente",
       b.abtax "CNPJ",
       (select trim(alcty1)
          from proddta.f0116 t1
         where t1.alan8 = sdan8
           and rownum = 1) "Cidade",
       (select aladds
          from proddta.f0116 t1
         where t1.alan8 = sdan8
           and rownum = 1) "Estado",
       decode(sdivd, 0, null, TO_DATE(sdivd + 1900000, 'YYYYDDD')) "Data NF",
       sddoc "Documento",
       trim(sdlitm) "Cód. Produto",
       trim(trim(sddsc1) || ' ' || trim(sddsc2)) "Descrição",
       sdsoqs "Quantidade",
       sdlotn "Lote",
       sduom "U/M",
       alast "Cód. Ajuste",
       decode(alast,
              'V0000140',
              -aluprc,
              'V0000141',
              -aluprc,
              'V0000143',
              -aluprc,
              0) / 10000 "Reembolso",
       aluprc / 10000 "Valor Ajuste",
       sduprc / 10000 "Preço Pedido",
       sdlprc / 10000 "Preço Fábrica",
       (select ivcitm
        from proddta.f4104 t1
        where ivxrt = 'VN'    and
              ivexdj >= sdivd and 
              ivlitm = sdlitm 
              and rownum = 1) "EAN",
       b.abac01 "Regiao",
       SDEMCU "Filial Venda",
       case trim(SDEMCU) when 'DIFARMA'   then '05.651.966/0004-55'
                         when 'DIFARARC'  then '05.651.966/0006-17'
                         when 'DIFARCAT'  then '05.651.966/0001-02'
                         when 'DIFARCAMB' then '05.651.966/0011-84'
                         when 'DIFARBRA'  then '05.651.966/0012-65'
                         when 'DIFARRIO'  then '05.651.966/0009-60' else SDEMCU end "CNPJ Filial Venda",
       'Lote Seven',  
       sddoco "Pedido Jde",
       sddcto "Tipo Ped Jde",
       'OL MANUAL'
  from proddta.f42119,
       proddta.f4074 j,
       proddta.f4102,
       proddta.f0101 a,
       proddta.f0101 b
  where sdivd between
       TO_CHAR(to_date('&"Data Inicial (DD/MM/AA)"', 'DD/MM/YY'), 'YYYYDDD') -
       1900000 and TO_CHAR(to_date('&"Data Final (DD/MM/AA)"', 'DD/MM/YY'),
                           'YYYYDDD') - 1900000
   and alast in ('V0000140', 'V0000141', 'V0000143')
   and aldoco = sddoco
   and aldcto = sddcto
   and alkcoo = sdkcoo
   and allnid = sdlnid
   and ibitm = sditm
   and ibmcu = '    DIFARCAT'
   and a.aban8 = sdvend
   and b.aban8 = sdan8
--and sdvend = 7297 -- nº do fornecedor
UNION ALL
SELECT distinct DECODE(em06_pbm, 1, 'PBM', 'OL') "PBM OU OL",
                em01_ean "VAN",
                DB_EDII_PROJETO "PROJETO",
                sdvend "Fornecedor",
                trim(a.abalph) "Razão Fornecedor",
                sdan8 "Cliente",
                trim(b.abalph) "Razão Cliente",
                b.abtax "CNPJ",
                (select trim(alcty1)
                   from proddta.f0116 t1
                  where t1.alan8 = sdan8
                    and rownum = 1) "Cidade",
                (select aladds
                   from proddta.f0116 t1
                  where t1.alan8 = sdan8
                    and rownum = 1) "Estado",
                decode(sdivd, 0, null, TO_DATE(sdivd + 1900000, 'YYYYDDD')) "Data NF",
                sddoc "Documento",
                trim(sdlitm) "Cód. Produto",
                trim(trim(sddsc1) || ' ' || trim(sddsc2)) "Descrição",
                sdsoqs "Quantidade",
                sdlotn "Lote",
                sduom "U/M",
                alast "Cód. Ajuste",
                (sdlprc - aluprc) / 10000 "Reembolso",
                aluprc / 10000 "Valor Ajuste",
                sduprc / 10000 "Preço Pedido",
                sdlprc / 10000 "Preço Fábrica",
                concat(lpad(sbstdslpr,5,0), lpad((sbuprc / 100), 8, 0)) "EAN",
                b.abac01 "Regiao",
                SDEMCU "Filial Venda",
                case trim(SDEMCU) when 'DIFARMA'   then '05.651.966/0004-55'
                         when 'DIFARARC'  then '05.651.966/0006-17'
                         when 'DIFARCAT'  then '05.651.966/0001-02'
                         when 'DIFARCAMB' then '05.651.966/0011-84'
                         when 'DIFARBRA'  then '05.651.966/0012-65'
                         when 'DIFARRIO'  then '05.651.966/0009-60' else SDEMCU end "CNPJ Filial Venda",
                 case trim(em01_ean) when 'SEVEN PDV' then DB_EDIP_OBS1 else ' ' end "Lote Seven",
                 sddoco "Pedido Jde",
                 sddcto "Tipo Ped Jde",
                 'ELE MERCANET'
  from proddta.f42119,
       proddta.f4074 j,
       proddta.f4102,
       proddta.f0101 a,
       proddta.f0101 b,
       PRODDTA.F5547011,
       PRODDTA.F5547012,
       MERCANET_PRD.mem01@dc09,
       MERCANET_PRD.mem06@dc09,
       MERCANET_PRD.db_pedido_distr@dc09,
       MERCANET_PRD.db_edi_pedido@dc09,
       MERCANET_PRD.db_edi_pedprod@dc09
 where sdivd between
       TO_CHAR(to_date('&"Data Inicial (DD/MM/AA)"', 'DD/MM/YY'), 'YYYYDDD') -
       1900000 and TO_CHAR(to_date('&"Data Final (DD/MM/AA)"', 'DD/MM/YY'),
                           'YYYYDDD') - 1900000
   and alast = 'V0000076'
   and aldoco = sddoco
   and aldcto = sddcto
   and alkcoo = sdkcoo
   and allnid = sdlnid
   and ibitm = sditm
   and ibmcu = '    DIFARCAT'
   and a.aban8 = sdvend
   and b.aban8 = sdan8
   and sadoco = sddoco
   and saoorn = 'MERCANET'
   AND saukid = sbukid
   AND sdlitm = sblitm
   and db_pedt_distr = em06_distr
   and db_pedt_projeto = em06_projeto
   and to_char(db_pedt_pedido) = trim(savr01)
   and em06_distr = em01_codigo
   and DB_EDIP_PEDMERC = db_pedt_pedido
   and DB_EDIP_PEDMERC = db_edii_pedmerc 
   and db_edii_produto = lpad(SBSTDSLPR,5,'0') || lpad(ROUND(SBUPRC/100,0),8,'0')


