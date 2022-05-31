--efetivaçao
select CabEfe.sadocd as NumCot,
       CabEfe.saukid as UkidEfe,
       CabEfe.savr01 as PedMercEfe,
       CabEfe.sadoco as PedJDEEFe,
       CabCot.sadoco as PedJDECot,
       PedEfe.sdlitm as ProdutoEfe,
       PedEfe.sdlnid as "LNID EFE",
       PedCot.Sdlitm as ProdutoCot,
       PedCot.Sdlnid as "LNID COT",
       PedEfe.Sdogno as "LNID COT EFE",
       PedEfe.Sdoorn as "NUM COT EFE"
from crpdta.f5547011 CabEfe, crpdta.f5547012 Detefe, crpdta.f4211 PedEfe,
     crpdta.f5547011 CabCot, crpdta.f5547012 DetCot, crpdta.f4211 PedCot
        where CabEfe.sadoco IN (109532)
          and CabEfe.saukid = Detefe.sbukid
          and CabEfe.sadoco = PedEfe.sddoco
          and PedEfe.sdlitm = Detefe.sblitm
          and CabCot.saukid = DetCot.sbukid
          and CabCot.sadoco = PedCot.sddoco
          and PedCot.sdlitm = DetCot.sblitm
          and CabEfe.Sadocd = CabCot.Sadocd
        --  and PedEfe.Sdlitm = PedCot.Sdlitm
          and DetEfe.Sblitm = DetCot.Sblitm
          and CabCot.Sadcto = 'SQ'