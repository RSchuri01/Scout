#workunit('name', 'PremiseAssociation_Pull_SCOUT_Logs');
#STORED('historyfreq', '7yrs');
IMPORT scout, STD;

Product := 'PremiseAssociation';
//Date is in format YYYYMMDD HHMMSS
BeginDate := '20190201';
EndDate := '20190201'; 
eyeball := 100;
companyNameFilter := ''; // Set to BLANK '' to not filter by company name.  This filter is typically only needed for companies such as Experian who resell our products.

AccountIDs := ['']; // Set to a blank string dataset [''] to pull all records except for test transaction login ids

outputFile := '~fallen::out::PremiseAssociation_SCOUT_' + BeginDate + '-' + EndDate + '_' + AccountIDs[1];

BaseScoutFile := scout.logs.keys.key_scorelogs_scout_transactionID.superFileData();
BaseLogFile := scout.logs.keys.key_scorelogs_XMLTransactionID.superFileData();

Pulled_ScoutFile := distribute(pull(BaseScoutFile));

ScoutFile_Raw := IF(AccountIDs[1] != '', Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['PREMISEASSOCIATION'] AND datetime[1..8] BETWEEN BeginDate AND EndDate AND (string)company_id IN AccountIDs AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs),
									     Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN ['PREMISEASSOCIATION'] AND datetime[1..8] BETWEEN BeginDate AND EndDate AND STD.Str.ToLowerCase(TRIM(login_id)) NOT IN scout.ad_hoc_reporting.constants.IgnoredLogins AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs));

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

Parsed_Layout := RECORD
	STRING30	TransactionID       := ''; // Forced into the record so I can join it all together
	STRING10	AccountID           := '';
    STRING20    LoginID             := '';
	STRING8		TransactionDate     := '';
	STRING150	EndUserCompanyName  := '';
	STRING30	FirstName           := '';
	STRING30	LastName            := '';
	STRING70	FullName            := '';
	STRING9		SSN                 := '';
	STRING8		DOB                 := '';
	STRING120	Address             := '';
	STRING25	City                := '';
	STRING2		State               := '';
	STRING9		Zip                 := '';
	STRING10	HomePhone           := '';
	STRING10	WorkPhone           := '';
	
	STRING2		AddressReportingSourceIndex     := '';
	STRING2		AddressReportingHistoryIndex    := '';
	STRING2		AddressSearchHistoryIndex       := '';
	STRING2		AddressUtilityHistoryIndex      := '';
	STRING2		AddressAssociationIndex         := '';
	STRING2		AddressPropertyTypeIndex        := '';
	STRING2		AddressValidityIndex            := '';
	STRING2		RelativesConfirmingAddressIndex := '';
	STRING2		AddressAssociationMailAddrIndex := '';
	STRING2		PriorAddressMoveIndex           := '';
	STRING2		PriorResidentMoveIndex          := '';
	STRING6		AddressDateFirstSeen            := '';
	STRING6		AddressDateLastSeen             := '';
	STRING2		OccupancyOverride               := '';
	STRING2		PremiseAssociationScore         := '';
END;

Parsed_Layout parseInput () := TRANSFORM
	SELF.TransactionID      := TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
	SELF.EndUserCompanyName := TRIM(XMLTEXT('User/EndUser/CompanyName'));
	SELF.FirstName          := TRIM(XMLTEXT('SearchBy/Name/First'));
	SELF.LastName           := TRIM(XMLTEXT('SearchBy/Name/Last'));
	SELF.FullName           := TRIM(XMLTEXT('SearchBy/Name/Full'));
	SELF.SSN                := scout.ad_hoc_reporting.Common.ParseSSN(XMLTEXT('SearchBy/SSN'));
	SELF.DOB                := TRIM(XMLTEXT('SearchBy/DOB')) + scout.ad_hoc_reporting.Common.ParseDate(XMLTEXT('SearchBy/DOB/Year'), XMLTEXT('SearchBy/DOB/Month'), XMLTEXT('SearchBy/DOB/Day'));
	SELF.Address            := scout.ad_hoc_reporting.Common.ParseAddress(XMLTEXT('SearchBy/Address/StreetAddress1'), XMLTEXT('SearchBy/Address/StreetAddress2'), XMLTEXT('SearchBy/Address/StreetNumber'),
                                                                          XMLTEXT('SearchBy/Address/StreetPreDirection'), XMLTEXT('SearchBy/Address/StreetName'), XMLTEXT('SearchBy/Address/StreetSuffix'),
                                                                          XMLTEXT('SearchBy/Address/StreetPostDirection'), XMLTEXT('SearchBy/Address/UnitDesignation'), XMLTEXT('SearchBy/Address/UnitNumber'));
	SELF.City               := TRIM(XMLTEXT('SearchBy/Address/City'));
	SELF.State              := TRIM(XMLTEXT('SearchBy/Address/State'));
	SELF.Zip                := scout.ad_hoc_reporting.Common.ParseZIP(XMLTEXT('SearchBy/Address/Zip5'));
	SELF.HomePhone          := scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/HomePhone'));
	SELF.WorkPhone          := scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('SearchBy/WorkPhone'));
	
	SELF := [];
END;

parsedInput := DISTRIBUTE(PARSE(Good_Logs, inputxml, parseInput(), XML('PremiseAssociation')), HASH64(TransactionID));
OUTPUT(CHOOSEN(parsedInput, eyeball), NAMED('Sample_parsedInput'));

Parsed_Layout parseOutput () := TRANSFORM
	SELF.TransactionID	:= TRIM(XMLTEXT('Header/TransactionId')); // Forced into the record so I can join it all together
	SELF.AddressReportingSourceIndex        := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[1]/Value'));
	SELF.AddressReportingHistoryIndex       := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[2]/Value'));
	SELF.AddressSearchHistoryIndex          := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[3]/Value'));
	SELF.AddressUtilityHistoryIndex         := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[4]/Value'));
	SELF.AddressAssociationIndex            := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[5]/Value'));
	SELF.AddressPropertyTypeIndex           := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[6]/Value'));
	SELF.AddressValidityIndex               := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[7]/Value'));
	SELF.RelativesConfirmingAddressIndex    := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[8]/Value'));
	SELF.AddressAssociationMailAddrIndex    := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[9]/Value'));
	SELF.PriorAddressMoveIndex              := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[10]/Value'));
	SELF.PriorResidentMoveIndex             := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[11]/Value'));
	SELF.AddressDateFirstSeen               := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[12]/Value'));
	SELF.AddressDateLastSeen                := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[13]/Value'));
	SELF.OccupancyOverride                  := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[14]/Value'));
	SELF.PremiseAssociationScore            := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[15]/Value'));
	SELF := [];
END;

parsedOutput := PARSE(Good_Logs, outputxml, parseOutput(), XML('PremiseAssociation'));
OUTPUT(CHOOSEN(parsedOutput, eyeball), NAMED('Sample_ParsedOutput'));


Parsed_Layout combineParsedRecords(Parsed_Layout le, Parsed_Layout ri) := TRANSFORM
	SELF.AddressReportingSourceIndex        := ri.AddressReportingSourceIndex;
	SELF.AddressReportingHistoryIndex       := ri.AddressReportingHistoryIndex;
	SELF.AddressSearchHistoryIndex          := ri.AddressSearchHistoryIndex;
	SELF.AddressUtilityHistoryIndex         := ri.AddressUtilityHistoryIndex;
	SELF.AddressAssociationIndex            := ri.AddressAssociationIndex;
	SELF.AddressPropertyTypeIndex           := ri.AddressPropertyTypeIndex;
	SELF.AddressValidityIndex               := ri.AddressValidityIndex;
	SELF.RelativesConfirmingAddressIndex    := ri.RelativesConfirmingAddressIndex;
	SELF.AddressAssociationMailAddrIndex    := ri.AddressAssociationMailAddrIndex;
	SELF.PriorAddressMoveIndex              := ri.PriorAddressMoveIndex;
	SELF.PriorResidentMoveIndex             := ri.PriorResidentMoveIndex;
	SELF.AddressDateFirstSeen               := ri.AddressDateFirstSeen;
	SELF.AddressDateLastSeen                := ri.AddressDateLastSeen;
	SELF.OccupancyOverride                  := ri.OccupancyOverride;
	SELF.PremiseAssociationScore            := ri.PremiseAssociationScore;
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

#if(companyNameFilter = '')

#else
	companyFilteredRecords := finalRecords (StringLib.StringToUpperCase(EndUserCompanyName) = companyNameFilter);
	OUTPUT(COUNT(companyFilteredRecords), NAMED('Total_Company_Records'));
	OUTPUT(companyFilteredRecords,, outputFile + '_' + companyNameFilter + '_' + Std.system.Job.wuid() + '.csv', CSV(HEADING(single), QUOTE('"')), EXPIRE(30), OVERWRITE);
#end

/* ***********************************************************************************************
 *************************************************************************************************
 *             MODIFY EVERYTHING BELOW AS NEEDED TO PERFORM SAOT ANALYSIS                        *
 *************************************************************************************************
 *********************************************************************************************** */
