 --- LIPQOH - qtde. em estoque.
--- LIHCOM - hard comiit reserva confirmada.
--- LIPCOM - soft commit reserva n�o confirmada.
--- Alterar LIPQOH (LIPQOH - (LIHCOM + LIPCOM)).
--- Copiar linha v�lida com outro lotes. N�o esquecer de zera LIHCOM e LIPCOM.
--- Criar novo lote atrav�s da transa��o P4108.


select A.*
  from crpdta.f41021 A
 where liitm = 31475
   and limcu = '    DIFARCAT' 
   and lilocn != 'ENTRADA' for update