#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

WSSTRUCT _StruEstoque
	
	WSDATA   empresa       AS string OPTIONAL
	WSDATA   ccod          AS string OPTIONAL
	WSDATA   cgrupo        AS string OPTIONAL
	WSDATA   cdesc         AS string OPTIONAL
	WSDATA   cfilial       AS string OPTIONAL
	WSDATA   cLote         AS string OPTIONAL
	WSDATA   nestatu       AS float OPTIONAL
	WSDATA   nempenho      AS float OPTIONAL
	WSDATA   nestdisp      AS float OPTIONAL
	WSDATA   ncusto        AS float OPTIONAL
	//WSDATA   menserro      AS string OPTIONAL
ENDWSSTRUCT

WSSTRUCT _StruCliente
	WSDATA   CodCli      AS string OPTIONAL
	WSDATA   LojaCli     AS string OPTIONAL
	WSDATA   Razao       AS string OPTIONAL
	WSDATA   LimCred		AS float OPTIONAL
	WSDATA   VencLim		AS String OPTIONAL
	WSDATA   Saldo		AS float OPTIONAL
	WSDATA   Bloq        AS Boolean OPTIONAL
	WSDATA   Hist        AS string OPTIONAL
	WSDATA	 Risco		As string OPTIONAL
ENDWSSTRUCT

WSSTRUCT _StruDadCred
	WSDATA   GrpTrib      AS string OPTIONAL
	WSDATA   FormaPag     AS string OPTIONAL
	WSDATA   Vendedor     AS string OPTIONAL
	WSDATA   CondPag      AS string OPTIONAL
	WSDATA   Risco        AS string OPTIONAL
	WSDATA   LimCred      AS float OPTIONAL
	WSDATA   MaiorComp    AS float OPTIONAL
	WSDATA   MedAtraso    AS float OPTIONAL
	WSDATA   UltCompra    AS String OPTIONAL
	WSDATA   SaldDuplic   AS float OPTIONAL
	WSDATA   NroPagamen   AS float OPTIONAL
	WSDATA   Atrasos      AS float OPTIONAL
	WSDATA   VlrAcum      AS float OPTIONAL
	WSDATA   MaiorAtra    AS float OPTIONAL
	WSDATA   PagAtras     AS float OPTIONAL
	WSDATA   CapSocial    AS float OPTIONAL
	WSDATA   DataAber     AS String OPTIONAL
	WSDATA   DataCadas    AS String OPTIONAL
	WSDATA   ObsCobra     AS string OPTIONAL
	WSDATA   ObsCadas     AS string OPTIONAL
	WSDATA   Saldo	      AS float OPTIONAL 
	WSDATA   Bloq        AS Boolean OPTIONAL
		
ENDWSSTRUCT

//#######################################################################################



/* --------------------------------------------------------------------------------------
Funcao		Estruturas do Servico WebService
Autor		Devair
Descricao	Armazenas as estruturas de dados para os Serviços
-------------------------------------------------------------------------------------- */

//ESTRUTURA PARA USUARIO

WSSTRUCT STSFUSER
	
	WSDATA USUARIO          	AS String
	WSDATA SENHA	          	AS String
	
ENDWSSTRUCT

// ESTRUTURA DE INCLUSAO E ALTERACAO DE CLIENTE

WSSTRUCT STSFCLIENTE
	
	WSDATA NOME	          	AS String //A1_NOME
	WSDATA NREDUZ           	AS String //A1_NREDUZ
	WSDATA TIPO             	AS String //A1_TIPO (F=CONS. FINAL, L=PRODUTOR RURAL, R=REVENDEDOR, S=SOLIDARIO, X=EXPORTAÇÃO)
	WSDATA PESSOA           	AS String //A1_PESSOA (F-FISICA / J-JURÍDICA)
	WSDATA ENDERECO         	AS String //A1_END
	WSDATA NUMERO          	    AS String OPTIONAL //CONCATENAR AO A1_END
	WSDATA COMPLEM		   	AS String OPTIONAL //A1_COMPLEM
	WSDATA CODMUN			   	AS String //A1_COD_MUN	
	WSDATA BAIRRO           	AS String //A1_BAIRRO
	WSDATA CEP              	AS String //A1_CEP
	WSDATA ESTADO           	AS String //A1_EST
	WSDATA DDD              	AS String //A1_DDD
	WSDATA TELEFONE         	AS String //A1_TEL
	WSDATA FAX              	AS String	OPTIONAL //A1_FAX
	WSDATA PAIS			   	AS String //A1_PAIS
	WSDATA EMAIL            	AS String	//A1_EMAIL
	WSDATA EMAILNFE         	AS String	OPTIONAL//A1_X_MAILN
	WSDATA CGC             	AS String //A1_CGC
	WSDATA IESTADUAL        	AS String //A1_INSCR
	WSDATA CONDPAG          	AS String 	OPTIONAL//A1_COND
	WSDATA LC				 	AS Float 	OPTIONAL//A1_LC
	WSDATA VENCLC			 	AS String	OPTIONAL //A1_VENCLC
	WSDATA QTDVEILEV	    	AS Integer OPTIONAL //A1_QTDVEIC
	WSDATA QTDVEIPES	    	AS Integer OPTIONAL // A1_QDTVEI1
	WSDATA GRTRIB			   As String OPTIONAL// A1_GRPTRIB
	WSDATA FROMPAG		   As String OPTIONAL // A1_FORMPAG	TEXT
	WSDATA VEND   		   AS String // A1_VEND 	TEXT
	WSDATA RISCO   		   AS String // A1_RISCO	TEXT
	WSDATA DTNASC    		   AS String    // A1_DTNASC 	DATE
	WSDATA CAPTSOC   		   AS Float // A1_CAPTSOC	NUMBER
	WSDATA OBCOB   		   AS String OPTIONAL // A1_X_OBCOB	MEMO
	WSDATA OBCAD   		   AS String OPTIONAL // A1_X_OBCAD	MEMO
	WSDATA ENVIASERASA	   AS String // A1_X_SERAS	S=SIM,N=NAO
	WSDATA SIMPNAC	      AS String // A1_SIMPNAC	1=SIM,2=NAO
	WSDATA CONTRIB	      AS String // A1_CONTRIB	1=SIM,2=NAO
	WSDATA ATIVO	      AS String // A1_MSBLQL	1=SIM,2=NAO
	WSDATA DTCADAS        AS String // A1_DTCADAS   
	WSDATA COBEXT         AS String OPTIONAL// A1_COBEXT
	WSDATA GRPVEN		  As String OPTIONAL //A1_GRPVEN
	WSDATA SITCOB		  AS String OPTIONAL //A1_X_SCOBR  
	WSDATA GRLEV		  AS String OPTIONAL //A1_X_GRLEV
	WSDATA CLPAI 		  As String	OPTIONAL //A1_X_CLPAI
	WSDATA LJPAI		  AS String OPTIONAL //A1_X_LJPAI
	
ENDWSSTRUCT

WSSTRUCT STSFCLIALT 

	WSDATA CODIGO 			AS 	String //A1_CODIGO + LOJA (CONCATENADOS)
	WSDATA NOME	          	AS String //A1_NOME
	WSDATA NREDUZ           	AS String //A1_NREDUZ
	WSDATA TIPO             	AS String //A1_TIPO (F=CONS. FINAL, L=PRODUTOR RURAL, R=REVENDEDOR, S=SOLIDARIO, X=EXPORTAÇÃO)
	WSDATA PESSOA           	AS String //A1_PESSOA (F-FISICA / J-JURÍDICA)
	WSDATA ENDERECO         	AS String //A1_END  
	WSDATA NUMERO          	    AS String OPTIONAL //CONCATENAR AO A1_END
	WSDATA COMPLEM		   	AS String OPTIONAL //A1_COMPLEM
	WSDATA CODMUN			   	AS String //A1_COD_MUN	
	WSDATA BAIRRO           	AS String //A1_BAIRRO
	WSDATA CEP              	AS String //A1_CEP
	WSDATA ESTADO           	AS String //A1_EST
	WSDATA DDD              	AS String //A1_DDD
	WSDATA TELEFONE         	AS String //A1_TEL
	WSDATA FAX              	AS String	OPTIONAL //A1_FAX 
	WSDATA EMAIL            	AS String   OPTIONAL //A1_EMAIL
	WSDATA PAIS			   		AS String //A1_PAIS
	WSDATA EMAILNFE         	AS String	//A1_X_MAILN  
	WSDATA CGC             		AS String //A1_CGC
	WSDATA IESTADUAL        	AS String //A1_INSCR
	WSDATA CONDPAG          	AS String 	OPTIONAL//A1_COND
	WSDATA LC				 	AS Float 	OPTIONAL//A1_LC
	WSDATA VENCLC			 	AS String	OPTIONAL //A1_VENCLC
	WSDATA QTDVEILEV	    	AS Integer OPTIONAL //A1_QTDVEIC
	WSDATA QTDVEIPES	    	AS Integer OPTIONAL // A1_QDTVEI1
	WSDATA GRTRIB			   As String OPTIONAL// A1_GRPTRIB
	WSDATA FROMPAG		   As String OPTIONAL // A1_FORMPAG	TEXT
	WSDATA VEND   		   AS String // A1_VEND 	TEXT
	WSDATA RISCO   		   AS String // A1_RISCO	TEXT
	WSDATA DTNASC    		   AS String    // A1_DTNASC 	DATE
	WSDATA CAPTSOC   		   AS Float // A1_CAPTSOC	NUMBER
	WSDATA OBCOB   		   AS String OPTIONAL // A1_X_OBCOB	MEMO
	WSDATA OBCAD   		   AS String OPTIONAL // A1_X_OBCAD	MEMO
	WSDATA ENVIASERASA	   AS String // A1_X_SERAS	S=SIM,N=NAO
	WSDATA SIMPNAC	      AS String // A1_SIMPNAC	1=SIM,2=NAO
	WSDATA CONTRIB	      AS String // A1_CONTRIB	1=SIM,2=NAO
	WSDATA ATIVO	      AS String // A1_MSBLQL	1=SIM,2=NAO
	WSDATA DTCADAS        AS String // A1_DTCADAS
	WSDATA COBEXT         AS String OPTIONAL// A1_COBEXT 
	WSDATA GRPVEN		  As String OPTIONAL //A1_GRPVEN
	WSDATA SITCOB		  AS String OPTIONAL //A1_X_SCOBR
	WSDATA GRLEV		  AS String OPTIONAL //A1_X_GRLEV
	WSDATA CLPAI 		  As String	OPTIONAL //A1_X_CLPAI
	WSDATA LJPAI		  AS String OPTIONAL //A1_X_LJPAI             
	
ENDWSSTRUCT

//ESTRUTURA DE PRODUTO

WSSTRUCT STSFPRODUTO
	
	WSDATA CODIGO				AS String //B1_COD
	WSDATA	GRUPO				AS String	//	B1_GRUPO
	WSDATA	PESO				AS Float	//	B1_PESO
	WSDATA	PESBRU				AS Float	//	B1_PESBRU
	WSDATA	UM					AS String	//	B1_UM
	WSDATA	SEGUM				AS String	//	B1_SEGUM
	WSDATA	CONV				AS Float	//	B1_CONV
	WSDATA DESCRICAO			AS String //B1_DESC
	WSDATA DESCPORTUGUES		AS String //B1_VM_P
	WSDATA ATIVO				AS String //B1_MSBLQL
	WSDATA RASTRO				AS String //B1_RASTRO
	
ENDWSSTRUCT


//ESTRUTURA DE PRODUTO
WSSTRUCT STSFCONDPAGAMENTO
	
	WSDATA	CODIGO				AS String	//	E4_CODIGO
	WSDATA	DESCRICAO			AS String	//	E4_DESCRI
	WSDATA	PRAZOMEDIO			AS String	//	E4_X_PRMED
	
ENDWSSTRUCT


//ESTRUTURAS DE LOTES
WSSTRUCT STSFLOTES
	
	WSDATA	LOTECTL			As String	//	B8_LOTECTL
	WSDATA	DATAFABRIC			As Date	//	B8_DFABRIC
	WSDATA	DATAENTRADA		As Date	//	B8_DATA
	WSDATA	DATAVALID			As Date	//	B8_DTVALID
	
ENDWSSTRUCT

//ESTRUTURA DE RETORNO DE INCLUSAO OU ALTERACAO DE CLIENTE
WSStruct STSFRETCLI
	WSData CODIGO		AS String
	WSData RETORNO	As Boolean
	WSData MENSERRO	As String OPTIONAL
EndWSStruct

//Estrutura de inclusao de pedidos
WSStruct SFSTPEDIDO
	WSData C5CLIENTE 		As String //Codigo cliente
	WSData C5LOJACLI 		As String //Loja cliente
	//WSData CPNJCPF 		As String //Codigo cliente
	WSData C5CODPAG		As String //Codigo condicao de pagamento
	WSData C5VEND1		As String //Codigo vendedor
	WSData	C5TPFRETE		As String //Tipo frete
	WsData	C5TRANSP		As String OPTIONAL//Codigo da transportadora
	WSData C5XTID			As String	OPTIONAL//Numero transacao bancaria
	WsData DESTINACAO		As String // Destinacao do pedido (Revenda - Insumo - Consumo - Amostra - Bonificacao)
	WsData PARCESPECIAIS	AS Array of SFSTPARCESPECIAIS OPTIONAL //Array com parcelas especiais
	WSData NUMOPORTUNIDADE AS String // Numero da Oportunidade
	WsData ENDENTREGA		AS SFSTPEDIDOENDENTREGA OPTIONAL
	WSData ITENSPEDIDO  	As Array of SFSTITENSPEDIDO //Itens do pedido
	WsData ORDEMCOMPRA	As String OPTIONAL
	WsData OBSNOTA		As String OPTIONAL
	
EndWSStruct

//Estrutura de parcelas especiais do pedido
WSStruct SFSTPARCESPECIAIS
	
	WsData C5PARC		As Float OPTIONAL //Valor parcelas tipo 9
	WsData C5DATA		As String OPTIONAL //Vencimento parcelas tipo 9
	
EndWSStruct


//Estrutura de itens de pedido
WSStruct SFSTITENSPEDIDO
	
	WsData	C6PRODUTO 		As String //Codigo produto
	WsData C6QTDVEN		As Float  //Quantidade vendida
	WsData C6SEGUM		As String  OPTIONAL //Segunda unidade
	WsData C6UNSVEN		As Float 	OPTIONAL //Quantidade segunda unidade
	WsData C6PRCVEN		As Float  //Preco de venda
	WsData C6PRUNIT		As Float  //Preco de Tabela
	WsData C6DESCONT		As Float  OPTIONAL //Percentual Desconto
	WsData C6VALDESC		As Float  OPTIONAL //Valor do desconto
	WsData C6COMIS1		As Float  //Percentual de comissao
	WsData C6LOTECTL		As String OPTIONAL //Lote da venda
	WsData C6RESERVA		As String OPTIONAL //Numero da reserva
	
EndWSStruct

//Endereco entrega pedido
WSStruct SFSTPEDIDOENDENTREGA
	
	WsData CEPENTREGA 		As String OPTIONAL//Cep de entrega A1_CEPE
	WsData ENDENTREGA			As String OPTIONAL//Endereco de entrega A1_ENDENT
	WsData BAIRRROENTREGA 	As String OPTIONAL//Bairro de entraga A1_BAIRROE
	WsData CODMUNENTREGA 	As String OPTIONAL //Codigo municipio de entrega A1_CODMUNE
	WsData UFENTREGA			As String OPTIONAL //UF de entrega A1_ESTE
	WsData PAISENTREGA		As String OPTIONAL //Pais de enterga A1_PAIS
	
EndWSStruct

//ESTRUTURA DE RETORNO DE INCLUSAO OU ALTERACAO DE CLIENTE
WSStruct STSFRETPED
	WSData CODIGO		AS String
	WSData RETORNO	As Boolean
	WSData MENSERRO	As String OPTIONAL
EndWSStruct


//Estrutura de inclusao de reserva

WSStruct STSFRESERVA

	WsData CLIENTE	As String
	WsData VENDEDOR	As String
	WSData ITEMRESERVA AS Array of STSFITEMRESERVA
	
EndWSStruct


//Estrutura de item de reserva
WSStruct STSFITEMRESERVA
	
	WsData PRODUTO	As String
	WsData QUANT		As float
	WsData LOTE		As String  OPTIONAL
	WsData VENCIMENTO	As Date OPTIONAL	
	
EndWSStruct

//Retorno de reserva
WSStruct STSFRETRES
	WSData CODIGO		AS String
	WSData RETORNO	As Boolean
	WSData MENSERRO	As String OPTIONAL
EndWSStruct
