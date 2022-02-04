import scout;
import std;
import scout.logs.layout as layout;
import scout.logs as logs;
import scout.logs.keys as keys;
IMPORT DataMgmt;
IMPORT scout.common.constants;
EXPORT key_scorelogs_scout_citystzip := MODULE

EXPORT mbs_base_slim1 := logs.files_index.scout;

EXPORT idxKeyName := scout.common.constants.key_scorelogs_scout_citystzip_keyName;
	
SHARED layout.scout_address_key tnormalize(mbs_base_slim1 le, integer cnt) := transform

							self.city := choose(cnt,le.i_city,le.i_bus_city);
							self.st := choose(cnt,le.i_state,le.i_bus_state);
							self.zip := choose(cnt,le.i_zip,le.i_bus_zip);
							self := le;
							
							end;
							
SHARED scout_base_norm := normalize(mbs_base_slim1, 2,	tnormalize(left, counter));

EXPORT mbs_base_slim := scout_base_norm(city<> '' or st <> '' or zip <> '');

SHARED scout_name_dedup := dedup(sort(distribute(mbs_base_slim, hash(city, st,zip, transaction_id)),
city, st,zip, transaction_id, local),city, st,zip, transaction_id, local);

export indexDailyStgFile := INDEX(scout_name_dedup, {city, st,zip, datetime}, {transaction_id},
					keys.key_constants().scout_citystzip_idx);

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);

SHARED OutputXMLRec := RECORDOF(scout_name_dedup);

EXPORT superFileData(Boolean isSuperFor2Years = true) := INDEX(DATASET([],OutputXMLRec), {OutputXMLRec.city, OutputXMLRec.st, OutputXMLRec.zip, OutputXMLRec.datetime}, {OutputXMLRec.transaction_id},
				    superFileName(isSuperFor2Years), opt);

SHARED rollupSuperData := PULL(SUPERFILEDATA(false));

EXPORT indexSuperFile := INDEX(rollupSuperData,  
							 {rollupSuperData.city, rollupSuperData.st, rollupSuperData.zip, rollupSuperData.datetime } ,
							 {rollupSuperData.transaction_id},  
							 scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, 
							       Scout.Common.Constants.Today, 
							       true
						     )
						);

EXPORT fileDateIndexData := INDEX(DATASET([],OutputXMLRec), {OutputXMLRec.city, OutputXMLRec.st, OutputXMLRec.zip, OutputXMLRec.datetime}, {OutputXMLRec.transaction_id},
				    			scout.logs.util.fn_getMySuperKeyNameByKeyForDailyBuild(idxKeyName),
							opt)(datetime[1..8] = Scout.logs.files_stg.yesterday);
					

END;				