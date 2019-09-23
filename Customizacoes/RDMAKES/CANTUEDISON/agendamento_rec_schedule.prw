#INCLUDE "rwmake.ch"
#INCLUDE "vkey.ch"
#include "TopConn.ch"
#include "Protheus.ch"
#include "TbiConn.ch"

User Function m3304001()
Local PARAMIXB1 := .T. // - Caso a rotina seja rodada em batch(.T.), senão (.F.)
Local PARAMIXB2 := {"01"} // - Lista com as filiais a serem consideradas (Batch)
Local PARAMIXB3 := .T. // - Se considera o custo em partes do processamento
Local PARAMIXB4 := {} // -Parametros para execução da rotina
Local aEmp := {"40","01"} // Empresa Filial

PREPARE ENVIRONMENT EMPRESA aemp[1] FILIAL aemp[2] USER 'admin' PASSWORD '@dmin2019' TABLES "AF9","SB2","SB9","SBD","SC2","SD1","SD3","SD8","SF4","SF5","SI1","SI2","SI3","SI5","SI6","SI7","SM2" MODULO "EST"

dData := LastDay(Date()) // Pega o ultimo dia do mês corrente
PARAMIXB4 := { dData ,2,1,1,0,2," " ,"ZZZZZZZZZZZZZZZ" ,1,3,2,3,2,3,1,1,2,1,2,2,2} //Parametros
MSExecAuto({|x,y,z,w|mata330(x,y,z,w)},PARAMIXB1,PARAMIXB2,PARAMIXB3,PARAMIXB4)
RESET ENVIRONMENT
Return Nil


User Function m3304002()
Local PARAMIXB1 := .T. // - Caso a rotina seja rodada em batch(.T.), senão (.F.)
Local PARAMIXB2 := {"02"} // - Lista com as filiais a serem consideradas (Batch)
Local PARAMIXB3 := .T. // - Se considera o custo em partes do processamento
Local PARAMIXB4 := {} // -Parametros para execução da rotina
Local aEmp := {"40","02"} // Empresa Filial

PREPARE ENVIRONMENT EMPRESA aemp[1] FILIAL aemp[2] USER 'admin' PASSWORD '@dmin2019' TABLES "AF9","SB2","SB9","SBD","SC2","SD1","SD3","SD8","SF4","SF5","SI1","SI2","SI3","SI5","SI6","SI7","SM2" MODULO "EST"

dData := LastDay(Date()) // Pega o ultimo dia do mês corrente
PARAMIXB4 := { dData ,2,1,1,0,2," " ,"ZZZZZZZZZZZZZZZ" ,1,3,2,3,2,3,1,1,2,1,2,2,2} //Parametros
MSExecAuto({|x,y,z,w|mata330(x,y,z,w)},PARAMIXB1,PARAMIXB2,PARAMIXB3,PARAMIXB4)
RESET ENVIRONMENT
Return Nil

User Function m3304004()
Local PARAMIXB1 := .T. // - Caso a rotina seja rodada em batch(.T.), senão (.F.)
Local PARAMIXB2 := {"04"} // - Lista com as filiais a serem consideradas (Batch)
Local PARAMIXB3 := .T. // - Se considera o custo em partes do processamento
Local PARAMIXB4 := {} // -Parametros para execução da rotina
Local aEmp := {"40","04"} // Empresa Filial

PREPARE ENVIRONMENT EMPRESA aemp[1] FILIAL aemp[2] USER 'admin' PASSWORD '@dmin2019' TABLES "AF9","SB2","SB9","SBD","SC2","SD1","SD3","SD8","SF4","SF5","SI1","SI2","SI3","SI5","SI6","SI7","SM2" MODULO "EST"

dData := LastDay(Date()) // Pega o ultimo dia do mês corrente
PARAMIXB4 := { dData ,2,1,1,0,2," " ,"ZZZZZZZZZZZZZZZ" ,1,3,2,3,2,3,1,1,2,1,2,2,2} //Parametros
MSExecAuto({|x,y,z,w|mata330(x,y,z,w)},PARAMIXB1,PARAMIXB2,PARAMIXB3,PARAMIXB4)
RESET ENVIRONMENT
Return Nil

User Function m3304005()
Local PARAMIXB1 := .T. // - Caso a rotina seja rodada em batch(.T.), senão (.F.)
Local PARAMIXB2 := {"05"} // - Lista com as filiais a serem consideradas (Batch)
Local PARAMIXB3 := .T. // - Se considera o custo em partes do processamento
Local PARAMIXB4 := {} // -Parametros para execução da rotina
Local aEmp := {"40","05"} // Empresa Filial

PREPARE ENVIRONMENT EMPRESA aemp[1] FILIAL aemp[2] USER 'admin' PASSWORD '@dmin2019' TABLES "AF9","SB2","SB9","SBD","SC2","SD1","SD3","SD8","SF4","SF5","SI1","SI2","SI3","SI5","SI6","SI7","SM2" MODULO "EST"

dData := LastDay(Date()) // Pega o ultimo dia do mês corrente
PARAMIXB4 := { dData ,2,1,1,0,2," " ,"ZZZZZZZZZZZZZZZ" ,1,3,2,3,2,3,1,1,2,1,2,2,2} //Parametros
MSExecAuto({|x,y,z,w|mata330(x,y,z,w)},PARAMIXB1,PARAMIXB2,PARAMIXB3,PARAMIXB4)
RESET ENVIRONMENT
Return Nil