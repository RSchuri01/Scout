import scout;
import scout.logs;
import std;
import scout.logs.layout as layout;

EXPORT FlexID_attr := MODULE

EXPORT infile := scout.logs.files_stg.online_stg_ds ;

espName :=  'FLEXID';

EXPORT mbs_base_slim := scout.logs.util.fn_productXMLcleaner(infile, espName);//(std.str.touppercase(TRIM(esp_method)) = 'INSTANTID');

shared mbs_logs := project(mbs_base_slim, transform(layout.base_transaction, 
			SELF.outputxml := '<FlexID><TransactionId>' + LEFT.Transaction_Id + '</TransactionId>' + 
			'<Datetime>' + LEFT.Datetime + '</Datetime>' + LEFT.outputxml + '</FlexID>', self := left));			

shared recLayout := RECORD
	STRING16 transaction_id;
	STRING20 datetime;
string1  verfirstname;
string1  verlastname;
string1  veraddress;
string1  vercity;
string1  verstate;
string1  verzip;
string1  verhomephone;
string1 verssn;
string1 verdateofbirth;
string1 VerDOBMatchLevel;
String1 VerDriverLicense;

string2 NAP;
string2 NAS;
  
END;

recLayout parseoutput() := transform

	SELF.Transaction_ID	:= TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
  SELF.datetime       := TRIM(XMLTEXT('Datetime'));

SELF.VerFirstName:= TRIM(XMLTEXT('Result/VerifiedElementSummary/FirstName'));
SELF.VerLastName:=  TRIM(XMLTEXT('Result/VerifiedElementSummary/LastName'));
SELF.VerAddress :=  TRIM(XMLTEXT('Result/VerifiedElementSummary/StreetAddress'));
SELF.VerCity:=  TRIM(XMLTEXT('Result/VerifiedElementSummary/City'));
SELF.VerState:=  TRIM(XMLTEXT('Result/VerifiedElementSummary/State'));
SELF.VerZIP :=  TRIM(XMLTEXT('Result/VerifiedElementSummary/Zip'));
SELF.VerHomePhone:=  TRIM(XMLTEXT('Result/VerifiedElementSummary/HomePhone'));
SELF.VerSSN:=  TRIM(XMLTEXT('Result/VerifiedElementSummary/SSN'));
SELF.VerDateOfBirth :=  TRIM(XMLTEXT('Result/VerifiedElementSummary/DOB'));
SELF.VerDOBMatchLevel :=  TRIM(XMLTEXT('Result/VerifiedElementSummary/DOBMatchLevel'));
SELF.VerDriverLicense := TRIM(XMLTEXT('Result/VerifiedElementSummary/DL'));
SELF.NAP :=  TRIM(XMLTEXT('Result/NameAddressPhone/Summary'));
SELF.NAS :=  TRIM(XMLTEXT('Result/NameAddressSSNSummary'));

	SELF := [];
END;
		
EXPORT FlexID := PARSE(mbs_logs, outputxml, parseOutput(), XML('FlexID'));

// SHARED FlexID := project(parsedoutput, transform(RecLayout,
// 					   self := left));

export idxKeyName := scout.common.constants.FlexId_attr_keyName;

SHARED subIdxFileName(String pversion) := scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion);

SHARED idxLayout := RECORDOF(FlexID);

EXPORT readIdxSubFileData(String pversion):= PULL(INDEX(DATASET([],RECORDOF(idxLayout)), 
                                 {idxLayout.transaction_id}, {idxLayout},
										 subIdxFileName(pversion)));

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);

export indexDailyStgFile(String pv, boolean isRollupAsked)  := scout.logs.util.fn_buildSubKeyAndAddToSuperKey(INDEX(FlexID(transaction_id <> ''), 
                                  {FlexID.transaction_id, FlexID.datetime}, {FlexID},
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
