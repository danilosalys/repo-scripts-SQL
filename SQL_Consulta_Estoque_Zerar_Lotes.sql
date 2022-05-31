SELECT IMLITM,
       IVCITM,
       IMDSC1,
       LILOCN,
       LILOTN,
       LIPQOH,
       LIHCOM,
       ((LIPQOH - LIHCOM) * (-1)) AJUSTE       
      -- (LIPQOH - LIHCOM) TOTAL_ESTOQUE
  FROM QADTA.F4101, QADTA.F41021 , QADTA.F4104
 WHERE IMLITM IN ('10008', '10040', '10065', '10083', '10084', '10086', '10088',
        '10116', '10125', '10130', '10135', '10140', '10232', '10239',
        '10242', '10338', '10344', '10357', '10426', '10445', '10460',
        '10538', '10539', '10602', '10607', '10730', '10847', '10876',
        '11073', '11256', '11324', '11325', '11326', '11346', '11458',
        '11464', '11539', '11546', '11547', '11556', '11616', '11631',
        '11650', '11651', '11652', '11653', '11663', '11674', '11678',
        '11778', '11784', '11863', '11930', '11946', '11953', '11992',
        '12010', '12054', '12095', '12096', '12216', '12260', '12261',
        '12280', '12305', '12330', '12350', '12354', '12367', '12391',
        '12505', '12506', '12630', '12696', '12697', '12713', '12742',
        '12840', '12935', '13025', '13096', '13097', '13098', '13125',
        '13240', '13241', '13305', '13345', '13346', '13347', '13348',
        '13349', '13352', '13353', '13414', '13495', '13496', '13497',
        '13547', '13589', '13720', '13800', '13999', '14079', '14256',
        '14368', '14577', '14578', '14579', '14580', '14837', '14838',
        '14839', '14964', '15106', '15302', '15519', '15520', '15521',
        '15522', '15525', '15526', '17108', '25978', '25979', '27407',
        '27408', '27409', '27410', '27596', '27599', '27601', '27747',
        '27865', '27866', '27871', '28709', '29088', '29089', '29090',
        '29828', '29981', '30018', '30588', '30589', '30636', '31685',
        '33616', '34068', '34069', '34070', '34897', '34970', '34971',
        '34975', '35359', '36480', '36752', '36948', '36949', '37985',
        '37987', '37988', '38185', '38187'
       )
   AND IMITM = LIITM
   AND LIITM = IVITM
   AND IVXRT = 'VN'
   AND LIMCU = '    DIFARCAT'
   AND (LIPQOH - LIHCOM) > 0
   AND TRIM(LILOCN) NOT IN
       ('ENTRADA', 'DEVOL', 'VENCIDO', 'AVARIA', 'RECOLHE')
       
       
       
    /*   SELECT * FROM QADTA.F4104
       WHERE IVXRT = 'VN'*/