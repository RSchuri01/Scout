import scout;
import scout.logs;
import std;
import scout.logs.layout as layout;

EXPORT INSTANTIDMODEL_attr := MODULE

SHARED infile := scout.logs.files_stg.online_stg_ds ;


espName := 'InstantIDModel';

EXPORT mbs_base_slim := scout.logs.util.fn_productXMLcleaner(infile, espName );

shared mbs_logs := project(mbs_base_slim, transform(layout.base_transaction, 
			SELF.outputxml := '<Row>' + LEFT.outputxml + '</Row>';
            SELF.inputxml := '<Row><outputxml>' + LEFT.outputxml + '</outputxml><TransactionId>' + LEFT.Transaction_Id + '</TransactionId>' + 
			     '<Datetime>' + LEFT.Datetime + '</Datetime>' + LEFT.inputxml + '</Row>';
             self := left, self := []));			

shared ScoreLayout := record
  string5 type {xpath('Type')};
	string2 value {xpath('Value')};
end;

shared tempLayout := RECORD
  STRING16 transaction_id {xpath('TransactionId')};
  STRING20 datetime {xpath('Datetime')};
  DATASET(ScoreLayout) scores {xpath('outputxml/Result/Models/Model/Scores/Score')};
  STRING1 IncludeNap {xpath('InstantIDModel/Options/IncludeModels/CVIModel/IncludeNAP')};
  STRING1 IncludeNas {xpath('InstantIDModel/Options/IncludeModels/CVIModel/IncludeNAS')};
  STRING1 IncludeCVI {xpath('InstantIDModel/Options/IncludeModels/CVIModel/IncludeCVI')};
END;


shared recLayout := RECORD
   	STRING16 transaction_id;
   	STRING20 datetime;
    STRING2 NAP;
    STRING2 NAS;
    STRING1 IncludeNap;
    STRING1 IncludeNas;
    STRING1 IncludeCVI;
end;

parsedoutputTemp := PROJECT(mbs_logs, TRANSFORM(tempLayout, SELF := FROMXML(tempLayout, LEFT.inputxml); self := left));

parsedInputoutput := PROJECT(parsedoutputTemp, 
                       TRANSFORM(
											     recLayout,													 
													 SELF.nap := LEFT.scores(type = 'nap')[1].value;

													 SELF.nas := LEFT.scores(type = 'nas')[1].value;
													 SELF     := LEFT;
								)
						);

SHARED InstantIdModel := project(parsedInputoutput, transform(RecLayout,
					   self := left));

export idxKeyName := scout.common.constants.InstantIdModel_attr_keyName;

SHARED subIdxFileName(String pversion) := scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion);

SHARED idxLayout := RECORDOF(InstantIdModel);

EXPORT readIdxSubFileData(String pversion):= PULL(INDEX(DATASET([],RECORDOF(idxLayout)), 
                                 {idxLayout.transaction_id}, {idxLayout},
										 subIdxFileName(pversion)));

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);

export indexDailyStgFile(String pv, boolean isRollupAsked)  := scout.logs.util.fn_buildSubKeyAndAddToSuperKey(INDEX(InstantIdModel(transaction_id <> ''), 
                                  {InstantIdModel.transaction_id, InstantIdModel.datetime}, {InstantIdModel},
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
