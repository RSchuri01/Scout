import scout;
import scout.logs;
import std;
import scout.logs.layout as layout;

EXPORT riskviewalertcode_Attr := MODULE

EXPORT infile := scout.logs.files_stg.online_stg_ds : INDEPENDENT;

espName :=  'RISKVIEW2';

infile1 := infile(std.str.touppercase(TRIM(esp_method))[1..LENGTH(espName)] = espName);

EXPORT mbs_base_slim := SCOUT.logs.util.fn_productXMLcleaner(infile1, 'RISKVIEW2');

SHARED mbs_logs := project(mbs_base_slim, transform(layout.base_transaction,
				SELF.outputxml := '<riskviewalertcode><TransactionId>' + LEFT.Transaction_Id + '</TransactionId>' + 
				'<Datetime>' + LEFT.Datetime + '</Datetime>' + LEFT.outputxml + '</riskviewalertcode>', self := left, self := []));

SHARED RecLayout := RECORD
	STRING16 transaction_id;
	STRING20 datetime;
String Alert_Code1;
String Alert_Code2;
String Alert_Code3;
String Alert_Code4;
String Alert_Code5;
String Alert_Code6;
String Alert_Code7;
String Alert_Code8;
String Alert_Code9;
String Alert_Code10;

END;

RecLayout     parseoutput() := transform

  SELF.Transaction_ID	:= TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
  SELF.datetime       := TRIM(XMLTEXT('Datetime'));

SELF.Alert_Code1 := TRIM(XMLTEXT('Result/Alerts[1]/Alert[1]/Code'));
SELF.Alert_Code2 := TRIM(XMLTEXT('Result/Alerts[2]/Alert[2]/Code'));
SELF.Alert_Code3 := TRIM(XMLTEXT('Result/Alerts[3]/Alert[3]/Code'));
SELF.Alert_Code4 := TRIM(XMLTEXT('Result/Alerts[4]/Alert[4]/Code'));
SELF.Alert_Code5 := TRIM(XMLTEXT('Result/Alerts[5]/Alert[5]/Code'));
SELF.Alert_Code6 := TRIM(XMLTEXT('Result/Alerts[6]/Alert[6]/Code'));
SELF.Alert_Code7 := TRIM(XMLTEXT('Result/Alerts[7]/Alert[7]/Code'));
SELF.Alert_Code8 := TRIM(XMLTEXT('Result/Alerts[8]/Alert[8]/Code'));
SELF.Alert_Code9 := TRIM(XMLTEXT('Result/Alerts[9]/Alert[9]/Code'));
SELF.Alert_Code10 := TRIM(XMLTEXT('Result/Alerts[10]/Alert[10]/Code'));
	
	self := [];
 
  END;

parsedoutput := PARSE(mbs_logs, outputxml, parseOutput(), XML('riskviewalertcode'));

SHARED riskviewalertcode := project(parsedoutput, transform(RecLayout,
					    self := left));

export idxKeyName := scout.common.constants.riskviewalertcode_Attr_keyName;

SHARED subIdxFileName(String pversion) := scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion);

SHARED idxLayout := RECORDOF(riskviewalertcode);

EXPORT readIdxSubFileData(String pversion):= PULL(INDEX(DATASET([],RECORDOF(idxLayout)), 
                                 {idxLayout.transaction_id}, {idxLayout},
										 subIdxFileName(pversion)));

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);

export indexDailyStgFile( String pv, boolean isRollupAsked) := scout.logs.util.fn_buildSubKeyAndAddToSuperKey(INDEX(riskviewalertcode(transaction_id <> '' ), 
                                 {riskviewalertcode.transaction_id, riskviewalertcode.datetime}, {riskviewalertcode},
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