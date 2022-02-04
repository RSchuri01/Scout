IMport scout;
import * from scout.logs.util;
Import std;


moveFilesFromDailyToMontlhy(String keyName) := Function

keyPrefix := scout.common.app_constants.key_file_prefix;

pversion := '20180901';

monthlySuperFileName := keyPrefix + 'monthly::' +  pversion[1..4] + '::' + pversion[5..6] + '::' + keyName;

dailySuperFileName := keyPrefix +  keyName;


filesToMove := (NOTHOR(Std.file.Superfilecontents(dailySuperFileName))) : INDEPENDENT;

clearFromTwoSuper := NOTHOR(apply(global(filesToMove, few), std.file.removesuperfile(dailySuperFileName, '~' + name)));

addToTwoSuper := NOTHOR(apply(global(filesToMove, few), std.file.addsuperfile(monthlySuperFileName, '~' + name)));

doAll := SEQUENTIAL(
        clearFromTwoSuper,
        addToTwoSuper
);

return Sequential(
    std.file.createSuperfile(monthlySuperFileName, allowExist := true);
    doAll
);
end;


moveFilesFromMontlhyToDaily(String keyName) := Function

keyPrefix := scout.common.app_constants.key_file_prefix;

pversion := '20180901';

monthlySuperFileName := keyPrefix + 'monthly::' +  pversion[1..4] + '::' + pversion[5..6] + '::' + keyName;

dailySuperFileName := keyPrefix +  keyName;


filesToMove := (NOTHOR(Std.file.Superfilecontents(monthlySuperFileName))) : INDEPENDENT;

clearFromTwoSuper := NOTHOR(apply(global(filesToMove, few), std.file.removesuperfile(monthlySuperFileName, '~' + name)));

addToTwoSuper := NOTHOR(apply(global(filesToMove, few), std.file.addsuperfile(dailySuperFileName, '~' + name)));

doAll := SEQUENTIAL(
        clearFromTwoSuper,
        addToTwoSuper
);

return Sequential(
       doAll
);
end;

MoveDailyFilesFromTwoYearToMonthlySuper(String keyname) := function

pversion := '20180901';

keyPrefix := scout.common.app_constants.key_file_prefix;

monthlySuperFileName := keyPrefix + 'monthly::' +  pversion[1..4] + '::' + pversion[5..6] + '::' + keyName;

twoyearsSuperFileName := keyPrefix + '2yearssuper::' + keyName;

dailySuperFileName := keyPrefix +  keyName;

filesToMove := (NOTHOR(Std.file.Superfilecontents(twoyearsSuperFileName)))(std.str.endswith(name, 'daily')) : INDEPENDENT;

clearFromTwoSuper := NOTHOR(apply(global(filesToMove, few), std.file.removesuperfile(twoyearsSuperFileName, '~' + name)));

addToTwoSuper := NOTHOR(apply(global(filesToMove, few), std.file.addsuperfile(dailySuperFileName, '~' + name)));

doAll := SEQUENTIAL(
        clearFromTwoSuper,
        addToTwoSuper
);

Return doAll;

end;

addSepMonthSuperToTwoyearSuper(String keyname) := function

    return std.File.addSuperfile(
        scout.logs.util.fn_getMySuperKeyNameByKey(keyname),
        scout.logs.util.fn_getMySuperKeyNameByKeyForDailyBuild(keyName)
    );
end;

moveFromWrongMonthlyToProperMonthly(String Keyname) := function

keyPrefix := '~thor::scout::key::score_logs::';

monthlySuperFileName := keyPrefix + 'monthly::' +  '2018::09::' + keyName;

badMonthlyFilename := keyPrefix + '2018::09::' + keyName;

dailySuperFileName := keyPrefix +  keyName;

filesToMove := (NOTHOR(Std.file.Superfilecontents(badMonthlyFilename))) : INDEPENDENT;

clearFromTwoSuper := NOTHOR(apply(global(filesToMove, few), std.file.removesuperfile(badMonthlyFilename, '~' + name)));

addToTwoSuper := NOTHOR(apply(global(filesToMove, few), std.file.addsuperfile(monthlySuperFileName, '~' + name)));

doAll := SEQUENTIAL(
        clearFromTwoSuper,
        addToTwoSuper
);

Return doAll;



end;

#stored('filedate', '20180901');

SEQUENTIAL(
moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.AntiMoneyLaunderingRiskAttributes_attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.BUSINESSINSTANTID2_input.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.BUSINESSINSTANTID2_output.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.businessInstantID_attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.chargebackdefender_attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.FlexId_attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.fraudpoint_attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.InstantIdModel_attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.LeadIntegrity_attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.orderscore_attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.premiseassociation_attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.ProfileBoosterAttributes_attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.Riskview2_attr.idxKeyName);

// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.riskviewalertcode_Attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.RiskViewAttributes_attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.RiskViewReport_attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.SmallBusinessAnalytics_attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.SmallBusinessBipCombinedReport_attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.SmallBusinessMarketingAttributes_attr .idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.verification_attr.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.attributes.VerificationOfOccupancy_attr.idxKeyName);

// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.key_scorelogs_scout_bus_name.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.key_scorelogs_scout_citystzip.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.key_scorelogs_scout_companyID.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.key_scorelogs_scout_loginID.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.key_scorelogs_scout_names.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.key_scorelogs_scout_transactionID.idxKeyName);

// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.key_scorelogs_XMLintermediate.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.key_scorelogs_XMLtransactionID.idxKeyName)


// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.key_scorelogs_scout_ESP_method.idxKeyName);
// moveFromWrongMonthlyToProperMonthly(scout.logs.keys.key_scorelogs_scout_industry.idxKeyName);

);
// moveFilesFromDailyToMontlhy(scout.logs.keys.key_scorelogs_scout_bus_name.idxKeyName);