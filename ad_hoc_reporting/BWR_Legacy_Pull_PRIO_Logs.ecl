#workunit('name', 'RiskWiseMainPRIO_Pull_SCOUT_Logs');
#STORED('historyfreq', '7yrs');
IMPORT scout, STD;

Product := 'RiskWise.RiskWiseMainPRIO';
//Date is in format YYYYMMDD HHMMSS
BeginDate := '20190201';
EndDate := '20190201'; 
eyeball := 100;  

AccountIDs := ['']; // Set to a blank string dataset [''] to pull all records except for test transaction login ids

Login_ID := ''; // Set to blank to include all records for the above Account ID, otherwise this will filter to only include records with this LoginID.

//Valid trib codes are allv, flfn, pi02, pi07, pi60
//Set value to true for which trib code is needed
//Must have only one active at a time
ALLV := FALSE;
FLFN := FALSE;
PI02 := TRUE;
PI07 := FALSE;
PI60 := FALSE;

#if(ALLV)
    Trib_Code := ['ALLV']; // only include records wtih this TribCode.
#elseif(FLFN)
    Trib_Code := ['FLFN']; // only include records wtih this TribCode.
#elseif(PI02)
    Trib_Code := ['PI02']; // only include records wtih this TribCode.
#elseif(PI07)
    Trib_Code := ['PI07']; // only include records wtih this TribCode.
#elseif(PI60)
    Trib_Code := ['PI60']; // only include records wtih this TribCode.
#else
    Trib_Code := ['']; //this conditon shouldn't happen
#end

outputFile := '~fallen::out::PRIO_SCOUT_' + BeginDate + '-' + EndDate + '_' + AccountIDs[1];

BaseScoutFile := scout.logs.keys.key_scorelogs_scout_transactionID.superFileData();
BaseLogFile := scout.logs.keys.key_scorelogs_XMLTransactionID.superFileData();

Pulled_ScoutFile := distribute(pull(BaseScoutFile));

ScoutFile_Raw := IF(AccountIDs[1] != '',Pulled_ScoutFile(STD.Str.ToUpperCase(TRIM(esp_method)) IN Trib_Code AND datetime[1..8] BETWEEN BeginDate AND EndDate AND (string)company_id IN AccountIDs AND company_id NOT IN scout.ad_hoc_reporting.constants.IgnoredAccountIDs),
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

scout.ad_hoc_reporting.layouts.Parsed_RiskWiseMainPRIO_Layout parseInput () := TRANSFORM
	SELF.TransactionID          := TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
	SELF._LoginId               := TRIM(XMLTEXT('_LoginId'));
	SELF.TribCode               := TRIM(XMLTEXT('tribcode'));
	SELF.DataRestrictionMask    := TRIM(XMLTEXT('DataRestrictionMask'));
	SELF.Account                := TRIM(XMLTEXT('account'));
	SELF.FirstName              := TRIM(XMLTEXT('first'));
	SELF.MiddleName             := TRIM(XMLTEXT('middleini'));
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
	
	SELF := [];
END;

parsedInput := PARSE(Good_Logs, inputxml, parseInput(), XML('RiskWise.RiskWiseMainPRIO'));
OUTPUT(CHOOSEN(parsedInput, eyeball), NAMED('Sample_Parsed_Input'));


scout.ad_hoc_reporting.layouts.Parsed_RiskWiseMainPRIO_Layout parseOutput () := TRANSFORM
	SELF.TransactionID     := TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
	SELF.RiskWiseID        := TRIM(XMLTEXT('riskwiseid'));
	SELF.hriskphoneflag    := TRIM(XMLTEXT('hriskphoneflag'));
	SELF.phonevalflag      := TRIM(XMLTEXT('phonevalflag'));
	SELF.phonezipflag      := TRIM(XMLTEXT('phonezipflag'));
	SELF.hriskaddrflag     := TRIM(XMLTEXT('hriskaddrflag'));
	SELF.decsflag          := TRIM(XMLTEXT('decsflag'));
	SELF.socsdobflag       := TRIM(XMLTEXT('socsdobflag'));
	SELF.socsvalflag       := TRIM(XMLTEXT('socsvalflag'));
	SELF.drlcvalflag       := TRIM(XMLTEXT('drlcvalflag'));
	SELF.frdriskscore      := TRIM(XMLTEXT('frdriskscore'));
	SELF.areacodesplitflag := TRIM(XMLTEXT('areacodesplitflag'));
	SELF.altareacode       := TRIM(XMLTEXT('altareacode'));
	SELF.splitdate         := TRIM(XMLTEXT('splitdate'));
	SELF.addrvalflag       := TRIM(XMLTEXT('addrvalflag'));
	SELF.dwelltypeflag     := TRIM(XMLTEXT('dwelltypeflag'));
	SELF.cassaddr          := TRIM(XMLTEXT('cassaddr'));
	SELF.casscity          := TRIM(XMLTEXT('casscity'));
	SELF.cassstate         := TRIM(XMLTEXT('cassstate'));
	SELF.casszip           := TRIM(XMLTEXT('casszip'));
	SELF.bansflag          := TRIM(XMLTEXT('bansflag'));
	SELF.coaalertflag      := TRIM(XMLTEXT('coaalertflag'));
	SELF.coafirst          := TRIM(XMLTEXT('coafirst'));
	SELF.coalast           := TRIM(XMLTEXT('coalast'));
	SELF.coaaddr           := TRIM(XMLTEXT('coaaddr'));
	SELF.coacity           := TRIM(XMLTEXT('coacity'));
	SELF.coastate          := TRIM(XMLTEXT('coastate'));
	SELF.coazip            := TRIM(XMLTEXT('coazip'));
	SELF.idtheftflag       := TRIM(XMLTEXT('idtheftflag'));
	SELF.aptscanflag       := TRIM(XMLTEXT('aptscanflag'));
	SELF.addrhistoryflag   := TRIM(XMLTEXT('addrhistoryflag'));
	SELF.firstcount        := TRIM(XMLTEXT('firstcount'));
	SELF.lastcount         := TRIM(XMLTEXT('lastcount'));
	SELF.formerlastcount   := TRIM(XMLTEXT('formerlastcount'));
	SELF.addrcount         := TRIM(XMLTEXT('addrcount'));
	SELF.hphonecount       := TRIM(XMLTEXT('hphonecount'));
	SELF.wphonecount       := TRIM(XMLTEXT('wphonecount'));
	SELF.socscount         := TRIM(XMLTEXT('socscount'));
	SELF.socsverlevel      := TRIM(XMLTEXT('socsverlevel'));
	SELF.dobcount          := TRIM(XMLTEXT('dobcount'));
	SELF.drlccount         := TRIM(XMLTEXT('drlccount'));
	SELF.emailcount        := TRIM(XMLTEXT('emailcount'));
	SELF.numelever         := TRIM(XMLTEXT('numelever'));
	SELF.numsource         := TRIM(XMLTEXT('numsource'));
	SELF.verfirst          := TRIM(XMLTEXT('verfirst'));
	SELF.verlast           := TRIM(XMLTEXT('verlast'));
	SELF.vercmpy           := TRIM(XMLTEXT('vercmpy'));
	SELF.veraddr           := TRIM(XMLTEXT('veraddr'));
	SELF.vercity           := TRIM(XMLTEXT('vercity'));
	SELF.verstate          := TRIM(XMLTEXT('verstate'));
	SELF.verzip            := TRIM(XMLTEXT('verzip'));
	SELF.verhphone         := TRIM(XMLTEXT('verhphone'));
	SELF.verwphone         := TRIM(XMLTEXT('verwphone'));
	SELF.verSSN            := TRIM(XMLTEXT('versocs'));
	SELF.verdob            := TRIM(XMLTEXT('verdob'));
	SELF.verdrlc           := TRIM(XMLTEXT('verdrlc'));
	SELF.veremail          := TRIM(XMLTEXT('veremail'));
	SELF.firstscore        := TRIM(XMLTEXT('firstscore'));
	SELF.lastscore         := TRIM(XMLTEXT('lastscore'));
	SELF.cmpyscore         := TRIM(XMLTEXT('cmpyscore'));
	SELF.addrscore         := TRIM(XMLTEXT('addrscore'));
	SELF.hphonescore       := TRIM(XMLTEXT('hphonescore'));
	SELF.wphonescore       := TRIM(XMLTEXT('wphonescore'));
	SELF.ssnscore          := TRIM(XMLTEXT('socsscore'));
	SELF.dobscore          := TRIM(XMLTEXT('dobscore'));
	SELF.dlnmscore         := TRIM(XMLTEXT('dlnmscore'));
	SELF.emailscore        := TRIM(XMLTEXT('emailscore'));
	SELF.SSNMiskeyFlag     := TRIM(XMLTEXT('socsmiskeyflag'));
	SELF.hphonemiskeyflag  := TRIM(XMLTEXT('hphonemiskeyflag'));
	SELF.addrmiskeyflag    := TRIM(XMLTEXT('addrmiskeyflag'));
	SELF.hriskcmpy         := TRIM(XMLTEXT('hriskcmpy'));
	SELF.hrisksic          := TRIM(XMLTEXT('hrisksic'));
	SELF.hriskphone        := TRIM(XMLTEXT('hriskphone'));
	SELF.hriskaddr         := TRIM(XMLTEXT('hriskaddr'));
	SELF.hriskcity         := TRIM(XMLTEXT('hriskcity'));
	SELF.hriskstate        := TRIM(XMLTEXT('hriskstate'));
	SELF.hriskzip          := TRIM(XMLTEXT('hriskzip'));
	SELF.disthphoneaddr    := TRIM(XMLTEXT('disthphoneaddr'));
	SELF.disthphonewphone  := TRIM(XMLTEXT('disthphonewphone'));
	SELF.distwphoneaddr    := TRIM(XMLTEXT('distwphoneaddr'));
	SELF.estincome         := TRIM(XMLTEXT('estincome'));
	SELF.numfraud          := TRIM(XMLTEXT('numfraud'));
	SELF.firstname_out     := TRIM(XMLTEXT('first'));
	SELF.lastname_out      := TRIM(XMLTEXT('last'));
	SELF.Addr_out          := TRIM(XMLTEXT('addr'));
	SELF.City_out          := TRIM(XMLTEXT('city'));
	SELF.State_out         := TRIM(XMLTEXT('state'));
	SELF.Zip_out           := TRIM(XMLTEXT('zip'));
	SELF.firstname2_out    := TRIM(XMLTEXT('first2'));
	SELF.lastname2_out     := TRIM(XMLTEXT('last2'));
	SELF.addr2_out         := TRIM(XMLTEXT('addr2'));
	SELF.City2_out         := TRIM(XMLTEXT('city2'));
	SELF.State2_out        := TRIM(XMLTEXT('state2'));
	SELF.Zip2_out          := TRIM(XMLTEXT('zip2'));

	SELF := [];
END;

parsedOutput := PARSE(Good_Logs, outputxml, parseOutput(), XML('RiskWise.RiskWiseMainPRIO'));
OUTPUT(CHOOSEN(parsedOutput, eyeball), NAMED('Sample_Parsed_Output'));


scout.ad_hoc_reporting.layouts.Parsed_RiskWiseMainPRIO_Layout combineParsedRecords(scout.ad_hoc_reporting.layouts.Parsed_RiskWiseMainPRIO_Layout le, scout.ad_hoc_reporting.layouts.Parsed_RiskWiseMainPRIO_Layout ri) := TRANSFORM
	SELF.RiskWiseID        := ri.RiskWiseID       ;
	SELF.hriskphoneflag    := ri.hriskphoneflag   ;
	SELF.phonevalflag      := ri.phonevalflag     ;
	SELF.phonezipflag      := ri.phonezipflag     ;
	SELF.hriskaddrflag     := ri.hriskaddrflag    ;
	SELF.decsflag          := ri.decsflag         ;
	SELF.socsdobflag       := ri.socsdobflag      ;
	SELF.socsvalflag       := ri.socsvalflag      ;
	SELF.drlcvalflag       := ri.drlcvalflag      ;
	SELF.frdriskscore      := ri.frdriskscore     ;
	SELF.areacodesplitflag := ri.areacodesplitflag;
	SELF.altareacode       := ri.altareacode      ;
	SELF.splitdate         := ri.splitdate        ;
	SELF.addrvalflag       := ri.addrvalflag      ;
	SELF.dwelltypeflag     := ri.dwelltypeflag    ;
	SELF.cassaddr          := ri.cassaddr         ;
	SELF.casscity          := ri.casscity         ;
	SELF.cassstate         := ri.cassstate        ;
	SELF.casszip           := ri.casszip          ;
	SELF.bansflag          := ri.bansflag         ;
	SELF.coaalertflag      := ri.coaalertflag     ;
	SELF.coafirst          := ri.coafirst         ;
	SELF.coalast           := ri.coalast          ;
	SELF.coaaddr           := ri.coaaddr          ;
	SELF.coacity           := ri.coacity          ;
	SELF.coastate          := ri.coastate         ;
	SELF.coazip            := ri.coazip           ;
	SELF.idtheftflag       := ri.idtheftflag      ;
	SELF.aptscanflag       := ri.aptscanflag      ;
	SELF.addrhistoryflag   := ri.addrhistoryflag  ;
	SELF.firstcount        := ri.firstcount       ;
	SELF.lastcount         := ri.lastcount        ;
	SELF.formerlastcount   := ri.formerlastcount  ;
	SELF.addrcount         := ri.addrcount        ;
	SELF.hphonecount       := ri.hphonecount      ;
	SELF.wphonecount       := ri.wphonecount      ;
	SELF.socscount         := ri.socscount        ;
	SELF.socsverlevel      := ri.socsverlevel     ;
	SELF.dobcount          := ri.dobcount         ;
	SELF.drlccount         := ri.drlccount        ;
	SELF.emailcount        := ri.emailcount       ;
	SELF.numelever         := ri.numelever        ;
	SELF.numsource         := ri.numsource        ;
	SELF.verfirst          := ri.verfirst         ;
	SELF.verlast           := ri.verlast          ;
	SELF.vercmpy           := ri.vercmpy          ;
	SELF.veraddr           := ri.veraddr          ;
	SELF.vercity           := ri.vercity          ;
	SELF.verstate          := ri.verstate         ;
	SELF.verzip            := ri.verzip           ;
	SELF.verhphone         := ri.verhphone        ;
	SELF.verwphone         := ri.verwphone        ;
	SELF.verSSN            := ri.verSSN           ;
	SELF.verdob            := ri.verdob           ;
	SELF.verdrlc           := ri.verdrlc          ;
	SELF.veremail          := ri.veremail         ;
	SELF.firstscore        := ri.firstscore       ;
	SELF.lastscore         := ri.lastscore        ;
	SELF.cmpyscore         := ri.cmpyscore        ;
	SELF.addrscore         := ri.addrscore        ;
	SELF.hphonescore       := ri.hphonescore      ;
	SELF.wphonescore       := ri.wphonescore      ;
	SELF.ssnscore          := ri.ssnscore         ;
	SELF.dobscore          := ri.dobscore         ;
	SELF.dlnmscore         := ri.dlnmscore        ;
	SELF.emailscore        := ri.emailscore       ;
	SELF.SSNMiskeyFlag     := ri.SSNMiskeyFlag    ;
	SELF.hphonemiskeyflag  := ri.hphonemiskeyflag ;
	SELF.addrmiskeyflag    := ri.addrmiskeyflag   ;
	SELF.hriskcmpy         := ri.hriskcmpy        ;
	SELF.hrisksic          := ri.hrisksic         ;
	SELF.hriskphone        := ri.hriskphone       ;
	SELF.hriskaddr         := ri.hriskaddr        ;
	SELF.hriskcity         := ri.hriskcity        ;
	SELF.hriskstate        := ri.hriskstate       ;
	SELF.hriskzip          := ri.hriskzip         ;
	SELF.disthphoneaddr    := ri.disthphoneaddr   ;
	SELF.disthphonewphone  := ri.disthphonewphone ;
	SELF.distwphoneaddr    := ri.distwphoneaddr   ;
	SELF.estincome         := ri.estincome        ;
	SELF.numfraud          := ri.numfraud         ;
	SELF.firstname_out     := ri.firstname_out    ;
	SELF.lastname_out      := ri.lastname_out     ;
	SELF.Addr_out          := ri.Addr_out         ;
	SELF.City_out          := ri.City_out         ;
	SELF.State_out         := ri.State_out        ;
	SELF.Zip_out           := ri.Zip_out          ;
	SELF.firstname2_out    := ri.firstname2_out   ;
	SELF.lastname2_out     := ri.lastname2_out    ;
	SELF.addr2_out         := ri.addr2_out        ;
	SELF.City2_out         := ri.City2_out        ;
	SELF.State2_out        := ri.State2_out       ;
	SELF.Zip2_out          := ri.Zip2_out         ;
	
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
