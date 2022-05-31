--BD: DC09
--EXPORTAR O PEDIDO PARA O JDE
DECLARE
  VRETORNO1 VARCHAR2(100);
  VRETORNO2 VARCHAR2(100);
BEGIN
  mercanet_hml.MERCP_CONCORRENTE_EXPORT(VRETORNO1, VRETORNO2);
  COMMIT;
END;

------------------------------------------------------------------------------
--BD: DC01
--Reprocessar
update CRPDTA.F5547011
   set saoorn = 'MERCANET',
       saedsp = ' ',
       saedbt = ' ',
       sadoco = 0,
       sadcto = 'VO',
       saexfn = ' ',
       saz55ori = 'MPE'
 where savr01 in ('80012457');


update CRPDTA.F5547012
   set   sbedsp = '', sbuom = 'UN'    
 where sbukid in (3001698);

--COPIAR O RESULTADO E EXECUTAR OS UPDATES

select 'update crpdta.f5547012 set sbedsp = '' ''' ||
        ',sbstdslpr = '  || 
        (select substr(trim(ivcitm),1,5) 
          from crpdta.f4102,  crpdta.f0005 a,  crpdta.f0005 b,   crpdta.f4104    
         where trim(ibmcu) = trim(a.drky)  
           and ibstkt != 'O' -- -Fixo
           and ibsrp1 = 'DIF'
           and a.drsy = '55'
           and a.drrt = 'OF'
           and a.drsphd = '1'
           and b.drsy = '41'
           and b.drrt = 'P5'
           and b.drsphd = '1'
           and trim(ibprp5) = trim(b.drky)
           and ivxrt = 'VN'
           and ivitm = ibitm
           and ivexdj >= TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000  
           and ivlitm = sblitm 
           and rownum = 1 )||   
        ',sbuprc = ' || (select substr(trim(ivcitm),6,8) * 100
          from crpdta.f4102,  crpdta.f0005 a,  crpdta.f0005 b,   crpdta.f4104    
         where trim(ibmcu) = trim(a.drky)  
           and ibstkt != 'O' -- -Fixo
           and ibsrp1 = 'DIF'
           and a.drsy = '55'
           and a.drrt = 'OF'
           and a.drsphd = '1'
           and b.drsy = '41'
           and b.drrt = 'P5'
           and b.drsphd = '1'
           and trim(ibprp5) = trim(b.drky)
           and ivxrt = 'VN'
           and ivitm = ibitm
           and ivexdj >= TO_CHAR(SYSDATE, 'YYYYDDD') - 1900000  
           and ivlitm = sblitm 
           and rownum = 1 ) || 
        ' where sbukid = ' || sbukid ||
        ' and sblitm = ''' ||  sblitm || '''' || ';'       
  from crpdta.f5547012         
 where sbukid in (3001698)


delete from CRPDTA.F5542456 where tgukid in (3001642);

------------------------------------------------------------------------------

--BD: DC09
--ATUALIZACAO INTERFACE PARA OFICIAIS DE PEDIDO

DECLARE
  VRETORNO VARCHAR2(100);
BEGIN
  mercanet_hml.MERCP_APIS_INTERFACE.MERCP_API_START (NULL, 30, VRETORNO);
  DBMS_OUTPUT.PUT_LINE('RETORNO: '||VRETORNO);
  COMMIT;
END;


