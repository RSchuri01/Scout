import scout;
import scout.logs;
import std;
import scout.logs.layout as layout;

EXPORT BUSINESSINSTANTID2_input := MODULE

SHARED infile := scout.logs.files_stg.online_stg_ds : INDEPENDENT;

espName := 'BUSINESSINSTANTID2';

// mbs_base_slim := infile(std.str.touppercase(TRIM(esp_method))[1..LENGTH(espName)] = espName );

EXPORT mbs_base_slim := scout.logs.util.fn_productXMLcleaner(infile, espName);

shared mbs_logs := project(mbs_base_slim, transform(layout.base_transaction,
				SELF.inputxml := '<BUSINESSINSTANTID2><TransactionId>' + LEFT.Transaction_Id + '</TransactionId>' + 
				'<Datetime>' + LEFT.Datetime + '</Datetime>' + STD.STR.FindReplace(LEFT.inputxml, 'BusinessInstantID2>', 'BusinessInstantID2Request>') + '</BUSINESSINSTANTID2>', self := left, self := []));

shared Reclayout := RECORD
	STRING16 transaction_id;
	STRING20 datetime;
String100  endusercompanyname;
String10  referencecode;
string25  biid20producttype;
string25  globalwatchlistthreshold;
string20  watchlistsrequested;
string15  dobradius;
string25  exactaddrmatch;
string25  exactdobmatch;
string20  exactdriverlicensematch;
string20  exactfirstnamematch;
string50  exactfirstnamematchallownicknames;
string50  exactlastnamematch;
string50  exactphonematch;
string50  exactssnmatch;
string50  excludewatchlists;
string50  includeadditionalwatchlists;
string50  includecloverride;
string50  includedlverification;
string50  includedobincvi;
string50  includedpbc;
string50  includedriverlicenseincvi;
string50  includemioverride;
string50  includemsoverride;
string50  includeofac;
string50  lastseenthreshold;
string50  nameinputorder;
string50  poboxcompliance;
string50  usedobfilter;
string50  inrep2streetaddress;
string25  inrep2city;
string50  inrep2state;
string10  inrep2zip5;
string10  inrep2ssn;
string10  inrep2dob;
string10  inrep2phone;
string10  inrep2dl;
string2  inrep2dlstate;
string50  inrep3streetaddress;
string25  inrep3city;
string50  inrep3state;
string10  inrep3zip5;
string10  inrep3ssn;
string10  inrep3dob;
string10  inrep3phone;
string10  inrep3dl;
string2  inrep3dlstate;
string50  inrep4streetaddress;
string25  inrep4city;
string50  inrep4state;
string10  inrep4zip5;
string10  inrep4ssn;
string10  inrep4dob;
string10  inrep4phone;
string10  inrep4dl;
string2  inrep4dlstate;
string50  inrep5streetaddress;
string25  inrep5city;
string50  inrep5state;
string10  inrep5zip5;
string10  inrep5ssn;
string10  inrep5dob;
string10  inrep5phone;
string10  inrep5dl;
string2  inrep5dlstate;
END;

Reclayout parseoutput() := transform

  SELF.Transaction_ID	:= TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
  SELF.datetime       := TRIM(XMLTEXT('Datetime'));

SELF.endusercompanyname:= TRIM(XMLTEXT('BusinessInstantID2Request/User/EndUser/CompanyName'));
SELF.referencecode:= TRIM(XMLTEXT('BusinessInstantID2Request/User/ReferenceCode'));
SELF.biid20producttype:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/BIID20ProductType'));
SELF.globalwatchlistthreshold:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/GlobalWatchlistThreshold'));
SELF.watchlistsrequested:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/WatchListsRequested'));
SELF.dobradius:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/DOBRadius'));
SELF.exactaddrmatch:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/ExactAddrMatch'));
SELF.exactdobmatch:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/ExactDOBMatch'));
SELF.exactdriverlicensematch:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/ExactDriverLicenseMatch'));
SELF.exactfirstnamematch:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/ExactFirstNameMatch'));
SELF.exactfirstnamematchallownicknames:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/ExactFirstNameMatchAllowNicknames'));
SELF.exactlastnamematch:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/ExactLastNameMatch'));
SELF.exactphonematch:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/ExactPhoneMatch'));
SELF.exactssnmatch:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/ExactSSNMatch'));
SELF.excludewatchlists:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/ExcludeWatchLists'));
SELF.includeadditionalwatchlists:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/IncludeAdditionalWatchlists'));
SELF.includecloverride:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/IncludeCLOverride'));
SELF.includedlverification:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/IncludeDLVerification'));
SELF.includedobincvi:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/IncludeDOBInCVI'));
SELF.includedpbc:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/IncludeDPBC'));
SELF.includedriverlicenseincvi:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/IncludeDriverLicenseInCVI'));
SELF.includemioverride:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/IncludeMIOverride'));
SELF.includemsoverride:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/IncludeMSOverride'));
SELF.includeofac:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/IncludeOFAC'));
SELF.lastseenthreshold:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/LastSeenThreshold'));
SELF.nameinputorder:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/NameInputOrder'));
SELF.poboxcompliance:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/PoBoxCompliance'));
SELF.usedobfilter:= TRIM(XMLTEXT('BusinessInstantID2Request/Options/UseDOBFilter'));
SELF.inrep2streetaddress:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep2/Address/StreetAddress1'));
SELF.inrep2city:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep2/Address/City'));
SELF.inrep2state:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep2/Address/State'));
SELF.inrep2zip5:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep2/Address/Zip5'));
SELF.inrep2ssn:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep2/SSN'));
SELF.inrep2dob:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep2/DOB/Year')) + TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep2/DOB/Month')) + TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep2/DOB/Day'));
SELF.inrep2phone:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep2/Phone'));
SELF.inrep2dl:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep2/DriverLicenseNumber'));
SELF.inrep2dlstate:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep2/DriverLicenseState'));
SELF.inrep3streetaddress:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep3/Address/StreetAddress1'));
SELF.inrep3city:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep3/Address/City'));
SELF.inrep3state:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep3/Address/State'));
SELF.inrep3zip5:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep3/Address/Zip5'));
SELF.inrep3ssn:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep3/SSN'));
SELF.inrep3dob:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep3/DOB/Year')) + TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep3/DOB/Month')) + TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep3/DOB/Day'));
SELF.inrep3phone:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep3/Phone'));
SELF.inrep3dl:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep3/DriverLicenseNumber'));
SELF.inrep3dlstate:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep3/DriverLicenseState'));
SELF.inrep4streetaddress:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep4/Address/StreetAddress1'));
SELF.inrep4city:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep4/Address/City'));
SELF.inrep4state:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep4/Address/State'));
SELF.inrep4zip5:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep4/Address/Zip5'));
SELF.inrep4ssn:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep4/SSN'));
SELF.inrep4dob:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep4/DOB/Year')) + TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep4/DOB/Month')) + TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep4/DOB/Day'));
SELF.inrep4phone:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep4/Phone'));
SELF.inrep4dl:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep4/DriverLicenseNumber'));
SELF.inrep4dlstate:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep4/DriverLicenseState'));
SELF.inrep5streetaddress:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep5/Address/StreetAddress1'));
SELF.inrep5city:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep5/Address/City'));
SELF.inrep5state:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep5/Address/State'));
SELF.inrep5zip5:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep5/Address/Zip5'));
SELF.inrep5ssn:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep5/SSN'));
SELF.inrep5dob:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep5/DOB/Year')) + TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep5/DOB/Month')) + TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep5/DOB/Day'));
SELF.inrep5phone:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep5/Phone'));
SELF.inrep5dl:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep5/DriverLicenseNumber'));
SELF.inrep5dlstate:= TRIM(XMLTEXT('BusinessInstantID2Request/SearchBy/AuthorizedRep5/DriverLicenseState'));

	self := [];
 
  END;

parsedoutput := PARSE(mbs_logs, inputxml, parseOutput(), XML('BUSINESSINSTANTID2'));

SHARED BUSINESSINSTANTID2 := project(parsedoutput, transform(RecLayout,
					    self := left)); 

export idxKeyName := scout.common.constants.BUSINESSINSTANTID2_input_keyName;

SHARED subIdxFileName(String pversion) := scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion);

SHARED idxLayout := RECORDOF(BUSINESSINSTANTID2);

EXPORT readIdxSubFileData(String pversion):= PULL(INDEX(DATASET([],RECORDOF(idxLayout)), 
                                 {idxLayout.transaction_id}, {idxLayout},
										 subIdxFileName(pversion)));

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);

export indexDailyStgFile(String pv, boolean isRollupAsked)  := scout.logs.util.fn_buildSubKeyAndAddToSuperKey(INDEX(BUSINESSINSTANTID2(transaction_id <> ''), 
                                 {BUSINESSINSTANTID2.transaction_id, BUSINESSINSTANTID2.datetime}, {BUSINESSINSTANTID2},
										 subIdxFileName(pv)), idxKeyName, subIdxFileName(pv), isRollupAsked);

EXPORT superFileData(Boolean isSuperFor2Years = true) := INDEX(DATASET([],idxLayout), {idxLayout.transaction_id, idxLayout.datetime}, {idxLayout},
				    superFileName(isSuperFor2Years), opt);

SHARED twoyrsOldData := PULL(SUPERFILEDATA(false));

EXPORT rollupBackSuperFileIndex(String pversion, Boolean isRollupOnly = true) := scout.logs.util.fn_rollupSupKeyIndexData(INDEX(twoyrsOldData , 
                                           {twoyrsOldData.transaction_id, twoyrsOldData.datetime}, 
                                           {twoyrsOldData}, 
                                           scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion, true)
                                      ),
								   idxKeyName,
                                   scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion,true),
								   isRollupOnly
                             );

EXPORT fileDateIndexData := INDEX(DATASET([], idxLayout), {idxLayout.transaction_id, idxLayout.datetime}, {idxLayout},
				    			scout.logs.util.fn_getMySuperKeyNameByKeyForDailyBuild(idxKeyName),
							opt)(datetime[1..8] = Scout.logs.files_stg.yesterday);

end;
