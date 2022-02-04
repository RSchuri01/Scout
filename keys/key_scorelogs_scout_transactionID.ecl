import scout;
import std;
import scout.logs.layout as layout;
import scout.logs as logs;
import scout.logs.keys as keys;
IMPORT DataMgmt;
IMPORT scout.common.constants;

EXPORT key_scorelogs_scout_transactionID := MODULE

EXPORT idxKeyName := scout.common.constants.key_scorelogs_scout_transactionID_keyName;

EXPORT mbs_base_slim := PROJECT(logs.files_index.scout, scout.logs.layout.base_transaction_scout);
             
export indexDailyStgFile := INDEX(mbs_base_slim, {transaction_id, datetime}, {mbs_base_slim},
					keys.key_constants().scout_transactionid_idx);

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);

SHARED OutputXMLRec := scout.logs.layout.base_transaction_scout;

EXPORT superFileData(Boolean isSuperFor2Years = true) := INDEX(DATASET([],OutputXMLRec), {OutputXMLRec.transaction_id, OutputXMLRec.datetime}, {OutputXMLRec},
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

EXPORT fileDateIndexData := INDEX(DATASET([],OutputXMLRec), {OutputXMLRec.transaction_id, OutputXMLRec.datetime}, {OutputXMLRec},
				    			scout.logs.util.fn_getMySuperKeyNameByKeyForDailyBuild(idxKeyName),
							opt)(datetime[1..8] = Scout.logs.files_stg.yesterday);
END;