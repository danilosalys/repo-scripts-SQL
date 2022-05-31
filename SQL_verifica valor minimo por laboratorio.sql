 select drky, drdl01 vlr_min, drsphd fatur, aban8 cod_fornec, abalph fornec
  from crpdta.f0005, crpdta.f0101
 where drsy = '55'
   and drrt = 'DA'
   and drsphd != '1'
   and drky like 'ZHR%'
   and substr(trim(drky),4,4) = aban8
