#INCLUDE "RWMAKE.CH" 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPORTSEL   บ Autor ณ Adriano Novachaelley Data ณ  23/11/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ                                                             ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  RJU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

/*O ponto de Entrada: PEF065 permite adicionar campos no Cabe็alho da cota็ใo e nos Itens da cota็ใo, 
no Portal do Fornecedor. O array deverแ ser montado com base na estrutura do WebServices 
e com os campos que serใo adicionados pelo usuแrio.                    
*/

User Function PEF065()
                       
Local cParam  := PARAMIXB[1]
Local aReturn := {}  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

Do Case
   Case cParam == 1 // Cabecalho
   
        //Campos padroes
       aAdd( aReturn, { "QUOTEID",		"D" } )
       aAdd( aReturn, { "PROPOSALID",	"D" } )
       aAdd( aReturn, { "SUPPLIER",		"D" } )
       aAdd( aReturn, { "REGISTERDATE",	"D" } )
       aAdd( aReturn,   "CONTACT"  )
       aAdd( aReturn, { "PAYMENTPLANCODE","N", {"BRWPAYMENTPLAN", ;
                                                 {"CPAYMENTPLANCODE", "CPAYMENTPLANCODE" } ;
                                                 }, ;
                                                 {"CPAYMENTPLANCODE", "CDESCRIPTIONPAYMENTPLAN" } } )
       //Campo Adicional
//        aAdd( aReturn, "C8_MSG" ) 
        
   Case cParam == 2 //Itens  
   
        //Campos padroes
        aAdd( aReturn, { "PROPOSALID",	"N", 0, .F. } )
        aAdd( aReturn, { "SEQUENTIALID",	"N", 0, .F. } )
        aAdd( aReturn, { "PRODUCTCODE",	"N", 0, .F. } )
        aAdd( aReturn, { "DESCRIPTIONPRODUCT", "N", 0, .F. } )
        aAdd( aReturn, { "MEASUREUNIT",	"N", 2, .F. } )
        aAdd( aReturn, { "QUANTITY",		"N", 3 } )
        aAdd( aReturn, { "UNITPRICE",	"N", 9, .T. } )
        aAdd( aReturn, { "TAXRATE",		"N", 5 } )
//        aAdd( aReturn, { "DISCOUNTPERCENT",	"N", 3 } )  
        aAdd( aReturn, { "TOTALVALUE",	"N", 0, .T. } )  
		
        //Campo Adicional
//        aAdd( aReturn,  "C8_PRAZO")         
        aAdd( aReturn,  "C8_VALFRE")        
//        aAdd( aReturn,  "C8_TPFRETE")        
        aAdd( aReturn,  "C8_DESPESA")                
        aAdd( aReturn,  "C8_PICM")                
        
EndCase

Return aReturn