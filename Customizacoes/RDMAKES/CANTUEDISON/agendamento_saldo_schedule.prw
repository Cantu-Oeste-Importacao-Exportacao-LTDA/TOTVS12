#INCLUDE "rwmake.ch"
#INCLUDE "vkey.ch"
#include "TopConn.ch"
#include "Protheus.ch"
#include "TbiConn.ch"

User Function m3004001()
	Local PARAMIXB := .T.      //-- Caso a rotina seja rodada em batch(.T.), senão (.F.)
	Local aemp := {"40","01"}  //-- "Empresa","Filial"
	PREPARE ENVIRONMENT EMPRESA aemp[1] Filial aemp[2] USER 'admin' PASSWORD '@dmin2019' TABLES  "SB1","SB2","SB9","SD1","SD2","SD3","SF4" MODULO "EST"
	MSExecAuto({|x| mata300(x)},PARAMIXB)
	RESET ENVIRONMENT
Return Nil

User Function m3004002()
	Local PARAMIXB := .T.      //-- Caso a rotina seja rodada em batch(.T.), senão (.F.)
	Local aemp := {"40","02"}  //-- "Empresa","Filial"
	PREPARE ENVIRONMENT EMPRESA aemp[1] Filial aemp[2] USER 'admin' PASSWORD '@dmin2019' TABLES  "SB1","SB2","SB9","SD1","SD2","SD3","SF4" MODULO "EST"
	MSExecAuto({|x| mata300(x)},PARAMIXB)
	RESET ENVIRONMENT
Return 

User Function m3004004()
	Local PARAMIXB := .T.      //-- Caso a rotina seja rodada em batch(.T.), senão (.F.)
	Local aemp := {"40","04"}  //-- "Empresa","Filial"
	PREPARE ENVIRONMENT EMPRESA aemp[1] Filial aemp[2] USER 'admin' PASSWORD '@dmin2019' TABLES  "SB1","SB2","SB9","SD1","SD2","SD3","SF4" MODULO "EST"
	MSExecAuto({|x| mata300(x)},PARAMIXB)
	RESET ENVIRONMENT
Return Nil

User Function m3004005()
	Local PARAMIXB := .T.      //-- Caso a rotina seja rodada em batch(.T.), senão (.F.)
	Local aemp := {"40","05"}  //-- "Empresa","Filial"
	PREPARE ENVIRONMENT EMPRESA aemp[1] Filial aemp[2] USER 'admin' PASSWORD '@dmin2019' TABLES  "SB1","SB2","SB9","SD1","SD2","SD3","SF4" MODULO "EST"
	MSExecAuto({|x| mata300(x)},PARAMIXB)
	RESET ENVIRONMENT
Return Nil