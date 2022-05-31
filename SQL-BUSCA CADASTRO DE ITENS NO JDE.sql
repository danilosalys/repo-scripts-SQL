select imlitm, imdsc1, ibshcm, ibstkt, ibvend, abalph, min(ivcitm),lilocn,  min(lilotn)
  from qadta.f4101, qadta.f4102, qadta.f41021, qadta.f0101, qadta.f4104
 where imitm = ibitm
   and ibmcu = '    DIFARCAT'
   and ibvend in (5003,5052,6351, 5355,5786,8738,6376,6261,6391,5333,7286,8772)
   and ibprp5 in ('MED', 'PER')
   and ibsrp8 not in ('V', 'Y', 'Z') -- Varejo
   and ibstkt != 'O'
   and imitm = liitm
   and limcu = '    DIFARCAT'
   and lilots = ' '
   and lilotn != ' '
   and ibvend = aban8
   and ivxrt = 'VN'
   and ivlitm = iblitm
   and ivexdj > 112062
group by imlitm, imdsc1, ibshcm, ibstkt, ibvend,lilocn, abalph