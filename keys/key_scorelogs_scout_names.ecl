import scout;
import std;
import scout.logs.layout as layout;
import scout.logs as logs;
import scout.logs.keys as keys;
IMPORT DataMgmt;
IMPORT scout.common.constants;
EXPORT key_scorelogs_scout_names := MODULE

EXPORT idxKeyName := scout.common.constants.key_scorelogs_scout_names_keyName;

EXPORT mbs_base_slim1 := logs.files_index.scout;

SHARED layout.Scout_name_key tnormalize(mbs_base_slim1 le, integer cnt) := transform

							self.fname := choose(cnt,le.i_name_first,le.i_name_first_2,le.i_name_first_3,le.i_name_first_4,
							                        le.i_name_first_5,le.i_name_first_6,le.i_name_first_7,le.i_name_first_8);
							self.lname := choose(cnt,le.i_name_last,le.i_name_last_2,le.i_name_last_3,le.i_name_last_4,
							                        le.i_name_last_5,le.i_name_last_6,le.i_name_last_7,le.i_name_last_8); 
							
							self := le;
							
							end;
							
SHARED scout_base_norm := normalize(mbs_base_slim1, 8,	tnormalize(left, counter));

EXPORT mbs_base_slim := scout_base_norm(fname<> '' and lname <> '');

SHARED scout_name_dedup := dedup(sort(distribute(mbs_base_slim, hash(fname, lname, transaction_id)),
     fname, lname, transaction_id, local),fname, lname, transaction_id, local);

export indexDailyStgFile := INDEX(scout_name_dedup, {fname, lname, datetime}, {transaction_id},
				keys.key_constants().scout_names_idx);

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);

SHARED OutputXMLRec := RECORDOF(scout_name_dedup);

EXPORT superFileData(Boolean isSuperFor2Years = true) := INDEX(DATASET([],OutputXMLRec), {OutputXMLRec.fname, OutputXMLRec.lname, OutputXMLRec.datetime}, {OutputXMLRec.transaction_id},
				    superFileName(isSuperFor2Years), opt);

SHARED rollupSuperData := PULL(SUPERFILEDATA(false));

EXPORT indexSuperFile := INDEX(rollupSuperData,  
                             {rollupSuperData.fname, rollupSuperData.lname, rollupSuperData.datetime}, 
							 {rollupSuperData.transaction_id},  
							 scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, 
							       Scout.Common.Constants.Today, 
							       true
						     )
						);

EXPORT fileDateIndexData := INDEX(DATASET([],OutputXMLRec), {OutputXMLRec.fname, OutputXMLRec.lname, OutputXMLRec.datetime}, {OutputXMLRec.transaction_id},
				    			scout.logs.util.fn_getMySuperKeyNameByKeyForDailyBuild(idxKeyName),
							opt)(datetime[1..8] = Scout.logs.files_stg.yesterday);
END;