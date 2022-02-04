IMPORT SCOUT;

intermediate_2018_stats := TABLE(
    
    scout.logs.files_stg.intermediate_pversionmonth_stg_2018_ds,

    {datetime[1..8], product_id, count(group)},

    datetime[1..8], product_id,

    merge,

    skew(1.0)
);

scout_2018_stats := TABLE(
    
    scout.logs.files_stg.scout_pversionmonth_stg_2018_ds,

    {datetime[1..8], esp_method, count(group)},

    datetime[1..8], esp_method,

    merge,

    skew(1.0)
);

online_2018_stats := TABLE(
    
    scout.logs.files_stg.online_pversionmonth_stg_2018_ds,

    {datetime[1..8], esp_method, count(group)},

    datetime[1..8], esp_method,

    merge,

    skew(1.0)
);

// output(online_2018_stats, ,'~thor::scout::stats::stg::online_2018_stats', overwrite, expire(2));

// output(scout_2018_stats, , '~thor::scout::stats::stg::scout_2018_stats', overwrite, expire(2));

findStatsUsingMacroPreWork(modName) := FunctionMACRO
    
    Return Table(
            modName.superFileData,
            {String datetime := datetime[1..8], transaction_id, string product_name := modName.idxKeyName},
            datetime[1..8], transaction_id,  
            merge,
            skew(1.0)
        );

ENDMACRO;

findStatsUsingMacro(modName) := FunctionMACRO
    
    Return Output(

        Table(
            findStatsUsingMacroPreWork(ModName),
            {datetime[1..8], string product_name := modName.idxKeyName,  count(Group)},
            datetime[1..8], 
            merge,
            skew(1.0)
        ), ,
        '~thor::scout::stats::stg::scout_2018::' + modName.idxKeyName,
        overwrite,
        expire(2)
    );

ENDMACRO;



parallel(
findStatsUsingMacro(scout.logs.keys.attributes.AntiMoneyLaunderingRiskAttributes_attr);

findStatsUsingMacro(scout.logs.keys.attributes.BUSINESSINSTANTID2_input);

findStatsUsingMacro(scout.logs.keys.attributes.BUSINESSINSTANTID2_output);

findStatsUsingMacro(scout.logs.keys.attributes.businessInstantID_attr);
findStatsUsingMacro(scout.logs.keys.attributes.chargebackdefender_attr);
findStatsUsingMacro(scout.logs.keys.attributes.FlexId_attr);
findStatsUsingMacro(scout.logs.keys.attributes.fraudpoint_attr);
findStatsUsingMacro(scout.logs.keys.attributes.InstantIdModel_attr);
findStatsUsingMacro(scout.logs.keys.attributes.LeadIntegrity_attr);
findStatsUsingMacro(scout.logs.keys.attributes.orderscore_attr);
findStatsUsingMacro(scout.logs.keys.attributes.premiseassociation_attr);
findStatsUsingMacro(scout.logs.keys.attributes.ProfileBoosterAttributes_attr);
findStatsUsingMacro(scout.logs.keys.attributes.Riskview2_attr);
findStatsUsingMacro(scout.logs.keys.attributes.riskviewalertcode_Attr);
findStatsUsingMacro(scout.logs.keys.attributes.RiskViewAttributes_attr);
findStatsUsingMacro(scout.logs.keys.attributes.RiskViewReport_attr);
findStatsUsingMacro(scout.logs.keys.attributes.SmallBusinessAnalytics_attr);
findStatsUsingMacro(scout.logs.keys.attributes.SmallBusinessBipCombinedReport_attr);
findStatsUsingMacro(scout.logs.keys.attributes.SmallBusinessMarketingAttributes_attr );
findStatsUsingMacro(scout.logs.keys.attributes.verification_attr);
findStatsUsingMacro(scout.logs.keys.attributes.VerificationOfOccupancy_attr);

findStatsUsingMacro(scout.logs.keys.key_scorelogs_scout_bus_name );
findStatsUsingMacro(scout.logs.keys.key_scorelogs_scout_citystzip);
findStatsUsingMacro(scout.logs.keys.key_scorelogs_scout_companyID);
findStatsUsingMacro(scout.logs.keys.key_scorelogs_scout_ESP_method);
findStatsUsingMacro(scout.logs.keys.key_scorelogs_scout_industry);
findStatsUsingMacro(scout.logs.keys.key_scorelogs_scout_loginID);
findStatsUsingMacro(scout.logs.keys.key_scorelogs_scout_names);
findStatsUsingMacro(scout.logs.keys.key_scorelogs_scout_transactionID);
findStatsUsingMacro(scout.logs.keys.key_scorelogs_XMLintermediate);
findStatsUsingMacro(scout.logs.keys.key_scorelogs_XMLtransactionID)

);



// output(intermediate_2018_stats, , '~thor::scout::stats::stg::intermediate_2018_stats', overwrite, expire(2));

// Output(scout.logs.files_stg.online_pversionmonth_stg_2018_ds);

// output(scout.logs.files_stg.scout_pversionmonth_stg_2018_ds);