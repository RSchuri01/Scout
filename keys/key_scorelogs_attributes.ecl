import scout;
import scout.logs;
import std;
import scout.logs.layout as layout;
import scout.common.app_constants as app_constants;

IMPORT DataMgmt;
IMPORT scout.common.constants;
IMPORT * from scout.logs.keys;
EXPORT key_scorelogs_attributes := MODULE

EXPORT idxKeyName := scout.common.constants.key_scorelogs_attributes_keyName;

	
EXPORT superFileName := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName);
	
EXPORT completeFileName := '{' + STD.STR.COMBINEWORDS(
    	SET(
        	project(
            	DATASET(scout.common.constants.attributesNameList, {string name}),
                	transform({string idxFileName}, 
					self.idxFileName := STD.Str.FindReplace(
							STD.Str.FindReplace(SCOUT.logs.util.fn_getMySuperKeyNameByKey(LEFT.name),'}' , ''),
							'{' , '')
					)
        	), 
    	idxFileName), 
	',') + 
'}';

/** THOR */
EXPORT superFileData := INDEX(DATASET([],layout.attributes_key), {layout.attributes_key.transaction_id, layout.attributes_key.datetime}, {layout.attributes_key},
			    completeFileName); 
/** for Roxie 
EXPORT superFileData := INDEX(DATASET([],layout.attributes_key), {layout.attributes_key.transaction_id, layout.attributes_key.datetime}, {layout.attributes_key},
			    superFileName);

*/
	SHARED createAndAddAllAttributes := 
	    SEQUENTIAL(
			STD.File.StartSuperFileTransaction();
          	STD.File.CreateSuperFile(superFileName, false, true);
			    PARALLEL(
			 	      STD.File.CreateSuperFile(Scout.logs.keys.attributes.AntiMoneyLaunderingRiskAttributes_attr.superFileName(), false, true),
				      STD.File.CreateSuperFile(Scout.logs.keys.attributes.businessInstantID_attr.superFileName(), false, true),
				      STD.File.CreateSuperFile(Scout.logs.keys.attributes.chargebackdefender_attr.superFileName(), false, true),
				      STD.File.CreateSuperFile(Scout.logs.keys.attributes.fraudpoint_attr.superFileName(), false, true),
				      STD.File.CreateSuperFile(Scout.logs.keys.attributes.LeadIntegrity_attr.superFileName(), false, true),
				      STD.File.CreateSuperFile(Scout.logs.keys.attributes.orderscore_attr.superFileName(), false, true),
				      STD.File.CreateSuperFile(Scout.logs.keys.attributes.premiseassociation_attr.superFileName(), false, true),
				      STD.File.CreateSuperFile(Scout.logs.keys.attributes.ProfileBoosterAttributes_attr.superFileName(), false, true),
				      STD.File.CreateSuperFile(Scout.logs.keys.attributes.Riskview2_attr.superFileName(), false, true),
				      STD.File.CreateSuperFile(Scout.logs.keys.attributes.RiskViewAttributes_attr.superFileName(), false, true),
				      STD.File.CreateSuperFile(Scout.logs.keys.attributes.RiskViewReport_attr.superFileName(), false, true),
				      STD.File.CreateSuperFile(Scout.logs.keys.attributes.SmallBusinessAnalytics_attr.superFileName(), false, true),
				      STD.File.CreateSuperFile(Scout.logs.keys.attributes.SmallBusinessBipCombinedReport_attr.superFileName(), false, true),
				      STD.File.CreateSuperFile(Scout.logs.keys.attributes.SmallBusinessMarketingAttributes_attr.superFileName(), false, true),
				      STD.File.CreateSuperFile(Scout.logs.keys.attributes.VerificationOfOccupancy_attr.superFileName(), false, true),
			),
			PARALLEL(
			    STD.File.AddSuperFile(SuperFileName, Scout.logs.keys.attributes.AntiMoneyLaunderingRiskAttributes_attr.superFileName()),
				STD.File.AddSuperFile(SuperFileName, Scout.logs.keys.attributes.businessInstantID_attr.superFileName()),
				STD.File.AddSuperFile(SuperFileName, Scout.logs.keys.attributes.chargebackdefender_attr.superFileName()),
				STD.File.AddSuperFile(SuperFileName, Scout.logs.keys.attributes.fraudpoint_attr.superFileName()),
				STD.File.AddSuperFile(SuperFileName, Scout.logs.keys.attributes.LeadIntegrity_attr.superFileName()),
				STD.File.AddSuperFile(SuperFileName, Scout.logs.keys.attributes.orderscore_attr.superFileName()),
				STD.File.AddSuperFile(SuperFileName, Scout.logs.keys.attributes.premiseassociation_attr.superFileName()),
				STD.File.AddSuperFile(SuperFileName, Scout.logs.keys.attributes.ProfileBoosterAttributes_attr.superFileName()),
				STD.File.AddSuperFile(SuperFileName, Scout.logs.keys.attributes.Riskview2_attr.superFileName()),
				STD.File.AddSuperFile(SuperFileName, Scout.logs.keys.attributes.RiskViewAttributes_attr.superFileName()),
				STD.File.AddSuperFile(SuperFileName, Scout.logs.keys.attributes.RiskViewReport_attr.superFileName()),
				STD.File.AddSuperFile(SuperFileName, Scout.logs.keys.attributes.SmallBusinessAnalytics_attr.superFileName()),
				STD.File.AddSuperFile(SuperFileName, Scout.logs.keys.attributes.SmallBusinessBipCombinedReport_attr.superFileName()),
				STD.File.AddSuperFile(SuperFileName, Scout.logs.keys.attributes.SmallBusinessMarketingAttributes_attr.superFileName()),
				STD.File.AddSuperFile(SuperFileName, Scout.logs.keys.attributes.VerificationOfOccupancy_attr.superFileName()),
			),
			STD.File.FinishSuperFileTransaction()
		);
END;