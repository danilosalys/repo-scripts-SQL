 SELECT * FROM 
(SELECT DB_EDILD_NOMEARQ, DB_EDIP_PROJETO, DB_EDIP_VAN ,      
      CASE           
            WHEN DB_EDIP_VAN  != 501 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,3) = 'PHL'                                      
                     THEN 'ERRO,ARQUIVO NAO PERTENCE A VAN'||DB_EDIP_VAN
                     
            WHEN DB_EDIP_VAN  != 503 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) IN ('PEDPRO', 'PEDMCC', 'PEDNIV')            
                     THEN ''
                     
            WHEN DB_EDIP_VAN  != 504 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) IN ('PEDEUR', 'PEDLAB', 'PEDFAR')                     
                     THEN ''
                     
            WHEN DB_EDIP_VAN  != 505 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,3) IN ('BOE', 'PFI', 'GSK','SDZ','NOV','MED')   
                     THEN ''
                     
            WHEN DB_EDIP_VAN  NOT IN (506,509,510,513,514,515) 
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,6) = 'PEDIDO'
                 AND LENGTH(TRIM(DB_EDILD_NOMEARQ)) = 36 
                     THEN ''
            
            WHEN DB_EDIP_VAN  != 507
                 AND SUBSTR(DB_EDILD_NOMEARQ,4,3) = 'PEDWYE'
                     THEN 'ERRO, PROJETO DE OUTRA VAN'
                     
            
            WHEN DB_EDIP_VAN  != 508
                 AND SUBSTR(DB_EDILD_NOMEARQ,1,2) = 'SP'
                     THEN 'ERRO, PROJETO DE OUTRA VAN' 
                     
                      END CONFERENCIA
      
      
   FROM DB_EDI_LOTE_DISTR B, DB_EDI_PEDIDO C
 WHERE B.DB_EDILD_SEQ = C.DB_EDIP_LOTE)     
     WHERE CONFERENCIA = 'ERRO, PROJETO DE OUTRA VAN'  