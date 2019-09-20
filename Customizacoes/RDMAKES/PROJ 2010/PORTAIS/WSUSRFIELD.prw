#INCLUDE "TOPCONN.CH"
#INCLUDE "rwmake.ch"   
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WSUSRFIELD� Autor � Adriano Novachaelley Data �  23/11/2010 ���
�������������������������������������������������������������������������͹��
���Descricao �  Este Ponto de Entrada tem por objetivo reconhecer os campos��
���          �  do sistema que n�o est�o configurados como padr�o no      ���
���          � Portal do Fornecedor.                                      ���
�������������������������������������������������������������������������͹��
���Uso       �  RJU                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function WSUSRFIELD( )
                           
//   

Local cAlias := PARAMIXB[1] //Nome da tabela
Local aCampos := {} //Array com os campos de usu�rio a serem retornados  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Do Case 
   Case cAlias == "SC8"
//        aAdd( aCampos,"C8_PRAZO")       
        aAdd( aCampos,"C8_VALFRE")      
        aAdd( aCampos,"C8_PICM")
     //   aAdd( aCampos,"C8_TPFRETE")
        aAdd( aCampos,"C8_DESPESA")        
EndCase 
 
Return (aCampos)