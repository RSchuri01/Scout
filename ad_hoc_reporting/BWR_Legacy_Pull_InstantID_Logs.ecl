#workunit('name', 'Instant_ID_Pull_SCOUT_Logs');
#STORED('historyfreq', '7yrs');
IMPORT scout, STD;

Product := 'InstantID';
//Date is in format YYYYMMDD HHMMSS
BeginDate := '20190201';
EndDate := '20190201'; 
eyeball := 100;

AccountIDs := ['']; // Set to a blank string dataset [''] to pull all records except for test transaction login ids

outputFile := '~fallen::out::InstantID_SCOUT_' + BeginDate + '-' + EndDate + '_' + AccountIDs[1];

BaseScoutFile := scout.logs.keys.key_scorelogs_scout_transactionID.superFileData();
BaseLogFile := scout.logs.keys.key_scorelogs_XMLTransactionID.superFileData();

Pulled_ScoutFile := distribute(pull(BaseScoutFile));

ScoutFile_Raw := IF(AccountIDs[1] != '', Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['INSTANTID', 'INSTANTIDMODEL'] AND datetime[1..8] BETWEEN BeginDate AND EndDate AND (string)company_id IN AccountIDs AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs),
									     Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['INSTANTID', 'INSTANTIDMODEL'] AND datetime[1..8] BETWEEN BeginDate AND EndDate AND STD.Str.ToLowerCase(TRIM(login_id)) NOT IN scout.ad_hoc_reporting.constants.IgnoredLogins AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs));

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

scout.ad_hoc_reporting.Layouts.Parsed_InstantID_Layout parseInput () := TRANSFORM
	SELF.TransactionID      := TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
	SELF.EndUserCompanyName := TRIM(XMLTEXT('User/EndUser/CompanyName'));
	SELF.ReferenceCode      := TRIM(XMLTEXT('User/ReferenceCode'));
	SELF.LoadAmount         := MAP(STD.STR.ToLowerCase(TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest[1]/ModelOptions/ModelOption[1]/OptionName')))= 'loadamount' => TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest/ModelOptions/ModelOption[1]/OptionValue')),
                                    STD.STR.ToLowerCase(TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest[1]/ModelOptions/ModelOption[2]/OptionName')))= 'loadamount' => TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest/ModelOptions/ModelOption[2]/OptionValue')),
                                    STD.STR.ToLowerCase(TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest[1]/ModelOptions/ModelOption[3]/OptionName')))= 'loadamount' => TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest/ModelOptions/ModelOption[3]/OptionValue')),
                                    STD.STR.ToLowerCase(TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest[1]/ModelOptions/ModelOption[4]/OptionName')))= 'loadamount' => TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest/ModelOptions/ModelOption[4]/OptionValue')),
                                    '');
	SELF.RetailZip          := MAP(STD.STR.ToLowerCase(TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest[1]/ModelOptions/ModelOption[1]/OptionName')))= 'retailzip' => TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest/ModelOptions/ModelOption[1]/OptionValue')),
                                    STD.STR.ToLowerCase(TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest[1]/ModelOptions/ModelOption[2]/OptionName')))= 'retailzip' => TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest/ModelOptions/ModelOption[2]/OptionValue')),
                                    STD.STR.ToLowerCase(TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest[1]/ModelOptions/ModelOption[3]/OptionName')))= 'retailzip' => TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest/ModelOptions/ModelOption[3]/OptionValue')),
                                    STD.STR.ToLowerCase(TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest[1]/ModelOptions/ModelOption[4]/OptionName')))= 'retailzip' => TRIM(XMLTEXT('Options/IncludeModels/ModelRequests/ModelRequest/ModelOptions/ModelOption[4]/OptionValue')),
                                    '');

	SELF.OptionName1    := TRIM(XMLTEXT('Options/IncludeModels/ModelRequests[1]/ModelRequest[1]/ModelOptions[1]/ModelOption[1]/OptionName'));
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
	
	SELF.FirstName  := TRIM(XMLTEXT('SearchBy/Name/First'));
	SELF.LastName   := TRIM(XMLTEXT('SearchBy/Name/Last'));
	SELF.FullName   := TRIM(XMLTEXT('SearchBy/Name/Full'));
	FullSSN         := scout.ad_hoc_reporting.Common.ParseSSN(XMLTEXT('SearchBy/SSN'));
	SSNLast4        := scout.ad_hoc_reporting.Common.ParseSSN(XMLTEXT('SearchBy/SSNLast4'), 4);
	SELF.SSN        := IF(FullSSN <> '', FullSSN, SSNLast4);
	SELF.DOB        := TRIM(XMLTEXT('SearchBy/DOB')) + scout.ad_hoc_reporting.Common.ParseDate(XMLTEXT('SearchBy/DOB/Year'), XMLTEXT('SearchBy/DOB/Month'), XMLTEXT('SearchBy/DOB/Day'));
	SELF.Address    := scout.ad_hoc_reporting.Common.ParseAddress(XMLTEXT('SearchBy/Address/StreetAddress1'), XMLTEXT('SearchBy/Address/StreetAddress2'), XMLTEXT('SearchBy/Address/StreetNumber'),
                                                                  XMLTEXT('SearchBy/Address/StreetPreDirection'), XMLTEXT('SearchBy/Address/StreetName'), XMLTEXT('SearchBy/Address/StreetSuffix'),
                                                                  XMLTEXT('SearchBy/Address/StreetPostDirection'), XMLTEXT('SearchBy/Address/UnitDesignation'), XMLTEXT('SearchBy/Address/UnitNumber'));
	SELF.City       := TRIM(XMLTEXT('SearchBy/Address/City'));
	SELF.State      := TRIM(XMLTEXT('SearchBy/Address/State'));
	SELF.Zip        := scout.ad_hoc_reporting.Common.ParseZIP(XMLTEXT('SearchBy/Address/Zip5'));
	SELF.DL         := TRIM(XMLTEXT('SearchBy/DriverLicenseNumber'));
	SELF.DLState    := TRIM(XMLTEXT('SearchBy/DriverLicenseState'));
	SELF.HomePhone  := scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/HomePhone'));
	SELF.WorkPhone  := scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/WorkPhone'));
	SELF := [];
END;

parsedInput := DISTRIBUTE(PARSE(Good_Logs, inputxml, parseInput(), XML('InstantID')), HASH64(TransactionID));
OUTPUT(CHOOSEN(parsedInput, eyeball), NAMED('Sample_Parsed_Input'));

scout.ad_hoc_reporting.Layouts.Parsed_InstantID_Layout parseOutput () := TRANSFORM
	SELF.TransactionID  := TRIM(XMLTEXT('Header/TransactionId')); // Forced into the record so I can join it all together
	ModelName           := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/Type'));
	CVIModel            := STD.STR.ToUpperCase(ModelName) = 'CVI';
	SELF.CVI            := Map(CVIModel => TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/Value')),// Instant ID Model
                                            TRIM(XMLTEXT('Result/ComprehensiveVerificationIndex')) + // Instant ID
                                            TRIM(XMLTEXT('Result/ComprehensiveVerification/ComprehensiveVerificationIndex')));

	SELF.NAP            := TRIM(XMLTEXT('Result/NameAddressPhone[1]/Summary'));
	SELF.NAS            := TRIM(XMLTEXT('Result/NameAddressSSNSummary'));
    FPModelName         := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Name'));
    IsFPModel           := IF(STD.STR.ToUpperCase(FPModelName) IN ['FRAUDDEFENDER', 'FRAUDPOINT'], TRUE, FALSE);
    SELF.FraudPointScore    := IF(IsFPModel, TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/Value')), '');
    SELF.FraudPointRC1  :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators/RiskIndicator[1]/RiskCode'));
	SELF.FraudPointRC2  :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators/RiskIndicator[2]/RiskCode'));
	SELF.FraudPointRC3  :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators/RiskIndicator[3]/RiskCode'));
	SELF.FraudPointRC4  :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators/RiskIndicator[4]/RiskCode'));
	SELF.FraudPointRC5  :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators/RiskIndicator[5]/RiskCode'));
	SELF.FraudPointRC6  :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicators/RiskIndicator[6]/RiskCode'));
	SELF.RiskIndex1     :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndices/RiskIndex[1]/Value'));
	SELF.RiskIndex2     :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndices/RiskIndex[2]/Value'));
	SELF.RiskIndex3     :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndices/RiskIndex[3]/Value'));
	SELF.RiskIndex4     :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndices/RiskIndex[4]/Value'));
	SELF.RiskIndex5     :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndices/RiskIndex[5]/Value'));
	SELF.RiskIndex6     :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndices/RiskIndex[6]/Value'));

	SELF.RC1    := Map(CVIModel => TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/HighRiskIndicators[1]/HighRiskIndicator[1]/RiskCode')),
                                    TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[1]/RiskCode')) + 
                                    TRIM(XMLTEXT('Result/ComprehensiveVerification/RiskIndicators[1]/RiskIndicator[1]/RiskCode')));

	SELF.RC2    := Map(CVIModel => TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/HighRiskIndicators[1]/HighRiskIndicator[2]/RiskCode')),
                                    TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[2]/RiskCode')) + 
                                    TRIM(XMLTEXT('Result/ComprehensiveVerification/RiskIndicators[1]/RiskIndicator[2]/RiskCode')));

	SELF.RC3    := Map(CVIModel => TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/HighRiskIndicators[1]/HighRiskIndicator[3]/RiskCode')),
                                    TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[3]/RiskCode')) + 
                                    TRIM(XMLTEXT('Result/ComprehensiveVerification/RiskIndicators[1]/RiskIndicator[3]/RiskCode')));

	SELF.RC4    := Map(CVIModel => TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/HighRiskIndicators[1]/HighRiskIndicator[4]/RiskCode')),
                                    TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[4]/RiskCode')) + 
                                    TRIM(XMLTEXT('Result/ComprehensiveVerification/RiskIndicators[1]/RiskIndicator[4]/RiskCode')));

	SELF.RC5    := Map(CVIModel => TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/HighRiskIndicators[1]/HighRiskIndicator[5]/RiskCode')),
                                    TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[5]/RiskCode')) + 
                                    TRIM(XMLTEXT('Result/ComprehensiveVerification/RiskIndicators[1]/RiskIndicator[5]/RiskCode')));

	SELF.RC6    := Map(CVIModel => TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/HighRiskIndicators[1]/HighRiskIndicator[6]/RiskCode')),
                                    TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[6]/RiskCode')) + 
                                    TRIM(XMLTEXT('Result/ComprehensiveVerification/RiskIndicators[1]/RiskIndicator[6]/RiskCode')));

	SELF.RC7    := Map(CVIModel => TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/HighRiskIndicators[1]/HighRiskIndicator[7]/RiskCode')),
                                    TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[7]/RiskCode')) + 
                                    TRIM(XMLTEXT('Result/ComprehensiveVerification/RiskIndicators[1]/RiskIndicator[7]/RiskCode')));

	SELF.RC8    := Map(CVIModel => TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/HighRiskIndicators[1]/HighRiskIndicator[8]/RiskCode')),
                                    TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[8]/RiskCode')) + 
                                    TRIM(XMLTEXT('Result/ComprehensiveVerification/RiskIndicators[1]/RiskIndicator[8]/RiskCode')));

	SELF.RC9    := Map(CVIModel => TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/HighRiskIndicators[1]/HighRiskIndicator[9]/RiskCode')),
                                    TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[9]/RiskCode')) + 
                                    TRIM(XMLTEXT('Result/ComprehensiveVerification/RiskIndicators[1]/RiskIndicator[9]/RiskCode')));

	SELF.RC10   := Map(CVIModel => TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/HighRiskIndicators[1]/HighRiskIndicator[10]/RiskCode')),
                                    TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[10]/RiskCode')) + 
                                    TRIM(XMLTEXT('Result/ComprehensiveVerification/RiskIndicators[1]/RiskIndicator[10]/RiskCode')));
	SELF := [];
END;

parsedOutputTemp := PARSE(Good_Logs, outputxml, parseOutput(), XML('InstantID'));
OUTPUT(CHOOSEN(parsedOutputTemp, eyeball), NAMED('parsedOutputTemp'));
										
scout.ad_hoc_reporting.Layouts.Parsed_InstantID_Layout normScores(scout.ad_hoc_reporting.Layouts.Parsed_InstantID_Layout le, UNSIGNED1 t) := TRANSFORM
	SELF.CVI := CASE(t,
		1 => le.CVI,
		'');

	SELF.NAP := CASE(t,
		1 => le.NAP,
		'');

	SELF.NAS := CASE(t,
		1 => le.NAS,
		'');

	SELF.RC1 := CASE(t,
		1		=> le.RC1,
		'');

	SELF.RC2 := CASE(t,
		1		=> le.RC2,
		'');
	
	SELF.RC3 := CASE(t,
		1		=> le.RC3,
		'');
		
	SELF.RC4 := CASE(t,
		1		=> le.RC4,
		'');
		
	SELF.RC5 := CASE(t,
		1		=> le.RC5,
		'');
		
	SELF.RC6 := CASE(t,
		1		=> le.RC6,
		'');
		
	SELF.RC7 := CASE(t,
		1		=> le.RC7,
		'');
		
	SELF.RC8 := CASE(t,
		1		=> le.RC8,
		'');
		
	SELF.RC9 := CASE(t,
		1		=> le.RC9,
		'');
		
	SELF.RC10 := CASE(t,
		1		=> le.RC10,
		'');
		
	SELF := le;
END;

parsedOutput:= NORMALIZE(parsedOutputTemp, 1, normScores(LEFT, COUNTER));
OUTPUT(CHOOSEN(parsedOutput, eyeball), NAMED('Sample_Normalized_Output'));

scout.ad_hoc_reporting.Layouts.Parsed_InstantID_Layout combineParsedRecords(scout.ad_hoc_reporting.Layouts.Parsed_InstantID_Layout le, scout.ad_hoc_reporting.Layouts.Parsed_InstantID_Layout ri) := TRANSFORM
	SELF.CVI    := ri.CVI;
	SELF.NAP    := ri.NAP;
	SELF.NAS    := ri.NAS;
	SELF.RC1    := ri.RC1;
	SELF.RC2    := ri.RC2;
	SELF.RC3    := ri.RC3;
	SELF.RC4    := ri.RC4;
	SELF.RC5    := ri.RC5;
	SELF.RC6    := ri.RC6;
	SELF.RC7    := ri.RC7;
	SELF.RC8    := ri.RC8;
	SELF.RC9    := ri.RC9;
	SELF.RC10   := ri.RC10;
	SELF.FraudPointScore    :=ri.FraudPointScore;
	SELF.FraudPointRC1  :=ri.FraudPointRC1;
	SELF.FraudPointRC2  :=ri.FraudPointRC2;
	SELF.FraudPointRC3  :=ri.FraudPointRC3;
	SELF.FraudPointRC4  :=ri.FraudPointRC4;
	SELF.FraudPointRC5  :=ri.FraudPointRC5;
	SELF.FraudPointRC6  :=ri.FraudPointRC6;
	SELF.RiskIndex1     :=ri.RiskIndex1;
	SELF.RiskIndex2     :=ri.RiskIndex2;
	SELF.RiskIndex3     :=ri.RiskIndex3;
	SELF.RiskIndex4     :=ri.RiskIndex4;
	SELF.RiskIndex5     :=ri.RiskIndex5;
	SELF.RiskIndex6     :=ri.RiskIndex6;
	
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
