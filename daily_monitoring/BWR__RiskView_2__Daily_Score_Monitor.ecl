#workunit('name', 'RiskView_2_Daily_Score_Monitor');
#OPTION('defaultSkewError', 1);

IMPORT scout, STD;

// Pull logs for the past year to do our rolling Average on
EndDate := scout.common.util.dateutils.today;
BeginDateTemp := scout.common.util.dateutils.date_math(EndDate, -60);
BeginDate := IF(BeginDateTemp >= 20130512, BeginDateTemp, 20130512); // Tracking didn't fully start until this date, eliminate the "test" days before this date.
EndDate_string := (string)EndDate;
BeginDate_string := (string)BeginDate;
Product := 'RiskView2';
eyeball := 100;

AccountIDs := ['']; // Set to a blank string dataset [''] to pull all records except for test transaction login ids
// esp_method := '';

/* ***********************************************************************************************
 *************************************************************************************************
 *             GATHER AND PARSE SCORE AND ATTRIBUTE OUTCOME TRACKING LOGS                        *
 *************************************************************************************************
 *********************************************************************************************** */

BaseScoutFile := scout.logs.keys.key_scorelogs_scout_transactionID.superFileData();
BaseLogFile := scout.logs.keys.key_scorelogs_XMLTransactionID.superFileData();

Pulled_ScoutFile := distribute(pull(BaseScoutFile));

ScoutFile_Raw := IF(AccountIDs[1] != '', Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['RISKVIEW2'] AND datetime[1..8] BETWEEN BeginDate_string AND EndDate_string AND (string)company_id IN AccountIDs AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs),
									 Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['RISKVIEW2'] AND datetime[1..8] BETWEEN BeginDate_string AND EndDate_string AND STD.Str.ToLowerCase(TRIM(login_id)) NOT IN scout.ad_hoc_reporting.constants.IgnoredLogins AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs));

count(ScoutFile_Raw);

//Get only the XML transactions that match the scout key filter
// Slim_LogFile := JOIN(ScoutFile_Raw(Transaction_ID in Transid), BaseLogFile(Transaction_ID in Transid), left.Transaction_ID = right.Transaction_ID, TRANSFORM(scout.logs.layout.base_transaction_online_key, self := right));
Slim_LogFile := JOIN(ScoutFile_Raw, BaseLogFile, left.Transaction_ID = right.Transaction_ID, TRANSFORM(scout.logs.layout.base_transaction_online_key, self := right));

OUTPUT(CHOOSEN(Slim_LogFile, eyeball), NAMED('Sample_Slim_LogFile_RV2'));


//Process the xml and clean the tags
Clean_xml_recs := scout.ad_hoc_reporting.common.ProcessRawXML(ScoutFile_Raw, Slim_LogFile, Product);
OUTPUT(CHOOSEN(Clean_xml_recs, eyeball), NAMED('Sample_Clean_xml_recs_RV2'));
Output(count(Clean_xml_recs), NAMED('Clean_xml_recs_count_RV2'));
//Filter out bad xml recs so the job doesn't crash
Good_Logs := Clean_xml_recs(validinputxml and validoutputxml);
OUTPUT(CHOOSEN(Good_Logs, eyeball), NAMED('Sample_Good_Logs_RV2'));
OUTPUT(count(Good_Logs), NAMED('Good_Logs_count_RV2'));

scout.ad_hoc_reporting.layouts.Parsed_RiskView2_Tracking_Layout parseInput () := TRANSFORM
	SELF.TransactionID	:= TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
	SELF.EndUserCompanyName		:= TRIM(XMLTEXT('User/EndUser/CompanyName'));
	SELF.FirstName			:= TRIM(XMLTEXT('SearchBy/Name/First'));
	SELF.LastName				:= TRIM(XMLTEXT('SearchBy/Name/Last'));
	SELF.SSN						:= scout.ad_hoc_reporting.Common.ParseSSN(XMLTEXT('SearchBy/SSN'));
	SELF.DOB						:= TRIM(XMLTEXT('SearchBy/DOB')) + scout.ad_hoc_reporting.Common.ParseDate(XMLTEXT('SearchBy/DOB/Year'), XMLTEXT('SearchBy/DOB/Month'), XMLTEXT('SearchBy/DOB/Day'));
	SELF.Address				:= scout.ad_hoc_reporting.Common.ParseAddress(XMLTEXT('SearchBy/Address/StreetAddress1'), XMLTEXT('SearchBy/Address/StreetAddress2'), XMLTEXT('SearchBy/Address/StreetNumber'), XMLTEXT('SearchBy/Address/StreetPreDirection'), XMLTEXT('SearchBy/Address/StreetName'),
															XMLTEXT('SearchBy/Address/StreetSuffix'), XMLTEXT('SearchBy/Address/StreetPostDirection'), XMLTEXT('SearchBy/Address/UnitDesignation'), XMLTEXT('SearchBy/Address/UnitNumber'));
	SELF.City						:= TRIM(XMLTEXT('SearchBy/Address/City'));
	SELF.State					:= TRIM(XMLTEXT('SearchBy/Address/State'));
	SELF.Zip						:= scout.ad_hoc_reporting.Common.ParseZIP(XMLTEXT('SearchBy/Address/Zip5'));
	SELF.DL							:= TRIM(XMLTEXT('SearchBy/DriverLicenseNumber'));
	SELF.HomePhone			:= scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/HomePhone'));
	SELF.WorkPhone			:= scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/WorkPhone'));
	
	SELF := [];
END;
// parsedInput := PARSE(Good_Logs, inputxml, parseInput(), XML('RiskView2Request'));
parsedInput := PARSE(Good_Logs, inputxml, parseInput(), XML('RiskView2'));

OUTPUT(CHOOSEN(parsedInput, eyeball), NAMED('Sample_Parsed_Input_RV2'));

Parsed_Layout_Temp := RECORD
	scout.ad_hoc_reporting.Layouts.Parsed_RiskView2_Tracking_Layout;
	
	STRING3 Score1 := '';
	STRING3 Score2 := '';
	STRING3 Score3 := '';
	STRING3 Score4 := '';
	STRING3 Score5 := '';
	STRING3 Score6 := '';
	
	STRING15 Model1 := '';
	STRING15 Model2 := '';
	STRING15 Model3 := '';
	STRING15 Model4 := '';
	STRING15 Model5 := '';
	STRING15 Model6 := '';
	
	STRING10 ScoreType1 := '';
	STRING10 ScoreType2 := '';
	STRING10 ScoreType3 := '';
	STRING10 ScoreType4 := '';
	STRING10 ScoreType5 := '';
	STRING10 ScoreType6 := '';
	
	STRING5 RC1_1		:= '';
	STRING5 RC1_2		:= '';
	STRING5 RC1_3		:= '';
	STRING5 RC1_4		:= '';
	STRING5 RC1_5		:= '';
	STRING5 RC1_6		:= '';
	STRING5 RC2_1		:= '';
	STRING5 RC2_2		:= '';
	STRING5 RC2_3		:= '';
	STRING5 RC2_4		:= '';
	STRING5 RC2_5		:= '';
	STRING5 RC2_6		:= '';
	STRING5 RC3_1		:= '';
	STRING5 RC3_2		:= '';
	STRING5 RC3_3		:= '';
	STRING5 RC3_4		:= '';
	STRING5 RC3_5		:= '';
	STRING5 RC3_6		:= '';
	STRING5 RC4_1		:= '';
	STRING5 RC4_2		:= '';
	STRING5 RC4_3		:= '';
	STRING5 RC4_4		:= '';
	STRING5 RC4_5		:= '';
	STRING5 RC4_6		:= '';
	STRING5 RC5_1		:= '';
	STRING5 RC5_2		:= '';
	STRING5 RC5_3		:= '';
	STRING5 RC5_4		:= '';
	STRING5 RC5_5		:= '';
	STRING5 RC5_6		:= '';
	STRING5 RC6_1		:= '';
	STRING5 RC6_2		:= '';
	STRING5 RC6_3		:= '';
	STRING5 RC6_4		:= '';
	STRING5 RC6_5		:= '';
	STRING5 RC6_6		:= '';
END;

Parsed_Layout_Temp parseOutput () := TRANSFORM
	SELF.TransactionID	:= TRIM(XMLTEXT('Header/TransactionId')); // Forced into the record so I can join it all together
	
	SELF.Score1					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/Value'));
	SELF.Score2					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/Value'));
	SELF.Score3					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/Value'));
	SELF.Score4					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/Value'));
	SELF.Score5					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/Value'));
	SELF.Score6					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/Value'));
	
	SELF.ScoreType1			:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/Type'));
	SELF.ScoreType2			:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/Type'));
	SELF.ScoreType3			:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/Type'));
	SELF.ScoreType4			:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/Type'));
	SELF.ScoreType5			:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/Type'));
	SELF.ScoreType6			:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/Type'));
	
	SELF.Model1					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Name'));
	SELF.Model2					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Name'));
	SELF.Model3					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Name'));
	SELF.Model4					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Name'));
	SELF.Model5					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Name'));
	SELF.Model6					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Name'));
	
	SELF.RC1_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[1]/ReasonCode'));
	SELF.RC1_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[2]/ReasonCode'));
	SELF.RC1_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[3]/ReasonCode'));
	SELF.RC1_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[4]/ReasonCode'));
	SELF.RC1_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[5]/ReasonCode'));
	SELF.RC1_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[6]/ReasonCode'));
	
	SELF.RC2_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[1]/ReasonCode'));
	SELF.RC2_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[2]/ReasonCode'));
	SELF.RC2_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[3]/ReasonCode'));
	SELF.RC2_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[4]/ReasonCode'));
	SELF.RC2_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[5]/ReasonCode'));
	SELF.RC2_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[2]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[6]/ReasonCode'));
	
	SELF.RC3_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[1]/ReasonCode'));
	SELF.RC3_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[2]/ReasonCode'));
	SELF.RC3_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[3]/ReasonCode'));
	SELF.RC3_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[4]/ReasonCode'));
	SELF.RC3_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[5]/ReasonCode'));
	SELF.RC3_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[3]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[6]/ReasonCode'));
	
	SELF.RC4_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[1]/ReasonCode'));
	SELF.RC4_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[2]/ReasonCode'));
	SELF.RC4_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[3]/ReasonCode'));
	SELF.RC4_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[4]/ReasonCode'));
	SELF.RC4_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[5]/ReasonCode'));
	SELF.RC4_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[4]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[6]/ReasonCode'));
	
	SELF.RC5_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[1]/ReasonCode'));
	SELF.RC5_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[2]/ReasonCode'));
	SELF.RC5_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[3]/ReasonCode'));
	SELF.RC5_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[4]/ReasonCode'));
	SELF.RC5_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[5]/ReasonCode'));
	SELF.RC5_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[5]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[6]/ReasonCode'));
	
	SELF.RC6_1					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[1]/ReasonCode'));
	SELF.RC6_2					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[2]/ReasonCode'));
	SELF.RC6_3					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[3]/ReasonCode'));
	SELF.RC6_4					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[4]/ReasonCode'));
	SELF.RC6_5					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[5]/ReasonCode'));
	SELF.RC6_6					:= TRIM(XMLTEXT('Result/Models[1]/Model[6]/Scores[1]/Score[1]/ScoreReasons[1]/ScoreReason[6]/ReasonCode'));
	
	SELF.Alert1					:= TRIM(XMLTEXT('Result/Alerts[1]/Alert[1]/Code'));
	SELF.Alert2					:= TRIM(XMLTEXT('Result/Alerts[1]/Alert[2]/Code'));
	SELF.Alert3					:= TRIM(XMLTEXT('Result/Alerts[1]/Alert[3]/Code'));
	SELF.Alert4					:= TRIM(XMLTEXT('Result/Alerts[1]/Alert[4]/Code'));
	SELF.Alert5					:= TRIM(XMLTEXT('Result/Alerts[1]/Alert[5]/Code'));
	SELF.Alert6					:= TRIM(XMLTEXT('Result/Alerts[1]/Alert[6]/Code'));
	SELF.Alert7					:= TRIM(XMLTEXT('Result/Alerts[1]/Alert[7]/Code'));
	SELF.Alert8					:= TRIM(XMLTEXT('Result/Alerts[1]/Alert[8]/Code'));
	SELF.Alert9					:= TRIM(XMLTEXT('Result/Alerts[1]/Alert[9]/Code'));
	SELF.Alert10				:= TRIM(XMLTEXT('Result/Alerts[1]/Alert[10]/Code'));
	
	SELF := [];
END;
parsedOutputTemp := PARSE(Good_Logs, outputxml, parseOutput(), XML('RiskView2'));

OUTPUT(CHOOSEN(parsedOutputTemp, eyeball), NAMED('Sample_Parsed_Output_RV2'));

scout.ad_hoc_reporting.Layouts.Parsed_RiskView2_Tracking_Layout normScores(Parsed_Layout_Temp le, UNSIGNED1 t) := TRANSFORM
	SELF.Score := CASE(t,
		1 => le.Score1,
		2 => le.Score2,
		3 => le.Score3,
		4 => le.Score4,
		5 => le.Score5,
		6 => le.Score6,
		'');
		
	SELF.ScoreType := CASE(t,
		1 => le.ScoreType1,
		2 => le.ScoreType2,
		3 => le.ScoreType3,
		4 => le.ScoreType4,
		5 => le.ScoreType5,
		6 => le.ScoreType6,
		'');
		
	SELF.Model := CASE(t,
		1 => le.Model1,
		2 => le.Model2,
		3 => le.Model3,
		4 => le.Model4,
		5 => le.Model5,
		6 => le.Model6,
		'');
		
	SELF.RC1 := CASE(t,
		1		=> le.RC1_1,
		2		=> le.RC2_1,
		3		=> le.RC3_1,
		4		=> le.RC4_1,
		5		=> le.RC5_1,
		6		=> le.RC6_1,
		'');

	SELF.RC2 := CASE(t,
		1		=> le.RC1_2,
		2		=> le.RC2_2,
		3		=> le.RC3_2,
		4		=> le.RC4_2,
		5		=> le.RC5_2,
		6		=> le.RC6_2,
		'');
	
	SELF.RC3 := CASE(t,
		1		=> le.RC1_3,
		2		=> le.RC2_3,
		3		=> le.RC3_3,
		4		=> le.RC4_3,
		5		=> le.RC5_3,
		6		=> le.RC6_3,
		'');
		
	SELF.RC4 := CASE(t,
		1		=> le.RC1_4,
		2		=> le.RC2_4,
		3		=> le.RC3_4,
		4		=> le.RC4_4,
		5		=> le.RC5_4,
		6		=> le.RC6_4,
		'');
		
	SELF.RC5 := CASE(t,
		1		=> le.RC1_5,
		2		=> le.RC2_5,
		3		=> le.RC3_5,
		4		=> le.RC4_5,
		5		=> le.RC5_5,
		6		=> le.RC6_5,
		'');
		
	SELF.RC6 := CASE(t,
		1		=> le.RC1_6,
		2		=> le.RC2_6,
		3		=> le.RC3_6,
		4		=> le.RC4_6,
		5		=> le.RC5_6,
		6		=> le.RC6_6,
		'');
	
	SELF := le;
END;
parsedOutput := NORMALIZE(parsedOutputTemp, 6, normScores(LEFT, COUNTER)) ((INTEGER)Score > 0);

OUTPUT(CHOOSEN(parsedOutput, eyeball), NAMED('Sample_Normalized_Output_RV2'));

scout.ad_hoc_reporting.Layouts.Parsed_RiskView2_Tracking_Layout combineParsedRecords(scout.ad_hoc_reporting.Layouts.Parsed_RiskView2_Tracking_Layout le, scout.ad_hoc_reporting.Layouts.Parsed_RiskView2_Tracking_Layout ri) := TRANSFORM
	SELF.Score	:= ri.Score;
	SELF.ScoreType := ri.ScoreType;
	SELF.Model	:= ri.Model;
	SELF.RC1		:= ri.RC1;
	SELF.RC2		:= ri.RC2;
	SELF.RC3		:= ri.RC3;
	SELF.RC4		:= ri.RC4;
	SELF.RC5		:= ri.RC5;
	SELF.RC6		:= ri.RC6;
	
	SELF.Alert1	:= ri.Alert1;
	SELF.Alert2	:= ri.Alert2;
	SELF.Alert3	:= ri.Alert3;
	SELF.Alert4	:= ri.Alert4;
	SELF.Alert5	:= ri.Alert5;
	SELF.Alert6	:= ri.Alert6;
	SELF.Alert7	:= ri.Alert7;
	SELF.Alert8	:= ri.Alert8;
	SELF.Alert9	:= ri.Alert9;
	SELF.Alert10:= ri.Alert10;
	
	SELF := le;
END;

// Join the parsed input/output and then filter out the results where no model was requested or where this was an income estimated model and not a true RiskView model
parsedRecordsTemp := JOIN(parsedInput, parsedOutput, LEFT.TransactionID = RIGHT.TransactionID, combineParsedRecords(LEFT, RIGHT), KEEP(10), ATMOST(scout.daily_monitoring.Constants.max_atmost)) (TRIM(STD.Str.ToUpperCase(model)) NOT IN ['', 'RISKWISE INTERNAL ADMIN']);

parsedRecords := JOIN(parsedRecordsTemp, Good_Logs, LEFT.TransactionID = RIGHT.TransactionID, TRANSFORM(RECORDOF(LEFT), SELF.TransactionDate := RIGHT.TransactionDate; SELF.AccountID := RIGHT.AccountID; SELF.LoginID := RIGHT.LoginID; SELF := LEFT));

OUTPUT(CHOOSEN(parsedRecords, eyeball), NAMED('Sample_Fully_Parsed_Records_RV2'));
OUTPUT(COUNT(parsedRecords), NAMED('Total_Fully_Parsed_Records_RV2'));

finalRecords := SORT(parsedRecords, TransactionDate);
OUTPUT(CHOOSEN(finalRecords, eyeball), NAMED('Sample_Final_Records_RV2'));

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
	DECIMAL6_3	Percent_SSN_Populated		:= (COUNT(GROUP, finalRecords.SSN <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_DOB_Populated		:= (COUNT(GROUP, finalRecords.DOB <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Address_Populated:= (COUNT(GROUP, finalRecords.Address <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_City_Populated	:= (COUNT(GROUP, finalRecords.City <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_State_Populated	:= (COUNT(GROUP, finalRecords.State <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Zip_Populated		:= (COUNT(GROUP, finalRecords.Zip <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_DL_Populated		:= (COUNT(GROUP, finalRecords.DL <> '') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Home_Phone_Populated := (COUNT(GROUP, finalRecords.HomePhone <> '') / COUNT(GROUP)) * 100;
	
	// Score Bucket Statistics
	DECIMAL6_3	Percent_Scored_100			:= (COUNT(GROUP, (INTEGER)finalRecords.Score = 100) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Scored_200			:= (COUNT(GROUP, (INTEGER)finalRecords.Score = 200) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Scored_222			:= (COUNT(GROUP, (INTEGER)finalRecords.Score = 222) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Scored_Between_501_540 := (COUNT(GROUP, (INTEGER)finalRecords.Score BETWEEN 501 AND 540) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Scored_Between_541_580 := (COUNT(GROUP, (INTEGER)finalRecords.Score BETWEEN 541 AND 580) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Scored_Between_581_620 := (COUNT(GROUP, (INTEGER)finalRecords.Score BETWEEN 581 AND 620) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Scored_Between_621_660 := (COUNT(GROUP, (INTEGER)finalRecords.Score BETWEEN 621 AND 660) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Scored_Between_661_700 := (COUNT(GROUP, (INTEGER)finalRecords.Score BETWEEN 661 AND 700) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Scored_Between_701_740 := (COUNT(GROUP, (INTEGER)finalRecords.Score BETWEEN 701 AND 740) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Scored_Between_741_780 := (COUNT(GROUP, (INTEGER)finalRecords.Score BETWEEN 741 AND 780) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Scored_Between_781_820 := (COUNT(GROUP, (INTEGER)finalRecords.Score BETWEEN 781 AND 820) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Scored_Between_821_860 := (COUNT(GROUP, (INTEGER)finalRecords.Score BETWEEN 821 AND 860) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Scored_Between_861_900 := (COUNT(GROUP, (INTEGER)finalRecords.Score BETWEEN 861 AND 900) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Scored_Above_900:= (COUNT(GROUP, (INTEGER)finalRecords.Score > 900) / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Scored_Below_100:= (COUNT(GROUP, (INTEGER)finalRecords.Score < 100) / COUNT(GROUP)) * 100;
	
	UNSIGNED2		Average_Score_Excluding_Exceptions			:= ROUND(SUM(GROUP, IF((INTEGER)finalRecords.Score BETWEEN 223 AND 900, (INTEGER)finalRecords.Score, 0)) / COUNT(GROUP, (INTEGER)finalRecords.Score BETWEEN 223 AND 900));
	
	// Alert Code Population Statistics
	DECIMAL6_3	Percent_Alert_100A			:= (COUNT(GROUP, finalRecords.Alert1 = '100A' OR finalRecords.Alert2 = '100A' OR finalRecords.Alert3 = '100A' OR finalRecords.Alert4 = '100A' OR finalRecords.Alert5 = '100A' OR finalRecords.Alert6 = '100A' OR finalRecords.Alert7 = '100A' OR finalRecords.Alert8 = '100A' OR finalRecords.Alert9 = '100A' OR finalRecords.Alert10 = '100A') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Alert_100B			:= (COUNT(GROUP, finalRecords.Alert1 = '100B' OR finalRecords.Alert2 = '100B' OR finalRecords.Alert3 = '100B' OR finalRecords.Alert4 = '100B' OR finalRecords.Alert5 = '100B' OR finalRecords.Alert6 = '100B' OR finalRecords.Alert7 = '100B' OR finalRecords.Alert8 = '100B' OR finalRecords.Alert9 = '100B' OR finalRecords.Alert10 = '100B') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Alert_100C			:= (COUNT(GROUP, finalRecords.Alert1 = '100C' OR finalRecords.Alert2 = '100C' OR finalRecords.Alert3 = '100C' OR finalRecords.Alert4 = '100C' OR finalRecords.Alert5 = '100C' OR finalRecords.Alert6 = '100C' OR finalRecords.Alert7 = '100C' OR finalRecords.Alert8 = '100C' OR finalRecords.Alert9 = '100C' OR finalRecords.Alert10 = '100C') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Alert_100D			:= (COUNT(GROUP, finalRecords.Alert1 = '100D' OR finalRecords.Alert2 = '100D' OR finalRecords.Alert3 = '100D' OR finalRecords.Alert4 = '100D' OR finalRecords.Alert5 = '100D' OR finalRecords.Alert6 = '100D' OR finalRecords.Alert7 = '100D' OR finalRecords.Alert8 = '100D' OR finalRecords.Alert9 = '100D' OR finalRecords.Alert10 = '100D') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Alert_100E			:= (COUNT(GROUP, finalRecords.Alert1 = '100E' OR finalRecords.Alert2 = '100E' OR finalRecords.Alert3 = '100E' OR finalRecords.Alert4 = '100E' OR finalRecords.Alert5 = '100E' OR finalRecords.Alert6 = '100E' OR finalRecords.Alert7 = '100E' OR finalRecords.Alert8 = '100E' OR finalRecords.Alert9 = '100E' OR finalRecords.Alert10 = '100E') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Alert_100F			:= (COUNT(GROUP, finalRecords.Alert1 = '100F' OR finalRecords.Alert2 = '100F' OR finalRecords.Alert3 = '100F' OR finalRecords.Alert4 = '100F' OR finalRecords.Alert5 = '100F' OR finalRecords.Alert6 = '100F' OR finalRecords.Alert7 = '100F' OR finalRecords.Alert8 = '100F' OR finalRecords.Alert9 = '100F' OR finalRecords.Alert10 = '100F') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Alert_200A			:= (COUNT(GROUP, finalRecords.Alert1 = '200A' OR finalRecords.Alert2 = '200A' OR finalRecords.Alert3 = '200A' OR finalRecords.Alert4 = '200A' OR finalRecords.Alert5 = '200A' OR finalRecords.Alert6 = '200A' OR finalRecords.Alert7 = '200A' OR finalRecords.Alert8 = '200A' OR finalRecords.Alert9 = '200A' OR finalRecords.Alert10 = '200A') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_Alert_222A			:= (COUNT(GROUP, finalRecords.Alert1 = '222A' OR finalRecords.Alert2 = '222A' OR finalRecords.Alert3 = '222A' OR finalRecords.Alert4 = '222A' OR finalRecords.Alert5 = '222A' OR finalRecords.Alert6 = '222A' OR finalRecords.Alert7 = '222A' OR finalRecords.Alert8 = '222A' OR finalRecords.Alert9 = '222A' OR finalRecords.Alert10 = '222A') / COUNT(GROUP)) * 100;
	
	// Reason Code Population Statistics
	DECIMAL6_3	Percent_RC_F00					:=	(COUNT(GROUP, finalRecords.RC1 = 'F00' OR finalRecords.RC2 = 'F00' OR finalRecords.RC3 = 'F00' OR finalRecords.RC4 = 'F00' OR finalRecords.RC5 = 'F00' OR finalRecords.RC6 = 'F00') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_F01					:=	(COUNT(GROUP, finalRecords.RC1 = 'F01' OR finalRecords.RC2 = 'F01' OR finalRecords.RC3 = 'F01' OR finalRecords.RC4 = 'F01' OR finalRecords.RC5 = 'F01' OR finalRecords.RC6 = 'F01') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_F02					:=	(COUNT(GROUP, finalRecords.RC1 = 'F02' OR finalRecords.RC2 = 'F02' OR finalRecords.RC3 = 'F02' OR finalRecords.RC4 = 'F02' OR finalRecords.RC5 = 'F02' OR finalRecords.RC6 = 'F02') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_F03					:=	(COUNT(GROUP, finalRecords.RC1 = 'F03' OR finalRecords.RC2 = 'F03' OR finalRecords.RC3 = 'F03' OR finalRecords.RC4 = 'F03' OR finalRecords.RC5 = 'F03' OR finalRecords.RC6 = 'F03') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_F04					:=	(COUNT(GROUP, finalRecords.RC1 = 'F04' OR finalRecords.RC2 = 'F04' OR finalRecords.RC3 = 'F04' OR finalRecords.RC4 = 'F04' OR finalRecords.RC5 = 'F04' OR finalRecords.RC6 = 'F04') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_C10					:=	(COUNT(GROUP, finalRecords.RC1 = 'C10' OR finalRecords.RC2 = 'C10' OR finalRecords.RC3 = 'C10' OR finalRecords.RC4 = 'C10' OR finalRecords.RC5 = 'C10' OR finalRecords.RC6 = 'C10') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_C11					:=	(COUNT(GROUP, finalRecords.RC1 = 'C11' OR finalRecords.RC2 = 'C11' OR finalRecords.RC3 = 'C11' OR finalRecords.RC4 = 'C11' OR finalRecords.RC5 = 'C11' OR finalRecords.RC6 = 'C11') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_C12					:=	(COUNT(GROUP, finalRecords.RC1 = 'C12' OR finalRecords.RC2 = 'C12' OR finalRecords.RC3 = 'C12' OR finalRecords.RC4 = 'C12' OR finalRecords.RC5 = 'C12' OR finalRecords.RC6 = 'C12') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_C13					:=	(COUNT(GROUP, finalRecords.RC1 = 'C13' OR finalRecords.RC2 = 'C13' OR finalRecords.RC3 = 'C13' OR finalRecords.RC4 = 'C13' OR finalRecords.RC5 = 'C13' OR finalRecords.RC6 = 'C13') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_C14					:=	(COUNT(GROUP, finalRecords.RC1 = 'C14' OR finalRecords.RC2 = 'C14' OR finalRecords.RC3 = 'C14' OR finalRecords.RC4 = 'C14' OR finalRecords.RC5 = 'C14' OR finalRecords.RC6 = 'C14') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_C15					:=	(COUNT(GROUP, finalRecords.RC1 = 'C15' OR finalRecords.RC2 = 'C15' OR finalRecords.RC3 = 'C15' OR finalRecords.RC4 = 'C15' OR finalRecords.RC5 = 'C15' OR finalRecords.RC6 = 'C15') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_C16					:=	(COUNT(GROUP, finalRecords.RC1 = 'C16' OR finalRecords.RC2 = 'C16' OR finalRecords.RC3 = 'C16' OR finalRecords.RC4 = 'C16' OR finalRecords.RC5 = 'C16' OR finalRecords.RC6 = 'C16') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_C17					:=	(COUNT(GROUP, finalRecords.RC1 = 'C17' OR finalRecords.RC2 = 'C17' OR finalRecords.RC3 = 'C17' OR finalRecords.RC4 = 'C17' OR finalRecords.RC5 = 'C17' OR finalRecords.RC6 = 'C17') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_C18					:=	(COUNT(GROUP, finalRecords.RC1 = 'C18' OR finalRecords.RC2 = 'C18' OR finalRecords.RC3 = 'C18' OR finalRecords.RC4 = 'C18' OR finalRecords.RC5 = 'C18' OR finalRecords.RC6 = 'C18') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_C19					:=	(COUNT(GROUP, finalRecords.RC1 = 'C19' OR finalRecords.RC2 = 'C19' OR finalRecords.RC3 = 'C19' OR finalRecords.RC4 = 'C19' OR finalRecords.RC5 = 'C19' OR finalRecords.RC6 = 'C19') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_C20					:=	(COUNT(GROUP, finalRecords.RC1 = 'C20' OR finalRecords.RC2 = 'C20' OR finalRecords.RC3 = 'C20' OR finalRecords.RC4 = 'C20' OR finalRecords.RC5 = 'C20' OR finalRecords.RC6 = 'C20') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_C21					:=	(COUNT(GROUP, finalRecords.RC1 = 'C21' OR finalRecords.RC2 = 'C21' OR finalRecords.RC3 = 'C21' OR finalRecords.RC4 = 'C21' OR finalRecords.RC5 = 'C21' OR finalRecords.RC6 = 'C21') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_C22					:=	(COUNT(GROUP, finalRecords.RC1 = 'C22' OR finalRecords.RC2 = 'C22' OR finalRecords.RC3 = 'C22' OR finalRecords.RC4 = 'C22' OR finalRecords.RC5 = 'C22' OR finalRecords.RC6 = 'C22') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_C23					:=	(COUNT(GROUP, finalRecords.RC1 = 'C23' OR finalRecords.RC2 = 'C23' OR finalRecords.RC3 = 'C23' OR finalRecords.RC4 = 'C23' OR finalRecords.RC5 = 'C23' OR finalRecords.RC6 = 'C23') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_D30					:=	(COUNT(GROUP, finalRecords.RC1 = 'D30' OR finalRecords.RC2 = 'D30' OR finalRecords.RC3 = 'D30' OR finalRecords.RC4 = 'D30' OR finalRecords.RC5 = 'D30' OR finalRecords.RC6 = 'D30') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_D31					:=	(COUNT(GROUP, finalRecords.RC1 = 'D31' OR finalRecords.RC2 = 'D31' OR finalRecords.RC3 = 'D31' OR finalRecords.RC4 = 'D31' OR finalRecords.RC5 = 'D31' OR finalRecords.RC6 = 'D31') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_D32					:=	(COUNT(GROUP, finalRecords.RC1 = 'D32' OR finalRecords.RC2 = 'D32' OR finalRecords.RC3 = 'D32' OR finalRecords.RC4 = 'D32' OR finalRecords.RC5 = 'D32' OR finalRecords.RC6 = 'D32') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_D33					:=	(COUNT(GROUP, finalRecords.RC1 = 'D33' OR finalRecords.RC2 = 'D33' OR finalRecords.RC3 = 'D33' OR finalRecords.RC4 = 'D33' OR finalRecords.RC5 = 'D33' OR finalRecords.RC6 = 'D33') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_D34					:=	(COUNT(GROUP, finalRecords.RC1 = 'D34' OR finalRecords.RC2 = 'D34' OR finalRecords.RC3 = 'D34' OR finalRecords.RC4 = 'D34' OR finalRecords.RC5 = 'D34' OR finalRecords.RC6 = 'D34') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A40					:=	(COUNT(GROUP, finalRecords.RC1 = 'A40' OR finalRecords.RC2 = 'A40' OR finalRecords.RC3 = 'A40' OR finalRecords.RC4 = 'A40' OR finalRecords.RC5 = 'A40' OR finalRecords.RC6 = 'A40') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A41					:=	(COUNT(GROUP, finalRecords.RC1 = 'A41' OR finalRecords.RC2 = 'A41' OR finalRecords.RC3 = 'A41' OR finalRecords.RC4 = 'A41' OR finalRecords.RC5 = 'A41' OR finalRecords.RC6 = 'A41') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A42					:=	(COUNT(GROUP, finalRecords.RC1 = 'A42' OR finalRecords.RC2 = 'A42' OR finalRecords.RC3 = 'A42' OR finalRecords.RC4 = 'A42' OR finalRecords.RC5 = 'A42' OR finalRecords.RC6 = 'A42') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A43					:=	(COUNT(GROUP, finalRecords.RC1 = 'A43' OR finalRecords.RC2 = 'A43' OR finalRecords.RC3 = 'A43' OR finalRecords.RC4 = 'A43' OR finalRecords.RC5 = 'A43' OR finalRecords.RC6 = 'A43') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A44					:=	(COUNT(GROUP, finalRecords.RC1 = 'A44' OR finalRecords.RC2 = 'A44' OR finalRecords.RC3 = 'A44' OR finalRecords.RC4 = 'A44' OR finalRecords.RC5 = 'A44' OR finalRecords.RC6 = 'A44') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A45					:=	(COUNT(GROUP, finalRecords.RC1 = 'A45' OR finalRecords.RC2 = 'A45' OR finalRecords.RC3 = 'A45' OR finalRecords.RC4 = 'A45' OR finalRecords.RC5 = 'A45' OR finalRecords.RC6 = 'A45') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A46					:=	(COUNT(GROUP, finalRecords.RC1 = 'A46' OR finalRecords.RC2 = 'A46' OR finalRecords.RC3 = 'A46' OR finalRecords.RC4 = 'A46' OR finalRecords.RC5 = 'A46' OR finalRecords.RC6 = 'A46') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A47					:=	(COUNT(GROUP, finalRecords.RC1 = 'A47' OR finalRecords.RC2 = 'A47' OR finalRecords.RC3 = 'A47' OR finalRecords.RC4 = 'A47' OR finalRecords.RC5 = 'A47' OR finalRecords.RC6 = 'A47') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A48					:=	(COUNT(GROUP, finalRecords.RC1 = 'A48' OR finalRecords.RC2 = 'A48' OR finalRecords.RC3 = 'A48' OR finalRecords.RC4 = 'A48' OR finalRecords.RC5 = 'A48' OR finalRecords.RC6 = 'A48') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A49					:=	(COUNT(GROUP, finalRecords.RC1 = 'A49' OR finalRecords.RC2 = 'A49' OR finalRecords.RC3 = 'A49' OR finalRecords.RC4 = 'A49' OR finalRecords.RC5 = 'A49' OR finalRecords.RC6 = 'A49') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A50					:=	(COUNT(GROUP, finalRecords.RC1 = 'A50' OR finalRecords.RC2 = 'A50' OR finalRecords.RC3 = 'A50' OR finalRecords.RC4 = 'A50' OR finalRecords.RC5 = 'A50' OR finalRecords.RC6 = 'A50') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_A51					:=	(COUNT(GROUP, finalRecords.RC1 = 'A51' OR finalRecords.RC2 = 'A51' OR finalRecords.RC3 = 'A51' OR finalRecords.RC4 = 'A51' OR finalRecords.RC5 = 'A51' OR finalRecords.RC6 = 'A51') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_E55					:=	(COUNT(GROUP, finalRecords.RC1 = 'E55' OR finalRecords.RC2 = 'E55' OR finalRecords.RC3 = 'E55' OR finalRecords.RC4 = 'E55' OR finalRecords.RC5 = 'E55' OR finalRecords.RC6 = 'E55') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_E56					:=	(COUNT(GROUP, finalRecords.RC1 = 'E56' OR finalRecords.RC2 = 'E56' OR finalRecords.RC3 = 'E56' OR finalRecords.RC4 = 'E56' OR finalRecords.RC5 = 'E56' OR finalRecords.RC6 = 'E56') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_E57					:=	(COUNT(GROUP, finalRecords.RC1 = 'E57' OR finalRecords.RC2 = 'E57' OR finalRecords.RC3 = 'E57' OR finalRecords.RC4 = 'E57' OR finalRecords.RC5 = 'E57' OR finalRecords.RC6 = 'E57') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_I60					:=	(COUNT(GROUP, finalRecords.RC1 = 'I60' OR finalRecords.RC2 = 'I60' OR finalRecords.RC3 = 'I60' OR finalRecords.RC4 = 'I60' OR finalRecords.RC5 = 'I60' OR finalRecords.RC6 = 'I60') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_I61					:=	(COUNT(GROUP, finalRecords.RC1 = 'I61' OR finalRecords.RC2 = 'I61' OR finalRecords.RC3 = 'I61' OR finalRecords.RC4 = 'I61' OR finalRecords.RC5 = 'I61' OR finalRecords.RC6 = 'I61') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_S65					:=	(COUNT(GROUP, finalRecords.RC1 = 'S65' OR finalRecords.RC2 = 'S65' OR finalRecords.RC3 = 'S65' OR finalRecords.RC4 = 'S65' OR finalRecords.RC5 = 'S65' OR finalRecords.RC6 = 'S65') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_S66					:=	(COUNT(GROUP, finalRecords.RC1 = 'S66' OR finalRecords.RC2 = 'S66' OR finalRecords.RC3 = 'S66' OR finalRecords.RC4 = 'S66' OR finalRecords.RC5 = 'S66' OR finalRecords.RC6 = 'S66') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_L70					:=	(COUNT(GROUP, finalRecords.RC1 = 'L70' OR finalRecords.RC2 = 'L70' OR finalRecords.RC3 = 'L70' OR finalRecords.RC4 = 'L70' OR finalRecords.RC5 = 'L70' OR finalRecords.RC6 = 'L70') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_L71					:=	(COUNT(GROUP, finalRecords.RC1 = 'L71' OR finalRecords.RC2 = 'L71' OR finalRecords.RC3 = 'L71' OR finalRecords.RC4 = 'L71' OR finalRecords.RC5 = 'L71' OR finalRecords.RC6 = 'L71') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_L72					:=	(COUNT(GROUP, finalRecords.RC1 = 'L72' OR finalRecords.RC2 = 'L72' OR finalRecords.RC3 = 'L72' OR finalRecords.RC4 = 'L72' OR finalRecords.RC5 = 'L72' OR finalRecords.RC6 = 'L72') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_L73					:=	(COUNT(GROUP, finalRecords.RC1 = 'L73' OR finalRecords.RC2 = 'L73' OR finalRecords.RC3 = 'L73' OR finalRecords.RC4 = 'L73' OR finalRecords.RC5 = 'L73' OR finalRecords.RC6 = 'L73') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_L74					:=	(COUNT(GROUP, finalRecords.RC1 = 'L74' OR finalRecords.RC2 = 'L74' OR finalRecords.RC3 = 'L74' OR finalRecords.RC4 = 'L74' OR finalRecords.RC5 = 'L74' OR finalRecords.RC6 = 'L74') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_L75					:=	(COUNT(GROUP, finalRecords.RC1 = 'L75' OR finalRecords.RC2 = 'L75' OR finalRecords.RC3 = 'L75' OR finalRecords.RC4 = 'L75' OR finalRecords.RC5 = 'L75' OR finalRecords.RC6 = 'L75') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_L76					:=	(COUNT(GROUP, finalRecords.RC1 = 'L76' OR finalRecords.RC2 = 'L76' OR finalRecords.RC3 = 'L76' OR finalRecords.RC4 = 'L76' OR finalRecords.RC5 = 'L76' OR finalRecords.RC6 = 'L76') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_L77					:=	(COUNT(GROUP, finalRecords.RC1 = 'L77' OR finalRecords.RC2 = 'L77' OR finalRecords.RC3 = 'L77' OR finalRecords.RC4 = 'L77' OR finalRecords.RC5 = 'L77' OR finalRecords.RC6 = 'L77') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_L78					:=	(COUNT(GROUP, finalRecords.RC1 = 'L78' OR finalRecords.RC2 = 'L78' OR finalRecords.RC3 = 'L78' OR finalRecords.RC4 = 'L78' OR finalRecords.RC5 = 'L78' OR finalRecords.RC6 = 'L78') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_L79					:=	(COUNT(GROUP, finalRecords.RC1 = 'L79' OR finalRecords.RC2 = 'L79' OR finalRecords.RC3 = 'L79' OR finalRecords.RC4 = 'L79' OR finalRecords.RC5 = 'L79' OR finalRecords.RC6 = 'L79') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_L80					:=	(COUNT(GROUP, finalRecords.RC1 = 'L80' OR finalRecords.RC2 = 'L80' OR finalRecords.RC3 = 'L80' OR finalRecords.RC4 = 'L80' OR finalRecords.RC5 = 'L80' OR finalRecords.RC6 = 'L80') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_L81					:=	(COUNT(GROUP, finalRecords.RC1 = 'L81' OR finalRecords.RC2 = 'L81' OR finalRecords.RC3 = 'L81' OR finalRecords.RC4 = 'L81' OR finalRecords.RC5 = 'L81' OR finalRecords.RC6 = 'L81') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_P85					:=	(COUNT(GROUP, finalRecords.RC1 = 'P85' OR finalRecords.RC2 = 'P85' OR finalRecords.RC3 = 'P85' OR finalRecords.RC4 = 'P85' OR finalRecords.RC5 = 'P85' OR finalRecords.RC6 = 'P85') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_P86					:=	(COUNT(GROUP, finalRecords.RC1 = 'P86' OR finalRecords.RC2 = 'P86' OR finalRecords.RC3 = 'P86' OR finalRecords.RC4 = 'P86' OR finalRecords.RC5 = 'P86' OR finalRecords.RC6 = 'P86') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_P87					:=	(COUNT(GROUP, finalRecords.RC1 = 'P87' OR finalRecords.RC2 = 'P87' OR finalRecords.RC3 = 'P87' OR finalRecords.RC4 = 'P87' OR finalRecords.RC5 = 'P87' OR finalRecords.RC6 = 'P87') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_P88					:=	(COUNT(GROUP, finalRecords.RC1 = 'P88' OR finalRecords.RC2 = 'P88' OR finalRecords.RC3 = 'P88' OR finalRecords.RC4 = 'P88' OR finalRecords.RC5 = 'P88' OR finalRecords.RC6 = 'P88') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_P89					:=	(COUNT(GROUP, finalRecords.RC1 = 'P89' OR finalRecords.RC2 = 'P89' OR finalRecords.RC3 = 'P89' OR finalRecords.RC4 = 'P89' OR finalRecords.RC5 = 'P89' OR finalRecords.RC6 = 'P89') / COUNT(GROUP)) * 100;
	DECIMAL6_3	Percent_RC_P90					:=	(COUNT(GROUP, finalRecords.RC1 = 'P90' OR finalRecords.RC2 = 'P90' OR finalRecords.RC3 = 'P90' OR finalRecords.RC4 = 'P90' OR finalRecords.RC5 = 'P90' OR finalRecords.RC6 = 'P90') / COUNT(GROUP)) * 100;
END;

trackingLayout2 := RECORD
	STRING8 Date_Of_Report															:= finalRecords.TransactionDate;
	UNSIGNED8 Number_Of_Unique_Account_IDs_Transacted		:= COUNT(GROUP);
END;

mainStats := TABLE(finalRecords, trackingLayout, TransactionDate);
OUTPUT(CHOOSEN(mainStats, eyeball), NAMED('Main_Stats_RV2'));
uniqueIDRecs := DEDUP(SORT(finalRecords, TransactionDate, AccountID), TransactionDate, AccountID);
uniqueIDs := TABLE(uniqueIDRecs, trackingLayout2, TransactionDate);
OUTPUT(CHOOSEN(uniqueIDs, eyeball), NAMED('Unique_IDs_RV2'));

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

OUTPUT(day1, NAMED('Sample_day1_RV2'));
OUTPUT(day3, NAMED('Sample_day3_RV2'));
OUTPUT(day7, NAMED('Sample_day7_RV2'));
OUTPUT(CHOOSEN(MostRecent, eyeball), NAMED('Sample_Stats_RV2'));

averageTrackingLayout := RECORD
	// General Statistics
	STRING8 Date_Of_Report := '';							
	UNSIGNED8 Total_Number_Of_Transactions;							
	UNSIGNED8 Number_Of_Unique_Account_IDs_Transacted;		
	
	// Input Population Statistics
	DECIMAL6_3	Percent_First_Name_Populated;						
	DECIMAL6_3	Percent_Last_Name_Populated;							
	DECIMAL6_3	Percent_SSN_Populated;		
	DECIMAL6_3	Percent_DOB_Populated;		
	DECIMAL6_3	Percent_Address_Populated;
	DECIMAL6_3	Percent_City_Populated;	
	DECIMAL6_3	Percent_State_Populated;	
	DECIMAL6_3	Percent_Zip_Populated;		
	DECIMAL6_3	Percent_DL_Populated;		
	DECIMAL6_3	Percent_Home_Phone_Populated;						
	
	// Score Bucket Statistics
	DECIMAL6_3	Percent_Scored_100;			
	DECIMAL6_3	Percent_Scored_200;			
	DECIMAL6_3	Percent_Scored_222;			
	DECIMAL6_3	Percent_Scored_Between_501_540;					
	DECIMAL6_3	Percent_Scored_Between_541_580;					
	DECIMAL6_3	Percent_Scored_Between_581_620;					
	DECIMAL6_3	Percent_Scored_Between_621_660;					
	DECIMAL6_3	Percent_Scored_Between_661_700;					
	DECIMAL6_3	Percent_Scored_Between_701_740;					
	DECIMAL6_3	Percent_Scored_Between_741_780;					
	DECIMAL6_3	Percent_Scored_Between_781_820;					
	DECIMAL6_3	Percent_Scored_Between_821_860;					
	DECIMAL6_3	Percent_Scored_Between_861_900;					
	DECIMAL6_3	Percent_Scored_Above_900;
	DECIMAL6_3	Percent_Scored_Below_100;
	
	UNSIGNED2		Average_Score_Excluding_Exceptions;
	
	// Alert Code Population Statistics
	DECIMAL6_3	Percent_Alert_100A;
	DECIMAL6_3	Percent_Alert_100B;
	DECIMAL6_3	Percent_Alert_100C;
	DECIMAL6_3	Percent_Alert_100D;
	DECIMAL6_3	Percent_Alert_100E;
	DECIMAL6_3	Percent_Alert_100F;
	DECIMAL6_3	Percent_Alert_200A;
	DECIMAL6_3	Percent_Alert_222A;
	
	// Reason Code Population Statistics
	DECIMAL6_3	Percent_RC_F00;
	DECIMAL6_3	Percent_RC_F01;
	DECIMAL6_3	Percent_RC_F02;
	DECIMAL6_3	Percent_RC_F03;
	DECIMAL6_3	Percent_RC_F04;
	DECIMAL6_3	Percent_RC_C10;
	DECIMAL6_3	Percent_RC_C11;
	DECIMAL6_3	Percent_RC_C12;
	DECIMAL6_3	Percent_RC_C13;
	DECIMAL6_3	Percent_RC_C14;
	DECIMAL6_3	Percent_RC_C15;
	DECIMAL6_3	Percent_RC_C16;
	DECIMAL6_3	Percent_RC_C17;
	DECIMAL6_3	Percent_RC_C18;
	DECIMAL6_3	Percent_RC_C19;
	DECIMAL6_3	Percent_RC_C20;
	DECIMAL6_3	Percent_RC_C21;
	DECIMAL6_3	Percent_RC_C22;
	DECIMAL6_3	Percent_RC_C23;
	DECIMAL6_3	Percent_RC_D30;
	DECIMAL6_3	Percent_RC_D31;
	DECIMAL6_3	Percent_RC_D32;
	DECIMAL6_3	Percent_RC_D33;
	DECIMAL6_3	Percent_RC_D34;
	DECIMAL6_3	Percent_RC_A40;
	DECIMAL6_3	Percent_RC_A41;
	DECIMAL6_3	Percent_RC_A42;
	DECIMAL6_3	Percent_RC_A43;
	DECIMAL6_3	Percent_RC_A44;
	DECIMAL6_3	Percent_RC_A45;
	DECIMAL6_3	Percent_RC_A46;
	DECIMAL6_3	Percent_RC_A47;
	DECIMAL6_3	Percent_RC_A48;
	DECIMAL6_3	Percent_RC_A49;
	DECIMAL6_3	Percent_RC_A50;
	DECIMAL6_3	Percent_RC_A51;
	DECIMAL6_3	Percent_RC_E55;
	DECIMAL6_3	Percent_RC_E56;
	DECIMAL6_3	Percent_RC_E57;
	DECIMAL6_3	Percent_RC_I60;
	DECIMAL6_3	Percent_RC_I61;
	DECIMAL6_3	Percent_RC_S65;
	DECIMAL6_3	Percent_RC_S66;
	DECIMAL6_3	Percent_RC_L70;
	DECIMAL6_3	Percent_RC_L71;
	DECIMAL6_3	Percent_RC_L72;
	DECIMAL6_3	Percent_RC_L73;
	DECIMAL6_3	Percent_RC_L74;
	DECIMAL6_3	Percent_RC_L75;
	DECIMAL6_3	Percent_RC_L76;
	DECIMAL6_3	Percent_RC_L77;
	DECIMAL6_3	Percent_RC_L78;
	DECIMAL6_3	Percent_RC_L79;
	DECIMAL6_3	Percent_RC_L80;
	DECIMAL6_3	Percent_RC_L81;
	DECIMAL6_3	Percent_RC_P85;
	DECIMAL6_3	Percent_RC_P86;
	DECIMAL6_3	Percent_RC_P87;
	DECIMAL6_3	Percent_RC_P88;
	DECIMAL6_3	Percent_RC_P89;
	DECIMAL6_3	Percent_RC_P90;
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
	SELF.Percent_SSN_Populated := percented(Percent_SSN_Populated);		
	SELF.Percent_DOB_Populated := percented(Percent_DOB_Populated);		
	SELF.Percent_Address_Populated := percented(Percent_Address_Populated);
	SELF.Percent_City_Populated := percented(Percent_City_Populated);	
	SELF.Percent_State_Populated := percented(Percent_State_Populated);	
	SELF.Percent_Zip_Populated := percented(Percent_Zip_Populated);		
	SELF.Percent_DL_Populated := percented(Percent_DL_Populated);		
	SELF.Percent_Home_Phone_Populated := percented(Percent_Home_Phone_Populated);						
	
	// Score Bucket Statistics
	SELF.Percent_Scored_100 := percented(Percent_Scored_100);			
	SELF.Percent_Scored_200 := percented(Percent_Scored_200);			
	SELF.Percent_Scored_222 := percented(Percent_Scored_222);			
	SELF.Percent_Scored_Between_501_540 := percented(Percent_Scored_Between_501_540);					
	SELF.Percent_Scored_Between_541_580 := percented(Percent_Scored_Between_541_580);					
	SELF.Percent_Scored_Between_581_620 := percented(Percent_Scored_Between_581_620);					
	SELF.Percent_Scored_Between_621_660 := percented(Percent_Scored_Between_621_660);					
	SELF.Percent_Scored_Between_661_700 := percented(Percent_Scored_Between_661_700);					
	SELF.Percent_Scored_Between_701_740 := percented(Percent_Scored_Between_701_740);					
	SELF.Percent_Scored_Between_741_780 := percented(Percent_Scored_Between_741_780);					
	SELF.Percent_Scored_Between_781_820 := percented(Percent_Scored_Between_781_820);					
	SELF.Percent_Scored_Between_821_860 := percented(Percent_Scored_Between_821_860);					
	SELF.Percent_Scored_Between_861_900 := percented(Percent_Scored_Between_861_900);					
	SELF.Percent_Scored_Above_900 := percented(Percent_Scored_Above_900);
	SELF.Percent_Scored_Below_100 := percented(Percent_Scored_Below_100);
	
	SELF.Average_Score_Excluding_Exceptions := rounded(Average_Score_Excluding_Exceptions);		
	
	// Alert Code Population Statistics
	SELF.Percent_Alert_100A := percented(Percent_Alert_100A);
	SELF.Percent_Alert_100B := percented(Percent_Alert_100B);
	SELF.Percent_Alert_100C := percented(Percent_Alert_100C);
	SELF.Percent_Alert_100D := percented(Percent_Alert_100D);
	SELF.Percent_Alert_100E := percented(Percent_Alert_100E);
	SELF.Percent_Alert_100F := percented(Percent_Alert_100F);
	SELF.Percent_Alert_200A := percented(Percent_Alert_200A);
	SELF.Percent_Alert_222A := percented(Percent_Alert_222A);
	
	// Reason Code Population Statistics
	SELF.Percent_RC_F00 := percented(Percent_RC_F00);
	SELF.Percent_RC_F01 := percented(Percent_RC_F01);
	SELF.Percent_RC_F02 := percented(Percent_RC_F02);
	SELF.Percent_RC_F03 := percented(Percent_RC_F03);
	SELF.Percent_RC_F04 := percented(Percent_RC_F04);
	SELF.Percent_RC_C10 := percented(Percent_RC_C10);
	SELF.Percent_RC_C11 := percented(Percent_RC_C11);
	SELF.Percent_RC_C12 := percented(Percent_RC_C12);
	SELF.Percent_RC_C13 := percented(Percent_RC_C13);
	SELF.Percent_RC_C14 := percented(Percent_RC_C14);
	SELF.Percent_RC_C15 := percented(Percent_RC_C15);
	SELF.Percent_RC_C16 := percented(Percent_RC_C16);
	SELF.Percent_RC_C17 := percented(Percent_RC_C17);
	SELF.Percent_RC_C18 := percented(Percent_RC_C18);
	SELF.Percent_RC_C19 := percented(Percent_RC_C19);
	SELF.Percent_RC_C20 := percented(Percent_RC_C20);
	SELF.Percent_RC_C21 := percented(Percent_RC_C21);
	SELF.Percent_RC_C22 := percented(Percent_RC_C22);
	SELF.Percent_RC_C23 := percented(Percent_RC_C23);
	SELF.Percent_RC_D30 := percented(Percent_RC_D30);
	SELF.Percent_RC_D31 := percented(Percent_RC_D31);
	SELF.Percent_RC_D32 := percented(Percent_RC_D32);
	SELF.Percent_RC_D33 := percented(Percent_RC_D33);
	SELF.Percent_RC_D34 := percented(Percent_RC_D34);
	SELF.Percent_RC_A40 := percented(Percent_RC_A40);
	SELF.Percent_RC_A41 := percented(Percent_RC_A41);
	SELF.Percent_RC_A42 := percented(Percent_RC_A42);
	SELF.Percent_RC_A43 := percented(Percent_RC_A43);
	SELF.Percent_RC_A44 := percented(Percent_RC_A44);
	SELF.Percent_RC_A45 := percented(Percent_RC_A45);
	SELF.Percent_RC_A46 := percented(Percent_RC_A46);
	SELF.Percent_RC_A47 := percented(Percent_RC_A47);
	SELF.Percent_RC_A48 := percented(Percent_RC_A48);
	SELF.Percent_RC_A49 := percented(Percent_RC_A49);
	SELF.Percent_RC_A50 := percented(Percent_RC_A50);
	SELF.Percent_RC_A51 := percented(Percent_RC_A51);
	SELF.Percent_RC_E55 := percented(Percent_RC_E55);
	SELF.Percent_RC_E56 := percented(Percent_RC_E56);
	SELF.Percent_RC_E57 := percented(Percent_RC_E57);
	SELF.Percent_RC_I60 := percented(Percent_RC_I60);
	SELF.Percent_RC_I61 := percented(Percent_RC_I61);
	SELF.Percent_RC_S65 := percented(Percent_RC_S65);
	SELF.Percent_RC_S66 := percented(Percent_RC_S66);
	SELF.Percent_RC_L70 := percented(Percent_RC_L70);
	SELF.Percent_RC_L71 := percented(Percent_RC_L71);
	SELF.Percent_RC_L72 := percented(Percent_RC_L72);
	SELF.Percent_RC_L73 := percented(Percent_RC_L73);
	SELF.Percent_RC_L74 := percented(Percent_RC_L74);
	SELF.Percent_RC_L75 := percented(Percent_RC_L75);
	SELF.Percent_RC_L76 := percented(Percent_RC_L76);
	SELF.Percent_RC_L77 := percented(Percent_RC_L77);
	SELF.Percent_RC_L78 := percented(Percent_RC_L78);
	SELF.Percent_RC_L79 := percented(Percent_RC_L79);
	SELF.Percent_RC_L80 := percented(Percent_RC_L80);
	SELF.Percent_RC_L81 := percented(Percent_RC_L81);
	SELF.Percent_RC_P85 := percented(Percent_RC_P85);
	SELF.Percent_RC_P86 := percented(Percent_RC_P86);
	SELF.Percent_RC_P87 := percented(Percent_RC_P87);
	SELF.Percent_RC_P88 := percented(Percent_RC_P88);
	SELF.Percent_RC_P89 := percented(Percent_RC_P89);
	SELF.Percent_RC_P90 := percented(Percent_RC_P90);
END;

Averaged := PROJECT(scout.daily_monitoring.Constants.ds_Record, getAverages(LEFT))[1];
OUTPUT(Averaged, NAMED('Averages_RV2'));

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
	SELF.Percent_SSN_Populated := difference(Percent_SSN_Populated);
	SELF.Percent_DOB_Populated := difference(Percent_DOB_Populated);
	SELF.Percent_Address_Populated := difference(Percent_Address_Populated);
	SELF.Percent_City_Populated := difference(Percent_City_Populated);
	SELF.Percent_State_Populated := difference(Percent_State_Populated);
	SELF.Percent_Zip_Populated := difference(Percent_Zip_Populated);
	SELF.Percent_DL_Populated := difference(Percent_DL_Populated);
	SELF.Percent_Home_Phone_Populated := difference(Percent_Home_Phone_Populated);
	
	// Score Bucket Statistics
	SELF.Percent_Scored_100 := difference(Percent_Scored_100);
	SELF.Percent_Scored_200 := difference(Percent_Scored_200);	
	SELF.Percent_Scored_222 := difference(Percent_Scored_222);	
	SELF.Percent_Scored_Between_501_540 := difference(Percent_Scored_Between_501_540);			
	SELF.Percent_Scored_Between_541_580 := difference(Percent_Scored_Between_541_580);			
	SELF.Percent_Scored_Between_581_620 := difference(Percent_Scored_Between_581_620);			
	SELF.Percent_Scored_Between_621_660 := difference(Percent_Scored_Between_621_660);			
	SELF.Percent_Scored_Between_661_700 := difference(Percent_Scored_Between_661_700);			
	SELF.Percent_Scored_Between_701_740 := difference(Percent_Scored_Between_701_740);			
	SELF.Percent_Scored_Between_741_780 := difference(Percent_Scored_Between_741_780);			
	SELF.Percent_Scored_Between_781_820 := difference(Percent_Scored_Between_781_820);			
	SELF.Percent_Scored_Between_821_860 := difference(Percent_Scored_Between_821_860);			
	SELF.Percent_Scored_Between_861_900 := difference(Percent_Scored_Between_861_900);			
	SELF.Percent_Scored_Above_900 := difference(Percent_Scored_Above_900);
	SELF.Percent_Scored_Below_100 := difference(Percent_Scored_Below_100);
	
	SELF.Average_Score_Excluding_Exceptions := difference(Average_Score_Excluding_Exceptions);	
	
	// Alert Code Population Statistics
	SELF.Percent_Alert_100A := difference(Percent_Alert_100A);
	SELF.Percent_Alert_100B := difference(Percent_Alert_100B);
	SELF.Percent_Alert_100C := difference(Percent_Alert_100C);
	SELF.Percent_Alert_100D := difference(Percent_Alert_100D);
	SELF.Percent_Alert_100E := difference(Percent_Alert_100E);
	SELF.Percent_Alert_100F := difference(Percent_Alert_100F);
	SELF.Percent_Alert_200A := difference(Percent_Alert_200A);
	SELF.Percent_Alert_222A := difference(Percent_Alert_222A);
	
	// Reason Code Population Statistics
	SELF.Percent_RC_F00 := difference(Percent_RC_F00);
	SELF.Percent_RC_F01 := difference(Percent_RC_F01);
	SELF.Percent_RC_F02 := difference(Percent_RC_F02);
	SELF.Percent_RC_F03 := difference(Percent_RC_F03);
	SELF.Percent_RC_F04 := difference(Percent_RC_F04);
	SELF.Percent_RC_C10 := difference(Percent_RC_C10);
	SELF.Percent_RC_C11 := difference(Percent_RC_C11);
	SELF.Percent_RC_C12 := difference(Percent_RC_C12);
	SELF.Percent_RC_C13 := difference(Percent_RC_C13);
	SELF.Percent_RC_C14 := difference(Percent_RC_C14);
	SELF.Percent_RC_C15 := difference(Percent_RC_C15);
	SELF.Percent_RC_C16 := difference(Percent_RC_C16);
	SELF.Percent_RC_C17 := difference(Percent_RC_C17);
	SELF.Percent_RC_C18 := difference(Percent_RC_C18);
	SELF.Percent_RC_C19 := difference(Percent_RC_C19);
	SELF.Percent_RC_C20 := difference(Percent_RC_C20);
	SELF.Percent_RC_C21 := difference(Percent_RC_C21);
	SELF.Percent_RC_C22 := difference(Percent_RC_C22);
	SELF.Percent_RC_C23 := difference(Percent_RC_C23);
	SELF.Percent_RC_D30 := difference(Percent_RC_D30);
	SELF.Percent_RC_D31 := difference(Percent_RC_D31);
	SELF.Percent_RC_D32 := difference(Percent_RC_D32);
	SELF.Percent_RC_D33 := difference(Percent_RC_D33);
	SELF.Percent_RC_D34 := difference(Percent_RC_D34);
	SELF.Percent_RC_A40 := difference(Percent_RC_A40);
	SELF.Percent_RC_A41 := difference(Percent_RC_A41);
	SELF.Percent_RC_A42 := difference(Percent_RC_A42);
	SELF.Percent_RC_A43 := difference(Percent_RC_A43);
	SELF.Percent_RC_A44 := difference(Percent_RC_A44);
	SELF.Percent_RC_A45 := difference(Percent_RC_A45);
	SELF.Percent_RC_A46 := difference(Percent_RC_A46);
	SELF.Percent_RC_A47 := difference(Percent_RC_A47);
	SELF.Percent_RC_A48 := difference(Percent_RC_A48);
	SELF.Percent_RC_A49 := difference(Percent_RC_A49);
	SELF.Percent_RC_A50 := difference(Percent_RC_A50);
	SELF.Percent_RC_A51 := difference(Percent_RC_A51);
	SELF.Percent_RC_E55 := difference(Percent_RC_E55);
	SELF.Percent_RC_E56 := difference(Percent_RC_E56);
	SELF.Percent_RC_E57 := difference(Percent_RC_E57);
	SELF.Percent_RC_I60 := difference(Percent_RC_I60);
	SELF.Percent_RC_I61 := difference(Percent_RC_I61);
	SELF.Percent_RC_S65 := difference(Percent_RC_S65);
	SELF.Percent_RC_S66 := difference(Percent_RC_S66);
	SELF.Percent_RC_L70 := difference(Percent_RC_L70);
	SELF.Percent_RC_L71 := difference(Percent_RC_L71);
	SELF.Percent_RC_L72 := difference(Percent_RC_L72);
	SELF.Percent_RC_L73 := difference(Percent_RC_L73);
	SELF.Percent_RC_L74 := difference(Percent_RC_L74);
	SELF.Percent_RC_L75 := difference(Percent_RC_L75);
	SELF.Percent_RC_L76 := difference(Percent_RC_L76);
	SELF.Percent_RC_L77 := difference(Percent_RC_L77);
	SELF.Percent_RC_L78 := difference(Percent_RC_L78);
	SELF.Percent_RC_L79 := difference(Percent_RC_L79);
	SELF.Percent_RC_L80 := difference(Percent_RC_L80);
	SELF.Percent_RC_L81 := difference(Percent_RC_L81);
	SELF.Percent_RC_P85 := difference(Percent_RC_P85);
	SELF.Percent_RC_P86 := difference(Percent_RC_P86);
	SELF.Percent_RC_P87 := difference(Percent_RC_P87);
	SELF.Percent_RC_P88 := difference(Percent_RC_P88);
	SELF.Percent_RC_P89 := difference(Percent_RC_P89);
	SELF.Percent_RC_P90 := difference(Percent_RC_P90);
END;

Differs := PROJECT(scout.daily_monitoring.Constants.ds_Record, getDifferences(LEFT))[1];

OUTPUT(Differs, NAMED('Differences_RV2'));

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
'RiskView 2 Daily Score Monitor' + '\n' +
'========================\n' +
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
potentialProblems(Percent_Scored_100, 'Percent_Scored_100', scout.daily_monitoring.Constants.ThreshPercent_Scored_100) +
potentialProblems(Percent_Scored_200, 'Percent_Scored_200', scout.daily_monitoring.Constants.ThreshPercent_Scored_200) +
potentialProblems(Percent_Scored_222, 'Percent_Scored_222', scout.daily_monitoring.Constants.ThreshPercent_Scored_222) +
potentialProblems(Percent_Scored_Between_501_540, 'Percent_Scored_Between_501_540', scout.daily_monitoring.Constants.ThreshRiskViewScoreBuckets) +
potentialProblems(Percent_Scored_Between_541_580, 'Percent_Scored_Between_541_580', scout.daily_monitoring.Constants.ThreshRiskViewScoreBuckets) +
potentialProblems(Percent_Scored_Between_581_620, 'Percent_Scored_Between_581_620', scout.daily_monitoring.Constants.ThreshRiskViewScoreBuckets) +
potentialProblems(Percent_Scored_Between_621_660, 'Percent_Scored_Between_621_660', scout.daily_monitoring.Constants.ThreshRiskViewScoreBuckets) +
potentialProblems(Percent_Scored_Between_661_700, 'Percent_Scored_Between_661_700', scout.daily_monitoring.Constants.ThreshRiskViewScoreBuckets) +
potentialProblems(Percent_Scored_Between_701_740, 'Percent_Scored_Between_701_740', scout.daily_monitoring.Constants.ThreshRiskViewScoreBuckets) +
potentialProblems(Percent_Scored_Between_741_780, 'Percent_Scored_Between_741_780', scout.daily_monitoring.Constants.ThreshRiskViewScoreBuckets) +
potentialProblems(Percent_Scored_Between_781_820, 'Percent_Scored_Between_781_820', scout.daily_monitoring.Constants.ThreshRiskViewScoreBuckets) +
potentialProblems(Percent_Scored_Between_821_860, 'Percent_Scored_Between_821_860', scout.daily_monitoring.Constants.ThreshRiskViewScoreBuckets) +
potentialProblems(Percent_Scored_Between_861_900, 'Percent_Scored_Between_861_900', scout.daily_monitoring.Constants.ThreshRiskViewScoreBuckets) +
potentialProblems(Percent_Scored_Above_900, 'Percent_Scored_Above_900', scout.daily_monitoring.Constants.ThreshScoredAbove900) +
potentialProblems(Percent_Scored_Below_100, 'Percent_Scored_Below_100', scout.daily_monitoring.Constants.ThreshScoredBelow100) +
// potentialProblems(Average_Score_Excluding_Exceptions, 'Average_Score_Excluding_Exceptions', 1.000) +
potentialProblems(Percent_Alert_100A, 'Percent_Alert_100A', scout.daily_monitoring.Constants.ThreshPercent_Alert_100A) +
potentialProblems(Percent_Alert_100B, 'Percent_Alert_100B', scout.daily_monitoring.Constants.ThreshPercent_Alert_100B) +
potentialProblems(Percent_Alert_100C, 'Percent_Alert_100C', scout.daily_monitoring.Constants.ThreshPercent_Alert_100C) +
potentialProblems(Percent_Alert_100D, 'Percent_Alert_100D', scout.daily_monitoring.Constants.ThreshPercent_Alert_100D) +
potentialProblems(Percent_Alert_100E, 'Percent_Alert_100E', scout.daily_monitoring.Constants.ThreshPercent_Alert_100E) +
potentialProblems(Percent_Alert_100F, 'Percent_Alert_100F', scout.daily_monitoring.Constants.ThreshPercent_Alert_100F) +
potentialProblems(Percent_Alert_200A, 'Percent_Alert_200A', scout.daily_monitoring.Constants.ThreshPercent_Alert_200A) +
potentialProblems(Percent_Alert_222A, 'Percent_Alert_222A', scout.daily_monitoring.Constants.ThreshPercent_Alert_222A) +
potentialProblems(Percent_RC_F00, 'Percent_RC_F00', scout.daily_monitoring.Constants.ThreshPercent_RC_F00) +
potentialProblems(Percent_RC_F01, 'Percent_RC_F01', scout.daily_monitoring.Constants.ThreshPercent_RC_F01) +
potentialProblems(Percent_RC_F02, 'Percent_RC_F02', scout.daily_monitoring.Constants.ThreshPercent_RC_F02) +
potentialProblems(Percent_RC_F03, 'Percent_RC_F03', scout.daily_monitoring.Constants.ThreshPercent_RC_F03) +
potentialProblems(Percent_RC_F04, 'Percent_RC_F04', scout.daily_monitoring.Constants.ThreshPercent_RC_F04) +
potentialProblems(Percent_RC_C10, 'Percent_RC_C10', scout.daily_monitoring.Constants.ThreshPercent_RC_C10) +
potentialProblems(Percent_RC_C11, 'Percent_RC_C11', scout.daily_monitoring.Constants.ThreshPercent_RC_C11) +
potentialProblems(Percent_RC_C12, 'Percent_RC_C12', scout.daily_monitoring.Constants.ThreshPercent_RC_C12) +
potentialProblems(Percent_RC_C13, 'Percent_RC_C13', scout.daily_monitoring.Constants.ThreshPercent_RC_C13) +
potentialProblems(Percent_RC_C14, 'Percent_RC_C14', scout.daily_monitoring.Constants.ThreshPercent_RC_C14) +
potentialProblems(Percent_RC_C15, 'Percent_RC_C15', scout.daily_monitoring.Constants.ThreshPercent_RC_C15) +
potentialProblems(Percent_RC_C16, 'Percent_RC_C16', scout.daily_monitoring.Constants.ThreshPercent_RC_C16) +
potentialProblems(Percent_RC_C17, 'Percent_RC_C17', scout.daily_monitoring.Constants.ThreshPercent_RC_C17) +
potentialProblems(Percent_RC_C18, 'Percent_RC_C18', scout.daily_monitoring.Constants.ThreshPercent_RC_C18) +
potentialProblems(Percent_RC_C19, 'Percent_RC_C19', scout.daily_monitoring.Constants.ThreshPercent_RC_C19) +
potentialProblems(Percent_RC_C20, 'Percent_RC_C20', scout.daily_monitoring.Constants.ThreshPercent_RC_C20) +
potentialProblems(Percent_RC_C21, 'Percent_RC_C21', scout.daily_monitoring.Constants.ThreshPercent_RC_C21) +
potentialProblems(Percent_RC_C22, 'Percent_RC_C22', scout.daily_monitoring.Constants.ThreshPercent_RC_C22) +
potentialProblems(Percent_RC_C23, 'Percent_RC_C23', scout.daily_monitoring.Constants.ThreshPercent_RC_C23) +
potentialProblems(Percent_RC_D30, 'Percent_RC_D30', scout.daily_monitoring.Constants.ThreshPercent_RC_D30) +
potentialProblems(Percent_RC_D31, 'Percent_RC_D31', scout.daily_monitoring.Constants.ThreshPercent_RC_D31) +
potentialProblems(Percent_RC_D32, 'Percent_RC_D32', scout.daily_monitoring.Constants.ThreshPercent_RC_D32) +
potentialProblems(Percent_RC_D33, 'Percent_RC_D33', scout.daily_monitoring.Constants.ThreshPercent_RC_D33) +
potentialProblems(Percent_RC_D34, 'Percent_RC_D34', scout.daily_monitoring.Constants.ThreshPercent_RC_D34) +
potentialProblems(Percent_RC_A40, 'Percent_RC_A40', scout.daily_monitoring.Constants.ThreshPercent_RC_A40) +
potentialProblems(Percent_RC_A41, 'Percent_RC_A41', scout.daily_monitoring.Constants.ThreshPercent_RC_A41) +
potentialProblems(Percent_RC_A42, 'Percent_RC_A42', scout.daily_monitoring.Constants.ThreshPercent_RC_A42) +
potentialProblems(Percent_RC_A43, 'Percent_RC_A43', scout.daily_monitoring.Constants.ThreshPercent_RC_A43) +
potentialProblems(Percent_RC_A44, 'Percent_RC_A44', scout.daily_monitoring.Constants.ThreshPercent_RC_A44) +
potentialProblems(Percent_RC_A45, 'Percent_RC_A45', scout.daily_monitoring.Constants.ThreshPercent_RC_A45) +
potentialProblems(Percent_RC_A46, 'Percent_RC_A46', scout.daily_monitoring.Constants.ThreshPercent_RC_A46) +
potentialProblems(Percent_RC_A47, 'Percent_RC_A47', scout.daily_monitoring.Constants.ThreshPercent_RC_A47) +
potentialProblems(Percent_RC_A48, 'Percent_RC_A48', scout.daily_monitoring.Constants.ThreshPercent_RC_A48) +
potentialProblems(Percent_RC_A49, 'Percent_RC_A49', scout.daily_monitoring.Constants.ThreshPercent_RC_A49) +
potentialProblems(Percent_RC_A50, 'Percent_RC_A50', scout.daily_monitoring.Constants.ThreshPercent_RC_A50) +
potentialProblems(Percent_RC_A51, 'Percent_RC_A51', scout.daily_monitoring.Constants.ThreshPercent_RC_A51) +
potentialProblems(Percent_RC_E55, 'Percent_RC_E55', scout.daily_monitoring.Constants.ThreshPercent_RC_E55) +
potentialProblems(Percent_RC_E56, 'Percent_RC_E56', scout.daily_monitoring.Constants.ThreshPercent_RC_E56) +
potentialProblems(Percent_RC_E57, 'Percent_RC_E57', scout.daily_monitoring.Constants.ThreshPercent_RC_E57) +
potentialProblems(Percent_RC_I60, 'Percent_RC_I60', scout.daily_monitoring.Constants.ThreshPercent_RC_I60) +
potentialProblems(Percent_RC_I61, 'Percent_RC_I61', scout.daily_monitoring.Constants.ThreshPercent_RC_I61) +
potentialProblems(Percent_RC_S65, 'Percent_RC_S65', scout.daily_monitoring.Constants.ThreshPercent_RC_S65) +
potentialProblems(Percent_RC_S66, 'Percent_RC_S66', scout.daily_monitoring.Constants.ThreshPercent_RC_S66) +
potentialProblems(Percent_RC_L70, 'Percent_RC_L70', scout.daily_monitoring.Constants.ThreshPercent_RC_L70) +
potentialProblems(Percent_RC_L71, 'Percent_RC_L71', scout.daily_monitoring.Constants.ThreshPercent_RC_L71) +
potentialProblems(Percent_RC_L72, 'Percent_RC_L72', scout.daily_monitoring.Constants.ThreshPercent_RC_L72) +
potentialProblems(Percent_RC_L73, 'Percent_RC_L73', scout.daily_monitoring.Constants.ThreshPercent_RC_L73) +
potentialProblems(Percent_RC_L74, 'Percent_RC_L74', scout.daily_monitoring.Constants.ThreshPercent_RC_L74) +
potentialProblems(Percent_RC_L75, 'Percent_RC_L75', scout.daily_monitoring.Constants.ThreshPercent_RC_L75) +
potentialProblems(Percent_RC_L76, 'Percent_RC_L76', scout.daily_monitoring.Constants.ThreshPercent_RC_L76) +
potentialProblems(Percent_RC_L77, 'Percent_RC_L77', scout.daily_monitoring.Constants.ThreshPercent_RC_L77) +
potentialProblems(Percent_RC_L78, 'Percent_RC_L78', scout.daily_monitoring.Constants.ThreshPercent_RC_L78) +
potentialProblems(Percent_RC_L79, 'Percent_RC_L79', scout.daily_monitoring.Constants.ThreshPercent_RC_L79) +
potentialProblems(Percent_RC_L80, 'Percent_RC_L80', scout.daily_monitoring.Constants.ThreshPercent_RC_L80) +
potentialProblems(Percent_RC_L81, 'Percent_RC_L81', scout.daily_monitoring.Constants.ThreshPercent_RC_L81) +
potentialProblems(Percent_RC_P85, 'Percent_RC_P85', scout.daily_monitoring.Constants.ThreshPercent_RC_P85) +
potentialProblems(Percent_RC_P86, 'Percent_RC_P86', scout.daily_monitoring.Constants.ThreshPercent_RC_P86) +
potentialProblems(Percent_RC_P87, 'Percent_RC_P87', scout.daily_monitoring.Constants.ThreshPercent_RC_P87) +
potentialProblems(Percent_RC_P88, 'Percent_RC_P88', scout.daily_monitoring.Constants.ThreshPercent_RC_P88) +
potentialProblems(Percent_RC_P89, 'Percent_RC_P89', scout.daily_monitoring.Constants.ThreshPercent_RC_P89) +
potentialProblems(Percent_RC_P90, 'Percent_RC_P90', scout.daily_monitoring.Constants.ThreshPercent_RC_P90) +
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
'% SSN Populated\t\t\t|' + genRow(Percent_SSN_Populated) +
'% Date of Birth Populated\t\t|' + genRow(Percent_DOB_Populated) +
'% Address Populated\t\t\t|' + genRow(Percent_Address_Populated) +
'% City Populated\t\t\t|' + genRow(Percent_City_Populated) +
'% State Populated\t\t\t|' + genRow(Percent_State_Populated) +
'% Zip Code Populated\t\t\t|' + genRow(Percent_Zip_Populated) +
'% Drivers License Populated\t\t|' + genRow(Percent_DL_Populated) +
'% Home Phone Populated\t\t|' + genRow(Percent_Home_Phone_Populated) +
'% Scored 100\t\t\t\t|' + genRow(Percent_Scored_100) +
'% Scored 200\t\t\t\t|' + genRow(Percent_Scored_200) +
'% Scored 222\t\t\t\t|' + genRow(Percent_Scored_222) +
'% Scored Between 501 - 540\t\t|' + genRow(Percent_Scored_Between_501_540) +
'% Scored Between 541 - 580\t\t|' + genRow(Percent_Scored_Between_541_580) +
'% Scored Between 581 - 620\t\t|' + genRow(Percent_Scored_Between_581_620) +
'% Scored Between 621 - 660\t\t|' + genRow(Percent_Scored_Between_621_660) +
'% Scored Between 661 - 700\t\t|' + genRow(Percent_Scored_Between_661_700) +
'% Scored Between 701 - 740\t\t|' + genRow(Percent_Scored_Between_701_740) +
'% Scored Between 741 - 780\t\t|' + genRow(Percent_Scored_Between_741_780) +
'% Scored Between 781 - 820\t\t|' + genRow(Percent_Scored_Between_781_820) +
'% Scored Between 821 - 860\t\t|' + genRow(Percent_Scored_Between_821_860) +
'% Scored Between 861 - 900\t\t|' + genRow(Percent_Scored_Between_861_900) +
'% Scored Above 900\t\t\t|' + genRow(Percent_Scored_Above_900) +
'% Scored Below 100\t\t\t|' + genRow(Percent_Scored_Below_100) +
'Average Score Excluding Exceptions\t|' + genRow(Average_Score_Excluding_Exceptions, TRUE, TRUE) +
'% Returned Alert Code 100A\t\t|' + genRow(Percent_Alert_100A) +
'% Returned Alert Code 100B\t\t|' + genRow(Percent_Alert_100B) +
'% Returned Alert Code 100C\t\t|' + genRow(Percent_Alert_100C) +
'% Returned Alert Code 100D\t\t|' + genRow(Percent_Alert_100D) +
'% Returned Alert Code 100E\t\t|' + genRow(Percent_Alert_100E) +
'% Returned Alert Code 100F\t\t|' + genRow(Percent_Alert_100F) +
'% Returned Alert Code 200A\t\t|' + genRow(Percent_Alert_200A) +
'% Returned Alert Code 222A\t\t|' + genRow(Percent_Alert_222A) +
'% Returned Reason Code F00\t\t|' + genRow(Percent_RC_F00) +
'% Returned Reason Code F01\t\t|' + genRow(Percent_RC_F01) +
'% Returned Reason Code F02\t\t|' + genRow(Percent_RC_F02) +
'% Returned Reason Code F03\t\t|' + genRow(Percent_RC_F03) +
'% Returned Reason Code F04\t\t|' + genRow(Percent_RC_F04) +
'% Returned Reason Code C10\t\t|' + genRow(Percent_RC_C10) +
'% Returned Reason Code C11\t\t|' + genRow(Percent_RC_C11) +
'% Returned Reason Code C12\t\t|' + genRow(Percent_RC_C12) +
'% Returned Reason Code C13\t\t|' + genRow(Percent_RC_C13) +
'% Returned Reason Code C14\t\t|' + genRow(Percent_RC_C14) +
'% Returned Reason Code C15\t\t|' + genRow(Percent_RC_C15) +
'% Returned Reason Code C16\t\t|' + genRow(Percent_RC_C16) +
'% Returned Reason Code C17\t\t|' + genRow(Percent_RC_C17) +
'% Returned Reason Code C18\t\t|' + genRow(Percent_RC_C18) +
'% Returned Reason Code C19\t\t|' + genRow(Percent_RC_C19) +
'% Returned Reason Code C20\t\t|' + genRow(Percent_RC_C20) +
'% Returned Reason Code C21\t\t|' + genRow(Percent_RC_C21) +
'% Returned Reason Code C22\t\t|' + genRow(Percent_RC_C22) +
'% Returned Reason Code C23\t\t|' + genRow(Percent_RC_C23) +
'% Returned Reason Code D30\t\t|' + genRow(Percent_RC_D30) +
'% Returned Reason Code D31\t\t|' + genRow(Percent_RC_D31) +
'% Returned Reason Code D32\t\t|' + genRow(Percent_RC_D32) +
'% Returned Reason Code D33\t\t|' + genRow(Percent_RC_D33) +
'% Returned Reason Code D34\t\t|' + genRow(Percent_RC_D34) +
'% Returned Reason Code A40\t\t|' + genRow(Percent_RC_A40) +
'% Returned Reason Code A41\t\t|' + genRow(Percent_RC_A41) +
'% Returned Reason Code A42\t\t|' + genRow(Percent_RC_A42) +
'% Returned Reason Code A43\t\t|' + genRow(Percent_RC_A43) +
'% Returned Reason Code A44\t\t|' + genRow(Percent_RC_A44) +
'% Returned Reason Code A45\t\t|' + genRow(Percent_RC_A45) +
'% Returned Reason Code A46\t\t|' + genRow(Percent_RC_A46) +
'% Returned Reason Code A47\t\t|' + genRow(Percent_RC_A47) +
'% Returned Reason Code A48\t\t|' + genRow(Percent_RC_A48) +
'% Returned Reason Code A49\t\t|' + genRow(Percent_RC_A49) +
'% Returned Reason Code A50\t\t|' + genRow(Percent_RC_A50) +
'% Returned Reason Code A51\t\t|' + genRow(Percent_RC_A51) +
'% Returned Reason Code E55\t\t|' + genRow(Percent_RC_E55) +
'% Returned Reason Code E56\t\t|' + genRow(Percent_RC_E56) +
'% Returned Reason Code E57\t\t|' + genRow(Percent_RC_E57) +
'% Returned Reason Code I60\t\t|' + genRow(Percent_RC_I60) +
'% Returned Reason Code I61\t\t|' + genRow(Percent_RC_I61) +
'% Returned Reason Code S65\t\t|' + genRow(Percent_RC_S65) +
'% Returned Reason Code S66\t\t|' + genRow(Percent_RC_S66) +
'% Returned Reason Code L70\t\t|' + genRow(Percent_RC_L70) +
'% Returned Reason Code L71\t\t|' + genRow(Percent_RC_L71) +
'% Returned Reason Code L72\t\t|' + genRow(Percent_RC_L72) +
'% Returned Reason Code L73\t\t|' + genRow(Percent_RC_L73) +
'% Returned Reason Code L74\t\t|' + genRow(Percent_RC_L74) +
'% Returned Reason Code L75\t\t|' + genRow(Percent_RC_L75) +
'% Returned Reason Code L76\t\t|' + genRow(Percent_RC_L76) +
'% Returned Reason Code L77\t\t|' + genRow(Percent_RC_L77) +
'% Returned Reason Code L78\t\t|' + genRow(Percent_RC_L78) +
'% Returned Reason Code L79\t\t|' + genRow(Percent_RC_L79) +
'% Returned Reason Code L80\t\t|' + genRow(Percent_RC_L80) +
'% Returned Reason Code L81\t\t|' + genRow(Percent_RC_L81) +
'% Returned Reason Code P85\t\t|' + genRow(Percent_RC_P85) +
'% Returned Reason Code P86\t\t|' + genRow(Percent_RC_P86) +
'% Returned Reason Code P87\t\t|' + genRow(Percent_RC_P87) +
'% Returned Reason Code P88\t\t|' + genRow(Percent_RC_P88) +
'% Returned Reason Code P89\t\t|' + genRow(Percent_RC_P89) +
'% Returned Reason Code P90\t\t|' + genRow(Percent_RC_P90) +
'\n\n' +
'Workunit ' + STD.Str.ToUpperCase(STD.system.Job.wuid()) + '\n  http://10.173.84.202:8010/?inner=../WsWorkunits/WUInfo?Wuid=' + STD.Str.ToUpperCase(STD.system.Job.wuid());

OUTPUT(emailBody, NAMED('E_Mail_Body_RV2'));


/* ***********************************************************************************************
 *************************************************************************************************
 *                                         SEND THE EMAIL                                        *
 *************************************************************************************************
 *********************************************************************************************** */

subject := 'RiskView 2 Daily Score Monitor';

STD.System.Email.SendEmail(scout.daily_monitoring.Constants.emailRiskView2ReportsTo, subject,
		emailBody,
		GETENV('SMTPserver'),
		(UNSIGNED4)GETENV('SMTPport', '25'),
		'ThorReport@lexisnexis.com');
		
