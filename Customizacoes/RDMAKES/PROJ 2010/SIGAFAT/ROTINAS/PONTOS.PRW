
#Include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"   

User function GPMEDARR()      

Local nMeses  	:= 3
Local cVerbas 	:= ""  
Local cDataLim 	:= Space(6)  
Local nPos		:= 0       
Local dDataIni	:= Space(6)
Local dDataFim	:= Space(6)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())      

	If cEmpAnt=="50" .and. SRA->RA_FILIAL=="09" .and. SRA->RA_SINDICA=="14"    
		nMeses  := 3
		cVerbas := "105|107"
	Else 
		If cEmpAnt=="31" .and. SRA->RA_FILIAL=="07" .and. SRA->RA_SINDICA=="05"
			nMeses  := 3
			cVerbas := "105|107"
		Else 
			If cEmpAnt=="31" .and. SRA->RA_FILIAL=="03" .and. SRA->RA_SINDICA=="02"
				nMeses  := 6
				cVerbas := "*"    
			Else
				Return
			EndIf
		EndIf 
	EndIf 

	If Len(aAviso) == 0  
		For n:= 1 to Len(aFV) 
			Aadd(aAv,{aFV[n,1],aFV[n,2],aFV[n,3],aFV[n,4],aFV[n,5],aFV[n,6]})
		Next
		For n:= 1 to Len(aFP) 
			Aadd(aAv,{aFP[n,1],aFP[n,2],aFP[n,3],aFP[n,4],aFP[n,5],aFP[n,6]})
		Next
	EndIf

	For n:=1 to Len(aAviso)
		If (aAviso[n,1] $ cVerbas) .or. SubStr(cVerbas,1,1)=="*"   
			If SubStr(aAviso[n,4],5,2) < StrZero((nMeses+1),2,0)    
				cDataLim := Strzero(Val(SubStr(aAviso[n,4],1,4))-1,4,0)+StrZero((Val(SubStr(aAviso[n,4],5,2))+13-nMeses),2,0)								
			Else
				cDataLim := StrZero(Val(aAviso[n,4])+1-nMeses,6,0)
			EndIf
			aAviso[n,2]:=Str(nMeses)
			aAviso[n,3]:=cDataLim
			aAviso[n,8]:=Str(nMeses)    
			For y:=1 to Len(aAv)
				If aAv[y,1] == aAviso[n,1]	 
					If aAv[y,2] < cDataLim     
						aAV[y,3] := 0.00
						aAv[y,4] := 0.00
						aAV[y,5] := Space(1)
						aAv[y,6] := Ctod("")
					EndIf
				EndIf
			Next
		EndIf                                                                                                 
	Next                   

	If AllTrim(FunName())=="GPEA070" .or. AllTrim(FunName())=="GPEM030"
		dDataFim := SubStr(dTos(dDataRef),1,6)
		If SubStr(dDataFim,5,2) < StrZero((nMeses+1),2,0)    
			dDataIni := Strzero(Val(SubStr(dDataFim,1,4))-1,4,0)+StrZero((Val(SubStr(dDataFim,5,2))+13-nMeses),2,0)								
		Else
			dDataIni := StrZero(Val(dDataFim)+1-nMeses,6,0)
		EndIf
	Else
		dDataIni := aAviso[1,3]
		dDataFim := aAviso[1,4]
	EndIf


	For n:=1 to Len(aFerVen) // aFv
		If (aFerVen[n,1] $ cVerbas) .or. SubStr(cVerbas,1,1)=="*"	   
			aFerVen[n,2]:=Str(nMeses)
			aFerVen[n,3]:=dDataIni
			aFerVen[n,4]:=dDataFim
			aFerVen[n,8]:=Str(nMeses)   
			aFerVen[n,9]:=.t.  
			For y:=1 to Len(aFv)
				If aFv[y,1] == aFerVen[n,1]	
					aFv[y,2] := Space(6)
					aFv[y,3] := 0.00
					aFv[y,4] := 0.00
					aFv[y,5] := Space(1)
					aFv[y,6] := Ctod("")
				EndIf  
			Next   
			For X:=1 to Len(aAv)
				If aAv[x,1] == aFerVen[n,1]
					If aAv[x,2] >= dDataIni	 
						If (nPos := Ascan(aFv,{ |y| y[1] == aFerVen[n,1] .And. y[2] == Space(6) }) ) > 0
							aFv[nPos,2] := aAv[x,2]
							aFv[nPos,3] := aAv[x,3]
							aFv[nPos,4] := aAv[x,4]
							aFv[nPos,5] := aAv[x,5]
							aFv[nPos,6] := aAv[x,6]
						Else
	   						Aadd(aFv,{aAv[x,1],aAv[x,2],aAv[x,3],aAv[x,4],aAv[x,5],aAv[x,6]})
						EndIf
				    EndIf
				EndIf  
			Next   
		EndIf
	Next

	For n:=1 to Len(aFerPro) // aFp
		If (aFerPro[n,1] $ cVerbas) .or. SubStr(cVerbas,1,1)=="*"	   
			aFerPro[n,2]:=Str(nMeses)
			aFerPro[n,3]:=dDataIni
			aFerPro[n,4]:=dDataFim
			aFerPro[n,8]:=Str(nMeses)   
			For y:=1 to Len(aFp)
				If aFp[y,1] == aFerPro[n,1]	
					aFp[y,2] := Space(6)
					aFp[y,3] := 0.00
					aFp[y,4] := 0.00
					aFp[y,5] := Space(1)
					aFp[y,6] := Ctod("")
				EndIf  
			Next   
			For X:=1 to Len(aAv)
				If aAv[x,1] == aFerPro[n,1]
					If aAv[x,2] >= dDataIni	 
						If (nPos := Ascan(aFp,{ |y| y[1] == aFerPro[n,1] .And. y[2] == Space(6) }) ) > 0
							aFp[nPos,2] := aAv[x,2]
							aFp[nPos,3] := aAv[x,3]
							aFp[nPos,4] := aAv[x,4]
							aFp[nPos,5] := aAv[x,5]
							aFp[nPos,6] := aAv[x,6]
						Else
	   						Aadd(aFp,{aAv[x,1],aAv[x,2],aAv[x,3],aAv[x,4],aAv[x,5],aAv[x,6]})
						EndIf
				    EndIf
				EndIf  
			Next   
		EndIf
	Next

	For n:=1 to Len(a13Sala) // a13
		If (a13Sala[n,1] $ cVerbas) .or. SubStr(cVerbas,1,1)=="*"	   
			a13Sala[n,2]:=Str(nMeses)
			a13Sala[n,3]:=dDataIni
			a13Sala[n,4]:=dDataFim
			a13Sala[n,8]:=Str(nMeses)   
			For y:=1 to Len(a13)
				If a13[y,1] == a13Sala[n,1]	
					a13[y,2] := Space(6)
					a13[y,3] := 0.00
					a13[y,4] := 0.00
					a13[y,5] := Space(1)
					a13[y,6] := Ctod("")
				EndIf  
			Next   
			For X:=1 to Len(aAv)
				If aAv[x,1] == a13Sala[n,1]
					If aAv[x,2] >= dDataIni	 
						If (nPos := Ascan(a13,{ |y| y[1] == a13Sala[n,1] .And. y[2] == Space(6) }) ) > 0
							a13[nPos,2] := aAv[x,2]
							a13[nPos,3] := aAv[x,3]
							a13[nPos,4] := aAv[x,4]
							a13[nPos,5] := aAv[x,5]
							a13[nPos,6] := aAv[x,6]
						Else
	   						Aadd(a13,{aAv[x,1],aAv[x,2],aAv[x,3],aAv[x,4],aAv[x,5],aAv[x,6]})
						EndIf
				    EndIf
				EndIf  
			Next   
		EndIf
	Next

Return

User Function GP080ALT()
    
Local aArea := GetArea()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
      
	/*DbSelectArea("TRP")
	DbGoTop()
	While !Eof()  
		If TRP->RP_VALOR==0.00  
			RecLock("TRP",.f.)
			DbDelete()
			MsUnLock()
		EndIf
	   //	DbSelectArea("TRP")
		DbSkip()
	End

	//DbSelectArea("TRP")
	//DbGoTop()
  RestArea(aArea)*/
Return      

/* GUSTAVO 11/08/2016 - SISTEMA CALCULA POR PADRÃO
User Function GPDAV040()      

Local dDataProj := Ctod("")  
Local dDataAniv	:= Ctod("")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	dDataAniv := Stod(Str(Year(dDataBase),4,0)+Substr(Dtos(SRA->RA_ADMISSA),5,4))
    
	//-- Gustavo 10/08/2016 - O array aIncRes não vem mais valorizado
	//If aIncRes[02]=="I"   
	If Type("cAvPrev") != "U" .And. cAvPrev == "I"  
		dDataProj := dDataAv + nDiasAV	
	EndIf 

	If dDataDem < dDataAniv 
		If dDataProj >= dDataAniv    
			nDiasAv := nDiasAv + 3
		 	Aviso("Aviso de Alteração","Adicionado 3 dias no aviso pela data de projeção "+Dtoc(dDataProj),{"OK"})
		EndIf
	EndIf    
Return        
*/           
