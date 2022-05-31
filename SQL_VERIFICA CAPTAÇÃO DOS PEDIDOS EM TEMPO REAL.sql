-- VERIFICA CAPTAÇÃO DOS PEDIDOS EM TEMPO REAL
SELECT DB_EDILD_SEQ , DB_EDILD_DISTR, DB_EDILD_DATA, DB_EDILD_LAYOUT , DB_EDILD_NOMEARQ  
FROM MERCANET_PRD.DB_EDI_LOTE_DISTR 
where DB_EDILD_SEQ = (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-1
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-2
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-3
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-4
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-5
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-6
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-7
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-8
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-9
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-10
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-11
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-12
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-13
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-14
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-15
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-16
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-17
or DB_EDILD_SEQ =  (select max(DB_EDILD_SEQ)from mercanet_prd.DB_EDI_LOTE_DISTR)-18
