SELECT * FROM 
(SELECT DB_EDILD_NOMEARQ, DB_EDIP_PROJETO, DB_EDIP_VAN ,      
      CASE
            WHEN DB_EDIP_VAN  != 501 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,3) = 'PHL'                                      
                     THEN 'ERRO, PROJETO DE OUTRA VAN'
                     
            WHEN DB_EDIP_VAN  != 503 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) IN ('PEDPRO', 'PEDMCC', 'PEDNIV')            
                     THEN 'ERRO, PROJETO DE OUTRA VAN'
                     
            WHEN DB_EDIP_VAN  != 504 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) IN ('PEDEUR', 'PEDLAB', 'PEDFAR')                     
                     THEN 'ERRO, PROJETO DE OUTRA VAN'
                     
            WHEN DB_EDIP_VAN  != 505 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,3) IN ('BOE', 'PFI', 'GSK','SDZ','NOV','MED')   
                     THEN 'ERRO, PROJETO DE OUTRA VAN'
                     
            WHEN DB_EDIP_VAN  NOT IN (506,509,510,513,514,515) 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) = 'PEDIDO'
                 AND LENGTH(TRIM(DB_EDILD_NOMEARQ)) = 36 
                     THEN 'ERRO, PROJETO DE OUTRA VAN'
            
            WHEN DB_EDIP_VAN  != 507
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,3) = 'PEDWYE'
                     THEN 'ERRO, PROJETO DE OUTRA VAN'
                     
            
            WHEN DB_EDIP_VAN  != 508
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,2) = 'SP'
                     THEN 'ERRO, PROJETO DE OUTRA VAN'         
                              
            WHEN DB_EDIP_PROJETO = '03' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '03'                                     
                     THEN 'ERRO'  
                     
            WHEN DB_EDIP_PROJETO = '06' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '06'                                     
                     THEN 'ERRO'
                     
            WHEN DB_EDIP_PROJETO = '07' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '07'                                     
                     THEN 'ERRO'         
                     
            WHEN DB_EDIP_PROJETO = '09' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '09'                                     
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = '10' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '10'                                     
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = '11' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '11'                                     
                     THEN 'ERRO'
                     
            WHEN DB_EDIP_PROJETO = '19' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '19'                                     
                     THEN 'ERRO'
                              
            WHEN DB_EDIP_PROJETO = '23' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '23'                                     
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = '27' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '27'                                     
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = '30' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '30'                                     
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = '31' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '31'                                     
                     THEN 'ERRO'
                     
            WHEN DB_EDIP_PROJETO = '40' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '40'                                     
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = '50' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '50'                                     
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = '70' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '70'                                     
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = '80' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '80'                                     
                     THEN 'ERRO'
                        
            WHEN DB_EDIP_PROJETO = '90' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,2) != '90'                                     
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = 'BOE' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,3) != 'BOE'                                   
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = 'SDZ' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,3) != 'SDZ'                                   
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = 'PFI' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,3) != 'PFI'                                   
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = 'NOV' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,3) != 'NOV'                                   
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = 'GSK' 
                 AND DB_EDIP_VAN = 505
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,3) != 'GSK'                                   
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = 'MED' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,3) != 'MED'                                   
                     THEN 'ERRO'
                                       
            WHEN DB_EDIP_PROJETO = 'EUR' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDEUR'                                
                     THEN 'ERRO'
                     
            WHEN DB_EDIP_PROJETO = 'FAR' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDFAR'                                
                     THEN 'ERRO'
                     
            WHEN DB_EDIP_PROJETO = 'LAB' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDLAB'                                
                     THEN 'ERRO' 
            
            WHEN DB_EDIP_PROJETO = 'PRO' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDPRO'                                   
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = 'MCC' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDMCC'                                   
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = 'PFI' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,3) != 'PFI'                                   
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = 'NIV' 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDNIV'                                   
                     THEN 'ERRO'
                     
            WHEN DB_EDIP_PROJETO = 'GSK' 
                 AND DB_EDIP_VAN = 506
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDIDO'                                   
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = 'MSD'
                 AND DB_EDIP_VAN = 509 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDIDO'                                   
                     THEN 'ERRO'
                                          
            WHEN DB_EDIP_PROJETO = 'THR'
                 AND DB_EDIP_VAN = 510 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDIDO'                                   
                     THEN 'ERRO'
                     
            WHEN DB_EDIP_PROJETO = 'SER'
                 AND DB_EDIP_VAN = 513 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDIDO'                                   
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = 'ABT'
                 AND DB_EDIP_VAN = 514 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDIDO'                                   
                     THEN 'ERRO'
             
            WHEN DB_EDIP_PROJETO = 'FR'
                 AND DB_EDIP_VAN = 515 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDIDO'                                   
                     THEN 'ERRO'
             
            WHEN DB_EDIP_PROJETO = 'WYE'
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDWYE'                                   
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO IN ('19','27','23','24','28','30','31','33')
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,2) != 'SP'                                   
                     THEN 'ERRO'
             
            WHEN DB_EDIP_PROJETO = 'ems'
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDems'                                   
                     THEN 'ERRO'
            
            WHEN DB_EDIP_PROJETO = 'VAR'
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDVAR'                                   
                     THEN 'ERRO'        
            
            WHEN DB_EDIP_PROJETO = 'MTC'
                 AND LENGTH(TRIM(DB_EDILD_NOMEARQ)) = 46 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) != 'PEDIDO'                                   
                     THEN 'ERRO'         
      
      END CONFERENCIA
      
      
   FROM DB_EDI_LOTE_DISTR B, DB_EDI_PEDIDO C
 WHERE B.DB_EDILD_SEQ = C.DB_EDIP_LOTE)     
     WHERE CONFERENCIA = 'ERRO'  