IMPORT SCOUT, std;

IMPORT DataMgmt;

EXPORT RemovePackageMapsForScoutQueries := SEQUENTIAL(

    DataMgmt.GenIndex.RemoveRoxiePackageMap 
	(
		'scout.detailed_search_service',              // Roxie query's name
		[
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_transactionID.idxKeyName
            ),

            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_XMLtransactionID.idxKeyName
            ),

            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_XMLintermediate.idxKeyName
            )
        ],        // Set of index stores used by the query
		scout.common.constants.fido_ip     // URL to ESP service (ECL Watch)
	),
    DataMgmt.GenIndex.RemoveRoxiePackageMap 
	(
		'scout.detailed_search_service_test',              // Roxie query's name
		[
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_transactionID.idxKeyName
            ),

            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_XMLtransactionID.idxKeyName
            ),

            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_XMLintermediate.idxKeyName
            )
        ],        // Set of index stores used by the query
		scout.common.constants.fido_ip     // URL to ESP service (ECL Watch)
	),
    DataMgmt.GenIndex.RemoveRoxiePackageMap
	(
		'scout.summary_search_service',              // Roxie query's name
		[
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_transactionID.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_bus_name.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_citystzip.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_companyID.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_ESP_method.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_industry.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_loginID.idxKeyName
            ),                     
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_names.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.AntiMoneyLaunderingRiskAttributes_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.BUSINESSINSTANTID2_input.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.BUSINESSINSTANTID2_output.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.businessInstantID_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.chargebackdefender_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.FlexId_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.fraudpoint_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.InstantIdModel_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.LeadIntegrity_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.orderscore_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.premiseassociation_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.ProfileBoosterAttributes_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.Riskview2_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.riskview_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.riskviewalertcode_Attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.RiskViewAttributes_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.RiskViewReport_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.SmallBusinessAnalytics_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.SmallBusinessBipCombinedReport_attr.idxKeyName
            ),   
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.SmallBusinessMarketingAttributes_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.verification_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.VerificationOfOccupancy_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_XMLtransactionID.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_XMLintermediate.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_attributes.idxKeyName
            )

        ],        // Set of index stores used by the query
		scout.common.constants.fido_ip    // URL to ESP service (ECL Watch)
	),
        DataMgmt.GenIndex.RemoveRoxiePackageMap
	(
		'scout.summary_search_service_test',              // Roxie query's name
		[
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_transactionID.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_bus_name.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_citystzip.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_companyID.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_ESP_method.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_industry.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_loginID.idxKeyName
            ),                     
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_scout_names.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.AntiMoneyLaunderingRiskAttributes_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.BUSINESSINSTANTID2_input.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.BUSINESSINSTANTID2_output.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.businessInstantID_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.chargebackdefender_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.FlexId_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.fraudpoint_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.InstantIdModel_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.LeadIntegrity_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.orderscore_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.premiseassociation_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.ProfileBoosterAttributes_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.Riskview2_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.riskview_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.riskviewalertcode_Attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.RiskViewAttributes_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.RiskViewReport_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.SmallBusinessAnalytics_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.SmallBusinessBipCombinedReport_attr.idxKeyName
            ),   
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.SmallBusinessMarketingAttributes_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.verification_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.attributes.VerificationOfOccupancy_attr.idxKeyName
            ), 
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_XMLtransactionID.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_XMLintermediate.idxKeyName
            ),
            scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(
                scout.logs.keys.key_scorelogs_attributes.idxKeyName
            )

        ],        // Set of index stores used by the query
		scout.common.constants.fido_ip    // URL to ESP service (ECL Watch)
	)
);