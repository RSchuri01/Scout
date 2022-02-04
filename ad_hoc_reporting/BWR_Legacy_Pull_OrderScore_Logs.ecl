#workunit('name', 'OrderScore_Pull_SCOUT_Logs');
#STORED('historyfreq', '7yrs');
IMPORT scout, STD;

Product := 'OrderScore';
//Date is in format YYYYMMDD HHMMSS
BeginDate := '20190201';
EndDate := '20190201'; 
eyeball := 100;

AccountIDs := ['']; // Set to a blank string dataset [''] to pull all records except for test transaction login ids

outputFile := '~fallen::out::OrderScore_SCOUT_' + BeginDate + '-' + EndDate + '_' + AccountIDs[1];

BaseScoutFile := scout.logs.keys.key_scorelogs_scout_transactionID.superFileData();
BaseLogFile := scout.logs.keys.key_scorelogs_XMLTransactionID.superFileData();

Pulled_ScoutFile := distribute(pull(BaseScoutFile));

ScoutFile_Raw := IF(AccountIDs[1] != '', Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['ORDERSCORE'] AND datetime[1..8] BETWEEN BeginDate AND EndDate AND (string)company_id IN AccountIDs AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs),
									     Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['ORDERSCORE'] AND datetime[1..8] BETWEEN BeginDate AND EndDate AND STD.Str.ToLowerCase(TRIM(login_id)) NOT IN scout.ad_hoc_reporting.constants.IgnoredLogins AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs));

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

scout.ad_hoc_reporting.Layouts.Parsed_OrderScore_Layout parseInput () := TRANSFORM
	SELF.TransactionID      := TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
	SELF.EndUserCompanyName := TRIM(XMLTEXT('User/EndUser/CompanyName'));
//options
	SELF.OrderType 			:= TRIM(XMLTEXT('Options/OrderType'));
	SELF.DeviceProviderScore1 := TRIM(XMLTEXT('Options/DeviceProviderScore1'));
	SELF.DeviceProviderScore2 := TRIM(XMLTEXT('Options/DeviceProviderScore2'));
	SELF.DeviceProviderScore3 := TRIM(XMLTEXT('Options/DeviceProviderScore3'));
	SELF.DeviceProviderScore4 := TRIM(XMLTEXT('Options/DeviceProviderScore4'));
	SELF.AttributesVersionRequest := TRIM(XMLTEXT('Options/AttributesVersionRequest[1]/Name[1]')) + ' ' + 
															TRIM(XMLTEXT('Options/AttributesVersionRequest[1]/Name[2]')) + ' ' +  
															TRIM(XMLTEXT('Options/AttributesVersionRequest[1]/Name[3]'));
	SELF.Model := TRIM(XMLTEXT('Options/IncludeModels/OrderScore'));
//BillTo
	SELF.FullName       := TRIM(XMLTEXT('SearchBy/BillTo/Name/Full'));
	SELF.FirstName      := TRIM(XMLTEXT('SearchBy/BillTo/Name/First'));
	SELF.MiddleName     := TRIM(XMLTEXT('SearchBy/BillTo/Name/Middle'));
	SELF.LastName       := TRIM(XMLTEXT('SearchBy/BillTo/Name/Last'));
	SELF.SSN            := scout.ad_hoc_reporting.Common.ParseSSN(XMLTEXT('SearchBy/BillTo/SSN'));
	SELF.DOB            := TRIM(XMLTEXT('SearchBy/BillTo/DOB')) + 
												scout.ad_hoc_reporting.Common.ParseDate(XMLTEXT('SearchBy/BillTo/DOB/Year'), 
												XMLTEXT('SearchBy/BillTo/DOB/Month'), XMLTEXT('SearchBy/BillTo/DOB/Day'));
	SELF.Address        := scout.ad_hoc_reporting.Common.ParseAddress(XMLTEXT('SearchBy/BillTo/Address/StreetAddress1'), 
												XMLTEXT('SearchBy/BillTo/Address/StreetAddress2'), 
												XMLTEXT('SearchBy/BillTo/Address/StreetNumber'), 
												XMLTEXT('SearchBy/BillTo/Address/StreetPreDirection'), 
												XMLTEXT('SearchBy/BillTo/Address/StreetName'),
												XMLTEXT('SearchBy/BillTo/Address/StreetSuffix'), 
												XMLTEXT('SearchBy/BillTo/Address/StreetPostDirection'), 
												XMLTEXT('SearchBy/BillTo/Address/UnitDesignation'),
												XMLTEXT('SearchBy/BillTo/Address/UnitNumber'));
	SELF.City           := TRIM(XMLTEXT('SearchBy/BillTo/Address/City'));
	SELF.State          := TRIM(XMLTEXT('SearchBy/BillTo/Address/State'));
	SELF.Zip            := scout.ad_hoc_reporting.Common.ParseZIP(XMLTEXT('SearchBy/BillTo/Address/Zip5'));
	SELF.DL             := TRIM(XMLTEXT('SearchBy/BillTo/DriverLicenseNumber'));
	SELF.DLState        := TRIM(XMLTEXT('SearchBy/BillTo/DriverLicenseState'));

	SELF.HomePhone      := scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/BillTo/Phone10'));
	// SELF.WorkPhone      := scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/WPhone10'));
	SELF.Email          := TRIM(XMLTEXT('SearchBy/BillTo/EmailAddress'));
	SELF.IPAddress      := TRIM(XMLTEXT('SearchBy/BillTo/IPAddress'));
	//Ship to
	SELF.FullName2      := TRIM(XMLTEXT('SearchBy/ShipTo/Name/Full'));
	SELF.FirstName2     := TRIM(XMLTEXT('SearchBy/ShipTo/Name/First'));
	SELF.MiddleName2    := TRIM(XMLTEXT('SearchBy/ShipTo/Name/Middle'));
	SELF.LastName2      := TRIM(XMLTEXT('SearchBy/ShipTo/Name/Last'));
	SELF.DOB2           := TRIM(XMLTEXT('SearchBy/ShipTo/DOB')) + 
												scout.ad_hoc_reporting.Common.ParseDate(XMLTEXT('SearchBy/ShipTo/DOB/Year'), 
												XMLTEXT('SearchBy/ShipTo/DOB/Month'), XMLTEXT('SearchBy/ShipTo/DOB/Day'));
	SELF.Address2       := scout.ad_hoc_reporting.Common.ParseAddress(XMLTEXT('SearchBy/ShipTo/Address/StreetAddress1'), 
												XMLTEXT('SearchBy/ShipTo/Address/StreetAddress2'), 
												XMLTEXT('SearchBy/ShipTo/Address/StreetNumber'), 
												XMLTEXT('SearchBy/ShipTo/Address/StreetPreDirection'), 
												XMLTEXT('SearchBy/ShipTo/Address/StreetName'),
												XMLTEXT('SearchBy/ShipTo/Address/StreetSuffix2'), 
												XMLTEXT('SearchBy/ShipTo/Address/StreetPostDirection'), 
												XMLTEXT('SearchBy/ShipTo/Address/UnitDesignation'),
												XMLTEXT('SearchBy/ShipTo/Address/UnitNumber'));
	SELF.City2          := TRIM(XMLTEXT('SearchBy/ShipTo/Address/City'));
	SELF.State2         := TRIM(XMLTEXT('SearchBy/ShipTo/Address/State'));
	SELF.Zip2           := scout.ad_hoc_reporting.Common.ParseZIP(XMLTEXT('SearchBy/ShipTo/Address/Zip5'));
	SELF.DL2            := TRIM(XMLTEXT('SearchBy/ShipTo/DriverLicenseNumber'));
	SELF.DLState2       := TRIM(XMLTEXT('SearchBy/ShipTo/DriverLicenseState'));
	SELF.HomePhone2     := scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/ShipTo/Phone10'));
	SELF.Email2         := TRIM(XMLTEXT('SearchBy/ShipTo/EmailAddress'));
	
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

	SELF := [];
END;

parsedInput := DISTRIBUTE(PARSE(Good_Logs, inputxml, parseInput(), XML('OrderScore')), HASH64(TransactionID));
OUTPUT(CHOOSEN(parsedInput, eyeball), NAMED('Sample_parsedInput'));


scout.ad_hoc_reporting.Layouts.Parsed_OrderScore_Layout parseOutput () := TRANSFORM
	SELF.TransactionID	:= TRIM(XMLTEXT('Header/TransactionId')); // Forced into the record so I can join it all together

// bill to verified
	self.verFirst:=TRIM(XMLTEXT('Result/BillTo/VerifiedInput/Name/First')) ; 
	self.verMiddle:=	TRIM(XMLTEXT('Result/BillTo/VerifiedInput/Name/Middle')) ; 
	self.verLast:=TRIM(XMLTEXT('Result/BillTo/VerifiedInput/Name/Last')) ; 
	self.verAddress1:=	TRIM(XMLTEXT('Result/BillTo/VerifiedInput/Address/StreetAddress1')) ;
	self.verCity:=	TRIM(XMLTEXT('Result/BillTo/VerifiedInput/Address/City')) ;
	self.verState:=TRIM(XMLTEXT('Result/BillTo/VerifiedInput/Address/State')) ;
	self.verZip5:=TRIM(XMLTEXT('Result/BillTo/VerifiedInput/Address/Zip5')) ;	

// bill to corrected
	self.corrFirst:=TRIM(XMLTEXT('Result/BillTo/InputCorrected/Name/First')) ;
	self.corrMiddle:=	TRIM(XMLTEXT('Result/BillTo/InputCorrected/Name/Middle')) ;
	self.corrLast:=TRIM(XMLTEXT('Result/BillTo/InputCorrected/Name/Last')) ;
	self.corrAddress1:=	TRIM(XMLTEXT('Result/BillTo/InputCorrected/Address/StreetAddress1')) ;
	self.corrCity:=	TRIM(XMLTEXT('Result/BillTo/InputCorrected/Address/City')) ;
	self.corrState:=TRIM(XMLTEXT('Result/BillTo/InputCorrected/Address/State')) ;
	self.corrZip5:=TRIM(XMLTEXT('Result/BillTo/InputCorrected/Address/Zip5')) ; 	
	self.corrphone:=TRIM(XMLTEXT('Result/BillTo/InputCorrected/Phone10')) ;	
	self.corrssn:=TRIM(XMLTEXT('Result/BillTo/InputCorrected/SSN')) ; 
//extras	

	self.phnameaddr := TRIM(XMLTEXT('Result/BillTo/PhoneOfNameAddress')) ;	
	self.nas := TRIM(XMLTEXT('Result/BillTo/NameAddressSSNSummary')) ;	
	self.nap :=TRIM(XMLTEXT('Result/BillTo/NameAddressPhoneSummary')) ;	
	self.sic := TRIM(XMLTEXT('Result/BillTo/SIC')) ;	
	self.phonetype := TRIM(XMLTEXT('Result/BillTo/PhoneType')) ;	
	self.dwelltype := TRIM(XMLTEXT('Result/BillTo/DwellingType')) ;	
	SELF.areacode := (string) TRIM(XMLTEXT('Result/BillTo/NewAreaCode/AreaCode')) ;	

	SELF.EffectiveDate	:= TRIM(XMLTEXT('Result/BillTo/NewAreaCode/EffectiveDate')) + 
												scout.ad_hoc_reporting.Common.ParseDate(XMLTEXT('Result/BillTo/NewAreaCode/EffectiveDate/Year'), 
												XMLTEXT('Result/BillTo/NewAreaCode/EffectiveDate/Month'), 
												XMLTEXT('Result/BillTo/NewAreaCode/EffectiveDate/Day'));

//ship to
	self.verFirst2 := TRIM(XMLTEXT('Result/ShipTo/VerifiedInput/Name/First')) ; 
	self.verMiddle2 := 	TRIM(XMLTEXT('Result/ShipTo/VerifiedInput/Name/Middle')) ; 
	self.verLast2 := TRIM(XMLTEXT('Result/ShipTo/VerifiedInput/Name/Last')) ; 
	self.verAddress2 := 	TRIM(XMLTEXT('Result/ShipTo/VerifiedInput/Address/StreetAddress1')) ;
	self.verCity2 := 	TRIM(XMLTEXT('Result/ShipTo/VerifiedInput/Address/City')) ;
	self.verState2 := TRIM(XMLTEXT('Result/ShipTo/VerifiedInput/Address/State')) ;
	self.verZip52 := TRIM(XMLTEXT('Result/ShipTo/VerifiedInput/Address/Zip5')) ;	
	// ship to corrected
	self.corrFirst2 :=TRIM(XMLTEXT('Result/ShipTo/InputCorrected/Name/First')) ;
	self.corrMiddle2 :=	TRIM(XMLTEXT('Result/ShipTo/InputCorrected/Name/Middle')) ;
	self.corrLast2 :=TRIM(XMLTEXT('Result/ShipTo/InputCorrected/Name/Last')) ;
	self.corrAddress2 :=	TRIM(XMLTEXT('Result/ShipTo/InputCorrected/Address/StreetAddress1')) ;
	self.corrCity2 :=	TRIM(XMLTEXT('Result/ShipTo/InputCorrected/Address/City')) ;
	self.corrState2 :=TRIM(XMLTEXT('Result/ShipTo/InputCorrected/Address/State')) ;
	self.corrZip52 :=TRIM(XMLTEXT('Result/ShipTo/InputCorrected/Address/Zip5')) ; 	
	self.corrphone2 :=TRIM(XMLTEXT('Result/ShipTo/InputCorrected/Phone10')) ;	
	self.corrssn2 :=TRIM(XMLTEXT('Result/ShipTo/InputCorrected/SSN')) ; 
//extras
	self.phnameaddr2 := TRIM(XMLTEXT('Result/ShipTo/PhoneOfNameAddress')) ;	
	self.nas2 := TRIM(XMLTEXT('Result/ShipTo/NameAddressSSNSummary')) ;	
	self.nap2 :=TRIM(XMLTEXT('Result/ShipTo/NameAddressPhoneSummary')) ;	
	self.sic2 := TRIM(XMLTEXT('Result/ShipTo/SIC')) ;	
	self.phonetype2 := TRIM(XMLTEXT('Result/ShipTo/PhoneType')) ;	
	self.dwelltype2 := TRIM(XMLTEXT('Result/ShipTo/DwellingType')) ;	
	SELF.areacode2 := (string) TRIM(XMLTEXT('Result/ShipTo/NewAreaCode/AreaCode')) ;	
	SELF.EffectiveDate2	:= TRIM(XMLTEXT('Result/ShipTo/NewAreaCode/EffectiveDate')) + 
												scout.ad_hoc_reporting.Common.ParseDate(XMLTEXT('Result/ShipTo/NewAreaCode/EffectiveDate/Year'), 
												XMLTEXT('Result/ShipTo/NewAreaCode/EffectiveDate/Month'), 
												XMLTEXT('Result/ShipTo/NewAreaCode/EffectiveDate/Day'));
	
	//bill to score info
	self.model := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Name'));
	self.modeltype := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/Type'));
	self.score := (string) TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/Value'));	
	self.riname := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/Name'));
	self.RC1 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[1]/RiskCode'));	
	self.ridesc := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[1]/Description'));
	self.riseq := (STRING) TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[1]/Sequence'));
	self.RC2 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[2]/RiskCode'));
	self.ridesc2 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[2]/Description'));
	self.riseq2 := (STRING) TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[2]/Sequence'));
	self.riname2 := if(self.riseq2 != '', TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/Name')), '');
	self.RC3 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[3]/RiskCode'));
	self.ridesc3 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[3]/Description'));
	self.riseq3 := (STRING) TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[3]/Sequence'));
	self.riname3 := if(self.riseq3 != '', TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/Name')), '');
	self.RC4 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[4]/RiskCode'));
	self.ridesc4 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[4]/Description'));
	self.riseq4 := (STRING) TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[4]/Sequence'));
	self.riname4 := if(self.riseq4 != '', TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/Name')), '');
	self.RC5 :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[5]/RiskCode'));
	self.ridesc5 :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[5]/Description'));
	self.riseq5 := (STRING) TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[5]/Sequence'));
	self.riname5 := if(self.riseq5 != '', TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/Name')), '');
	self.RC6 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[6]/RiskCode'));
	self.ridesc6 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[6]/Description'));
	self.riseq6 :=(STRING) TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/RiskIndicators[1]/RiskIndicator[6]/Sequence'));
	self.riname6 := if(self.riseq6 != '', TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[1]/Name')), '');

	//ship to score info
	self.RC7 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[1]/RiskCode'));	
	self.ridesc7 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[1]/Description'));
	self.riseq7 := (STRING) TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[1]/Sequence'));
	self.riname7 := if(self.riseq7 != '', TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/Name')), '');
	self.RC8 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[2]/RiskCode'));
	self.ridesc8 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[2]/Description'));
	self.riseq8 := (STRING) TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[2]/Sequence'));
	self.riname8 := if(self.riseq8 != '', TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/Name')), '');
	self.RC9 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[3]/RiskCode'));
	self.ridesc9 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[3]/Description'));
	self.riseq9 := (STRING) TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[3]/Sequence'));
	self.riname9 := if(self.riseq9 != '', TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/Name')), '');
	self.RC10 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[4]/RiskCode'));
	self.ridesc10 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[4]/Description'));
	self.riseq10 := (STRING) TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[4]/Sequence'));
	self.riname10 :=if(self.riseq10 != '',  TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/Name')), '');
	self.RC11 :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[5]/RiskCode'));
	self.ridesc11 :=TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[5]/Description'));
	self.riseq11 := (STRING) TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[5]/Sequence'));
	self.riname11 := if(self.riseq11 != '', TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/Name')), '');
	self.RC12 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[6]/RiskCode'));
	self.ridesc12 := TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[6]/Description'));
	self.riseq12 :=(STRING) TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/RiskIndicators[1]/RiskIndicator[6]/Sequence'));
	self.riname12 := if(self.riseq12 != '', TRIM(XMLTEXT('Result/Models[1]/Model[1]/Scores[1]/Score[1]/RiskIndicatorSets[1]/RiskIndicatorSet[2]/Name')), '');
	
	self.ipcontinen := TRIM(XMLTEXT('Result/IPAddressID/Continent'));
	self.iproutetyp := TRIM(XMLTEXT('Result/IPAddressID/RoutingType'));
	self.topdomain := TRIM(XMLTEXT('Result/IPAddressID/TopLevelDomain'));
	self.iparea := TRIM(XMLTEXT('Result/IPAddressID/AreaCode'));
	self.secdomain := TRIM(XMLTEXT('Result/IPAddressID/SecondLevelDomain'));
	self.ipcountry := TRIM(XMLTEXT('Result/IPAddressID/Country'));
	self.ipstate :=TRIM(XMLTEXT('Result/IPAddressID/State'));
	self.ipzip := TRIM(XMLTEXT('Result/IPAddressID/Zip')); 
 
	//attributes
  SELF.Attribute1Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[1]/Value'));
  SELF.Attribute1Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[1]/Name')) ;  
	SELF.Attribute2Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[2]/Name')) ;
  SELF.Attribute2Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[2]/Value')) ;
  SELF.Attribute3Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[3]/Name')) ;
  SELF.Attribute3Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[3]/Value')) ;
  SELF.Attribute4Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[4]/Name')) ;
  SELF.Attribute4Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[4]/Value')) ;
  SELF.Attribute5Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[5]/Name')) ;
  SELF.Attribute5Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[5]/Value')) ;
  SELF.Attribute6Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[6]/Name')) ;
  SELF.Attribute6Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[6]/Value'));
  SELF.Attribute7Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[7]/Name')) ;
  SELF.Attribute7Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[7]/Value')) ;
  SELF.Attribute8Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[8]/Name')) ;
  SELF.Attribute8Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[8]/Value')) ;
  SELF.Attribute9Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[9]/Name')) ;
  SELF.Attribute9Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[9]/Value')) ;
  SELF.Attribute10Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[10]/Name')) ;
  SELF.Attribute10Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[10]/Value'));
  SELF.Attribute11Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[11]/Name')) ;
  SELF.Attribute11Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[11]/Value'));
  SELF.Attribute12Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[12]/Name')) ;
  SELF.Attribute12Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[12]/Value'));
  SELF.Attribute13Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[13]/Name')) ;
  SELF.Attribute13Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[13]/Value'));
  SELF.Attribute14Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[14]/Name')) ;
  SELF.Attribute14Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[14]/Value'));
  SELF.Attribute15Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[15]/Name')) ;
  SELF.Attribute15Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[15]/Value'));
  SELF.Attribute16Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[16]/Name')) ;
  SELF.Attribute16Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[16]/Value'));
  SELF.Attribute17Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[17]/Name')) ;
  SELF.Attribute17Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[17]/Value'));
  SELF.Attribute18Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[18]/Name')) ;
  SELF.Attribute18Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[18]/Value'));
  SELF.Attribute19Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[19]/Name')) ;
  SELF.Attribute19Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[19]/Value'));
  SELF.Attribute20Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[20]/Name')) ;
  SELF.Attribute20Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[20]/Value'));
  SELF.Attribute21Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[21]/Name')) ;
  SELF.Attribute21Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[21]/Value'));
  SELF.Attribute22Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[22]/Name')) ;
  SELF.Attribute22Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[22]/Value'));
  SELF.Attribute23Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[23]/Name')) ;
  SELF.Attribute23Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[23]/Value'));
  SELF.Attribute24Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[24]/Name')) ;
  SELF.Attribute24Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[24]/Value'));
  SELF.Attribute25Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[25]/Name')) ;
  SELF.Attribute25Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[25]/Value'));
  SELF.Attribute26Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[26]/Name')) ;
  SELF.Attribute26Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[26]/Value'));
  SELF.Attribute27Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[27]/Name')) ;
  SELF.Attribute27Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[27]/Value'));
  SELF.Attribute28Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[28]/Name')) ;
  SELF.Attribute28Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[28]/Value'));
  SELF.Attribute29Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[29]/Name')) ;
  SELF.Attribute29Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[29]/Value'));
  SELF.Attribute30Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[30]/Name')) ;
  SELF.Attribute30Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[30]/Value'));
  SELF.Attribute31Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[31]/Name')) ;
  SELF.Attribute31Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[31]/Value'));
  SELF.Attribute32Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[32]/Name')) ;
  SELF.Attribute32Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[32]/Value'));
  SELF.Attribute33Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[33]/Name')) ;
  SELF.Attribute33Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[33]/Value'));
  SELF.Attribute34Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[34]/Name')) ;
  SELF.Attribute34Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[34]/Value'));
  SELF.Attribute35Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[35]/Name')) ;
  SELF.Attribute35Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[35]/Value'));
  SELF.Attribute36Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[36]/Name')) ;
  SELF.Attribute36Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[36]/Value'));
  SELF.Attribute37Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[37]/Name')) ;
  SELF.Attribute37Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[37]/Value'));
  SELF.Attribute38Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[38]/Name')) ;
  SELF.Attribute38Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[38]/Value'));
  SELF.Attribute39Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[39]/Name')) ;
  SELF.Attribute39Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[39]/Value'));
  SELF.Attribute40Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[40]/Name')) ;
  SELF.Attribute40Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[40]/Value'));
  SELF.Attribute41Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[41]/Name')) ;
  SELF.Attribute41Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[41]/Value'));
  SELF.Attribute42Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[42]/Name')) ;
  SELF.Attribute42Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[42]/Value'));
  SELF.Attribute43Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[43]/Name')) ;
  SELF.Attribute43Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[43]/Value'));
  SELF.Attribute44Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[44]/Name')) ;
  SELF.Attribute44Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[44]/Value'));
  SELF.Attribute45Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[45]/Name')) ;
  SELF.Attribute45Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[45]/Value'));
  SELF.Attribute46Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[46]/Name')) ;
  SELF.Attribute46Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[46]/Value'));
  SELF.Attribute47Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[47]/Name')) ;
  SELF.Attribute47Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[47]/Value'));
  SELF.Attribute48Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[48]/Name')) ;
  SELF.Attribute48Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[48]/Value'));
  SELF.Attribute49Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[49]/Name')) ;
  SELF.Attribute49Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[49]/Value'));
  SELF.Attribute50Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[50]/Name')) ;
  SELF.Attribute50Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[50]/Value'));
  SELF.Attribute51Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[51]/Name')) ;
  SELF.Attribute51Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[51]/Value'));
  SELF.Attribute52Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[52]/Name')) ;
  SELF.Attribute52Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[52]/Value'));
  SELF.Attribute53Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[53]/Name')) ;
  SELF.Attribute53Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[53]/Value'));
  SELF.Attribute54Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[54]/Name')) ;
  SELF.Attribute54Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[54]/Value'));
  SELF.Attribute55Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[55]/Name')) ;
  SELF.Attribute55Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[55]/Value'));
  SELF.Attribute56Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[56]/Name')) ;
  SELF.Attribute56Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[56]/Value'));
  SELF.Attribute57Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[57]/Name')) ;
  SELF.Attribute57Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[57]/Value'));
  SELF.Attribute58Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[58]/Name')) ;
  SELF.Attribute58Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[58]/Value'));
  SELF.Attribute59Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[59]/Name')) ;
  SELF.Attribute59Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[59]/Value'));
  SELF.Attribute60Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[60]/Name')) ;
  SELF.Attribute60Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[60]/Value'));
  SELF.Attribute61Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[61]/Name')) ;
  SELF.Attribute61Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[61]/Value'));
  SELF.Attribute62Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[62]/Name')) ;
  SELF.Attribute62Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[62]/Value'));
  SELF.Attribute63Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[63]/Name')) ;
  SELF.Attribute63Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[63]/Value'));
  SELF.Attribute64Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[64]/Name')) ;
  SELF.Attribute64Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[64]/Value'));
  SELF.Attribute65Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[65]/Name')) ;
  SELF.Attribute65Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[65]/Value'));
  SELF.Attribute66Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[66]/Name')) ;
  SELF.Attribute66Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[66]/Value'));
  SELF.Attribute67Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[67]/Name')) ;
  SELF.Attribute67Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[67]/Value'));
  SELF.Attribute68Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[68]/Name')) ;
  SELF.Attribute68Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[68]/Value'));
  SELF.Attribute69Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[69]/Name')) ;
  SELF.Attribute69Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[69]/Value'));
  SELF.Attribute70Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[70]/Name')) ;
  SELF.Attribute70Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[70]/Value'));
  SELF.Attribute71Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[71]/Name')) ;
  SELF.Attribute71Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[71]/Value'));
  SELF.Attribute72Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[72]/Name')) ;
  SELF.Attribute72Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[72]/Value'));
  SELF.Attribute73Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[73]/Name')) ;
  SELF.Attribute73Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[73]/Value'));
  SELF.Attribute74Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[74]/Name')) ;
  SELF.Attribute74Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[74]/Value'));
  SELF.Attribute75Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[75]/Name')) ;
  SELF.Attribute75Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[75]/Value'));
  SELF.Attribute76Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[76]/Name')) ;
  SELF.Attribute76Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[76]/Value'));
  SELF.Attribute77Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[77]/Name')) ;
  SELF.Attribute77Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[77]/Value'));
  SELF.Attribute78Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[78]/Name')) ;
  SELF.Attribute78Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[78]/Value'));
  SELF.Attribute79Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[79]/Name')) ;
  SELF.Attribute79Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[79]/Value'));
  SELF.Attribute80Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[80]/Name')) ;
  SELF.Attribute80Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[80]/Value'));
  SELF.Attribute81Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[81]/Name')) ;
  SELF.Attribute81Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[81]/Value'));
  SELF.Attribute82Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[82]/Name')) ;
  SELF.Attribute82Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[82]/Value'));
  SELF.Attribute83Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[83]/Name')) ;
  SELF.Attribute83Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[83]/Value'));
  SELF.Attribute84Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[84]/Name')) ;
  SELF.Attribute84Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[84]/Value'));
  SELF.Attribute85Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[1]/Name')) ;
  SELF.Attribute85Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[1]/Value'));
  SELF.Attribute86Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[2]/Name')) ;
  SELF.Attribute86Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[2]/Value'));
  SELF.Attribute87Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[3]/Name')) ;
  SELF.Attribute87Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[3]/Value'));
  SELF.Attribute88Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[4]/Name')) ;
  SELF.Attribute88Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[4]/Value'));
  SELF.Attribute89Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[5]/Name')) ;
  SELF.Attribute89Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[5]/Value'));
  SELF.Attribute90Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[6]/Name')) ;
  SELF.Attribute90Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[6]/Value'));
  SELF.Attribute91Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[7]/Name')) ;
  SELF.Attribute91Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[7]/Value'));
  SELF.Attribute92Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[8]/Name')) ;
  SELF.Attribute92Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[8]/Value'));
  SELF.Attribute93Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[9]/Name')) ;
  SELF.Attribute93Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[9]/Value'));
  SELF.Attribute94Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[10]/Name')) ;
  SELF.Attribute94Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[10]/Value'));
  SELF.Attribute95Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[11]/Name')) ;
  SELF.Attribute95Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[11]/Value'));
  SELF.Attribute96Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[12]/Name')) ;
  SELF.Attribute96Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[12]/Value'));
  SELF.Attribute97Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[13]/Name')) ;
  SELF.Attribute97Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[13]/Value'));
  SELF.Attribute98Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[14]/Name')) ;
  SELF.Attribute98Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[14]/Value'));
  SELF.Attribute99Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[15]/Name')) ;
  SELF.Attribute99Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[15]/Value'));
  SELF.Attribute100Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[1]/Name'));
  SELF.Attribute100Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[1]/Value'));
  SELF.Attribute101Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[2]/Name')) ;
  SELF.Attribute101Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[2]/Value'));
  SELF.Attribute102Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[3]/Name')) ;
  SELF.Attribute102Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[3]/Value'));
  SELF.Attribute103Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[4]/Name')) ;
  SELF.Attribute103Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[4]/Value'));
  SELF.Attribute104Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[5]/Name')) ;
  SELF.Attribute104Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[5]/Value'));
  SELF.Attribute105Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[6]/Name')) ;
  SELF.Attribute105Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[6]/Value'));
  SELF.Attribute106Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[7]/Name')) ;
  SELF.Attribute106Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[7]/Value'));
  SELF.Attribute107Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[8]/Name')) ;
  SELF.Attribute107Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[8]/Value'));
  SELF.Attribute108Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[9]/Name')) ;
  SELF.Attribute108Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[9]/Value'));
  SELF.Attribute109Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[10]/Name')) ;
  SELF.Attribute109Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[10]/Value'));
  SELF.Attribute110Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[11]/Name')) ;
  SELF.Attribute110Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[11]/Value'));
  SELF.Attribute111Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[12]/Name')) ;
  SELF.Attribute111Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[12]/Value'));
  SELF.Attribute112Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[13]/Name')) ;
  SELF.Attribute112Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[13]/Value'));
  SELF.Attribute113Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[14]/Name')) ;
  SELF.Attribute113Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[14]/Value'));
  SELF.Attribute114Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[15]/Name')) ;
  SELF.Attribute114Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[15]/Value'));
  SELF.Attribute115Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[16]/Name')) ;
  SELF.Attribute115Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[16]/Value'));
  SELF.Attribute116Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[17]/Name')) ;
  SELF.Attribute116Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[17]/Value'));
  SELF.Attribute117Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[18]/Name')) ;
  SELF.Attribute117Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[18]/Value'));
  SELF.Attribute118Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[19]/Name')) ;
  SELF.Attribute118Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[19]/Value'));
  SELF.Attribute119Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[20]/Name')) ;
  SELF.Attribute119Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[20]/Value'));
  SELF.Attribute120Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[21]/Name')) ;
  SELF.Attribute120Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[21]/Value'));
  SELF.Attribute121Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[22]/Name')) ;
  SELF.Attribute121Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[22]/Value'));
  SELF.Attribute122Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[23]/Name')) ;
  SELF.Attribute122Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[23]/Value'));
  SELF.Attribute123Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[24]/Name')) ;
  SELF.Attribute123Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[24]/Value'));
  SELF.Attribute124Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[25]/Name')) ;
  SELF.Attribute124Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[25]/Value'));
  SELF.Attribute125Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[26]/Name')) ;
  SELF.Attribute125Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[26]/Value'));
  SELF.Attribute126Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[27]/Name')) ;
  SELF.Attribute126Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[27]/Value'));
  SELF.Attribute127Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[28]/Name')) ;
  SELF.Attribute127Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[28]/Value'));
  SELF.Attribute128Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[29]/Name')) ;
  SELF.Attribute128Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[29]/Value'));
  SELF.Attribute129Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[30]/Name')) ;
  SELF.Attribute129Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[30]/Value'));
  SELF.Attribute130Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[31]/Name')) ;
  SELF.Attribute130Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[31]/Value'));
  SELF.Attribute131Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[32]/Name')) ;
  SELF.Attribute131Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[32]/Value'));
                                                                                                                             
	self := [];
 
  END;
  
parsedOutput := PARSE(Good_Logs, outputxml, parseOutput(), XML('OrderScore'));
OUTPUT(CHOOSEN(parsedOutput, eyeball), NAMED('Sample_Parsed_Output'));
  
 scout.ad_hoc_reporting.Layouts.Parsed_OrderScore_Layout combineParsedRecords(scout.ad_hoc_reporting.Layouts.Parsed_OrderScore_Layout le, scout.ad_hoc_reporting.Layouts.Parsed_OrderScore_Layout ri) := TRANSFORM
	SELF.TransactionID	:= le.TransactionId;
	SELF.EndUserCompanyName := le.EndUserCompanyName;
//options
	SELF.OrderType              := le.OrderType;
	SELF.DeviceProviderScore1   := le.DeviceProviderScore1;
	SELF.DeviceProviderScore2   := le.DeviceProviderScore2;
	SELF.DeviceProviderScore3   := le.DeviceProviderScore3;
	SELF.DeviceProviderScore4   := le.DeviceProviderScore4;
	SELF.AttributesVersionRequest := le.AttributesVersionRequest;
	SELF.Model := le.Model;
//BillTo
	SELF.FullName   := le.FullName;
	SELF.FirstName  := le.FirstName;
	SELF.MiddleName := le.MiddleName;
	SELF.LastName   := le.LastName;
	SELF.SSN        := le.SSN;
	SELF.DOB        := le.DOB ;
	SELF.Address    := le.Address;
	SELF.City       := le.City;
	SELF.State      := le.State;
	SELF.Zip        := le.zip;
	SELF.DL         := le.DL;
	SELF.DLState    := le.DLState;

	SELF.HomePhone  := le.HomePhone;
	// SELF.WorkPhone  := scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/WPhone10'));
	SELF.Email      := le.Email;
	SELF.IPAddress  := le.IPAddress;
	//Ship to
	SELF.FullName2      := le.FullName2;
	SELF.FirstName2     := le.FirstName2;
	SELF.MiddleName2    := le.MiddleName2;
	SELF.LastName2      := le.LastName2;
	SELF.DOB2           := le.DOB2;
	SELF.Address2       := le.Address2;
	SELF.City2          := le.City2;
	SELF.State2         := le.State2;
	SELF.Zip2           := le.Zip2;
	SELF.DL2            := le.DL2;
	SELF.DLState2       := le.DLState2;
	SELF.HomePhone2     := le.HomePhone2;
	SELF.Email2         := le.Email2;
	SELF.OptionName1    := le.OptionName1  ;
	SELF.OptionValue1   := le.OptionValue1 ;
	SELF.OptionName2    := le.OptionName2  ;
	SELF.OptionValue2   := le.OptionValue2 ;
	SELF.OptionName3    := le.OptionName3  ;
	SELF.OptionValue3   := le.OptionValue3 ;
	SELF.OptionName4    := le.OptionName4  ;
	SELF.OptionValue4   := le.OptionValue4 ;
	SELF.OptionName5    := le.OptionName5  ;
	SELF.OptionValue5   := le.OptionValue5 ;
	SELF.OptionName6    := le.OptionName6  ;
	SELF.OptionValue6   := le.OptionValue6 ;
	SELF.OptionName7    := le.OptionName7  ;
	SELF.OptionValue7   := le.OptionValue7 ;
	SELF.OptionName8    := le.OptionName8  ;
	SELF.OptionValue8   := le.OptionValue8 ;
	SELF.OptionName9    := le.OptionName9  ;
	SELF.OptionValue9   := le.OptionValue9 ;
	SELF.OptionName10   := le.OptionName10 ;
	SELF.OptionValue10  := le.OptionValue10;	
	SELF := ri;
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
