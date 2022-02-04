import scout;
import std;
import scout.logs.layout as layout;
import scout.logs as logs;
import scout.logs.keys as keys;
IMPORT DataMgmt;
IMPORT scout.common.constants;

EXPORT key_scorelogs_scout_bus_name := MODULE

EXPORT idxKeyName := scout.common.constants.key_scorelogs_scout_bus_name_keyName;

EXPORT mbs_base := logs.files_index.scout;
						
EXPORT mbs_base_slim := project(mbs_base(i_bus_name <> ''),
              transform(layout.scout_business_name_key, 
						  self.bus_name := left.i_bus_name,self := left));

export indexDailyStgFile := INDEX(mbs_base_slim, {bus_name, datetime}, {transaction_id},
				keys.key_constants().scout_bus_name_idx);

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);

SHARED OutputXMLRec := RECORDOF(mbs_base_slim);

EXPORT superFileData(Boolean isSuperFor2Years = true) := INDEX(DATASET([],OutputXMLRec), {OutputXMLRec.bus_name, OutputXMLRec.datetime}, {OutputXMLRec.transaction_id},
				    superFileName(isSuperFor2Years), opt);

SHARED rollupSuperData := PULL(SUPERFILEDATA(false));

EXPORT indexSuperFile := INDEX(rollupSuperData,  
                             {rollupSuperData.bus_name, rollupSuperData.datetime}, 
							 {rollupSuperData.transaction_id},  
							 scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, 
							       Scout.Common.Constants.Today, 
							       true
						     )
						);

EXPORT fileDateIndexData := INDEX(DATASET([],OutputXMLRec), {OutputXMLRec.bus_name, OutputXMLRec.datetime}, {OutputXMLRec.transaction_id},
				    			scout.logs.util.fn_getMySuperKeyNameByKeyForDailyBuild(idxKeyName),
							opt)(datetime[1..8] = Scout.logs.files_stg.yesterday);
					

END;	