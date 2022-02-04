IMPORT std;
IMPORT scout;

export mysqlconnection := module

//DEV
SHARED dev_myServer := 'dbdprsql-bct.risk.regn.net';
SHARED dev_myUser 		:= 'nagararx';
SHARED dev_mypass 		:= 'sUM3.!17';
SHARED dev_myDb 		:= 'scout';
shared dev_myPort		:= '3306';

//QA
SHARED qa_myServer 	:= 'dbqprsql-bct.risk.regn.net';
SHARED qa_myUser 	:= 'svc-scout';
SHARED qa_mypass	:= '$vcSc0ut18';
SHARED qa_myDb 		:= 'scout';
shared qa_myPort	:= '3308';

//PROD
SHARED prod_myServer 	:= 'mbssql.br.seisint.com';
SHARED prod_myUser 		:= 'svc-scout';
SHARED prod_mypass 		:= '$vcSc0ut18';
SHARED prod_myDb 		:= 'scout';
shared prod_myPort		:= '3306';

export myServer := MAP(std.str.ToUpperCase(scout.common.stored_mysql_env) = 'DEV' => dev_myServer,
						std.str.ToUpperCase(scout.common.stored_mysql_env) = 'QA' => qa_myServer,
						std.str.ToUpperCase(scout.common.stored_mysql_env) = 'PROD' => prod_myServer, '');

export myUser 	:= MAP(std.str.ToUpperCase(scout.common.stored_mysql_env) = 'DEV' => dev_myUser,
						std.str.ToUpperCase(scout.common.stored_mysql_env) = 'QA' => qa_myUser,
						std.str.ToUpperCase(scout.common.stored_mysql_env) = 'PROD' => prod_myUser, '');

export mypass 	:= MAP(std.str.ToUpperCase(scout.common.stored_mysql_env) = 'DEV' => dev_mypass,
						std.str.ToUpperCase(scout.common.stored_mysql_env) = 'QA' => qa_mypass,
						std.str.ToUpperCase(scout.common.stored_mysql_env) = 'PROD' => prod_mypass, '');

export myDb 	:= MAP(std.str.ToUpperCase(scout.common.stored_mysql_env) = 'DEV' => dev_myDb,
						std.str.ToUpperCase(scout.common.stored_mysql_env) = 'QA' => qa_myDb,
						std.str.ToUpperCase(scout.common.stored_mysql_env) = 'PROD' => prod_myDb, '');

export myPort 	:= MAP(std.str.ToUpperCase(scout.common.stored_mysql_env) = 'DEV' => dev_myPort,
						std.str.ToUpperCase(scout.common.stored_mysql_env) = 'QA' => qa_myPort,
						std.str.ToUpperCase(scout.common.stored_mysql_env) = 'PROD' => prod_myPort, '');

end;