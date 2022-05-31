--- Olhar Entrada para ver se não ha qtde consumindo estoque e caso haja considerar essa qtde
--- LIPQOH - qtde. em estoque.
--- LIHCOM - hard comiit reserva confirmada.
--- LIPCOM - soft commit reserva não confirmada.
--- Alterar LIPQOH (LIPQOH - (LIHCOM + LIPCOM)).
--- Copiar linha válida com outro lotes. Não esquecer de zera LIHCOM e LIPCOM.
--- Criar novo lote através da transação P4108.

--CONSULTA NUMERO LONGO DO ITEM
  select imitm, imlitm
          from crpdta.f4101
         where imlitm = '26098'



SELECT A.*
  FROM crpdta.f41021 A
 WHERE liitm in (26538)
   AND limcu = '    DIFARCAT'
   AND lilocn != 'ENTRADA'
   AND lilocn != 'DEVOL'
   AND LILOTN != ' '
   FOR UPDATE;

--------------------------------------------------------------------

SELECT imlitm, A.*
  FROM crpdta.f41021 A, crpdta.f4101
 WHERE liitm in
       (9253, 9257, 9351, 9361, 9383, 9618, 9634, 9719, 10054, 10811, 2233, 2432, 2791, 2967, 3462, 3736, 4609, 4638, 5548, 5602,
        24505, 25755, 28060, 29319, 29541, 31734, 32637, 34781, 35435, 35708,
        10632, 10934, 1258)
   AND liitm = imitm
   AND limcu = '    DIFARCAT'
   AND lilocn != 'ENTRADA'
   AND lilocn != 'DEVOL'
--AND LILOTN in ('654394','654395','654396' )

-------------------------------------------------------


        
        
--------------------------------------------------------        
--Consulta os pedidos que contem os itens 
  select sdsoqs,sdlttr,sdnxtr,sdtorg,
         sdtrdj,sdlocn,sdlotn,a.*
  from crpdta.f4211 a
  where sdmcu = '    DIFARCAT'
  and sditm = 34188