--INSERE TABELAS PARA CENARIOS
/*DROP TABLE ORIGEM_PEDIDO ;
DROP TABLE ORIEM_DESTINO ;
DROP TABLE TIPO_CLIENTE_AC05;
DROP TABLE CAT_CLI_1004;
DROP TABLE CAT_CLI_1008;
DROP TABLE CAT_CLI_1010;
DROP TABLE CAT_CLI_1015;
DROP TABLE TIPO_PRODUTO_SRP8;
DROP TABLE PROMOCAO;*/
-----------------------------
/*
CREATE TABLE ORIGEM_PEDIDO (seq number, ORIGEM_PED varchar2(20)) ; 

CREATE TABLE ORIGEM_DESTINO (seq number, ORI_DEST varchar2(20)); 

CREATE TABLE TIPO_CLIENTE_AC05(seq number, AC05 varchar2(20)); 

CREATE TABLE CAT_CLI_1004 (seq number, AC04 varchar2(20));

CREATE TABLE CAT_CLI_1008 (seq number, AC08 varchar2(20));

CREATE TABLE CAT_CLI_1010 (seq number, AC10 varchar2(20));

CREATE TABLE CAT_CLI_1015 (seq number, AC15 varchar2(20));

CREATE TABLE TIPO_PRODUTO_SRP8 (seq number, SRP8 varchar2(20));

CREATE TABLE PROMOCAO (seq number, PRP3 varchar2(20));

----------------
--INSERIR OS CENÁRIOS

insert into  ORIGEM_PEDIDO values (1 ,'EUSE = HRY');
insert into  ORIGEM_PEDIDO values (1 ,'EUSE = ZHR');
insert into  ORIGEM_PEDIDO values (1 ,'EUSE = PBM');
insert into  ORIGEM_PEDIDO values (1 ,'EUSE = CTC | PTC');
insert into  ORIGEM_PEDIDO values (1 ,'EUSE = MPE');
--insert into  ORIGEM_PEDIDO values (1 ,'EUSE = ORA');
--insert into  ORIGEM_PEDIDO values (1 ,'EUSE = ORR');
--insert into  ORIGEM_PEDIDO values (1 ,'EUSE = ORG');
--insert into  ORIGEM_PEDIDO values (1 ,'EUSE = PRP');
--insert into  ORIGEM_PEDIDO values (1 ,'EUSE = MPR');

insert into  ORIGEM_DESTINO values (1 ,'GO - GO');
insert into  ORIGEM_DESTINO values (1 ,'GO - SP');
insert into  ORIGEM_DESTINO values (1 ,'GO - RJ');
insert into  ORIGEM_DESTINO values (1 ,'MG - MG');
insert into  ORIGEM_DESTINO values (1 ,'PR - PR');
insert into  ORIGEM_DESTINO values (1 ,'PR - SC');
insert into  ORIGEM_DESTINO values (1 ,'RJ - RJ');
insert into  ORIGEM_DESTINO values (1 ,'SP - SP');

insert into  TIPO_CLIENTE_AC05 values (1 ,'AC05 <> DRO');
insert into  TIPO_CLIENTE_AC05 values (1 ,'AC05 = DRO');

insert into  CAT_CLI_1004 values (1 ,'1004 = AA');
insert into  CAT_CLI_1004 values (1 ,'1004 <> AA');

insert into  CAT_CLI_1008 values (1 ,'1008 = AA');
insert into  CAT_CLI_1008 values (1 ,'1008 <> AA');

insert into  CAT_CLI_1010 values (1 ,'1010 = AA');
insert into  CAT_CLI_1010 values (1 ,'1010 <> AA');

insert into  CAT_CLI_1015 values (1 ,'1015 = 7');
insert into  CAT_CLI_1015 values (1 ,'1015 = 35');
insert into  CAT_CLI_1015 values (1 ,'1015 = ANN');

insert into  TIPO_PRODUTO_SRP8 values (1 ,'C');
insert into  TIPO_PRODUTO_SRP8 values (1 ,'L');
insert into  TIPO_PRODUTO_SRP8 values (1 ,'V');
insert into  TIPO_PRODUTO_SRP8 values (1 ,'Z');
insert into  TIPO_PRODUTO_SRP8 values (1 ,'P');
insert into  TIPO_PRODUTO_SRP8 values (1 ,'Y');

insert into  PROMOCAO values (1 ,'PRP3 = AA');
insert into  PROMOCAO values (1 ,'PRP3 <> AA');*/

---------------------
/*select * 
  from ORIGEM_PEDIDO A, 
       ORIGEM_DESTINO B,
       TIPO_CLIENTE_AC05 C,
       CAT_CLI_1004 D,
       CAT_CLI_1008 E,
       CAT_CLI_1010 F,
       CAT_CLI_1015 G,
       TIPO_PRODUTO_SRP8 H,
       PROMOCAO I
where a.seq = b.seq
  and b.seq = c.seq
  and c.seq = d.seq
  and d.seq = e.seq
  and e.seq = f.seq
  and f.seq = g.seq
  and g.seq = h.seq  
  and h.seq = i.seq  
order by a.origem_ped, b.ori_dest , c.ac05, d.ac04,e.ac08, f.ac10, g.ac15 , i.prp3, h.srp8; */

----------------------------------------------------------------------------------------------------------------------------
--CRIA TABELA DE CENÁRIOS
drop table cenarios;

create table CENARIOS
(
  id_cenario     NUMBER,
  origem_ped     VARCHAR2(20),
  ori_dest       VARCHAR2(20),
  ac05           VARCHAR2(20),
  ac04           VARCHAR2(20),
  ac08           VARCHAR2(20),
  ac10           VARCHAR2(20),
  ac15           VARCHAR2(20),
  srp8           VARCHAR2(20),
  prp3           VARCHAR2(20),
  van            CHAR(3),
  id_arquivo     NUMBER,
  cnpj_filial    CHAR(14),
  cnpj_cliente   CHAR(14),
  id_produto     NUMBER,
  codigo_produto NUMBER,
  pedido         VARCHAR2(100),
  log            clob
);
INSERT INTO CENARIOS
  select (select null from dual)as id_cenario,
         a.origem_ped,
         b.ori_dest,
         c.ac05,
         d.ac04,
         e.ac08,
         f.ac10,
         g.ac15,
         h.srp8,
         i.prp3,
         (select '' from dual) as van,
         (select null from dual) as id_arquivo,
         (select '' from dual) as cnpj_filial,
         (select '' from dual) as cnpj_cliente,
         (select null from dual) as id_produto,
         (select null from dual) as codigo_produto,
         (select '' from dual) as pedido,
         (select '' from dual) as log         
    from ORIGEM_PEDIDO     A,
         ORIGEM_DESTINO    B,
         TIPO_CLIENTE_AC05 C,
         CAT_CLI_1004      D,
         CAT_CLI_1008      E,
         CAT_CLI_1010      F,
         CAT_CLI_1015      G,
         TIPO_PRODUTO_SRP8 H,
         PROMOCAO          I
   where a.seq = b.seq
     and b.seq = c.seq
     and c.seq = d.seq
     and d.seq = e.seq
     and e.seq = f.seq
     and f.seq = g.seq
     and g.seq = h.seq
     and h.seq = i.seq
   order by a.origem_ped,
            b.ori_dest,
            c.ac05,
            d.ac04,
            e.ac08,
            f.ac10,
            g.ac15,
            i.prp3,
            h.srp8;
commit;
------------------------------------------------------------------------------------------------------------------------

DELETE FROM CENARIOS 
WHERE ORIGEM_PED IN ('EUSE = ORA','EUSE = ORR','EUSE = ORG','EUSE = PRP','EUSE = MPR');

DELETE FROM  CENARIOS
 WHERE SRP8 IN ('V','Z','Y')
   AND AC05 = 'AC05 <> DRO'; 
   
DELETE FROM  CENARIOS
 WHERE SRP8 IN ('V','Z','Y')
   AND PRP3 = 'PRP3 <> AA'; 

DELETE FROM CENARIOS
WHERE AC05 = 'AC05 = DRO'
 AND ORIGEM_PED IN ( 'EUSE = CTC | PTC' , 'EUSE = MPE');
 
DELETE FROM CENARIOS
WHERE ORIGEM_PED = 'EUSE = PBM'
AND ORI_DEST IN ('MG - MG','GO - RJ','PR - SC');

DELETE FROM CENARIOS
WHERE ORIGEM_PED = 'EUSE = PBM'
AND SRP8 NOT IN ('C','L')

DELETE FROM CENARIOS
WHERE ORIGEM_PED = 'EUSE = MPE'
AND ORI_DEST NOT IN ('SP - SP','PR - PR','PR - SC');

COMMIT; 

------------------------------------------------------------------------------------------------------------------------

update cenarios set id_cenario = rownum;
commit;
alter table CENARIOS add constraint pk_cen1 primary key(ID_CENARIO);
update CENARIOS
   set van            = null,
       id_arquivo     = null,
       cnpj_filial    = null,
       cnpj_cliente   = null,
       id_produto     = null,
       codigo_produto = null,
       pedido = null,
       log = null ;
       
commit;

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------



---ROTINA CRIA CENARIOS E POPULA IDs 

-- Created on 23/12/2015 by DSALES 
DECLARE
  V_LINHA_ATUAL VARCHAR2(200) := ' ';
  V_PROX_LINHA  VARCHAR2(200) := ' ';
  V_ID_ARQUIVO  NUMBER := 0;
  V_VAN         VARCHAR2(3);
  V_FILIAL      VARCHAR2(14);
  V_ORIGEM_PED  VARCHAR2(20);
  V_ESTADO      VARCHAR2(10);
  V_ID_MIN      NUMBER := 0;
  V_ID_MAX      NUMBER := 0;
  V_ID_PRODUTO  NUMBER := 0;

BEGIN
  SELECT 1 INTO V_ID_ARQUIVO FROM DUAL;
  SELECT 1 INTO V_ID_PRODUTO FROM DUAL;
  SELECT 1 INTO V_ID_MIN FROM DUAL;
  SELECT MAX(ID_CENARIO) INTO V_ID_MAX FROM CENARIOS;

  FOR CENARIO IN (SELECT * FROM CENARIOS /*WHERE ID_CENARIO < 1000*/
                  ) LOOP
  
    V_VAN := CASE
               WHEN CENARIO.ORIGEM_PED = 'EUSE = HRY' THEN
                504
               ELSE
                CASE
                  WHEN CENARIO.ORIGEM_PED = 'EUSE = ZHR' THEN
                   540
                  ELSE
                   CASE
                     WHEN CENARIO.ORIGEM_PED = 'EUSE = ZHR (MISTO)' THEN
                      517
                     ELSE
                      CASE
                        WHEN CENARIO.ORIGEM_PED = 'EUSE = PBM' THEN
                         508
                        ELSE
                         CASE
                           WHEN CENARIO.ORIGEM_PED = 'EUSE = MPE' THEN
                            531
                           ELSE
                            CASE
                              WHEN CENARIO.ORIGEM_PED = 'EUSE = CTC | PTC' THEN
                               529
                              ELSE
                               NULL
                            END
                         END
                      END
                   END
                END
             END;
  
    SELECT DECODE(A.ORI_DEST,
                  'GO - GO',
                  'GO',
                  'GO - SP',
                  'SP',
                  'GO - RJ',
                  'RJ',
                  'MG - MG',
                  'MG',
                  'PR - PR',
                  'PR',
                  'PR - SC',
                  'SC',
                  'RJ - RJ',
                  'RJ',
                  'SP - SP',
                  'SP',
                  'DF - DF',
                  'DF'),
           DECODE(A.ORI_DEST,
                  'GO - GO',
                  '05651966000102',
                  'GO - SP',
                  '05651966000102',
                  'GO - RJ',
                  '05651966000102',
                  'MG - MG',
                  '05651966000617',
                  'PR - PR',
                  '05651966001184',
                  'PR - SC',
                  '05651966001184',
                  'RJ - RJ',
                  '05651966000960',
                  'SP - SP',
                  '05651966000455',
                  'DF - DF',
                  '05651966001265')
      INTO V_ESTADO, V_FILIAL
      FROM ORIGEM_DESTINO A
     WHERE A.ORI_DEST = CENARIO.ORI_DEST;
  
    UPDATE CENARIOS A
       SET A.VAN = V_VAN, A.CNPJ_FILIAL = V_FILIAL
     WHERE CENARIO.ID_CENARIO = A.ID_CENARIO;
    COMMIT;
  
    IF CENARIO.ID_CENARIO = V_ID_MIN OR CENARIO.ID_CENARIO = V_ID_MAX THEN
      SELECT A.ORIGEM_PED || A.ORI_DEST || A.AC05 || A.AC04 || A.AC08 ||
             A.AC10 || A.AC15
        INTO V_PROX_LINHA
        FROM CENARIOS A
       WHERE A.ID_CENARIO = CENARIO.ID_CENARIO;
    
    ELSE
      SELECT A.ORIGEM_PED || A.ORI_DEST || A.AC05 || A.AC04 || A.AC08 ||
             A.AC10 || A.AC15
        INTO V_PROX_LINHA
        FROM CENARIOS A
       WHERE A.ID_CENARIO = CENARIO.ID_CENARIO + 1;
    END IF;
    V_LINHA_ATUAL := CENARIO.ORIGEM_PED || CENARIO.ORI_DEST || CENARIO.AC05 ||
                     CENARIO.AC04 || CENARIO.AC08 || CENARIO.AC10 ||
                     CENARIO.AC15;
  
    --ID_ARQUIVO E ID_PRODUTO
    IF V_PROX_LINHA = V_LINHA_ATUAL THEN
    
      UPDATE CENARIOS A
         SET A.ID_ARQUIVO = V_ID_ARQUIVO, A.ID_PRODUTO = V_ID_PRODUTO
       WHERE CENARIO.ID_CENARIO = A.ID_CENARIO;
      COMMIT;
      V_ID_PRODUTO := V_ID_PRODUTO + 1;
    
    ELSE
      UPDATE CENARIOS A
         SET A.ID_ARQUIVO = V_ID_ARQUIVO, A.ID_PRODUTO = V_ID_PRODUTO
       WHERE CENARIO.ID_CENARIO = A.ID_CENARIO;
      COMMIT;
      V_ID_ARQUIVO := V_ID_ARQUIVO + 1;
      SELECT 1 INTO V_ID_PRODUTO FROM DUAL;
    
    END IF;
   
  END LOOP;
  COMMIT;
END;

-------------------------------

--Parte II - insere os produtos 
DECLARE

  V_PRP3    VARCHAR2(2000);
  V_PRODUTO NUMBER := 0;

BEGIN

  SELECT 1 INTO V_PRP3 FROM DUAL;

  FOR CENARIO IN (SELECT * FROM CENARIOS) LOOP
  
    IF CENARIO.PRP3 = 'PRP3 = AA' THEN
      SELECT 'AA' INTO V_PRP3 FROM DUAL;
    ELSE
      SELECT '00,08,16,18,23,40,41,43,44,51,57,60,69,75,82,85,D01,D05,D30,D31,D41,D54,D74,D99,F01,F08,F14,
             F19,F31,F34,F40,F59,F64,F66,F72,F87,F94,F97,F99,02,12,14,21,25,32,36,47,49,52,64,65,72,77,84,
             91,D10,D14,D22,D28,D39,D52,D55,D57,D59,D62,D69,D73,D77,D81,D84,D88,D89,D91,D95,F10,F42,F44,
             F60,F68,F70,F75,F76,F85,F92,F95,04,13,17,26,42,48,54,56,61,62,63,70,79,98,D08,D40,D42,D44,D47,
             D60,D68,D94,F02,F07,F18,F20,F22,F33,F38,F52,F53,F56,F62,03,20,27,39,50,58,67,73,89,90,D06,D21,
             D36,D46,D49,D51,D75,D96,F06,F12,F23,F24,F30,F32,F35,F49,F65,F71,F73,F74,F79,F83,F96,01,19,28,
             29,31,34,45,53,76,78,83,93,95,96,D02,D03,D07,D11,D13,D17,D26,D29,D35,D37,D43,D45,D48,D56,D58,
             D66,D79,D82,D87,F13,F26,F39,F78,F80,F82,F89,F90,F91,F93,07,10,30,35,37,46,55,68,92,D12,D15,D19,
             D25,D32,D33,D50,D53,D64,D67,D71,D85,D97,F03,F09,F17,F21,F29,F41,F43,F46,F50,F54,F55,F63,F67,
             F86,05,06,09,11,15,24,33,38,59,71,74,81,87,88,94,D04,D18,D20,D24,D27,D38,D78,D83,D90,D93,F04,
             F05,F11,F25,F36,F45,F47,F51,F84,F98,22,66,80,86,97,99,D09,D16,D23,D34,D61,D63,D65,D70,D72,D76,
             D80,D86,D92,D98,F15,F16,F27,F28,F37,F48,F57,F58,F61,F69,F77,F81,F88'
        INTO V_PRP3
        FROM DUAL;
    END IF;
  
    --SELECIONA PRODUTOS
    BEGIN
      SELECT PROD.PRODUTO
        INTO V_PRODUTO
        FROM (SELECT TO_NUMBER(TRIM(A.LITM)) AS PRODUTO
                FROM produtos_teste_liberados A
               WHERE INSTR(V_PRP3, TRIM(A.PRP3)) > 0
                 AND TRIM(A.SRP8) = TRIM(CENARIO.SRP8)
               ORDER BY DBMS_RANDOM.value) PROD
       WHERE ROWNUM = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_PRODUTO := 0;
    END;
  
    --ATUALIZA NA TABELA 
    UPDATE CENARIOS A
       SET A.CODIGO_PRODUTO = V_PRODUTO
     WHERE A.ID_CENARIO = CENARIO.ID_CENARIO;
    COMMIT;
  END LOOP;
END;
--------------------------------------

--PARTE III - INSERE OS CLIENTES
DECLARE
  V_AC05          VARCHAR2(200);
  V_AC04          VARCHAR2(200);
  V_AC08          VARCHAR2(200);
  V_AC10          VARCHAR2(200);
  V_AC15          VARCHAR2(1000);
  V_PRP3          VARCHAR2(2000);
  V_CLIENTE_ATUAL VARCHAR2(20);
  V_CLIENTE_PROX  VARCHAR2(20);
  V_ESTADO        VARCHAR2(10);

BEGIN

  SELECT 1 INTO V_AC04 FROM DUAL;
  SELECT 1 INTO V_AC05 FROM DUAL;
  SELECT 1 INTO V_AC08 FROM DUAL;
  SELECT 1 INTO V_AC10 FROM DUAL;
  SELECT 1 INTO V_AC15 FROM DUAL;
  SELECT 1 INTO V_PRP3 FROM DUAL;

  FOR CENARIO IN (SELECT * FROM CENARIOS) LOOP
  
    IF CENARIO.AC04 = '1004 = AA' THEN
      SELECT 'AA' INTO V_AC04 FROM DUAL;
    ELSE
      SELECT 'A01,A51,A61,A71,A81,A91,A92,B81,B91,B92,T10,T20,T30,T90'
        INTO V_AC04
        FROM DUAL;
    END IF;
  
    IF CENARIO.AC05 = 'AC05 = DRO' THEN
      SELECT 'DRO' INTO V_AC05 FROM DUAL;
    ELSE
      SELECT 'DIF' INTO V_AC05 FROM DUAL;
    END IF;
  
    IF CENARIO.AC08 = '1008 = AA' THEN
      SELECT 'AA' INTO V_AC08 FROM DUAL;
    ELSE
      SELECT '0MI,CB1,CB3,CB6,CG2,CG3,CO2,CO3,CO4,CR2,CR3,CR4,CU1,CU2'
        INTO V_AC08
        FROM DUAL;
    END IF;
  
    IF CENARIO.AC10 = '1010 = AA' THEN
      SELECT 'AA' INTO V_AC10 FROM DUAL;
    ELSE
      SELECT 'CE6,EF5,EF8,EF3,CE0,EF9,EF7,CE1,EF1,EF4,CE2,EF6,EF2'
        INTO V_AC10
        FROM DUAL;
    END IF;
  
    IF CENARIO.AC15 = '1015 = ANN' THEN
      SELECT 'ANN' INTO V_AC15 FROM DUAL;
    ELSE
      IF CENARIO.AC15 = '1015 = 7' THEN
        SELECT '147,167,187,302,307,357,397,403,404,507,607,707,800,902,905,906,907,908,909'
          INTO V_AC15
          FROM DUAL;
      ELSE
        SELECT '100,260,261,262,263,264,265,266,267,268,269,270,271,328,349,353,355,358,359,360,383,385,387,389,393,395,398,399,402,414,422,423,432,434,435,436,437,438,439,440,441,443,444,446,449,450,500,501,502,514,516,534,560,621,628,634,635,642,649,712,714,715,716,721,728,735,741,749,760,761,763,793,821,828,832,841,842,843,848,849,860,861,862,864,890,900,912,913,914,915,916,918,921,923,927,929,934,935,938,939,941,942,943,944,949,950,960,961,962,965,966,967,970,971,972,975,998,999,O70'
          INTO V_AC15
          FROM DUAL;
      END IF;
    END IF;
  
    IF CENARIO.PRP3 = 'PRP3 = AA' THEN
      SELECT 'AA' INTO V_PRP3 FROM DUAL;
    ELSE
      SELECT '00,08,16,18,23,40,41,43,44,51,57,60,69,75,82,85,D01,D05,D30,D31,D41,D54,D74,D99,F01,F08,F14,
             F19,F31,F34,F40,F59,F64,F66,F72,F87,F94,F97,F99,02,12,14,21,25,32,36,47,49,52,64,65,72,77,84,
             91,D10,D14,D22,D28,D39,D52,D55,D57,D59,D62,D69,D73,D77,D81,D84,D88,D89,D91,D95,F10,F42,F44,
             F60,F68,F70,F75,F76,F85,F92,F95,04,13,17,26,42,48,54,56,61,62,63,70,79,98,D08,D40,D42,D44,D47,
             D60,D68,D94,F02,F07,F18,F20,F22,F33,F38,F52,F53,F56,F62,03,20,27,39,50,58,67,73,89,90,D06,D21,
             D36,D46,D49,D51,D75,D96,F06,F12,F23,F24,F30,F32,F35,F49,F65,F71,F73,F74,F79,F83,F96,01,19,28,
             29,31,34,45,53,76,78,83,93,95,96,D02,D03,D07,D11,D13,D17,D26,D29,D35,D37,D43,D45,D48,D56,D58,
             D66,D79,D82,D87,F13,F26,F39,F78,F80,F82,F89,F90,F91,F93,07,10,30,35,37,46,55,68,92,D12,D15,D19,
             D25,D32,D33,D50,D53,D64,D67,D71,D85,D97,F03,F09,F17,F21,F29,F41,F43,F46,F50,F54,F55,F63,F67,
             F86,05,06,09,11,15,24,33,38,59,71,74,81,87,88,94,D04,D18,D20,D24,D27,D38,D78,D83,D90,D93,F04,
             F05,F11,F25,F36,F45,F47,F51,F84,F98,22,66,80,86,97,99,D09,D16,D23,D34,D61,D63,D65,D70,D72,D76,
             D80,D86,D92,D98,F15,F16,F27,F28,F37,F48,F57,F58,F61,F69,F77,F81,F88'
        INTO V_PRP3
        FROM DUAL;
    END IF;
  
    SELECT DECODE(A.ORI_DEST,
                  'GO - GO',
                  'GO',
                  'GO - SP',
                  'SP',
                  'GO - RJ',
                  'RJ',
                  'MG - MG',
                  'MG',
                  'PR - PR',
                  'PR',
                  'PR - SC',
                  'SC',
                  'RJ - RJ',
                  'RJ',
                  'SP - SP',
                  'SP',
                  'DF - DF',
                  'DF')
      INTO V_ESTADO
      FROM ORIGEM_DESTINO A
     WHERE A.ORI_DEST = CENARIO.ORI_DEST;
  
    ---CLIENTE 
    BEGIN
      SELECT CLI.CLIENTE
        INTO V_CLIENTE_PROX
        FROM (SELECT A.DB_CLI_CGCMF AS CLIENTE
                FROM CLIENTE_TESTE_LIBERADOS A
               WHERE A.DB_CLI_ESTADO = V_ESTADO
                 AND INSTR(V_AC04, A.AT1004) > 0
                 AND INSTR(V_AC05, A.AT1005) > 0
                 AND INSTR(V_AC08, A.AT1008) > 0
                 AND INSTR(V_AC10, A.AT1010) > 0
                 AND INSTR(V_AC15, A.AT1015) > 0
               ORDER BY DBMS_RANDOM.value) CLI
       WHERE ROWNUM = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_CLIENTE_PROX := 'NAO ENCONTROU!';
    END;
  
    --ATUALIZA NA TABELA 
    UPDATE CENARIOS A
       SET A.CNPJ_CLIENTE = V_CLIENTE_PROX
     WHERE A.ID_CENARIO = CENARIO.ID_CENARIO
       AND A.ID_ARQUIVO = CENARIO.ID_ARQUIVO;
    COMMIT;
  END LOOP;
END;
