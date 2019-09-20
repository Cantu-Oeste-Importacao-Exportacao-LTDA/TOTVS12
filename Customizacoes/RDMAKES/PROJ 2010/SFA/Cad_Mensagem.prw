#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MSGSFA   � Autor � Rafael Parma       � Data �  25/05/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Gerenciador de mensagens SFACRM                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8 CANTU                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

*---------------------*
User Function MSGSFA()  
*---------------------*
  
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cPrefix := ""

Private cCadastro := "Cadastro de Mensagens"
Private aCores := {}

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := { {"Pesquisar"  ,"AxPesqui" ,0 ,1} ,;
             		 {"Visualizar" ,"AxVisual" ,0 ,2} ,;
                     {"Incluir"    ,"AxInclui" ,0 ,3} ,;
                     {"Alterar"    ,"AxAltera" ,0 ,4} ,;
                     {"Excluir"    ,"AxDeleta" ,0 ,5} }

//���������������������������������������������������������������������Ŀ
//� Monta array com os campos para o Browse                             �
//�����������������������������������������������������������������������
Private cString := GetMv("MV_TBLMSG",,"")
Private aCampos := {}
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

If Empty(cString)
	MsgAlert("Verifique o parametro MV_TBLMSG, alias de mensagens nao configurado")
	Return .T.
Endif

cPrefix := Right(cString, 2) + "_"
aCampos := { {"Codigo"  , cPrefix+"CODMSG" , "@!"} ,;
             {"Vendedor", cPrefix+"CODVEND", "@!"} ,;
             {"Data"    , cPrefix+"DATAMSG", "@!"} ,;
             {"Vigencia", cPrefix+"DATAVIG", "@!"} ,;
             {"Origem"  , cPrefix+"ORIMSG" , "@!"} ,;
             {"Mensagem", cPrefix+"MENSAGE", "@!"} }

dbSelectArea(cString)
dbSetOrder(1)
dbSelectArea(cString)

aADD(aCores, { cPrefix+'ORIMSG == "1" ' , 'BR_AMARELO'  })
aADD(aCores, { cPrefix+'ORIMSG == "2" .AND. '+cPrefix+'LIDA <> "1" ' , 'BR_VERDE'     })
aADD(aCores, { cPrefix+'ORIMSG == "2" .AND. '+cPrefix+'LIDA == "1" ' , 'BR_VERMELHO'  })


mBrowse( 6,1,22,75,cString,aCampos,,,,, aCores)

Return