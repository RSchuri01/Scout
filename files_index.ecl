  IMPORT scout;

IMPORT scout.logs as logs;

EXPORT files_index := MODULE

    EXPORT online := scout.logs.files_stg.online_stg_ds : INDEPENDENT;
		
		EXPORT intermediate := scout.logs.files_stg.intermediate_stg_ds : INDEPENDENT;
		
		EXPORT scout := scout.logs.files_stg.scout_stg_ds : INDEPENDENT;

    EXPORT rollup_individual_attributes(String pversion, boolean isRollupAsked = true) := parallel (
        logs.keys.attributes.AntiMoneyLaunderingRiskAttributes_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),
        logs.keys.attributes.businessInstantID_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),
        logs.keys.attributes.chargebackdefender_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),              
		logs.keys.attributes.fraudpoint_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),      
		logs.keys.attributes.LeadIntegrity_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),           
		logs.keys.attributes.orderscore_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),   
		logs.keys.attributes.PremiseAssociation_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),
		logs.keys.attributes.ProfileBoosterAttributes_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),
		logs.keys.attributes.RiskView2_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),
        logs.keys.attributes.RiskViewAttributes_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),
        logs.keys.attributes.SmallBusinessMarketingAttributes_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),
        logs.keys.attributes.SmallBusinessAnalytics_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),
        logs.keys.attributes.SmallBusinessBipCombinedReport_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),
        logs.keys.attributes.verificationOfOccupancy_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),
   		logs.keys.attributes.RiskViewReport_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),
		logs.keys.attributes.BUSINESSINSTANTID2_input.rollupBackSuperFileIndex(pversion, isRollupAsked),
		logs.keys.attributes.BUSINESSINSTANTID2_output.rollupBackSuperFileIndex(pversion, isRollupAsked),
        logs.keys.attributes.verification_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),
        logs.keys.attributes.riskviewalertcode_Attr.rollupBackSuperFileIndex(pversion, isRollupAsked),
		logs.keys.attributes.InstantIdModel_attr.rollupBackSuperFileIndex(pversion, isRollupAsked),
		logs.keys.attributes.FlexId_attr.rollupBackSuperFileIndex(pversion, isRollupAsked)																					 
      );

	 EXPORT build_attributes(STRING pver, Boolean isRollupAsked) := PARALLEL(
		 logs.keys.attributes.fraudpoint_attr.indexDailyStgFile(pver, isRollupAsked),      
         logs.keys.attributes.AntiMoneyLaunderingRiskAttributes_attr.indexDailyStgFile(pver, isRollupAsked),
		 logs.keys.attributes.businessInstantID_attr.indexDailyStgFile(pver, isRollupAsked),
		 logs.keys.attributes.chargebackdefender_attr.indexDailyStgFile(pver, isRollupAsked),      

		 logs.keys.attributes.LeadIntegrity_attr.indexDailyStgFile(pver, isRollupAsked),           
		 logs.keys.attributes.orderscore_attr.indexDailyStgFile(pver, isRollupAsked),   
		 logs.keys.attributes.PremiseAssociation_attr.indexDailyStgFile(pver, isRollupAsked),
		 logs.keys.attributes.ProfileBoosterAttributes_attr.indexDailyStgFile(pver, isRollupAsked),


	     logs.keys.attributes.RiskView2_attr.indexDailyStgFile(pver, isRollupAsked),


		 logs.keys.attributes.RiskViewAttributes_attr.indexDailyStgFile(pver, isRollupAsked),
		 logs.keys.attributes.SmallBusinessMarketingAttributes_attr.indexDailyStgFile(pver, isRollupAsked),
		 logs.keys.attributes.SmallBusinessAnalytics_attr.indexDailyStgFile(pver, isRollupAsked),
		 logs.keys.attributes.SmallBusinessBipCombinedReport_attr.indexDailyStgFile(pver, isRollupAsked),
		 logs.keys.attributes.verificationOfOccupancy_attr.indexDailyStgFile(pver, isRollupAsked),
		 logs.keys.attributes.RiskViewReport_attr.indexDailyStgFile(pver, isRollupAsked),
		 logs.keys.attributes.BUSINESSINSTANTID2_input.indexDailyStgFile(pver, isRollupAsked),
		 logs.keys.attributes.BUSINESSINSTANTID2_output.indexDailyStgFile(pver, isRollupAsked),


		 logs.keys.attributes.verification_attr.indexDailyStgFile(pver, isRollupAsked),
		 logs.keys.attributes.riskviewalertcode_Attr.indexDailyStgFile(pver, isRollupAsked),
		 


		 logs.keys.attributes.InstantIdModel_attr.indexDailyStgFile(pver, isRollupAsked),
		 logs.keys.attributes.FlexId_attr.indexDailyStgFile(pver, isRollupAsked)
		 
   );
END;
