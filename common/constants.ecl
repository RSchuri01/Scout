import std, Scout;

	EXPORT constants := module

	export digits := '0123456789';
	
	export line_feed 									:= '\n';
	export double_quote 							:= '\"';
	export email_smtp_server 	:= 'appmail.risk.regn.net';
	export email_address_fido_issues 	:= 'FIDO@risk.lexisnexis.com';
	export scout_key_build_alert        := 'raja.sundarrajan@lexisnexis.com,raju.nagarajan@lexisnexis.com,Margaret.Worob@lexisnexisrisk.com,Nicholas.Montpetit@lexisnexisrisk.com,Jamie.Martin@lexisnexisrisk.com';
	export ncf_dali 					:= '10.194.12.1:7070';
	export fcra_dali 					:= '10.194.12.1:7070';
	export forac_dali					:=	'10.194.10.1:7070';
	export boca_dataland_dali := '10.241.20.205:7070';
	export fido_dev_dali 			:= '10.194.169.1:7070';
	export fido_prod_dali 		:= '10.194.93.1:7070';
	// export fido_dev_ip 				:= 'http://10.194.169.2:8010';
	// export fido_prod_ip 			:= 'http://10.194.93.3:8010';
	// export fido_dr_ip 			:= 'http://10.173.93.142:8010';
	export fido_dr_ip 			:= 'https://fido-dr.hpcc.risk.regn.net:18010';
	export fido_dev_ip 				:= 'https://fido-dev.hpcc.risk.regn.net:18010';
	export fido_prod_ip 			:= 'https://fido-prod.hpcc.risk.regn.net:18010';		
	export foreign 						:= '~foreign';
    export roxie_target          := IF(scout.common.stored_env = 'dev', 'roxie', 'roxie_prod');
    // export fido_ip                   := IF(scout.common.stored_env = 'dev', fido_dev_ip, fido_prod_ip );
	export superkeypath              := '~thor::scout::key::score_logs::';
	export scout_input_keys_pattern  := superkeypath[2..] + '*';
    export today                     := std.Date.DateToString(std.Date.Today(), '%Y%m%d');
	export keyCountFileName          := '~thor::scout::key::score_logs::KeyCountsforlastweekdays';
	export stg_prefix                := '~thor::scout::stg';
	export fido_ip			 := map(scout.common.stored_env = 'dev' => fido_dev_ip, 
											scout.common.stored_env = 'dr' => fido_dr_ip,
											fido_prod_ip
										);

	thor_group 	:= std.system.Thorlib.group();
	

	export hpcc_env 		:= map(thor_group = 'thor40_83' => 'prod',
															thor_group = 'thor_fido_dev' => 'dev',
															thor_group = 'mythor' => 'dev',
															'unknown');

	EXPORT AntiMoneyLaunderingRiskAttributes_attr_keyName := 'AntiMoneyLaunderingRiskAttributes';
	EXPORT businessInstantID_attr_keyName := 'BusinessInstantID';
	EXPORT BUSINESSINSTANTID2_input_keyName := 'BUSINESSINSTANTID2_input';
	EXPORT BUSINESSINSTANTID2_output_keyName := 'BUSINESSINSTANTID2_output';
	EXPORT chargebackdefender_attr_keyName := 'ChargebackDefender';
	EXPORT FlexId_attr_keyName := 'FlexID';
	EXPORT fraudpoint_attr_keyName := 'FraudPoint';
	EXPORT InstantIdModel_attr_keyName := 'InstantIdModel';
	EXPORT LeadIntegrity_attr_keyName := 'LeadIntegrity';
	EXPORT orderscore_attr_keyName := 'OrderScoreResponseEx';
	EXPORT premiseassociation_attr_keyName := 'PremiseAssociation';
	EXPORT ProfileBoosterAttributes_attr_keyName := 'ProfileBoosterAttributes';
	EXPORT riskview_attr_keyName := 'RiskView';
	EXPORT Riskview2_attr_keyName := 'RiskView2';
	EXPORT riskviewalertcode_Attr_keyName := 'riskviewalertcode';
	EXPORT RiskViewAttributes_attr_keyName := 'RiskViewAttributes';
	EXPORT RiskViewReport_attr_keyName := 'RiskViewReport';
	EXPORT SmallBusinessAnalytics_attr_keyName := 'SmallBusinessAnalytics';
	EXPORT SmallBusinessBipCombinedReport_attr_keyName := 'SmallBusinessBipCombinedReport';
	EXPORT SmallBusinessMarketingAttributes_attr_keyName := 'SmallBusinessMarketingAttributes';
	EXPORT verification_attr_keyName := 'Verification';
	EXPORT VerificationOfOccupancy_attr_keyName := 'VerificationOfOccupancy';
	EXPORT key_scorelogs_scout_bus_name_keyName := 'scout_bus_name';
	EXPORT key_scorelogs_scout_citystzip_keyName := 'scout_citystzip';
	EXPORT key_scorelogs_scout_companyID_keyName := 'scout_companyID';
	EXPORT key_scorelogs_scout_ESP_method_keyName := 'scout_esp_method';
	EXPORT key_scorelogs_scout_industry_keyName := 'scout_industry';
	EXPORT key_scorelogs_scout_loginID_keyName := 'scout_loginID';
	EXPORT key_scorelogs_scout_names_keyName := 'scout_names';
	EXPORT key_scorelogs_scout_transactionID_keyName := 'scout_TransactionID';
	EXPORT key_scorelogs_XMLintermediate_keyName := 'xml_intermediate';
	EXPORT key_scorelogs_XMLtransactionID_keyName := 'xml_transactionid';

	EXPORT key_scorelogs_attributes_keyName := 'attributes';

	EXPORT attributesNameList := [
		AntiMoneyLaunderingRiskAttributes_attr_keyName,
		businessInstantID_attr_keyName,
		chargebackdefender_attr_keyName,
		fraudpoint_attr_keyName,
		LeadIntegrity_attr_keyName,
		orderscore_attr_keyName,
		premiseassociation_attr_keyName,
		ProfileBoosterAttributes_attr_keyName,
		Riskview2_attr_keyName,
		RiskViewAttributes_attr_keyName,
		RiskViewReport_attr_keyName,
		SmallBusinessAnalytics_attr_keyName,
		SmallBusinessBipCombinedReport_attr_keyName,
		SmallBusinessMarketingAttributes_attr_keyName,
		VerificationOfOccupancy_attr_keyName
	];
end;
