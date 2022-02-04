#workunit('name', 'Instant_ID_Daily_Monitor_v2');
#OPTION('defaultSkewError', 1);

IMPORT STD, scout;

// Pull logs for the past year to do our rolling Average on
// currentDate := scout.common.util.dateutils.today;
EndDate := scout.common.util.dateutils.today;
BeginDateTemp := scout.common.util.dateutils.date_math(EndDate, -60);
// BeginDate :=  20200601; // Tracking didn't fully start until this date, eliminate the "test" days before this date.
BeginDate := IF(BeginDateTemp >= 20130512, BeginDateTemp, 20130512); // Tracking didn't fully start until this date, eliminate the "test" days before this date.
Product := 'InstantID';
eyeball := 100;
EndDate_string := (string)EndDate;
BeginDate_string := (string)BeginDate;

AccountIDs := ['']; // Set to a blank string dataset [''] to pull all records except for test transaction login ids
// esp_method := '';

/* ***********************************************************************************************
 *************************************************************************************************
 *             GATHER AND PARSE SCORE AND ATTRIBUTE OUTCOME TRACKING LOGS                        *
 *************************************************************************************************
 *********************************************************************************************** */


BaseScoutFile := scout.logs.keys.key_scorelogs_scout_transactionID.superFileData();
BaseLogFile := scout.logs.keys.key_scorelogs_XMLTransactionID.superFileData();

// Pulled_ScoutFile := distribute(pull(BaseScoutFile));

ScoutFile_Raw := IF(AccountIDs[1] != '', BaseScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['INSTANTID'] AND datetime[1..8] BETWEEN BeginDate_string AND EndDate_string AND (string)company_id IN AccountIDs AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs),
									 BaseScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['INSTANTID'] AND datetime[1..8] BETWEEN BeginDate_string AND EndDate_string AND STD.Str.ToLowerCase(TRIM(login_id)) NOT IN scout.ad_hoc_reporting.constants.IgnoredLogins AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs));

count(ScoutFile_Raw);

//Get only the XML transactions that match the scout key filter
Slim_LogFile := JOIN(ScoutFile_Raw, BaseLogFile, left.Transaction_ID = right.Transaction_ID, TRANSFORM(scout.logs.layout.base_transaction_online_key, self := right));

OUTPUT(CHOOSEN(Slim_LogFile, eyeball), NAMED('Sample_Slim_LogFile_IID'));

//Process the xml and clean the tags
Clean_xml_recs := scout.ad_hoc_reporting.common.ProcessRawXML(ScoutFile_Raw, Slim_LogFile, Product);
OUTPUT(CHOOSEN(Clean_xml_recs, eyeball), NAMED('Sample_Clean_xml_recs_IID'));

//Filter out bad xml recs so the job doesn't crash
Good_Logs := Clean_xml_recs(validinputxml and validoutputxml);
OUTPUT(CHOOSEN(Good_Logs, eyeball), NAMED('Sample_Good_Logs_IID'));
OUTPUT(count(Good_Logs), NAMED('Good_Logs_count_IID'));

scout.ad_hoc_reporting.Layouts.Parsed_InstantID_Layout parseInput () := TRANSFORM
	SELF.TransactionID				:= TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
	// SELF.TransactionID				:= Transaction_Id; // Forced into the record so I can join it all together
	SELF.EndUserCompanyName		:= TRIM(XMLTEXT('User/EndUser/CompanyName'));
	SELF.FirstName						:= TRIM(XMLTEXT('SearchBy/Name/First'));
	SELF.LastName							:= TRIM(XMLTEXT('SearchBy/Name/Last'));
	SELF.FullName							:= TRIM(XMLTEXT('SearchBy/Name/Full'));
	// SELF.SSN									:= scout.ad_hoc_reporting.Common.ParseSSN(XMLTEXT('SearchBy/SSN'));
	FullSSN         := scout.ad_hoc_reporting.Common.ParseSSN(XMLTEXT('SearchBy/SSN'));
	SSNLast4        := scout.ad_hoc_reporting.Common.ParseSSN(XMLTEXT('SearchBy/SSNLast4'), 4);
	SELF.SSN        := IF(FullSSN <> '', FullSSN, SSNLast4);
	SELF.DOB									:= TRIM(XMLTEXT('SearchBy/DOB')) + scout.ad_hoc_reporting.Common.ParseDate(XMLTEXT('SearchBy/DOB/Year'), XMLTEXT('SearchBy/DOB/Month'), XMLTEXT('SearchBy/DOB/Day'));
	SELF.Address							:= scout.ad_hoc_reporting.Common.ParseAddress(XMLTEXT('SearchBy/Address/StreetAddress1'), XMLTEXT('SearchBy/Address/StreetAddress2'), XMLTEXT('SearchBy/Address/StreetNumber'), XMLTEXT('SearchBy/Address/StreetPreDirection'), XMLTEXT('SearchBy/Address/StreetName'),
															XMLTEXT('SearchBy/Address/StreetSuffix'), XMLTEXT('SearchBy/Address/StreetPostDirection'), XMLTEXT('SearchBy/Address/UnitDesignation'), XMLTEXT('SearchBy/Address/UnitNumber'));
	
	SELF.City									:= TRIM(XMLTEXT('SearchBy/Address/City'));
	SELF.State								:= TRIM(XMLTEXT('SearchBy/Address/State'));
	SELF.Zip									:= scout.ad_hoc_reporting.Common.ParseZIP(XMLTEXT('SearchBy/Address/Zip5'));
	SELF.DL										:= TRIM(XMLTEXT('SearchBy/DriverLicenseNumber'));
	SELF.HomePhone						:= scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/HomePhone'));
	SELF.WorkPhone						:= scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/WorkPhone'));
	
	SELF := [];
END;
parsedInput := PARSE(Good_Logs, inputxml, parseInput(), XML(Product));

OUTPUT(CHOOSEN(parsedInput, eyeball), NAMED('Sample_Parsed_Input_IID'));

scout.ad_hoc_reporting.Layouts.Parsed_InstantID_Layout parseOutput () := TRANSFORM
	SELF.TransactionID	:= TRIM(XMLTEXT('Header/TransactionId')); // Forced into the record so I can join it all together
	// SELF.CVI						:= TRIM(XMLTEXT('Result/ComprehensiveVerificationIndex'));
	// SELF.NAP						:= TRIM(XMLTEXT('Result/NameAddressPhone[1]/Summary'));
	// SELF.NAS						:= TRIM(XMLTEXT('Result/NameAddressSSNSummary'));
	
	// SELF.RC1						:= TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[1]/RiskCode'));
	// SELF.RC2						:= TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[2]/RiskCode'));
	// SELF.RC3						:= TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[3]/RiskCode'));
	// SELF.RC4						:= TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[4]/RiskCode'));
	// SELF.RC5						:= TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[5]/RiskCode'));
	// SELF.RC6						:= TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[6]/RiskCode'));
	// SELF.RC7						:= TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[7]/RiskCode'));
	// SELF.RC8						:= TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[8]/RiskCode'));
	// SELF.RC9						:= TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[9]/RiskCode'));
	// SELF.RC10						:= TRIM(XMLTEXT('Result/RiskIndicators[1]/RiskIndicator[10]/RiskCode'));

	// SELF := [];
	
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

OUTPUT(CHOOSEN(parsedOutputTemp, eyeball), NAMED('Sample_Parsed_Output_IID'));

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
parsedOutput:= NORMALIZE(parsedOutputTemp, 1, normScores(LEFT, COUNTER)) (CVI <> ''); // Ignore Blank CVI Records

OUTPUT(CHOOSEN(parsedOutput, eyeball), NAMED('Sample_Normalized_Output_IID'));

scout.ad_hoc_reporting.Layouts.Parsed_InstantID_Layout combineParsedRecords(scout.ad_hoc_reporting.Layouts.Parsed_InstantID_Layout le, scout.ad_hoc_reporting.Layouts.Parsed_InstantID_Layout ri) := TRANSFORM
	SELF.CVI		:= ri.CVI;
	SELF.NAP		:= ri.NAP;
	SELF.NAS		:= ri.NAS;
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

// Join the parsed input/output and then filter out the results where no model was requested or where this was an income estimated model and not a true RiskView model
parsedRecordsTemp := JOIN(parsedInput, parsedOutput, LEFT.TransactionID = RIGHT.TransactionID, combineParsedRecords(LEFT, RIGHT), KEEP(1), ATMOST(scout.daily_monitoring.Constants.Max_atmost));

parsedRecords := JOIN(parsedRecordsTemp, Good_Logs, LEFT.TransactionID = RIGHT.TransactionID, TRANSFORM(RECORDOF(LEFT), SELF.TransactionDate := RIGHT.TransactionDate; SELF.AccountID := RIGHT.AccountID; SELF := LEFT));

OUTPUT(CHOOSEN(parsedRecords, eyeball), NAMED('Sample_Fully_Parsed_Records_IID'));
OUTPUT(COUNT(parsedRecords), NAMED('Total_Fully_Parsed_Records_IID'));

finalRecords := SORT(parsedRecords, TransactionDate);
OUTPUT(CHOOSEN(finalRecords, eyeball), NAMED('Sample_Final_Records_IID'));

/* ***********************************************************************************************
 *************************************************************************************************
 *                                    CALCULATE PERCENTAGES/COUNTS                               *
 *************************************************************************************************
 *********************************************************************************************** */
trackingLayout := RECORD
	// General Statistics
	STRING8 Date_Of_Report															:= finalRecords.TransactionDate;
	UNSIGNED8 Total_Number_Of_Transactions							:= COUNT(GROUP);
	UNSIGNED8 Number_Of_Unique_Account_IDs_Transacted		:= 0;
	
	// Input Population Statistics
	DECIMAL6_3	Percent_First_Name_Populated := (COUNT(GROUP, finalRecords.FirstName <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Last_Name_Populated := (COUNT(GROUP, finalRecords.LastName <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Full_Name_Populated := (COUNT(GROUP, finalRecords.FullName <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_SSN_Populated		:= (COUNT(GROUP, finalRecords.SSN <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_DOB_Populated		:= (COUNT(GROUP, finalRecords.DOB <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Address_Populated:= (COUNT(GROUP, finalRecords.Address <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_City_Populated	:= (COUNT(GROUP, finalRecords.City <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_State_Populated	:= (COUNT(GROUP, finalRecords.State <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Zip_Populated		:= (COUNT(GROUP, finalRecords.Zip <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_DL_Populated		:= (COUNT(GROUP, finalRecords.DL <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Home_Phone_Populated := (COUNT(GROUP, finalRecords.HomePhone <> '') / COUNT(GROUP)) * 100;

	// CVI Score Buckets
	DECIMAL6_3	Percent_CVI_00			:= (COUNT(GROUP, (INTEGER)finalRecords.CVI = 0) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_CVI_10			:= (COUNT(GROUP, (INTEGER)finalRecords.CVI = 10) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_CVI_20			:= (COUNT(GROUP, (INTEGER)finalRecords.CVI = 20) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_CVI_30			:= (COUNT(GROUP, (INTEGER)finalRecords.CVI = 30) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_CVI_40			:= (COUNT(GROUP, (INTEGER)finalRecords.CVI = 40) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_CVI_50			:= (COUNT(GROUP, (INTEGER)finalRecords.CVI = 50) / COUNT(GROUP)) * 100;
	UNSIGNED2		Average_CVI_Value			:= ROUND(SUM(GROUP, (INTEGER)finalRecords.CVI / 10) / COUNT(GROUP)) * 10;
	
	// NAP Score Buckets
	DECIMAL6_3	Percent_NAP_0			:= (COUNT(GROUP, (INTEGER)finalRecords.NAP = 0) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAP_1			:= (COUNT(GROUP, (INTEGER)finalRecords.NAP = 1) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAP_2			:= (COUNT(GROUP, (INTEGER)finalRecords.NAP = 2) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAP_3			:= (COUNT(GROUP, (INTEGER)finalRecords.NAP = 3) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAP_4			:= (COUNT(GROUP, (INTEGER)finalRecords.NAP = 4) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAP_5			:= (COUNT(GROUP, (INTEGER)finalRecords.NAP = 5) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAP_6			:= (COUNT(GROUP, (INTEGER)finalRecords.NAP = 6) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAP_7			:= (COUNT(GROUP, (INTEGER)finalRecords.NAP = 7) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAP_8			:= (COUNT(GROUP, (INTEGER)finalRecords.NAP = 8) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAP_9			:= (COUNT(GROUP, (INTEGER)finalRecords.NAP = 9) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAP_10		:= (COUNT(GROUP, (INTEGER)finalRecords.NAP = 10) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAP_11		:= (COUNT(GROUP, (INTEGER)finalRecords.NAP = 11) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAP_12		:= (COUNT(GROUP, (INTEGER)finalRecords.NAP = 12) / COUNT(GROUP)) * 100;
	UNSIGNED1		Average_NAP_Value	:= ROUND(SUM(GROUP, (INTEGER)finalRecords.NAP) / COUNT(GROUP));
	
	// NAS Score Buckets
	DECIMAL6_3	Percent_NAS_0			:= (COUNT(GROUP, (INTEGER)finalRecords.NAS = 0) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAS_1			:= (COUNT(GROUP, (INTEGER)finalRecords.NAS = 1) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAS_2			:= (COUNT(GROUP, (INTEGER)finalRecords.NAS = 2) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAS_3			:= (COUNT(GROUP, (INTEGER)finalRecords.NAS = 3) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAS_4			:= (COUNT(GROUP, (INTEGER)finalRecords.NAS = 4) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAS_5			:= (COUNT(GROUP, (INTEGER)finalRecords.NAS = 5) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAS_6			:= (COUNT(GROUP, (INTEGER)finalRecords.NAS = 6) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAS_7			:= (COUNT(GROUP, (INTEGER)finalRecords.NAS = 7) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAS_8			:= (COUNT(GROUP, (INTEGER)finalRecords.NAS = 8) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAS_9			:= (COUNT(GROUP, (INTEGER)finalRecords.NAS = 9) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAS_10		:= (COUNT(GROUP, (INTEGER)finalRecords.NAS = 10) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAS_11		:= (COUNT(GROUP, (INTEGER)finalRecords.NAS = 11) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_NAS_12		:= (COUNT(GROUP, (INTEGER)finalRecords.NAS = 12) / COUNT(GROUP)) * 100;
	UNSIGNED1		Average_NAS_Value	:= ROUND(SUM(GROUP, (INTEGER)finalRecords.NAS) / COUNT(GROUP));
	
		// Score Bucket Statistics
	DECIMAL6_3	Percent_FP_Scored_200			:= (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore = 200) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_Scored_201			:= (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore = 201) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_Scored_202			:= (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore = 202) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_Scored_203			:= (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore = 203) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_Scored_222			:= (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore = 222) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_Scored_Between_300_350 := (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore BETWEEN 300 AND 350) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_Scored_Between_351_400 := (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore BETWEEN 351 AND 400) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_Scored_Between_401_450 := (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore BETWEEN 401 AND 450) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_Scored_Between_451_500 := (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore BETWEEN 451 AND 500) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_Scored_Between_501_550 := (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore BETWEEN 501 AND 550) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_Scored_Between_551_600 := (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore BETWEEN 551 AND 600) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_Scored_Between_601_650 := (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore BETWEEN 601 AND 650) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_Scored_Between_651_700 := (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore BETWEEN 651 AND 700) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_Scored_Between_701_750 := (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore BETWEEN 701 AND 750) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_Scored_Between_751_900 := (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore BETWEEN 751 AND 900) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_Scored_Above_900:= (COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore > 900) / COUNT(GROUP)) * 100;
	
	UNSIGNED2		Average_Score_Excluding_Exceptions			:= ROUND(SUM(GROUP, IF((INTEGER)finalRecords.FraudPointScore BETWEEN 223 AND 900, (INTEGER)finalRecords.FraudPointScore, 0)) / COUNT(GROUP, (INTEGER)finalRecords.FraudPointScore BETWEEN 223 AND 900));
	
	
	DECIMAL6_3	Percent_FraudPointRC1			:= (COUNT(GROUP, (INTEGER)finalRecords.FraudPointRC1 = 9) / COUNT(GROUP)) * 100;

	DECIMAL6_3	Percent_FP_RC_02	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '02' OR finalRecords.FraudPointRC2 = '02' OR finalRecords.FraudPointRC3 = '02' OR finalRecords.FraudPointRC4 = '02' OR finalRecords.FraudPointRC5 = '02' OR finalRecords.FraudPointRC6 = '02') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_03	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '03' OR finalRecords.FraudPointRC2 = '03' OR finalRecords.FraudPointRC3 = '03' OR finalRecords.FraudPointRC4 = '03' OR finalRecords.FraudPointRC5 = '03' OR finalRecords.FraudPointRC6 = '03') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_06	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '06' OR finalRecords.FraudPointRC2 = '06' OR finalRecords.FraudPointRC3 = '06' OR finalRecords.FraudPointRC4 = '06' OR finalRecords.FraudPointRC5 = '06' OR finalRecords.FraudPointRC6 = '06') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_07	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '07' OR finalRecords.FraudPointRC2 = '07' OR finalRecords.FraudPointRC3 = '07' OR finalRecords.FraudPointRC4 = '07' OR finalRecords.FraudPointRC5 = '07' OR finalRecords.FraudPointRC6 = '07') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_08	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '08' OR finalRecords.FraudPointRC2 = '08' OR finalRecords.FraudPointRC3 = '08' OR finalRecords.FraudPointRC4 = '08' OR finalRecords.FraudPointRC5 = '08' OR finalRecords.FraudPointRC6 = '08') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_09	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '09' OR finalRecords.FraudPointRC2 = '09' OR finalRecords.FraudPointRC3 = '09' OR finalRecords.FraudPointRC4 = '09' OR finalRecords.FraudPointRC5 = '09' OR finalRecords.FraudPointRC6 = '09') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_10	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '10' OR finalRecords.FraudPointRC2 = '10' OR finalRecords.FraudPointRC3 = '10' OR finalRecords.FraudPointRC4 = '10' OR finalRecords.FraudPointRC5 = '10' OR finalRecords.FraudPointRC6 = '10') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_11	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '11' OR finalRecords.FraudPointRC2 = '11' OR finalRecords.FraudPointRC3 = '11' OR finalRecords.FraudPointRC4 = '11' OR finalRecords.FraudPointRC5 = '11' OR finalRecords.FraudPointRC6 = '11') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_12	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '12' OR finalRecords.FraudPointRC2 = '12' OR finalRecords.FraudPointRC3 = '12' OR finalRecords.FraudPointRC4 = '12' OR finalRecords.FraudPointRC5 = '12' OR finalRecords.FraudPointRC6 = '12') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_14	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '14' OR finalRecords.FraudPointRC2 = '14' OR finalRecords.FraudPointRC3 = '14' OR finalRecords.FraudPointRC4 = '14' OR finalRecords.FraudPointRC5 = '14' OR finalRecords.FraudPointRC6 = '14') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_15	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '15' OR finalRecords.FraudPointRC2 = '15' OR finalRecords.FraudPointRC3 = '15' OR finalRecords.FraudPointRC4 = '15' OR finalRecords.FraudPointRC5 = '15' OR finalRecords.FraudPointRC6 = '15') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_16	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '16' OR finalRecords.FraudPointRC2 = '16' OR finalRecords.FraudPointRC3 = '16' OR finalRecords.FraudPointRC4 = '16' OR finalRecords.FraudPointRC5 = '16' OR finalRecords.FraudPointRC6 = '16') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_34	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '34' OR finalRecords.FraudPointRC2 = '34' OR finalRecords.FraudPointRC3 = '34' OR finalRecords.FraudPointRC4 = '34' OR finalRecords.FraudPointRC5 = '34' OR finalRecords.FraudPointRC6 = '34') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_38	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '38' OR finalRecords.FraudPointRC2 = '38' OR finalRecords.FraudPointRC3 = '38' OR finalRecords.FraudPointRC4 = '38' OR finalRecords.FraudPointRC5 = '38' OR finalRecords.FraudPointRC6 = '38') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_39	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '39' OR finalRecords.FraudPointRC2 = '39' OR finalRecords.FraudPointRC3 = '39' OR finalRecords.FraudPointRC4 = '39' OR finalRecords.FraudPointRC5 = '39' OR finalRecords.FraudPointRC6 = '39') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_40	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '40' OR finalRecords.FraudPointRC2 = '40' OR finalRecords.FraudPointRC3 = '40' OR finalRecords.FraudPointRC4 = '40' OR finalRecords.FraudPointRC5 = '40' OR finalRecords.FraudPointRC6 = '40') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_49	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '49' OR finalRecords.FraudPointRC2 = '49' OR finalRecords.FraudPointRC3 = '49' OR finalRecords.FraudPointRC4 = '49' OR finalRecords.FraudPointRC5 = '49' OR finalRecords.FraudPointRC6 = '49') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_50	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '50' OR finalRecords.FraudPointRC2 = '50' OR finalRecords.FraudPointRC3 = '50' OR finalRecords.FraudPointRC4 = '50' OR finalRecords.FraudPointRC5 = '50' OR finalRecords.FraudPointRC6 = '50') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_51	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '51' OR finalRecords.FraudPointRC2 = '51' OR finalRecords.FraudPointRC3 = '51' OR finalRecords.FraudPointRC4 = '51' OR finalRecords.FraudPointRC5 = '51' OR finalRecords.FraudPointRC6 = '51') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_52	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '52' OR finalRecords.FraudPointRC2 = '52' OR finalRecords.FraudPointRC3 = '52' OR finalRecords.FraudPointRC4 = '52' OR finalRecords.FraudPointRC5 = '52' OR finalRecords.FraudPointRC6 = '52') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_53	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '53' OR finalRecords.FraudPointRC2 = '53' OR finalRecords.FraudPointRC3 = '53' OR finalRecords.FraudPointRC4 = '53' OR finalRecords.FraudPointRC5 = '53' OR finalRecords.FraudPointRC6 = '53') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_55	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '55' OR finalRecords.FraudPointRC2 = '55' OR finalRecords.FraudPointRC3 = '55' OR finalRecords.FraudPointRC4 = '55' OR finalRecords.FraudPointRC5 = '55' OR finalRecords.FraudPointRC6 = '55') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_56	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '56' OR finalRecords.FraudPointRC2 = '56' OR finalRecords.FraudPointRC3 = '56' OR finalRecords.FraudPointRC4 = '56' OR finalRecords.FraudPointRC5 = '56' OR finalRecords.FraudPointRC6 = '56') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_57	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '57' OR finalRecords.FraudPointRC2 = '57' OR finalRecords.FraudPointRC3 = '57' OR finalRecords.FraudPointRC4 = '57' OR finalRecords.FraudPointRC5 = '57' OR finalRecords.FraudPointRC6 = '57') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_64	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '64' OR finalRecords.FraudPointRC2 = '64' OR finalRecords.FraudPointRC3 = '64' OR finalRecords.FraudPointRC4 = '64' OR finalRecords.FraudPointRC5 = '64' OR finalRecords.FraudPointRC6 = '64') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_66	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '66' OR finalRecords.FraudPointRC2 = '66' OR finalRecords.FraudPointRC3 = '66' OR finalRecords.FraudPointRC4 = '66' OR finalRecords.FraudPointRC5 = '66' OR finalRecords.FraudPointRC6 = '66') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_71	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '71' OR finalRecords.FraudPointRC2 = '71' OR finalRecords.FraudPointRC3 = '71' OR finalRecords.FraudPointRC4 = '71' OR finalRecords.FraudPointRC5 = '71' OR finalRecords.FraudPointRC6 = '71') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_72	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '72' OR finalRecords.FraudPointRC2 = '72' OR finalRecords.FraudPointRC3 = '72' OR finalRecords.FraudPointRC4 = '72' OR finalRecords.FraudPointRC5 = '72' OR finalRecords.FraudPointRC6 = '72') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_73	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '73' OR finalRecords.FraudPointRC2 = '73' OR finalRecords.FraudPointRC3 = '73' OR finalRecords.FraudPointRC4 = '73' OR finalRecords.FraudPointRC5 = '73' OR finalRecords.FraudPointRC6 = '73') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_74	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '74' OR finalRecords.FraudPointRC2 = '74' OR finalRecords.FraudPointRC3 = '74' OR finalRecords.FraudPointRC4 = '74' OR finalRecords.FraudPointRC5 = '74' OR finalRecords.FraudPointRC6 = '74') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_75	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '75' OR finalRecords.FraudPointRC2 = '75' OR finalRecords.FraudPointRC3 = '75' OR finalRecords.FraudPointRC4 = '75' OR finalRecords.FraudPointRC5 = '75' OR finalRecords.FraudPointRC6 = '75') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_77	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '77' OR finalRecords.FraudPointRC2 = '77' OR finalRecords.FraudPointRC3 = '77' OR finalRecords.FraudPointRC4 = '77' OR finalRecords.FraudPointRC5 = '77' OR finalRecords.FraudPointRC6 = '77') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_78	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '78' OR finalRecords.FraudPointRC2 = '78' OR finalRecords.FraudPointRC3 = '78' OR finalRecords.FraudPointRC4 = '78' OR finalRecords.FraudPointRC5 = '78' OR finalRecords.FraudPointRC6 = '78') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_79	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '79' OR finalRecords.FraudPointRC2 = '79' OR finalRecords.FraudPointRC3 = '79' OR finalRecords.FraudPointRC4 = '79' OR finalRecords.FraudPointRC5 = '79' OR finalRecords.FraudPointRC6 = '79') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_80	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '80' OR finalRecords.FraudPointRC2 = '80' OR finalRecords.FraudPointRC3 = '80' OR finalRecords.FraudPointRC4 = '80' OR finalRecords.FraudPointRC5 = '80' OR finalRecords.FraudPointRC6 = '80') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_81	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '81' OR finalRecords.FraudPointRC2 = '81' OR finalRecords.FraudPointRC3 = '81' OR finalRecords.FraudPointRC4 = '81' OR finalRecords.FraudPointRC5 = '81' OR finalRecords.FraudPointRC6 = '81') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_82	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '82' OR finalRecords.FraudPointRC2 = '82' OR finalRecords.FraudPointRC3 = '82' OR finalRecords.FraudPointRC4 = '82' OR finalRecords.FraudPointRC5 = '82' OR finalRecords.FraudPointRC6 = '82') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_85	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '85' OR finalRecords.FraudPointRC2 = '85' OR finalRecords.FraudPointRC3 = '85' OR finalRecords.FraudPointRC4 = '85' OR finalRecords.FraudPointRC5 = '85' OR finalRecords.FraudPointRC6 = '85') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_89	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '89' OR finalRecords.FraudPointRC2 = '89' OR finalRecords.FraudPointRC3 = '89' OR finalRecords.FraudPointRC4 = '89' OR finalRecords.FraudPointRC5 = '89' OR finalRecords.FraudPointRC6 = '89') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_90	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '90' OR finalRecords.FraudPointRC2 = '90' OR finalRecords.FraudPointRC3 = '90' OR finalRecords.FraudPointRC4 = '90' OR finalRecords.FraudPointRC5 = '90' OR finalRecords.FraudPointRC6 = '90') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_97	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '97' OR finalRecords.FraudPointRC2 = '97' OR finalRecords.FraudPointRC3 = '97' OR finalRecords.FraudPointRC4 = '97' OR finalRecords.FraudPointRC5 = '97' OR finalRecords.FraudPointRC6 = '97') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_9D	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '9D' OR finalRecords.FraudPointRC2 = '9D' OR finalRecords.FraudPointRC3 = '9D' OR finalRecords.FraudPointRC4 = '9D' OR finalRecords.FraudPointRC5 = '9D' OR finalRecords.FraudPointRC6 = '9D') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_9K	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = '9K' OR finalRecords.FraudPointRC2 = '9K' OR finalRecords.FraudPointRC3 = '9K' OR finalRecords.FraudPointRC4 = '9K' OR finalRecords.FraudPointRC5 = '9K' OR finalRecords.FraudPointRC6 = '9K') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_AR	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'AR' OR finalRecords.FraudPointRC2 = 'AR' OR finalRecords.FraudPointRC3 = 'AR' OR finalRecords.FraudPointRC4 = 'AR' OR finalRecords.FraudPointRC5 = 'AR' OR finalRecords.FraudPointRC6 = 'AR') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_BO	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'BO' OR finalRecords.FraudPointRC2 = 'BO' OR finalRecords.FraudPointRC3 = 'BO' OR finalRecords.FraudPointRC4 = 'BO' OR finalRecords.FraudPointRC5 = 'BO' OR finalRecords.FraudPointRC6 = 'BO') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_CB	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'CB' OR finalRecords.FraudPointRC2 = 'CB' OR finalRecords.FraudPointRC3 = 'CB' OR finalRecords.FraudPointRC4 = 'CB' OR finalRecords.FraudPointRC5 = 'CB' OR finalRecords.FraudPointRC6 = 'CB') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_CC	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'CC' OR finalRecords.FraudPointRC2 = 'CC' OR finalRecords.FraudPointRC3 = 'CC' OR finalRecords.FraudPointRC4 = 'CC' OR finalRecords.FraudPointRC5 = 'CC' OR finalRecords.FraudPointRC6 = 'CC') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_CR	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'CR' OR finalRecords.FraudPointRC2 = 'CR' OR finalRecords.FraudPointRC3 = 'CR' OR finalRecords.FraudPointRC4 = 'CR' OR finalRecords.FraudPointRC5 = 'CR' OR finalRecords.FraudPointRC6 = 'CR') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_DR	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'DR' OR finalRecords.FraudPointRC2 = 'DR' OR finalRecords.FraudPointRC3 = 'DR' OR finalRecords.FraudPointRC4 = 'DR' OR finalRecords.FraudPointRC5 = 'DR' OR finalRecords.FraudPointRC6 = 'DR') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_FQ	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'FQ' OR finalRecords.FraudPointRC2 = 'FQ' OR finalRecords.FraudPointRC3 = 'FQ' OR finalRecords.FraudPointRC4 = 'FQ' OR finalRecords.FraudPointRC5 = 'FQ' OR finalRecords.FraudPointRC6 = 'FQ') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_FV	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'FV' OR finalRecords.FraudPointRC2 = 'FV' OR finalRecords.FraudPointRC3 = 'FV' OR finalRecords.FraudPointRC4 = 'FV' OR finalRecords.FraudPointRC5 = 'FV' OR finalRecords.FraudPointRC6 = 'FV') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_HA	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'HA' OR finalRecords.FraudPointRC2 = 'HA' OR finalRecords.FraudPointRC3 = 'HA' OR finalRecords.FraudPointRC4 = 'HA' OR finalRecords.FraudPointRC5 = 'HA' OR finalRecords.FraudPointRC6 = 'HA') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_IA	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'IA' OR finalRecords.FraudPointRC2 = 'IA' OR finalRecords.FraudPointRC3 = 'IA' OR finalRecords.FraudPointRC4 = 'IA' OR finalRecords.FraudPointRC5 = 'IA' OR finalRecords.FraudPointRC6 = 'IA') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_IE	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'IE' OR finalRecords.FraudPointRC2 = 'IE' OR finalRecords.FraudPointRC3 = 'IE' OR finalRecords.FraudPointRC4 = 'IE' OR finalRecords.FraudPointRC5 = 'IE' OR finalRecords.FraudPointRC6 = 'IE') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_IF	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'IF' OR finalRecords.FraudPointRC2 = 'IF' OR finalRecords.FraudPointRC3 = 'IF' OR finalRecords.FraudPointRC4 = 'IF' OR finalRecords.FraudPointRC5 = 'IF' OR finalRecords.FraudPointRC6 = 'IF') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_IG	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'IG' OR finalRecords.FraudPointRC2 = 'IG' OR finalRecords.FraudPointRC3 = 'IG' OR finalRecords.FraudPointRC4 = 'IG' OR finalRecords.FraudPointRC5 = 'IG' OR finalRecords.FraudPointRC6 = 'IG') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_II	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'II' OR finalRecords.FraudPointRC2 = 'II' OR finalRecords.FraudPointRC3 = 'II' OR finalRecords.FraudPointRC4 = 'II' OR finalRecords.FraudPointRC5 = 'II' OR finalRecords.FraudPointRC6 = 'II') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_IJ	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'IJ' OR finalRecords.FraudPointRC2 = 'IJ' OR finalRecords.FraudPointRC3 = 'IJ' OR finalRecords.FraudPointRC4 = 'IJ' OR finalRecords.FraudPointRC5 = 'IJ' OR finalRecords.FraudPointRC6 = 'IJ') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_IK	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'IK' OR finalRecords.FraudPointRC2 = 'IK' OR finalRecords.FraudPointRC3 = 'IK' OR finalRecords.FraudPointRC4 = 'IK' OR finalRecords.FraudPointRC5 = 'IK' OR finalRecords.FraudPointRC6 = 'IK') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_IR	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'IR' OR finalRecords.FraudPointRC2 = 'IR' OR finalRecords.FraudPointRC3 = 'IR' OR finalRecords.FraudPointRC4 = 'IR' OR finalRecords.FraudPointRC5 = 'IR' OR finalRecords.FraudPointRC6 = 'IR') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_MI	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'MI' OR finalRecords.FraudPointRC2 = 'MI' OR finalRecords.FraudPointRC3 = 'MI' OR finalRecords.FraudPointRC4 = 'MI' OR finalRecords.FraudPointRC5 = 'MI' OR finalRecords.FraudPointRC6 = 'MI') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_MN	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'MN' OR finalRecords.FraudPointRC2 = 'MN' OR finalRecords.FraudPointRC3 = 'MN' OR finalRecords.FraudPointRC4 = 'MN' OR finalRecords.FraudPointRC5 = 'MN' OR finalRecords.FraudPointRC6 = 'MN') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_MS	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'MS' OR finalRecords.FraudPointRC2 = 'MS' OR finalRecords.FraudPointRC3 = 'MS' OR finalRecords.FraudPointRC4 = 'MS' OR finalRecords.FraudPointRC5 = 'MS' OR finalRecords.FraudPointRC6 = 'MS') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_PA	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'PA' OR finalRecords.FraudPointRC2 = 'PA' OR finalRecords.FraudPointRC3 = 'PA' OR finalRecords.FraudPointRC4 = 'PA' OR finalRecords.FraudPointRC5 = 'PA' OR finalRecords.FraudPointRC6 = 'PA') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_PH	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'PH' OR finalRecords.FraudPointRC2 = 'PH' OR finalRecords.FraudPointRC3 = 'PH' OR finalRecords.FraudPointRC4 = 'PH' OR finalRecords.FraudPointRC5 = 'PH' OR finalRecords.FraudPointRC6 = 'PH') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_PN	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'PN' OR finalRecords.FraudPointRC2 = 'PN' OR finalRecords.FraudPointRC3 = 'PN' OR finalRecords.FraudPointRC4 = 'PN' OR finalRecords.FraudPointRC5 = 'PN' OR finalRecords.FraudPointRC6 = 'PN') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_PO	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'PO' OR finalRecords.FraudPointRC2 = 'PO' OR finalRecords.FraudPointRC3 = 'PO' OR finalRecords.FraudPointRC4 = 'PO' OR finalRecords.FraudPointRC5 = 'PO' OR finalRecords.FraudPointRC6 = 'PO') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_QA	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'QA' OR finalRecords.FraudPointRC2 = 'QA' OR finalRecords.FraudPointRC3 = 'QA' OR finalRecords.FraudPointRC4 = 'QA' OR finalRecords.FraudPointRC5 = 'QA' OR finalRecords.FraudPointRC6 = 'QA') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_QB	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'QB' OR finalRecords.FraudPointRC2 = 'QB' OR finalRecords.FraudPointRC3 = 'QB' OR finalRecords.FraudPointRC4 = 'QB' OR finalRecords.FraudPointRC5 = 'QB' OR finalRecords.FraudPointRC6 = 'QB') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_QC	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'QC' OR finalRecords.FraudPointRC2 = 'QC' OR finalRecords.FraudPointRC3 = 'QC' OR finalRecords.FraudPointRC4 = 'QC' OR finalRecords.FraudPointRC5 = 'QC' OR finalRecords.FraudPointRC6 = 'QC') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_QD	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'QD' OR finalRecords.FraudPointRC2 = 'QD' OR finalRecords.FraudPointRC3 = 'QD' OR finalRecords.FraudPointRC4 = 'QD' OR finalRecords.FraudPointRC5 = 'QD' OR finalRecords.FraudPointRC6 = 'QD') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_QE	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'QE' OR finalRecords.FraudPointRC2 = 'QE' OR finalRecords.FraudPointRC3 = 'QE' OR finalRecords.FraudPointRC4 = 'QE' OR finalRecords.FraudPointRC5 = 'QE' OR finalRecords.FraudPointRC6 = 'QE') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_QF	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'QF' OR finalRecords.FraudPointRC2 = 'QF' OR finalRecords.FraudPointRC3 = 'QF' OR finalRecords.FraudPointRC4 = 'QF' OR finalRecords.FraudPointRC5 = 'QF' OR finalRecords.FraudPointRC6 = 'QF') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_QG	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'QG' OR finalRecords.FraudPointRC2 = 'QG' OR finalRecords.FraudPointRC3 = 'QG' OR finalRecords.FraudPointRC4 = 'QG' OR finalRecords.FraudPointRC5 = 'QG' OR finalRecords.FraudPointRC6 = 'QG') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_QH	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'QH' OR finalRecords.FraudPointRC2 = 'QH' OR finalRecords.FraudPointRC3 = 'QH' OR finalRecords.FraudPointRC4 = 'QH' OR finalRecords.FraudPointRC5 = 'QH' OR finalRecords.FraudPointRC6 = 'QH') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_QI	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'QI' OR finalRecords.FraudPointRC2 = 'QI' OR finalRecords.FraudPointRC3 = 'QI' OR finalRecords.FraudPointRC4 = 'QI' OR finalRecords.FraudPointRC5 = 'QI' OR finalRecords.FraudPointRC6 = 'QI') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_QJ	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'QJ' OR finalRecords.FraudPointRC2 = 'QJ' OR finalRecords.FraudPointRC3 = 'QJ' OR finalRecords.FraudPointRC4 = 'QJ' OR finalRecords.FraudPointRC5 = 'QJ' OR finalRecords.FraudPointRC6 = 'QJ') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_QK	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'QK' OR finalRecords.FraudPointRC2 = 'QK' OR finalRecords.FraudPointRC3 = 'QK' OR finalRecords.FraudPointRC4 = 'QK' OR finalRecords.FraudPointRC5 = 'QK' OR finalRecords.FraudPointRC6 = 'QK') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_QL	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'QL' OR finalRecords.FraudPointRC2 = 'QL' OR finalRecords.FraudPointRC3 = 'QL' OR finalRecords.FraudPointRC4 = 'QL' OR finalRecords.FraudPointRC5 = 'QL' OR finalRecords.FraudPointRC6 = 'QL') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_QM	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'QM' OR finalRecords.FraudPointRC2 = 'QM' OR finalRecords.FraudPointRC3 = 'QM' OR finalRecords.FraudPointRC4 = 'QM' OR finalRecords.FraudPointRC5 = 'QM' OR finalRecords.FraudPointRC6 = 'QM') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_RC	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'RC' OR finalRecords.FraudPointRC2 = 'RC' OR finalRecords.FraudPointRC3 = 'RC' OR finalRecords.FraudPointRC4 = 'RC' OR finalRecords.FraudPointRC5 = 'RC' OR finalRecords.FraudPointRC6 = 'RC') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_RF	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'RF' OR finalRecords.FraudPointRC2 = 'RF' OR finalRecords.FraudPointRC3 = 'RF' OR finalRecords.FraudPointRC4 = 'RF' OR finalRecords.FraudPointRC5 = 'RF' OR finalRecords.FraudPointRC6 = 'RF') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_S1	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'S1' OR finalRecords.FraudPointRC2 = 'S1' OR finalRecords.FraudPointRC3 = 'S1' OR finalRecords.FraudPointRC4 = 'S1' OR finalRecords.FraudPointRC5 = 'S1' OR finalRecords.FraudPointRC6 = 'S1') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_S2	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'S2' OR finalRecords.FraudPointRC2 = 'S2' OR finalRecords.FraudPointRC3 = 'S2' OR finalRecords.FraudPointRC4 = 'S2' OR finalRecords.FraudPointRC5 = 'S2' OR finalRecords.FraudPointRC6 = 'S2') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_S3	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'S3' OR finalRecords.FraudPointRC2 = 'S3' OR finalRecords.FraudPointRC3 = 'S3' OR finalRecords.FraudPointRC4 = 'S3' OR finalRecords.FraudPointRC5 = 'S3' OR finalRecords.FraudPointRC6 = 'S3') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_S4	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'S4' OR finalRecords.FraudPointRC2 = 'S4' OR finalRecords.FraudPointRC3 = 'S4' OR finalRecords.FraudPointRC4 = 'S4' OR finalRecords.FraudPointRC5 = 'S4' OR finalRecords.FraudPointRC6 = 'S4') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_S5	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'S5' OR finalRecords.FraudPointRC2 = 'S5' OR finalRecords.FraudPointRC3 = 'S5' OR finalRecords.FraudPointRC4 = 'S5' OR finalRecords.FraudPointRC5 = 'S5' OR finalRecords.FraudPointRC6 = 'S5') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_SA	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'SA' OR finalRecords.FraudPointRC2 = 'SA' OR finalRecords.FraudPointRC3 = 'SA' OR finalRecords.FraudPointRC4 = 'SA' OR finalRecords.FraudPointRC5 = 'SA' OR finalRecords.FraudPointRC6 = 'SA') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_SC	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'SC' OR finalRecords.FraudPointRC2 = 'SC' OR finalRecords.FraudPointRC3 = 'SC' OR finalRecords.FraudPointRC4 = 'SC' OR finalRecords.FraudPointRC5 = 'SC' OR finalRecords.FraudPointRC6 = 'SC') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_SN	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'SN' OR finalRecords.FraudPointRC2 = 'SN' OR finalRecords.FraudPointRC3 = 'SN' OR finalRecords.FraudPointRC4 = 'SN' OR finalRecords.FraudPointRC5 = 'SN' OR finalRecords.FraudPointRC6 = 'SN') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_SR	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'SR' OR finalRecords.FraudPointRC2 = 'SR' OR finalRecords.FraudPointRC3 = 'SR' OR finalRecords.FraudPointRC4 = 'SR' OR finalRecords.FraudPointRC5 = 'SR' OR finalRecords.FraudPointRC6 = 'SR') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_VE	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'VE' OR finalRecords.FraudPointRC2 = 'VE' OR finalRecords.FraudPointRC3 = 'VE' OR finalRecords.FraudPointRC4 = 'VE' OR finalRecords.FraudPointRC5 = 'VE' OR finalRecords.FraudPointRC6 = 'VE') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_VL	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'VL' OR finalRecords.FraudPointRC2 = 'VL' OR finalRecords.FraudPointRC3 = 'VL' OR finalRecords.FraudPointRC4 = 'VL' OR finalRecords.FraudPointRC5 = 'VL' OR finalRecords.FraudPointRC6 = 'VL') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_VR	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'VR' OR finalRecords.FraudPointRC2 = 'VR' OR finalRecords.FraudPointRC3 = 'VR' OR finalRecords.FraudPointRC4 = 'VR' OR finalRecords.FraudPointRC5 = 'VR' OR finalRecords.FraudPointRC6 = 'VR') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_VV	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'VV' OR finalRecords.FraudPointRC2 = 'VV' OR finalRecords.FraudPointRC3 = 'VV' OR finalRecords.FraudPointRC4 = 'VV' OR finalRecords.FraudPointRC5 = 'VV' OR finalRecords.FraudPointRC6 = 'VV') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FP_RC_VX	:=	(COUNT(GROUP, finalRecords.FraudPointRC1 = 'VX' OR finalRecords.FraudPointRC2 = 'VX' OR finalRecords.FraudPointRC3 = 'VX' OR finalRecords.FraudPointRC4 = 'VX' OR finalRecords.FraudPointRC5 = 'VX' OR finalRecords.FraudPointRC6 = 'VX') / COUNT(GROUP)) * 100;


	DECIMAL6_3	Percent_StolenIdentity_Index	:=	(COUNT(GROUP, finalRecords.RiskIndex1 = 'StolenIdentityIndex' OR finalRecords.RiskIndex2 = 'StolenIdentityIndex' OR finalRecords.RiskIndex3 = 'StolenIdentityIndex' OR finalRecords.RiskIndex4 = 'StolenIdentityIndex' OR finalRecords.RiskIndex5 = 'StolenIdentityIndex' OR finalRecords.RiskIndex6 = 'StolenIdentityIndex' ) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_SyntheticIdentity_Index	:=	(COUNT(GROUP, finalRecords.RiskIndex1 = 'SyntheticIdentityIndex' OR finalRecords.RiskIndex2 = 'SyntheticIdentityIndex' OR finalRecords.RiskIndex3 = 'SyntheticIdentityIndex' OR finalRecords.RiskIndex4 = 'SyntheticIdentityIndex' OR finalRecords.RiskIndex5 = 'SyntheticIdentityIndex' OR finalRecords.RiskIndex6 = 'SyntheticIdentityIndex' ) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_ManipulatedIdentity_Index	:=	(COUNT(GROUP, finalRecords.RiskIndex1 = 'ManipulatedIdentityIndex' OR finalRecords.RiskIndex2 = 'ManipulatedIdentityIndex' OR finalRecords.RiskIndex3 = 'ManipulatedIdentityIndex' OR finalRecords.RiskIndex4 = 'ManipulatedIdentityIndex' OR finalRecords.RiskIndex5 = 'ManipulatedIdentityIndex' OR finalRecords.RiskIndex6 = 'ManipulatedIdentityIndex' ) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_VulnerableVictim_Index	:=	(COUNT(GROUP, finalRecords.RiskIndex1 = 'VulnerableVictimIndex' OR finalRecords.RiskIndex2 = 'VulnerableVictimIndex' OR finalRecords.RiskIndex3 = 'VulnerableVictimIndex' OR finalRecords.RiskIndex4 = 'VulnerableVictimIndex' OR finalRecords.RiskIndex5 = 'VulnerableVictimIndex' OR finalRecords.RiskIndex6 = 'VulnerableVictimIndex' ) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_FriendlyFraud_Index	:=	(COUNT(GROUP, finalRecords.RiskIndex1 = 'FriendlyFraudIndex' OR finalRecords.RiskIndex2 = 'FriendlyFraudIndex' OR finalRecords.RiskIndex3 = 'FriendlyFraudIndex' OR finalRecords.RiskIndex4 = 'FriendlyFraudIndex' OR finalRecords.RiskIndex5 = 'FriendlyFraudIndex' OR finalRecords.RiskIndex6 = 'VulnerableVictimIndex' ) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_SuspiciousActivity_Index	:=	(COUNT(GROUP, finalRecords.RiskIndex1 = 'SuspiciousActivityIndex' OR finalRecords.RiskIndex2 = 'SuspiciousActivityIndex' OR finalRecords.RiskIndex3 = 'SuspiciousActivityIndex' OR finalRecords.RiskIndex4 = 'SuspiciousActivityIndex' OR finalRecords.RiskIndex5 = 'SuspiciousActivityIndex' OR finalRecords.RiskIndex6 = 'SuspiciousActivityIndex' ) / COUNT(GROUP)) * 100;
																 
	
	
	// Reason Code Population Statistics
	DECIMAL6_3	Percent_RC_01						:=	(COUNT(GROUP, finalRecords.RC1 = '01' OR finalRecords.RC2 = '01' OR finalRecords.RC3 = '01' OR finalRecords.RC4 = '01' OR finalRecords.RC5 = '01' OR finalRecords.RC6 = '01' OR finalRecords.RC7 = '01' OR finalRecords.RC8 = '01' OR finalRecords.RC9 = '01' OR finalRecords.RC10 = '01') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_02						:=	(COUNT(GROUP, finalRecords.RC1 = '02' OR finalRecords.RC2 = '02' OR finalRecords.RC3 = '02' OR finalRecords.RC4 = '02' OR finalRecords.RC5 = '02' OR finalRecords.RC6 = '02' OR finalRecords.RC7 = '02' OR finalRecords.RC8 = '02' OR finalRecords.RC9 = '02' OR finalRecords.RC10 = '02') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_03						:=	(COUNT(GROUP, finalRecords.RC1 = '03' OR finalRecords.RC2 = '03' OR finalRecords.RC3 = '03' OR finalRecords.RC4 = '03' OR finalRecords.RC5 = '03' OR finalRecords.RC6 = '03' OR finalRecords.RC7 = '03' OR finalRecords.RC8 = '03' OR finalRecords.RC9 = '03' OR finalRecords.RC10 = '03') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_04						:=	(COUNT(GROUP, finalRecords.RC1 = '04' OR finalRecords.RC2 = '04' OR finalRecords.RC3 = '04' OR finalRecords.RC4 = '04' OR finalRecords.RC5 = '04' OR finalRecords.RC6 = '04' OR finalRecords.RC7 = '04' OR finalRecords.RC8 = '04' OR finalRecords.RC9 = '04' OR finalRecords.RC10 = '04') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_05						:=	(COUNT(GROUP, finalRecords.RC1 = '05' OR finalRecords.RC2 = '05' OR finalRecords.RC3 = '05' OR finalRecords.RC4 = '05' OR finalRecords.RC5 = '05' OR finalRecords.RC6 = '05' OR finalRecords.RC7 = '05' OR finalRecords.RC8 = '05' OR finalRecords.RC9 = '05' OR finalRecords.RC10 = '05') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_06						:=	(COUNT(GROUP, finalRecords.RC1 = '06' OR finalRecords.RC2 = '06' OR finalRecords.RC3 = '06' OR finalRecords.RC4 = '06' OR finalRecords.RC5 = '06' OR finalRecords.RC6 = '06' OR finalRecords.RC7 = '06' OR finalRecords.RC8 = '06' OR finalRecords.RC9 = '06' OR finalRecords.RC10 = '06') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_07						:=	(COUNT(GROUP, finalRecords.RC1 = '07' OR finalRecords.RC2 = '07' OR finalRecords.RC3 = '07' OR finalRecords.RC4 = '07' OR finalRecords.RC5 = '07' OR finalRecords.RC6 = '07' OR finalRecords.RC7 = '07' OR finalRecords.RC8 = '07' OR finalRecords.RC9 = '07' OR finalRecords.RC10 = '07') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_08						:=	(COUNT(GROUP, finalRecords.RC1 = '08' OR finalRecords.RC2 = '08' OR finalRecords.RC3 = '08' OR finalRecords.RC4 = '08' OR finalRecords.RC5 = '08' OR finalRecords.RC6 = '08' OR finalRecords.RC7 = '08' OR finalRecords.RC8 = '08' OR finalRecords.RC9 = '08' OR finalRecords.RC10 = '08') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_09						:=	(COUNT(GROUP, finalRecords.RC1 = '09' OR finalRecords.RC2 = '09' OR finalRecords.RC3 = '09' OR finalRecords.RC4 = '09' OR finalRecords.RC5 = '09' OR finalRecords.RC6 = '09' OR finalRecords.RC7 = '09' OR finalRecords.RC8 = '09' OR finalRecords.RC9 = '09' OR finalRecords.RC10 = '09') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_10						:=	(COUNT(GROUP, finalRecords.RC1 = '10' OR finalRecords.RC2 = '10' OR finalRecords.RC3 = '10' OR finalRecords.RC4 = '10' OR finalRecords.RC5 = '10' OR finalRecords.RC6 = '10' OR finalRecords.RC7 = '10' OR finalRecords.RC8 = '10' OR finalRecords.RC9 = '10' OR finalRecords.RC10 = '10') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_11						:=	(COUNT(GROUP, finalRecords.RC1 = '11' OR finalRecords.RC2 = '11' OR finalRecords.RC3 = '11' OR finalRecords.RC4 = '11' OR finalRecords.RC5 = '11' OR finalRecords.RC6 = '11' OR finalRecords.RC7 = '11' OR finalRecords.RC8 = '11' OR finalRecords.RC9 = '11' OR finalRecords.RC10 = '11') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_12						:=	(COUNT(GROUP, finalRecords.RC1 = '12' OR finalRecords.RC2 = '12' OR finalRecords.RC3 = '12' OR finalRecords.RC4 = '12' OR finalRecords.RC5 = '12' OR finalRecords.RC6 = '12' OR finalRecords.RC7 = '12' OR finalRecords.RC8 = '12' OR finalRecords.RC9 = '12' OR finalRecords.RC10 = '12') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_13						:=	(COUNT(GROUP, finalRecords.RC1 = '13' OR finalRecords.RC2 = '13' OR finalRecords.RC3 = '13' OR finalRecords.RC4 = '13' OR finalRecords.RC5 = '13' OR finalRecords.RC6 = '13' OR finalRecords.RC7 = '13' OR finalRecords.RC8 = '13' OR finalRecords.RC9 = '13' OR finalRecords.RC10 = '13') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_14						:=	(COUNT(GROUP, finalRecords.RC1 = '14' OR finalRecords.RC2 = '14' OR finalRecords.RC3 = '14' OR finalRecords.RC4 = '14' OR finalRecords.RC5 = '14' OR finalRecords.RC6 = '14' OR finalRecords.RC7 = '14' OR finalRecords.RC8 = '14' OR finalRecords.RC9 = '14' OR finalRecords.RC10 = '14') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_15						:=	(COUNT(GROUP, finalRecords.RC1 = '15' OR finalRecords.RC2 = '15' OR finalRecords.RC3 = '15' OR finalRecords.RC4 = '15' OR finalRecords.RC5 = '15' OR finalRecords.RC6 = '15' OR finalRecords.RC7 = '15' OR finalRecords.RC8 = '15' OR finalRecords.RC9 = '15' OR finalRecords.RC10 = '15') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_16						:=	(COUNT(GROUP, finalRecords.RC1 = '16' OR finalRecords.RC2 = '16' OR finalRecords.RC3 = '16' OR finalRecords.RC4 = '16' OR finalRecords.RC5 = '16' OR finalRecords.RC6 = '16' OR finalRecords.RC7 = '16' OR finalRecords.RC8 = '16' OR finalRecords.RC9 = '16' OR finalRecords.RC10 = '16') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_17						:=	(COUNT(GROUP, finalRecords.RC1 = '17' OR finalRecords.RC2 = '17' OR finalRecords.RC3 = '17' OR finalRecords.RC4 = '17' OR finalRecords.RC5 = '17' OR finalRecords.RC6 = '17' OR finalRecords.RC7 = '17' OR finalRecords.RC8 = '17' OR finalRecords.RC9 = '17' OR finalRecords.RC10 = '17') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_19						:=	(COUNT(GROUP, finalRecords.RC1 = '19' OR finalRecords.RC2 = '19' OR finalRecords.RC3 = '19' OR finalRecords.RC4 = '19' OR finalRecords.RC5 = '19' OR finalRecords.RC6 = '19' OR finalRecords.RC7 = '19' OR finalRecords.RC8 = '19' OR finalRecords.RC9 = '19' OR finalRecords.RC10 = '19') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_20						:=	(COUNT(GROUP, finalRecords.RC1 = '20' OR finalRecords.RC2 = '20' OR finalRecords.RC3 = '20' OR finalRecords.RC4 = '20' OR finalRecords.RC5 = '20' OR finalRecords.RC6 = '20' OR finalRecords.RC7 = '20' OR finalRecords.RC8 = '20' OR finalRecords.RC9 = '20' OR finalRecords.RC10 = '20') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_21						:=	(COUNT(GROUP, finalRecords.RC1 = '21' OR finalRecords.RC2 = '21' OR finalRecords.RC3 = '21' OR finalRecords.RC4 = '21' OR finalRecords.RC5 = '21' OR finalRecords.RC6 = '21' OR finalRecords.RC7 = '21' OR finalRecords.RC8 = '21' OR finalRecords.RC9 = '21' OR finalRecords.RC10 = '21') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_22						:=	(COUNT(GROUP, finalRecords.RC1 = '22' OR finalRecords.RC2 = '22' OR finalRecords.RC3 = '22' OR finalRecords.RC4 = '22' OR finalRecords.RC5 = '22' OR finalRecords.RC6 = '22' OR finalRecords.RC7 = '22' OR finalRecords.RC8 = '22' OR finalRecords.RC9 = '22' OR finalRecords.RC10 = '22') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_23						:=	(COUNT(GROUP, finalRecords.RC1 = '23' OR finalRecords.RC2 = '23' OR finalRecords.RC3 = '23' OR finalRecords.RC4 = '23' OR finalRecords.RC5 = '23' OR finalRecords.RC6 = '23' OR finalRecords.RC7 = '23' OR finalRecords.RC8 = '23' OR finalRecords.RC9 = '23' OR finalRecords.RC10 = '23') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_24						:=	(COUNT(GROUP, finalRecords.RC1 = '24' OR finalRecords.RC2 = '24' OR finalRecords.RC3 = '24' OR finalRecords.RC4 = '24' OR finalRecords.RC5 = '24' OR finalRecords.RC6 = '24' OR finalRecords.RC7 = '24' OR finalRecords.RC8 = '24' OR finalRecords.RC9 = '24' OR finalRecords.RC10 = '24') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_25						:=	(COUNT(GROUP, finalRecords.RC1 = '25' OR finalRecords.RC2 = '25' OR finalRecords.RC3 = '25' OR finalRecords.RC4 = '25' OR finalRecords.RC5 = '25' OR finalRecords.RC6 = '25' OR finalRecords.RC7 = '25' OR finalRecords.RC8 = '25' OR finalRecords.RC9 = '25' OR finalRecords.RC10 = '25') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_26						:=	(COUNT(GROUP, finalRecords.RC1 = '26' OR finalRecords.RC2 = '26' OR finalRecords.RC3 = '26' OR finalRecords.RC4 = '26' OR finalRecords.RC5 = '26' OR finalRecords.RC6 = '26' OR finalRecords.RC7 = '26' OR finalRecords.RC8 = '26' OR finalRecords.RC9 = '26' OR finalRecords.RC10 = '26') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_27						:=	(COUNT(GROUP, finalRecords.RC1 = '27' OR finalRecords.RC2 = '27' OR finalRecords.RC3 = '27' OR finalRecords.RC4 = '27' OR finalRecords.RC5 = '27' OR finalRecords.RC6 = '27' OR finalRecords.RC7 = '27' OR finalRecords.RC8 = '27' OR finalRecords.RC9 = '27' OR finalRecords.RC10 = '27') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_28						:=	(COUNT(GROUP, finalRecords.RC1 = '28' OR finalRecords.RC2 = '28' OR finalRecords.RC3 = '28' OR finalRecords.RC4 = '28' OR finalRecords.RC5 = '28' OR finalRecords.RC6 = '28' OR finalRecords.RC7 = '28' OR finalRecords.RC8 = '28' OR finalRecords.RC9 = '28' OR finalRecords.RC10 = '28') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_29						:=	(COUNT(GROUP, finalRecords.RC1 = '29' OR finalRecords.RC2 = '29' OR finalRecords.RC3 = '29' OR finalRecords.RC4 = '29' OR finalRecords.RC5 = '29' OR finalRecords.RC6 = '29' OR finalRecords.RC7 = '29' OR finalRecords.RC8 = '29' OR finalRecords.RC9 = '29' OR finalRecords.RC10 = '29') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_30						:=	(COUNT(GROUP, finalRecords.RC1 = '30' OR finalRecords.RC2 = '30' OR finalRecords.RC3 = '30' OR finalRecords.RC4 = '30' OR finalRecords.RC5 = '30' OR finalRecords.RC6 = '30' OR finalRecords.RC7 = '30' OR finalRecords.RC8 = '30' OR finalRecords.RC9 = '30' OR finalRecords.RC10 = '30') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_31						:=	(COUNT(GROUP, finalRecords.RC1 = '31' OR finalRecords.RC2 = '31' OR finalRecords.RC3 = '31' OR finalRecords.RC4 = '31' OR finalRecords.RC5 = '31' OR finalRecords.RC6 = '31' OR finalRecords.RC7 = '31' OR finalRecords.RC8 = '31' OR finalRecords.RC9 = '31' OR finalRecords.RC10 = '31') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_32						:=	(COUNT(GROUP, finalRecords.RC1 = '32' OR finalRecords.RC2 = '32' OR finalRecords.RC3 = '32' OR finalRecords.RC4 = '32' OR finalRecords.RC5 = '32' OR finalRecords.RC6 = '32' OR finalRecords.RC7 = '32' OR finalRecords.RC8 = '32' OR finalRecords.RC9 = '32' OR finalRecords.RC10 = '32') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_33						:=	(COUNT(GROUP, finalRecords.RC1 = '33' OR finalRecords.RC2 = '33' OR finalRecords.RC3 = '33' OR finalRecords.RC4 = '33' OR finalRecords.RC5 = '33' OR finalRecords.RC6 = '33' OR finalRecords.RC7 = '33' OR finalRecords.RC8 = '33' OR finalRecords.RC9 = '33' OR finalRecords.RC10 = '33') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_34						:=	(COUNT(GROUP, finalRecords.RC1 = '34' OR finalRecords.RC2 = '34' OR finalRecords.RC3 = '34' OR finalRecords.RC4 = '34' OR finalRecords.RC5 = '34' OR finalRecords.RC6 = '34' OR finalRecords.RC7 = '34' OR finalRecords.RC8 = '34' OR finalRecords.RC9 = '34' OR finalRecords.RC10 = '34') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_35						:=	(COUNT(GROUP, finalRecords.RC1 = '35' OR finalRecords.RC2 = '35' OR finalRecords.RC3 = '35' OR finalRecords.RC4 = '35' OR finalRecords.RC5 = '35' OR finalRecords.RC6 = '35' OR finalRecords.RC7 = '35' OR finalRecords.RC8 = '35' OR finalRecords.RC9 = '35' OR finalRecords.RC10 = '35') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_36						:=	(COUNT(GROUP, finalRecords.RC1 = '36' OR finalRecords.RC2 = '36' OR finalRecords.RC3 = '36' OR finalRecords.RC4 = '36' OR finalRecords.RC5 = '36' OR finalRecords.RC6 = '36' OR finalRecords.RC7 = '36' OR finalRecords.RC8 = '36' OR finalRecords.RC9 = '36' OR finalRecords.RC10 = '36') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_37						:=	(COUNT(GROUP, finalRecords.RC1 = '37' OR finalRecords.RC2 = '37' OR finalRecords.RC3 = '37' OR finalRecords.RC4 = '37' OR finalRecords.RC5 = '37' OR finalRecords.RC6 = '37' OR finalRecords.RC7 = '37' OR finalRecords.RC8 = '37' OR finalRecords.RC9 = '37' OR finalRecords.RC10 = '37') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_38						:=	(COUNT(GROUP, finalRecords.RC1 = '38' OR finalRecords.RC2 = '38' OR finalRecords.RC3 = '38' OR finalRecords.RC4 = '38' OR finalRecords.RC5 = '38' OR finalRecords.RC6 = '38' OR finalRecords.RC7 = '38' OR finalRecords.RC8 = '38' OR finalRecords.RC9 = '38' OR finalRecords.RC10 = '38') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_39						:=	(COUNT(GROUP, finalRecords.RC1 = '39' OR finalRecords.RC2 = '39' OR finalRecords.RC3 = '39' OR finalRecords.RC4 = '39' OR finalRecords.RC5 = '39' OR finalRecords.RC6 = '39' OR finalRecords.RC7 = '39' OR finalRecords.RC8 = '39' OR finalRecords.RC9 = '39' OR finalRecords.RC10 = '39') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_40						:=	(COUNT(GROUP, finalRecords.RC1 = '40' OR finalRecords.RC2 = '40' OR finalRecords.RC3 = '40' OR finalRecords.RC4 = '40' OR finalRecords.RC5 = '40' OR finalRecords.RC6 = '40' OR finalRecords.RC7 = '40' OR finalRecords.RC8 = '40' OR finalRecords.RC9 = '40' OR finalRecords.RC10 = '40') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_41						:=	(COUNT(GROUP, finalRecords.RC1 = '41' OR finalRecords.RC2 = '41' OR finalRecords.RC3 = '41' OR finalRecords.RC4 = '41' OR finalRecords.RC5 = '41' OR finalRecords.RC6 = '41' OR finalRecords.RC7 = '41' OR finalRecords.RC8 = '41' OR finalRecords.RC9 = '41' OR finalRecords.RC10 = '41') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_42						:=	(COUNT(GROUP, finalRecords.RC1 = '42' OR finalRecords.RC2 = '42' OR finalRecords.RC3 = '42' OR finalRecords.RC4 = '42' OR finalRecords.RC5 = '42' OR finalRecords.RC6 = '42' OR finalRecords.RC7 = '42' OR finalRecords.RC8 = '42' OR finalRecords.RC9 = '42' OR finalRecords.RC10 = '42') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_43						:=	(COUNT(GROUP, finalRecords.RC1 = '43' OR finalRecords.RC2 = '43' OR finalRecords.RC3 = '43' OR finalRecords.RC4 = '43' OR finalRecords.RC5 = '43' OR finalRecords.RC6 = '43' OR finalRecords.RC7 = '43' OR finalRecords.RC8 = '43' OR finalRecords.RC9 = '43' OR finalRecords.RC10 = '43') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_44						:=	(COUNT(GROUP, finalRecords.RC1 = '44' OR finalRecords.RC2 = '44' OR finalRecords.RC3 = '44' OR finalRecords.RC4 = '44' OR finalRecords.RC5 = '44' OR finalRecords.RC6 = '44' OR finalRecords.RC7 = '44' OR finalRecords.RC8 = '44' OR finalRecords.RC9 = '44' OR finalRecords.RC10 = '44') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_45						:=	(COUNT(GROUP, finalRecords.RC1 = '45' OR finalRecords.RC2 = '45' OR finalRecords.RC3 = '45' OR finalRecords.RC4 = '45' OR finalRecords.RC5 = '45' OR finalRecords.RC6 = '45' OR finalRecords.RC7 = '45' OR finalRecords.RC8 = '45' OR finalRecords.RC9 = '45' OR finalRecords.RC10 = '45') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_46						:=	(COUNT(GROUP, finalRecords.RC1 = '46' OR finalRecords.RC2 = '46' OR finalRecords.RC3 = '46' OR finalRecords.RC4 = '46' OR finalRecords.RC5 = '46' OR finalRecords.RC6 = '46' OR finalRecords.RC7 = '46' OR finalRecords.RC8 = '46' OR finalRecords.RC9 = '46' OR finalRecords.RC10 = '46') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_47						:=	(COUNT(GROUP, finalRecords.RC1 = '47' OR finalRecords.RC2 = '47' OR finalRecords.RC3 = '47' OR finalRecords.RC4 = '47' OR finalRecords.RC5 = '47' OR finalRecords.RC6 = '47' OR finalRecords.RC7 = '47' OR finalRecords.RC8 = '47' OR finalRecords.RC9 = '47' OR finalRecords.RC10 = '47') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_48						:=	(COUNT(GROUP, finalRecords.RC1 = '48' OR finalRecords.RC2 = '48' OR finalRecords.RC3 = '48' OR finalRecords.RC4 = '48' OR finalRecords.RC5 = '48' OR finalRecords.RC6 = '48' OR finalRecords.RC7 = '48' OR finalRecords.RC8 = '48' OR finalRecords.RC9 = '48' OR finalRecords.RC10 = '48') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_49						:=	(COUNT(GROUP, finalRecords.RC1 = '49' OR finalRecords.RC2 = '49' OR finalRecords.RC3 = '49' OR finalRecords.RC4 = '49' OR finalRecords.RC5 = '49' OR finalRecords.RC6 = '49' OR finalRecords.RC7 = '49' OR finalRecords.RC8 = '49' OR finalRecords.RC9 = '49' OR finalRecords.RC10 = '49') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_50						:=	(COUNT(GROUP, finalRecords.RC1 = '50' OR finalRecords.RC2 = '50' OR finalRecords.RC3 = '50' OR finalRecords.RC4 = '50' OR finalRecords.RC5 = '50' OR finalRecords.RC6 = '50' OR finalRecords.RC7 = '50' OR finalRecords.RC8 = '50' OR finalRecords.RC9 = '50' OR finalRecords.RC10 = '50') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_51						:=	(COUNT(GROUP, finalRecords.RC1 = '51' OR finalRecords.RC2 = '51' OR finalRecords.RC3 = '51' OR finalRecords.RC4 = '51' OR finalRecords.RC5 = '51' OR finalRecords.RC6 = '51' OR finalRecords.RC7 = '51' OR finalRecords.RC8 = '51' OR finalRecords.RC9 = '51' OR finalRecords.RC10 = '51') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_52						:=	(COUNT(GROUP, finalRecords.RC1 = '52' OR finalRecords.RC2 = '52' OR finalRecords.RC3 = '52' OR finalRecords.RC4 = '52' OR finalRecords.RC5 = '52' OR finalRecords.RC6 = '52' OR finalRecords.RC7 = '52' OR finalRecords.RC8 = '52' OR finalRecords.RC9 = '52' OR finalRecords.RC10 = '52') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_53						:=	(COUNT(GROUP, finalRecords.RC1 = '53' OR finalRecords.RC2 = '53' OR finalRecords.RC3 = '53' OR finalRecords.RC4 = '53' OR finalRecords.RC5 = '53' OR finalRecords.RC6 = '53' OR finalRecords.RC7 = '53' OR finalRecords.RC8 = '53' OR finalRecords.RC9 = '53' OR finalRecords.RC10 = '53') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_54						:=	(COUNT(GROUP, finalRecords.RC1 = '54' OR finalRecords.RC2 = '54' OR finalRecords.RC3 = '54' OR finalRecords.RC4 = '54' OR finalRecords.RC5 = '54' OR finalRecords.RC6 = '54' OR finalRecords.RC7 = '54' OR finalRecords.RC8 = '54' OR finalRecords.RC9 = '54' OR finalRecords.RC10 = '54') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_55						:=	(COUNT(GROUP, finalRecords.RC1 = '55' OR finalRecords.RC2 = '55' OR finalRecords.RC3 = '55' OR finalRecords.RC4 = '55' OR finalRecords.RC5 = '55' OR finalRecords.RC6 = '55' OR finalRecords.RC7 = '55' OR finalRecords.RC8 = '55' OR finalRecords.RC9 = '55' OR finalRecords.RC10 = '55') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_56						:=	(COUNT(GROUP, finalRecords.RC1 = '56' OR finalRecords.RC2 = '56' OR finalRecords.RC3 = '56' OR finalRecords.RC4 = '56' OR finalRecords.RC5 = '56' OR finalRecords.RC6 = '56' OR finalRecords.RC7 = '56' OR finalRecords.RC8 = '56' OR finalRecords.RC9 = '56' OR finalRecords.RC10 = '56') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_57						:=	(COUNT(GROUP, finalRecords.RC1 = '57' OR finalRecords.RC2 = '57' OR finalRecords.RC3 = '57' OR finalRecords.RC4 = '57' OR finalRecords.RC5 = '57' OR finalRecords.RC6 = '57' OR finalRecords.RC7 = '57' OR finalRecords.RC8 = '57' OR finalRecords.RC9 = '57' OR finalRecords.RC10 = '57') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_58						:=	(COUNT(GROUP, finalRecords.RC1 = '58' OR finalRecords.RC2 = '58' OR finalRecords.RC3 = '58' OR finalRecords.RC4 = '58' OR finalRecords.RC5 = '58' OR finalRecords.RC6 = '58' OR finalRecords.RC7 = '58' OR finalRecords.RC8 = '58' OR finalRecords.RC9 = '58' OR finalRecords.RC10 = '58') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_59						:=	(COUNT(GROUP, finalRecords.RC1 = '59' OR finalRecords.RC2 = '59' OR finalRecords.RC3 = '59' OR finalRecords.RC4 = '59' OR finalRecords.RC5 = '59' OR finalRecords.RC6 = '59' OR finalRecords.RC7 = '59' OR finalRecords.RC8 = '59' OR finalRecords.RC9 = '59' OR finalRecords.RC10 = '59') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_5Q						:=	(COUNT(GROUP, finalRecords.RC1 = '5Q' OR finalRecords.RC2 = '5Q' OR finalRecords.RC3 = '5Q' OR finalRecords.RC4 = '5Q' OR finalRecords.RC5 = '5Q' OR finalRecords.RC6 = '5Q' OR finalRecords.RC7 = '5Q' OR finalRecords.RC8 = '5Q' OR finalRecords.RC9 = '5Q' OR finalRecords.RC10 = '5Q') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_60						:=	(COUNT(GROUP, finalRecords.RC1 = '60' OR finalRecords.RC2 = '60' OR finalRecords.RC3 = '60' OR finalRecords.RC4 = '60' OR finalRecords.RC5 = '60' OR finalRecords.RC6 = '60' OR finalRecords.RC7 = '60' OR finalRecords.RC8 = '60' OR finalRecords.RC9 = '60' OR finalRecords.RC10 = '60') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_61						:=	(COUNT(GROUP, finalRecords.RC1 = '61' OR finalRecords.RC2 = '61' OR finalRecords.RC3 = '61' OR finalRecords.RC4 = '61' OR finalRecords.RC5 = '61' OR finalRecords.RC6 = '61' OR finalRecords.RC7 = '61' OR finalRecords.RC8 = '61' OR finalRecords.RC9 = '61' OR finalRecords.RC10 = '61') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_62						:=	(COUNT(GROUP, finalRecords.RC1 = '62' OR finalRecords.RC2 = '62' OR finalRecords.RC3 = '62' OR finalRecords.RC4 = '62' OR finalRecords.RC5 = '62' OR finalRecords.RC6 = '62' OR finalRecords.RC7 = '62' OR finalRecords.RC8 = '62' OR finalRecords.RC9 = '62' OR finalRecords.RC10 = '62') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_63						:=	(COUNT(GROUP, finalRecords.RC1 = '63' OR finalRecords.RC2 = '63' OR finalRecords.RC3 = '63' OR finalRecords.RC4 = '63' OR finalRecords.RC5 = '63' OR finalRecords.RC6 = '63' OR finalRecords.RC7 = '63' OR finalRecords.RC8 = '63' OR finalRecords.RC9 = '63' OR finalRecords.RC10 = '63') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_64						:=	(COUNT(GROUP, finalRecords.RC1 = '64' OR finalRecords.RC2 = '64' OR finalRecords.RC3 = '64' OR finalRecords.RC4 = '64' OR finalRecords.RC5 = '64' OR finalRecords.RC6 = '64' OR finalRecords.RC7 = '64' OR finalRecords.RC8 = '64' OR finalRecords.RC9 = '64' OR finalRecords.RC10 = '64') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_65						:=	(COUNT(GROUP, finalRecords.RC1 = '65' OR finalRecords.RC2 = '65' OR finalRecords.RC3 = '65' OR finalRecords.RC4 = '65' OR finalRecords.RC5 = '65' OR finalRecords.RC6 = '65' OR finalRecords.RC7 = '65' OR finalRecords.RC8 = '65' OR finalRecords.RC9 = '65' OR finalRecords.RC10 = '65') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_66						:=	(COUNT(GROUP, finalRecords.RC1 = '66' OR finalRecords.RC2 = '66' OR finalRecords.RC3 = '66' OR finalRecords.RC4 = '66' OR finalRecords.RC5 = '66' OR finalRecords.RC6 = '66' OR finalRecords.RC7 = '66' OR finalRecords.RC8 = '66' OR finalRecords.RC9 = '66' OR finalRecords.RC10 = '66') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_67						:=	(COUNT(GROUP, finalRecords.RC1 = '67' OR finalRecords.RC2 = '67' OR finalRecords.RC3 = '67' OR finalRecords.RC4 = '67' OR finalRecords.RC5 = '67' OR finalRecords.RC6 = '67' OR finalRecords.RC7 = '67' OR finalRecords.RC8 = '67' OR finalRecords.RC9 = '67' OR finalRecords.RC10 = '67') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_68						:=	(COUNT(GROUP, finalRecords.RC1 = '68' OR finalRecords.RC2 = '68' OR finalRecords.RC3 = '68' OR finalRecords.RC4 = '68' OR finalRecords.RC5 = '68' OR finalRecords.RC6 = '68' OR finalRecords.RC7 = '68' OR finalRecords.RC8 = '68' OR finalRecords.RC9 = '68' OR finalRecords.RC10 = '68') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_69						:=	(COUNT(GROUP, finalRecords.RC1 = '69' OR finalRecords.RC2 = '69' OR finalRecords.RC3 = '69' OR finalRecords.RC4 = '69' OR finalRecords.RC5 = '69' OR finalRecords.RC6 = '69' OR finalRecords.RC7 = '69' OR finalRecords.RC8 = '69' OR finalRecords.RC9 = '69' OR finalRecords.RC10 = '69') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_70						:=	(COUNT(GROUP, finalRecords.RC1 = '70' OR finalRecords.RC2 = '70' OR finalRecords.RC3 = '70' OR finalRecords.RC4 = '70' OR finalRecords.RC5 = '70' OR finalRecords.RC6 = '70' OR finalRecords.RC7 = '70' OR finalRecords.RC8 = '70' OR finalRecords.RC9 = '70' OR finalRecords.RC10 = '70') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_71						:=	(COUNT(GROUP, finalRecords.RC1 = '71' OR finalRecords.RC2 = '71' OR finalRecords.RC3 = '71' OR finalRecords.RC4 = '71' OR finalRecords.RC5 = '71' OR finalRecords.RC6 = '71' OR finalRecords.RC7 = '71' OR finalRecords.RC8 = '71' OR finalRecords.RC9 = '71' OR finalRecords.RC10 = '71') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_72						:=	(COUNT(GROUP, finalRecords.RC1 = '72' OR finalRecords.RC2 = '72' OR finalRecords.RC3 = '72' OR finalRecords.RC4 = '72' OR finalRecords.RC5 = '72' OR finalRecords.RC6 = '72' OR finalRecords.RC7 = '72' OR finalRecords.RC8 = '72' OR finalRecords.RC9 = '72' OR finalRecords.RC10 = '72') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_73						:=	(COUNT(GROUP, finalRecords.RC1 = '73' OR finalRecords.RC2 = '73' OR finalRecords.RC3 = '73' OR finalRecords.RC4 = '73' OR finalRecords.RC5 = '73' OR finalRecords.RC6 = '73' OR finalRecords.RC7 = '73' OR finalRecords.RC8 = '73' OR finalRecords.RC9 = '73' OR finalRecords.RC10 = '73') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_74						:=	(COUNT(GROUP, finalRecords.RC1 = '74' OR finalRecords.RC2 = '74' OR finalRecords.RC3 = '74' OR finalRecords.RC4 = '74' OR finalRecords.RC5 = '74' OR finalRecords.RC6 = '74' OR finalRecords.RC7 = '74' OR finalRecords.RC8 = '74' OR finalRecords.RC9 = '74' OR finalRecords.RC10 = '74') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_75						:=	(COUNT(GROUP, finalRecords.RC1 = '75' OR finalRecords.RC2 = '75' OR finalRecords.RC3 = '75' OR finalRecords.RC4 = '75' OR finalRecords.RC5 = '75' OR finalRecords.RC6 = '75' OR finalRecords.RC7 = '75' OR finalRecords.RC8 = '75' OR finalRecords.RC9 = '75' OR finalRecords.RC10 = '75') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_76						:=	(COUNT(GROUP, finalRecords.RC1 = '76' OR finalRecords.RC2 = '76' OR finalRecords.RC3 = '76' OR finalRecords.RC4 = '76' OR finalRecords.RC5 = '76' OR finalRecords.RC6 = '76' OR finalRecords.RC7 = '76' OR finalRecords.RC8 = '76' OR finalRecords.RC9 = '76' OR finalRecords.RC10 = '76') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_77						:=	(COUNT(GROUP, finalRecords.RC1 = '77' OR finalRecords.RC2 = '77' OR finalRecords.RC3 = '77' OR finalRecords.RC4 = '77' OR finalRecords.RC5 = '77' OR finalRecords.RC6 = '77' OR finalRecords.RC7 = '77' OR finalRecords.RC8 = '77' OR finalRecords.RC9 = '77' OR finalRecords.RC10 = '77') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_78						:=	(COUNT(GROUP, finalRecords.RC1 = '78' OR finalRecords.RC2 = '78' OR finalRecords.RC3 = '78' OR finalRecords.RC4 = '78' OR finalRecords.RC5 = '78' OR finalRecords.RC6 = '78' OR finalRecords.RC7 = '78' OR finalRecords.RC8 = '78' OR finalRecords.RC9 = '78' OR finalRecords.RC10 = '78') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_79						:=	(COUNT(GROUP, finalRecords.RC1 = '79' OR finalRecords.RC2 = '79' OR finalRecords.RC3 = '79' OR finalRecords.RC4 = '79' OR finalRecords.RC5 = '79' OR finalRecords.RC6 = '79' OR finalRecords.RC7 = '79' OR finalRecords.RC8 = '79' OR finalRecords.RC9 = '79' OR finalRecords.RC10 = '79') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_80						:=	(COUNT(GROUP, finalRecords.RC1 = '80' OR finalRecords.RC2 = '80' OR finalRecords.RC3 = '80' OR finalRecords.RC4 = '80' OR finalRecords.RC5 = '80' OR finalRecords.RC6 = '80' OR finalRecords.RC7 = '80' OR finalRecords.RC8 = '80' OR finalRecords.RC9 = '80' OR finalRecords.RC10 = '80') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_81						:=	(COUNT(GROUP, finalRecords.RC1 = '81' OR finalRecords.RC2 = '81' OR finalRecords.RC3 = '81' OR finalRecords.RC4 = '81' OR finalRecords.RC5 = '81' OR finalRecords.RC6 = '81' OR finalRecords.RC7 = '81' OR finalRecords.RC8 = '81' OR finalRecords.RC9 = '81' OR finalRecords.RC10 = '81') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_82						:=	(COUNT(GROUP, finalRecords.RC1 = '82' OR finalRecords.RC2 = '82' OR finalRecords.RC3 = '82' OR finalRecords.RC4 = '82' OR finalRecords.RC5 = '82' OR finalRecords.RC6 = '82' OR finalRecords.RC7 = '82' OR finalRecords.RC8 = '82' OR finalRecords.RC9 = '82' OR finalRecords.RC10 = '82') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_83						:=	(COUNT(GROUP, finalRecords.RC1 = '83' OR finalRecords.RC2 = '83' OR finalRecords.RC3 = '83' OR finalRecords.RC4 = '83' OR finalRecords.RC5 = '83' OR finalRecords.RC6 = '83' OR finalRecords.RC7 = '83' OR finalRecords.RC8 = '83' OR finalRecords.RC9 = '83' OR finalRecords.RC10 = '83') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_84						:=	(COUNT(GROUP, finalRecords.RC1 = '84' OR finalRecords.RC2 = '84' OR finalRecords.RC3 = '84' OR finalRecords.RC4 = '84' OR finalRecords.RC5 = '84' OR finalRecords.RC6 = '84' OR finalRecords.RC7 = '84' OR finalRecords.RC8 = '84' OR finalRecords.RC9 = '84' OR finalRecords.RC10 = '84') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_85						:=	(COUNT(GROUP, finalRecords.RC1 = '85' OR finalRecords.RC2 = '85' OR finalRecords.RC3 = '85' OR finalRecords.RC4 = '85' OR finalRecords.RC5 = '85' OR finalRecords.RC6 = '85' OR finalRecords.RC7 = '85' OR finalRecords.RC8 = '85' OR finalRecords.RC9 = '85' OR finalRecords.RC10 = '85') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_86						:=	(COUNT(GROUP, finalRecords.RC1 = '86' OR finalRecords.RC2 = '86' OR finalRecords.RC3 = '86' OR finalRecords.RC4 = '86' OR finalRecords.RC5 = '86' OR finalRecords.RC6 = '86' OR finalRecords.RC7 = '86' OR finalRecords.RC8 = '86' OR finalRecords.RC9 = '86' OR finalRecords.RC10 = '86') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_87						:=	(COUNT(GROUP, finalRecords.RC1 = '87' OR finalRecords.RC2 = '87' OR finalRecords.RC3 = '87' OR finalRecords.RC4 = '87' OR finalRecords.RC5 = '87' OR finalRecords.RC6 = '87' OR finalRecords.RC7 = '87' OR finalRecords.RC8 = '87' OR finalRecords.RC9 = '87' OR finalRecords.RC10 = '87') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_88						:=	(COUNT(GROUP, finalRecords.RC1 = '88' OR finalRecords.RC2 = '88' OR finalRecords.RC3 = '88' OR finalRecords.RC4 = '88' OR finalRecords.RC5 = '88' OR finalRecords.RC6 = '88' OR finalRecords.RC7 = '88' OR finalRecords.RC8 = '88' OR finalRecords.RC9 = '88' OR finalRecords.RC10 = '88') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_89						:=	(COUNT(GROUP, finalRecords.RC1 = '89' OR finalRecords.RC2 = '89' OR finalRecords.RC3 = '89' OR finalRecords.RC4 = '89' OR finalRecords.RC5 = '89' OR finalRecords.RC6 = '89' OR finalRecords.RC7 = '89' OR finalRecords.RC8 = '89' OR finalRecords.RC9 = '89' OR finalRecords.RC10 = '89') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_90						:=	(COUNT(GROUP, finalRecords.RC1 = '90' OR finalRecords.RC2 = '90' OR finalRecords.RC3 = '90' OR finalRecords.RC4 = '90' OR finalRecords.RC5 = '90' OR finalRecords.RC6 = '90' OR finalRecords.RC7 = '90' OR finalRecords.RC8 = '90' OR finalRecords.RC9 = '90' OR finalRecords.RC10 = '90') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_91						:=	(COUNT(GROUP, finalRecords.RC1 = '91' OR finalRecords.RC2 = '91' OR finalRecords.RC3 = '91' OR finalRecords.RC4 = '91' OR finalRecords.RC5 = '91' OR finalRecords.RC6 = '91' OR finalRecords.RC7 = '91' OR finalRecords.RC8 = '91' OR finalRecords.RC9 = '91' OR finalRecords.RC10 = '91') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_92						:=	(COUNT(GROUP, finalRecords.RC1 = '92' OR finalRecords.RC2 = '92' OR finalRecords.RC3 = '92' OR finalRecords.RC4 = '92' OR finalRecords.RC5 = '92' OR finalRecords.RC6 = '92' OR finalRecords.RC7 = '92' OR finalRecords.RC8 = '92' OR finalRecords.RC9 = '92' OR finalRecords.RC10 = '92') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_93						:=	(COUNT(GROUP, finalRecords.RC1 = '93' OR finalRecords.RC2 = '93' OR finalRecords.RC3 = '93' OR finalRecords.RC4 = '93' OR finalRecords.RC5 = '93' OR finalRecords.RC6 = '93' OR finalRecords.RC7 = '93' OR finalRecords.RC8 = '93' OR finalRecords.RC9 = '93' OR finalRecords.RC10 = '93') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_94						:=	(COUNT(GROUP, finalRecords.RC1 = '94' OR finalRecords.RC2 = '94' OR finalRecords.RC3 = '94' OR finalRecords.RC4 = '94' OR finalRecords.RC5 = '94' OR finalRecords.RC6 = '94' OR finalRecords.RC7 = '94' OR finalRecords.RC8 = '94' OR finalRecords.RC9 = '94' OR finalRecords.RC10 = '94') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_95						:=	(COUNT(GROUP, finalRecords.RC1 = '95' OR finalRecords.RC2 = '95' OR finalRecords.RC3 = '95' OR finalRecords.RC4 = '95' OR finalRecords.RC5 = '95' OR finalRecords.RC6 = '95' OR finalRecords.RC7 = '95' OR finalRecords.RC8 = '95' OR finalRecords.RC9 = '95' OR finalRecords.RC10 = '95') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_96						:=	(COUNT(GROUP, finalRecords.RC1 = '96' OR finalRecords.RC2 = '96' OR finalRecords.RC3 = '96' OR finalRecords.RC4 = '96' OR finalRecords.RC5 = '96' OR finalRecords.RC6 = '96' OR finalRecords.RC7 = '96' OR finalRecords.RC8 = '96' OR finalRecords.RC9 = '96' OR finalRecords.RC10 = '96') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_97						:=	(COUNT(GROUP, finalRecords.RC1 = '97' OR finalRecords.RC2 = '97' OR finalRecords.RC3 = '97' OR finalRecords.RC4 = '97' OR finalRecords.RC5 = '97' OR finalRecords.RC6 = '97' OR finalRecords.RC7 = '97' OR finalRecords.RC8 = '97' OR finalRecords.RC9 = '97' OR finalRecords.RC10 = '97') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_98						:=	(COUNT(GROUP, finalRecords.RC1 = '98' OR finalRecords.RC2 = '98' OR finalRecords.RC3 = '98' OR finalRecords.RC4 = '98' OR finalRecords.RC5 = '98' OR finalRecords.RC6 = '98' OR finalRecords.RC7 = '98' OR finalRecords.RC8 = '98' OR finalRecords.RC9 = '98' OR finalRecords.RC10 = '98') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_99						:=	(COUNT(GROUP, finalRecords.RC1 = '99' OR finalRecords.RC2 = '99' OR finalRecords.RC3 = '99' OR finalRecords.RC4 = '99' OR finalRecords.RC5 = '99' OR finalRecords.RC6 = '99' OR finalRecords.RC7 = '99' OR finalRecords.RC8 = '99' OR finalRecords.RC9 = '99' OR finalRecords.RC10 = '99') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9A						:=	(COUNT(GROUP, finalRecords.RC1 = '9A' OR finalRecords.RC2 = '9A' OR finalRecords.RC3 = '9A' OR finalRecords.RC4 = '9A' OR finalRecords.RC5 = '9A' OR finalRecords.RC6 = '9A' OR finalRecords.RC7 = '9A' OR finalRecords.RC8 = '9A' OR finalRecords.RC9 = '9A' OR finalRecords.RC10 = '9A') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9B						:=	(COUNT(GROUP, finalRecords.RC1 = '9B' OR finalRecords.RC2 = '9B' OR finalRecords.RC3 = '9B' OR finalRecords.RC4 = '9B' OR finalRecords.RC5 = '9B' OR finalRecords.RC6 = '9B' OR finalRecords.RC7 = '9B' OR finalRecords.RC8 = '9B' OR finalRecords.RC9 = '9B' OR finalRecords.RC10 = '9B') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9C						:=	(COUNT(GROUP, finalRecords.RC1 = '9C' OR finalRecords.RC2 = '9C' OR finalRecords.RC3 = '9C' OR finalRecords.RC4 = '9C' OR finalRecords.RC5 = '9C' OR finalRecords.RC6 = '9C' OR finalRecords.RC7 = '9C' OR finalRecords.RC8 = '9C' OR finalRecords.RC9 = '9C' OR finalRecords.RC10 = '9C') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9D						:=	(COUNT(GROUP, finalRecords.RC1 = '9D' OR finalRecords.RC2 = '9D' OR finalRecords.RC3 = '9D' OR finalRecords.RC4 = '9D' OR finalRecords.RC5 = '9D' OR finalRecords.RC6 = '9D' OR finalRecords.RC7 = '9D' OR finalRecords.RC8 = '9D' OR finalRecords.RC9 = '9D' OR finalRecords.RC10 = '9D') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9E						:=	(COUNT(GROUP, finalRecords.RC1 = '9E' OR finalRecords.RC2 = '9E' OR finalRecords.RC3 = '9E' OR finalRecords.RC4 = '9E' OR finalRecords.RC5 = '9E' OR finalRecords.RC6 = '9E' OR finalRecords.RC7 = '9E' OR finalRecords.RC8 = '9E' OR finalRecords.RC9 = '9E' OR finalRecords.RC10 = '9E') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9F						:=	(COUNT(GROUP, finalRecords.RC1 = '9F' OR finalRecords.RC2 = '9F' OR finalRecords.RC3 = '9F' OR finalRecords.RC4 = '9F' OR finalRecords.RC5 = '9F' OR finalRecords.RC6 = '9F' OR finalRecords.RC7 = '9F' OR finalRecords.RC8 = '9F' OR finalRecords.RC9 = '9F' OR finalRecords.RC10 = '9F') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9G						:=	(COUNT(GROUP, finalRecords.RC1 = '9G' OR finalRecords.RC2 = '9G' OR finalRecords.RC3 = '9G' OR finalRecords.RC4 = '9G' OR finalRecords.RC5 = '9G' OR finalRecords.RC6 = '9G' OR finalRecords.RC7 = '9G' OR finalRecords.RC8 = '9G' OR finalRecords.RC9 = '9G' OR finalRecords.RC10 = '9G') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9H						:=	(COUNT(GROUP, finalRecords.RC1 = '9H' OR finalRecords.RC2 = '9H' OR finalRecords.RC3 = '9H' OR finalRecords.RC4 = '9H' OR finalRecords.RC5 = '9H' OR finalRecords.RC6 = '9H' OR finalRecords.RC7 = '9H' OR finalRecords.RC8 = '9H' OR finalRecords.RC9 = '9H' OR finalRecords.RC10 = '9H') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9I						:=	(COUNT(GROUP, finalRecords.RC1 = '9I' OR finalRecords.RC2 = '9I' OR finalRecords.RC3 = '9I' OR finalRecords.RC4 = '9I' OR finalRecords.RC5 = '9I' OR finalRecords.RC6 = '9I' OR finalRecords.RC7 = '9I' OR finalRecords.RC8 = '9I' OR finalRecords.RC9 = '9I' OR finalRecords.RC10 = '9I') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9J						:=	(COUNT(GROUP, finalRecords.RC1 = '9J' OR finalRecords.RC2 = '9J' OR finalRecords.RC3 = '9J' OR finalRecords.RC4 = '9J' OR finalRecords.RC5 = '9J' OR finalRecords.RC6 = '9J' OR finalRecords.RC7 = '9J' OR finalRecords.RC8 = '9J' OR finalRecords.RC9 = '9J' OR finalRecords.RC10 = '9J') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9K						:=	(COUNT(GROUP, finalRecords.RC1 = '9K' OR finalRecords.RC2 = '9K' OR finalRecords.RC3 = '9K' OR finalRecords.RC4 = '9K' OR finalRecords.RC5 = '9K' OR finalRecords.RC6 = '9K' OR finalRecords.RC7 = '9K' OR finalRecords.RC8 = '9K' OR finalRecords.RC9 = '9K' OR finalRecords.RC10 = '9K') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9L						:=	(COUNT(GROUP, finalRecords.RC1 = '9L' OR finalRecords.RC2 = '9L' OR finalRecords.RC3 = '9L' OR finalRecords.RC4 = '9L' OR finalRecords.RC5 = '9L' OR finalRecords.RC6 = '9L' OR finalRecords.RC7 = '9L' OR finalRecords.RC8 = '9L' OR finalRecords.RC9 = '9L' OR finalRecords.RC10 = '9L') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9M						:=	(COUNT(GROUP, finalRecords.RC1 = '9M' OR finalRecords.RC2 = '9M' OR finalRecords.RC3 = '9M' OR finalRecords.RC4 = '9M' OR finalRecords.RC5 = '9M' OR finalRecords.RC6 = '9M' OR finalRecords.RC7 = '9M' OR finalRecords.RC8 = '9M' OR finalRecords.RC9 = '9M' OR finalRecords.RC10 = '9M') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9N						:=	(COUNT(GROUP, finalRecords.RC1 = '9N' OR finalRecords.RC2 = '9N' OR finalRecords.RC3 = '9N' OR finalRecords.RC4 = '9N' OR finalRecords.RC5 = '9N' OR finalRecords.RC6 = '9N' OR finalRecords.RC7 = '9N' OR finalRecords.RC8 = '9N' OR finalRecords.RC9 = '9N' OR finalRecords.RC10 = '9N') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9O						:=	(COUNT(GROUP, finalRecords.RC1 = '9O' OR finalRecords.RC2 = '9O' OR finalRecords.RC3 = '9O' OR finalRecords.RC4 = '9O' OR finalRecords.RC5 = '9O' OR finalRecords.RC6 = '9O' OR finalRecords.RC7 = '9O' OR finalRecords.RC8 = '9O' OR finalRecords.RC9 = '9O' OR finalRecords.RC10 = '9O') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9P						:=	(COUNT(GROUP, finalRecords.RC1 = '9P' OR finalRecords.RC2 = '9P' OR finalRecords.RC3 = '9P' OR finalRecords.RC4 = '9P' OR finalRecords.RC5 = '9P' OR finalRecords.RC6 = '9P' OR finalRecords.RC7 = '9P' OR finalRecords.RC8 = '9P' OR finalRecords.RC9 = '9P' OR finalRecords.RC10 = '9P') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9Q						:=	(COUNT(GROUP, finalRecords.RC1 = '9Q' OR finalRecords.RC2 = '9Q' OR finalRecords.RC3 = '9Q' OR finalRecords.RC4 = '9Q' OR finalRecords.RC5 = '9Q' OR finalRecords.RC6 = '9Q' OR finalRecords.RC7 = '9Q' OR finalRecords.RC8 = '9Q' OR finalRecords.RC9 = '9Q' OR finalRecords.RC10 = '9Q') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9R						:=	(COUNT(GROUP, finalRecords.RC1 = '9R' OR finalRecords.RC2 = '9R' OR finalRecords.RC3 = '9R' OR finalRecords.RC4 = '9R' OR finalRecords.RC5 = '9R' OR finalRecords.RC6 = '9R' OR finalRecords.RC7 = '9R' OR finalRecords.RC8 = '9R' OR finalRecords.RC9 = '9R' OR finalRecords.RC10 = '9R') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9S						:=	(COUNT(GROUP, finalRecords.RC1 = '9S' OR finalRecords.RC2 = '9S' OR finalRecords.RC3 = '9S' OR finalRecords.RC4 = '9S' OR finalRecords.RC5 = '9S' OR finalRecords.RC6 = '9S' OR finalRecords.RC7 = '9S' OR finalRecords.RC8 = '9S' OR finalRecords.RC9 = '9S' OR finalRecords.RC10 = '9S') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9T						:=	(COUNT(GROUP, finalRecords.RC1 = '9T' OR finalRecords.RC2 = '9T' OR finalRecords.RC3 = '9T' OR finalRecords.RC4 = '9T' OR finalRecords.RC5 = '9T' OR finalRecords.RC6 = '9T' OR finalRecords.RC7 = '9T' OR finalRecords.RC8 = '9T' OR finalRecords.RC9 = '9T' OR finalRecords.RC10 = '9T') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9U						:=	(COUNT(GROUP, finalRecords.RC1 = '9U' OR finalRecords.RC2 = '9U' OR finalRecords.RC3 = '9U' OR finalRecords.RC4 = '9U' OR finalRecords.RC5 = '9U' OR finalRecords.RC6 = '9U' OR finalRecords.RC7 = '9U' OR finalRecords.RC8 = '9U' OR finalRecords.RC9 = '9U' OR finalRecords.RC10 = '9U') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9V						:=	(COUNT(GROUP, finalRecords.RC1 = '9V' OR finalRecords.RC2 = '9V' OR finalRecords.RC3 = '9V' OR finalRecords.RC4 = '9V' OR finalRecords.RC5 = '9V' OR finalRecords.RC6 = '9V' OR finalRecords.RC7 = '9V' OR finalRecords.RC8 = '9V' OR finalRecords.RC9 = '9V' OR finalRecords.RC10 = '9V') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9W						:=	(COUNT(GROUP, finalRecords.RC1 = '9W' OR finalRecords.RC2 = '9W' OR finalRecords.RC3 = '9W' OR finalRecords.RC4 = '9W' OR finalRecords.RC5 = '9W' OR finalRecords.RC6 = '9W' OR finalRecords.RC7 = '9W' OR finalRecords.RC8 = '9W' OR finalRecords.RC9 = '9W' OR finalRecords.RC10 = '9W') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_9X						:=	(COUNT(GROUP, finalRecords.RC1 = '9X' OR finalRecords.RC2 = '9X' OR finalRecords.RC3 = '9X' OR finalRecords.RC4 = '9X' OR finalRecords.RC5 = '9X' OR finalRecords.RC6 = '9X' OR finalRecords.RC7 = '9X' OR finalRecords.RC8 = '9X' OR finalRecords.RC9 = '9X' OR finalRecords.RC10 = '9X') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A0						:=	(COUNT(GROUP, finalRecords.RC1 = 'A0' OR finalRecords.RC2 = 'A0' OR finalRecords.RC3 = 'A0' OR finalRecords.RC4 = 'A0' OR finalRecords.RC5 = 'A0' OR finalRecords.RC6 = 'A0' OR finalRecords.RC7 = 'A0' OR finalRecords.RC8 = 'A0' OR finalRecords.RC9 = 'A0' OR finalRecords.RC10 = 'A0') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A1						:=	(COUNT(GROUP, finalRecords.RC1 = 'A1' OR finalRecords.RC2 = 'A1' OR finalRecords.RC3 = 'A1' OR finalRecords.RC4 = 'A1' OR finalRecords.RC5 = 'A1' OR finalRecords.RC6 = 'A1' OR finalRecords.RC7 = 'A1' OR finalRecords.RC8 = 'A1' OR finalRecords.RC9 = 'A1' OR finalRecords.RC10 = 'A1') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A2						:=	(COUNT(GROUP, finalRecords.RC1 = 'A2' OR finalRecords.RC2 = 'A2' OR finalRecords.RC3 = 'A2' OR finalRecords.RC4 = 'A2' OR finalRecords.RC5 = 'A2' OR finalRecords.RC6 = 'A2' OR finalRecords.RC7 = 'A2' OR finalRecords.RC8 = 'A2' OR finalRecords.RC9 = 'A2' OR finalRecords.RC10 = 'A2') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A3						:=	(COUNT(GROUP, finalRecords.RC1 = 'A3' OR finalRecords.RC2 = 'A3' OR finalRecords.RC3 = 'A3' OR finalRecords.RC4 = 'A3' OR finalRecords.RC5 = 'A3' OR finalRecords.RC6 = 'A3' OR finalRecords.RC7 = 'A3' OR finalRecords.RC8 = 'A3' OR finalRecords.RC9 = 'A3' OR finalRecords.RC10 = 'A3') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A4						:=	(COUNT(GROUP, finalRecords.RC1 = 'A4' OR finalRecords.RC2 = 'A4' OR finalRecords.RC3 = 'A4' OR finalRecords.RC4 = 'A4' OR finalRecords.RC5 = 'A4' OR finalRecords.RC6 = 'A4' OR finalRecords.RC7 = 'A4' OR finalRecords.RC8 = 'A4' OR finalRecords.RC9 = 'A4' OR finalRecords.RC10 = 'A4') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A5						:=	(COUNT(GROUP, finalRecords.RC1 = 'A5' OR finalRecords.RC2 = 'A5' OR finalRecords.RC3 = 'A5' OR finalRecords.RC4 = 'A5' OR finalRecords.RC5 = 'A5' OR finalRecords.RC6 = 'A5' OR finalRecords.RC7 = 'A5' OR finalRecords.RC8 = 'A5' OR finalRecords.RC9 = 'A5' OR finalRecords.RC10 = 'A5') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A6						:=	(COUNT(GROUP, finalRecords.RC1 = 'A6' OR finalRecords.RC2 = 'A6' OR finalRecords.RC3 = 'A6' OR finalRecords.RC4 = 'A6' OR finalRecords.RC5 = 'A6' OR finalRecords.RC6 = 'A6' OR finalRecords.RC7 = 'A6' OR finalRecords.RC8 = 'A6' OR finalRecords.RC9 = 'A6' OR finalRecords.RC10 = 'A6') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A7						:=	(COUNT(GROUP, finalRecords.RC1 = 'A7' OR finalRecords.RC2 = 'A7' OR finalRecords.RC3 = 'A7' OR finalRecords.RC4 = 'A7' OR finalRecords.RC5 = 'A7' OR finalRecords.RC6 = 'A7' OR finalRecords.RC7 = 'A7' OR finalRecords.RC8 = 'A7' OR finalRecords.RC9 = 'A7' OR finalRecords.RC10 = 'A7') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A8						:=	(COUNT(GROUP, finalRecords.RC1 = 'A8' OR finalRecords.RC2 = 'A8' OR finalRecords.RC3 = 'A8' OR finalRecords.RC4 = 'A8' OR finalRecords.RC5 = 'A8' OR finalRecords.RC6 = 'A8' OR finalRecords.RC7 = 'A8' OR finalRecords.RC8 = 'A8' OR finalRecords.RC9 = 'A8' OR finalRecords.RC10 = 'A8') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A9						:=	(COUNT(GROUP, finalRecords.RC1 = 'A9' OR finalRecords.RC2 = 'A9' OR finalRecords.RC3 = 'A9' OR finalRecords.RC4 = 'A9' OR finalRecords.RC5 = 'A9' OR finalRecords.RC6 = 'A9' OR finalRecords.RC7 = 'A9' OR finalRecords.RC8 = 'A9' OR finalRecords.RC9 = 'A9' OR finalRecords.RC10 = 'A9') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_B0						:=	(COUNT(GROUP, finalRecords.RC1 = 'B0' OR finalRecords.RC2 = 'B0' OR finalRecords.RC3 = 'B0' OR finalRecords.RC4 = 'B0' OR finalRecords.RC5 = 'B0' OR finalRecords.RC6 = 'B0' OR finalRecords.RC7 = 'B0' OR finalRecords.RC8 = 'B0' OR finalRecords.RC9 = 'B0' OR finalRecords.RC10 = 'B0') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_BO						:=	(COUNT(GROUP, finalRecords.RC1 = 'BO' OR finalRecords.RC2 = 'BO' OR finalRecords.RC3 = 'BO' OR finalRecords.RC4 = 'BO' OR finalRecords.RC5 = 'BO' OR finalRecords.RC6 = 'BO' OR finalRecords.RC7 = 'BO' OR finalRecords.RC8 = 'BO' OR finalRecords.RC9 = 'BO' OR finalRecords.RC10 = 'BO') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_CL						:=	(COUNT(GROUP, finalRecords.RC1 = 'CL' OR finalRecords.RC2 = 'CL' OR finalRecords.RC3 = 'CL' OR finalRecords.RC4 = 'CL' OR finalRecords.RC5 = 'CL' OR finalRecords.RC6 = 'CL' OR finalRecords.RC7 = 'CL' OR finalRecords.RC8 = 'CL' OR finalRecords.RC9 = 'CL' OR finalRecords.RC10 = 'CL') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_CO						:=	(COUNT(GROUP, finalRecords.RC1 = 'CO' OR finalRecords.RC2 = 'CO' OR finalRecords.RC3 = 'CO' OR finalRecords.RC4 = 'CO' OR finalRecords.RC5 = 'CO' OR finalRecords.RC6 = 'CO' OR finalRecords.RC7 = 'CO' OR finalRecords.RC8 = 'CO' OR finalRecords.RC9 = 'CO' OR finalRecords.RC10 = 'CO') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_CR						:=	(COUNT(GROUP, finalRecords.RC1 = 'CR' OR finalRecords.RC2 = 'CR' OR finalRecords.RC3 = 'CR' OR finalRecords.RC4 = 'CR' OR finalRecords.RC5 = 'CR' OR finalRecords.RC6 = 'CR' OR finalRecords.RC7 = 'CR' OR finalRecords.RC8 = 'CR' OR finalRecords.RC9 = 'CR' OR finalRecords.RC10 = 'CR') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_CZ						:=	(COUNT(GROUP, finalRecords.RC1 = 'CZ' OR finalRecords.RC2 = 'CZ' OR finalRecords.RC3 = 'CZ' OR finalRecords.RC4 = 'CZ' OR finalRecords.RC5 = 'CZ' OR finalRecords.RC6 = 'CZ' OR finalRecords.RC7 = 'CZ' OR finalRecords.RC8 = 'CZ' OR finalRecords.RC9 = 'CZ' OR finalRecords.RC10 = 'CZ') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_DD						:=	(COUNT(GROUP, finalRecords.RC1 = 'DD' OR finalRecords.RC2 = 'DD' OR finalRecords.RC3 = 'DD' OR finalRecords.RC4 = 'DD' OR finalRecords.RC5 = 'DD' OR finalRecords.RC6 = 'DD' OR finalRecords.RC7 = 'DD' OR finalRecords.RC8 = 'DD' OR finalRecords.RC9 = 'DD' OR finalRecords.RC10 = 'DD') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_DF						:=	(COUNT(GROUP, finalRecords.RC1 = 'DF' OR finalRecords.RC2 = 'DF' OR finalRecords.RC3 = 'DF' OR finalRecords.RC4 = 'DF' OR finalRecords.RC5 = 'DF' OR finalRecords.RC6 = 'DF' OR finalRecords.RC7 = 'DF' OR finalRecords.RC8 = 'DF' OR finalRecords.RC9 = 'DF' OR finalRecords.RC10 = 'DF') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_DM						:=	(COUNT(GROUP, finalRecords.RC1 = 'DM' OR finalRecords.RC2 = 'DM' OR finalRecords.RC3 = 'DM' OR finalRecords.RC4 = 'DM' OR finalRecords.RC5 = 'DM' OR finalRecords.RC6 = 'DM' OR finalRecords.RC7 = 'DM' OR finalRecords.RC8 = 'DM' OR finalRecords.RC9 = 'DM' OR finalRecords.RC10 = 'DM') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_DV						:=	(COUNT(GROUP, finalRecords.RC1 = 'DV' OR finalRecords.RC2 = 'DV' OR finalRecords.RC3 = 'DV' OR finalRecords.RC4 = 'DV' OR finalRecords.RC5 = 'DV' OR finalRecords.RC6 = 'DV' OR finalRecords.RC7 = 'DV' OR finalRecords.RC8 = 'DV' OR finalRecords.RC9 = 'DV' OR finalRecords.RC10 = 'DV') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_EV						:=	(COUNT(GROUP, finalRecords.RC1 = 'EV' OR finalRecords.RC2 = 'EV' OR finalRecords.RC3 = 'EV' OR finalRecords.RC4 = 'EV' OR finalRecords.RC5 = 'EV' OR finalRecords.RC6 = 'EV' OR finalRecords.RC7 = 'EV' OR finalRecords.RC8 = 'EV' OR finalRecords.RC9 = 'EV' OR finalRecords.RC10 = 'EV') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_FB						:=	(COUNT(GROUP, finalRecords.RC1 = 'FB' OR finalRecords.RC2 = 'FB' OR finalRecords.RC3 = 'FB' OR finalRecords.RC4 = 'FB' OR finalRecords.RC5 = 'FB' OR finalRecords.RC6 = 'FB' OR finalRecords.RC7 = 'FB' OR finalRecords.RC8 = 'FB' OR finalRecords.RC9 = 'FB' OR finalRecords.RC10 = 'FB') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_FM						:=	(COUNT(GROUP, finalRecords.RC1 = 'FM' OR finalRecords.RC2 = 'FM' OR finalRecords.RC3 = 'FM' OR finalRecords.RC4 = 'FM' OR finalRecords.RC5 = 'FM' OR finalRecords.RC6 = 'FM' OR finalRecords.RC7 = 'FM' OR finalRecords.RC8 = 'FM' OR finalRecords.RC9 = 'FM' OR finalRecords.RC10 = 'FM') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_FQ						:=	(COUNT(GROUP, finalRecords.RC1 = 'FQ' OR finalRecords.RC2 = 'FQ' OR finalRecords.RC3 = 'FQ' OR finalRecords.RC4 = 'FQ' OR finalRecords.RC5 = 'FQ' OR finalRecords.RC6 = 'FQ' OR finalRecords.RC7 = 'FQ' OR finalRecords.RC8 = 'FQ' OR finalRecords.RC9 = 'FQ' OR finalRecords.RC10 = 'FQ') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_FR						:=	(COUNT(GROUP, finalRecords.RC1 = 'FR' OR finalRecords.RC2 = 'FR' OR finalRecords.RC3 = 'FR' OR finalRecords.RC4 = 'FR' OR finalRecords.RC5 = 'FR' OR finalRecords.RC6 = 'FR' OR finalRecords.RC7 = 'FR' OR finalRecords.RC8 = 'FR' OR finalRecords.RC9 = 'FR' OR finalRecords.RC10 = 'FR') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_FV						:=	(COUNT(GROUP, finalRecords.RC1 = 'FV' OR finalRecords.RC2 = 'FV' OR finalRecords.RC3 = 'FV' OR finalRecords.RC4 = 'FV' OR finalRecords.RC5 = 'FV' OR finalRecords.RC6 = 'FV' OR finalRecords.RC7 = 'FV' OR finalRecords.RC8 = 'FV' OR finalRecords.RC9 = 'FV' OR finalRecords.RC10 = 'FV') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_IA						:=	(COUNT(GROUP, finalRecords.RC1 = 'IA' OR finalRecords.RC2 = 'IA' OR finalRecords.RC3 = 'IA' OR finalRecords.RC4 = 'IA' OR finalRecords.RC5 = 'IA' OR finalRecords.RC6 = 'IA' OR finalRecords.RC7 = 'IA' OR finalRecords.RC8 = 'IA' OR finalRecords.RC9 = 'IA' OR finalRecords.RC10 = 'IA') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_IB						:=	(COUNT(GROUP, finalRecords.RC1 = 'IB' OR finalRecords.RC2 = 'IB' OR finalRecords.RC3 = 'IB' OR finalRecords.RC4 = 'IB' OR finalRecords.RC5 = 'IB' OR finalRecords.RC6 = 'IB' OR finalRecords.RC7 = 'IB' OR finalRecords.RC8 = 'IB' OR finalRecords.RC9 = 'IB' OR finalRecords.RC10 = 'IB') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_IC						:=	(COUNT(GROUP, finalRecords.RC1 = 'IC' OR finalRecords.RC2 = 'IC' OR finalRecords.RC3 = 'IC' OR finalRecords.RC4 = 'IC' OR finalRecords.RC5 = 'IC' OR finalRecords.RC6 = 'IC' OR finalRecords.RC7 = 'IC' OR finalRecords.RC8 = 'IC' OR finalRecords.RC9 = 'IC' OR finalRecords.RC10 = 'IC') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_ID						:=	(COUNT(GROUP, finalRecords.RC1 = 'ID' OR finalRecords.RC2 = 'ID' OR finalRecords.RC3 = 'ID' OR finalRecords.RC4 = 'ID' OR finalRecords.RC5 = 'ID' OR finalRecords.RC6 = 'ID' OR finalRecords.RC7 = 'ID' OR finalRecords.RC8 = 'ID' OR finalRecords.RC9 = 'ID' OR finalRecords.RC10 = 'ID') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_IE						:=	(COUNT(GROUP, finalRecords.RC1 = 'IE' OR finalRecords.RC2 = 'IE' OR finalRecords.RC3 = 'IE' OR finalRecords.RC4 = 'IE' OR finalRecords.RC5 = 'IE' OR finalRecords.RC6 = 'IE' OR finalRecords.RC7 = 'IE' OR finalRecords.RC8 = 'IE' OR finalRecords.RC9 = 'IE' OR finalRecords.RC10 = 'IE') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_IF						:=	(COUNT(GROUP, finalRecords.RC1 = 'IF' OR finalRecords.RC2 = 'IF' OR finalRecords.RC3 = 'IF' OR finalRecords.RC4 = 'IF' OR finalRecords.RC5 = 'IF' OR finalRecords.RC6 = 'IF' OR finalRecords.RC7 = 'IF' OR finalRecords.RC8 = 'IF' OR finalRecords.RC9 = 'IF' OR finalRecords.RC10 = 'IF') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_IG						:=	(COUNT(GROUP, finalRecords.RC1 = 'IG' OR finalRecords.RC2 = 'IG' OR finalRecords.RC3 = 'IG' OR finalRecords.RC4 = 'IG' OR finalRecords.RC5 = 'IG' OR finalRecords.RC6 = 'IG' OR finalRecords.RC7 = 'IG' OR finalRecords.RC8 = 'IG' OR finalRecords.RC9 = 'IG' OR finalRecords.RC10 = 'IG') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_IH						:=	(COUNT(GROUP, finalRecords.RC1 = 'IH' OR finalRecords.RC2 = 'IH' OR finalRecords.RC3 = 'IH' OR finalRecords.RC4 = 'IH' OR finalRecords.RC5 = 'IH' OR finalRecords.RC6 = 'IH' OR finalRecords.RC7 = 'IH' OR finalRecords.RC8 = 'IH' OR finalRecords.RC9 = 'IH' OR finalRecords.RC10 = 'IH') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_II						:=	(COUNT(GROUP, finalRecords.RC1 = 'II' OR finalRecords.RC2 = 'II' OR finalRecords.RC3 = 'II' OR finalRecords.RC4 = 'II' OR finalRecords.RC5 = 'II' OR finalRecords.RC6 = 'II' OR finalRecords.RC7 = 'II' OR finalRecords.RC8 = 'II' OR finalRecords.RC9 = 'II' OR finalRecords.RC10 = 'II') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_IJ						:=	(COUNT(GROUP, finalRecords.RC1 = 'IJ' OR finalRecords.RC2 = 'IJ' OR finalRecords.RC3 = 'IJ' OR finalRecords.RC4 = 'IJ' OR finalRecords.RC5 = 'IJ' OR finalRecords.RC6 = 'IJ' OR finalRecords.RC7 = 'IJ' OR finalRecords.RC8 = 'IJ' OR finalRecords.RC9 = 'IJ' OR finalRecords.RC10 = 'IJ') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_IK						:=	(COUNT(GROUP, finalRecords.RC1 = 'IK' OR finalRecords.RC2 = 'IK' OR finalRecords.RC3 = 'IK' OR finalRecords.RC4 = 'IK' OR finalRecords.RC5 = 'IK' OR finalRecords.RC6 = 'IK' OR finalRecords.RC7 = 'IK' OR finalRecords.RC8 = 'IK' OR finalRecords.RC9 = 'IK' OR finalRecords.RC10 = 'IK') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_IS						:=	(COUNT(GROUP, finalRecords.RC1 = 'IS' OR finalRecords.RC2 = 'IS' OR finalRecords.RC3 = 'IS' OR finalRecords.RC4 = 'IS' OR finalRecords.RC5 = 'IS' OR finalRecords.RC6 = 'IS' OR finalRecords.RC7 = 'IS' OR finalRecords.RC8 = 'IS' OR finalRecords.RC9 = 'IS' OR finalRecords.RC10 = 'IS') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_IT						:=	(COUNT(GROUP, finalRecords.RC1 = 'IT' OR finalRecords.RC2 = 'IT' OR finalRecords.RC3 = 'IT' OR finalRecords.RC4 = 'IT' OR finalRecords.RC5 = 'IT' OR finalRecords.RC6 = 'IT' OR finalRecords.RC7 = 'IT' OR finalRecords.RC8 = 'IT' OR finalRecords.RC9 = 'IT' OR finalRecords.RC10 = 'IT') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_MI						:=	(COUNT(GROUP, finalRecords.RC1 = 'MI' OR finalRecords.RC2 = 'MI' OR finalRecords.RC3 = 'MI' OR finalRecords.RC4 = 'MI' OR finalRecords.RC5 = 'MI' OR finalRecords.RC6 = 'MI' OR finalRecords.RC7 = 'MI' OR finalRecords.RC8 = 'MI' OR finalRecords.RC9 = 'MI' OR finalRecords.RC10 = 'MI') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_MN						:=	(COUNT(GROUP, finalRecords.RC1 = 'MN' OR finalRecords.RC2 = 'MN' OR finalRecords.RC3 = 'MN' OR finalRecords.RC4 = 'MN' OR finalRecords.RC5 = 'MN' OR finalRecords.RC6 = 'MN' OR finalRecords.RC7 = 'MN' OR finalRecords.RC8 = 'MN' OR finalRecords.RC9 = 'MN' OR finalRecords.RC10 = 'MN') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_MO						:=	(COUNT(GROUP, finalRecords.RC1 = 'MO' OR finalRecords.RC2 = 'MO' OR finalRecords.RC3 = 'MO' OR finalRecords.RC4 = 'MO' OR finalRecords.RC5 = 'MO' OR finalRecords.RC6 = 'MO' OR finalRecords.RC7 = 'MO' OR finalRecords.RC8 = 'MO' OR finalRecords.RC9 = 'MO' OR finalRecords.RC10 = 'MO') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_MS						:=	(COUNT(GROUP, finalRecords.RC1 = 'MS' OR finalRecords.RC2 = 'MS' OR finalRecords.RC3 = 'MS' OR finalRecords.RC4 = 'MS' OR finalRecords.RC5 = 'MS' OR finalRecords.RC6 = 'MS' OR finalRecords.RC7 = 'MS' OR finalRecords.RC8 = 'MS' OR finalRecords.RC9 = 'MS' OR finalRecords.RC10 = 'MS') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_PA						:=	(COUNT(GROUP, finalRecords.RC1 = 'PA' OR finalRecords.RC2 = 'PA' OR finalRecords.RC3 = 'PA' OR finalRecords.RC4 = 'PA' OR finalRecords.RC5 = 'PA' OR finalRecords.RC6 = 'PA' OR finalRecords.RC7 = 'PA' OR finalRecords.RC8 = 'PA' OR finalRecords.RC9 = 'PA' OR finalRecords.RC10 = 'PA') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_PO						:=	(COUNT(GROUP, finalRecords.RC1 = 'PO' OR finalRecords.RC2 = 'PO' OR finalRecords.RC3 = 'PO' OR finalRecords.RC4 = 'PO' OR finalRecords.RC5 = 'PO' OR finalRecords.RC6 = 'PO' OR finalRecords.RC7 = 'PO' OR finalRecords.RC8 = 'PO' OR finalRecords.RC9 = 'PO' OR finalRecords.RC10 = 'PO') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_PV						:=	(COUNT(GROUP, finalRecords.RC1 = 'PV' OR finalRecords.RC2 = 'PV' OR finalRecords.RC3 = 'PV' OR finalRecords.RC4 = 'PV' OR finalRecords.RC5 = 'PV' OR finalRecords.RC6 = 'PV' OR finalRecords.RC7 = 'PV' OR finalRecords.RC8 = 'PV' OR finalRecords.RC9 = 'PV' OR finalRecords.RC10 = 'PV') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_RS						:=	(COUNT(GROUP, finalRecords.RC1 = 'RS' OR finalRecords.RC2 = 'RS' OR finalRecords.RC3 = 'RS' OR finalRecords.RC4 = 'RS' OR finalRecords.RC5 = 'RS' OR finalRecords.RC6 = 'RS' OR finalRecords.RC7 = 'RS' OR finalRecords.RC8 = 'RS' OR finalRecords.RC9 = 'RS' OR finalRecords.RC10 = 'RS') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_SR						:=	(COUNT(GROUP, finalRecords.RC1 = 'SR' OR finalRecords.RC2 = 'SR' OR finalRecords.RC3 = 'SR' OR finalRecords.RC4 = 'SR' OR finalRecords.RC5 = 'SR' OR finalRecords.RC6 = 'SR' OR finalRecords.RC7 = 'SR' OR finalRecords.RC8 = 'SR' OR finalRecords.RC9 = 'SR' OR finalRecords.RC10 = 'SR') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_U1						:=	(COUNT(GROUP, finalRecords.RC1 = 'U1' OR finalRecords.RC2 = 'U1' OR finalRecords.RC3 = 'U1' OR finalRecords.RC4 = 'U1' OR finalRecords.RC5 = 'U1' OR finalRecords.RC6 = 'U1' OR finalRecords.RC7 = 'U1' OR finalRecords.RC8 = 'U1' OR finalRecords.RC9 = 'U1' OR finalRecords.RC10 = 'U1') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_U2						:=	(COUNT(GROUP, finalRecords.RC1 = 'U2' OR finalRecords.RC2 = 'U2' OR finalRecords.RC3 = 'U2' OR finalRecords.RC4 = 'U2' OR finalRecords.RC5 = 'U2' OR finalRecords.RC6 = 'U2' OR finalRecords.RC7 = 'U2' OR finalRecords.RC8 = 'U2' OR finalRecords.RC9 = 'U2' OR finalRecords.RC10 = 'U2') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_WL						:=	(COUNT(GROUP, finalRecords.RC1 = 'WL' OR finalRecords.RC2 = 'WL' OR finalRecords.RC3 = 'WL' OR finalRecords.RC4 = 'WL' OR finalRecords.RC5 = 'WL' OR finalRecords.RC6 = 'WL' OR finalRecords.RC7 = 'WL' OR finalRecords.RC8 = 'WL' OR finalRecords.RC9 = 'WL' OR finalRecords.RC10 = 'WL') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_ZI						:=	(COUNT(GROUP, finalRecords.RC1 = 'ZI' OR finalRecords.RC2 = 'ZI' OR finalRecords.RC3 = 'ZI' OR finalRecords.RC4 = 'ZI' OR finalRecords.RC5 = 'ZI' OR finalRecords.RC6 = 'ZI' OR finalRecords.RC7 = 'ZI' OR finalRecords.RC8 = 'ZI' OR finalRecords.RC9 = 'ZI' OR finalRecords.RC10 = 'ZI') / COUNT(GROUP)) * 100;
	// New V1 Reason Codes
	DECIMAL6_3	Percent_RC_CA						:=	(COUNT(GROUP, finalRecords.RC1 = 'CA' OR finalRecords.RC2 = 'CA' OR finalRecords.RC3 = 'CA' OR finalRecords.RC4 = 'CA' OR finalRecords.RC5 = 'CA' OR finalRecords.RC6 = 'CA' OR finalRecords.RC7 = 'CA' OR finalRecords.RC8 = 'CA' OR finalRecords.RC9 = 'CA' OR finalRecords.RC10 = 'CA') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_DI						:=	(COUNT(GROUP, finalRecords.RC1 = 'DI' OR finalRecords.RC2 = 'DI' OR finalRecords.RC3 = 'DI' OR finalRecords.RC4 = 'DI' OR finalRecords.RC5 = 'DI' OR finalRecords.RC6 = 'DI' OR finalRecords.RC7 = 'DI' OR finalRecords.RC8 = 'DI' OR finalRecords.RC9 = 'DI' OR finalRecords.RC10 = 'DI') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_NB						:=	(COUNT(GROUP, finalRecords.RC1 = 'NB' OR finalRecords.RC2 = 'NB' OR finalRecords.RC3 = 'NB' OR finalRecords.RC4 = 'NB' OR finalRecords.RC5 = 'NB' OR finalRecords.RC6 = 'NB' OR finalRecords.RC7 = 'NB' OR finalRecords.RC8 = 'NB' OR finalRecords.RC9 = 'NB' OR finalRecords.RC10 = 'NB') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_NF						:=	(COUNT(GROUP, finalRecords.RC1 = 'NF' OR finalRecords.RC2 = 'NF' OR finalRecords.RC3 = 'NF' OR finalRecords.RC4 = 'NF' OR finalRecords.RC5 = 'NF' OR finalRecords.RC6 = 'NF' OR finalRecords.RC7 = 'NF' OR finalRecords.RC8 = 'NF' OR finalRecords.RC9 = 'NF' OR finalRecords.RC10 = 'NF') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_SD						:=	(COUNT(GROUP, finalRecords.RC1 = 'SD' OR finalRecords.RC2 = 'SD' OR finalRecords.RC3 = 'SD' OR finalRecords.RC4 = 'SD' OR finalRecords.RC5 = 'SD' OR finalRecords.RC6 = 'SD' OR finalRecords.RC7 = 'SD' OR finalRecords.RC8 = 'SD' OR finalRecords.RC9 = 'SD' OR finalRecords.RC10 = 'SD') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_VA						:=	(COUNT(GROUP, finalRecords.RC1 = 'VA' OR finalRecords.RC2 = 'VA' OR finalRecords.RC3 = 'VA' OR finalRecords.RC4 = 'VA' OR finalRecords.RC5 = 'VA' OR finalRecords.RC6 = 'VA' OR finalRecords.RC7 = 'VA' OR finalRecords.RC8 = 'VA' OR finalRecords.RC9 = 'VA' OR finalRecords.RC10 = 'VA') / COUNT(GROUP)) * 100;
END;

trackingLayout2 := RECORD
	STRING8 Date_Of_Report															:= finalRecords.TransactionDate;
	UNSIGNED8 Number_Of_Unique_Account_IDs_Transacted		:= COUNT(GROUP);
END;

mainStats := TABLE(finalRecords, trackingLayout, TransactionDate);
OUTPUT(CHOOSEN(mainStats, eyeball), NAMED('Main_Stats_IID'));
uniqueIDRecs := DEDUP(SORT(finalRecords, TransactionDate, AccountID), TransactionDate, AccountID);
uniqueIDs := TABLE(uniqueIDRecs, trackingLayout2, TransactionDate);
OUTPUT(CHOOSEN(uniqueIDs, eyeball), NAMED('Unique_IDs_IID'));

stats := JOIN(mainStats, uniqueIDs, LEFT.Date_Of_Report = RIGHT.Date_Of_Report, TRANSFORM(RECORDOF(LEFT), SELF.Number_Of_Unique_Account_IDs_Transacted := RIGHT.Number_Of_Unique_Account_IDs_Transacted; SELF := LEFT)) (Total_Number_Of_Transactions >= 50); // If the total number of transactions for the day is less than 50, assume it's a bad key build

MostRecent := SORT(stats, -Date_Of_Report); // Sort most recent dates to the front
Oldest := SORT(stats, Date_Of_Report);

day1 := MostRecent[1];
day2 := MostRecent[2];
day3 := MostRecent[3];
day4 := MostRecent[4];
day5 := MostRecent[5];
day6 := MostRecent[6];
day7 := MostRecent[7];

OUTPUT(CHOOSEN(MostRecent, eyeball), NAMED('Sample_Stats_IID'));

averageTrackingLayout := RECORD
	// General Statistics
	STRING8 Date_Of_Report := '';							
	UNSIGNED8 Total_Number_Of_Transactions;							
	UNSIGNED8 Number_Of_Unique_Account_IDs_Transacted;		
	
	// Input Population Statistics
	DECIMAL6_3	Percent_First_Name_Populated;
	DECIMAL6_3	Percent_Last_Name_Populated;
	DECIMAL6_3	Percent_Full_Name_Populated;
	DECIMAL6_3	Percent_SSN_Populated;
	DECIMAL6_3	Percent_DOB_Populated;
	DECIMAL6_3	Percent_Address_Populated;
	DECIMAL6_3	Percent_City_Populated;
	DECIMAL6_3	Percent_State_Populated;
	DECIMAL6_3	Percent_Zip_Populated;
	DECIMAL6_3	Percent_DL_Populated;
	DECIMAL6_3	Percent_Home_Phone_Populated;
	
	// CVI Score Buckets
	DECIMAL6_3	Percent_CVI_00;
	DECIMAL6_3	Percent_CVI_10;
	DECIMAL6_3	Percent_CVI_20;
	DECIMAL6_3	Percent_CVI_30;
	DECIMAL6_3	Percent_CVI_40;
	DECIMAL6_3	Percent_CVI_50;	
	UNSIGNED2		Average_CVI_Value;
	
	// NAP Score Buckets
	DECIMAL6_3	Percent_NAP_0;
	DECIMAL6_3	Percent_NAP_1;
	DECIMAL6_3	Percent_NAP_2;
	DECIMAL6_3	Percent_NAP_3;
	DECIMAL6_3	Percent_NAP_4;
	DECIMAL6_3	Percent_NAP_5;
	DECIMAL6_3	Percent_NAP_6;
	DECIMAL6_3	Percent_NAP_7;
	DECIMAL6_3	Percent_NAP_8;
	DECIMAL6_3	Percent_NAP_9;
	DECIMAL6_3	Percent_NAP_10;
	DECIMAL6_3	Percent_NAP_11;
	DECIMAL6_3	Percent_NAP_12;
	UNSIGNED1		Average_NAP_Value;
	
	// NAS Score Buckets
	DECIMAL6_3	Percent_NAS_0;
	DECIMAL6_3	Percent_NAS_1;
	DECIMAL6_3	Percent_NAS_2;
	DECIMAL6_3	Percent_NAS_3;
	DECIMAL6_3	Percent_NAS_4;
	DECIMAL6_3	Percent_NAS_5;
	DECIMAL6_3	Percent_NAS_6;
	DECIMAL6_3	Percent_NAS_7;
	DECIMAL6_3	Percent_NAS_8;
	DECIMAL6_3	Percent_NAS_9;
	DECIMAL6_3	Percent_NAS_10;
	DECIMAL6_3	Percent_NAS_11;
	DECIMAL6_3	Percent_NAS_12;
	UNSIGNED1		Average_NAS_Value;
	
	// Score Bucket Statistics
	DECIMAL6_3	Percent_FP_Scored_200;
	DECIMAL6_3	Percent_FP_Scored_201;
	DECIMAL6_3	Percent_FP_Scored_202;
	DECIMAL6_3	Percent_FP_Scored_203;
	DECIMAL6_3	Percent_FP_Scored_222;
	DECIMAL6_3	Percent_FP_Scored_Between_300_350 ;
	DECIMAL6_3	Percent_FP_Scored_Between_351_400 ;
	DECIMAL6_3	Percent_FP_Scored_Between_401_450 ;
	DECIMAL6_3	Percent_FP_Scored_Between_451_500 ;
	DECIMAL6_3	Percent_FP_Scored_Between_501_550 ;
	DECIMAL6_3	Percent_FP_Scored_Between_551_600 ;
	DECIMAL6_3	Percent_FP_Scored_Between_601_650 ;
	DECIMAL6_3	Percent_FP_Scored_Between_651_700 ;
	DECIMAL6_3	Percent_FP_Scored_Between_701_750 ;
	DECIMAL6_3	Percent_FP_Scored_Between_751_900 ;
	DECIMAL6_3	Percent_FP_Scored_Above_900;
		
	UNSIGNED2	Average_Score_Excluding_Exceptions;
	
	DECIMAL6_3	Percent_FraudPointRC1;
	DECIMAL6_3	Percent_FP_RC_02;
	DECIMAL6_3	Percent_FP_RC_03;
	DECIMAL6_3	Percent_FP_RC_06;
	DECIMAL6_3	Percent_FP_RC_07;
	DECIMAL6_3	Percent_FP_RC_08;
	DECIMAL6_3	Percent_FP_RC_09;
	DECIMAL6_3	Percent_FP_RC_10;
	DECIMAL6_3	Percent_FP_RC_11;
	DECIMAL6_3	Percent_FP_RC_12;
	DECIMAL6_3	Percent_FP_RC_14;
	DECIMAL6_3	Percent_FP_RC_15;
	DECIMAL6_3	Percent_FP_RC_16;
	DECIMAL6_3	Percent_FP_RC_34;
	DECIMAL6_3	Percent_FP_RC_38;
	DECIMAL6_3	Percent_FP_RC_39;
	DECIMAL6_3	Percent_FP_RC_40;
	DECIMAL6_3	Percent_FP_RC_49;
	DECIMAL6_3	Percent_FP_RC_50;
	DECIMAL6_3	Percent_FP_RC_51;
	DECIMAL6_3	Percent_FP_RC_52;
	DECIMAL6_3	Percent_FP_RC_53;
	DECIMAL6_3	Percent_FP_RC_55;
	DECIMAL6_3	Percent_FP_RC_56;
	DECIMAL6_3	Percent_FP_RC_57;
	DECIMAL6_3	Percent_FP_RC_64;
	DECIMAL6_3	Percent_FP_RC_66;
	DECIMAL6_3	Percent_FP_RC_71;
	DECIMAL6_3	Percent_FP_RC_72;
	DECIMAL6_3	Percent_FP_RC_73;
	DECIMAL6_3	Percent_FP_RC_74;
	DECIMAL6_3	Percent_FP_RC_75;
	DECIMAL6_3	Percent_FP_RC_77;
	DECIMAL6_3	Percent_FP_RC_78;
	DECIMAL6_3	Percent_FP_RC_79;
	DECIMAL6_3	Percent_FP_RC_80;
	DECIMAL6_3	Percent_FP_RC_81;
	DECIMAL6_3	Percent_FP_RC_82;
	DECIMAL6_3	Percent_FP_RC_85;
	DECIMAL6_3	Percent_FP_RC_89;
	DECIMAL6_3	Percent_FP_RC_90;
	DECIMAL6_3	Percent_FP_RC_97;
	DECIMAL6_3	Percent_FP_RC_9D;
	DECIMAL6_3	Percent_FP_RC_9K;
	DECIMAL6_3	Percent_FP_RC_AR;
	DECIMAL6_3	Percent_FP_RC_BO;
	DECIMAL6_3	Percent_FP_RC_CB;
	DECIMAL6_3	Percent_FP_RC_CC;
	DECIMAL6_3	Percent_FP_RC_CR;
	DECIMAL6_3	Percent_FP_RC_DR;
	DECIMAL6_3	Percent_FP_RC_FQ;
	DECIMAL6_3	Percent_FP_RC_FV;
	DECIMAL6_3	Percent_FP_RC_HA;
	DECIMAL6_3	Percent_FP_RC_IA;
	DECIMAL6_3	Percent_FP_RC_IE;
	DECIMAL6_3	Percent_FP_RC_IF;
	DECIMAL6_3	Percent_FP_RC_IG;
	DECIMAL6_3	Percent_FP_RC_II;
	DECIMAL6_3	Percent_FP_RC_IJ;
	DECIMAL6_3	Percent_FP_RC_IK;
	DECIMAL6_3	Percent_FP_RC_IR;
	DECIMAL6_3	Percent_FP_RC_MI;
	DECIMAL6_3	Percent_FP_RC_MN;
	DECIMAL6_3	Percent_FP_RC_MS;
	DECIMAL6_3	Percent_FP_RC_PA;
	DECIMAL6_3	Percent_FP_RC_PH;
	DECIMAL6_3	Percent_FP_RC_PN;
	DECIMAL6_3	Percent_FP_RC_PO;
	DECIMAL6_3	Percent_FP_RC_QA;
	DECIMAL6_3	Percent_FP_RC_QB;
	DECIMAL6_3	Percent_FP_RC_QC;
	DECIMAL6_3	Percent_FP_RC_QD;
	DECIMAL6_3	Percent_FP_RC_QE;
	DECIMAL6_3	Percent_FP_RC_QF;
	DECIMAL6_3	Percent_FP_RC_QG;
	DECIMAL6_3	Percent_FP_RC_QH;
	DECIMAL6_3	Percent_FP_RC_QI;
	DECIMAL6_3	Percent_FP_RC_QJ;
	DECIMAL6_3	Percent_FP_RC_QK;
	DECIMAL6_3	Percent_FP_RC_QL;
	DECIMAL6_3	Percent_FP_RC_QM;
	DECIMAL6_3	Percent_FP_RC_RC;
	DECIMAL6_3	Percent_FP_RC_RF;
	DECIMAL6_3	Percent_FP_RC_S1;
	DECIMAL6_3	Percent_FP_RC_S2;
	DECIMAL6_3	Percent_FP_RC_S3;
	DECIMAL6_3	Percent_FP_RC_S4;
	DECIMAL6_3	Percent_FP_RC_S5;
	DECIMAL6_3	Percent_FP_RC_SA;
	DECIMAL6_3	Percent_FP_RC_SC;
	DECIMAL6_3	Percent_FP_RC_SN;
	DECIMAL6_3	Percent_FP_RC_SR;
	DECIMAL6_3	Percent_FP_RC_VE;
	DECIMAL6_3	Percent_FP_RC_VL;
	DECIMAL6_3	Percent_FP_RC_VR;
	DECIMAL6_3	Percent_FP_RC_VV;
	DECIMAL6_3	Percent_FP_RC_VX;
		
		
	DECIMAL6_3	Percent_StolenIdentity_Index;
	DECIMAL6_3	Percent_SyntheticIdentity_Index;
	DECIMAL6_3	Percent_ManipulatedIdentity_Index;
	DECIMAL6_3	Percent_VulnerableVictim_Index;
	DECIMAL6_3	Percent_FriendlyFraud_Index;
	DECIMAL6_3	Percent_SuspiciousActivity_Index;

	// Reason Code Population Statistics
	DECIMAL6_3	Percent_RC_01;						
	DECIMAL6_3	Percent_RC_02;						
	DECIMAL6_3	Percent_RC_03;						
	DECIMAL6_3	Percent_RC_04;						
	DECIMAL6_3	Percent_RC_05;						
	DECIMAL6_3	Percent_RC_06;						
	DECIMAL6_3	Percent_RC_07;						
	DECIMAL6_3	Percent_RC_08;						
	DECIMAL6_3	Percent_RC_09;						
	DECIMAL6_3	Percent_RC_10;						
	DECIMAL6_3	Percent_RC_11;						
	DECIMAL6_3	Percent_RC_12;						
	DECIMAL6_3	Percent_RC_13;						
	DECIMAL6_3	Percent_RC_14;						
	DECIMAL6_3	Percent_RC_15;						
	DECIMAL6_3	Percent_RC_16;						
	DECIMAL6_3	Percent_RC_17;						
	DECIMAL6_3	Percent_RC_19;						
	DECIMAL6_3	Percent_RC_20;						
	DECIMAL6_3	Percent_RC_21;						
	DECIMAL6_3	Percent_RC_22;						
	DECIMAL6_3	Percent_RC_23;						
	DECIMAL6_3	Percent_RC_24;						
	DECIMAL6_3	Percent_RC_25;						
	DECIMAL6_3	Percent_RC_26;						
	DECIMAL6_3	Percent_RC_27;						
	DECIMAL6_3	Percent_RC_28;						
	DECIMAL6_3	Percent_RC_29;						
	DECIMAL6_3	Percent_RC_30;						
	DECIMAL6_3	Percent_RC_31;						
	DECIMAL6_3	Percent_RC_32;						
	DECIMAL6_3	Percent_RC_33;						
	DECIMAL6_3	Percent_RC_34;						
	DECIMAL6_3	Percent_RC_35;						
	DECIMAL6_3	Percent_RC_36;						
	DECIMAL6_3	Percent_RC_37;						
	DECIMAL6_3	Percent_RC_38;						
	DECIMAL6_3	Percent_RC_39;						
	DECIMAL6_3	Percent_RC_40;						
	DECIMAL6_3	Percent_RC_41;						
	DECIMAL6_3	Percent_RC_42;						
	DECIMAL6_3	Percent_RC_43;						
	DECIMAL6_3	Percent_RC_44;						
	DECIMAL6_3	Percent_RC_45;						
	DECIMAL6_3	Percent_RC_46;						
	DECIMAL6_3	Percent_RC_47;						
	DECIMAL6_3	Percent_RC_48;						
	DECIMAL6_3	Percent_RC_49;						
	DECIMAL6_3	Percent_RC_50;						
	DECIMAL6_3	Percent_RC_51;						
	DECIMAL6_3	Percent_RC_52;						
	DECIMAL6_3	Percent_RC_53;						
	DECIMAL6_3	Percent_RC_54;						
	DECIMAL6_3	Percent_RC_55;						
	DECIMAL6_3	Percent_RC_56;						
	DECIMAL6_3	Percent_RC_57;						
	DECIMAL6_3	Percent_RC_58;						
	DECIMAL6_3	Percent_RC_59;						
	DECIMAL6_3	Percent_RC_5Q;						
	DECIMAL6_3	Percent_RC_60;						
	DECIMAL6_3	Percent_RC_61;						
	DECIMAL6_3	Percent_RC_62;						
	DECIMAL6_3	Percent_RC_63;						
	DECIMAL6_3	Percent_RC_64;						
	DECIMAL6_3	Percent_RC_65;						
	DECIMAL6_3	Percent_RC_66;						
	DECIMAL6_3	Percent_RC_67;						
	DECIMAL6_3	Percent_RC_68;						
	DECIMAL6_3	Percent_RC_69;						
	DECIMAL6_3	Percent_RC_70;						
	DECIMAL6_3	Percent_RC_71;						
	DECIMAL6_3	Percent_RC_72;						
	DECIMAL6_3	Percent_RC_73;						
	DECIMAL6_3	Percent_RC_74;						
	DECIMAL6_3	Percent_RC_75;						
	DECIMAL6_3	Percent_RC_76;						
	DECIMAL6_3	Percent_RC_77;						
	DECIMAL6_3	Percent_RC_78;						
	DECIMAL6_3	Percent_RC_79;						
	DECIMAL6_3	Percent_RC_80;						
	DECIMAL6_3	Percent_RC_81;						
	DECIMAL6_3	Percent_RC_82;						
	DECIMAL6_3	Percent_RC_83;						
	DECIMAL6_3	Percent_RC_84;						
	DECIMAL6_3	Percent_RC_85;						
	DECIMAL6_3	Percent_RC_86;						
	DECIMAL6_3	Percent_RC_87;						
	DECIMAL6_3	Percent_RC_88;						
	DECIMAL6_3	Percent_RC_89;						
	DECIMAL6_3	Percent_RC_90;						
	DECIMAL6_3	Percent_RC_91;						
	DECIMAL6_3	Percent_RC_92;						
	DECIMAL6_3	Percent_RC_93;						
	DECIMAL6_3	Percent_RC_94;						
	DECIMAL6_3	Percent_RC_95;						
	DECIMAL6_3	Percent_RC_96;						
	DECIMAL6_3	Percent_RC_97;						
	DECIMAL6_3	Percent_RC_98;						
	DECIMAL6_3	Percent_RC_99;						
	DECIMAL6_3	Percent_RC_9A;						
	DECIMAL6_3	Percent_RC_9B;						
	DECIMAL6_3	Percent_RC_9C;						
	DECIMAL6_3	Percent_RC_9D;						
	DECIMAL6_3	Percent_RC_9E;						
	DECIMAL6_3	Percent_RC_9F;						
	DECIMAL6_3	Percent_RC_9G;						
	DECIMAL6_3	Percent_RC_9H;						
	DECIMAL6_3	Percent_RC_9I;						
	DECIMAL6_3	Percent_RC_9J;						
	DECIMAL6_3	Percent_RC_9K;						
	DECIMAL6_3	Percent_RC_9L;						
	DECIMAL6_3	Percent_RC_9M;						
	DECIMAL6_3	Percent_RC_9N;						
	DECIMAL6_3	Percent_RC_9O;						
	DECIMAL6_3	Percent_RC_9P;						
	DECIMAL6_3	Percent_RC_9Q;						
	DECIMAL6_3	Percent_RC_9R;						
	DECIMAL6_3	Percent_RC_9S;						
	DECIMAL6_3	Percent_RC_9T;						
	DECIMAL6_3	Percent_RC_9U;						
	DECIMAL6_3	Percent_RC_9V;						
	DECIMAL6_3	Percent_RC_9W;						
	DECIMAL6_3	Percent_RC_9X;						
	DECIMAL6_3	Percent_RC_A0;						
	DECIMAL6_3	Percent_RC_A1;						
	DECIMAL6_3	Percent_RC_A2;						
	DECIMAL6_3	Percent_RC_A3;						
	DECIMAL6_3	Percent_RC_A4;						
	DECIMAL6_3	Percent_RC_A5;						
	DECIMAL6_3	Percent_RC_A6;						
	DECIMAL6_3	Percent_RC_A7;						
	DECIMAL6_3	Percent_RC_A8;						
	DECIMAL6_3	Percent_RC_A9;						
	DECIMAL6_3	Percent_RC_B0;						
	DECIMAL6_3	Percent_RC_BO;						
	DECIMAL6_3	Percent_RC_CL;						
	DECIMAL6_3	Percent_RC_CO;						
	DECIMAL6_3	Percent_RC_CR;						
	DECIMAL6_3	Percent_RC_CZ;						
	DECIMAL6_3	Percent_RC_DD;						
	DECIMAL6_3	Percent_RC_DF;						
	DECIMAL6_3	Percent_RC_DM;						
	DECIMAL6_3	Percent_RC_DV;						
	DECIMAL6_3	Percent_RC_EV;						
	DECIMAL6_3	Percent_RC_FB;						
	DECIMAL6_3	Percent_RC_FM;						
	DECIMAL6_3	Percent_RC_FQ;						
	DECIMAL6_3	Percent_RC_FR;						
	DECIMAL6_3	Percent_RC_FV;						
	DECIMAL6_3	Percent_RC_IA;						
	DECIMAL6_3	Percent_RC_IB;						
	DECIMAL6_3	Percent_RC_IC;						
	DECIMAL6_3	Percent_RC_ID;						
	DECIMAL6_3	Percent_RC_IE;						
	DECIMAL6_3	Percent_RC_IF;						
	DECIMAL6_3	Percent_RC_IG;						
	DECIMAL6_3	Percent_RC_IH;						
	DECIMAL6_3	Percent_RC_II;						
	DECIMAL6_3	Percent_RC_IJ;						
	DECIMAL6_3	Percent_RC_IK;						
	DECIMAL6_3	Percent_RC_IS;						
	DECIMAL6_3	Percent_RC_IT;						
	DECIMAL6_3	Percent_RC_MI;						
	DECIMAL6_3	Percent_RC_MN;						
	DECIMAL6_3	Percent_RC_MO;						
	DECIMAL6_3	Percent_RC_MS;						
	DECIMAL6_3	Percent_RC_PA;						
	DECIMAL6_3	Percent_RC_PO;						
	DECIMAL6_3	Percent_RC_PV;						
	DECIMAL6_3	Percent_RC_RS;						
	DECIMAL6_3	Percent_RC_SR;						
	DECIMAL6_3	Percent_RC_U1;						
	DECIMAL6_3	Percent_RC_U2;						
	DECIMAL6_3	Percent_RC_WL;						
	DECIMAL6_3	Percent_RC_ZI;	
	// New version 1 reason codes
	DECIMAL6_3	Percent_RC_CA;						
	DECIMAL6_3	Percent_RC_DI;						
	DECIMAL6_3	Percent_RC_NB;						
	DECIMAL6_3	Percent_RC_NF;						
	DECIMAL6_3	Percent_RC_SD;						
	DECIMAL6_3	Percent_RC_VA;						
END;

rounded (field) := FUNCTIONMACRO
	RETURN(ROUND(AVE(MostRecent, MostRecent.field)));
ENDMACRO;

percented (field) := FUNCTIONMACRO
	RETURN((DECIMAL6_3)AVE(MostRecent, MostRecent.field));
ENDMACRO;

averageTrackingLayout getAverages(scout.daily_monitoring.Constants.ds_Record le) := TRANSFORM
	// General Statistics
	SELF.Date_Of_Report := 'AVERAGE';							
	SELF.Total_Number_Of_Transactions := rounded(Total_Number_Of_Transactions);							
	SELF.Number_Of_Unique_Account_IDs_Transacted := rounded(Number_Of_Unique_Account_IDs_Transacted);		
	
	// Input Population Statistics
	SELF.Percent_First_Name_Populated := percented(Percent_First_Name_Populated);						
	SELF.Percent_Last_Name_Populated := percented(Percent_Last_Name_Populated);							
	SELF.Percent_Full_Name_Populated := percented(Percent_Full_Name_Populated);							
	SELF.Percent_SSN_Populated := percented(Percent_SSN_Populated);		
	SELF.Percent_DOB_Populated := percented(Percent_DOB_Populated);		
	SELF.Percent_Address_Populated := percented(Percent_Address_Populated);
	SELF.Percent_City_Populated := percented(Percent_City_Populated);	
	SELF.Percent_State_Populated := percented(Percent_State_Populated);	
	SELF.Percent_Zip_Populated := percented(Percent_Zip_Populated);		
	SELF.Percent_DL_Populated := percented(Percent_DL_Populated);		
	SELF.Percent_Home_Phone_Populated := percented(Percent_Home_Phone_Populated);						
	
	// CVI Score Bucket Statistics
	SELF.Percent_CVI_00 := percented(Percent_CVI_00);
	SELF.Percent_CVI_10 := percented(Percent_CVI_10);
	SELF.Percent_CVI_20 := percented(Percent_CVI_20);
	SELF.Percent_CVI_30 := percented(Percent_CVI_30);
	SELF.Percent_CVI_40 := percented(Percent_CVI_40);
	SELF.Percent_CVI_50 := percented(Percent_CVI_50);
	SELF.Average_CVI_Value := rounded(Average_CVI_Value);
	
	// NAP Score Bucket Statistics
	SELF.Percent_NAP_0 := percented(Percent_NAP_0);
	SELF.Percent_NAP_1 := percented(Percent_NAP_1);
	SELF.Percent_NAP_2 := percented(Percent_NAP_2);
	SELF.Percent_NAP_3 := percented(Percent_NAP_3);
	SELF.Percent_NAP_4 := percented(Percent_NAP_4);
	SELF.Percent_NAP_5 := percented(Percent_NAP_5);
	SELF.Percent_NAP_6 := percented(Percent_NAP_6);
	SELF.Percent_NAP_7 := percented(Percent_NAP_7);
	SELF.Percent_NAP_8 := percented(Percent_NAP_8);
	SELF.Percent_NAP_9 := percented(Percent_NAP_9);
	SELF.Percent_NAP_10 := percented(Percent_NAP_10);
	SELF.Percent_NAP_11 := percented(Percent_NAP_11);
	SELF.Percent_NAP_12 := percented(Percent_NAP_12);
	SELF.Average_NAP_Value := rounded(Average_NAP_Value);
	
	// NAS Score Bucket Statistics
	SELF.Percent_NAS_0 := percented(Percent_NAS_0);
	SELF.Percent_NAS_1 := percented(Percent_NAS_1);
	SELF.Percent_NAS_2 := percented(Percent_NAS_2);
	SELF.Percent_NAS_3 := percented(Percent_NAS_3);
	SELF.Percent_NAS_4 := percented(Percent_NAS_4);
	SELF.Percent_NAS_5 := percented(Percent_NAS_5);
	SELF.Percent_NAS_6 := percented(Percent_NAS_6);
	SELF.Percent_NAS_7 := percented(Percent_NAS_7);
	SELF.Percent_NAS_8 := percented(Percent_NAS_8);
	SELF.Percent_NAS_9 := percented(Percent_NAS_9);
	SELF.Percent_NAS_10 := percented(Percent_NAS_10);
	SELF.Percent_NAS_11 := percented(Percent_NAS_11);
	SELF.Percent_NAS_12 := percented(Percent_NAS_12);
	SELF.Average_NAS_Value := rounded(Average_NAS_Value);
	
//FP Reason codes Statistics
	SELF.Percent_FP_Scored_200	:=	percented(Percent_FP_Scored_200	);
	SELF.Percent_FP_Scored_201	:=	percented(Percent_FP_Scored_201	);
	SELF.Percent_FP_Scored_202	:=	percented(Percent_FP_Scored_202	);
	SELF.Percent_FP_Scored_203	:=	percented(Percent_FP_Scored_203	);
	SELF.Percent_FP_Scored_222	:=	percented(Percent_FP_Scored_222	);
	SELF.Percent_FP_Scored_Between_300_350 	:=	percented(Percent_FP_Scored_Between_300_350 	);
	SELF.Percent_FP_Scored_Between_351_400 	:=	percented(Percent_FP_Scored_Between_351_400 	);
	SELF.Percent_FP_Scored_Between_401_450 	:=	percented(Percent_FP_Scored_Between_401_450 	);
	SELF.Percent_FP_Scored_Between_451_500 	:=	percented(Percent_FP_Scored_Between_451_500 	);
	SELF.Percent_FP_Scored_Between_501_550 	:=	percented(Percent_FP_Scored_Between_501_550 	);
	SELF.Percent_FP_Scored_Between_551_600 	:=	percented(Percent_FP_Scored_Between_551_600 	);
	SELF.Percent_FP_Scored_Between_601_650 	:=	percented(Percent_FP_Scored_Between_601_650 	);
	SELF.Percent_FP_Scored_Between_651_700 	:=	percented(Percent_FP_Scored_Between_651_700 	);
	SELF.Percent_FP_Scored_Between_701_750 	:=	percented(Percent_FP_Scored_Between_701_750 	);
	SELF.Percent_FP_Scored_Between_751_900 	:=	percented(Percent_FP_Scored_Between_751_900 	);
	SELF.Percent_FP_Scored_Above_900	:=	percented(Percent_FP_Scored_Above_900	);
	SELF.Average_Score_Excluding_Exceptions	:=	percented(Average_Score_Excluding_Exceptions	);
	SELF.Percent_FraudPointRC1	:=	percented(Percent_FraudPointRC1	);
	SELF.Percent_FP_RC_02	:=	percented(Percent_FP_RC_02	);
	SELF.Percent_FP_RC_03	:=	percented(Percent_FP_RC_03	);
	SELF.Percent_FP_RC_06	:=	percented(Percent_FP_RC_06	);
	SELF.Percent_FP_RC_07	:=	percented(Percent_FP_RC_07	);
	SELF.Percent_FP_RC_08	:=	percented(Percent_FP_RC_08	);
	SELF.Percent_FP_RC_09	:=	percented(Percent_FP_RC_09	);
	SELF.Percent_FP_RC_10	:=	percented(Percent_FP_RC_10	);
	SELF.Percent_FP_RC_11	:=	percented(Percent_FP_RC_11	);
	SELF.Percent_FP_RC_12	:=	percented(Percent_FP_RC_12	);
	SELF.Percent_FP_RC_14	:=	percented(Percent_FP_RC_14	);
	SELF.Percent_FP_RC_15	:=	percented(Percent_FP_RC_15	);
	SELF.Percent_FP_RC_16	:=	percented(Percent_FP_RC_16	);
	SELF.Percent_FP_RC_34	:=	percented(Percent_FP_RC_34	);
	SELF.Percent_FP_RC_38	:=	percented(Percent_FP_RC_38	);
	SELF.Percent_FP_RC_39	:=	percented(Percent_FP_RC_39	);
	SELF.Percent_FP_RC_40	:=	percented(Percent_FP_RC_40	);
	SELF.Percent_FP_RC_49	:=	percented(Percent_FP_RC_49	);
	SELF.Percent_FP_RC_50	:=	percented(Percent_FP_RC_50	);
	SELF.Percent_FP_RC_51	:=	percented(Percent_FP_RC_51	);
	SELF.Percent_FP_RC_52	:=	percented(Percent_FP_RC_52	);
	SELF.Percent_FP_RC_53	:=	percented(Percent_FP_RC_53	);
	SELF.Percent_FP_RC_55	:=	percented(Percent_FP_RC_55	);
	SELF.Percent_FP_RC_56	:=	percented(Percent_FP_RC_56	);
	SELF.Percent_FP_RC_57	:=	percented(Percent_FP_RC_57	);
	SELF.Percent_FP_RC_64	:=	percented(Percent_FP_RC_64	);
	SELF.Percent_FP_RC_66	:=	percented(Percent_FP_RC_66	);
	SELF.Percent_FP_RC_71	:=	percented(Percent_FP_RC_71	);
	SELF.Percent_FP_RC_72	:=	percented(Percent_FP_RC_72	);
	SELF.Percent_FP_RC_73	:=	percented(Percent_FP_RC_73	);
	SELF.Percent_FP_RC_74	:=	percented(Percent_FP_RC_74	);
	SELF.Percent_FP_RC_75	:=	percented(Percent_FP_RC_75	);
	SELF.Percent_FP_RC_77	:=	percented(Percent_FP_RC_77	);
	SELF.Percent_FP_RC_78	:=	percented(Percent_FP_RC_78	);
	SELF.Percent_FP_RC_79	:=	percented(Percent_FP_RC_79	);
	SELF.Percent_FP_RC_80	:=	percented(Percent_FP_RC_80	);
	SELF.Percent_FP_RC_81	:=	percented(Percent_FP_RC_81	);
	SELF.Percent_FP_RC_82	:=	percented(Percent_FP_RC_82	);
	SELF.Percent_FP_RC_85	:=	percented(Percent_FP_RC_85	);
	SELF.Percent_FP_RC_89	:=	percented(Percent_FP_RC_89	);
	SELF.Percent_FP_RC_90	:=	percented(Percent_FP_RC_90	);
	SELF.Percent_FP_RC_97	:=	percented(Percent_FP_RC_97	);
	SELF.Percent_FP_RC_9D	:=	percented(Percent_FP_RC_9D	);
	SELF.Percent_FP_RC_9K	:=	percented(Percent_FP_RC_9K	);
	SELF.Percent_FP_RC_AR	:=	percented(Percent_FP_RC_AR	);
	SELF.Percent_FP_RC_BO	:=	percented(Percent_FP_RC_BO	);
	SELF.Percent_FP_RC_CB	:=	percented(Percent_FP_RC_CB	);
	SELF.Percent_FP_RC_CC	:=	percented(Percent_FP_RC_CC	);
	SELF.Percent_FP_RC_CR	:=	percented(Percent_FP_RC_CR	);
	SELF.Percent_FP_RC_DR	:=	percented(Percent_FP_RC_DR	);
	SELF.Percent_FP_RC_FQ	:=	percented(Percent_FP_RC_FQ	);
	SELF.Percent_FP_RC_FV	:=	percented(Percent_FP_RC_FV	);
	SELF.Percent_FP_RC_HA	:=	percented(Percent_FP_RC_HA	);
	SELF.Percent_FP_RC_IA	:=	percented(Percent_FP_RC_IA	);
	SELF.Percent_FP_RC_IE	:=	percented(Percent_FP_RC_IE	);
	SELF.Percent_FP_RC_IF	:=	percented(Percent_FP_RC_IF	);
	SELF.Percent_FP_RC_IG	:=	percented(Percent_FP_RC_IG	);
	SELF.Percent_FP_RC_II	:=	percented(Percent_FP_RC_II	);
	SELF.Percent_FP_RC_IJ	:=	percented(Percent_FP_RC_IJ	);
	SELF.Percent_FP_RC_IK	:=	percented(Percent_FP_RC_IK	);
	SELF.Percent_FP_RC_IR	:=	percented(Percent_FP_RC_IR	);
	SELF.Percent_FP_RC_MI	:=	percented(Percent_FP_RC_MI	);
	SELF.Percent_FP_RC_MN	:=	percented(Percent_FP_RC_MN	);
	SELF.Percent_FP_RC_MS	:=	percented(Percent_FP_RC_MS	);
	SELF.Percent_FP_RC_PA	:=	percented(Percent_FP_RC_PA	);
	SELF.Percent_FP_RC_PH	:=	percented(Percent_FP_RC_PH	);
	SELF.Percent_FP_RC_PN	:=	percented(Percent_FP_RC_PN	);
	SELF.Percent_FP_RC_PO	:=	percented(Percent_FP_RC_PO	);
	SELF.Percent_FP_RC_QA	:=	percented(Percent_FP_RC_QA	);
	SELF.Percent_FP_RC_QB	:=	percented(Percent_FP_RC_QB	);
	SELF.Percent_FP_RC_QC	:=	percented(Percent_FP_RC_QC	);
	SELF.Percent_FP_RC_QD	:=	percented(Percent_FP_RC_QD	);
	SELF.Percent_FP_RC_QE	:=	percented(Percent_FP_RC_QE	);
	SELF.Percent_FP_RC_QF	:=	percented(Percent_FP_RC_QF	);
	SELF.Percent_FP_RC_QG	:=	percented(Percent_FP_RC_QG	);
	SELF.Percent_FP_RC_QH	:=	percented(Percent_FP_RC_QH	);
	SELF.Percent_FP_RC_QI	:=	percented(Percent_FP_RC_QI	);
	SELF.Percent_FP_RC_QJ	:=	percented(Percent_FP_RC_QJ	);
	SELF.Percent_FP_RC_QK	:=	percented(Percent_FP_RC_QK	);
	SELF.Percent_FP_RC_QL	:=	percented(Percent_FP_RC_QL	);
	SELF.Percent_FP_RC_QM	:=	percented(Percent_FP_RC_QM	);
	SELF.Percent_FP_RC_RC	:=	percented(Percent_FP_RC_RC	);
	SELF.Percent_FP_RC_RF	:=	percented(Percent_FP_RC_RF	);
	SELF.Percent_FP_RC_S1	:=	percented(Percent_FP_RC_S1	);
	SELF.Percent_FP_RC_S2	:=	percented(Percent_FP_RC_S2	);
	SELF.Percent_FP_RC_S3	:=	percented(Percent_FP_RC_S3	);
	SELF.Percent_FP_RC_S4	:=	percented(Percent_FP_RC_S4	);
	SELF.Percent_FP_RC_S5	:=	percented(Percent_FP_RC_S5	);
	SELF.Percent_FP_RC_SA	:=	percented(Percent_FP_RC_SA	);
	SELF.Percent_FP_RC_SC	:=	percented(Percent_FP_RC_SC	);
	SELF.Percent_FP_RC_SN	:=	percented(Percent_FP_RC_SN	);
	SELF.Percent_FP_RC_SR	:=	percented(Percent_FP_RC_SR	);
	SELF.Percent_FP_RC_VE	:=	percented(Percent_FP_RC_VE	);
	SELF.Percent_FP_RC_VL	:=	percented(Percent_FP_RC_VL	);
	SELF.Percent_FP_RC_VR	:=	percented(Percent_FP_RC_VR	);
	SELF.Percent_FP_RC_VV	:=	percented(Percent_FP_RC_VV	);
	SELF.Percent_FP_RC_VX	:=	percented(Percent_FP_RC_VX	);
	SELF.Percent_StolenIdentity_Index	:=	percented(Percent_StolenIdentity_Index	);
	SELF.Percent_SyntheticIdentity_Index	:=	percented(Percent_SyntheticIdentity_Index	);
	SELF.Percent_ManipulatedIdentity_Index	:=	percented(Percent_ManipulatedIdentity_Index	);
	SELF.Percent_VulnerableVictim_Index	:=	percented(Percent_VulnerableVictim_Index	);
	SELF.Percent_FriendlyFraud_Index	:=	percented(Percent_FriendlyFraud_Index	);
	SELF.Percent_SuspiciousActivity_Index	:=	percented(Percent_SuspiciousActivity_Index	);
	
	
	// Reason Code Population Statistics
	SELF.Percent_RC_01 := percented(Percent_RC_01);
	SELF.Percent_RC_02 := percented(Percent_RC_02);
	SELF.Percent_RC_03 := percented(Percent_RC_03);
	SELF.Percent_RC_04 := percented(Percent_RC_04);
	SELF.Percent_RC_05 := percented(Percent_RC_05);
	SELF.Percent_RC_06 := percented(Percent_RC_06);
	SELF.Percent_RC_07 := percented(Percent_RC_07);
	SELF.Percent_RC_08 := percented(Percent_RC_08);
	SELF.Percent_RC_09 := percented(Percent_RC_09);
	SELF.Percent_RC_10 := percented(Percent_RC_10);
	SELF.Percent_RC_11 := percented(Percent_RC_11);
	SELF.Percent_RC_12 := percented(Percent_RC_12);
	SELF.Percent_RC_13 := percented(Percent_RC_13);
	SELF.Percent_RC_14 := percented(Percent_RC_14);
	SELF.Percent_RC_15 := percented(Percent_RC_15);
	SELF.Percent_RC_16 := percented(Percent_RC_16);
	SELF.Percent_RC_17 := percented(Percent_RC_17);
	SELF.Percent_RC_19 := percented(Percent_RC_19);
	SELF.Percent_RC_20 := percented(Percent_RC_20);
	SELF.Percent_RC_21 := percented(Percent_RC_21);
	SELF.Percent_RC_22 := percented(Percent_RC_22);
	SELF.Percent_RC_23 := percented(Percent_RC_23);
	SELF.Percent_RC_24 := percented(Percent_RC_24);
	SELF.Percent_RC_25 := percented(Percent_RC_25);
	SELF.Percent_RC_26 := percented(Percent_RC_26);
	SELF.Percent_RC_27 := percented(Percent_RC_27);
	SELF.Percent_RC_28 := percented(Percent_RC_28);
	SELF.Percent_RC_29 := percented(Percent_RC_29);
	SELF.Percent_RC_30 := percented(Percent_RC_30);
	SELF.Percent_RC_31 := percented(Percent_RC_31);
	SELF.Percent_RC_32 := percented(Percent_RC_32);
	SELF.Percent_RC_33 := percented(Percent_RC_33);
	SELF.Percent_RC_34 := percented(Percent_RC_34);
	SELF.Percent_RC_35 := percented(Percent_RC_35);
	SELF.Percent_RC_36 := percented(Percent_RC_36);
	SELF.Percent_RC_37 := percented(Percent_RC_37);
	SELF.Percent_RC_38 := percented(Percent_RC_38);
	SELF.Percent_RC_39 := percented(Percent_RC_39);
	SELF.Percent_RC_40 := percented(Percent_RC_40);
	SELF.Percent_RC_41 := percented(Percent_RC_41);
	SELF.Percent_RC_42 := percented(Percent_RC_42);
	SELF.Percent_RC_43 := percented(Percent_RC_43);
	SELF.Percent_RC_44 := percented(Percent_RC_44);
	SELF.Percent_RC_45 := percented(Percent_RC_45);
	SELF.Percent_RC_46 := percented(Percent_RC_46);
	SELF.Percent_RC_47 := percented(Percent_RC_47);
	SELF.Percent_RC_48 := percented(Percent_RC_48);
	SELF.Percent_RC_49 := percented(Percent_RC_49);
	SELF.Percent_RC_50 := percented(Percent_RC_50);
	SELF.Percent_RC_51 := percented(Percent_RC_51);
	SELF.Percent_RC_52 := percented(Percent_RC_52);
	SELF.Percent_RC_53 := percented(Percent_RC_53);
	SELF.Percent_RC_54 := percented(Percent_RC_54);
	SELF.Percent_RC_55 := percented(Percent_RC_55);
	SELF.Percent_RC_56 := percented(Percent_RC_56);
	SELF.Percent_RC_57 := percented(Percent_RC_57);
	SELF.Percent_RC_58 := percented(Percent_RC_58);
	SELF.Percent_RC_59 := percented(Percent_RC_59);
	SELF.Percent_RC_5Q := percented(Percent_RC_5Q);
	SELF.Percent_RC_60 := percented(Percent_RC_60);
	SELF.Percent_RC_61 := percented(Percent_RC_61);
	SELF.Percent_RC_62 := percented(Percent_RC_62);
	SELF.Percent_RC_63 := percented(Percent_RC_63);
	SELF.Percent_RC_64 := percented(Percent_RC_64);
	SELF.Percent_RC_65 := percented(Percent_RC_65);
	SELF.Percent_RC_66 := percented(Percent_RC_66);
	SELF.Percent_RC_67 := percented(Percent_RC_67);
	SELF.Percent_RC_68 := percented(Percent_RC_68);
	SELF.Percent_RC_69 := percented(Percent_RC_69);
	SELF.Percent_RC_70 := percented(Percent_RC_70);
	SELF.Percent_RC_71 := percented(Percent_RC_71);
	SELF.Percent_RC_72 := percented(Percent_RC_72);
	SELF.Percent_RC_73 := percented(Percent_RC_73);
	SELF.Percent_RC_74 := percented(Percent_RC_74);
	SELF.Percent_RC_75 := percented(Percent_RC_75);
	SELF.Percent_RC_76 := percented(Percent_RC_76);
	SELF.Percent_RC_77 := percented(Percent_RC_77);
	SELF.Percent_RC_78 := percented(Percent_RC_78);
	SELF.Percent_RC_79 := percented(Percent_RC_79);
	SELF.Percent_RC_80 := percented(Percent_RC_80);
	SELF.Percent_RC_81 := percented(Percent_RC_81);
	SELF.Percent_RC_82 := percented(Percent_RC_82);
	SELF.Percent_RC_83 := percented(Percent_RC_83);
	SELF.Percent_RC_84 := percented(Percent_RC_84);
	SELF.Percent_RC_85 := percented(Percent_RC_85);
	SELF.Percent_RC_86 := percented(Percent_RC_86);
	SELF.Percent_RC_87 := percented(Percent_RC_87);
	SELF.Percent_RC_88 := percented(Percent_RC_88);
	SELF.Percent_RC_89 := percented(Percent_RC_89);
	SELF.Percent_RC_90 := percented(Percent_RC_90);
	SELF.Percent_RC_91 := percented(Percent_RC_91);
	SELF.Percent_RC_92 := percented(Percent_RC_92);
	SELF.Percent_RC_93 := percented(Percent_RC_93);
	SELF.Percent_RC_94 := percented(Percent_RC_94);
	SELF.Percent_RC_95 := percented(Percent_RC_95);
	SELF.Percent_RC_96 := percented(Percent_RC_96);
	SELF.Percent_RC_97 := percented(Percent_RC_97);
	SELF.Percent_RC_98 := percented(Percent_RC_98);
	SELF.Percent_RC_99 := percented(Percent_RC_99);
	SELF.Percent_RC_9A := percented(Percent_RC_9A);
	SELF.Percent_RC_9B := percented(Percent_RC_9B);
	SELF.Percent_RC_9C := percented(Percent_RC_9C);
	SELF.Percent_RC_9D := percented(Percent_RC_9D);
	SELF.Percent_RC_9E := percented(Percent_RC_9E);
	SELF.Percent_RC_9F := percented(Percent_RC_9F);
	SELF.Percent_RC_9G := percented(Percent_RC_9G);
	SELF.Percent_RC_9H := percented(Percent_RC_9H);
	SELF.Percent_RC_9I := percented(Percent_RC_9I);
	SELF.Percent_RC_9J := percented(Percent_RC_9J);
	SELF.Percent_RC_9K := percented(Percent_RC_9K);
	SELF.Percent_RC_9L := percented(Percent_RC_9L);
	SELF.Percent_RC_9M := percented(Percent_RC_9M);
	SELF.Percent_RC_9N := percented(Percent_RC_9N);
	SELF.Percent_RC_9O := percented(Percent_RC_9O);
	SELF.Percent_RC_9P := percented(Percent_RC_9P);
	SELF.Percent_RC_9Q := percented(Percent_RC_9Q);
	SELF.Percent_RC_9R := percented(Percent_RC_9R);
	SELF.Percent_RC_9S := percented(Percent_RC_9S);
	SELF.Percent_RC_9T := percented(Percent_RC_9T);
	SELF.Percent_RC_9U := percented(Percent_RC_9U);
	SELF.Percent_RC_9V := percented(Percent_RC_9V);
	SELF.Percent_RC_9W := percented(Percent_RC_9W);
	SELF.Percent_RC_9X := percented(Percent_RC_9X);
	SELF.Percent_RC_A0 := percented(Percent_RC_A0);
	SELF.Percent_RC_A1 := percented(Percent_RC_A1);
	SELF.Percent_RC_A2 := percented(Percent_RC_A2);
	SELF.Percent_RC_A3 := percented(Percent_RC_A3);
	SELF.Percent_RC_A4 := percented(Percent_RC_A4);
	SELF.Percent_RC_A5 := percented(Percent_RC_A5);
	SELF.Percent_RC_A6 := percented(Percent_RC_A6);
	SELF.Percent_RC_A7 := percented(Percent_RC_A7);
	SELF.Percent_RC_A8 := percented(Percent_RC_A8);
	SELF.Percent_RC_A9 := percented(Percent_RC_A9);
	SELF.Percent_RC_B0 := percented(Percent_RC_B0);
	SELF.Percent_RC_BO := percented(Percent_RC_BO);
	SELF.Percent_RC_CL := percented(Percent_RC_CL);
	SELF.Percent_RC_CO := percented(Percent_RC_CO);
	SELF.Percent_RC_CR := percented(Percent_RC_CR);
	SELF.Percent_RC_CZ := percented(Percent_RC_CZ);
	SELF.Percent_RC_DD := percented(Percent_RC_DD);
	SELF.Percent_RC_DF := percented(Percent_RC_DF);
	SELF.Percent_RC_DM := percented(Percent_RC_DM);
	SELF.Percent_RC_DV := percented(Percent_RC_DV);
	SELF.Percent_RC_EV := percented(Percent_RC_EV);
	SELF.Percent_RC_FB := percented(Percent_RC_FB);
	SELF.Percent_RC_FM := percented(Percent_RC_FM);
	SELF.Percent_RC_FQ := percented(Percent_RC_FQ);
	SELF.Percent_RC_FR := percented(Percent_RC_FR);
	SELF.Percent_RC_FV := percented(Percent_RC_FV);
	SELF.Percent_RC_IA := percented(Percent_RC_IA);
	SELF.Percent_RC_IB := percented(Percent_RC_IB);
	SELF.Percent_RC_IC := percented(Percent_RC_IC);
	SELF.Percent_RC_ID := percented(Percent_RC_ID);
	SELF.Percent_RC_IE := percented(Percent_RC_IE);
	SELF.Percent_RC_IF := percented(Percent_RC_IF);
	SELF.Percent_RC_IG := percented(Percent_RC_IG);
	SELF.Percent_RC_IH := percented(Percent_RC_IH);
	SELF.Percent_RC_II := percented(Percent_RC_II);
	SELF.Percent_RC_IJ := percented(Percent_RC_IJ);
	SELF.Percent_RC_IK := percented(Percent_RC_IK);
	SELF.Percent_RC_IS := percented(Percent_RC_IS);
	SELF.Percent_RC_IT := percented(Percent_RC_IT);
	SELF.Percent_RC_MI := percented(Percent_RC_MI);
	SELF.Percent_RC_MN := percented(Percent_RC_MN);
	SELF.Percent_RC_MO := percented(Percent_RC_MO);
	SELF.Percent_RC_MS := percented(Percent_RC_MS);
	SELF.Percent_RC_PA := percented(Percent_RC_PA);
	SELF.Percent_RC_PO := percented(Percent_RC_PO);
	SELF.Percent_RC_PV := percented(Percent_RC_PV);
	SELF.Percent_RC_RS := percented(Percent_RC_RS);
	SELF.Percent_RC_SR := percented(Percent_RC_SR);
	SELF.Percent_RC_U1 := percented(Percent_RC_U1);
	SELF.Percent_RC_U2 := percented(Percent_RC_U2);
	SELF.Percent_RC_WL := percented(Percent_RC_WL);
	SELF.Percent_RC_ZI := percented(Percent_RC_ZI);
	// New version 1 reason codes
	SELF.Percent_RC_CA := percented(Percent_RC_CA);
	SELF.Percent_RC_DI := percented(Percent_RC_DI);
	SELF.Percent_RC_NB := percented(Percent_RC_NB);
	SELF.Percent_RC_NF := percented(Percent_RC_NF);
	SELF.Percent_RC_SD := percented(Percent_RC_SD);
	SELF.Percent_RC_VA := percented(Percent_RC_VA);
END;

Averaged := PROJECT(scout.daily_monitoring.Constants.ds_Record, getAverages(LEFT))[1];
OUTPUT(Averaged, NAMED('Averages_IID'));

difference (field) := FUNCTIONMACRO
	RETURN(ABS(day1.field - Averaged.field));
ENDMACRO;

averageTrackingLayout getDifferences(scout.daily_monitoring.Constants.ds_Record le) := TRANSFORM
		// General Statistics
	SELF.Date_Of_Report := 'DIFFERS';							
	SELF.Total_Number_Of_Transactions := difference(Total_Number_Of_Transactions);							
	SELF.Number_Of_Unique_Account_IDs_Transacted := difference(Number_Of_Unique_Account_IDs_Transacted);		
	
	// Input Population Statistics
	SELF.Percent_First_Name_Populated := difference(Percent_First_Name_Populated);
	SELF.Percent_Last_Name_Populated := difference(Percent_Last_Name_Populated);	
	SELF.Percent_Full_Name_Populated := difference(Percent_Full_Name_Populated);	
	SELF.Percent_SSN_Populated := difference(Percent_SSN_Populated);
	SELF.Percent_DOB_Populated := difference(Percent_DOB_Populated);
	SELF.Percent_Address_Populated := difference(Percent_Address_Populated);
	SELF.Percent_City_Populated := difference(Percent_City_Populated);
	SELF.Percent_State_Populated := difference(Percent_State_Populated);
	SELF.Percent_Zip_Populated := difference(Percent_Zip_Populated);
	SELF.Percent_DL_Populated := difference(Percent_DL_Populated);
	SELF.Percent_Home_Phone_Populated := difference(Percent_Home_Phone_Populated);
	
	// CVI Score Bucket Statistics
	SELF.Percent_CVI_00 := difference(Percent_CVI_00);
	SELF.Percent_CVI_10 := difference(Percent_CVI_10);
	SELF.Percent_CVI_20 := difference(Percent_CVI_20);
	SELF.Percent_CVI_30 := difference(Percent_CVI_30);
	SELF.Percent_CVI_40 := difference(Percent_CVI_40);
	SELF.Percent_CVI_50 := difference(Percent_CVI_50);
	SELF.Average_CVI_Value := difference(Average_CVI_Value);
	
	// NAP Score Bucket Statistics
	SELF.Percent_NAP_0 := difference(Percent_NAP_0);
	SELF.Percent_NAP_1 := difference(Percent_NAP_1);
	SELF.Percent_NAP_2 := difference(Percent_NAP_2);
	SELF.Percent_NAP_3 := difference(Percent_NAP_3);
	SELF.Percent_NAP_4 := difference(Percent_NAP_4);
	SELF.Percent_NAP_5 := difference(Percent_NAP_5);
	SELF.Percent_NAP_6 := difference(Percent_NAP_6);
	SELF.Percent_NAP_7 := difference(Percent_NAP_7);
	SELF.Percent_NAP_8 := difference(Percent_NAP_8);
	SELF.Percent_NAP_9 := difference(Percent_NAP_9);
	SELF.Percent_NAP_10 := difference(Percent_NAP_10);
	SELF.Percent_NAP_11 := difference(Percent_NAP_11);
	SELF.Percent_NAP_12 := difference(Percent_NAP_12);
	SELF.Average_NAP_Value := difference(Average_NAP_Value);
	
	// NAS Score Bucket Statistics
	SELF.Percent_NAS_0 := difference(Percent_NAS_0);
	SELF.Percent_NAS_1 := difference(Percent_NAS_1);
	SELF.Percent_NAS_2 := difference(Percent_NAS_2);
	SELF.Percent_NAS_3 := difference(Percent_NAS_3);
	SELF.Percent_NAS_4 := difference(Percent_NAS_4);
	SELF.Percent_NAS_5 := difference(Percent_NAS_5);
	SELF.Percent_NAS_6 := difference(Percent_NAS_6);
	SELF.Percent_NAS_7 := difference(Percent_NAS_7);
	SELF.Percent_NAS_8 := difference(Percent_NAS_8);
	SELF.Percent_NAS_9 := difference(Percent_NAS_9);
	SELF.Percent_NAS_10 := difference(Percent_NAS_10);
	SELF.Percent_NAS_11 := difference(Percent_NAS_11);
	SELF.Percent_NAS_12 := difference(Percent_NAS_12);
	SELF.Average_NAS_Value := difference(Average_NAS_Value);
	
	//FP Reason codes Statistics
	SELF.Percent_FP_Scored_200	:=	difference(Percent_FP_Scored_200	);
	SELF.Percent_FP_Scored_201	:=	difference(Percent_FP_Scored_201	);
	SELF.Percent_FP_Scored_202	:=	difference(Percent_FP_Scored_202	);
	SELF.Percent_FP_Scored_203	:=	difference(Percent_FP_Scored_203	);
	SELF.Percent_FP_Scored_222	:=	difference(Percent_FP_Scored_222	);
	SELF.Percent_FP_Scored_Between_300_350 	:=	difference(Percent_FP_Scored_Between_300_350 	);
	SELF.Percent_FP_Scored_Between_351_400 	:=	difference(Percent_FP_Scored_Between_351_400 	);
	SELF.Percent_FP_Scored_Between_401_450 	:=	difference(Percent_FP_Scored_Between_401_450 	);
	SELF.Percent_FP_Scored_Between_451_500 	:=	difference(Percent_FP_Scored_Between_451_500 	);
	SELF.Percent_FP_Scored_Between_501_550 	:=	difference(Percent_FP_Scored_Between_501_550 	);
	SELF.Percent_FP_Scored_Between_551_600 	:=	difference(Percent_FP_Scored_Between_551_600 	);
	SELF.Percent_FP_Scored_Between_601_650 	:=	difference(Percent_FP_Scored_Between_601_650 	);
	SELF.Percent_FP_Scored_Between_651_700 	:=	difference(Percent_FP_Scored_Between_651_700 	);
	SELF.Percent_FP_Scored_Between_701_750 	:=	difference(Percent_FP_Scored_Between_701_750 	);
	SELF.Percent_FP_Scored_Between_751_900 	:=	difference(Percent_FP_Scored_Between_751_900 	);
	SELF.Percent_FP_Scored_Above_900				:=	difference(Percent_FP_Scored_Above_900	);
	SELF.Average_Score_Excluding_Exceptions	:=	difference(Average_Score_Excluding_Exceptions	);
	SELF.Percent_FraudPointRC1							:=	difference(Percent_FraudPointRC1	);
	SELF.Percent_FP_RC_02										:=	difference(Percent_FP_RC_02	);
	SELF.Percent_FP_RC_03										:=	difference(Percent_FP_RC_03	);
	SELF.Percent_FP_RC_06										:=	difference(Percent_FP_RC_06	);
	SELF.Percent_FP_RC_07										:=	difference(Percent_FP_RC_07	);
	SELF.Percent_FP_RC_08										:=	difference(Percent_FP_RC_08	);
	SELF.Percent_FP_RC_09										:=	difference(Percent_FP_RC_09	);
	SELF.Percent_FP_RC_10										:=	difference(Percent_FP_RC_10	);
	SELF.Percent_FP_RC_11										:=	difference(Percent_FP_RC_11	);
	SELF.Percent_FP_RC_12										:=	difference(Percent_FP_RC_12	);
	SELF.Percent_FP_RC_14										:=	difference(Percent_FP_RC_14	);
	SELF.Percent_FP_RC_15										:=	difference(Percent_FP_RC_15	);
	SELF.Percent_FP_RC_16										:=	difference(Percent_FP_RC_16	);
	SELF.Percent_FP_RC_34										:=	difference(Percent_FP_RC_34	);
	SELF.Percent_FP_RC_38										:=	difference(Percent_FP_RC_38	);
	SELF.Percent_FP_RC_39										:=	difference(Percent_FP_RC_39	);
	SELF.Percent_FP_RC_40										:=	difference(Percent_FP_RC_40	);
	SELF.Percent_FP_RC_49										:=	difference(Percent_FP_RC_49	);
	SELF.Percent_FP_RC_50										:=	difference(Percent_FP_RC_50	);
	SELF.Percent_FP_RC_51										:=	difference(Percent_FP_RC_51	);
	SELF.Percent_FP_RC_52										:=	difference(Percent_FP_RC_52	);
	SELF.Percent_FP_RC_53										:=	difference(Percent_FP_RC_53	);
	SELF.Percent_FP_RC_55										:=	difference(Percent_FP_RC_55	);
	SELF.Percent_FP_RC_56										:=	difference(Percent_FP_RC_56	);
	SELF.Percent_FP_RC_57										:=	difference(Percent_FP_RC_57	);
	SELF.Percent_FP_RC_64										:=	difference(Percent_FP_RC_64	);
	SELF.Percent_FP_RC_66										:=	difference(Percent_FP_RC_66	);
	SELF.Percent_FP_RC_71										:=	difference(Percent_FP_RC_71	);
	SELF.Percent_FP_RC_72										:=	difference(Percent_FP_RC_72	);
	SELF.Percent_FP_RC_73										:=	difference(Percent_FP_RC_73	);
	SELF.Percent_FP_RC_74										:=	difference(Percent_FP_RC_74	);
	SELF.Percent_FP_RC_75										:=	difference(Percent_FP_RC_75	);
	SELF.Percent_FP_RC_77										:=	difference(Percent_FP_RC_77	);
	SELF.Percent_FP_RC_78										:=	difference(Percent_FP_RC_78	);
	SELF.Percent_FP_RC_79										:=	difference(Percent_FP_RC_79	);
	SELF.Percent_FP_RC_80										:=	difference(Percent_FP_RC_80	);
	SELF.Percent_FP_RC_81										:=	difference(Percent_FP_RC_81	);
	SELF.Percent_FP_RC_82										:=	difference(Percent_FP_RC_82	);
	SELF.Percent_FP_RC_85										:=	difference(Percent_FP_RC_85	);
	SELF.Percent_FP_RC_89										:=	difference(Percent_FP_RC_89	);
	SELF.Percent_FP_RC_90										:=	difference(Percent_FP_RC_90	);
	SELF.Percent_FP_RC_97										:=	difference(Percent_FP_RC_97	);
	SELF.Percent_FP_RC_9D										:=	difference(Percent_FP_RC_9D	);
	SELF.Percent_FP_RC_9K										:=	difference(Percent_FP_RC_9K	);
	SELF.Percent_FP_RC_AR										:=	difference(Percent_FP_RC_AR	);
	SELF.Percent_FP_RC_BO										:=	difference(Percent_FP_RC_BO	);
	SELF.Percent_FP_RC_CB										:=	difference(Percent_FP_RC_CB	);
	SELF.Percent_FP_RC_CC										:=	difference(Percent_FP_RC_CC	);
	SELF.Percent_FP_RC_CR										:=	difference(Percent_FP_RC_CR	);
	SELF.Percent_FP_RC_DR										:=	difference(Percent_FP_RC_DR	);
	SELF.Percent_FP_RC_FQ										:=	difference(Percent_FP_RC_FQ	);
	SELF.Percent_FP_RC_FV										:=	difference(Percent_FP_RC_FV	);
	SELF.Percent_FP_RC_HA										:=	difference(Percent_FP_RC_HA	);
	SELF.Percent_FP_RC_IA										:=	difference(Percent_FP_RC_IA	);
	SELF.Percent_FP_RC_IE										:=	difference(Percent_FP_RC_IE	);
	SELF.Percent_FP_RC_IF										:=	difference(Percent_FP_RC_IF	);
	SELF.Percent_FP_RC_IG										:=	difference(Percent_FP_RC_IG	);
	SELF.Percent_FP_RC_II										:=	difference(Percent_FP_RC_II	);
	SELF.Percent_FP_RC_IJ										:=	difference(Percent_FP_RC_IJ	);
	SELF.Percent_FP_RC_IK										:=	difference(Percent_FP_RC_IK	);
	SELF.Percent_FP_RC_IR										:=	difference(Percent_FP_RC_IR	);
	SELF.Percent_FP_RC_MI										:=	difference(Percent_FP_RC_MI	);
	SELF.Percent_FP_RC_MN										:=	difference(Percent_FP_RC_MN	);
	SELF.Percent_FP_RC_MS										:=	difference(Percent_FP_RC_MS	);
	SELF.Percent_FP_RC_PA										:=	difference(Percent_FP_RC_PA	);
	SELF.Percent_FP_RC_PH										:=	difference(Percent_FP_RC_PH	);
	SELF.Percent_FP_RC_PN										:=	difference(Percent_FP_RC_PN	);
	SELF.Percent_FP_RC_PO										:=	difference(Percent_FP_RC_PO	);
	SELF.Percent_FP_RC_QA										:=	difference(Percent_FP_RC_QA	);
	SELF.Percent_FP_RC_QB										:=	difference(Percent_FP_RC_QB	);
	SELF.Percent_FP_RC_QC										:=	difference(Percent_FP_RC_QC	);
	SELF.Percent_FP_RC_QD										:=	difference(Percent_FP_RC_QD	);
	SELF.Percent_FP_RC_QE										:=	difference(Percent_FP_RC_QE	);
	SELF.Percent_FP_RC_QF										:=	difference(Percent_FP_RC_QF	);
	SELF.Percent_FP_RC_QG										:=	difference(Percent_FP_RC_QG	);
	SELF.Percent_FP_RC_QH										:=	difference(Percent_FP_RC_QH	);
	SELF.Percent_FP_RC_QI										:=	difference(Percent_FP_RC_QI	);
	SELF.Percent_FP_RC_QJ										:=	difference(Percent_FP_RC_QJ	);
	SELF.Percent_FP_RC_QK										:=	difference(Percent_FP_RC_QK	);
	SELF.Percent_FP_RC_QL										:=	difference(Percent_FP_RC_QL	);
	SELF.Percent_FP_RC_QM										:=	difference(Percent_FP_RC_QM	);
	SELF.Percent_FP_RC_RC										:=	difference(Percent_FP_RC_RC	);
	SELF.Percent_FP_RC_RF										:=	difference(Percent_FP_RC_RF	);
	SELF.Percent_FP_RC_S1										:=	difference(Percent_FP_RC_S1	);
	SELF.Percent_FP_RC_S2										:=	difference(Percent_FP_RC_S2	);
	SELF.Percent_FP_RC_S3										:=	difference(Percent_FP_RC_S3	);
	SELF.Percent_FP_RC_S4										:=	difference(Percent_FP_RC_S4	);
	SELF.Percent_FP_RC_S5										:=	difference(Percent_FP_RC_S5	);
	SELF.Percent_FP_RC_SA										:=	difference(Percent_FP_RC_SA	);
	SELF.Percent_FP_RC_SC										:=	difference(Percent_FP_RC_SC	);
	SELF.Percent_FP_RC_SN										:=	difference(Percent_FP_RC_SN	);
	SELF.Percent_FP_RC_SR										:=	difference(Percent_FP_RC_SR	);
	SELF.Percent_FP_RC_VE										:=	difference(Percent_FP_RC_VE	);
	SELF.Percent_FP_RC_VL										:=	difference(Percent_FP_RC_VL	);
	SELF.Percent_FP_RC_VR										:=	difference(Percent_FP_RC_VR	);
	SELF.Percent_FP_RC_VV										:=	difference(Percent_FP_RC_VV	);
	SELF.Percent_FP_RC_VX										:=	difference(Percent_FP_RC_VX	);
	SELF.Percent_StolenIdentity_Index				:=	difference(Percent_StolenIdentity_Index	);
	SELF.Percent_SyntheticIdentity_Index		:=	difference(Percent_SyntheticIdentity_Index	);
	SELF.Percent_ManipulatedIdentity_Index	:=	difference(Percent_ManipulatedIdentity_Index	);
	SELF.Percent_VulnerableVictim_Index			:=	difference(Percent_VulnerableVictim_Index	);
	SELF.Percent_FriendlyFraud_Index				:=	difference(Percent_FriendlyFraud_Index	);
	SELF.Percent_SuspiciousActivity_Index		:=	difference(Percent_SuspiciousActivity_Index	);
	// Reason Code Population Statistics
	SELF.Percent_RC_01 := difference(Percent_RC_01);
	SELF.Percent_RC_02 := difference(Percent_RC_02);
	SELF.Percent_RC_03 := difference(Percent_RC_03);
	SELF.Percent_RC_04 := difference(Percent_RC_04);
	SELF.Percent_RC_05 := difference(Percent_RC_05);
	SELF.Percent_RC_06 := difference(Percent_RC_06);
	SELF.Percent_RC_07 := difference(Percent_RC_07);
	SELF.Percent_RC_08 := difference(Percent_RC_08);
	SELF.Percent_RC_09 := difference(Percent_RC_09);
	SELF.Percent_RC_10 := difference(Percent_RC_10);
	SELF.Percent_RC_11 := difference(Percent_RC_11);
	SELF.Percent_RC_12 := difference(Percent_RC_12);
	SELF.Percent_RC_13 := difference(Percent_RC_13);
	SELF.Percent_RC_14 := difference(Percent_RC_14);
	SELF.Percent_RC_15 := difference(Percent_RC_15);
	SELF.Percent_RC_16 := difference(Percent_RC_16);
	SELF.Percent_RC_17 := difference(Percent_RC_17);
	SELF.Percent_RC_19 := difference(Percent_RC_19);
	SELF.Percent_RC_20 := difference(Percent_RC_20);
	SELF.Percent_RC_21 := difference(Percent_RC_21);
	SELF.Percent_RC_22 := difference(Percent_RC_22);
	SELF.Percent_RC_23 := difference(Percent_RC_23);
	SELF.Percent_RC_24 := difference(Percent_RC_24);
	SELF.Percent_RC_25 := difference(Percent_RC_25);
	SELF.Percent_RC_26 := difference(Percent_RC_26);
	SELF.Percent_RC_27 := difference(Percent_RC_27);
	SELF.Percent_RC_28 := difference(Percent_RC_28);
	SELF.Percent_RC_29 := difference(Percent_RC_29);
	SELF.Percent_RC_30 := difference(Percent_RC_30);
	SELF.Percent_RC_31 := difference(Percent_RC_31);
	SELF.Percent_RC_32 := difference(Percent_RC_32);
	SELF.Percent_RC_33 := difference(Percent_RC_33);
	SELF.Percent_RC_34 := difference(Percent_RC_34);
	SELF.Percent_RC_35 := difference(Percent_RC_35);
	SELF.Percent_RC_36 := difference(Percent_RC_36);
	SELF.Percent_RC_37 := difference(Percent_RC_37);
	SELF.Percent_RC_38 := difference(Percent_RC_38);
	SELF.Percent_RC_39 := difference(Percent_RC_39);
	SELF.Percent_RC_40 := difference(Percent_RC_40);
	SELF.Percent_RC_41 := difference(Percent_RC_41);
	SELF.Percent_RC_42 := difference(Percent_RC_42);
	SELF.Percent_RC_43 := difference(Percent_RC_43);
	SELF.Percent_RC_44 := difference(Percent_RC_44);
	SELF.Percent_RC_45 := difference(Percent_RC_45);
	SELF.Percent_RC_46 := difference(Percent_RC_46);
	SELF.Percent_RC_47 := difference(Percent_RC_47);
	SELF.Percent_RC_48 := difference(Percent_RC_48);
	SELF.Percent_RC_49 := difference(Percent_RC_49);
	SELF.Percent_RC_50 := difference(Percent_RC_50);
	SELF.Percent_RC_51 := difference(Percent_RC_51);
	SELF.Percent_RC_52 := difference(Percent_RC_52);
	SELF.Percent_RC_53 := difference(Percent_RC_53);
	SELF.Percent_RC_54 := difference(Percent_RC_54);
	SELF.Percent_RC_55 := difference(Percent_RC_55);
	SELF.Percent_RC_56 := difference(Percent_RC_56);
	SELF.Percent_RC_57 := difference(Percent_RC_57);
	SELF.Percent_RC_58 := difference(Percent_RC_58);
	SELF.Percent_RC_59 := difference(Percent_RC_59);
	SELF.Percent_RC_5Q := difference(Percent_RC_5Q);
	SELF.Percent_RC_60 := difference(Percent_RC_60);
	SELF.Percent_RC_61 := difference(Percent_RC_61);
	SELF.Percent_RC_62 := difference(Percent_RC_62);
	SELF.Percent_RC_63 := difference(Percent_RC_63);
	SELF.Percent_RC_64 := difference(Percent_RC_64);
	SELF.Percent_RC_65 := difference(Percent_RC_65);
	SELF.Percent_RC_66 := difference(Percent_RC_66);
	SELF.Percent_RC_67 := difference(Percent_RC_67);
	SELF.Percent_RC_68 := difference(Percent_RC_68);
	SELF.Percent_RC_69 := difference(Percent_RC_69);
	SELF.Percent_RC_70 := difference(Percent_RC_70);
	SELF.Percent_RC_71 := difference(Percent_RC_71);
	SELF.Percent_RC_72 := difference(Percent_RC_72);
	SELF.Percent_RC_73 := difference(Percent_RC_73);
	SELF.Percent_RC_74 := difference(Percent_RC_74);
	SELF.Percent_RC_75 := difference(Percent_RC_75);
	SELF.Percent_RC_76 := difference(Percent_RC_76);
	SELF.Percent_RC_77 := difference(Percent_RC_77);
	SELF.Percent_RC_78 := difference(Percent_RC_78);
	SELF.Percent_RC_79 := difference(Percent_RC_79);
	SELF.Percent_RC_80 := difference(Percent_RC_80);
	SELF.Percent_RC_81 := difference(Percent_RC_81);
	SELF.Percent_RC_82 := difference(Percent_RC_82);
	SELF.Percent_RC_83 := difference(Percent_RC_83);
	SELF.Percent_RC_84 := difference(Percent_RC_84);
	SELF.Percent_RC_85 := difference(Percent_RC_85);
	SELF.Percent_RC_86 := difference(Percent_RC_86);
	SELF.Percent_RC_87 := difference(Percent_RC_87);
	SELF.Percent_RC_88 := difference(Percent_RC_88);
	SELF.Percent_RC_89 := difference(Percent_RC_89);
	SELF.Percent_RC_90 := difference(Percent_RC_90);
	SELF.Percent_RC_91 := difference(Percent_RC_91);
	SELF.Percent_RC_92 := difference(Percent_RC_92);
	SELF.Percent_RC_93 := difference(Percent_RC_93);
	SELF.Percent_RC_94 := difference(Percent_RC_94);
	SELF.Percent_RC_95 := difference(Percent_RC_95);
	SELF.Percent_RC_96 := difference(Percent_RC_96);
	SELF.Percent_RC_97 := difference(Percent_RC_97);
	SELF.Percent_RC_98 := difference(Percent_RC_98);
	SELF.Percent_RC_99 := difference(Percent_RC_99);
	SELF.Percent_RC_9A := difference(Percent_RC_9A);
	SELF.Percent_RC_9B := difference(Percent_RC_9B);
	SELF.Percent_RC_9C := difference(Percent_RC_9C);
	SELF.Percent_RC_9D := difference(Percent_RC_9D);
	SELF.Percent_RC_9E := difference(Percent_RC_9E);
	SELF.Percent_RC_9F := difference(Percent_RC_9F);
	SELF.Percent_RC_9G := difference(Percent_RC_9G);
	SELF.Percent_RC_9H := difference(Percent_RC_9H);
	SELF.Percent_RC_9I := difference(Percent_RC_9I);
	SELF.Percent_RC_9J := difference(Percent_RC_9J);
	SELF.Percent_RC_9K := difference(Percent_RC_9K);
	SELF.Percent_RC_9L := difference(Percent_RC_9L);
	SELF.Percent_RC_9M := difference(Percent_RC_9M);
	SELF.Percent_RC_9N := difference(Percent_RC_9N);
	SELF.Percent_RC_9O := difference(Percent_RC_9O);
	SELF.Percent_RC_9P := difference(Percent_RC_9P);
	SELF.Percent_RC_9Q := difference(Percent_RC_9Q);
	SELF.Percent_RC_9R := difference(Percent_RC_9R);
	SELF.Percent_RC_9S := difference(Percent_RC_9S);
	SELF.Percent_RC_9T := difference(Percent_RC_9T);
	SELF.Percent_RC_9U := difference(Percent_RC_9U);
	SELF.Percent_RC_9V := difference(Percent_RC_9V);
	SELF.Percent_RC_9W := difference(Percent_RC_9W);
	SELF.Percent_RC_9X := difference(Percent_RC_9X);
	SELF.Percent_RC_A0 := difference(Percent_RC_A0);
	SELF.Percent_RC_A1 := difference(Percent_RC_A1);
	SELF.Percent_RC_A2 := difference(Percent_RC_A2);
	SELF.Percent_RC_A3 := difference(Percent_RC_A3);
	SELF.Percent_RC_A4 := difference(Percent_RC_A4);
	SELF.Percent_RC_A5 := difference(Percent_RC_A5);
	SELF.Percent_RC_A6 := difference(Percent_RC_A6);
	SELF.Percent_RC_A7 := difference(Percent_RC_A7);
	SELF.Percent_RC_A8 := difference(Percent_RC_A8);
	SELF.Percent_RC_A9 := difference(Percent_RC_A9);
	SELF.Percent_RC_B0 := difference(Percent_RC_B0);
	SELF.Percent_RC_BO := difference(Percent_RC_BO);
	SELF.Percent_RC_CL := difference(Percent_RC_CL);
	SELF.Percent_RC_CO := difference(Percent_RC_CO);
	SELF.Percent_RC_CR := difference(Percent_RC_CR);
	SELF.Percent_RC_CZ := difference(Percent_RC_CZ);
	SELF.Percent_RC_DD := difference(Percent_RC_DD);
	SELF.Percent_RC_DF := difference(Percent_RC_DF);
	SELF.Percent_RC_DM := difference(Percent_RC_DM);
	SELF.Percent_RC_DV := difference(Percent_RC_DV);
	SELF.Percent_RC_EV := difference(Percent_RC_EV);
	SELF.Percent_RC_FB := difference(Percent_RC_FB);
	SELF.Percent_RC_FM := difference(Percent_RC_FM);
	SELF.Percent_RC_FQ := difference(Percent_RC_FQ);
	SELF.Percent_RC_FR := difference(Percent_RC_FR);
	SELF.Percent_RC_FV := difference(Percent_RC_FV);
	SELF.Percent_RC_IA := difference(Percent_RC_IA);
	SELF.Percent_RC_IB := difference(Percent_RC_IB);
	SELF.Percent_RC_IC := difference(Percent_RC_IC);
	SELF.Percent_RC_ID := difference(Percent_RC_ID);
	SELF.Percent_RC_IE := difference(Percent_RC_IE);
	SELF.Percent_RC_IF := difference(Percent_RC_IF);
	SELF.Percent_RC_IG := difference(Percent_RC_IG);
	SELF.Percent_RC_IH := difference(Percent_RC_IH);
	SELF.Percent_RC_II := difference(Percent_RC_II);
	SELF.Percent_RC_IJ := difference(Percent_RC_IJ);
	SELF.Percent_RC_IK := difference(Percent_RC_IK);
	SELF.Percent_RC_IS := difference(Percent_RC_IS);
	SELF.Percent_RC_IT := difference(Percent_RC_IT);
	SELF.Percent_RC_MI := difference(Percent_RC_MI);
	SELF.Percent_RC_MN := difference(Percent_RC_MN);
	SELF.Percent_RC_MO := difference(Percent_RC_MO);
	SELF.Percent_RC_MS := difference(Percent_RC_MS);
	SELF.Percent_RC_PA := difference(Percent_RC_PA);
	SELF.Percent_RC_PO := difference(Percent_RC_PO);
	SELF.Percent_RC_PV := difference(Percent_RC_PV);
	SELF.Percent_RC_RS := difference(Percent_RC_RS);
	SELF.Percent_RC_SR := difference(Percent_RC_SR);
	SELF.Percent_RC_U1 := difference(Percent_RC_U1);
	SELF.Percent_RC_U2 := difference(Percent_RC_U2);
	SELF.Percent_RC_WL := difference(Percent_RC_WL);
	SELF.Percent_RC_ZI := difference(Percent_RC_ZI);
	// New version 1 reason codes
	SELF.Percent_RC_CA := difference(Percent_RC_CA);
	SELF.Percent_RC_DI := difference(Percent_RC_DI);
	SELF.Percent_RC_NB := difference(Percent_RC_NB);
	SELF.Percent_RC_NF := difference(Percent_RC_NF);
	SELF.Percent_RC_SD := difference(Percent_RC_SD);
	SELF.Percent_RC_VA := difference(Percent_RC_VA);
END;

Differs := PROJECT(scout.daily_monitoring.Constants.ds_Record, getDifferences(LEFT))[1];

OUTPUT(Differs, NAMED('Differences_IID'));

/* ***********************************************************************************************
 *************************************************************************************************
 *                                        GENERATE E-MAIL BODY                                   *
 *************************************************************************************************
 *********************************************************************************************** */

dashes := '-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n';
STRING padNumber (STRING number, BOOLEAN exist) := MAP(exist = FALSE 	=> ' \t\t|',
				LENGTH(number) >= 0 AND LENGTH(number) <= 5 	=> ' ' + number + '\t\t|',
				LENGTH(number) >= 6 AND LENGTH(number) <= 12 	=> ' ' + number + '\t|',
				LENGTH(number) >= 13 AND LENGTH(number) <= 13 => ' ' + number + '|',
					number + '|');

genRow (field, disablePercent = FALSE, disableDiffers = FALSE) := MACRO
	padNumber((STRING)day1.field + IF(disablePercent = TRUE, '', '%'), day1.Date_Of_Report <> '') + 
	padNumber((STRING)day2.field + IF(disablePercent = TRUE, '', '%'), day2.Date_Of_Report <> '') + 
	padNumber((STRING)day3.field + IF(disablePercent = TRUE, '', '%'), day3.Date_Of_Report <> '') + 
	padNumber((STRING)day4.field + IF(disablePercent = TRUE, '', '%'), day4.Date_Of_Report <> '') + 
	padNumber((STRING)day5.field + IF(disablePercent = TRUE, '', '%'), day5.Date_Of_Report <> '') + 
	padNumber((STRING)Oldest[1].field + IF(disablePercent = TRUE, '', '%'), COUNT(Oldest) > 0) + 
	padNumber((STRING)Averaged.field + IF(disablePercent = TRUE, '', '%'), Averaged.Date_Of_Report <> '') +
	IF(disableDiffers = TRUE, '', padNumber((STRING)Differs.field + IF(disablePercent = TRUE, '', '%'), Differs.Date_Of_Report <> '')) +
	'\n' +
	dashes
ENDMACRO;

potentialProblems (field, fieldName, thresh) := MACRO
	IF(Differs.field >= thresh, fieldName + ':\t' + (STRING)Differs.field + '%\t(' + (STRING)thresh + '% Threshold)\n', '')
ENDMACRO;

emailBody := 
'Instant ID Daily Monitor' + '\n' +
'==================\n' +
'Report Run Date: ' + EndDate + '\n' + 
'SAOT Key Latest Date: ' + day1.Date_Of_Report + '\n\n' +
// Highlight any potential issues at the top of the email, so you don't have to look at the whole thing if you don't want to
'Potential Problems - Percent Change Between ' + day1.Date_Of_Report + ' and Average >= Threshold\n' + 
'===============================================================\n' + 
// potentialProblems(Percent_First_Name_Populated, 'Percent_First_Name_Populated', 1.000) +
// potentialProblems(Percent_Last_Name_Populated, 'Percent_Last_Name_Populated', 1.000) +
// potentialProblems(Percent_SSN_Populated, 'Percent_SSN_Populated', 1.000) +
// potentialProblems(Percent_DOB_Populated, 'Percent_DOB_Populated', 1.000) +
// potentialProblems(Percent_Address_Populated, 'Percent_Address_Populated', 1.000) +
// potentialProblems(Percent_City_Populated, 'Percent_City_Populated', 1.000) +
// potentialProblems(Percent_State_Populated, 'Percent_State_Populated', 1.000) +
// potentialProblems(Percent_Zip_Populated, 'Percent_Zip_Populated', 1.000) +
// potentialProblems(Percent_DL_Populated, 'Percent_DL_Populated', 1.000) +
// potentialProblems(Percent_Home_Phone_Populated, 'Percent_Home_Phone_Populated', 1.000) +
potentialProblems(Percent_CVI_00, 'Percent_CVI_00', scout.daily_monitoring.Constants.ThreshPercent_CVI_00) +
potentialProblems(Percent_CVI_10, 'Percent_CVI_10', scout.daily_monitoring.Constants.ThreshPercent_CVI_10) +
potentialProblems(Percent_CVI_20, 'Percent_CVI_20', scout.daily_monitoring.Constants.ThreshPercent_CVI_20) +
potentialProblems(Percent_CVI_30, 'Percent_CVI_30', scout.daily_monitoring.Constants.ThreshPercent_CVI_30) +
potentialProblems(Percent_CVI_40, 'Percent_CVI_40', scout.daily_monitoring.Constants.ThreshPercent_CVI_40) +
potentialProblems(Percent_CVI_50, 'Percent_CVI_50', scout.daily_monitoring.Constants.ThreshPercent_CVI_50) +
potentialProblems(Percent_NAP_0, 'Percent_NAP_0', scout.daily_monitoring.Constants.ThreshPercent_NAP_0) +
potentialProblems(Percent_NAP_1, 'Percent_NAP_1', scout.daily_monitoring.Constants.ThreshPercent_NAP_1) +
potentialProblems(Percent_NAP_2, 'Percent_NAP_2', scout.daily_monitoring.Constants.ThreshPercent_NAP_2) +
potentialProblems(Percent_NAP_3, 'Percent_NAP_3', scout.daily_monitoring.Constants.ThreshPercent_NAP_3) +
potentialProblems(Percent_NAP_4, 'Percent_NAP_4', scout.daily_monitoring.Constants.ThreshPercent_NAP_4) +
potentialProblems(Percent_NAP_5, 'Percent_NAP_5', scout.daily_monitoring.Constants.ThreshPercent_NAP_5) +
potentialProblems(Percent_NAP_6, 'Percent_NAP_6', scout.daily_monitoring.Constants.ThreshPercent_NAP_6) +
potentialProblems(Percent_NAP_7, 'Percent_NAP_7', scout.daily_monitoring.Constants.ThreshPercent_NAP_7) +
potentialProblems(Percent_NAP_8, 'Percent_NAP_8', scout.daily_monitoring.Constants.ThreshPercent_NAP_8) +
potentialProblems(Percent_NAP_9, 'Percent_NAP_9', scout.daily_monitoring.Constants.ThreshPercent_NAP_9) +
potentialProblems(Percent_NAP_10, 'Percent_NAP_10', scout.daily_monitoring.Constants.ThreshPercent_NAP_10) +
potentialProblems(Percent_NAP_11, 'Percent_NAP_11', scout.daily_monitoring.Constants.ThreshPercent_NAP_11) +
potentialProblems(Percent_NAP_12, 'Percent_NAP_12', scout.daily_monitoring.Constants.ThreshPercent_NAP_12) +
potentialProblems(Percent_NAS_0, 'Percent_NAS_0', scout.daily_monitoring.Constants.ThreshPercent_NAS_0) +
potentialProblems(Percent_NAS_1, 'Percent_NAS_1', scout.daily_monitoring.Constants.ThreshPercent_NAS_1) +
potentialProblems(Percent_NAS_2, 'Percent_NAS_2', scout.daily_monitoring.Constants.ThreshPercent_NAS_2) +
potentialProblems(Percent_NAS_3, 'Percent_NAS_3', scout.daily_monitoring.Constants.ThreshPercent_NAS_3) +
potentialProblems(Percent_NAS_4, 'Percent_NAS_4', scout.daily_monitoring.Constants.ThreshPercent_NAS_4) +
potentialProblems(Percent_NAS_5, 'Percent_NAS_5', scout.daily_monitoring.Constants.ThreshPercent_NAS_5) +
potentialProblems(Percent_NAS_6, 'Percent_NAS_6', scout.daily_monitoring.Constants.ThreshPercent_NAS_6) +
potentialProblems(Percent_NAS_7, 'Percent_NAS_7', scout.daily_monitoring.Constants.ThreshPercent_NAS_7) +
potentialProblems(Percent_NAS_8, 'Percent_NAS_8', scout.daily_monitoring.Constants.ThreshPercent_NAS_8) +
potentialProblems(Percent_NAS_9, 'Percent_NAS_9', scout.daily_monitoring.Constants.ThreshPercent_NAS_9) +
potentialProblems(Percent_NAS_10, 'Percent_NAS_10', scout.daily_monitoring.Constants.ThreshPercent_NAS_10) +
potentialProblems(Percent_NAS_11, 'Percent_NAS_11', scout.daily_monitoring.Constants.ThreshPercent_NAS_11) +
potentialProblems(Percent_NAS_12, 'Percent_NAS_12', scout.daily_monitoring.Constants.ThreshPercent_NAS_12) +
//FP REASON CODES
	potentialProblems(Percent_FP_RC_02	, 'Percent_FP_RC_02', scout.daily_monitoring.Constants.ThreshPercent_RC_02) +
	potentialProblems(Percent_FP_RC_03	, 'Percent_FP_RC_03', scout.daily_monitoring.Constants.ThreshPercent_RC_03) +
	potentialProblems(Percent_FP_RC_06	, 'Percent_FP_RC_06', scout.daily_monitoring.Constants.ThreshPercent_RC_06) +
	potentialProblems(Percent_FP_RC_07	, 'Percent_FP_RC_07', scout.daily_monitoring.Constants.ThreshPercent_RC_07) +
	potentialProblems(Percent_FP_RC_08	, 'Percent_FP_RC_08', scout.daily_monitoring.Constants.ThreshPercent_RC_08) +
	potentialProblems(Percent_FP_RC_09	, 'Percent_FP_RC_09', scout.daily_monitoring.Constants.ThreshPercent_RC_09) +
	potentialProblems(Percent_FP_RC_10	, 'Percent_FP_RC_10', scout.daily_monitoring.Constants.ThreshPercent_RC_10) +
	potentialProblems(Percent_FP_RC_11	, 'Percent_FP_RC_11', scout.daily_monitoring.Constants.ThreshPercent_RC_11) +
	potentialProblems(Percent_FP_RC_12	, 'Percent_FP_RC_12', scout.daily_monitoring.Constants.ThreshPercent_RC_12) +
	potentialProblems(Percent_FP_RC_14	, 'Percent_FP_RC_14', scout.daily_monitoring.Constants.ThreshPercent_RC_14) +
	potentialProblems(Percent_FP_RC_15	, 'Percent_FP_RC_15', scout.daily_monitoring.Constants.ThreshPercent_RC_15) +
	potentialProblems(Percent_FP_RC_16	, 'Percent_FP_RC_16', scout.daily_monitoring.Constants.ThreshPercent_RC_16) +
	potentialProblems(Percent_FP_RC_34	, 'Percent_FP_RC_34', scout.daily_monitoring.Constants.ThreshPercent_RC_34) +
	potentialProblems(Percent_FP_RC_38	, 'Percent_FP_RC_38', scout.daily_monitoring.Constants.ThreshPercent_RC_38) +
	potentialProblems(Percent_FP_RC_39	, 'Percent_FP_RC_39', scout.daily_monitoring.Constants.ThreshPercent_RC_39) +
	potentialProblems(Percent_FP_RC_40	, 'Percent_FP_RC_40', scout.daily_monitoring.Constants.ThreshPercent_RC_40) +
	potentialProblems(Percent_FP_RC_49	, 'Percent_FP_RC_49', scout.daily_monitoring.Constants.ThreshPercent_RC_49) +
  potentialProblems(Percent_FP_RC_50	, 'Percent_FP_RC_50', scout.daily_monitoring.Constants.ThreshPercent_RC_50) +
	potentialProblems(Percent_FP_RC_51	, 'Percent_FP_RC_51', scout.daily_monitoring.Constants.ThreshPercent_RC_51) +
	potentialProblems(Percent_FP_RC_52	, 'Percent_FP_RC_52', scout.daily_monitoring.Constants.ThreshPercent_RC_52) +
	potentialProblems(Percent_FP_RC_53	, 'Percent_FP_RC_53', scout.daily_monitoring.Constants.ThreshPercent_RC_53) +
	potentialProblems(Percent_FP_RC_55	, 'Percent_FP_RC_55', scout.daily_monitoring.Constants.ThreshPercent_RC_55) +
	potentialProblems(Percent_FP_RC_56	, 'Percent_FP_RC_56', scout.daily_monitoring.Constants.ThreshPercent_RC_56) +
	potentialProblems(Percent_FP_RC_57	, 'Percent_FP_RC_57', scout.daily_monitoring.Constants.ThreshPercent_RC_57) +
	potentialProblems(Percent_FP_RC_64	, 'Percent_FP_RC_64', scout.daily_monitoring.Constants.ThreshPercent_RC_64) +
	potentialProblems(Percent_FP_RC_66	, 'Percent_FP_RC_66', scout.daily_monitoring.Constants.ThreshPercent_RC_66) +
	potentialProblems(Percent_FP_RC_71	, 'Percent_FP_RC_71', scout.daily_monitoring.Constants.ThreshPercent_RC_71) +
	potentialProblems(Percent_FP_RC_72	, 'Percent_FP_RC_72', scout.daily_monitoring.Constants.ThreshPercent_RC_72) +
	potentialProblems(Percent_FP_RC_73	, 'Percent_FP_RC_73', scout.daily_monitoring.Constants.ThreshPercent_RC_73) +
	potentialProblems(Percent_FP_RC_74	, 'Percent_FP_RC_74', scout.daily_monitoring.Constants.ThreshPercent_RC_74) +
	potentialProblems(Percent_FP_RC_75	, 'Percent_FP_RC_75', scout.daily_monitoring.Constants.ThreshPercent_RC_75) +
	potentialProblems(Percent_FP_RC_77	, 'Percent_FP_RC_77', scout.daily_monitoring.Constants.ThreshPercent_RC_77) +
	potentialProblems(Percent_FP_RC_78	, 'Percent_FP_RC_78', scout.daily_monitoring.Constants.ThreshPercent_RC_78) +
	potentialProblems(Percent_FP_RC_79	, 'Percent_FP_RC_79', scout.daily_monitoring.Constants.ThreshPercent_RC_79) +
	potentialProblems(Percent_FP_RC_80	, 'Percent_FP_RC_80', scout.daily_monitoring.Constants.ThreshPercent_RC_80) +
	potentialProblems(Percent_FP_RC_81	, 'Percent_FP_RC_81', scout.daily_monitoring.Constants.ThreshPercent_RC_81) +
	potentialProblems(Percent_FP_RC_82	, 'Percent_FP_RC_82', scout.daily_monitoring.Constants.ThreshPercent_RC_82) +
	potentialProblems(Percent_FP_RC_85	, 'Percent_FP_RC_85', scout.daily_monitoring.Constants.ThreshPercent_RC_85) +
	potentialProblems(Percent_FP_RC_89	, 'Percent_FP_RC_89', scout.daily_monitoring.Constants.ThreshPercent_RC_89) +
	potentialProblems(Percent_FP_RC_90	, 'Percent_FP_RC_90', scout.daily_monitoring.Constants.ThreshPercent_RC_90) +
	potentialProblems(Percent_FP_RC_97	, 'Percent_FP_RC_97', scout.daily_monitoring.Constants.ThreshPercent_RC_97) +
	potentialProblems(Percent_FP_RC_9D	, 'Percent_FP_RC_9D', scout.daily_monitoring.Constants.ThreshPercent_RC_9D) +
	potentialProblems(Percent_FP_RC_9K	, 'Percent_FP_RC_9K', scout.daily_monitoring.Constants.ThreshPercent_RC_9K) +
	potentialProblems(Percent_FP_RC_AR	, 'Percent_FP_RC_AR', scout.daily_monitoring.Constants.ThreshPercent_RC_AR) +
	potentialProblems(Percent_FP_RC_BO	, 'Percent_FP_RC_BO', scout.daily_monitoring.Constants.ThreshPercent_RC_BO) +
	potentialProblems(Percent_FP_RC_CB	, 'Percent_FP_RC_CB', scout.daily_monitoring.Constants.ThreshPercent_RC_CB) +
	potentialProblems(Percent_FP_RC_CC	, 'Percent_FP_RC_CC', scout.daily_monitoring.Constants.ThreshPercent_RC_CC) +
	potentialProblems(Percent_FP_RC_CR	, 'Percent_FP_RC_CR', scout.daily_monitoring.Constants.ThreshPercent_RC_CR) +
	potentialProblems(Percent_FP_RC_DR	, 'Percent_FP_RC_DR', scout.daily_monitoring.Constants.ThreshPercent_RC_DR) +
	potentialProblems(Percent_FP_RC_FQ	, 'Percent_FP_RC_FQ', scout.daily_monitoring.Constants.ThreshPercent_RC_FQ) +
	potentialProblems(Percent_FP_RC_FV	, 'Percent_FP_RC_FV', scout.daily_monitoring.Constants.ThreshPercent_RC_FV) +
	potentialProblems(Percent_FP_RC_HA	, 'Percent_FP_RC_HA', scout.daily_monitoring.Constants.ThreshPercent_RC_HA) +
	potentialProblems(Percent_FP_RC_IA	, 'Percent_FP_RC_IA', scout.daily_monitoring.Constants.ThreshPercent_RC_IA) +
	potentialProblems(Percent_FP_RC_IE	, 'Percent_FP_RC_IE', scout.daily_monitoring.Constants.ThreshPercent_RC_IE) +
	potentialProblems(Percent_FP_RC_IF	, 'Percent_FP_RC_IF', scout.daily_monitoring.Constants.ThreshPercent_RC_IF) +
	potentialProblems(Percent_FP_RC_IG	, 'Percent_FP_RC_IG', scout.daily_monitoring.Constants.ThreshPercent_RC_IG) +
	potentialProblems(Percent_FP_RC_II	, 'Percent_FP_RC_II', scout.daily_monitoring.Constants.ThreshPercent_RC_II) +
	potentialProblems(Percent_FP_RC_IJ	, 'Percent_FP_RC_IJ', scout.daily_monitoring.Constants.ThreshPercent_RC_IJ) +
	potentialProblems(Percent_FP_RC_IK	, 'Percent_FP_RC_IK', scout.daily_monitoring.Constants.ThreshPercent_RC_IK) +
	potentialProblems(Percent_FP_RC_IR	, 'Percent_FP_RC_IR', scout.daily_monitoring.Constants.ThreshPercent_RC_IR) +
	potentialProblems(Percent_FP_RC_MI	, 'Percent_FP_RC_MI', scout.daily_monitoring.Constants.ThreshPercent_RC_MI) +
	potentialProblems(Percent_FP_RC_MN	, 'Percent_FP_RC_MN', scout.daily_monitoring.Constants.ThreshPercent_RC_MN) +
	potentialProblems(Percent_FP_RC_MS	, 'Percent_FP_RC_MS', scout.daily_monitoring.Constants.ThreshPercent_RC_MS) +
	potentialProblems(Percent_FP_RC_PA	, 'Percent_FP_RC_PA', scout.daily_monitoring.Constants.ThreshPercent_RC_PA) +
	potentialProblems(Percent_FP_RC_PH	, 'Percent_FP_RC_PH', scout.daily_monitoring.Constants.ThreshPercent_RC_PH) +
	potentialProblems(Percent_FP_RC_PN	, 'Percent_FP_RC_PN', scout.daily_monitoring.Constants.ThreshPercent_RC_PN) +
	potentialProblems(Percent_FP_RC_PO	, 'Percent_FP_RC_PO', scout.daily_monitoring.Constants.ThreshPercent_RC_PO) +
	potentialProblems(Percent_FP_RC_QA	, 'Percent_FP_RC_QA', scout.daily_monitoring.Constants.ThreshPercent_RC_QA) +
	potentialProblems(Percent_FP_RC_QB	, 'Percent_FP_RC_QB', scout.daily_monitoring.Constants.ThreshPercent_RC_QB) +
	potentialProblems(Percent_FP_RC_QC	, 'Percent_FP_RC_QC', scout.daily_monitoring.Constants.ThreshPercent_RC_QC) +
	potentialProblems(Percent_FP_RC_QD	, 'Percent_FP_RC_QD', scout.daily_monitoring.Constants.ThreshPercent_RC_QD) +
	potentialProblems(Percent_FP_RC_QE	, 'Percent_FP_RC_QE', scout.daily_monitoring.Constants.ThreshPercent_RC_QE) +
	potentialProblems(Percent_FP_RC_QF	, 'Percent_FP_RC_QF', scout.daily_monitoring.Constants.ThreshPercent_RC_QF) +
	potentialProblems(Percent_FP_RC_QG	, 'Percent_FP_RC_QG', scout.daily_monitoring.Constants.ThreshPercent_RC_QG) +
	potentialProblems(Percent_FP_RC_QH	, 'Percent_FP_RC_QH', scout.daily_monitoring.Constants.ThreshPercent_RC_QH) +
	potentialProblems(Percent_FP_RC_QI	, 'Percent_FP_RC_QI', scout.daily_monitoring.Constants.ThreshPercent_RC_QI) +
	potentialProblems(Percent_FP_RC_QJ	, 'Percent_FP_RC_QJ', scout.daily_monitoring.Constants.ThreshPercent_RC_QJ) +
	potentialProblems(Percent_FP_RC_QK	, 'Percent_FP_RC_QK', scout.daily_monitoring.Constants.ThreshPercent_RC_QK) +
	potentialProblems(Percent_FP_RC_QL	, 'Percent_FP_RC_QL', scout.daily_monitoring.Constants.ThreshPercent_RC_QL) +
	potentialProblems(Percent_FP_RC_QM	, 'Percent_FP_RC_QM', scout.daily_monitoring.Constants.ThreshPercent_RC_QM) +
	potentialProblems(Percent_FP_RC_RC	, 'Percent_FP_RC_RC', scout.daily_monitoring.Constants.ThreshPercent_RC_RC) +
	potentialProblems(Percent_FP_RC_RF	, 'Percent_FP_RC_RF', scout.daily_monitoring.Constants.ThreshPercent_RC_RF) +
	potentialProblems(Percent_FP_RC_S1	, 'Percent_FP_RC_S1', scout.daily_monitoring.Constants.ThreshPercent_RC_S1) +
	potentialProblems(Percent_FP_RC_S2	, 'Percent_FP_RC_S2', scout.daily_monitoring.Constants.ThreshPercent_RC_S2) +
	potentialProblems(Percent_FP_RC_S3	, 'Percent_FP_RC_S3', scout.daily_monitoring.Constants.ThreshPercent_RC_S3) +
	potentialProblems(Percent_FP_RC_S4	, 'Percent_FP_RC_S4', scout.daily_monitoring.Constants.ThreshPercent_RC_S4) +
	potentialProblems(Percent_FP_RC_S5	, 'Percent_FP_RC_S5', scout.daily_monitoring.Constants.ThreshPercent_RC_S5) +
	potentialProblems(Percent_FP_RC_SA	, 'Percent_FP_RC_SA', scout.daily_monitoring.Constants.ThreshPercent_RC_SA) +
	potentialProblems(Percent_FP_RC_SC	, 'Percent_FP_RC_SC', scout.daily_monitoring.Constants.ThreshPercent_RC_SC) +
	potentialProblems(Percent_FP_RC_SN	, 'Percent_FP_RC_SN', scout.daily_monitoring.Constants.ThreshPercent_RC_SN) +
	potentialProblems(Percent_FP_RC_SR	, 'Percent_FP_RC_SR', scout.daily_monitoring.Constants.ThreshPercent_RC_SR) +
	potentialProblems(Percent_FP_RC_VE	, 'Percent_FP_RC_VE', scout.daily_monitoring.Constants.ThreshPercent_RC_VE) +
	potentialProblems(Percent_FP_RC_VL	, 'Percent_FP_RC_VL', scout.daily_monitoring.Constants.ThreshPercent_RC_VL) +
	potentialProblems(Percent_FP_RC_VR	, 'Percent_FP_RC_VR', scout.daily_monitoring.Constants.ThreshPercent_RC_VR) +
	potentialProblems(Percent_FP_RC_VV	, 'Percent_FP_RC_VV', scout.daily_monitoring.Constants.ThreshPercent_RC_VV) +
	potentialProblems(Percent_FP_RC_VX	, 'Percent_FP_RC_VX', scout.daily_monitoring.Constants.ThreshPercent_RC_VX) +
potentialProblems(Percent_RC_01, 'Percent_RC_01', scout.daily_monitoring.Constants.ThreshPercent_RC_01) +
potentialProblems(Percent_RC_02, 'Percent_RC_02', scout.daily_monitoring.Constants.ThreshPercent_RC_02) +
potentialProblems(Percent_RC_03, 'Percent_RC_03', scout.daily_monitoring.Constants.ThreshPercent_RC_03) +
potentialProblems(Percent_RC_04, 'Percent_RC_04', scout.daily_monitoring.Constants.ThreshPercent_RC_04) +
potentialProblems(Percent_RC_05, 'Percent_RC_05', scout.daily_monitoring.Constants.ThreshPercent_RC_05) +
potentialProblems(Percent_RC_06, 'Percent_RC_06', scout.daily_monitoring.Constants.ThreshPercent_RC_06) +
potentialProblems(Percent_RC_07, 'Percent_RC_07', scout.daily_monitoring.Constants.ThreshPercent_RC_07) +
potentialProblems(Percent_RC_08, 'Percent_RC_08', scout.daily_monitoring.Constants.ThreshPercent_RC_08) +
potentialProblems(Percent_RC_09, 'Percent_RC_09', scout.daily_monitoring.Constants.ThreshPercent_RC_09) +
potentialProblems(Percent_RC_10, 'Percent_RC_10', scout.daily_monitoring.Constants.ThreshPercent_RC_10) +
potentialProblems(Percent_RC_11, 'Percent_RC_11', scout.daily_monitoring.Constants.ThreshPercent_RC_11) +
potentialProblems(Percent_RC_12, 'Percent_RC_12', scout.daily_monitoring.Constants.ThreshPercent_RC_12) +
potentialProblems(Percent_RC_13, 'Percent_RC_13', scout.daily_monitoring.Constants.ThreshPercent_RC_13) +
potentialProblems(Percent_RC_14, 'Percent_RC_14', scout.daily_monitoring.Constants.ThreshPercent_RC_14) +
potentialProblems(Percent_RC_15, 'Percent_RC_15', scout.daily_monitoring.Constants.ThreshPercent_RC_15) +
potentialProblems(Percent_RC_16, 'Percent_RC_16', scout.daily_monitoring.Constants.ThreshPercent_RC_16) +
potentialProblems(Percent_RC_17, 'Percent_RC_17', scout.daily_monitoring.Constants.ThreshPercent_RC_17) +
potentialProblems(Percent_RC_19, 'Percent_RC_19', scout.daily_monitoring.Constants.ThreshPercent_RC_19) +
potentialProblems(Percent_RC_20, 'Percent_RC_20', scout.daily_monitoring.Constants.ThreshPercent_RC_20) +
potentialProblems(Percent_RC_21, 'Percent_RC_21', scout.daily_monitoring.Constants.ThreshPercent_RC_21) +
potentialProblems(Percent_RC_22, 'Percent_RC_22', scout.daily_monitoring.Constants.ThreshPercent_RC_22) +
potentialProblems(Percent_RC_23, 'Percent_RC_23', scout.daily_monitoring.Constants.ThreshPercent_RC_23) +
potentialProblems(Percent_RC_24, 'Percent_RC_24', scout.daily_monitoring.Constants.ThreshPercent_RC_24) +
potentialProblems(Percent_RC_25, 'Percent_RC_25', scout.daily_monitoring.Constants.ThreshPercent_RC_25) +
potentialProblems(Percent_RC_26, 'Percent_RC_26', scout.daily_monitoring.Constants.ThreshPercent_RC_26) +
potentialProblems(Percent_RC_27, 'Percent_RC_27', scout.daily_monitoring.Constants.ThreshPercent_RC_27) +
potentialProblems(Percent_RC_28, 'Percent_RC_28', scout.daily_monitoring.Constants.ThreshPercent_RC_28) +
potentialProblems(Percent_RC_29, 'Percent_RC_29', scout.daily_monitoring.Constants.ThreshPercent_RC_29) +
potentialProblems(Percent_RC_30, 'Percent_RC_30', scout.daily_monitoring.Constants.ThreshPercent_RC_30) +
potentialProblems(Percent_RC_31, 'Percent_RC_31', scout.daily_monitoring.Constants.ThreshPercent_RC_31) +
potentialProblems(Percent_RC_32, 'Percent_RC_32', scout.daily_monitoring.Constants.ThreshPercent_RC_32) +
potentialProblems(Percent_RC_33, 'Percent_RC_33', scout.daily_monitoring.Constants.ThreshPercent_RC_33) +
potentialProblems(Percent_RC_34, 'Percent_RC_34', scout.daily_monitoring.Constants.ThreshPercent_RC_34) +
potentialProblems(Percent_RC_35, 'Percent_RC_35', scout.daily_monitoring.Constants.ThreshPercent_RC_35) +
potentialProblems(Percent_RC_36, 'Percent_RC_36', scout.daily_monitoring.Constants.ThreshPercent_RC_36) +
potentialProblems(Percent_RC_37, 'Percent_RC_37', scout.daily_monitoring.Constants.ThreshPercent_RC_37) +
potentialProblems(Percent_RC_38, 'Percent_RC_38', scout.daily_monitoring.Constants.ThreshPercent_RC_38) +
potentialProblems(Percent_RC_39, 'Percent_RC_39', scout.daily_monitoring.Constants.ThreshPercent_RC_39) +
potentialProblems(Percent_RC_40, 'Percent_RC_40', scout.daily_monitoring.Constants.ThreshPercent_RC_40) +
potentialProblems(Percent_RC_41, 'Percent_RC_41', scout.daily_monitoring.Constants.ThreshPercent_RC_41) +
potentialProblems(Percent_RC_42, 'Percent_RC_42', scout.daily_monitoring.Constants.ThreshPercent_RC_42) +
potentialProblems(Percent_RC_43, 'Percent_RC_43', scout.daily_monitoring.Constants.ThreshPercent_RC_43) +
potentialProblems(Percent_RC_44, 'Percent_RC_44', scout.daily_monitoring.Constants.ThreshPercent_RC_44) +
potentialProblems(Percent_RC_45, 'Percent_RC_45', scout.daily_monitoring.Constants.ThreshPercent_RC_45) +
potentialProblems(Percent_RC_46, 'Percent_RC_46', scout.daily_monitoring.Constants.ThreshPercent_RC_46) +
potentialProblems(Percent_RC_47, 'Percent_RC_47', scout.daily_monitoring.Constants.ThreshPercent_RC_47) +
potentialProblems(Percent_RC_48, 'Percent_RC_48', scout.daily_monitoring.Constants.ThreshPercent_RC_48) +
potentialProblems(Percent_RC_49, 'Percent_RC_49', scout.daily_monitoring.Constants.ThreshPercent_RC_49) +
potentialProblems(Percent_RC_50, 'Percent_RC_50', scout.daily_monitoring.Constants.ThreshPercent_RC_50) +
potentialProblems(Percent_RC_51, 'Percent_RC_51', scout.daily_monitoring.Constants.ThreshPercent_RC_51) +
potentialProblems(Percent_RC_52, 'Percent_RC_52', scout.daily_monitoring.Constants.ThreshPercent_RC_52) +
potentialProblems(Percent_RC_53, 'Percent_RC_53', scout.daily_monitoring.Constants.ThreshPercent_RC_53) +
potentialProblems(Percent_RC_54, 'Percent_RC_54', scout.daily_monitoring.Constants.ThreshPercent_RC_54) +
potentialProblems(Percent_RC_55, 'Percent_RC_55', scout.daily_monitoring.Constants.ThreshPercent_RC_55) +
potentialProblems(Percent_RC_56, 'Percent_RC_56', scout.daily_monitoring.Constants.ThreshPercent_RC_56) +
potentialProblems(Percent_RC_57, 'Percent_RC_57', scout.daily_monitoring.Constants.ThreshPercent_RC_57) +
potentialProblems(Percent_RC_58, 'Percent_RC_58', scout.daily_monitoring.Constants.ThreshPercent_RC_58) +
potentialProblems(Percent_RC_59, 'Percent_RC_59', scout.daily_monitoring.Constants.ThreshPercent_RC_59) +
potentialProblems(Percent_RC_5Q, 'Percent_RC_5Q', scout.daily_monitoring.Constants.ThreshPercent_RC_5Q) +
potentialProblems(Percent_RC_60, 'Percent_RC_60', scout.daily_monitoring.Constants.ThreshPercent_RC_60) +
potentialProblems(Percent_RC_61, 'Percent_RC_61', scout.daily_monitoring.Constants.ThreshPercent_RC_61) +
potentialProblems(Percent_RC_62, 'Percent_RC_62', scout.daily_monitoring.Constants.ThreshPercent_RC_62) +
potentialProblems(Percent_RC_63, 'Percent_RC_63', scout.daily_monitoring.Constants.ThreshPercent_RC_63) +
potentialProblems(Percent_RC_64, 'Percent_RC_64', scout.daily_monitoring.Constants.ThreshPercent_RC_64) +
potentialProblems(Percent_RC_65, 'Percent_RC_65', scout.daily_monitoring.Constants.ThreshPercent_RC_65) +
potentialProblems(Percent_RC_66, 'Percent_RC_66', scout.daily_monitoring.Constants.ThreshPercent_RC_66) +
potentialProblems(Percent_RC_67, 'Percent_RC_67', scout.daily_monitoring.Constants.ThreshPercent_RC_67) +
potentialProblems(Percent_RC_68, 'Percent_RC_68', scout.daily_monitoring.Constants.ThreshPercent_RC_68) +
potentialProblems(Percent_RC_69, 'Percent_RC_69', scout.daily_monitoring.Constants.ThreshPercent_RC_69) +
potentialProblems(Percent_RC_70, 'Percent_RC_70', scout.daily_monitoring.Constants.ThreshPercent_RC_70) +
potentialProblems(Percent_RC_71, 'Percent_RC_71', scout.daily_monitoring.Constants.ThreshPercent_RC_71) +
potentialProblems(Percent_RC_72, 'Percent_RC_72', scout.daily_monitoring.Constants.ThreshPercent_RC_72) +
potentialProblems(Percent_RC_73, 'Percent_RC_73', scout.daily_monitoring.Constants.ThreshPercent_RC_73) +
potentialProblems(Percent_RC_74, 'Percent_RC_74', scout.daily_monitoring.Constants.ThreshPercent_RC_74) +
potentialProblems(Percent_RC_75, 'Percent_RC_75', scout.daily_monitoring.Constants.ThreshPercent_RC_75) +
potentialProblems(Percent_RC_76, 'Percent_RC_76', scout.daily_monitoring.Constants.ThreshPercent_RC_76) +
potentialProblems(Percent_RC_77, 'Percent_RC_77', scout.daily_monitoring.Constants.ThreshPercent_RC_77) +
potentialProblems(Percent_RC_78, 'Percent_RC_78', scout.daily_monitoring.Constants.ThreshPercent_RC_78) +
potentialProblems(Percent_RC_79, 'Percent_RC_79', scout.daily_monitoring.Constants.ThreshPercent_RC_79) +
potentialProblems(Percent_RC_80, 'Percent_RC_80', scout.daily_monitoring.Constants.ThreshPercent_RC_80) +
potentialProblems(Percent_RC_81, 'Percent_RC_81', scout.daily_monitoring.Constants.ThreshPercent_RC_81) +
potentialProblems(Percent_RC_82, 'Percent_RC_82', scout.daily_monitoring.Constants.ThreshPercent_RC_82) +
potentialProblems(Percent_RC_83, 'Percent_RC_83', scout.daily_monitoring.Constants.ThreshPercent_RC_83) +
potentialProblems(Percent_RC_84, 'Percent_RC_84', scout.daily_monitoring.Constants.ThreshPercent_RC_84) +
potentialProblems(Percent_RC_85, 'Percent_RC_85', scout.daily_monitoring.Constants.ThreshPercent_RC_85) +
potentialProblems(Percent_RC_86, 'Percent_RC_86', scout.daily_monitoring.Constants.ThreshPercent_RC_86) +
potentialProblems(Percent_RC_87, 'Percent_RC_87', scout.daily_monitoring.Constants.ThreshPercent_RC_87) +
potentialProblems(Percent_RC_88, 'Percent_RC_88', scout.daily_monitoring.Constants.ThreshPercent_RC_88) +
potentialProblems(Percent_RC_89, 'Percent_RC_89', scout.daily_monitoring.Constants.ThreshPercent_RC_89) +
potentialProblems(Percent_RC_90, 'Percent_RC_90', scout.daily_monitoring.Constants.ThreshPercent_RC_90) +
potentialProblems(Percent_RC_91, 'Percent_RC_91', scout.daily_monitoring.Constants.ThreshPercent_RC_91) +
potentialProblems(Percent_RC_92, 'Percent_RC_92', scout.daily_monitoring.Constants.ThreshPercent_RC_92) +
potentialProblems(Percent_RC_93, 'Percent_RC_93', scout.daily_monitoring.Constants.ThreshPercent_RC_93) +
potentialProblems(Percent_RC_94, 'Percent_RC_94', scout.daily_monitoring.Constants.ThreshPercent_RC_94) +
potentialProblems(Percent_RC_95, 'Percent_RC_95', scout.daily_monitoring.Constants.ThreshPercent_RC_95) +
potentialProblems(Percent_RC_96, 'Percent_RC_96', scout.daily_monitoring.Constants.ThreshPercent_RC_96) +
potentialProblems(Percent_RC_97, 'Percent_RC_97', scout.daily_monitoring.Constants.ThreshPercent_RC_97) +
potentialProblems(Percent_RC_98, 'Percent_RC_98', scout.daily_monitoring.Constants.ThreshPercent_RC_98) +
potentialProblems(Percent_RC_99, 'Percent_RC_99', scout.daily_monitoring.Constants.ThreshPercent_RC_99) +
potentialProblems(Percent_RC_9A, 'Percent_RC_9A', scout.daily_monitoring.Constants.ThreshPercent_RC_9A) +
potentialProblems(Percent_RC_9B, 'Percent_RC_9B', scout.daily_monitoring.Constants.ThreshPercent_RC_9B) +
potentialProblems(Percent_RC_9C, 'Percent_RC_9C', scout.daily_monitoring.Constants.ThreshPercent_RC_9C) +
potentialProblems(Percent_RC_9D, 'Percent_RC_9D', scout.daily_monitoring.Constants.ThreshPercent_RC_9D) +
potentialProblems(Percent_RC_9E, 'Percent_RC_9E', scout.daily_monitoring.Constants.ThreshPercent_RC_9E) +
potentialProblems(Percent_RC_9F, 'Percent_RC_9F', scout.daily_monitoring.Constants.ThreshPercent_RC_9F) +
potentialProblems(Percent_RC_9G, 'Percent_RC_9G', scout.daily_monitoring.Constants.ThreshPercent_RC_9G) +
potentialProblems(Percent_RC_9H, 'Percent_RC_9H', scout.daily_monitoring.Constants.ThreshPercent_RC_9H) +
potentialProblems(Percent_RC_9I, 'Percent_RC_9I', scout.daily_monitoring.Constants.ThreshPercent_RC_9I) +
potentialProblems(Percent_RC_9J, 'Percent_RC_9J', scout.daily_monitoring.Constants.ThreshPercent_RC_9J) +
potentialProblems(Percent_RC_9K, 'Percent_RC_9K', scout.daily_monitoring.Constants.ThreshPercent_RC_9K) +
potentialProblems(Percent_RC_9L, 'Percent_RC_9L', scout.daily_monitoring.Constants.ThreshPercent_RC_9L) +
potentialProblems(Percent_RC_9M, 'Percent_RC_9M', scout.daily_monitoring.Constants.ThreshPercent_RC_9M) +
potentialProblems(Percent_RC_9N, 'Percent_RC_9N', scout.daily_monitoring.Constants.ThreshPercent_RC_9N) +
potentialProblems(Percent_RC_9O, 'Percent_RC_9O', scout.daily_monitoring.Constants.ThreshPercent_RC_9O) +
potentialProblems(Percent_RC_9P, 'Percent_RC_9P', scout.daily_monitoring.Constants.ThreshPercent_RC_9P) +
potentialProblems(Percent_RC_9Q, 'Percent_RC_9Q', scout.daily_monitoring.Constants.ThreshPercent_RC_9Q) +
potentialProblems(Percent_RC_9R, 'Percent_RC_9R', scout.daily_monitoring.Constants.ThreshPercent_RC_9R) +
potentialProblems(Percent_RC_9S, 'Percent_RC_9S', scout.daily_monitoring.Constants.ThreshPercent_RC_9S) +
potentialProblems(Percent_RC_9T, 'Percent_RC_9T', scout.daily_monitoring.Constants.ThreshPercent_RC_9T) +
potentialProblems(Percent_RC_9U, 'Percent_RC_9U', scout.daily_monitoring.Constants.ThreshPercent_RC_9U) +
potentialProblems(Percent_RC_9V, 'Percent_RC_9V', scout.daily_monitoring.Constants.ThreshPercent_RC_9V) +
potentialProblems(Percent_RC_9W, 'Percent_RC_9W', scout.daily_monitoring.Constants.ThreshPercent_RC_9W) +
potentialProblems(Percent_RC_9X, 'Percent_RC_9X', scout.daily_monitoring.Constants.ThreshPercent_RC_9X) +
potentialProblems(Percent_RC_A0, 'Percent_RC_A0', scout.daily_monitoring.Constants.ThreshPercent_RC_A0) +
potentialProblems(Percent_RC_A1, 'Percent_RC_A1', scout.daily_monitoring.Constants.ThreshPercent_RC_A1) +
potentialProblems(Percent_RC_A2, 'Percent_RC_A2', scout.daily_monitoring.Constants.ThreshPercent_RC_A2) +
potentialProblems(Percent_RC_A3, 'Percent_RC_A3', scout.daily_monitoring.Constants.ThreshPercent_RC_A3) +
potentialProblems(Percent_RC_A4, 'Percent_RC_A4', scout.daily_monitoring.Constants.ThreshPercent_RC_A4) +
potentialProblems(Percent_RC_A5, 'Percent_RC_A5', scout.daily_monitoring.Constants.ThreshPercent_RC_A5) +
potentialProblems(Percent_RC_A6, 'Percent_RC_A6', scout.daily_monitoring.Constants.ThreshPercent_RC_A6) +
potentialProblems(Percent_RC_A7, 'Percent_RC_A7', scout.daily_monitoring.Constants.ThreshPercent_RC_A7) +
potentialProblems(Percent_RC_A8, 'Percent_RC_A8', scout.daily_monitoring.Constants.ThreshPercent_RC_A8) +
potentialProblems(Percent_RC_A9, 'Percent_RC_A9', scout.daily_monitoring.Constants.ThreshPercent_RC_A9) +
potentialProblems(Percent_RC_B0, 'Percent_RC_B0', scout.daily_monitoring.Constants.ThreshPercent_RC_B0) +
potentialProblems(Percent_RC_BO, 'Percent_RC_BO', scout.daily_monitoring.Constants.ThreshPercent_RC_BO) +
potentialProblems(Percent_RC_CL, 'Percent_RC_CL', scout.daily_monitoring.Constants.ThreshPercent_RC_CL) +
potentialProblems(Percent_RC_CO, 'Percent_RC_CO', scout.daily_monitoring.Constants.ThreshPercent_RC_CO) +
potentialProblems(Percent_RC_CR, 'Percent_RC_CR', scout.daily_monitoring.Constants.ThreshPercent_RC_CR) +
potentialProblems(Percent_RC_CZ, 'Percent_RC_CZ', scout.daily_monitoring.Constants.ThreshPercent_RC_CZ) +
potentialProblems(Percent_RC_DD, 'Percent_RC_DD', scout.daily_monitoring.Constants.ThreshPercent_RC_DD) +
potentialProblems(Percent_RC_DF, 'Percent_RC_DF', scout.daily_monitoring.Constants.ThreshPercent_RC_DF) +
potentialProblems(Percent_RC_DM, 'Percent_RC_DM', scout.daily_monitoring.Constants.ThreshPercent_RC_DM) +
potentialProblems(Percent_RC_DV, 'Percent_RC_DV', scout.daily_monitoring.Constants.ThreshPercent_RC_DV) +
potentialProblems(Percent_RC_EV, 'Percent_RC_EV', scout.daily_monitoring.Constants.ThreshPercent_RC_EV) +
potentialProblems(Percent_RC_FB, 'Percent_RC_FB', scout.daily_monitoring.Constants.ThreshPercent_RC_FB) +
potentialProblems(Percent_RC_FM, 'Percent_RC_FM', scout.daily_monitoring.Constants.ThreshPercent_RC_FM) +
potentialProblems(Percent_RC_FQ, 'Percent_RC_FQ', scout.daily_monitoring.Constants.ThreshPercent_RC_FQ) +
potentialProblems(Percent_RC_FR, 'Percent_RC_FR', scout.daily_monitoring.Constants.ThreshPercent_RC_FR) +
potentialProblems(Percent_RC_FV, 'Percent_RC_FV', scout.daily_monitoring.Constants.ThreshPercent_RC_FV) +
potentialProblems(Percent_RC_IA, 'Percent_RC_IA', scout.daily_monitoring.Constants.ThreshPercent_RC_IA) +
potentialProblems(Percent_RC_IB, 'Percent_RC_IB', scout.daily_monitoring.Constants.ThreshPercent_RC_IB) +
potentialProblems(Percent_RC_IC, 'Percent_RC_IC', scout.daily_monitoring.Constants.ThreshPercent_RC_IC) +
potentialProblems(Percent_RC_ID, 'Percent_RC_ID', scout.daily_monitoring.Constants.ThreshPercent_RC_ID) +
potentialProblems(Percent_RC_IE, 'Percent_RC_IE', scout.daily_monitoring.Constants.ThreshPercent_RC_IE) +
potentialProblems(Percent_RC_IF, 'Percent_RC_IF', scout.daily_monitoring.Constants.ThreshPercent_RC_IF) +
potentialProblems(Percent_RC_IG, 'Percent_RC_IG', scout.daily_monitoring.Constants.ThreshPercent_RC_IG) +
potentialProblems(Percent_RC_IH, 'Percent_RC_IH', scout.daily_monitoring.Constants.ThreshPercent_RC_IH) +
potentialProblems(Percent_RC_II, 'Percent_RC_II', scout.daily_monitoring.Constants.ThreshPercent_RC_II) +
potentialProblems(Percent_RC_IJ, 'Percent_RC_IJ', scout.daily_monitoring.Constants.ThreshPercent_RC_IJ) +
potentialProblems(Percent_RC_IK, 'Percent_RC_IK', scout.daily_monitoring.Constants.ThreshPercent_RC_IK) +
potentialProblems(Percent_RC_IS, 'Percent_RC_IS', scout.daily_monitoring.Constants.ThreshPercent_RC_IS) +
potentialProblems(Percent_RC_IT, 'Percent_RC_IT', scout.daily_monitoring.Constants.ThreshPercent_RC_IT) +
potentialProblems(Percent_RC_MI, 'Percent_RC_MI', scout.daily_monitoring.Constants.ThreshPercent_RC_MI) +
potentialProblems(Percent_RC_MN, 'Percent_RC_MN', scout.daily_monitoring.Constants.ThreshPercent_RC_MN) +
potentialProblems(Percent_RC_MO, 'Percent_RC_MO', scout.daily_monitoring.Constants.ThreshPercent_RC_MO) +
potentialProblems(Percent_RC_MS, 'Percent_RC_MS', scout.daily_monitoring.Constants.ThreshPercent_RC_MS) +
potentialProblems(Percent_RC_PA, 'Percent_RC_PA', scout.daily_monitoring.Constants.ThreshPercent_RC_PA) +
potentialProblems(Percent_RC_PO, 'Percent_RC_PO', scout.daily_monitoring.Constants.ThreshPercent_RC_PO) +
potentialProblems(Percent_RC_PV, 'Percent_RC_PV', scout.daily_monitoring.Constants.ThreshPercent_RC_PV) +
potentialProblems(Percent_RC_RS, 'Percent_RC_RS', scout.daily_monitoring.Constants.ThreshPercent_RC_RS) +
potentialProblems(Percent_RC_SR, 'Percent_RC_SR', scout.daily_monitoring.Constants.ThreshPercent_RC_SR) +
potentialProblems(Percent_RC_U1, 'Percent_RC_U1', scout.daily_monitoring.Constants.ThreshPercent_RC_U1) +
potentialProblems(Percent_RC_U2, 'Percent_RC_U2', scout.daily_monitoring.Constants.ThreshPercent_RC_U2) +
potentialProblems(Percent_RC_WL, 'Percent_RC_WL', scout.daily_monitoring.Constants.ThreshPercent_RC_WL) +
potentialProblems(Percent_RC_ZI, 'Percent_RC_ZI', scout.daily_monitoring.Constants.ThreshPercent_RC_ZI) +
// Generate the table
'\n\nRolling 5 Day Window Stats:\n' +
'=====================\n' +
'\t\t\t\t\t| ' + day1.Date_Of_Report + '\t| ' + 
day2.Date_Of_Report + '\t| ' + 
day3.Date_Of_Report + '\t| ' + 
day4.Date_Of_Report + '\t| ' + 
day5.Date_Of_Report + '\t| ' + 
'1st-' + Oldest[1].Date_Of_Report + '\t| ' +
'1 Month Avg\t| ' +
'% Differ Col 1/Avg\n' +
dashes +
'Total Number of Transactions\t\t|' + genRow(Total_Number_Of_Transactions, TRUE, TRUE) +
'Number of Unique Account IDs\t\t|' + genRow(Number_Of_Unique_Account_IDs_Transacted, TRUE, TRUE) +
'% First Name Populated\t\t|' + genRow(Percent_First_Name_Populated) +
'% Last Name Populated\t\t|' + genRow(Percent_Last_Name_Populated) +
'% Full Name Populated\t\t\t|' + genRow(Percent_Full_Name_Populated) +
'% SSN Populated\t\t\t|' + genRow(Percent_SSN_Populated) +
'% Date of Birth Populated\t\t|' + genRow(Percent_DOB_Populated) +
'% Address Populated\t\t\t|' + genRow(Percent_Address_Populated) +
'% City Populated\t\t\t|' + genRow(Percent_City_Populated) +
'% State Populated\t\t\t|' + genRow(Percent_State_Populated) +
'% Zip Code Populated\t\t\t|' + genRow(Percent_Zip_Populated) +
'% Drivers License Populated\t\t|' + genRow(Percent_DL_Populated) +
'% Home Phone Populated\t\t|' + genRow(Percent_Home_Phone_Populated) +
'% CVI 00\t\t\t\t|' + genRow(Percent_CVI_00) +
'% CVI 10\t\t\t\t|' + genRow(Percent_CVI_10) +
'% CVI 20\t\t\t\t|' + genRow(Percent_CVI_20) +
'% CVI 30\t\t\t\t|' + genRow(Percent_CVI_30) +
'% CVI 40\t\t\t\t|' + genRow(Percent_CVI_40) +
'% CVI 50\t\t\t\t|' + genRow(Percent_CVI_50) +
'% NAP 0\t\t\t\t|' + genRow(Percent_NAP_0) +
'% NAP 1\t\t\t\t|' + genRow(Percent_NAP_1) +
'% NAP 2\t\t\t\t|' + genRow(Percent_NAP_2) +
'% NAP 3\t\t\t\t|' + genRow(Percent_NAP_3) +
'% NAP 4\t\t\t\t|' + genRow(Percent_NAP_4) +
'% NAP 5\t\t\t\t|' + genRow(Percent_NAP_5) +
'% NAP 6\t\t\t\t|' + genRow(Percent_NAP_6) +
'% NAP 7\t\t\t\t|' + genRow(Percent_NAP_7) +
'% NAP 8\t\t\t\t|' + genRow(Percent_NAP_8) +
'% NAP 9\t\t\t\t|' + genRow(Percent_NAP_9) +
'% NAP 10\t\t\t\t|' + genRow(Percent_NAP_10) +
'% NAP 11\t\t\t\t|' + genRow(Percent_NAP_11) +
'% NAP 12\t\t\t\t|' + genRow(Percent_NAP_12) +
'% NAS 0\t\t\t\t|' + genRow(Percent_NAS_0) +
'% NAS 1\t\t\t\t|' + genRow(Percent_NAS_1) +
'% NAS 2\t\t\t\t|' + genRow(Percent_NAS_2) +
'% NAS 3\t\t\t\t|' + genRow(Percent_NAS_3) +
'% NAS 4\t\t\t\t|' + genRow(Percent_NAS_4) +
'% NAS 5\t\t\t\t|' + genRow(Percent_NAS_5) +
'% NAS 6\t\t\t\t|' + genRow(Percent_NAS_6) +
'% NAS 7\t\t\t\t|' + genRow(Percent_NAS_7) +
'% NAS 8\t\t\t\t|' + genRow(Percent_NAS_8) +
'% NAS 9\t\t\t\t|' + genRow(Percent_NAS_9) +
'% NAS 10\t\t\t\t|' + genRow(Percent_NAS_10) +
'% NAS 11\t\t\t\t|' + genRow(Percent_NAS_11) +
'% NAS 12\t\t\t\t|' + genRow(Percent_NAS_12) +
 '% Returned FP Reason Code 02\t\t|' + genRow(Percent_FP_RC_02)  +
 '% Returned FP Reason Code 03\t\t|' + genRow(Percent_FP_RC_03)  +
 '% Returned FP Reason Code 06\t\t|' + genRow(Percent_FP_RC_06)  +
 '% Returned FP Reason Code 07\t\t|' + genRow(Percent_FP_RC_07)  +
 '% Returned FP Reason Code 08\t\t|' + genRow(Percent_FP_RC_08)  +
 '% Returned FP Reason Code 09\t\t|' + genRow(Percent_FP_RC_09)  +
 '% Returned FP Reason Code 10\t\t|' + genRow(Percent_FP_RC_10)  +
 '% Returned FP Reason Code 11\t\t|' + genRow(Percent_FP_RC_11)  +
 '% Returned FP Reason Code 12\t\t|' + genRow(Percent_FP_RC_12)  +
 '% Returned FP Reason Code 14\t\t|' + genRow(Percent_FP_RC_14)  +
 '% Returned FP Reason Code 15\t\t|' + genRow(Percent_FP_RC_15)  +
 '% Returned FP Reason Code 16\t\t|' + genRow(Percent_FP_RC_16)  +
 '% Returned FP Reason Code 34\t\t|' + genRow(Percent_FP_RC_34)  +
 '% Returned FP Reason Code 38\t\t|' + genRow(Percent_FP_RC_38)  +
 '% Returned FP Reason Code 39\t\t|' + genRow(Percent_FP_RC_39)  +
 '% Returned FP Reason Code 40\t\t|' + genRow(Percent_FP_RC_40)  +
 '% Returned FP Reason Code 49\t\t|' + genRow(Percent_FP_RC_49)  +
 '% Returned FP Reason Code 50\t\t|' + genRow(Percent_FP_RC_50)  +
 '% Returned FP Reason Code 51\t\t|' + genRow(Percent_FP_RC_51)  +
 '% Returned FP Reason Code 52\t\t|' + genRow(Percent_FP_RC_52)  +
 '% Returned FP Reason Code 53\t\t|' + genRow(Percent_FP_RC_53)  +
 '% Returned FP Reason Code 55\t\t|' + genRow(Percent_FP_RC_55)  +
 '% Returned FP Reason Code 56\t\t|' + genRow(Percent_FP_RC_56)  +
 '% Returned FP Reason Code 57\t\t|' + genRow(Percent_FP_RC_57)  +
 '% Returned FP Reason Code 64\t\t|' + genRow(Percent_FP_RC_64)  +
 '% Returned FP Reason Code 66\t\t|' + genRow(Percent_FP_RC_66)  +
 '% Returned FP Reason Code 71\t\t|' + genRow(Percent_FP_RC_71)  +
 '% Returned FP Reason Code 72\t\t|' + genRow(Percent_FP_RC_72)  +
 '% Returned FP Reason Code 73\t\t|' + genRow(Percent_FP_RC_73)  +
 '% Returned FP Reason Code 74\t\t|' + genRow(Percent_FP_RC_74)  +
 '% Returned FP Reason Code 75\t\t|' + genRow(Percent_FP_RC_75)  +
 '% Returned FP Reason Code 77\t\t|' + genRow(Percent_FP_RC_77)  +
 '% Returned FP Reason Code 78\t\t|' + genRow(Percent_FP_RC_78)  +
 '% Returned FP Reason Code 79\t\t|' + genRow(Percent_FP_RC_79)  +
 '% Returned FP Reason Code 80\t\t|' + genRow(Percent_FP_RC_80)  +
 '% Returned FP Reason Code 81\t\t|' + genRow(Percent_FP_RC_81)  +
 '% Returned FP Reason Code 82\t\t|' + genRow(Percent_FP_RC_82)  +
 '% Returned FP Reason Code 85\t\t|' + genRow(Percent_FP_RC_85)  +
 '% Returned FP Reason Code 89\t\t|' + genRow(Percent_FP_RC_89)  +
 '% Returned FP Reason Code 90\t\t|' + genRow(Percent_FP_RC_90)  +
 '% Returned FP Reason Code 97\t\t|' + genRow(Percent_FP_RC_97)  +
 '% Returned FP Reason Code 9D\t\t|' + genRow(Percent_FP_RC_9D)  +
 '% Returned FP Reason Code 9K\t\t|' + genRow(Percent_FP_RC_9K)  +
 '% Returned FP Reason Code AR\t\t|' + genRow(Percent_FP_RC_AR)  +
 '% Returned FP Reason Code BO\t\t|' + genRow(Percent_FP_RC_BO)  +
 '% Returned FP Reason Code CB\t\t|' + genRow(Percent_FP_RC_CB)  +
 '% Returned FP Reason Code CC\t\t|' + genRow(Percent_FP_RC_CC)  +
 '% Returned FP Reason Code CR\t\t|' + genRow(Percent_FP_RC_CR)  +
 '% Returned FP Reason Code DR\t\t|' + genRow(Percent_FP_RC_DR)  +
 '% Returned FP Reason Code FQ\t\t|' + genRow(Percent_FP_RC_FQ)  +
 '% Returned FP Reason Code FV\t\t|' + genRow(Percent_FP_RC_FV)  +
 '% Returned FP Reason Code HA\t\t|' + genRow(Percent_FP_RC_HA)  +
 '% Returned FP Reason Code IA\t\t|' + genRow(Percent_FP_RC_IA)  +
 '% Returned FP Reason Code IE\t\t|' + genRow(Percent_FP_RC_IE)  +
 '% Returned FP Reason Code IF\t\t|' + genRow(Percent_FP_RC_IF)  +
 '% Returned FP Reason Code IG\t\t|' + genRow(Percent_FP_RC_IG)  +
 '% Returned FP Reason Code II\t\t|' + genRow(Percent_FP_RC_II)  +
 '% Returned FP Reason Code IJ\t\t|' + genRow(Percent_FP_RC_IJ)  +
 '% Returned FP Reason Code IK\t\t|' + genRow(Percent_FP_RC_IK)  +
 '% Returned FP Reason Code IR\t\t|' + genRow(Percent_FP_RC_IR)  +
 '% Returned FP Reason Code MI\t\t|' + genRow(Percent_FP_RC_MI)  +
 '% Returned FP Reason Code MN\t\t|' + genRow(Percent_FP_RC_MN)  +
 '% Returned FP Reason Code MS\t\t|' + genRow(Percent_FP_RC_MS)  +
 '% Returned FP Reason Code PA\t\t|' + genRow(Percent_FP_RC_PA)  +
 '% Returned FP Reason Code PH\t\t|' + genRow(Percent_FP_RC_PH)  +
 '% Returned FP Reason Code PN\t\t|' + genRow(Percent_FP_RC_PN)  +
 '% Returned FP Reason Code PO\t\t|' + genRow(Percent_FP_RC_PO)  +
 '% Returned FP Reason Code QA\t\t|' + genRow(Percent_FP_RC_QA)  +
 '% Returned FP Reason Code QB\t\t|' + genRow(Percent_FP_RC_QB)  +
 '% Returned FP Reason Code QC\t\t|' + genRow(Percent_FP_RC_QC)  +
 '% Returned FP Reason Code QD\t\t|' + genRow(Percent_FP_RC_QD)  +
 '% Returned FP Reason Code QE\t\t|' + genRow(Percent_FP_RC_QE)  +
 '% Returned FP Reason Code QF\t\t|' + genRow(Percent_FP_RC_QF)  +
 '% Returned FP Reason Code QG\t\t|' + genRow(Percent_FP_RC_QG)  +
 '% Returned FP Reason Code QH\t\t|' + genRow(Percent_FP_RC_QH)  +
 '% Returned FP Reason Code QI\t\t|' + genRow(Percent_FP_RC_QI)  +
 '% Returned FP Reason Code QJ\t\t|' + genRow(Percent_FP_RC_QJ)  +
 '% Returned FP Reason Code QK\t\t|' + genRow(Percent_FP_RC_QK)  +
 '% Returned FP Reason Code QL\t\t|' + genRow(Percent_FP_RC_QL)  +
 '% Returned FP Reason Code QM\t\t|' + genRow(Percent_FP_RC_QM)  +
 '% Returned FP Reason Code RC\t\t|' + genRow(Percent_FP_RC_RC)  +
 '% Returned FP Reason Code RF\t\t|' + genRow(Percent_FP_RC_RF)  +
 '% Returned FP Reason Code S1\t\t|' + genRow(Percent_FP_RC_S1)  +
 '% Returned FP Reason Code S2\t\t|' + genRow(Percent_FP_RC_S2)  +
 '% Returned FP Reason Code S3\t\t|' + genRow(Percent_FP_RC_S3)  +
 '% Returned FP Reason Code S4\t\t|' + genRow(Percent_FP_RC_S4)  +
 '% Returned FP Reason Code S5\t\t|' + genRow(Percent_FP_RC_S5)  +
 '% Returned FP Reason Code SA\t\t|' + genRow(Percent_FP_RC_SA)  +
 '% Returned FP Reason Code SC\t\t|' + genRow(Percent_FP_RC_SC)  +
 '% Returned FP Reason Code SN\t\t|' + genRow(Percent_FP_RC_SN)  +
 '% Returned FP Reason Code SR\t\t|' + genRow(Percent_FP_RC_SR)  +
 '% Returned FP Reason Code VE\t\t|' + genRow(Percent_FP_RC_VE)  +
 '% Returned FP Reason Code VL\t\t|' + genRow(Percent_FP_RC_VL)  +
 '% Returned FP Reason Code VR\t\t|' + genRow(Percent_FP_RC_VR)  +
 '% Returned FP Reason Code VV\t\t|' + genRow(Percent_FP_RC_VV)  +
 '% Returned FP Reason Code VX\t\t|' + genRow(Percent_FP_RC_VX)  +
'% Returned Reason Code 01\t\t|' + genRow(Percent_RC_01) +
'% Returned Reason Code 02\t\t|' + genRow(Percent_RC_02) +
'% Returned Reason Code 03\t\t|' + genRow(Percent_RC_03) +
'% Returned Reason Code 04\t\t|' + genRow(Percent_RC_04) +
'% Returned Reason Code 05\t\t|' + genRow(Percent_RC_05) +
'% Returned Reason Code 06\t\t|' + genRow(Percent_RC_06) +
'% Returned Reason Code 07\t\t|' + genRow(Percent_RC_07) +
'% Returned Reason Code 08\t\t|' + genRow(Percent_RC_08) +
'% Returned Reason Code 09\t\t|' + genRow(Percent_RC_09) +
'% Returned Reason Code 10\t\t|' + genRow(Percent_RC_10) +
'% Returned Reason Code 11\t\t|' + genRow(Percent_RC_11) +
'% Returned Reason Code 12\t\t|' + genRow(Percent_RC_12) +
'% Returned Reason Code 13\t\t|' + genRow(Percent_RC_13) +
'% Returned Reason Code 14\t\t|' + genRow(Percent_RC_14) +
'% Returned Reason Code 15\t\t|' + genRow(Percent_RC_15) +
'% Returned Reason Code 16\t\t|' + genRow(Percent_RC_16) +
'% Returned Reason Code 17\t\t|' + genRow(Percent_RC_17) +
'% Returned Reason Code 19\t\t|' + genRow(Percent_RC_19) +
'% Returned Reason Code 20\t\t|' + genRow(Percent_RC_20) +
'% Returned Reason Code 21\t\t|' + genRow(Percent_RC_21) +
'% Returned Reason Code 22\t\t|' + genRow(Percent_RC_22) +
'% Returned Reason Code 23\t\t|' + genRow(Percent_RC_23) +
'% Returned Reason Code 24\t\t|' + genRow(Percent_RC_24) +
'% Returned Reason Code 25\t\t|' + genRow(Percent_RC_25) +
'% Returned Reason Code 26\t\t|' + genRow(Percent_RC_26) +
'% Returned Reason Code 27\t\t|' + genRow(Percent_RC_27) +
'% Returned Reason Code 28\t\t|' + genRow(Percent_RC_28) +
'% Returned Reason Code 29\t\t|' + genRow(Percent_RC_29) +
'% Returned Reason Code 30\t\t|' + genRow(Percent_RC_30) +
'% Returned Reason Code 31\t\t|' + genRow(Percent_RC_31) +
'% Returned Reason Code 32\t\t|' + genRow(Percent_RC_32) +
'% Returned Reason Code 33\t\t|' + genRow(Percent_RC_33) +
'% Returned Reason Code 34\t\t|' + genRow(Percent_RC_34) +
'% Returned Reason Code 35\t\t|' + genRow(Percent_RC_35) +
'% Returned Reason Code 36\t\t|' + genRow(Percent_RC_36) +
'% Returned Reason Code 37\t\t|' + genRow(Percent_RC_37) +
'% Returned Reason Code 38\t\t|' + genRow(Percent_RC_38) +
'% Returned Reason Code 39\t\t|' + genRow(Percent_RC_39) +
'% Returned Reason Code 40\t\t|' + genRow(Percent_RC_40) +
'% Returned Reason Code 41\t\t|' + genRow(Percent_RC_41) +
'% Returned Reason Code 42\t\t|' + genRow(Percent_RC_42) +
'% Returned Reason Code 43\t\t|' + genRow(Percent_RC_43) +
'% Returned Reason Code 44\t\t|' + genRow(Percent_RC_44) +
'% Returned Reason Code 45\t\t|' + genRow(Percent_RC_45) +
'% Returned Reason Code 46\t\t|' + genRow(Percent_RC_46) +
'% Returned Reason Code 47\t\t|' + genRow(Percent_RC_47) +
'% Returned Reason Code 48\t\t|' + genRow(Percent_RC_48) +
'% Returned Reason Code 49\t\t|' + genRow(Percent_RC_49) +
'% Returned Reason Code 50\t\t|' + genRow(Percent_RC_50) +
'% Returned Reason Code 51\t\t|' + genRow(Percent_RC_51) +
'% Returned Reason Code 52\t\t|' + genRow(Percent_RC_52) +
'% Returned Reason Code 53\t\t|' + genRow(Percent_RC_53) +
'% Returned Reason Code 54\t\t|' + genRow(Percent_RC_54) +
'% Returned Reason Code 55\t\t|' + genRow(Percent_RC_55) +
'% Returned Reason Code 56\t\t|' + genRow(Percent_RC_56) +
'% Returned Reason Code 57\t\t|' + genRow(Percent_RC_57) +
'% Returned Reason Code 58\t\t|' + genRow(Percent_RC_58) +
'% Returned Reason Code 59\t\t|' + genRow(Percent_RC_59) +
'% Returned Reason Code 5Q\t\t|' + genRow(Percent_RC_5Q) +
'% Returned Reason Code 60\t\t|' + genRow(Percent_RC_60) +
'% Returned Reason Code 61\t\t|' + genRow(Percent_RC_61) +
'% Returned Reason Code 62\t\t|' + genRow(Percent_RC_62) +
'% Returned Reason Code 63\t\t|' + genRow(Percent_RC_63) +
'% Returned Reason Code 64\t\t|' + genRow(Percent_RC_64) +
'% Returned Reason Code 65\t\t|' + genRow(Percent_RC_65) +
'% Returned Reason Code 66\t\t|' + genRow(Percent_RC_66) +
'% Returned Reason Code 67\t\t|' + genRow(Percent_RC_67) +
'% Returned Reason Code 68\t\t|' + genRow(Percent_RC_68) +
'% Returned Reason Code 69\t\t|' + genRow(Percent_RC_69) +
'% Returned Reason Code 70\t\t|' + genRow(Percent_RC_70) +
'% Returned Reason Code 71\t\t|' + genRow(Percent_RC_71) +
'% Returned Reason Code 72\t\t|' + genRow(Percent_RC_72) +
'% Returned Reason Code 73\t\t|' + genRow(Percent_RC_73) +
'% Returned Reason Code 74\t\t|' + genRow(Percent_RC_74) +
'% Returned Reason Code 75\t\t|' + genRow(Percent_RC_75) +
'% Returned Reason Code 76\t\t|' + genRow(Percent_RC_76) +
'% Returned Reason Code 77\t\t|' + genRow(Percent_RC_77) +
'% Returned Reason Code 78\t\t|' + genRow(Percent_RC_78) +
'% Returned Reason Code 79\t\t|' + genRow(Percent_RC_79) +
'% Returned Reason Code 80\t\t|' + genRow(Percent_RC_80) +
'% Returned Reason Code 81\t\t|' + genRow(Percent_RC_81) +
'% Returned Reason Code 82\t\t|' + genRow(Percent_RC_82) +
'% Returned Reason Code 83\t\t|' + genRow(Percent_RC_83) +
'% Returned Reason Code 84\t\t|' + genRow(Percent_RC_84) +
'% Returned Reason Code 85\t\t|' + genRow(Percent_RC_85) +
'% Returned Reason Code 86\t\t|' + genRow(Percent_RC_86) +
'% Returned Reason Code 87\t\t|' + genRow(Percent_RC_87) +
'% Returned Reason Code 88\t\t|' + genRow(Percent_RC_88) +
'% Returned Reason Code 89\t\t|' + genRow(Percent_RC_89) +
'% Returned Reason Code 90\t\t|' + genRow(Percent_RC_90) +
'% Returned Reason Code 91\t\t|' + genRow(Percent_RC_91) +
'% Returned Reason Code 92\t\t|' + genRow(Percent_RC_92) +
'% Returned Reason Code 93\t\t|' + genRow(Percent_RC_93) +
'% Returned Reason Code 94\t\t|' + genRow(Percent_RC_94) +
'% Returned Reason Code 95\t\t|' + genRow(Percent_RC_95) +
'% Returned Reason Code 96\t\t|' + genRow(Percent_RC_96) +
'% Returned Reason Code 97\t\t|' + genRow(Percent_RC_97) +
'% Returned Reason Code 98\t\t|' + genRow(Percent_RC_98) +
'% Returned Reason Code 99\t\t|' + genRow(Percent_RC_99) +
'% Returned Reason Code 9A\t\t|' + genRow(Percent_RC_9A) +
'% Returned Reason Code 9B\t\t|' + genRow(Percent_RC_9B) +
'% Returned Reason Code 9C\t\t|' + genRow(Percent_RC_9C) +
'% Returned Reason Code 9D\t\t|' + genRow(Percent_RC_9D) +
'% Returned Reason Code 9E\t\t|' + genRow(Percent_RC_9E) +
'% Returned Reason Code 9F\t\t|' + genRow(Percent_RC_9F) +
'% Returned Reason Code 9G\t\t|' + genRow(Percent_RC_9G) +
'% Returned Reason Code 9H\t\t|' + genRow(Percent_RC_9H) +
'% Returned Reason Code 9I\t\t|' + genRow(Percent_RC_9I) +
'% Returned Reason Code 9J\t\t|' + genRow(Percent_RC_9J) +
'% Returned Reason Code 9K\t\t|' + genRow(Percent_RC_9K) +
'% Returned Reason Code 9L\t\t|' + genRow(Percent_RC_9L) +
'% Returned Reason Code 9M\t\t|' + genRow(Percent_RC_9M) +
'% Returned Reason Code 9N\t\t|' + genRow(Percent_RC_9N) +
'% Returned Reason Code 9O\t\t|' + genRow(Percent_RC_9O) +
'% Returned Reason Code 9P\t\t|' + genRow(Percent_RC_9P) +
'% Returned Reason Code 9Q\t\t|' + genRow(Percent_RC_9Q) +
'% Returned Reason Code 9R\t\t|' + genRow(Percent_RC_9R) +
'% Returned Reason Code 9S\t\t|' + genRow(Percent_RC_9S) +
'% Returned Reason Code 9T\t\t|' + genRow(Percent_RC_9T) +
'% Returned Reason Code 9U\t\t|' + genRow(Percent_RC_9U) +
'% Returned Reason Code 9V\t\t|' + genRow(Percent_RC_9V) +
'% Returned Reason Code 9W\t\t|' + genRow(Percent_RC_9W) +
'% Returned Reason Code 9X\t\t|' + genRow(Percent_RC_9X) +
'% Returned Reason Code A0\t\t|' + genRow(Percent_RC_A0) +
'% Returned Reason Code A1\t\t|' + genRow(Percent_RC_A1) +
'% Returned Reason Code A2\t\t|' + genRow(Percent_RC_A2) +
'% Returned Reason Code A3\t\t|' + genRow(Percent_RC_A3) +
'% Returned Reason Code A4\t\t|' + genRow(Percent_RC_A4) +
'% Returned Reason Code A5\t\t|' + genRow(Percent_RC_A5) +
'% Returned Reason Code A6\t\t|' + genRow(Percent_RC_A6) +
'% Returned Reason Code A7\t\t|' + genRow(Percent_RC_A7) +
'% Returned Reason Code A8\t\t|' + genRow(Percent_RC_A8) +
'% Returned Reason Code A9\t\t|' + genRow(Percent_RC_A9) +
'% Returned Reason Code B0\t\t|' + genRow(Percent_RC_B0) +
'% Returned Reason Code BO\t\t|' + genRow(Percent_RC_BO) +
'% Returned Reason Code CL\t\t|' + genRow(Percent_RC_CL) +
'% Returned Reason Code CO\t\t|' + genRow(Percent_RC_CO) +
'% Returned Reason Code CR\t\t|' + genRow(Percent_RC_CR) +
'% Returned Reason Code CZ\t\t|' + genRow(Percent_RC_CZ) +
'% Returned Reason Code DD\t\t|' + genRow(Percent_RC_DD) +
'% Returned Reason Code DF\t\t|' + genRow(Percent_RC_DF) +
'% Returned Reason Code DM\t\t|' + genRow(Percent_RC_DM) +
'% Returned Reason Code DV\t\t|' + genRow(Percent_RC_DV) +
'% Returned Reason Code EV\t\t|' + genRow(Percent_RC_EV) +
'% Returned Reason Code FB\t\t|' + genRow(Percent_RC_FB) +
'% Returned Reason Code FM\t\t|' + genRow(Percent_RC_FM) +
'% Returned Reason Code FQ\t\t|' + genRow(Percent_RC_FQ) +
'% Returned Reason Code FR\t\t|' + genRow(Percent_RC_FR) +
'% Returned Reason Code FV\t\t|' + genRow(Percent_RC_FV) +
'% Returned Reason Code IA\t\t|' + genRow(Percent_RC_IA) +
'% Returned Reason Code IB\t\t|' + genRow(Percent_RC_IB) +
'% Returned Reason Code IC\t\t|' + genRow(Percent_RC_IC) +
'% Returned Reason Code ID\t\t|' + genRow(Percent_RC_ID) +
'% Returned Reason Code IE\t\t|' + genRow(Percent_RC_IE) +
'% Returned Reason Code IF\t\t|' + genRow(Percent_RC_IF) +
'% Returned Reason Code IG\t\t|' + genRow(Percent_RC_IG) +
'% Returned Reason Code IH\t\t|' + genRow(Percent_RC_IH) +
'% Returned Reason Code II\t\t|' + genRow(Percent_RC_II) +
'% Returned Reason Code IJ\t\t|' + genRow(Percent_RC_IJ) +
'% Returned Reason Code IK\t\t|' + genRow(Percent_RC_IK) +
'% Returned Reason Code IS\t\t|' + genRow(Percent_RC_IS) +
'% Returned Reason Code IT\t\t|' + genRow(Percent_RC_IT) +
'% Returned Reason Code MI\t\t|' + genRow(Percent_RC_MI) +
'% Returned Reason Code MN\t\t|' + genRow(Percent_RC_MN) +
'% Returned Reason Code MO\t\t|' + genRow(Percent_RC_MO) +
'% Returned Reason Code MS\t\t|' + genRow(Percent_RC_MS) +
'% Returned Reason Code PA\t\t|' + genRow(Percent_RC_PA) +
'% Returned Reason Code PO\t\t|' + genRow(Percent_RC_PO) +
'% Returned Reason Code PV\t\t|' + genRow(Percent_RC_PV) +
'% Returned Reason Code RS\t\t|' + genRow(Percent_RC_RS) +
'% Returned Reason Code SR\t\t|' + genRow(Percent_RC_SR) +
'% Returned Reason Code U1\t\t|' + genRow(Percent_RC_U1) +
'% Returned Reason Code U2\t\t|' + genRow(Percent_RC_U2) +
'% Returned Reason Code WL\t\t|' + genRow(Percent_RC_WL) +
'% Returned Reason Code ZI\t\t|' + genRow(Percent_RC_ZI) +
'% Returned Reason Code CA\t\t|' + genRow(Percent_RC_CA) +
'% Returned Reason Code DI\t\t|' + genRow(Percent_RC_DI) +
'% Returned Reason Code NB\t\t|' + genRow(Percent_RC_NB) +
'% Returned Reason Code NF\t\t|' + genRow(Percent_RC_NF) +
'% Returned Reason Code SD\t\t|' + genRow(Percent_RC_SD) +
'% Returned Reason Code VA\t\t|' + genRow(Percent_RC_VA) +
'\n\n' +
'Workunit ' + STD.Str.ToUpperCase(STD.system.Job.wuid()) + '\n  http://10.173.84.202:8010/?inner=../WsWorkunits/WUInfo?Wuid=' + STD.Str.ToUpperCase(STD.system.Job.wuid());

OUTPUT(emailBody, NAMED('E_Mail_Body_IID'));


/* ***********************************************************************************************
 *************************************************************************************************
 *                                         SEND THE EMAIL                                        *
 *************************************************************************************************
 *********************************************************************************************** */

subject := 'Instant ID Daily Monitor';

STD.System.Email.SendEmail(scout.daily_monitoring.Constants.emailv2InstantIDReportsTo, subject,
																		emailBody,
																		GETENV('SMTPserver'),
																		(UNSIGNED4)GETENV('SMTPport', '25'),
																		'ThorReport@lexisnexis.com');		