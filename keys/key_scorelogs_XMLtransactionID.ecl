import scout;
import std;
import scout.logs.layout as layout;
import scout.logs as logs;
import scout.logs.keys as keys;
IMPORT DataMgmt;
IMPORT scout.common.constants;

EXPORT key_scorelogs_XMLtransactionID := MODULE

EXPORT idxKeyName := scout.common.constants.key_scorelogs_XMLtransactionID_keyName;

SHARED OutputXMLRec := RECORD
	UNSIGNED1 numRows;
	layout.base_transaction;
END;

SHARED OutputXMLIdxRec := RECORD
	layout.base_transaction_online_key;
END;

SHARED mxLength:= 29500;

EXPORT mbs_base_slim := scout.logs.files_index.online;

EXPORT OutputXML_Base_P	:= 	project(mbs_base_slim, transform(OutputXMLRec,
								self.numRows		:= length(left.outputxml)/mxLength + 1;
								self := left));

SHARED layout.base_transaction_online_key tnorm(OutputXML_Base_P Le, INTEGER C) := TRANSFORM

	xmlPart := le.outputxml[mxLength*(C-1)+1..mxLength*C];
	
	SELF.outputxml_len := length(xmlPart);

	SELF.seq_num := C;
	
	SELF.outputxml := xmlPart;

	SELF := le;
	
END;	 

EXPORT OutputXML_Base_N := NORMALIZE(OutputXML_Base_P, LEFT.numRows, tnorm(LEFT,COUNTER));

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);

export indexDailyStgFile := INDEX(OutputXML_Base_N, {transaction_id, datetime}, {OutputXML_Base_N},
				keys.key_constants().xmltransaction_idx);

EXPORT superFileData(Boolean isSuperFor2Years = true) := INDEX(DATASET([],OutputXMLIdxRec), {OutputXMLIdxRec.transaction_id, OutputXMLIdxRec.datetime}, {OutputXMLIdxRec},
				    superFileName(isSuperFor2Years), opt);

SHARED rollupSuperData := PULL(SUPERFILEDATA(false));

EXPORT indexSuperFile := INDEX(rollupSuperData,  
                             {rollupSuperData.transaction_id, rollupSuperData.datetime}, 
							 {rollupSuperData},  
							 scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, 
							       Scout.Common.Constants.Today, 
							       true
						     )
						);

EXPORT fileDateIndexData := INDEX(DATASET([],OutputXMLIdxRec), {OutputXMLIdxRec.transaction_id, OutputXMLIdxRec.datetime}, {OutputXMLIdxRec},
				    			scout.logs.util.fn_getMySuperKeyNameByKeyForDailyBuild(idxKeyName),
							opt)(datetime[1..8] = Scout.logs.files_stg.yesterday);

END;