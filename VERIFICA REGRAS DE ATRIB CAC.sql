-- As regras de atribuiçao das Atendentes do CAC,são tratadas de
-- forma diferente, pois o cadastro é constantemente alterado,
-- no entanto, o script funciona para todas as regra de atribuição

SELECT PV06_POLITICA,
       PV06_IDENT,
       CASE
         WHEN PV06_POLITICA IN (1035, 1033) THEN
          SUBSTR(PV06_IDENT, 1, INSTR(PV06_IDENT, '#', 1, 2) - 1)
         ELSE
          CASE
            WHEN PV06_POLITICA IN (1034, 1032) THEN
             SUBSTR(PV06_IDENT, 1, INSTR(PV06_IDENT, '#', 1, 1)) ||
             SUBSTR(PV06_IDENT,
                    INSTR(PV06_IDENT, '#', 1, 2) + 1,
                    INSTR(PV06_IDENT, '#', 1, 3) - 1 -
                    INSTR(PV06_IDENT, '#', 1, 2))
            ELSE
             CASE
               WHEN PV06_POLITICA IN (1026) THEN
                PV06_IDENT
             END
          END
       END as "Regra",
       PV06_IDREGRA,
       DB_CPO_VALORINF

  FROM MERCANET_PRD.MPV06, MERCANET_PRD.DB_CPO_ATRIB
 WHERE PV06_POLITICA IN (1021, 1022, 1023) -- inserir as regras
   AND PV06_IDREGRA = DB_CPO_RES_PAI
