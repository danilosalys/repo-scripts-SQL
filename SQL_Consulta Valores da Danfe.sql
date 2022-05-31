
  select edlnid, fhbnnf,
       fhn001,
       fhmcu, --fhbvis / 100 ST,
       ehan01 / 100 VLR_PROD,
       -- fhbfrt / 100 FRETE,
       -- fhbseg / 100 SEGURO,
       ehan08 / 100 DESCONTO,
       -- ehan05 / 100 DESP_ACES,
       --fhbipi / 100 IPI,
       EHAN06 / 100 VLR_NOTA,
       fhbvtn / 100 VLRNOTA,
       EDAN03 / 100 VLRTOTPROD,
       (fduprc/10000) * fduorg + edan05/100 xxxxxxxxxxxxxx, 
       FDAEXP / 100,
       edan04 / 100 PERDESCPROD,
       edan05 / 100 VLRDESCPROD,
       eduprc / 10000,
       fduorg QTD,
       sdlprc / 10000 PREÇOLISTA,
       edm010 / 100 VLRST,
       fdlitm
  from proddta.f7601b,
       proddta.f555501,
       prodDTA.F555511,
       prodDTA.F7611B,
       proddta.f42119
 where ehbnnf = fhbnnf
   and ehdct = fhdct
   and ehbser = fhbser
   and ehn001 = fhn001
   and fhbnnf in (511619)
   and fhn001 in (15901039)
   AND ehbnnf = EDbnnf
   and ehdct = EDdct
   and ehbser = EDbser
   and ehn001 = EDn001
   AND eDbnnf = FDbnnf
   and eDdct = FDdct
   and eDbser = FDbser
   and eDn001 = FDn001
   AND EDLNID = FDLNID
   and sddoco = fddoco
   and sddcto = fdpdct
   and sdlnid = fdlnid



