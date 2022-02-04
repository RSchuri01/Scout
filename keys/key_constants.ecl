IMPORT scout;
IMPORT std;
IMPORT scout.common.app_constants as app_constants;

EXPORT key_constants(string freq='daily') := MODULE

export basename		:=
                       TRIM(CASE (std.str.tolowercase(freq),
							 'daily' => app_constants.key_file_prefix,
							 '2yearhistory' => scout.common.app_constants.historical_2year_key_file_prefix  + '::',
							 '2yearhistoryfiltered' => scout.common.app_constants.historical_2year_filtered_key_file_prefix  + '::',
							 'recent2yearfiltered' => scout.common.app_constants.recent_2year_filtered_key_file_prefix  + '::'
							 ,''));


export attributes_idx			:= basename + 'attributes';
export scout_bus_name_idx		:= basename + 'scout_bus_name';
export scout_citystzip_idx 		:= basename + 'scout_citystzip';
export scout_companyid_idx		:= basename + 'scout_companyid';
export scout_esp_method_idx		:= basename + 'scout_esp_method';
export scout_industry_idx 		:= basename + 'scout_industry';
export scout_loginid_idx 		:= basename + 'scout_loginid';
export scout_names_idx 			:= basename + 'scout_names';
export scout_transactionid_idx 	:= basename + 'scout_transactionid';
export xmlintermediate_idx 		:= basename + 'xml_intermediate';
export xmltransaction_idx 		:= basename + 'xml_transactionid';
export AntiMoneyLaunderingRiskAttributes_idx := basename + 'AntiMoneyLaunderingRiskAttributes';
export businessInstantID_idx := basename + 'businessInstantID';
export chargebackdefender_idx := basename + 'chargebackdefender';
export fraudpoint_idx := basename + 'fraudpoint';
export LeadIntegrity_idx := basename + 'LeadIntegrity';
export OrderScoreResponseEx_idx := basename + 'orderscore';
export premiseassociation_idx := basename + 'premiseassociation';
export ProfileBoosterAttributes_idx := basename + 'ProfileBoosterAttributes';
export riskview_idx := basename + 'riskview';
export Riskview2_idx := basename + 'Riskview2';
export RiskViewAttributes_idx := basename + 'RiskViewAttributes';
export RiskViewReport_idx := basename + 'RiskViewReport';
export SmallBusinessAnalytics_idx := basename + 'SmallBusinessAnalytics';
export SmallBusinessBipCombinedReport_idx := basename + 'SmallBusinessBipCombinedReport';
export SmallBusinessMarketingAttributes_idx := basename + 'SmallBusinessMarketingAttributes';
export VerificationOfOccupancy_idx := basename + 'VerificationOfOccupancy';



END;