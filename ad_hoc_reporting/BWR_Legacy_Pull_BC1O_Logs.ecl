#workunit('name', 'RiskWiseMainBC1O_Pull_SCOUT_Logs');
#STORED('historyfreq', '7yrs');
IMPORT scout, STD;

Product := 'RiskWise.RiskWiseMainBC1O';
//Date is in format YYYYMMDD HHMMSS
BeginDate := '20190201';
EndDate := '20190201'; 
eyeball := 100;  

AccountIDs := ['']; // Set to a blank string dataset [''] to pull all records except for test transaction login ids
Login_ID := ''; // Set to blank to include all records for the above Account ID, otherwise this will filter to only include records with this LoginID.

//Valid trib codes are bnk4 or cbbl
//Set value to true for which trib code is needed
//Must have only one active at a time
BNK4 := TRUE;
CBBL := FALSE;

#if(BNK4)
    Trib_Code := ['BNK4']; // only include records wtih this TribCode.
#elseif(CBBL)
    Trib_Code := ['CBBL']; // only include records wtih this TribCode.
#else
    Trib_Code := ['']; ////this conditon shouldn't happen
#end

outputFile := '~fallen::out::BC1O_SCOUT_' + BeginDate + '-' + EndDate + '_' + AccountIDs[1];

BaseScoutFile := scout.logs.keys.key_scorelogs_scout_transactionID.superFileData();
BaseLogFile := scout.logs.keys.key_scorelogs_XMLTransactionID.superFileData();

Pulled_ScoutFile := distribute(pull(BaseScoutFile));

ScoutFile_Raw := IF(AccountIDs[1] != '', Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN Trib_Code AND datetime[1..8] BETWEEN BeginDate AND EndDate AND (string)company_id IN AccountIDs AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs),
									     Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN Trib_Code AND datetime[1..8] BETWEEN BeginDate AND EndDate AND STD.Str.ToLowerCase(TRIM(login_id)) NOT IN scout.ad_hoc_reporting.constants.IgnoredLogins AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs));

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

scout.ad_hoc_reporting.Layouts.Parsed_RiskWiseMainBC1O_Layout parseInput () := TRANSFORM
	SELF.TransactionID          := TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
	SELF._LoginId               := TRIM(XMLTEXT('_LoginId'));
	SELF.TribCode               := TRIM(XMLTEXT('tribcode'));
	SELF.DataRestrictionMask    := TRIM(XMLTEXT('DataRestrictionMask'));
	SELF.Account                := TRIM(XMLTEXT('account'));
	SELF.FirstName              := TRIM(XMLTEXT('first'));
	SELF.LastName               := TRIM(XMLTEXT('last'));
	SELF.Address                := TRIM(XMLTEXT('addr'));
	SELF.City                   := TRIM(XMLTEXT('city'));
	SELF.State                  := TRIM(XMLTEXT('state'));
	SELF.Zip                    := scout.ad_hoc_reporting.Common.ParseZIP(TRIM(XMLTEXT('zip')));
	SELF.SSN                    := scout.ad_hoc_reporting.Common.ParseSSN(TRIM(XMLTEXT('socs')));
	SELF.DateOfBirth            := TRIM(XMLTEXT('dob'));
	SELF.HomePhone              := scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('hphone'));
	SELF.WorkPhone              := scout.ad_hoc_reporting.Common.ParsePhone(XMLTEXT('wphone'));
	SELF.Income                 := TRIM(XMLTEXT('income'));
	SELF.CompanyName            := TRIM(XMLTEXT('cmpy'));
	SELF.CompanyAddress         := TRIM(XMLTEXT('cmpyaddr'));
	SELF.CompanyCity            := TRIM(XMLTEXT('cmpycity'));
	SELF.CompanyState           := TRIM(XMLTEXT('cmpystate'));
	SELF.CompanyZIP             := TRIM(XMLTEXT('cmpyzip'));
	SELF.FEIN                   := TRIM(XMLTEXT('fin'));
	
	SELF := [];
END;

parsedInput := DISTRIBUTE(PARSE(Good_Logs, inputxml, parseInput(), XML('RiskWise.RiskWiseMainBC1O')), HASH64(TransactionID));
OUTPUT(CHOOSEN(parsedInput, eyeball), NAMED('Sample_Parsed_Input'));


scout.ad_hoc_reporting.Layouts.Parsed_RiskWiseMainBC1O_Layout parseOutput () := TRANSFORM
	SELF.TransactionID             := TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
	SELF.RiskWiseID                := TRIM(XMLTEXT('riskwiseid'));
	SELF.FirstCount                := TRIM(XMLTEXT('firstcount'));
	SELF.LastCount                 := TRIM(XMLTEXT('lastcount'));
	SELF.AddrCount                 := TRIM(XMLTEXT('addrcount'));
	SELF.PhoneCount                := TRIM(XMLTEXT('phonecount'));
	SELF.SSNCount                  := TRIM(XMLTEXT('socscount'));
	SELF.SSNVerLevel               := TRIM(XMLTEXT('socsverlevel'));
	SELF.DOBCount                  := TRIM(XMLTEXT('dobcount'));
	SELF.DriverLicenseCount        := TRIM(XMLTEXT('drlccount'));
	SELF.CompanyCount              := TRIM(XMLTEXT('cmpycount'));
	SELF.CompanyAddressCount       := TRIM(XMLTEXT('cmpyaddrcount'));
	SELF.CompanyPhoneCount         := TRIM(XMLTEXT('cmpyphonecount'));
	SELF.FEINCount                 := TRIM(XMLTEXT('fincount'));
	SELF.EmailCount                := TRIM(XMLTEXT('emailcount'));
	SELF.VerFirstName              := TRIM(XMLTEXT('verfirst'));
	SELF.VerLastName               := TRIM(XMLTEXT('verlast'));
	SELF.VerAddress                := TRIM(XMLTEXT('veraddr'));
	SELF.VerCity                   := TRIM(XMLTEXT('vercity'));
	SELF.VerState                  := TRIM(XMLTEXT('verstate'));
	SELF.VerZIP                    := TRIM(XMLTEXT('verzip'));
	SELF.VerHomePhone              := TRIM(XMLTEXT('verhphone'));
	SELF.VerSSN                    := TRIM(XMLTEXT('versocs'));
	SELF.VerDriverLicense          := TRIM(XMLTEXT('verdrlc'));
	SELF.VerDateOfBirth            := TRIM(XMLTEXT('verdob'));
	SELF.VerCompanyName            := TRIM(XMLTEXT('vercmpy'));
	SELF.VerCompanyAddress         := TRIM(XMLTEXT('vercmpyaddr'));
	SELF.VerCompanyCity            := TRIM(XMLTEXT('vercmpycity'));
	SELF.VerCompanyState           := TRIM(XMLTEXT('vercmpystate'));
	SELF.VerCompanyZIP             := TRIM(XMLTEXT('vercmpyzip'));
	SELF.VerCompanyPhone           := TRIM(XMLTEXT('vercmpyphone'));
	SELF.VerCompanyFEIN            := TRIM(XMLTEXT('verfin'));
	SELF.Numelever                 := TRIM(XMLTEXT('numelever'));
	SELF.NumSource                 := TRIM(XMLTEXT('numsource'));
	SELF.NumCompanyelever          := TRIM(XMLTEXT('numcmpyelever'));
	SELF.NumCompanySource          := TRIM(XMLTEXT('numcmpysource'));
	SELF.FirstScore                := TRIM(XMLTEXT('firstscore'));
	SELF.LastScore                 := TRIM(XMLTEXT('lastscore'));
	SELF.CompanyScore              := TRIM(XMLTEXT('cmpyscore'));
	SELF.AddressScore              := TRIM(XMLTEXT('addrscore'));
	SELF.PhoneScore                := TRIM(XMLTEXT('phonescore'));
	SELF.SSNScore                  := TRIM(XMLTEXT('socscore'));
	SELF.DateOfBirthScore          := TRIM(XMLTEXT('dobscore'));
	SELF.DriverLicenseScore        := TRIM(XMLTEXT('drlcscore'));
	SELF.CompanyScore2             := TRIM(XMLTEXT('cmpyscore2'));
	SELF.CompanyAddressScore       := TRIM(XMLTEXT('cmpyaddrscore'));
	SELF.CompanyPhoneScore         := TRIM(XMLTEXT('cmpyphonescore'));
	SELF.FEINScore                 := TRIM(XMLTEXT('finscore'));
	SELF.EmailScore                := TRIM(XMLTEXT('emailscore'));
	SELF.WPhoneName                := TRIM(XMLTEXT('wphonename'));
	SELF.WPhoneAddress             := TRIM(XMLTEXT('wphoneaddr'));
	SELF.WPhoneCity                := TRIM(XMLTEXT('wphonecity'));
	SELF.WPhoneState               := TRIM(XMLTEXT('wphonestate'));
	SELF.WPhoneZIP                 := TRIM(XMLTEXT('wphonezip'));
	SELF.SSNMiskeyFlag             := TRIM(XMLTEXT('socsmiskeyflag'));
	SELF.PhoneMiskeyFlag           := TRIM(XMLTEXT('phonemiskeyflag'));
	SELF.AddressMiskeyFlag         := TRIM(XMLTEXT('addrmiskeyflag'));
	SELF.IDTheftFlag               := TRIM(XMLTEXT('idtheftflag'));
	SELF.HomePhoneTypeFlag         := TRIM(XMLTEXT('hphonetypeflag'));
	SELF.HomePhoneSrvc             := TRIM(XMLTEXT('hphonesrvc'));
	SELF.HomePhone2AddressTypeFlag := TRIM(XMLTEXT('hphone2addrtypeflag'));
	SELF.HomePhone2TypeFlag        := TRIM(XMLTEXT('hphone2typeflag'));
	SELF.WPhoneTypeFlag            := TRIM(XMLTEXT('wphonetypeflag'));
	SELF.WPhoneSrvc                := TRIM(XMLTEXT('wphonesrvc'));
	SELF.AreaCodeSplitFlag         := TRIM(XMLTEXT('areacodesplitflag'));
	SELF.AltAreaCode               := TRIM(XMLTEXT('altareacode'));
	SELF.PhoneZIPFlag              := TRIM(XMLTEXT('phonezipflag'));
	SELF.SSNDateOfBirth            := TRIM(XMLTEXT('socsdob'));
	SELF.HighRiskPhoneFlag         := TRIM(XMLTEXT('hhriskphoneflag'));
	SELF.HighRiskCompany           := TRIM(XMLTEXT('hriskcmpy'));
	SELF.SICCode                   := TRIM(XMLTEXT('sic'));
	SELF.ZIPClassFlag              := TRIM(XMLTEXT('zipclassflag'));
	SELF.ZIPName                   := TRIM(XMLTEXT('zipname'));
	SELF.MedianIncome              := TRIM(XMLTEXT('medincome'));
	SELF.AddressRiskFlag           := TRIM(XMLTEXT('addrriskflag'));
	SELF.BansFlag                  := TRIM(XMLTEXT('bansflag'));
	SELF.BansDateFiled             := TRIM(XMLTEXT('bansdatefiled'));
	SELF.AddrValFlag               := TRIM(XMLTEXT('addrvalflag'));
	SELF.AddressReason             := TRIM(XMLTEXT('addrreason'));
	SELF.LowIssue                  := TRIM(XMLTEXT('lowissue'));
	SELF.DwellTypeFlag             := TRIM(XMLTEXT('dwelltypeflag'));
	SELF.PhoneDissFlag             := TRIM(XMLTEXT('phonedissflag'));
	SELF.EcoVariables              := TRIM(XMLTEXT('ecovariables'));
	SELF.TCIFull                   := TRIM(XMLTEXT('tcifull'));
	SELF.TCILast                   := TRIM(XMLTEXT('tcilast'));
	SELF.TCIAddr                   := TRIM(XMLTEXT('tciaddr'));
	
	SELF := [];
END;

parsedOutput := PARSE(Good_Logs, outputxml, parseOutput(), XML('RiskWise.RiskWiseMainBC1O'));
OUTPUT(CHOOSEN(parsedOutput, eyeball), NAMED('Sample_Parsed_Output'));


scout.ad_hoc_reporting.Layouts.Parsed_RiskWiseMainBC1O_Layout combineParsedRecords(scout.ad_hoc_reporting.Layouts.Parsed_RiskWiseMainBC1O_Layout le, scout.ad_hoc_reporting.Layouts.Parsed_RiskWiseMainBC1O_Layout ri) := TRANSFORM
	SELF.RiskWiseID                := ri.RiskWiseID               ;
	SELF.FirstCount                := ri.FirstCount               ;
	SELF.LastCount                 := ri.LastCount                ;
	SELF.AddrCount                 := ri.AddrCount                ;
	SELF.PhoneCount                := ri.PhoneCount               ;
	SELF.SSNCount                  := ri.SSNCount                 ;
	SELF.SSNVerLevel               := ri.SSNVerLevel              ;
	SELF.DOBCount                  := ri.DOBCount                 ;
	SELF.DriverLicenseCount        := ri.DriverLicenseCount       ;
	SELF.CompanyCount              := ri.CompanyCount             ;
	SELF.CompanyAddressCount       := ri.CompanyAddressCount      ;
	SELF.CompanyPhoneCount         := ri.CompanyPhoneCount        ;
	SELF.FEINCount                 := ri.FEINCount                ;
	SELF.EmailCount                := ri.EmailCount               ;
	SELF.VerFirstName              := ri.VerFirstName             ;
	SELF.VerLastName               := ri.VerLastName              ;
	SELF.VerAddress                := ri.VerAddress               ;
	SELF.VerCity                   := ri.VerCity                  ;
	SELF.VerState                  := ri.VerState                 ;
	SELF.VerZIP                    := ri.VerZIP                   ;
	SELF.VerHomePhone              := ri.VerHomePhone             ;
	SELF.VerSSN                    := ri.VerSSN                   ;
	SELF.VerDriverLicense          := ri.VerDriverLicense         ;
	SELF.VerDateOfBirth            := ri.VerDateOfBirth           ;
	SELF.VerCompanyName            := ri.VerCompanyName           ;
	SELF.VerCompanyAddress         := ri.VerCompanyAddress        ;
	SELF.VerCompanyCity            := ri.VerCompanyCity           ;
	SELF.VerCompanyState           := ri.VerCompanyState          ;
	SELF.VerCompanyZIP             := ri.VerCompanyZIP            ;
	SELF.VerCompanyPhone           := ri.VerCompanyPhone          ;
	SELF.VerCompanyFEIN            := ri.VerCompanyFEIN           ;
	SELF.Numelever                 := ri.Numelever                ;
	SELF.NumSource                 := ri.NumSource                ;
	SELF.NumCompanyelever          := ri.NumCompanyelever         ;
	SELF.NumCompanySource          := ri.NumCompanySource         ;
	SELF.FirstScore                := ri.FirstScore               ;
	SELF.LastScore                 := ri.LastScore                ;
	SELF.CompanyScore              := ri.CompanyScore             ;
	SELF.AddressScore              := ri.AddressScore             ;
	SELF.PhoneScore                := ri.PhoneScore               ;
	SELF.SSNScore                  := ri.SSNScore                 ;
	SELF.DateOfBirthScore          := ri.DateOfBirthScore         ;
	SELF.DriverLicenseScore        := ri.DriverLicenseScore       ;
	SELF.CompanyScore2             := ri.CompanyScore2            ;
	SELF.CompanyAddressScore       := ri.CompanyAddressScore      ;
	SELF.CompanyPhoneScore         := ri.CompanyPhoneScore        ;
	SELF.FEINScore                 := ri.FEINScore                ;
	SELF.EmailScore                := ri.EmailScore               ;
	SELF.WPhoneName                := ri.WPhoneName               ;
	SELF.WPhoneAddress             := ri.WPhoneAddress            ;
	SELF.WPhoneCity                := ri.WPhoneCity               ;
	SELF.WPhoneState               := ri.WPhoneState              ;
	SELF.WPhoneZIP                 := ri.WPhoneZIP                ;
	SELF.SSNMiskeyFlag             := ri.SSNMiskeyFlag            ;
	SELF.PhoneMiskeyFlag           := ri.PhoneMiskeyFlag          ;
	SELF.AddressMiskeyFlag         := ri.AddressMiskeyFlag        ;
	SELF.IDTheftFlag               := ri.IDTheftFlag              ;
	SELF.HomePhoneTypeFlag         := ri.HomePhoneTypeFlag        ;
	SELF.HomePhoneSrvc             := ri.HomePhoneSrvc            ;
	SELF.HomePhone2AddressTypeFlag := ri.HomePhone2AddressTypeFlag;
	SELF.HomePhone2TypeFlag        := ri.HomePhone2TypeFlag       ;
	SELF.WPhoneTypeFlag            := ri.WPhoneTypeFlag           ;
	SELF.WPhoneSrvc                := ri.WPhoneSrvc               ;
	SELF.AreaCodeSplitFlag         := ri.AreaCodeSplitFlag        ;
	SELF.AltAreaCode               := ri.AltAreaCode              ;
	SELF.PhoneZIPFlag              := ri.PhoneZIPFlag             ;
	SELF.SSNDateOfBirth            := ri.SSNDateOfBirth           ;
	SELF.HighRiskPhoneFlag         := ri.HighRiskPhoneFlag        ;
	SELF.HighRiskCompany           := ri.HighRiskCompany          ;
	SELF.SICCode                   := ri.SICCode                  ;
	SELF.ZIPClassFlag              := ri.ZIPClassFlag             ;
	SELF.ZIPName                   := ri.ZIPName                  ;
	SELF.MedianIncome              := ri.MedianIncome             ;
	SELF.AddressRiskFlag           := ri.AddressRiskFlag          ;
	SELF.BansFlag                  := ri.BansFlag                 ;
	SELF.BansDateFiled             := ri.BansDateFiled            ;
	SELF.AddrValFlag               := ri.AddrValFlag              ;
	SELF.AddressReason             := ri.AddressReason            ;
	SELF.LowIssue                  := ri.LowIssue                 ;
	SELF.DwellTypeFlag             := ri.DwellTypeFlag            ;
	SELF.PhoneDissFlag             := ri.PhoneDissFlag            ;
	SELF.EcoVariables              := ri.EcoVariables             ;
	SELF.TCIFull                   := ri.TCIFull                  ;
	SELF.TCILast                   := ri.TCILast                  ;
	SELF.TCIAddr                   := ri.TCIAddr                  ;
	
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
                        SELF._LoginID := RIGHT.LoginID;
                        SELF := LEFT), LOCAL);

// OUTPUT(CHOOSEN(parsedRecords, eyeball), NAMED('Sample_Fully_Parsed_Records'));
// OUTPUT(COUNT(parsedRecords), NAMED('Total_Final_Records'));

parsedRecordsFiltered1 := IF(Login_ID <> '', parsedRecords(_LoginID = Login_ID), parsedRecords);

parsedRecordsFiltered2 := IF(Trib_Code[1] <> '', parsedRecordsFiltered1(STD.STR.ToUpperCase(TribCode) in Trib_Code), parsedRecordsFiltered1);

parsedRecordsFinal := parsedRecordsFiltered2;

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
