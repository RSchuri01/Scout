import scout;
import std;
import scout.logs.layout as layout;
import scout.logs as logs;
import scout.logs.keys as keys;
IMPORT DataMgmt;
IMPORT scout.common.constants;

EXPORT key_scorelogs_scout_ESP_method := MODULE

EXPORT idxKeyName := scout.common.constants.key_scorelogs_scout_ESP_method_keyName;

SHARED scout_base := logs.files_index.scout;

EXPORT mbs_base_slim := project(scout_base(esp_method <> ''),transform(layout.scout_esp_method_key, 
                          self := left));

export indexDailyStgFile := INDEX(mbs_base_slim, {esp_method,datetime}, {transaction_id},
						keys.key_constants().scout_esp_method_idx);

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);

SHARED OutputXMLRec := RECORDOF(mbs_base_slim);

EXPORT superFileData(Boolean isSuperFor2Years = true) := INDEX(DATASET([],OutputXMLRec), {OutputXMLRec.esp_method, OutputXMLRec.datetime}, {OutputXMLRec.transaction_id},
				    superFileName(isSuperFor2Years), opt);

SHARED rollupSuperData := PULL(SUPERFILEDATA(false));

EXPORT indexSuperFile := INDEX(rollupSuperData,  
                             {rollupSuperData.esp_method, rollupSuperData.datetime}, 
							 {rollupSuperData.transaction_id},  
							 scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, 
							       Scout.Common.Constants.Today, 
							       true
						     )
						);
EXPORT fileDateIndexData := INDEX(DATASET([],OutputXMLRec), {OutputXMLRec.esp_method, OutputXMLRec.datetime}, {OutputXMLRec.transaction_id},
				    			scout.logs.util.fn_getMySuperKeyNameByKeyForDailyBuild(idxKeyName),
							opt)(datetime[1..8] = Scout.logs.files_stg.yesterday);

END;

