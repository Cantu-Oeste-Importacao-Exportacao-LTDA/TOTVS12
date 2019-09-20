#include "rwmake.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F440BASE  �Autor  �Microsiga           � Data �  05/25/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Altera a base de comissao e comissao com o desconto fin    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F440BASE()
Local _Desc:= 0
Local _aVend := PARAMIXB 
Local _Prefixo := SE1->E1_PREFIXO
Local _Num     := SE1->E1_NUM

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

If AllTrim(Upper(GetMV("MV_ABATFIN"))) == "S" 

   dbSelectArea("SF2")
   dbSetOrder(1)
   If dbSeek(xFilial("SF2") + _Num + _Prefixo)
      _Desc:= SF2->F2_DESVEN
   Endif
   If _Desc > 0
      For X:= 1 to Len(_aVend)
         _aVend[X,2] := _aVend[X,2] - (_aVend[X,2] * _Desc / 100)  // base comissao
         _aVend[X,3] := _aVend[X,3] - (_aVend[X,3] * _Desc / 100)  // base icms
     //    _aVend[X,4] :=                                          //
         _aVend[X,5] := _aVend[X,3] * _aVend[X,7] / 100              // comissao
     //    _aVend[X,6] := 
     //    _aVend[X,7] :=                                          // % da comissao

      Next X
   Endif   
Endif   


Return _aVend



/*
User Function F440BASE(aVend,nValor,cAliasTMP)
Local _Desc:= SF2->F2_DESVEN
Local aVendXXX := aVend                           
If AllTrim(Upper(GetMV("MV_ABATCOM"))) = "S"      
   If _Desc > 0
      For X:= 1 to Len(aVet)
         aVend[X,2] := aVend[X,2] - (aVend[X,2] * _Desc / 100) 
        // aVend[X,3] := aVend[X,3] - (aVend[X,3] * _Desc / 100)
        nValor := nValor - (nValor * _Desc / 100)
      Next X
   Endif   
Endif

Return aVendXXX*/