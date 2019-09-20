#ifdef SPANISH
	#define STR0001 "EMISION DEL LIBRO DE SUELDOS"
	#define STR0002 "Emision del Libro de sueldos. "
	#define STR0003 "Se imprimira de acuerdo con los parametros solicitados "
	#define STR0004 " por el usuario. "
	#define STR0005 "A rayas"
	#define STR0006 "Administrac."
	#define STR0007 "Atencion"
	#define STR0008 "El periodo seleccionado todavia no se encerro, ¿desea imprimir los mov. pendientes?"
	#define STR0009 "Si"
	#define STR0010 "No"
	#define STR0011 "El periodo selecc. es posterior al mes de competencia."
	#define STR0012 "OK"
	#define STR0013 "Empleados"
	#define STR0014 "Dependient."
	#define STR0015 "Asientos"
	#define STR0016 "Remuner."
	#define STR0017 "Descuent."
	#define STR0018 "P.Liq"
	#define STR0019 "Fch."
	#define STR0020 "Tp. Doc."
	#define STR0021 "Neto:"
	#define STR0022 "Masc"
	#define STR0023 "Fem."
	#define STR0024 "CONYUGE"
	#define STR0025 "HIJO"
	#define STR0026 "OTROS"
	#define STR0027 "F. Mat:"
	#define STR0028 "F.Nac: "
	#define STR0029 "Aguinaldo"
	#define STR0030 "Fecha Ingr."
	#define STR0031 "Fecha Desp."
#else
	#ifdef ENGLISH
		#define STR0001 "GENERATION OF PAYROLL RECORD"
		#define STR0002 "Generation of Salary Records."
		#define STR0003 "Will be printed according to the parameters requested "
		#define STR0004 "by the user. "
		#define STR0005 "Z.Form "
		#define STR0006 "Management   "
		#define STR0007 "Warning"
		#define STR0008 "The period selected has not yet been closed, do you want to print the pending movemt?"
		#define STR0009 "Yes"
		#define STR0010 "No "
		#define STR0011 "The selected period is posterior to the competence month"
		#define STR0012 "OK"
		#define STR0013 "Employees   "
		#define STR0014 "Dependants "
		#define STR0015 "Entries    "
		#define STR0016 "Earnings "
		#define STR0017 "Deductns."
		#define STR0018 "Net.P"
		#define STR0019 "Date"
		#define STR0020 "Tp. Doc."
		#define STR0021 "Net:"
		#define STR0022 "Masc"
		#define STR0023 "Fem."
		#define STR0024 "SPOUSE"
		#define STR0025 "CHILD"
		#define STR0026 "OTHERS"
		#define STR0027 "Wed.D: "
		#define STR0028 "Bir.D: "
		#define STR0029 "Annual Bonus"
		#define STR0030 "Adm. Date"
		#define STR0031 "Dism. Date"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Emissão Do Livro De Remunerações", "EMISSAO DO LIVRO DE SALARIOS" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Emissão do livro de remunerações. ", "Emissao do Livro de Salarios. " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Será impresso de acordo com os parâmetros solicitados ", "Será impresso de acordo com os parametros solicitados " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", " pelo utilizador. ", " pelo usuario. " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Administração", "Administraçäo" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Atenção", "Atencao" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "O período seleccionado ainda não foi terminado, deseja imprimir os movimentos em aberto?", "O periodo selecionado ainda nao foi fechado, deseja imprimir os movimentos em aberto?" )
		#define STR0009 "Sim"
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Não", "Nao" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "O período seleccionado é posterior ao mês de competência.", "O periodo selecionado e posterior ao mes de competencia." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Ok", "OK" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Empregados", "Funcionarios" )
		#define STR0014 "Dependentes"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Movimentos", "Lancamentos" )
		#define STR0016 "Proventos"
		#define STR0017 "Descontos"
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "P.liq", "P.Liq" )
		#define STR0019 "Data"
		#define STR0020 "Tp. Doc."
		#define STR0021 "Liquido:"
		#define STR0022 "Masc"
		#define STR0023 "Fem."
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Cônjuge", "CONJUGE" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Filho", "FILHO" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Outros", "OUTROS" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Dt.cas.: ", "D.Cas: " )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Dt.nasc.: ", "D.Nas: " )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "13º Salário", "13o. Salario" )
		#define STR0030 "Data Adm."
		#define STR0031 "Data Dem."
	#endif
#endif
