 --- LIPQOH - qtde. em estoque.
--- LIHCOM - hard comiit reserva confirmada.
--- LIPCOM - soft commit reserva não confirmada.
--- Alterar LIPQOH (LIPQOH - (LIHCOM + LIPCOM)).
--- Copiar linha válida com outro lotes. Não esquecer de zera LIHCOM e LIPCOM.
--- Criar novo lote através da transação P4108.


select A.*
  from crpdta.f41021 A
 where liitm = 31475
   and limcu = '    DIFARCAT' 
   and lilocn != 'ENTRADA' for update