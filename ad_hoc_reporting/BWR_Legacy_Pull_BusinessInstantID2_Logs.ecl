#workunit('name', 'Business_Instant_ID_2_Pull_SCOUT_Logs');
#STORED('historyfreq', '7yrs');
IMPORT scout, STD;

Product := 'BusinessInstantID2';
//Date is in format YYYYMMDD HHMMSS   
BeginDate := '20190201';
EndDate := '20190201';
eyeball := 100;

AccountIDs := ['']; // Set to a blank string dataset [''] to pull all records except for test transaction login ids

outputFile := '~fallen::out::BusinessInstantID2_SCOUT_' + BeginDate + '-' + EndDate + '_' + AccountIDs[1];

BaseScoutFile := scout.logs.keys.key_scorelogs_scout_transactionID.superFileData();
BaseLogFile := scout.logs.keys.key_scorelogs_XMLTransactionID.superFileData();

Pulled_ScoutFile := distribute(pull(BaseScoutFile));

ScoutFile_Raw := IF(AccountIDs[1] != '', Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['BUSINESSINSTANTID2'] AND datetime[1..8] BETWEEN BeginDate AND EndDate AND (string)company_id IN AccountIDs AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs),
									     Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['BUSINESSINSTANTID2'] AND datetime[1..8] BETWEEN BeginDate AND EndDate AND STD.Str.ToLowerCase(TRIM(login_id)) NOT IN scout.ad_hoc_reporting.constants.IgnoredLogins AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs));

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

Parsed_BusinessIID2_Layout := RECORD
STRING TransactionID := '';
STRING10 AccountID := '';
String20 LoginID := '';
STRING8 TransactionDate := '';
STRING EndUserCompanyName := '';
STRING ReferenceCode := '';
//options
STRING BIID20ProductType := '';
STRING GlobalWatchlistThreshold := '';
STRING WatchListsRequested := '';
STRING DOBRadius := '';
STRING ExactAddrMatch := '';
STRING ExactDOBMatch := '';
STRING ExactDriverLicenseMatch := '';
STRING ExactFirstNameMatch := '';
STRING ExactFirstNameMatchAllowNicknames := '';
STRING ExactLastNameMatch := '';
STRING ExactPhoneMatch := '';
STRING ExactSSNMatch := '';
STRING ExcludeWatchLists := '';
STRING IncludeAdditionalWatchlists := '';
STRING IncludeCLOverride := '';
STRING IncludeDLVerification := '';
STRING IncludeDOBInCVI := '';
STRING IncludeDPBC := '';
STRING IncludeDriverLicenseInCVI := '';
STRING IncludeMIOverride := '';
STRING IncludeMSOverride := '';
STRING IncludeOFAC := '';
STRING LastSeenThreshold := '';
STRING NameInputOrder := '';
STRING PoBoxCompliance := '';
STRING UseDOBFilter := '';
//options
STRING InCompanyName := '';
STRING InAlternateCompanyName := '';
STRING InCompanyStreetAddress := '';
STRING InCompanyCity := '';
STRING InCompanyState := '';
STRING InCompanyZip5 := '';
STRING InCompanyPhone := '';
STRING InCompanyFEIN := '';
STRING InRep1FirstName := '';
STRING InRep1LastName := '';
STRING InRep1StreetAddress := '';
STRING InRep1City := '';
STRING InRep1State := '';
STRING InRep1Zip5 := '';
STRING InRep1SSN := '';
STRING InRep1DOB := '';
STRING InRep1Phone := '';
STRING InRep1DL := '';
STRING InRep1DLState := '';
STRING InRep2FirstName := '';
STRING InRep2LastName := '';
STRING InRep2StreetAddress := '';
STRING InRep2City := '';
STRING InRep2State := '';
STRING InRep2Zip5 := '';
STRING InRep2SSN := '';
STRING InRep2DOB := '';
STRING InRep2Phone := '';
STRING InRep2DL := '';
STRING InRep2DLState := '';
STRING InRep3FirstName := '';
STRING InRep3LastName := '';
STRING InRep3StreetAddress := '';
STRING InRep3City := '';
STRING InRep3State := '';
STRING InRep3Zip5 := '';
STRING InRep3SSN := '';
STRING InRep3DOB := '';
STRING InRep3Phone := '';
STRING InRep3DL := '';
STRING InRep3DLState := '';
STRING InRep4FirstName := '';
STRING InRep4LastName := '';
STRING InRep4StreetAddress := '';
STRING InRep4City := '';
STRING InRep4State := '';
STRING InRep4Zip5 := '';
STRING InRep4SSN := '';
STRING InRep4DOB := '';
STRING InRep4Phone := '';
STRING InRep4DL := '';
STRING InRep4DLState := '';
STRING InRep5FirstName := '';
STRING InRep5LastName := '';
STRING InRep5StreetAddress := '';
STRING InRep5City := '';
STRING InRep5State := '';
STRING InRep5Zip5 := '';
STRING InRep5SSN := '';
STRING InRep5DOB := '';
STRING InRep5Phone := '';
STRING InRep5DL := '';
STRING InRep5DLState := '';

// Output Fields
// STRING TransactionID := '';
STRING NumberValidAuthRepsInput := '';
STRING CompanySeleID := '';
STRING VerCompanyName := '';
STRING VerCompanyAddr := '';
STRING VerCompanyCity := '';
STRING VerCompanyState := '';
STRING VerCompanyZip := '';
STRING VerCompanyPhone := '';
STRING VerCompanyFEIN := '';
STRING CompanyBusinessVerificationIndex := '';
STRING CompanyBusinessVerificationDesc := '';
STRING CompanyPRI_Seq1 := '';
STRING CompanyPRI_Code1 := '';
STRING CompanyPRI_Desc1 := '';
STRING CompanyPRI_Seq2 := '';
STRING CompanyPRI_Code2 := '';
STRING CompanyPRI_Desc2 := '';
STRING CompanyPRI_Seq3 := '';
STRING CompanyPRI_Code3 := '';
STRING CompanyPRI_Desc3 := '';
STRING CompanyPRI_Seq4 := '';
STRING CompanyPRI_Code4 := '';
STRING CompanyPRI_Desc4 := '';
STRING CompanyPRI_Seq5 := '';
STRING CompanyPRI_Code5 := '';
STRING CompanyPRI_Desc5 := '';
STRING CompanyPRI_Seq6 := '';
STRING CompanyPRI_Code6 := '';
STRING CompanyPRI_Desc6 := '';
STRING CompanyPRI_Seq7 := '';
STRING CompanyPRI_Code7 := '';
STRING CompanyPRI_Desc7 := '';
STRING CompanyPRI_Seq8 := '';
STRING CompanyPRI_Code8 := '';
STRING CompanyPRI_Desc8 := '';
STRING CompanyResidentialDesc := '';
STRING CompanySOSFilingName := '';
STRING CompanyVeriSummary_Type1 := '';
STRING CompanyVeriSummary_Index1 := '';
STRING CompanyVeriSummary_Desc1 := '';
STRING CompanyVeriSummary_Type2 := '';
STRING CompanyVeriSummary_Index2 := '';
STRING CompanyVeriSummary_Desc2 := '';
STRING CompanyVeriSummary_Type3 := '';
STRING CompanyVeriSummary_Index3 := '';
STRING CompanyVeriSummary_Desc3 := '';
STRING CompanyVeriSummary_Type4 := '';
STRING CompanyVeriSummary_Index4 := '';
STRING CompanyVeriSummary_Desc4 := '';
STRING CompanyVeriSummary_Type5 := '';
STRING CompanyVeriSummary_Index5 := '';
STRING CompanyVeriSummary_Desc5 := '';
STRING BusToExexIndex_Rep1 := '';
STRING BusToExexIndex_Index1 := '';
STRING BusToExexIndex_Desc1 := '';
STRING BusToExexIndex_Rep2 := '';
STRING BusToExexIndex_Index2 := '';
STRING BusToExexIndex_Desc2 := '';
STRING BusToExexIndex_Rep3 := '';
STRING BusToExexIndex_Index3 := '';
STRING BusToExexIndex_Desc3 := '';
STRING BusToExexIndex_Rep4 := '';
STRING BusToExexIndex_Index4 := '';
STRING BusToExexIndex_Desc4 := '';
STRING BusToExexIndex_Rep5 := '';
STRING BusToExexIndex_Index5 := '';
STRING BusToExexIndex_Desc5 := '';
STRING Rep1UniqueId := '';
STRING Rep1CVI := '';
STRING Rep1NAP := '';
STRING Rep1NAS := '';
STRING Rep1RI_seq1 := '';
STRING Rep1RI_Code1 := '';
STRING Rep1RI_Desc1 := '';
STRING Rep1RI_seq2 := '';
STRING Rep1RI_Code2 := '';
STRING Rep1RI_Desc2 := '';
STRING Rep1RI_seq3 := '';
STRING Rep1RI_Code3 := '';
STRING Rep1RI_Desc3 := '';
STRING Rep1RI_seq4 := '';
STRING Rep1RI_Code4 := '';
STRING Rep1RI_Desc4 := '';
STRING Rep1RI_seq5 := '';
STRING Rep1RI_Code5 := '';
STRING Rep1RI_Desc5 := '';
STRING Rep1RI_seq6 := '';
STRING Rep1RI_Code6 := '';
STRING Rep1RI_Desc6 := '';
STRING Rep1RI_seq7 := '';
STRING Rep1RI_Code7 := '';
STRING Rep1RI_Desc7 := '';
STRING Rep1RI_seq8 := '';
STRING Rep1RI_Code8 := '';
STRING Rep1RI_Desc8 := '';
STRING Rep1RI_seq9 := '';
STRING Rep1RI_Code9 := '';
STRING Rep1RI_Desc9 := '';
STRING Rep1RI_seq10 := '';
STRING Rep1RI_Code10 := '';
STRING Rep1RI_Desc10 := '';

STRING Rep2UniqueId := '';
STRING Rep2CVI := '';
STRING Rep2NAP := '';
STRING Rep2NAS := '';
STRING Rep2RI_seq1 := '';
STRING Rep2RI_Code1 := '';
STRING Rep2RI_Desc1 := '';
STRING Rep2RI_seq2 := '';
STRING Rep2RI_Code2 := '';
STRING Rep2RI_Desc2 := '';
STRING Rep2RI_seq3 := '';
STRING Rep2RI_Code3 := '';
STRING Rep2RI_Desc3 := '';
STRING Rep2RI_seq4 := '';
STRING Rep2RI_Code4 := '';
STRING Rep2RI_Desc4 := '';
STRING Rep2RI_seq5 := '';
STRING Rep2RI_Code5 := '';
STRING Rep2RI_Desc5 := '';
STRING Rep2RI_seq6 := '';
STRING Rep2RI_Code6 := '';
STRING Rep2RI_Desc6 := '';
STRING Rep2RI_seq7 := '';
STRING Rep2RI_Code7 := '';
STRING Rep2RI_Desc7 := '';
STRING Rep2RI_seq8 := '';
STRING Rep2RI_Code8 := '';
STRING Rep2RI_Desc8 := '';
STRING Rep2RI_seq9 := '';
STRING Rep2RI_Code9 := '';
STRING Rep2RI_Desc9 := '';
STRING Rep2RI_seq10 := '';
STRING Rep2RI_Code10 := '';
STRING Rep2RI_Desc10 := '';
STRING Rep3UniqueId := '';
STRING Rep3CVI := '';
STRING Rep3NAP := '';
STRING Rep3NAS := '';
STRING Rep3RI_seq1 := '';
STRING Rep3RI_Code1 := '';
STRING Rep3RI_Desc1 := '';
STRING Rep3RI_seq2 := '';
STRING Rep3RI_Code2 := '';
STRING Rep3RI_Desc2 := '';
STRING Rep3RI_seq3 := '';
STRING Rep3RI_Code3 := '';
STRING Rep3RI_Desc3 := '';
STRING Rep3RI_seq4 := '';
STRING Rep3RI_Code4 := '';
STRING Rep3RI_Desc4 := '';
STRING Rep3RI_seq5 := '';
STRING Rep3RI_Code5 := '';
STRING Rep3RI_Desc5 := '';
STRING Rep3RI_seq6 := '';
STRING Rep3RI_Code6 := '';
STRING Rep3RI_Desc6 := '';
STRING Rep3RI_seq7 := '';
STRING Rep3RI_Code7 := '';
STRING Rep3RI_Desc7 := '';
STRING Rep3RI_seq8 := '';
STRING Rep3RI_Code8 := '';
STRING Rep3RI_Desc8 := '';
STRING Rep3RI_seq9 := '';
STRING Rep3RI_Code9 := '';
STRING Rep3RI_Desc9 := '';
STRING Rep3RI_seq10 := '';
STRING Rep3RI_Code10 := '';
STRING Rep3RI_Desc10 := '';
STRING Rep4UniqueId := '';
STRING Rep4CVI := '';
STRING Rep4NAP := '';
STRING Rep4NAS := '';
STRING Rep4RI_seq1 := '';
STRING Rep4RI_Code1 := '';
STRING Rep4RI_Desc1 := '';
STRING Rep4RI_seq2 := '';
STRING Rep4RI_Code2 := '';
STRING Rep4RI_Desc2 := '';
STRING Rep4RI_seq3 := '';
STRING Rep4RI_Code3 := '';
STRING Rep4RI_Desc3 := '';
STRING Rep4RI_seq4 := '';
STRING Rep4RI_Code4 := '';
STRING Rep4RI_Desc4 := '';
STRING Rep4RI_seq5 := '';
STRING Rep4RI_Code5 := '';
STRING Rep4RI_Desc5 := '';
STRING Rep4RI_seq6 := '';
STRING Rep4RI_Code6 := '';
STRING Rep4RI_Desc6 := '';
STRING Rep4RI_seq7 := '';
STRING Rep4RI_Code7 := '';
STRING Rep4RI_Desc7 := '';
STRING Rep4RI_seq8 := '';
STRING Rep4RI_Code8 := '';
STRING Rep4RI_Desc8 := '';
STRING Rep4RI_seq9 := '';
STRING Rep4RI_Code9 := '';
STRING Rep4RI_Desc9 := '';
STRING Rep4RI_seq10 := '';
STRING Rep4RI_Code10 := '';
STRING Rep4RI_Desc10 := '';
STRING Rep5UniqueId := '';
STRING Rep5CVI := '';
STRING Rep5NAP := '';
STRING Rep5NAS := '';
STRING Rep5RI_seq1 := '';
STRING Rep5RI_Code1 := '';
STRING Rep5RI_Desc1 := '';
STRING Rep5RI_seq2 := '';
STRING Rep5RI_Code2 := '';
STRING Rep5RI_Desc2 := '';
STRING Rep5RI_seq3 := '';
STRING Rep5RI_Code3 := '';
STRING Rep5RI_Desc3 := '';
STRING Rep5RI_seq4 := '';
STRING Rep5RI_Code4 := '';
STRING Rep5RI_Desc4 := '';
STRING Rep5RI_seq5 := '';
STRING Rep5RI_Code5 := '';
STRING Rep5RI_Desc5 := '';
STRING Rep5RI_seq6 := '';
STRING Rep5RI_Code6 := '';
STRING Rep5RI_Desc6 := '';
STRING Rep5RI_seq7 := '';
STRING Rep5RI_Code7 := '';
STRING Rep5RI_Desc7 := '';
STRING Rep5RI_seq8 := '';
STRING Rep5RI_Code8 := '';
STRING Rep5RI_Desc8 := '';
STRING Rep5RI_seq9 := '';
STRING Rep5RI_Code9 := '';
STRING Rep5RI_Desc9 := '';
STRING Rep5RI_seq10 := '';
STRING Rep5RI_Code10 := '';
STRING Rep5RI_Desc10 := '';
END;

Parsed_BusinessIID2_Layout parseInput () := TRANSFORM

  _InRep1DOB_year  := TRIM(XMLTEXT('SearchBy/AuthorizedRep1/DOB/Year'));
  _InRep1DOB_month := '00' + TRIM(XMLTEXT('SearchBy/AuthorizedRep1/DOB/Month'));
  _InRep1DOB_day   := '00' + TRIM(XMLTEXT('SearchBy/AuthorizedRep1/DOB/Day'));
  _InRep1DOB := _InRep1DOB_year + _InRep1DOB_month[(LENGTH(_InRep1DOB_month)-1)..(LENGTH(_InRep1DOB_month))] + _InRep1DOB_day[(LENGTH(_InRep1DOB_day)-1)..(LENGTH(_InRep1DOB_day))];
  
  _InRep2DOB_year  := TRIM(XMLTEXT('SearchBy/AuthorizedRep2/DOB/Year'));
  _InRep2DOB_month := '00' + TRIM(XMLTEXT('SearchBy/AuthorizedRep2/DOB/Month'));
  _InRep2DOB_day   := '00' + TRIM(XMLTEXT('SearchBy/AuthorizedRep2/DOB/Day'));
  _InRep2DOB := _InRep2DOB_year + _InRep2DOB_month[(LENGTH(_InRep2DOB_month)-1)..(LENGTH(_InRep2DOB_month))] + _InRep2DOB_day[(LENGTH(_InRep2DOB_day)-1)..(LENGTH(_InRep2DOB_day))];

  _InRep3DOB_year  := TRIM(XMLTEXT('SearchBy/AuthorizedRep3/DOB/Year'));
  _InRep3DOB_month := '00' + TRIM(XMLTEXT('SearchBy/AuthorizedRep3/DOB/Month'));
  _InRep3DOB_day   := '00' + TRIM(XMLTEXT('SearchBy/AuthorizedRep3/DOB/Day'));
  _InRep3DOB := _InRep3DOB_year + _InRep3DOB_month[(LENGTH(_InRep3DOB_month)-1)..(LENGTH(_InRep3DOB_month))] + _InRep3DOB_day[(LENGTH(_InRep3DOB_day)-1)..(LENGTH(_InRep3DOB_day))];
  
  _InRep4DOB_year  := TRIM(XMLTEXT('SearchBy/AuthorizedRep4/DOB/Year'));
  _InRep4DOB_month := '00' + TRIM(XMLTEXT('SearchBy/AuthorizedRep4/DOB/Month'));
  _InRep4DOB_day   := '00' + TRIM(XMLTEXT('SearchBy/AuthorizedRep4/DOB/Day'));
  _InRep4DOB := _InRep4DOB_year + _InRep4DOB_month[(LENGTH(_InRep4DOB_month)-1)..(LENGTH(_InRep4DOB_month))] + _InRep4DOB_day[(LENGTH(_InRep4DOB_day)-1)..(LENGTH(_InRep4DOB_day))];
  
  _InRep5DOB_year  := TRIM(XMLTEXT('SearchBy/AuthorizedRep5/DOB/Year'));
  _InRep5DOB_month := '00' + TRIM(XMLTEXT('SearchBy/AuthorizedRep5/DOB/Month'));
  _InRep5DOB_day   := '00' + TRIM(XMLTEXT('SearchBy/AuthorizedRep5/DOB/Day'));
  _InRep5DOB := _InRep5DOB_year + _InRep5DOB_month[(LENGTH(_InRep5DOB_month)-1)..(LENGTH(_InRep5DOB_month))] + _InRep5DOB_day[(LENGTH(_InRep5DOB_day)-1)..(LENGTH(_InRep5DOB_day))];
  
	SELF.TransactionID				:= TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
	SELF.EndUserCompanyName		:= TRIM(XMLTEXT('User/EndUser/CompanyName'));
	SELF.ReferenceCode				:= TRIM(XMLTEXT('User/ReferenceCode'));
	SELF.BIID20ProductType		:= TRIM(XMLTEXT('Options/BIID20ProductType'));
	SELF.GlobalWatchlistThreshold		:= TRIM(XMLTEXT('Options/GlobalWatchlistThreshold'));
	SELF.WatchListsRequested		:= TRIM(XMLTEXT('Options/WatchListsRequested'));
	SELF.DOBRadius		:= TRIM(XMLTEXT('Options/DOBRadius'));
	SELF.ExactAddrMatch		:= TRIM(XMLTEXT('Options/ExactAddrMatch'));
	SELF.ExactDOBMatch		:= TRIM(XMLTEXT('Options/ExactDOBMatch'));
	SELF.ExactDriverLicenseMatch		:= TRIM(XMLTEXT('Options/ExactDriverLicenseMatch'));
	SELF.ExactFirstNameMatch		:= TRIM(XMLTEXT('Options/ExactFirstNameMatch'));
	SELF.ExactFirstNameMatchAllowNicknames		:= TRIM(XMLTEXT('Options/ExactFirstNameMatchAllowNicknames'));
	SELF.ExactLastNameMatch		:= TRIM(XMLTEXT('Options/ExactLastNameMatch'));
	SELF.ExactPhoneMatch		:= TRIM(XMLTEXT('Options/ExactPhoneMatch'));
	SELF.ExactSSNMatch		:= TRIM(XMLTEXT('Options/ExactSSNMatch'));
	SELF.ExcludeWatchLists		:= TRIM(XMLTEXT('Options/ExcludeWatchLists'));
	SELF.IncludeAdditionalWatchlists		:= TRIM(XMLTEXT('Options/IncludeAdditionalWatchlists'));
	SELF.IncludeCLOverride		:= TRIM(XMLTEXT('Options/IncludeCLOverride'));
	SELF.IncludeDLVerification		:= TRIM(XMLTEXT('Options/IncludeDLVerification'));
	SELF.IncludeDOBInCVI		:= TRIM(XMLTEXT('Options/IncludeDOBInCVI'));
	SELF.IncludeDPBC		:= TRIM(XMLTEXT('Options/IncludeDPBC'));
	SELF.IncludeDriverLicenseInCVI		:= TRIM(XMLTEXT('Options/IncludeDriverLicenseInCVI'));
	SELF.IncludeMIOverride		:= TRIM(XMLTEXT('Options/IncludeMIOverride'));
	SELF.IncludeMSOverride		:= TRIM(XMLTEXT('Options/IncludeMSOverride'));
	SELF.IncludeOFAC		:= TRIM(XMLTEXT('Options/IncludeOFAC'));
	SELF.LastSeenThreshold		:= TRIM(XMLTEXT('Options/LastSeenThreshold'));
	SELF.NameInputOrder		:= TRIM(XMLTEXT('Options/NameInputOrder'));
	SELF.PoBoxCompliance		:= TRIM(XMLTEXT('Options/PoBoxCompliance'));
	SELF.UseDOBFilter		:= TRIM(XMLTEXT('Options/UseDOBFilter'));
	SELF.InCompanyName					:= TRIM(XMLTEXT('SearchBy/Company/CompanyName'));
	SELF.InAlternateCompanyName	:= TRIM(XMLTEXT('SearchBy/Company/AlternateCompanyName'));
	SELF.InCompanyStreetAddress	:= TRIM(XMLTEXT('SearchBy/Company/Address/StreetAddress1'));
	SELF.InCompanyCity		:= TRIM(XMLTEXT('SearchBy/Company/Address/City'));
	SELF.InCompanyState		:= TRIM(XMLTEXT('SearchBy/Company/Address/State'));
	SELF.InCompanyZip5		:= TRIM(XMLTEXT('SearchBy/Company/Address/Zip5'));
	SELF.InCompanyPhone		:= TRIM(XMLTEXT('SearchBy/Company/Phone'));
	SELF.InCompanyFEIN		:= TRIM(XMLTEXT('SearchBy/Company/FEIN'));
	SELF.InRep1FirstName	:= TRIM(XMLTEXT('SearchBy/AuthorizedRep1/Name/First'));
	SELF.InRep1LastName		:= TRIM(XMLTEXT('SearchBy/AuthorizedRep1/Name/Last'));
	SELF.InRep1StreetAddress	:= TRIM(XMLTEXT('SearchBy/AuthorizedRep1/Address/StreetAddress1'));
	SELF.InRep1City				:= TRIM(XMLTEXT('SearchBy/AuthorizedRep1/Address/City'));
	SELF.InRep1State			:= TRIM(XMLTEXT('SearchBy/AuthorizedRep1/Address/State'));
  SELF.InRep1Zip5       := TRIM(XMLTEXT('SearchBy/AuthorizedRep1/Address/Zip5'));
	SELF.InRep1SSN				:= TRIM(XMLTEXT('SearchBy/AuthorizedRep1/SSN'));
	SELF.InRep1DOB				:= IF( (INTEGER)_InRep1DOB = 0, '', _InRep1DOB );
	SELF.InRep1Phone			:= TRIM(XMLTEXT('SearchBy/AuthorizedRep1/Phone'));
	SELF.InRep1DL					:= TRIM(XMLTEXT('SearchBy/AuthorizedRep1/DriverLicenseNumber'));
	SELF.InRep1DLState		:= TRIM(XMLTEXT('SearchBy/AuthorizedRep1/DriverLicenseState'));
	
	SELF.InRep2FirstName	:= TRIM(XMLTEXT('SearchBy/AuthorizedRep2/Name/First'));
	SELF.InRep2LastName		:= TRIM(XMLTEXT('SearchBy/AuthorizedRep2/Name/Last'));
	SELF.InRep2StreetAddress	:= TRIM(XMLTEXT('SearchBy/AuthorizedRep2/Address/StreetAddress1'));
	SELF.InRep2City				:= TRIM(XMLTEXT('SearchBy/AuthorizedRep2/Address/City'));
	SELF.InRep2State			:= TRIM(XMLTEXT('SearchBy/AuthorizedRep2/Address/State'));
  SELF.InRep2Zip5       := TRIM(XMLTEXT('SearchBy/AuthorizedRep2/Address/Zip5'));
	SELF.InRep2SSN				:= TRIM(XMLTEXT('SearchBy/AuthorizedRep2/SSN'));
	SELF.InRep2DOB				:= IF( (INTEGER)_InRep2DOB = 0, '', _InRep2DOB );
	SELF.InRep2Phone			:= TRIM(XMLTEXT('SearchBy/AuthorizedRep2/Phone'));
	SELF.InRep2DL					:= TRIM(XMLTEXT('SearchBy/AuthorizedRep2/DriverLicenseNumber'));
	SELF.InRep2DLState		:= TRIM(XMLTEXT('SearchBy/AuthorizedRep2/DriverLicenseState'));
	
	SELF.InRep3FirstName	:= TRIM(XMLTEXT('SearchBy/AuthorizedRep3/Name/First'));
	SELF.InRep3LastName		:= TRIM(XMLTEXT('SearchBy/AuthorizedRep3/Name/Last'));
	SELF.InRep3StreetAddress	:= TRIM(XMLTEXT('SearchBy/AuthorizedRep3/Address/StreetAddress1'));
	SELF.InRep3City				:= TRIM(XMLTEXT('SearchBy/AuthorizedRep3/Address/City'));
	SELF.InRep3State			:= TRIM(XMLTEXT('SearchBy/AuthorizedRep3/Address/State'));
  SELF.InRep3Zip5       := TRIM(XMLTEXT('SearchBy/AuthorizedRep3/Address/Zip5'));
	SELF.InRep3SSN				:= TRIM(XMLTEXT('SearchBy/AuthorizedRep3/SSN'));
	SELF.InRep3DOB				:= IF( (INTEGER)_InRep3DOB = 0, '', _InRep3DOB );
	SELF.InRep3Phone			:= TRIM(XMLTEXT('SearchBy/AuthorizedRep3/Phone'));
	SELF.InRep3DL					:= TRIM(XMLTEXT('SearchBy/AuthorizedRep3/DriverLicenseNumber'));
	SELF.InRep3DLState		:= TRIM(XMLTEXT('SearchBy/AuthorizedRep3/DriverLicenseState'));
	
	SELF.InRep4FirstName	:= TRIM(XMLTEXT('SearchBy/AuthorizedRep4/Name/First'));
	SELF.InRep4LastName		:= TRIM(XMLTEXT('SearchBy/AuthorizedRep4/Name/Last'));
	SELF.InRep4StreetAddress	:= TRIM(XMLTEXT('SearchBy/AuthorizedRep4/Address/StreetAddress1'));
	SELF.InRep4City				:= TRIM(XMLTEXT('SearchBy/AuthorizedRep4/Address/City'));
	SELF.InRep4State			:= TRIM(XMLTEXT('SearchBy/AuthorizedRep4/Address/State'));
  SELF.InRep4Zip5       := TRIM(XMLTEXT('SearchBy/AuthorizedRep4/Address/Zip5'));
	SELF.InRep4SSN				:= TRIM(XMLTEXT('SearchBy/AuthorizedRep4/SSN'));
	SELF.InRep4DOB				:= IF( (INTEGER)_InRep4DOB = 0, '', _InRep4DOB );
	SELF.InRep4Phone			:= TRIM(XMLTEXT('SearchBy/AuthorizedRep4/Phone'));
	SELF.InRep4DL					:= TRIM(XMLTEXT('SearchBy/AuthorizedRep4/DriverLicenseNumber'));
	SELF.InRep4DLState		:= TRIM(XMLTEXT('SearchBy/AuthorizedRep4/DriverLicenseState'));
	
	SELF.InRep5FirstName	:= TRIM(XMLTEXT('SearchBy/AuthorizedRep5/Name/First'));
	SELF.InRep5LastName		:= TRIM(XMLTEXT('SearchBy/AuthorizedRep5/Name/Last'));
	SELF.InRep5StreetAddress	:= TRIM(XMLTEXT('SearchBy/AuthorizedRep5/Address/StreetAddress1'));
	SELF.InRep5City				:= TRIM(XMLTEXT('SearchBy/AuthorizedRep5/Address/City'));
	SELF.InRep5State			:= TRIM(XMLTEXT('SearchBy/AuthorizedRep5/Address/State'));
  SELF.InRep5Zip5       := TRIM(XMLTEXT('SearchBy/AuthorizedRep5/Address/Zip5'));
	SELF.InRep5SSN				:= TRIM(XMLTEXT('SearchBy/AuthorizedRep5/SSN'));
	SELF.InRep5DOB				:= IF( (INTEGER)_InRep5DOB = 0, '', _InRep5DOB );
	SELF.InRep5Phone			:= TRIM(XMLTEXT('SearchBy/AuthorizedRep5/Phone'));
	SELF.InRep5DL					:= TRIM(XMLTEXT('SearchBy/AuthorizedRep5/DriverLicenseNumber'));
	SELF.InRep5DLState		:= TRIM(XMLTEXT('SearchBy/AuthorizedRep5/DriverLicenseState'));
	SELF := [];
END;

parsedInput := DISTRIBUTE(PARSE(Good_Logs, inputxml, parseInput(), XML('BusinessInstantID2')), HASH64(TransactionID));

OUTPUT(CHOOSEN(parsedInput, eyeball), NAMED('Sample_Parsed_Input'));
OUTPUT(COUNT(parsedInput), NAMED('parsedInput'));

Parsed_BusinessIID2_Layout parseOutput() := TRANSFORM
	SELF.TransactionID	:= TRIM(XMLTEXT('Header/TransactionId')); // Forced into the record so I can join it all together
												 
	SELF.NumberValidAuthRepsInput := TRIM(XMLTEXT('Result/NumberValidAuthRepsInput'));
	SELF.CompanySeleID 						:= TRIM(XMLTEXT('Result/CompanyResults/BusinessIds/SeleID'));
  SELF.VerCompanyName  					:= IF(TRIM(XMLTEXT('Result/CompanyResults/VerificationIndicators/CompanyName'))   = '1', 'TRUE', 'FALSE');
  SELF.VerCompanyAddr  					:= IF(TRIM(XMLTEXT('Result/CompanyResults/VerificationIndicators/StreetAddress')) = '1', 'TRUE', 'FALSE');
  SELF.VerCompanyCity  					:= IF(TRIM(XMLTEXT('Result/CompanyResults/VerificationIndicators/City'))          = '1', 'TRUE', 'FALSE');
  SELF.VerCompanyState 					:= IF(TRIM(XMLTEXT('Result/CompanyResults/VerificationIndicators/State'))         = '1', 'TRUE', 'FALSE');
  SELF.VerCompanyZip   					:= IF(TRIM(XMLTEXT('Result/CompanyResults/VerificationIndicators/Zip'))           = '1', 'TRUE', 'FALSE');
  SELF.VerCompanyPhone 					:= IF(TRIM(XMLTEXT('Result/CompanyResults/VerificationIndicators/Phone'))         = '1', 'TRUE', 'FALSE');
  SELF.VerCompanyFEIN  					:= IF(TRIM(XMLTEXT('Result/CompanyResults/VerificationIndicators/FEIN'))          = '1', 'TRUE', 'FALSE');
	SELF.CompanyBusinessVerificationIndex := TRIM(XMLTEXT('Result/CompanyResults/BusinessVerification/Index'));
	SELF.CompanyBusinessVerificationDesc := TRIM(XMLTEXT('Result/CompanyResults/BusinessVerification/Description'));
	// RI1_Seq           		:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[1]/Sequence'));
	// RI1_Seq_flag					:= IF((RI1_Seq) = '1', TRUE, FALSE);
	SELF.CompanyPRI_Seq1 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[1]/Sequence'));
	SELF.CompanyPRI_Code1:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[1]/RiskCode'));
	SELF.CompanyPRI_Desc1:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[1]/Description'));

	// RI2_Seq           		:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[2]/Sequence'));
	// RI2_Seq_flag					:= IF((RI2_Seq) = '1', TRUE, FALSE);
	SELF.CompanyPRI_Seq2 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[2]/Sequence'));	
	SELF.CompanyPRI_Code2:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[2]/RiskCode'));
	SELF.CompanyPRI_Desc2:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[2]/Description'));
	
	// RI3_Seq           		:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[3]/Sequence'));
	// RI3_Seq_flag					:= IF((RI3_Seq) = '1', TRUE, FALSE);
	SELF.CompanyPRI_Seq3 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[3]/Sequence'));	
	SELF.CompanyPRI_Code3:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[3]/RiskCode'));
	SELF.CompanyPRI_Desc3:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[3]/Description'));
	
	// RI4_Seq           		:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[4]/Sequence'));
	// RI4_Seq_flag					:= IF((RI4_Seq) = '1', TRUE, FALSE);
	SELF.CompanyPRI_Seq4 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[4]/Sequence'));		
	SELF.CompanyPRI_Code4:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[4]/RiskCode'));
	SELF.CompanyPRI_Desc4:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[4]/Description'));
	
	// RI5_Seq           		:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[5]/Sequence'));
	// RI5_Seq_flag					:= IF((RI5_Seq) = '1', TRUE, FALSE);
	SELF.CompanyPRI_Seq5 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[5]/Sequence'));		
	SELF.CompanyPRI_Code5:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[5]/RiskCode'));
	SELF.CompanyPRI_Desc5:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[5]/Description'));
	
	// RI6_Seq           		:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[6]/Sequence'));
	// RI6_Seq_flag					:= IF((RI6_Seq) = '1', TRUE, FALSE);
	SELF.CompanyPRI_Seq6 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[6]/Sequence'));		
	SELF.CompanyPRI_Code6:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[6]/RiskCode'));
	SELF.CompanyPRI_Desc6:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[6]/Description'));
	
	// RI7_Seq           		:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[7]/Sequence'));
	// RI7_Seq_flag					:= IF((RI7_Seq) = '1', TRUE, FALSE);
	SELF.CompanyPRI_Seq7 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[7]/Sequence'));		
	SELF.CompanyPRI_Code7:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[7]/RiskCode'));
	SELF.CompanyPRI_Desc7:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[7]/Description'));
	
	// RI8_Seq           		:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[8]/Sequence'));
	// RI8_Seq_flag					:= IF((RI8_Seq) = '1', TRUE, FALSE);
	SELF.CompanyPRI_Seq8 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[8]/Sequence'));		
	SELF.CompanyPRI_Code8:=  TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[8]/RiskCode'));
	SELF.CompanyPRI_Desc8:= TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[8]/Description'));
	
	SELF.CompanyResidentialDesc := TRIM(XMLTEXT('Result/CompanyResults/ResidentialBusinesses/ResidentialBusiness/Description'));
	SELF.CompanySOSFilingName := TRIM(XMLTEXT('Result/CompanyResults/Compliance/SOSFilingName'));
	
	SELF.CompanyVeriSummary_Type1:= TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[1]/Type'));
	SELF.CompanyVeriSummary_Index1:= TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[1]/Index')),;
	SELF.CompanyVeriSummary_Desc1:= TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[1]/Description'));
	
	SELF.CompanyVeriSummary_Type2:= TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[2]/Type'));
	SELF.CompanyVeriSummary_Index2:= TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[2]/Index')),;
	SELF.CompanyVeriSummary_Desc2:= TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[2]/Description'));
	
	SELF.CompanyVeriSummary_Type3:= TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[3]/Type'));
	SELF.CompanyVeriSummary_Index3:= TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[3]/Index')),;
	SELF.CompanyVeriSummary_Desc3:= TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[3]/Description'));
	
	SELF.CompanyVeriSummary_Type4:= TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[4]/Type'));
	SELF.CompanyVeriSummary_Index4:= TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[4]/Index')),;
	SELF.CompanyVeriSummary_Desc4:= TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[4]/Description'));
	
	SELF.CompanyVeriSummary_Type5:= TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[5]/Type'));
	SELF.CompanyVeriSummary_Index5:= TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[5]/Index')),;
	SELF.CompanyVeriSummary_Desc5:= TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[5]/Description'));
	
	SELF.BusToExexIndex_Rep1:= TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[1]/InputRepNumber'));
	SELF.BusToExexIndex_Index1:= TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[1]/Index')),;
	SELF.BusToExexIndex_Desc1:= TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[1]/Description'));
	
	SELF.BusToExexIndex_Rep2:= TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[2]/InputRepNumber'));
	SELF.BusToExexIndex_Index2:= TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[2]/Index')),;
	SELF.BusToExexIndex_Desc2:= TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[2]/Description'));
	
	SELF.BusToExexIndex_Rep3:= TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[3]/InputRepNumber'));
	SELF.BusToExexIndex_Index3:= TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[3]/Index')),;
	SELF.BusToExexIndex_Desc3:= TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[3]/Description'));
	
	SELF.BusToExexIndex_Rep4:= TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[4]/InputRepNumber'));
	SELF.BusToExexIndex_Index4:= TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[4]/Index')),;
	SELF.BusToExexIndex_Desc4:= TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[4]/Description'));
	
	SELF.BusToExexIndex_Rep5:= TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[5]/InputRepNumber'));
	SELF.BusToExexIndex_Index5:= TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[5]/Index')),;
	SELF.BusToExexIndex_Desc5:= TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[5]/Description'));
	//AuthorizedRepresentativeResult1
	SELF.Rep1UniqueId		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/UniqueId'));
	SELF.Rep1CVI		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/ComprehensiveVerificationIndex'));
	SELF.Rep1NAP		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/NameAddressPhoneSummary'));
	SELF.Rep1NAS		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/NameAddressSSNSummary'));
	
	SELF.Rep1RI_seq1		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[1]/Sequence'));
	SELF.Rep1RI_Code1		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[1]/RiskCode'));
	SELF.Rep1RI_Desc1		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[1]/Description'));
		
	SELF.Rep1RI_seq2		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[2]/Sequence'));
	SELF.Rep1RI_Code2		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[2]/RiskCode'));
	SELF.Rep1RI_Desc2		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[2]/Description'));
		
	SELF.Rep1RI_seq3		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[3]/Sequence'));
	SELF.Rep1RI_Code3		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[3]/RiskCode'));
	SELF.Rep1RI_Desc3		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[3]/Description'));
		
	SELF.Rep1RI_seq4		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[4]/Sequence'));
	SELF.Rep1RI_Code4		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[4]/RiskCode'));
	SELF.Rep1RI_Desc4		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[4]/Description'));
		
	SELF.Rep1RI_seq5		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[5]/Sequence'));
	SELF.Rep1RI_Code5		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[5]/RiskCode'));
	SELF.Rep1RI_Desc5		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[5]/Description'));
		
	SELF.Rep1RI_seq6		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[6]/Sequence'));
	SELF.Rep1RI_Code6		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[6]/RiskCode'));
	SELF.Rep1RI_Desc6		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[6]/Description'));
		
	SELF.Rep1RI_seq7		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[7]/Sequence'));
	SELF.Rep1RI_Code7		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[7]/RiskCode'));
	SELF.Rep1RI_Desc7		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[7]/Description'));
		
	SELF.Rep1RI_seq8		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[8]/Sequence'));
	SELF.Rep1RI_Code8		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[8]/RiskCode'));
	SELF.Rep1RI_Desc8		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[8]/Description'));
		
	SELF.Rep1RI_seq9		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[9]/Sequence'));
	SELF.Rep1RI_Code9		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[9]/RiskCode'));
	SELF.Rep1RI_Desc9		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[9]/Description'));
		
	SELF.Rep1RI_seq10		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[10]/Sequence'));
	SELF.Rep1RI_Code10		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[10]/RiskCode'));
	SELF.Rep1RI_Desc10		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[10]/Description'));
	
	//AuthorizedRepresentativeResult2
	SELF.Rep2UniqueId		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/UniqueId'));
	SELF.Rep2CVI		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/ComprehensiveVerificationIndex'));
	SELF.Rep2NAP		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/NameAddressPhoneSummary'));
	SELF.Rep2NAS		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/NameAddressSSNSummary'));
	
	SELF.Rep2RI_seq1		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[1]/Sequence'));
	SELF.Rep2RI_Code1		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[1]/RiskCode'));
	SELF.Rep2RI_Desc1		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[1]/Description'));
		
	SELF.Rep2RI_seq2		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[2]/Sequence'));
	SELF.Rep2RI_Code2		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[2]/RiskCode'));
	SELF.Rep2RI_Desc2		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[2]/Description'));
		
	SELF.Rep2RI_seq3		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[3]/Sequence'));
	SELF.Rep2RI_Code3		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[3]/RiskCode'));
	SELF.Rep2RI_Desc3		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[3]/Description'));
		
	SELF.Rep2RI_seq4		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[4]/Sequence'));
	SELF.Rep2RI_Code4		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[4]/RiskCode'));
	SELF.Rep2RI_Desc4		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[4]/Description'));
		
	SELF.Rep2RI_seq5		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[5]/Sequence'));
	SELF.Rep2RI_Code5		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[5]/RiskCode'));
	SELF.Rep2RI_Desc5		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[5]/Description'));
		
	SELF.Rep2RI_seq6		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[6]/Sequence'));
	SELF.Rep2RI_Code6		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[6]/RiskCode'));
	SELF.Rep2RI_Desc6		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[6]/Description'));
		
	SELF.Rep2RI_seq7		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[7]/Sequence'));
	SELF.Rep2RI_Code7		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[7]/RiskCode'));
	SELF.Rep2RI_Desc7		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[7]/Description'));
		
	SELF.Rep2RI_seq8		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[8]/Sequence'));
	SELF.Rep2RI_Code8		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[8]/RiskCode'));
	SELF.Rep2RI_Desc8		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[8]/Description'));
		
	SELF.Rep2RI_seq9		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[9]/Sequence'));
	SELF.Rep2RI_Code9		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[9]/RiskCode'));
	SELF.Rep2RI_Desc9		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[9]/Description'));
		
	SELF.Rep2RI_seq10		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[10]/Sequence'));
	SELF.Rep2RI_Code10		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[10]/RiskCode'));
	SELF.Rep2RI_Desc10		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[10]/Description'));
	
	//AuthorizedRepresentativeResult3
	SELF.Rep3UniqueId		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/UniqueId'));
	SELF.Rep3CVI		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/ComprehensiveVerificationIndex'));
	SELF.Rep3NAP		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/NameAddressPhoneSummary'));
	SELF.Rep3NAS		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/NameAddressSSNSummary'));
	
	SELF.Rep3RI_seq1		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[1]/Sequence'));
	SELF.Rep3RI_Code1		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[1]/RiskCode'));
	SELF.Rep3RI_Desc1		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[1]/Description'));
		
	SELF.Rep3RI_seq2		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[2]/Sequence'));
	SELF.Rep3RI_Code2		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[2]/RiskCode'));
	SELF.Rep3RI_Desc2		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[2]/Description'));
		
	SELF.Rep3RI_seq3		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[3]/Sequence'));
	SELF.Rep3RI_Code3		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[3]/RiskCode'));
	SELF.Rep3RI_Desc3		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[3]/Description'));
		
	SELF.Rep3RI_seq4		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[4]/Sequence'));
	SELF.Rep3RI_Code4		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[4]/RiskCode'));
	SELF.Rep3RI_Desc4		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[4]/Description'));
		
	SELF.Rep3RI_seq5		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[5]/Sequence'));
	SELF.Rep3RI_Code5		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[5]/RiskCode'));
	SELF.Rep3RI_Desc5		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[5]/Description'));
		
	SELF.Rep3RI_seq6		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[6]/Sequence'));
	SELF.Rep3RI_Code6		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[6]/RiskCode'));
	SELF.Rep3RI_Desc6		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[6]/Description'));
		
	SELF.Rep3RI_seq7		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[7]/Sequence'));
	SELF.Rep3RI_Code7		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[7]/RiskCode'));
	SELF.Rep3RI_Desc7		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[7]/Description'));
		
	SELF.Rep3RI_seq8		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[8]/Sequence'));
	SELF.Rep3RI_Code8		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[8]/RiskCode'));
	SELF.Rep3RI_Desc8		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[8]/Description'));
		
	SELF.Rep3RI_seq9		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[9]/Sequence'));
	SELF.Rep3RI_Code9		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[9]/RiskCode'));
	SELF.Rep3RI_Desc9		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[9]/Description'));
		
	SELF.Rep3RI_seq10		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[10]/Sequence'));
	SELF.Rep3RI_Code10		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[10]/RiskCode'));
	SELF.Rep3RI_Desc10		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[10]/Description'));
	
	//AuthorizedRepresentativeResult4
	SELF.Rep4UniqueId		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/UniqueId'));
	SELF.Rep4CVI		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/ComprehensiveVerificationIndex'));
	SELF.Rep4NAP		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/NameAddressPhoneSummary'));
	SELF.Rep4NAS		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/NameAddressSSNSummary'));
	
	SELF.Rep4RI_seq1		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[1]/Sequence'));
	SELF.Rep4RI_Code1		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[1]/RiskCode'));
	SELF.Rep4RI_Desc1		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[1]/Description'));
		
	SELF.Rep4RI_seq2		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[2]/Sequence'));
	SELF.Rep4RI_Code2		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[2]/RiskCode'));
	SELF.Rep4RI_Desc2		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[2]/Description'));
		
	SELF.Rep4RI_seq3		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[3]/Sequence'));
	SELF.Rep4RI_Code3		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[3]/RiskCode'));
	SELF.Rep4RI_Desc3		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[3]/Description'));
		
	SELF.Rep4RI_seq4		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[4]/Sequence'));
	SELF.Rep4RI_Code4		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[4]/RiskCode'));
	SELF.Rep4RI_Desc4		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[4]/Description'));
		
	SELF.Rep4RI_seq5		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[5]/Sequence'));
	SELF.Rep4RI_Code5		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[5]/RiskCode'));
	SELF.Rep4RI_Desc5		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[5]/Description'));
		
	SELF.Rep4RI_seq6		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[6]/Sequence'));
	SELF.Rep4RI_Code6		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[6]/RiskCode'));
	SELF.Rep4RI_Desc6		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[6]/Description'));
		
	SELF.Rep4RI_seq7		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[7]/Sequence'));
	SELF.Rep4RI_Code7		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[7]/RiskCode'));
	SELF.Rep4RI_Desc7		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[7]/Description'));
		
	SELF.Rep4RI_seq8		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[8]/Sequence'));
	SELF.Rep4RI_Code8		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[8]/RiskCode'));
	SELF.Rep4RI_Desc8		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[8]/Description'));
		
	SELF.Rep4RI_seq9		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[9]/Sequence'));
	SELF.Rep4RI_Code9		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[9]/RiskCode'));
	SELF.Rep4RI_Desc9		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[9]/Description'));
		
	SELF.Rep4RI_seq10		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[10]/Sequence'));
	SELF.Rep4RI_Code10		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[10]/RiskCode'));
	SELF.Rep4RI_Desc10		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[10]/Description'));
	
	//AuthorizedRepresentativeResult5
	SELF.Rep5UniqueId		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/UniqueId'));
	SELF.Rep5CVI		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/ComprehensiveVerificationIndex'));
	SELF.Rep5NAP		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/NameAddressPhoneSummary'));
	SELF.Rep5NAS		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/NameAddressSSNSummary'));
	
	SELF.Rep5RI_seq1		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[1]/Sequence'));
	SELF.Rep5RI_Code1		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[1]/RiskCode'));
	SELF.Rep5RI_Desc1		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[1]/Description'));
		
	SELF.Rep5RI_seq2		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[2]/Sequence'));
	SELF.Rep5RI_Code2		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[2]/RiskCode'));
	SELF.Rep5RI_Desc2		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[2]/Description'));
		
	SELF.Rep5RI_seq3		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[3]/Sequence'));
	SELF.Rep5RI_Code3		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[3]/RiskCode'));
	SELF.Rep5RI_Desc3		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[3]/Description'));
		
	SELF.Rep5RI_seq4		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[4]/Sequence'));
	SELF.Rep5RI_Code4		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[4]/RiskCode'));
	SELF.Rep5RI_Desc4		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[4]/Description'));
		
	SELF.Rep5RI_seq5		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[5]/Sequence'));
	SELF.Rep5RI_Code5		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[5]/RiskCode'));
	SELF.Rep5RI_Desc5		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[5]/Description'));
		
	SELF.Rep5RI_seq6		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[6]/Sequence'));
	SELF.Rep5RI_Code6		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[6]/RiskCode'));
	SELF.Rep5RI_Desc6		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[6]/Description'));
		
	SELF.Rep5RI_seq7		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[7]/Sequence'));
	SELF.Rep5RI_Code7		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[7]/RiskCode'));
	SELF.Rep5RI_Desc7		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[7]/Description'));
		
	SELF.Rep5RI_seq8		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[8]/Sequence'));
	SELF.Rep5RI_Code8		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[8]/RiskCode'));
	SELF.Rep5RI_Desc8		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[8]/Description'));
		
	SELF.Rep5RI_seq9		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[9]/Sequence'));
	SELF.Rep5RI_Code9		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[9]/RiskCode'));
	SELF.Rep5RI_Desc9		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[9]/Description'));
		
	SELF.Rep5RI_seq10		:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[10]/Sequence'));
	SELF.Rep5RI_Code10	:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[10]/RiskCode'));
	SELF.Rep5RI_Desc10	:= TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[10]/Description'));
	SELF := [];
END;

parsedOutput := PARSE(Good_Logs, outputxml, parseOutput(), XML('BusinessInstantID2'));

OUTPUT(CHOOSEN(parsedOutput, eyeball), NAMED('Sample_Parsed_Output'));

OUTPUT(COUNT(parsedOutput), NAMED('parsedOutput'));


Parsed_BusinessIID2_Layout combineParsedRecords(Parsed_BusinessIID2_Layout le, Parsed_BusinessIID2_Layout ri) := TRANSFORM
SELF.NumberValidAuthRepsInput:=ri.NumberValidAuthRepsInput;
SELF.CompanySeleID:=ri.CompanySeleID;
SELF.VerCompanyName := ri.VerCompanyName;
SELF.VerCompanyAddr := ri.VerCompanyAddr;
SELF.VerCompanyCity := ri.VerCompanyCity;
SELF.VerCompanyState:= ri.VerCompanyState;
SELF.VerCompanyZip  := ri.VerCompanyZip;
SELF.VerCompanyPhone:= ri.VerCompanyPhone;
SELF.VerCompanyFEIN := ri.VerCompanyFEIN;
SELF.CompanyBusinessVerificationIndex:=ri.CompanyBusinessVerificationIndex;
SELF.CompanyBusinessVerificationDesc:=ri.CompanyBusinessVerificationDesc;
SELF.CompanyPRI_Seq1:=ri.CompanyPRI_Seq1;
SELF.CompanyPRI_Code1:=ri.CompanyPRI_Code1;
SELF.CompanyPRI_Desc1:=ri.CompanyPRI_Desc1;
SELF.CompanyPRI_Seq2:=ri.CompanyPRI_Seq2;
SELF.CompanyPRI_Code2:=ri.CompanyPRI_Code2;
SELF.CompanyPRI_Desc2:=ri.CompanyPRI_Desc2;
SELF.CompanyPRI_Seq3:=ri.CompanyPRI_Seq3;
SELF.CompanyPRI_Code3:=ri.CompanyPRI_Code3;
SELF.CompanyPRI_Desc3:=ri.CompanyPRI_Desc3;
SELF.CompanyPRI_Seq4:=ri.CompanyPRI_Seq4;
SELF.CompanyPRI_Code4:=ri.CompanyPRI_Code4;
SELF.CompanyPRI_Desc4:=ri.CompanyPRI_Desc4;
SELF.CompanyPRI_Seq5:=ri.CompanyPRI_Seq5;
SELF.CompanyPRI_Code5:=ri.CompanyPRI_Code5;
SELF.CompanyPRI_Desc5:=ri.CompanyPRI_Desc5;
SELF.CompanyPRI_Seq6:=ri.CompanyPRI_Seq6;
SELF.CompanyPRI_Code6:=ri.CompanyPRI_Code6;
SELF.CompanyPRI_Desc6:=ri.CompanyPRI_Desc6;
SELF.CompanyPRI_Seq7:=ri.CompanyPRI_Seq7;
SELF.CompanyPRI_Code7:=ri.CompanyPRI_Code7;
SELF.CompanyPRI_Desc7:=ri.CompanyPRI_Desc7;
SELF.CompanyPRI_Seq8:=ri.CompanyPRI_Seq8;
SELF.CompanyPRI_Code8:=ri.CompanyPRI_Code8;
SELF.CompanyPRI_Desc8:=ri.CompanyPRI_Desc8;
SELF.CompanyResidentialDesc:=ri.CompanyResidentialDesc;
SELF.CompanySOSFilingName:=ri.CompanySOSFilingName;
SELF.CompanyVeriSummary_Type1:=ri.CompanyVeriSummary_Type1;
SELF.CompanyVeriSummary_Index1:=ri.CompanyVeriSummary_Index1;
SELF.CompanyVeriSummary_Desc1:=ri.CompanyVeriSummary_Desc1;
SELF.CompanyVeriSummary_Type2:=ri.CompanyVeriSummary_Type2;
SELF.CompanyVeriSummary_Index2:=ri.CompanyVeriSummary_Index2;
SELF.CompanyVeriSummary_Desc2:=ri.CompanyVeriSummary_Desc2;
SELF.CompanyVeriSummary_Type3:=ri.CompanyVeriSummary_Type3;
SELF.CompanyVeriSummary_Index3:=ri.CompanyVeriSummary_Index3;
SELF.CompanyVeriSummary_Desc3:=ri.CompanyVeriSummary_Desc3;
SELF.CompanyVeriSummary_Type4:=ri.CompanyVeriSummary_Type4;
SELF.CompanyVeriSummary_Index4:=ri.CompanyVeriSummary_Index4;
SELF.CompanyVeriSummary_Desc4:=ri.CompanyVeriSummary_Desc4;
SELF.CompanyVeriSummary_Type5:=ri.CompanyVeriSummary_Type5;
SELF.CompanyVeriSummary_Index5:=ri.CompanyVeriSummary_Index5;
SELF.CompanyVeriSummary_Desc5:=ri.CompanyVeriSummary_Desc5;
SELF.BusToExexIndex_Rep1:=ri.BusToExexIndex_Rep1;
SELF.BusToExexIndex_Index1:=ri.BusToExexIndex_Index1;
SELF.BusToExexIndex_Desc1:=ri.BusToExexIndex_Desc1;
SELF.BusToExexIndex_Rep2:=ri.BusToExexIndex_Rep2;
SELF.BusToExexIndex_Index2:=ri.BusToExexIndex_Index2;
SELF.BusToExexIndex_Desc2:=ri.BusToExexIndex_Desc2;
SELF.BusToExexIndex_Rep3:=ri.BusToExexIndex_Rep3;
SELF.BusToExexIndex_Index3:=ri.BusToExexIndex_Index3;
SELF.BusToExexIndex_Desc3:=ri.BusToExexIndex_Desc3;
SELF.BusToExexIndex_Rep4:=ri.BusToExexIndex_Rep4;
SELF.BusToExexIndex_Index4:=ri.BusToExexIndex_Index4;
SELF.BusToExexIndex_Desc4:=ri.BusToExexIndex_Desc4;
SELF.BusToExexIndex_Rep5:=ri.BusToExexIndex_Rep5;
SELF.BusToExexIndex_Index5:=ri.BusToExexIndex_Index5;
SELF.BusToExexIndex_Desc5:=ri.BusToExexIndex_Desc5;
SELF.Rep1UniqueId:=ri.Rep1UniqueId;
SELF.Rep1CVI:=ri.Rep1CVI;
SELF.Rep1NAP:=ri.Rep1NAP;
SELF.Rep1NAS:=ri.Rep1NAS;
SELF.Rep1RI_seq1:=ri.Rep1RI_seq1;
SELF.Rep1RI_Code1:=ri.Rep1RI_Code1;
SELF.Rep1RI_Desc1:=ri.Rep1RI_Desc1;
SELF.Rep1RI_seq2:=ri.Rep1RI_seq2;
SELF.Rep1RI_Code2:=ri.Rep1RI_Code2;
SELF.Rep1RI_Desc2:=ri.Rep1RI_Desc2;
SELF.Rep1RI_seq3:=ri.Rep1RI_seq3;
SELF.Rep1RI_Code3:=ri.Rep1RI_Code3;
SELF.Rep1RI_Desc3:=ri.Rep1RI_Desc3;
SELF.Rep1RI_seq4:=ri.Rep1RI_seq4;
SELF.Rep1RI_Code4:=ri.Rep1RI_Code4;
SELF.Rep1RI_Desc4:=ri.Rep1RI_Desc4;
SELF.Rep1RI_seq5:=ri.Rep1RI_seq5;
SELF.Rep1RI_Code5:=ri.Rep1RI_Code5;
SELF.Rep1RI_Desc5:=ri.Rep1RI_Desc5;
SELF.Rep1RI_seq6:=ri.Rep1RI_seq6;
SELF.Rep1RI_Code6:=ri.Rep1RI_Code6;
SELF.Rep1RI_Desc6:=ri.Rep1RI_Desc6;
SELF.Rep1RI_seq7:=ri.Rep1RI_seq7;
SELF.Rep1RI_Code7:=ri.Rep1RI_Code7;
SELF.Rep1RI_Desc7:=ri.Rep1RI_Desc7;
SELF.Rep1RI_seq8:=ri.Rep1RI_seq8;
SELF.Rep1RI_Code8:=ri.Rep1RI_Code8;
SELF.Rep1RI_Desc8:=ri.Rep1RI_Desc8;
SELF.Rep1RI_seq9:=ri.Rep1RI_seq9;
SELF.Rep1RI_Code9:=ri.Rep1RI_Code9;
SELF.Rep1RI_Desc9:=ri.Rep1RI_Desc9;
SELF.Rep1RI_seq10:=ri.Rep1RI_seq10;
SELF.Rep1RI_Code10:=ri.Rep1RI_Code10;
SELF.Rep1RI_Desc10:=ri.Rep1RI_Desc10;
SELF.Rep2UniqueId:=ri.Rep2UniqueId;
SELF.Rep2CVI:=ri.Rep2CVI;
SELF.Rep2NAP:=ri.Rep2NAP;
SELF.Rep2NAS:=ri.Rep2NAS;
SELF.Rep2RI_seq1:=ri.Rep2RI_seq1;
SELF.Rep2RI_Code1:=ri.Rep2RI_Code1;
SELF.Rep2RI_Desc1:=ri.Rep2RI_Desc1;
SELF.Rep2RI_seq2:=ri.Rep2RI_seq2;
SELF.Rep2RI_Code2:=ri.Rep2RI_Code2;
SELF.Rep2RI_Desc2:=ri.Rep2RI_Desc2;
SELF.Rep2RI_seq3:=ri.Rep2RI_seq3;
SELF.Rep2RI_Code3:=ri.Rep2RI_Code3;
SELF.Rep2RI_Desc3:=ri.Rep2RI_Desc3;
SELF.Rep2RI_seq4:=ri.Rep2RI_seq4;
SELF.Rep2RI_Code4:=ri.Rep2RI_Code4;
SELF.Rep2RI_Desc4:=ri.Rep2RI_Desc4;
SELF.Rep2RI_seq5:=ri.Rep2RI_seq5;
SELF.Rep2RI_Code5:=ri.Rep2RI_Code5;
SELF.Rep2RI_Desc5:=ri.Rep2RI_Desc5;
SELF.Rep2RI_seq6:=ri.Rep2RI_seq6;
SELF.Rep2RI_Code6:=ri.Rep2RI_Code6;
SELF.Rep2RI_Desc6:=ri.Rep2RI_Desc6;
SELF.Rep2RI_seq7:=ri.Rep2RI_seq7;
SELF.Rep2RI_Code7:=ri.Rep2RI_Code7;
SELF.Rep2RI_Desc7:=ri.Rep2RI_Desc7;
SELF.Rep2RI_seq8:=ri.Rep2RI_seq8;
SELF.Rep2RI_Code8:=ri.Rep2RI_Code8;
SELF.Rep2RI_Desc8:=ri.Rep2RI_Desc8;
SELF.Rep2RI_seq9:=ri.Rep2RI_seq9;
SELF.Rep2RI_Code9:=ri.Rep2RI_Code9;
SELF.Rep2RI_Desc9:=ri.Rep2RI_Desc9;
SELF.Rep2RI_seq10:=ri.Rep2RI_seq10;
SELF.Rep2RI_Code10:=ri.Rep2RI_Code10;
SELF.Rep2RI_Desc10:=ri.Rep2RI_Desc10;
SELF.Rep3UniqueId:=ri.Rep3UniqueId;
SELF.Rep3CVI:=ri.Rep3CVI;
SELF.Rep3NAP:=ri.Rep3NAP;
SELF.Rep3NAS:=ri.Rep3NAS;
SELF.Rep3RI_seq1:=ri.Rep3RI_seq1;
SELF.Rep3RI_Code1:=ri.Rep3RI_Code1;
SELF.Rep3RI_Desc1:=ri.Rep3RI_Desc1;
SELF.Rep3RI_seq2:=ri.Rep3RI_seq2;
SELF.Rep3RI_Code2:=ri.Rep3RI_Code2;
SELF.Rep3RI_Desc2:=ri.Rep3RI_Desc2;
SELF.Rep3RI_seq3:=ri.Rep3RI_seq3;
SELF.Rep3RI_Code3:=ri.Rep3RI_Code3;
SELF.Rep3RI_Desc3:=ri.Rep3RI_Desc3;
SELF.Rep3RI_seq4:=ri.Rep3RI_seq4;
SELF.Rep3RI_Code4:=ri.Rep3RI_Code4;
SELF.Rep3RI_Desc4:=ri.Rep3RI_Desc4;
SELF.Rep3RI_seq5:=ri.Rep3RI_seq5;
SELF.Rep3RI_Code5:=ri.Rep3RI_Code5;
SELF.Rep3RI_Desc5:=ri.Rep3RI_Desc5;
SELF.Rep3RI_seq6:=ri.Rep3RI_seq6;
SELF.Rep3RI_Code6:=ri.Rep3RI_Code6;
SELF.Rep3RI_Desc6:=ri.Rep3RI_Desc6;
SELF.Rep3RI_seq7:=ri.Rep3RI_seq7;
SELF.Rep3RI_Code7:=ri.Rep3RI_Code7;
SELF.Rep3RI_Desc7:=ri.Rep3RI_Desc7;
SELF.Rep3RI_seq8:=ri.Rep3RI_seq8;
SELF.Rep3RI_Code8:=ri.Rep3RI_Code8;
SELF.Rep3RI_Desc8:=ri.Rep3RI_Desc8;
SELF.Rep3RI_seq9:=ri.Rep3RI_seq9;
SELF.Rep3RI_Code9:=ri.Rep3RI_Code9;
SELF.Rep3RI_Desc9:=ri.Rep3RI_Desc9;
SELF.Rep3RI_seq10:=ri.Rep3RI_seq10;
SELF.Rep3RI_Code10:=ri.Rep3RI_Code10;
SELF.Rep3RI_Desc10:=ri.Rep3RI_Desc10;
SELF.Rep4UniqueId:=ri.Rep4UniqueId;
SELF.Rep4CVI:=ri.Rep4CVI;
SELF.Rep4NAP:=ri.Rep4NAP;
SELF.Rep4NAS:=ri.Rep4NAS;
SELF.Rep4RI_seq1:=ri.Rep4RI_seq1;
SELF.Rep4RI_Code1:=ri.Rep4RI_Code1;
SELF.Rep4RI_Desc1:=ri.Rep4RI_Desc1;
SELF.Rep4RI_seq2:=ri.Rep4RI_seq2;
SELF.Rep4RI_Code2:=ri.Rep4RI_Code2;
SELF.Rep4RI_Desc2:=ri.Rep4RI_Desc2;
SELF.Rep4RI_seq3:=ri.Rep4RI_seq3;
SELF.Rep4RI_Code3:=ri.Rep4RI_Code3;
SELF.Rep4RI_Desc3:=ri.Rep4RI_Desc3;
SELF.Rep4RI_seq4:=ri.Rep4RI_seq4;
SELF.Rep4RI_Code4:=ri.Rep4RI_Code4;
SELF.Rep4RI_Desc4:=ri.Rep4RI_Desc4;
SELF.Rep4RI_seq5:=ri.Rep4RI_seq5;
SELF.Rep4RI_Code5:=ri.Rep4RI_Code5;
SELF.Rep4RI_Desc5:=ri.Rep4RI_Desc5;
SELF.Rep4RI_seq6:=ri.Rep4RI_seq6;
SELF.Rep4RI_Code6:=ri.Rep4RI_Code6;
SELF.Rep4RI_Desc6:=ri.Rep4RI_Desc6;
SELF.Rep4RI_seq7:=ri.Rep4RI_seq7;
SELF.Rep4RI_Code7:=ri.Rep4RI_Code7;
SELF.Rep4RI_Desc7:=ri.Rep4RI_Desc7;
SELF.Rep4RI_seq8:=ri.Rep4RI_seq8;
SELF.Rep4RI_Code8:=ri.Rep4RI_Code8;
SELF.Rep4RI_Desc8:=ri.Rep4RI_Desc8;
SELF.Rep4RI_seq9:=ri.Rep4RI_seq9;
SELF.Rep4RI_Code9:=ri.Rep4RI_Code9;
SELF.Rep4RI_Desc9:=ri.Rep4RI_Desc9;
SELF.Rep4RI_seq10:=ri.Rep4RI_seq10;
SELF.Rep4RI_Code10:=ri.Rep4RI_Code10;
SELF.Rep4RI_Desc10:=ri.Rep4RI_Desc10;
SELF.Rep5UniqueId:=ri.Rep5UniqueId;
SELF.Rep5CVI:=ri.Rep5CVI;
SELF.Rep5NAP:=ri.Rep5NAP;
SELF.Rep5NAS:=ri.Rep5NAS;
SELF.Rep5RI_seq1:=ri.Rep5RI_seq1;
SELF.Rep5RI_Code1:=ri.Rep5RI_Code1;
SELF.Rep5RI_Desc1:=ri.Rep5RI_Desc1;
SELF.Rep5RI_seq2:=ri.Rep5RI_seq2;
SELF.Rep5RI_Code2:=ri.Rep5RI_Code2;
SELF.Rep5RI_Desc2:=ri.Rep5RI_Desc2;
SELF.Rep5RI_seq3:=ri.Rep5RI_seq3;
SELF.Rep5RI_Code3:=ri.Rep5RI_Code3;
SELF.Rep5RI_Desc3:=ri.Rep5RI_Desc3;
SELF.Rep5RI_seq4:=ri.Rep5RI_seq4;
SELF.Rep5RI_Code4:=ri.Rep5RI_Code4;
SELF.Rep5RI_Desc4:=ri.Rep5RI_Desc4;
SELF.Rep5RI_seq5:=ri.Rep5RI_seq5;
SELF.Rep5RI_Code5:=ri.Rep5RI_Code5;
SELF.Rep5RI_Desc5:=ri.Rep5RI_Desc5;
SELF.Rep5RI_seq6:=ri.Rep5RI_seq6;
SELF.Rep5RI_Code6:=ri.Rep5RI_Code6;
SELF.Rep5RI_Desc6:=ri.Rep5RI_Desc6;
SELF.Rep5RI_seq7:=ri.Rep5RI_seq7;
SELF.Rep5RI_Code7:=ri.Rep5RI_Code7;
SELF.Rep5RI_Desc7:=ri.Rep5RI_Desc7;
SELF.Rep5RI_seq8:=ri.Rep5RI_seq8;
SELF.Rep5RI_Code8:=ri.Rep5RI_Code8;
SELF.Rep5RI_Desc8:=ri.Rep5RI_Desc8;
SELF.Rep5RI_seq9:=ri.Rep5RI_seq9;
SELF.Rep5RI_Code9:=ri.Rep5RI_Code9;
SELF.Rep5RI_Desc9:=ri.Rep5RI_Desc9;
SELF.Rep5RI_seq10:=ri.Rep5RI_seq10;
SELF.Rep5RI_Code10:=ri.Rep5RI_Code10;
SELF.Rep5RI_Desc10:=ri.Rep5RI_Desc10;
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
 