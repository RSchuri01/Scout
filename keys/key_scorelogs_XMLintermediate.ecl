import scout;
import std;
import scout.logs.layout as layout;
import scout.logs as logs;
import scout.logs.keys as keys;
IMPORT DataMgmt;
IMPORT scout.common.constants;

EXPORT key_scorelogs_XMLintermediate:= MODULE

EXPORT idxKeyName := scout.common.constants.key_scorelogs_XMLintermediate_keyName;

SHARED OutputXMLRec := RECORD
	UNSIGNED1 numRows;
	layout.base_intermediate;
END;

SHARED OutputXMLIdxRec  := RECORD
	layout.base_intermediate_key;
END;

SHARED mxLength:= 29500;

EXPORT mbs_base_slim := logs.files_index.intermediate;

EXPORT OutputXML_Base_P
		:= 	project(mbs_base_slim, transform(OutputXMLRec,
											self.numRows		:= length(left.outputxml)/mxLength + 1;
											self := left));

SHARED layout.base_intermediate_key tnorm(OutputXML_Base_P le, INTEGER C) := TRANSFORM
		SELF.outputxml_len := CHOOSE(C
									,length(trim(le.outputxml[..mxLength]))
									,length(trim(le.outputxml[mxLength*(C-1)+1..mxLength*C]))
									,length(trim(le.outputxml[mxLength*(C-1)+1..mxLength*C]))
									,length(trim(le.outputxml[mxLength*(C-1)+1..mxLength*C]))
									,length(trim(le.outputxml[mxLength*(C-1)+1..mxLength*C]))
									,length(trim(le.outputxml[mxLength*(C-1)+1..mxLength*C]))
									,length(trim(le.outputxml[mxLength*(C-1)+1..mxLength*C]))
									,length(trim(le.outputxml[mxLength*(C-1)+1..mxLength*C]))
									,length(trim(le.outputxml[mxLength*(C-1)+1..mxLength*C]))
									,length(trim(le.outputxml[mxLength*(C-1)+1..mxLength*C]))
									,length(trim(le.outputxml[mxLength*(C-1)+1..mxLength*C]))											
									,length(trim(le.outputxml[mxLength*(C-1)+1..]))
									 );
		SELF.seq_num := C;
		SELF.outputxml := CHOOSE(C
								,trim(le.outputxml[..mxLength])
								,trim(le.outputxml[mxLength*(C-1)+1..mxLength*C])
								,trim(le.outputxml[mxLength*(C-1)+1..mxLength*C])
								,trim(le.outputxml[mxLength*(C-1)+1..mxLength*C])
								,trim(le.outputxml[mxLength*(C-1)+1..mxLength*C])
								,trim(le.outputxml[mxLength*(C-1)+1..mxLength*C])
								,trim(le.outputxml[mxLength*(C-1)+1..mxLength*C])
								,trim(le.outputxml[mxLength*(C-1)+1..mxLength*C])
								,trim(le.outputxml[mxLength*(C-1)+1..mxLength*C])
								,trim(le.outputxml[mxLength*(C-1)+1..mxLength*C])
								,trim(le.outputxml[mxLength*(C-1)+1..mxLength*C])
								,trim(le.outputxml[mxLength*(C-1)+1..])
								 );

	SELF := le;
END;

SHARED OutputXML_Base_N := NORMALIZE(OutputXML_Base_P, LEFT.numRows, tnorm(LEFT,COUNTER));

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