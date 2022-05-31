--drop table numeros_gerados
--create table numeros_gerados (id_jogo number, id_seq number, numero number(15));
--alter table numeros_gerados add constraint uk_numero unique (id_jogo, numero);
truncate table numeros_gerados;

declare
  v_num    number := 0;
  v_existe number := 0;
  v_tipo   number := 6; --6:  Mega Sena --15: Lotofácil --5: Quina -- 6: Dupla Sena -- 50: Lotomania -- 7: Dia de Sorte
  v_qtde   number := 50; -- 60: Mega Sena -- 25: Lotofácil -- 80: Quina --50: Dupla Sena -- 99: Lotomania -- 31: Dia de Sorte 
  v_qtde_jogos number := 5;
  
  --select (27 / 4.50) from dual 
  
begin
 for h in 1.. v_qtde_jogos loop 
  for i in 1 .. v_tipo loop
  
    select round(dbms_random.value(1, v_qtde)) into v_num from dual;
    select count(1)
      into v_existe
      from numeros_gerados
     where numero = v_num
       and id_jogo = h;
    --dbms_output.put_line('ID_JOGO: '|| h || ' - SEQ: ' || i || ' - NUMERO: ' || v_num || case when v_existe = 0 then
    --                     ' - OK' else ' - DUPLICADO' end);
    while v_existe = 1 loop
      select round(dbms_random.value(1, v_qtde)) into v_num from dual;
      select count(1)
        into v_existe
        from numeros_gerados
       where numero = v_num
         and id_jogo = h;
   -- dbms_output.put_line('ID_JOGO: '|| h || ' - SEQ: ' || i || ' - NUMERO: ' || v_num || case when v_existe = 0 then
   --                      ' - OK' else ' - DUPLICADO' end);
    end loop;
    insert into numeros_gerados values (h,i,v_num);
    commit;
  
  end loop;
end loop; 
end;
/

select ID_JOGO, JOGOS, NUMEROS
  from (select id_jogo,
               REPLACE(RTRIM(XMLAGG(XMLELEMENT(e, numero || ' ') order by numero)
                             .extract('//text()'),
                             ','),
                       ' ',
                       CHR(9)) JOGOS,
               RTRIM(XMLAGG(XMLELEMENT(e, numero) order by numero)
                     .extract('//text()'),
                     ',') NUMEROS
          from numeros_gerados
         group by id_jogo) T1
/* where exists (select t2.numeros
          from num_sorteados T2
         where t1.numeros = t2.numeros)*/




