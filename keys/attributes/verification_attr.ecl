import scout;
import scout.logs;
import std;
import scout.logs.layout as layout;

EXPORT verification_attr := MODULE

EXPORT infile := scout.logs.files_stg.online_stg_ds ;

espName :=  'InstantID';

EXPORT mbs_base_slim := scout.logs.util.fn_productXMLcleaner(infile, espName);//(std.str.touppercase(TRIM(esp_method)) = 'INSTANTID');

shared mbs_logs := project(mbs_base_slim, transform(layout.base_transaction, 
			SELF.outputxml := '<Verification><TransactionId>' + LEFT.Transaction_Id + '</TransactionId>' + 
			'<Datetime>' + LEFT.Datetime + '</Datetime>' + LEFT.outputxml + '</Verification>', self := left));			

shared recLayout := RECORD
	STRING16 transaction_id;
	STRING20 datetime;
STRING30 verfirstname;
STRING30 verlastname;
STRING60 veraddress;
STRING50 vercity;
STRING2 verstate;
STRING9 verzip;
STRING10 verhomephone;
STRING9 verssn;
STRING30 verdriverlicense;
STRING8 verdateofbirth; 
String2 NAP;
String2 NAS;
  
END;

recLayout parseoutput() := transform

	SELF.Transaction_ID	:= TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
  SELF.datetime       := TRIM(XMLTEXT('Datetime'));

SELF.VerFirstName:= TRIM(XMLTEXT('Result/VerifiedInput/Name/First'));
SELF.VerLastName:= TRIM(XMLTEXT('Result/VerifiedInput/Name/Last'));
SELF.VerAddress := TRIM(XMLTEXT('Result/VerifiedInput/Address/StreetAddress1'));
SELF.VerCity:= TRIM(XMLTEXT('Result/VerifiedInput/Address/City'));
SELF.VerState:= TRIM(XMLTEXT('Result/VerifiedInput/Address/State'));
SELF.VerZIP := TRIM(XMLTEXT('Result/VerifiedInput/Address/Zip5'));
SELF.VerHomePhone:= TRIM(XMLTEXT('Result/VerifiedInput/HomePhone'));
SELF.VerSSN:= TRIM(XMLTEXT('Result/VerifiedInput/SSN'));
SELF.VerDriverLicense:= TRIM(XMLTEXT('Result/VerifiedInput/DriverLicenseNumber'));
SELF.VerDateOfBirth := TRIM(XMLTEXT('Result/VerifiedInput/DOB/Year')) + '' + TRIM(XMLTEXT('Result/VerifiedInput/DOB/Month')) + '' + TRIM(XMLTEXT('Result/VerifiedInput/DOB/Day'));
SELF.NAP := TRIM(XMLTEXT('Result/NameAddressPhone[1]/Summary'));
SELF.NAS := TRIM(XMLTEXT('Result/NameAddressSSNSummary'));

	SELF := [];
END;
		
EXPORT verification := PARSE(mbs_logs, outputxml, parseOutput(), XML('Verification'));

// SHARED verification := project(parsedoutput, transform(RecLayout,
// 					   self := left));

export idxKeyName := scout.common.constants.verification_attr_keyName;

SHARED subIdxFileName(String pversion) := scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion);

SHARED idxLayout := RECORDOF(verification);

EXPORT readIdxSubFileData(String pversion):= PULL(INDEX(DATASET([],RECORDOF(idxLayout)), 
                                 {idxLayout.transaction_id}, {idxLayout},
										 subIdxFileName(pversion)));

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);

export indexDailyStgFile(String pv, boolean isRollupAsked)  := scout.logs.util.fn_buildSubKeyAndAddToSuperKey(INDEX(verification(transaction_id <> ''), 
                                  {verification.transaction_id, verification.datetime}, {verification},
										 subIdxFileName(pv)), idxKeyName, subIdxFileName(pv), isRollupAsked);


EXPORT superFileData(Boolean isSuperFor2Years = true) := INDEX(DATASET([], recLayout), {recLayout.transaction_id, recLayout.datetime}, {recLayout},
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
