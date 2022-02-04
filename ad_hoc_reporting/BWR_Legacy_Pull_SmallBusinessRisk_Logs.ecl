#workunit('name', 'Small_Business_Risk_Pull_SCOUT_Logs');
#STORED('historyfreq', '7yrs');
IMPORT scout, STD;

Product := 'SmallBusinessRisk';
//Date is in format YYYYMMDD HHMMSS
BeginDate := '20190201';
EndDate := '20190201'; 
eyeball := 100;  

AccountIDs := ['']; // Set to a blank string dataset [''] to pull all records except for test transaction login ids

outputFile := '~fallen::out::Small_Business_Risk_SCOUT_' + BeginDate + '-' + EndDate + '_' + AccountIDs[1];

BaseScoutFile := scout.logs.keys.key_scorelogs_scout_transactionID.superFileData();
BaseLogFile := scout.logs.keys.key_scorelogs_XMLTransactionID.superFileData();

Pulled_ScoutFile := distribute(pull(BaseScoutFile));

ScoutFile_Raw := IF(AccountIDs[1] != '', Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['SMALLBUSINESSRISK'] AND datetime[1..8] BETWEEN BeginDate AND EndDate AND (string)company_id IN AccountIDs AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs),
									     Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['SMALLBUSINESSRISK'] AND datetime[1..8] BETWEEN BeginDate AND EndDate AND STD.Str.ToLowerCase(TRIM(login_id)) NOT IN scout.ad_hoc_reporting.constants.IgnoredLogins AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs));

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
				
scout.ad_hoc_reporting.Layouts.Parsed_SmallBusinessRisk_Layout parseInput () := TRANSFORM
	SELF.TransactionID      := TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
	SELF.EndUserCompanyName := TRIM(XMLTEXT('User/EndUser/CompanyName'));
	SELF.CompanyName        := TRIM(XMLTEXT('SearchBy/Business/Name'));
	SELF.CompanyAddress     := scout.ad_hoc_reporting.Common.ParseAddress(XMLTEXT('SearchBy/Business/Address/StreetAddress1'), XMLTEXT('SearchBy/Business/Address/StreetAddress2'));
	SELF.CompanyCity        := TRIM(XMLTEXT('SearchBy/Business/Address/City'));
	SELF.CompanyState       := TRIM(XMLTEXT('SearchBy/Business/Address/State'));
	SELF.CompanyZIP         := scout.ad_hoc_reporting.Common.ParseZIP(XMLTEXT('SearchBy/Business/Address/Zip5'));
	SELF.FEIN               := TRIM(XMLTEXT('SearchBy/Business/FEIN'));
	SELF.CompanyPhone10     := scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/Business/Phone10'));
	SELF.RepFirstName       := TRIM(XMLTEXT('SearchBy/OwnerAgent/Name/First'));
	SELF.RepLastName        := TRIM(XMLTEXT('SearchBy/OwnerAgent/Name/Last'));
	SELF.RepSSN             := scout.ad_hoc_reporting.Common.ParseSSN(XMLTEXT('SearchBy/OwnerAgent/SSN'));
	SELF.RepDOB             := scout.ad_hoc_reporting.Common.ParseDate(XMLTEXT('SearchBy/OwnerAgent/DOB/Year'), XMLTEXT('SearchBy/OwnerAgent/DOB/Month'), XMLTEXT('SearchBy/OwnerAgent/DOB/Day'));
	SELF.RepAddress         := scout.ad_hoc_reporting.Common.ParseAddress(XMLTEXT('SearchBy/OwnerAgent/Address/StreetAddress1'), XMLTEXT('SearchBy/OwnerAgent/Address/StreetAddress2'));
	SELF.RepCity            := TRIM(XMLTEXT('SearchBy/OwnerAgent/Address/City'));
	SELF.RepState           := TRIM(XMLTEXT('SearchBy/OwnerAgent/Address/State'));
	SELF.RepZip             := scout.ad_hoc_reporting.Common.ParseZIP(XMLTEXT('SearchBy/OwnerAgent/Address/Zip5'));
	SELF.RepDL              := TRIM(XMLTEXT('SearchBy/OwnerAgent/DriverLicenseNumber'));
	SELF.RepDLState         := TRIM(XMLTEXT('SearchBy/OwnerAgent/DriverLicenseState'));
	SELF.RepPhone10         := scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/OwnerAgent/Phone10'));
	
	SELF := [];
END;

parsedInput := PARSE(Good_Logs, inputxml, parseInput(), XML('SmallBusinessRisk'));
OUTPUT(CHOOSEN(parsedInput, eyeball), NAMED('Sample_Parsed_Input'));


scout.ad_hoc_reporting.Layouts.Parsed_SmallBusinessRisk_Layout parseOutput () := TRANSFORM
	SELF.TransactionID	:= TRIM(XMLTEXT('Header/TransactionId')); // Forced into the record so I can join it all together

	SELF.ModelName		:= TRIM(XMLTEXT('Result/Models/Model[1]/Name'));
	SELF.ModelScore		:= TRIM(XMLTEXT('Result/Models/Model[1]/Scores/Score[1]/Value'));
	SELF.ModelType		:= TRIM(XMLTEXT('Result/Models/Model[1]/Scores/Score[1]/Type'));
	SELF.BusinessRC1	:= TRIM(XMLTEXT('Result/Models/Model[1]/Scores/Score[1]/BusinessHighRiskIndicators/HighRiskIndicator[1]/RiskCode'));
	SELF.BusinessRC2	:= TRIM(XMLTEXT('Result/Models/Model[1]/Scores/Score[1]/BusinessHighRiskIndicators/HighRiskIndicator[2]/RiskCode'));
	SELF.BusinessRC3	:= TRIM(XMLTEXT('Result/Models/Model[1]/Scores/Score[1]/BusinessHighRiskIndicators/HighRiskIndicator[3]/RiskCode'));
	SELF.BusinessRC4	:= TRIM(XMLTEXT('Result/Models/Model[1]/Scores/Score[1]/BusinessHighRiskIndicators/HighRiskIndicator[4]/RiskCode'));
	SELF.BusinessRC5	:= TRIM(XMLTEXT('Result/Models/Model[1]/Scores/Score[1]/BusinessHighRiskIndicators/HighRiskIndicator[5]/RiskCode'));
	SELF.BusinessRC6	:= TRIM(XMLTEXT('Result/Models/Model[1]/Scores/Score[1]/BusinessHighRiskIndicators/HighRiskIndicator[6]/RiskCode'));
	SELF.RepRC1				:= TRIM(XMLTEXT('Result/Models/Model[1]/Scores/Score[1]/OwnerAgentHighRiskIndicators/HighRiskIndicator[1]/RiskCode'));
	SELF.RepRC2				:= TRIM(XMLTEXT('Result/Models/Model[1]/Scores/Score[1]/OwnerAgentHighRiskIndicators/HighRiskIndicator[2]/RiskCode'));
	SELF.RepRC3				:= TRIM(XMLTEXT('Result/Models/Model[1]/Scores/Score[1]/OwnerAgentHighRiskIndicators/HighRiskIndicator[3]/RiskCode'));
	SELF.RepRC4				:= TRIM(XMLTEXT('Result/Models/Model[1]/Scores/Score[1]/OwnerAgentHighRiskIndicators/HighRiskIndicator[4]/RiskCode'));
	SELF.RepRC5				:= TRIM(XMLTEXT('Result/Models/Model[1]/Scores/Score[1]/OwnerAgentHighRiskIndicators/HighRiskIndicator[5]/RiskCode'));
	SELF.RepRC6				:= TRIM(XMLTEXT('Result/Models/Model[1]/Scores/Score[1]/OwnerAgentHighRiskIndicators/HighRiskIndicator[6]/RiskCode'));

	SELF := [];
END;

parsedOutput := PARSE(Good_Logs, outputxml, parseOutput(), XML('SmallBusinessRisk'));
OUTPUT(CHOOSEN(parsedOutput, eyeball), NAMED('Sample_Parsed_Output'));


scout.ad_hoc_reporting.Layouts.Parsed_SmallBusinessRisk_Layout combineParsedRecords(scout.ad_hoc_reporting.Layouts.Parsed_SmallBusinessRisk_Layout le, scout.ad_hoc_reporting.Layouts.Parsed_SmallBusinessRisk_Layout ri) := TRANSFORM
	SELF.ModelName		:= ri.ModelName	  ;
	SELF.ModelScore		:= ri.ModelScore	;
	SELF.ModelType		:= ri.ModelType	  ;
	SELF.BusinessRC1	:= ri.BusinessRC1 ;
	SELF.BusinessRC2	:= ri.BusinessRC2 ;
	SELF.BusinessRC3	:= ri.BusinessRC3 ;
	SELF.BusinessRC4	:= ri.BusinessRC4 ;
	SELF.BusinessRC5	:= ri.BusinessRC5 ;
	SELF.BusinessRC6	:= ri.BusinessRC6 ;
	SELF.RepRC1				:= ri.RepRC1			;
	SELF.RepRC2				:= ri.RepRC2			;
	SELF.RepRC3				:= ri.RepRC3			;
	SELF.RepRC4				:= ri.RepRC4			;
	SELF.RepRC5				:= ri.RepRC5			;
	SELF.RepRC6				:= ri.RepRC6			;
	
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
