#workunit('name', 'FraudPoint_Pull_SCOUT_Logs');
#STORED('historyfreq', '7yrs');
IMPORT scout, STD;

Product := 'FraudPoint';
//Date is in format YYYYMMDD HHMMSS
BeginDate := '20190201';
EndDate := '20190201';
eyeball := 100;

AccountIDs := ['']; // Set to a blank string dataset [''] to pull all records except for test transaction login ids

outputFile := '~fallen::out::FraudPoint_SCOUT_' + BeginDate + '-' + EndDate + '_' + AccountIDs[1];

BaseScoutFile := scout.logs.keys.key_scorelogs_scout_transactionID.superFileData();
BaseLogFile := scout.logs.keys.key_scorelogs_XMLTransactionID.superFileData();

Pulled_ScoutFile := distribute(pull(BaseScoutFile));

ScoutFile_Raw := IF(AccountIDs[1] != '', Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['FRAUDPOINT'] AND datetime[1..8] BETWEEN BeginDate AND EndDate AND (string)company_id IN AccountIDs AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs),
									     Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['FRAUDPOINT'] AND datetime[1..8] BETWEEN BeginDate AND EndDate AND STD.Str.ToLowerCase(TRIM(login_id)) NOT IN scout.ad_hoc_reporting.constants.IgnoredLogins AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs));

//Get only the XML transactions that match the scout key filter
Slim_LogFile := JOIN(ScoutFile_Raw, BaseLogFile, left.Transaction_ID = right.Transaction_ID, TRANSFORM(recordof(BaseLogFile), self := right));

//Process the xml and clean the tags
Clean_xml_recs := scout.ad_hoc_reporting.common.ProcessRawXML(ScoutFile_Raw, Slim_LogFile, Product);
// OUTPUT(CHOOSEN(Clean_xml_recs, eyeball), NAMED('Sample_Clean_xml_recs'));
// Output(count(Clean_xml_recs), NAMED('Clean_xml_recs_count'));

//Filter out bad xml recs so the job doesn't crash
Good_Logs := Clean_xml_recs(validinputxml and validoutputxml);
OUTPUT(CHOOSEN(Good_Logs, eyeball), NAMED('Sample_Good_Logs'));
OUTPUT(count(Good_Logs), NAMED('Good_Logs_count'));

//For trouble shooting if need to find bad xml recs
// Bad_Logs := Clean_xml_recs(~validinputxml or ~validoutputxml);
// OUTPUT(CHOOSEN(Bad_Logs, eyeball), NAMED('Sample_Bad_Logs'));
// OUTPUT(count(Bad_Logs), NAMED('Bad_Logs_count'));

scout.ad_hoc_reporting.layouts.Parsed_FraudAdvisor_Layout parseInput () := TRANSFORM
	SELF.TransactionID      := TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
	SELF.EndUserCompanyName := TRIM(XMLTEXT('User/EndUser/CompanyName'));
	SELF.FirstName          := TRIM(XMLTEXT('SearchBy/Name/First'));
	SELF.LastName           := TRIM(XMLTEXT('SearchBy/Name/Last'));
	SELF.SSN                := scout.ad_hoc_reporting.Common.ParseSSN(XMLTEXT('SearchBy/SSN'));
	SELF.DOB                := TRIM(XMLTEXT('SearchBy/DOB')) + scout.ad_hoc_reporting.Common.ParseDate(XMLTEXT('SearchBy/DOB/Year'), XMLTEXT('SearchBy/DOB/Month'), XMLTEXT('SearchBy/DOB/Day'));
	SELF.Address            := scout.ad_hoc_reporting.Common.ParseAddress(XMLTEXT('SearchBy/Address/StreetAddress1'), XMLTEXT('SearchBy/Address/StreetAddress2'), XMLTEXT('SearchBy/Address/StreetNumber'),
                                                                          XMLTEXT('SearchBy/Address/StreetPreDirection'), XMLTEXT('SearchBy/Address/StreetName'), XMLTEXT('SearchBy/Address/StreetSuffix'),
                                                                          XMLTEXT('SearchBy/Address/StreetPostDirection'), XMLTEXT('SearchBy/Address/UnitDesignation'), XMLTEXT('SearchBy/Address/UnitNumber'));
	SELF.City               := TRIM(XMLTEXT('SearchBy/Address/City'));
	SELF.State              := TRIM(XMLTEXT('SearchBy/Address/State'));
	SELF.Zip                := scout.ad_hoc_reporting.Common.ParseZIP(XMLTEXT('SearchBy/Address/Zip5'));
	SELF.DL                 := TRIM(XMLTEXT('SearchBy/DriverLicenseNumber'));
	// SELF.DLState			:= TRIM(XMLTEXT('SearchBy/DriverLicenseState'));
	SELF.HomePhone          := scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/Phone10'));
	SELF.WorkPhone          := scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/WPhone10'));
	SELF.Email              := TRIM(XMLTEXT('SearchBy/Email'));
	SELF.IPAddress          := TRIM(XMLTEXT('SearchBy/IPAddress'));
	
	SELF.OptionName1    := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelName/ModelOptions[1]/ModelOption[1]/OptionName'));
	SELF.OptionValue1   := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[1]/OptionValue'));
	SELF.OptionName2    := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[2]/OptionName'));
	SELF.OptionValue2   := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[2]/OptionValue'));
	SELF.OptionName3    := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[3]/OptionName'));
	SELF.OptionValue3   := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[3]/OptionValue'));
	SELF.OptionName4    := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[4]/OptionName'));
	SELF.OptionValue4   := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[4]/OptionValue'));
	SELF.OptionName5    := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[5]/OptionName'));
	SELF.OptionValue5   := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[5]/OptionValue'));
	SELF.OptionName6    := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[6]/OptionName'));
	SELF.OptionValue6   := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[6]/OptionValue'));
	SELF.OptionName7    := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[7]/OptionName'));
	SELF.OptionValue7   := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[7]/OptionValue'));
	SELF.OptionName8    := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[8]/OptionName'));
	SELF.OptionValue8   := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[8]/OptionValue'));
	SELF.OptionName9    := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[9]/OptionName'));
	SELF.OptionValue9   := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[9]/OptionValue'));
	SELF.OptionName10   := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[10]/OptionName'));
	SELF.OptionValue10  := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[10]/OptionValue'));
	
	SELF := [];
END;
parsedInput := DISTRIBUTE(PARSE(Good_Logs, inputxml, parseInput(), XML('FraudPoint')), HASH64(TransactionID));
OUTPUT(CHOOSEN(parsedInput, eyeball), NAMED('Sample_Parsed_Input'));

Parsed_Layout_Temp := RECORD
	scout.ad_hoc_reporting.Layouts.Parsed_FraudAdvisor_Layout;  
  
	STRING3 Score1 := '';
	STRING3 Score2 := '';
	STRING3 Score3 := '';
	STRING3 Score4 := '';
	STRING3 Score5 := '';
	STRING3 Score6 := '';
	STRING3 Score7 := '';
	STRING3 Score8 := '';
	STRING3 Score9 := '';
	STRING3 Score10 := '';
	
	STRING15 Model1 := '';
	STRING15 Model2 := '';
	STRING15 Model3 := '';
	STRING15 Model4 := '';
	STRING15 Model5 := '';
	STRING15 Model6 := '';
	STRING15 Model7 := '';
	STRING15 Model8 := '';
	STRING15 Model9 := '';
	STRING15 Model10 := '';
	
	STRING5 RC1_1	:= '';
	STRING5 RC1_2	:= '';
	STRING5 RC1_3	:= '';
	STRING5 RC1_4	:= '';
	STRING5 RC1_5	:= '';
	STRING5 RC1_6	:= '';
	STRING5 RC1_7	:= '';
	STRING5 RC1_8	:= '';
	STRING5 RC1_9	:= '';
	STRING5 RC1_10  := '';
	STRING5 RC2_1	:= '';
	STRING5 RC2_2	:= '';
	STRING5 RC2_3	:= '';
	STRING5 RC2_4	:= '';
	STRING5 RC2_5	:= '';
	STRING5 RC2_6	:= '';
	STRING5 RC2_7	:= '';
	STRING5 RC2_8	:= '';
	STRING5 RC2_9	:= '';
	STRING5 RC2_10	:= '';
	STRING5 RC3_1	:= '';
	STRING5 RC3_2	:= '';
	STRING5 RC3_3	:= '';
	STRING5 RC3_4	:= '';
	STRING5 RC3_5	:= '';
	STRING5 RC3_6	:= '';
	STRING5 RC3_7	:= '';
	STRING5 RC3_8	:= '';
	STRING5 RC3_9	:= '';
	STRING5 RC3_10	:= '';
	STRING5 RC4_1	:= '';
	STRING5 RC4_2	:= '';
	STRING5 RC4_3	:= '';
	STRING5 RC4_4	:= '';
	STRING5 RC4_5	:= '';
	STRING5 RC4_6	:= '';
	STRING5 RC4_7	:= '';
	STRING5 RC4_8	:= '';
	STRING5 RC4_9	:= '';
	STRING5 RC4_10	:= '';
	STRING5 RC5_1	:= '';
	STRING5 RC5_2	:= '';
	STRING5 RC5_3	:= '';
	STRING5 RC5_4	:= '';
	STRING5 RC5_5	:= '';
	STRING5 RC5_6	:= '';
	STRING5 RC5_7	:= '';
	STRING5 RC5_8	:= '';
	STRING5 RC5_9	:= '';
	STRING5 RC5_10	:= '';
	STRING5 RC6_1	:= '';
	STRING5 RC6_2	:= '';
	STRING5 RC6_3	:= '';
	STRING5 RC6_4	:= '';
	STRING5 RC6_5	:= '';
	STRING5 RC6_6	:= '';
	STRING5 RC6_7	:= '';
	STRING5 RC6_8	:= '';
	STRING5 RC6_9	:= '';
	STRING5 RC6_10	:= '';
	STRING5 RC7_1	:= '';
	STRING5 RC7_2	:= '';
	STRING5 RC7_3	:= '';
	STRING5 RC7_4	:= '';
	STRING5 RC7_5	:= '';
	STRING5 RC7_6	:= '';
	STRING5 RC7_7	:= '';
	STRING5 RC7_8	:= '';
	STRING5 RC7_9	:= '';
	STRING5 RC7_10	:= '';
	STRING5 RC8_1	:= '';
	STRING5 RC8_2	:= '';
	STRING5 RC8_3	:= '';
	STRING5 RC8_4	:= '';
	STRING5 RC8_5	:= '';
	STRING5 RC8_6	:= '';
	STRING5 RC8_7	:= '';
	STRING5 RC8_8	:= '';
	STRING5 RC8_9	:= '';
	STRING5 RC8_10	:= '';
	STRING5 RC9_1	:= '';
	STRING5 RC9_2	:= '';
	STRING5 RC9_3	:= '';
	STRING5 RC9_4	:= '';
	STRING5 RC9_5	:= '';
	STRING5 RC9_6	:= '';
	STRING5 RC9_7	:= '';
	STRING5 RC9_8	:= '';
	STRING5 RC9_9	:= '';
	STRING5 RC9_10	:= '';
	STRING5 RC10_1	:= '';
	STRING5 RC10_2	:= '';
	STRING5 RC10_3	:= '';
	STRING5 RC10_4	:= '';
	STRING5 RC10_5	:= '';
	STRING5 RC10_6	:= '';
	STRING5 RC10_7	:= '';
	STRING5 RC10_8	:= '';
	STRING5 RC10_9	:= '';
	STRING5 RC10_10	:= '';
END;

Parsed_Layout_Temp parseOutput () := TRANSFORM
	SELF.TransactionID	:= TRIM(XMLTEXT('Header/TransactionId')); // Forced into the record so I can join it all together
	
    SELF.StolenIdentityIndex      := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndices[1]/RiskIndex[1]/Value'));
    SELF.SyntheticIdentityIndex   := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndices[1]/RiskIndex[2]/Value'));
    SELF.ManipulatedIdentityIndex := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndices[1]/RiskIndex[3]/Value'));
    SELF.VulnerableVictimIndex    := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndices[1]/RiskIndex[4]/Value'));
    SELF.FriendlyFraudIndex       := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndices[1]/RiskIndex[5]/Value'));
    SELF.SuspiciousActivityIndex  := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndices[1]/RiskIndex[6]/Value'));
  
	SELF.Score1					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/Value'));
	SELF.Score2					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/Value'));
	SELF.Score3					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/Value'));
	SELF.Score4					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/Value'));
	SELF.Score5					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/Value'));
	SELF.Score6					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/Value'));
	SELF.Score7					:= TRIM(XMLTEXT('Result/Models[1]/Model[7]/Scores[1]/Score[1]/Value'));
	SELF.Score8					:= TRIM(XMLTEXT('Result/Models[1]/Model[8]/Scores[1]/Score[1]/Value'));
	SELF.Score9					:= TRIM(XMLTEXT('Result/Models[1]/Model[9]/Scores[1]/Score[1]/Value'));
	SELF.Score10				:= TRIM(XMLTEXT('Result/Models[1]/Model[10]/Scores[1]/Score[1]/Value'));
	
	SELF.Model1					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/Type'));
	SELF.Model2					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/Type'));
	SELF.Model3					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/Type'));
	SELF.Model4					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/Type'));
	SELF.Model5					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/Type'));
	SELF.Model6					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/Type'));
	SELF.Model7					:= TRIM(XMLTEXT('Result/Models[1]/Model[7]/Scores[1]/Score[1]/Type'));
	SELF.Model8					:= TRIM(XMLTEXT('Result/Models[1]/Model[8]/Scores[1]/Score[1]/Type'));
	SELF.Model9					:= TRIM(XMLTEXT('Result/Models[1]/Model[9]/Scores[1]/Score[1]/Type'));
	SELF.Model10				:= TRIM(XMLTEXT('Result/Models[1]/Model[10]/Scores[1]/Score[1]/Type'));
	
	SELF.RC1_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[1]/RiskCode'));
	SELF.RC1_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[2]/RiskCode'));
	SELF.RC1_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[3]/RiskCode'));
	SELF.RC1_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[4]/RiskCode'));
	SELF.RC1_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[5]/RiskCode'));
	SELF.RC1_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[6]/RiskCode'));
	SELF.RC1_7					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[7]/RiskCode'));
	SELF.RC1_8					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[8]/RiskCode'));
	SELF.RC1_9					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[9]/RiskCode'));
	SELF.RC1_10					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[10]/RiskCode'));
	
	SELF.RC2_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[1]/RiskCode'));
	SELF.RC2_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[2]/RiskCode'));
	SELF.RC2_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[3]/RiskCode'));
	SELF.RC2_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[4]/RiskCode'));
	SELF.RC2_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[5]/RiskCode'));
	SELF.RC2_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[6]/RiskCode'));
	SELF.RC2_7					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[7]/RiskCode'));
	SELF.RC2_8					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[8]/RiskCode'));
	SELF.RC2_9					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[9]/RiskCode'));
	SELF.RC2_10					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[10]/RiskCode'));
	
	SELF.RC3_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[1]/RiskCode'));
	SELF.RC3_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[2]/RiskCode'));
	SELF.RC3_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[3]/RiskCode'));
	SELF.RC3_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[4]/RiskCode'));
	SELF.RC3_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[5]/RiskCode'));
	SELF.RC3_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[6]/RiskCode'));
	SELF.RC3_7					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[7]/RiskCode'));
	SELF.RC3_8					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[8]/RiskCode'));
	SELF.RC3_9					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[9]/RiskCode'));
	SELF.RC3_10					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[10]/RiskCode'));
	
	SELF.RC4_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[1]/RiskCode'));
	SELF.RC4_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[2]/RiskCode'));
	SELF.RC4_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[3]/RiskCode'));
	SELF.RC4_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[4]/RiskCode'));
	SELF.RC4_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[5]/RiskCode'));
	SELF.RC4_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[6]/RiskCode'));
	SELF.RC4_7					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[7]/RiskCode'));
	SELF.RC4_8					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[8]/RiskCode'));
	SELF.RC4_9					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[9]/RiskCode'));
	SELF.RC4_10					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[10]/RiskCode'));
	
	SELF.RC5_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[1]/RiskCode'));
	SELF.RC5_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[2]/RiskCode'));
	SELF.RC5_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[3]/RiskCode'));
	SELF.RC5_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[4]/RiskCode'));
	SELF.RC5_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[5]/RiskCode'));
	SELF.RC5_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[6]/RiskCode'));
	SELF.RC5_7					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[7]/RiskCode'));
	SELF.RC5_8					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[8]/RiskCode'));
	SELF.RC5_9					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[9]/RiskCode'));
	SELF.RC5_10					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[10]/RiskCode'));
	
	SELF.RC6_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[1]/RiskCode'));
	SELF.RC6_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[2]/RiskCode'));
	SELF.RC6_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[3]/RiskCode'));
	SELF.RC6_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[4]/RiskCode'));
	SELF.RC6_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[5]/RiskCode'));
	SELF.RC6_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[6]/RiskCode'));
	SELF.RC6_7					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[7]/RiskCode'));
	SELF.RC6_8					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[8]/RiskCode'));
	SELF.RC6_9					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[9]/RiskCode'));
	SELF.RC6_10					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[10]/RiskCode'));
	
	SELF.RC7_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[7]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[1]/RiskCode'));
	SELF.RC7_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[7]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[2]/RiskCode'));
	SELF.RC7_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[7]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[3]/RiskCode'));
	SELF.RC7_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[7]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[4]/RiskCode'));
	SELF.RC7_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[7]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[5]/RiskCode'));
	SELF.RC7_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[7]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[6]/RiskCode'));
	SELF.RC7_7					:= TRIM(XMLTEXT('Result/Models[1]/Model[7]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[7]/RiskCode'));
	SELF.RC7_8					:= TRIM(XMLTEXT('Result/Models[1]/Model[7]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[8]/RiskCode'));
	SELF.RC7_9					:= TRIM(XMLTEXT('Result/Models[1]/Model[7]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[9]/RiskCode'));
	SELF.RC7_10					:= TRIM(XMLTEXT('Result/Models[1]/Model[7]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[10]/RiskCode'));
	
	SELF.RC8_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[8]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[1]/RiskCode'));
	SELF.RC8_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[8]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[2]/RiskCode'));
	SELF.RC8_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[8]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[3]/RiskCode'));
	SELF.RC8_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[8]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[4]/RiskCode'));
	SELF.RC8_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[8]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[5]/RiskCode'));
	SELF.RC8_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[8]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[6]/RiskCode'));
	SELF.RC8_7					:= TRIM(XMLTEXT('Result/Models[1]/Model[8]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[7]/RiskCode'));
	SELF.RC8_8					:= TRIM(XMLTEXT('Result/Models[1]/Model[8]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[8]/RiskCode'));
	SELF.RC8_9					:= TRIM(XMLTEXT('Result/Models[1]/Model[8]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[9]/RiskCode'));
	SELF.RC8_10					:= TRIM(XMLTEXT('Result/Models[1]/Model[8]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[10]/RiskCode'));
	
	SELF.RC9_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[9]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[1]/RiskCode'));
	SELF.RC9_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[9]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[2]/RiskCode'));
	SELF.RC9_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[9]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[3]/RiskCode'));
	SELF.RC9_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[9]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[4]/RiskCode'));
	SELF.RC9_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[9]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[5]/RiskCode'));
	SELF.RC9_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[9]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[6]/RiskCode'));
	SELF.RC9_7					:= TRIM(XMLTEXT('Result/Models[1]/Model[9]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[7]/RiskCode'));
	SELF.RC9_8					:= TRIM(XMLTEXT('Result/Models[1]/Model[9]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[8]/RiskCode'));
	SELF.RC9_9					:= TRIM(XMLTEXT('Result/Models[1]/Model[9]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[9]/RiskCode'));
	SELF.RC9_10					:= TRIM(XMLTEXT('Result/Models[1]/Model[9]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[10]/RiskCode'));
	
	SELF.RC10_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[10]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[1]/RiskCode'));
	SELF.RC10_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[10]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[2]/RiskCode'));
	SELF.RC10_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[10]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[3]/RiskCode'));
	SELF.RC10_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[10]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[4]/RiskCode'));
	SELF.RC10_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[10]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[5]/RiskCode'));
	SELF.RC10_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[10]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[6]/RiskCode'));
	SELF.RC10_7					:= TRIM(XMLTEXT('Result/Models[1]/Model[10]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[7]/RiskCode'));
	SELF.RC10_8					:= TRIM(XMLTEXT('Result/Models[1]/Model[10]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[8]/RiskCode'));
	SELF.RC10_9					:= TRIM(XMLTEXT('Result/Models[1]/Model[10]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[9]/RiskCode'));
	SELF.RC10_10				:= TRIM(XMLTEXT('Result/Models[1]/Model[10]/Scores[1]/Score[1]/RiskIndicators[1]/RiskIndicator[10]/RiskCode'));
	
	SELF := [];
END;
parsedOutputTemp := PARSE(Good_Logs, outputxml, parseOutput(), XML('FraudPoint'));
OUTPUT(CHOOSEN(parsedOutputTemp, eyeball), NAMED('Sample_Parsed_Output'));

scout.ad_hoc_reporting.Layouts.Parsed_FraudAdvisor_Layout normScores(Parsed_Layout_Temp le, UNSIGNED1 t) := TRANSFORM
	SELF.Score := CASE(t,
		1 => le.Score1,
		2 => le.Score2,
		3 => le.Score3,
		4 => le.Score4,
		5 => le.Score5,
		6 => le.Score6,
		7 => le.Score7,
		8 => le.Score8,
		9 => le.Score9,
		10 => le.Score10,
		'');
	SELF.Model := CASE(t,
		1 => le.Model1,
		2 => le.Model2,
		3 => le.Model3,
		4 => le.Model4,
		5 => le.Model5,
		6 => le.Model6,
		7 => le.Model7,
		8 => le.Model8,
		9 => le.Model9,
		10 => le.Model10,
		'');
		
	SELF.RC1 := CASE(t,
		1		=> le.RC1_1,
		2		=> le.RC2_1,
		3		=> le.RC3_1,
		4		=> le.RC4_1,
		5		=> le.RC5_1,
		6		=> le.RC6_1,
		7		=> le.RC7_1,
		8		=> le.RC8_1,
		9		=> le.RC9_1,
		10	=> le.RC10_1,
		'');

	SELF.RC2 := CASE(t,
		1		=> le.RC1_2,
		2		=> le.RC2_2,
		3		=> le.RC3_2,
		4		=> le.RC4_2,
		5		=> le.RC5_2,
		6		=> le.RC6_2,
		7		=> le.RC7_2,
		8		=> le.RC8_2,
		9		=> le.RC9_2,
		10	=> le.RC10_2,
		'');
	
	SELF.RC3 := CASE(t,
		1		=> le.RC1_3,
		2		=> le.RC2_3,
		3		=> le.RC3_3,
		4		=> le.RC4_3,
		5		=> le.RC5_3,
		6		=> le.RC6_3,
		7		=> le.RC7_3,
		8		=> le.RC8_3,
		9		=> le.RC9_3,
		10	=> le.RC10_3,
		'');
		
	SELF.RC4 := CASE(t,
		1		=> le.RC1_4,
		2		=> le.RC2_4,
		3		=> le.RC3_4,
		4		=> le.RC4_4,
		5		=> le.RC5_4,
		6		=> le.RC6_4,
		7		=> le.RC7_4,
		8		=> le.RC8_4,
		9		=> le.RC9_4,
		10	=> le.RC10_4,
		'');
		
	SELF.RC5 := CASE(t,
		1		=> le.RC1_5,
		2		=> le.RC2_5,
		3		=> le.RC3_5,
		4		=> le.RC4_5,
		5		=> le.RC5_5,
		6		=> le.RC6_5,
		7		=> le.RC7_5,
		8		=> le.RC8_5,
		9		=> le.RC9_5,
		10	=> le.RC10_5,
		'');
		
	SELF.RC6 := CASE(t,
		1		=> le.RC1_6,
		2		=> le.RC2_6,
		3		=> le.RC3_6,
		4		=> le.RC4_6,
		5		=> le.RC5_6,
		6		=> le.RC6_6,
		7		=> le.RC7_6,
		8		=> le.RC8_6,
		9		=> le.RC9_6,
		10	=> le.RC10_6,
		'');
		
	SELF.RC7 := CASE(t,
		1		=> le.RC1_7,
		2		=> le.RC2_7,
		3		=> le.RC3_7,
		4		=> le.RC4_7,
		5		=> le.RC5_7,
		6		=> le.RC6_7,
		7		=> le.RC7_7,
		8		=> le.RC8_7,
		9		=> le.RC9_7,
		10	=> le.RC10_7,
		'');
		
	SELF.RC8 := CASE(t,
		1		=> le.RC1_8,
		2		=> le.RC2_8,
		3		=> le.RC3_8,
		4		=> le.RC4_8,
		5		=> le.RC5_8,
		6		=> le.RC6_8,
		7		=> le.RC7_8,
		8		=> le.RC8_8,
		9		=> le.RC9_8,
		10	=> le.RC10_8,
		'');
		
	SELF.RC9 := CASE(t,
		1		=> le.RC1_9,
		2		=> le.RC2_9,
		3		=> le.RC3_9,
		4		=> le.RC4_9,
		5		=> le.RC5_9,
		6		=> le.RC6_9,
		7		=> le.RC7_9,
		8		=> le.RC8_9,
		9		=> le.RC9_9,
		10	=> le.RC10_9,
		'');
		
	SELF.RC10 := CASE(t,
		1		=> le.RC1_10,
		2		=> le.RC2_10,
		3		=> le.RC3_10,
		4		=> le.RC4_10,
		5		=> le.RC5_10,
		6		=> le.RC6_10,
		7		=> le.RC7_10,
		8		=> le.RC8_10,
		9		=> le.RC9_10,
		10	=> le.RC10_10,
		'');
		
	SELF := le;
END;

parsedOutput := NORMALIZE(parsedOutputTemp, 10, normScores(LEFT, COUNTER)) ((INTEGER)Score > 0); //Do we really want to filter off nonscore records?
OUTPUT(CHOOSEN(parsedOutput, eyeball), NAMED('Sample_Normalized_Output'));

scout.ad_hoc_reporting.Layouts.Parsed_FraudAdvisor_Layout combineParsedRecords(scout.ad_hoc_reporting.Layouts.Parsed_FraudAdvisor_Layout le, scout.ad_hoc_reporting.Layouts.Parsed_FraudAdvisor_Layout ri) := TRANSFORM
	
    SELF.StolenIdentityIndex := ri.StolenIdentityIndex;
    SELF.SyntheticIdentityIndex := ri.SyntheticIdentityIndex;
    SELF.ManipulatedIdentityIndex := ri.ManipulatedIdentityIndex;
    SELF.VulnerableVictimIndex := ri.VulnerableVictimIndex;
    SELF.FriendlyFraudIndex := ri.FriendlyFraudIndex;
    SELF.SuspiciousActivityIndex := ri.SuspiciousActivityIndex;  
    SELF.Score	:= ri.Score;
	SELF.Model	:= ri.Model;
	SELF.RC1		:= ri.RC1;
	SELF.RC2		:= ri.RC2;
	SELF.RC3		:= ri.RC3;
	SELF.RC4		:= ri.RC4;
	SELF.RC5		:= ri.RC5;
	SELF.RC6		:= ri.RC6;
	SELF.RC7		:= ri.RC7;
	SELF.RC8		:= ri.RC8;
	SELF.RC9		:= ri.RC9;
	SELF.RC10		:= ri.RC10;
	
	SELF := le;
END;

// Join the parsed input/output
parsedRecordsTemp := JOIN(DISTRIBUTE(parsedInput, HASH64(TransactionID)), DISTRIBUTE(parsedOutput, HASH64(TransactionID)), 
                        trim(LEFT.TransactionID,left,right) = trim(RIGHT.TransactionID,left,right),
                        combineParsedRecords(LEFT, RIGHT), KEEP(1), ATMOST(10), LOCAL);

// Join results back to original recs to get AccountID, LoginID, and TransactionDate
parsedRecords := JOIN(DISTRIBUTE(parsedRecordsTemp, HASH64(TransactionID)), DISTRIBUTE(Good_Logs, HASH64(TransactionID)), 
                    trim(LEFT.TransactionID,left,right) = trim(RIGHT.TransactionID,left,right),
                    TRANSFORM(RECORDOF(LEFT), 
                        SELF.TransactionDate := RIGHT.TransactionDate; 
                        SELF.AccountID := RIGHT.AccountID;
                        SELF.LoginID := RIGHT.LoginID;
                        SELF := LEFT), LOCAL);

OUTPUT(CHOOSEN(parsedRecords, eyeball), NAMED('Sample_Fully_Parsed_Records'));
OUTPUT(COUNT(parsedRecords), NAMED('Total_Final_Records'));

finalRecords := SORT(DISTRIBUTE(parsedRecords, HASH64(AccountID, TransactionDate, TransactionID)), AccountID, TransactionDate, TransactionID, LOCAL);
OUTPUT(CHOOSEN(finalRecords, eyeball), NAMED('Sample_Final_Records'));

OUTPUT(finalRecords,, outputFile + '_' + Std.system.Job.wuid() + '.csv', CSV(HEADING(single), QUOTE('"')), EXPIRE(30), OVERWRITE);

/* ***********************************************************************************************
 *************************************************************************************************
 *             MODIFY EVERYTHING BELOW AS NEEDED TO PERFORM SAOT ANALYSIS                        *
 *************************************************************************************************
 *********************************************************************************************** */
