import scout;
import scout.logs;
import std;
import scout.logs.layout as layout;
IMPORT DataMgmt;
IMPORT scout.common.constants;

EXPORT verificationOfOccupancy_attr := MODULE

SHARED infile := scout.logs.files_stg.online_stg_ds : INDEPENDENT;

espName := 'VERIFICATIONOFOCCUPANCY';

EXPORT mbs_base_slim := infile(std.str.touppercase(TRIM(esp_method))[1..LENGTH(espName)] = espName and regexfind('<Attributes>', outputxml));

mbs_logs := project(mbs_base_slim, transform(layout.base_transaction, 
			SELF.outputxml := '<VerificationOfOccupancy><TransactionId>' + LEFT.Transaction_Id + '</TransactionId>' + 
			'<Datetime>' + LEFT.Datetime + '</Datetime>' + LEFT.outputxml + '</VerificationOfOccupancy>', self := left));			

layout.attributes     parseoutput() := transform

	SELF.Transaction_ID	:= TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
  SELF.datetime       := TRIM(XMLTEXT('Datetime'));
  SELF.Attribute1Name		:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[1]/Name'));
	SELF.Attribute1Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[1]/Value'));
	SELF.Attribute2Name		:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[2]/Name'));
	SELF.Attribute2Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[2]/Value'));
	SELF.Attribute3Name		:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[3]/Name'));
	SELF.Attribute3Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[3]/Value'));
	SELF.Attribute4Name		:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[4]/Name'));
	SELF.Attribute4Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[4]/Value'));
	SELF.Attribute5Name		:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[5]/Name'));
	SELF.Attribute5Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[5]/Value'));
	SELF.Attribute6Name		:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[6]/Name'));
	SELF.Attribute6Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[6]/Value'));
	SELF.Attribute7Name		:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[7]/Name'));
	SELF.Attribute7Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[7]/Value'));
	SELF.Attribute8Name		:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[8]/Name'));
	SELF.Attribute8Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[8]/Value'));
	SELF.Attribute9Name		:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[9]/Name'));
	SELF.Attribute9Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[9]/Value'));
	SELF.Attribute10Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[10]/Name'));
	SELF.Attribute10Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[10]/Value'));
	SELF.Attribute11Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[11]/Name'));
	SELF.Attribute11Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[11]/Value'));
	SELF.Attribute12Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[12]/Name'));
	SELF.Attribute12Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[12]/Value'));
	SELF.Attribute13Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[13]/Name'));
	SELF.Attribute13Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[13]/Value'));
	SELF.Attribute14Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[14]/Name'));
	SELF.Attribute14Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[14]/Value'));
	SELF.Attribute15Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[15]/Name'));
	SELF.Attribute15Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[15]/Value'));
	SELF.Attribute16Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[16]/Name'));
	SELF.Attribute16Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[16]/Value'));
	SELF.Attribute17Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[17]/Name'));
	SELF.Attribute17Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[17]/Value'));
	SELF.Attribute18Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[18]/Name'));
	SELF.Attribute18Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[18]/Value'));
	SELF.Attribute19Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[19]/Name'));
	SELF.Attribute19Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[19]/Value'));
	SELF.Attribute20Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[20]/Name'));
	SELF.Attribute20Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[20]/Value'));

	SELF := [];
END;
		
parsedoutput := PARSE(mbs_logs, outputxml, parseOutput(), XML('VerificationOfOccupancy'));

SHARED projectedData := project(parsedoutput, transform(layout.attributes,
					   self.esp_method := 'VerificationOfOccupancy', self := left));

SHARED VerificationOfOccupancy := dedup(
	        normalize(projectedData, 2160, scout.logs.util.fn_transformattributesByNormalize(left, counter), local), all, local);

export idxKeyName := scout.common.constants.VerificationOfOccupancy_attr_keyName;

export twoyrHistoryFileName := scout.logs.keys.key_constants('2yearhistory').VerificationOfOccupancy_idx;

SHARED subIdxFileName(String pversion) := scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion);

SHARED idxLayout := RECORDOF(VerificationOfOccupancy);

EXPORT readIdxSubFileData(String pversion):= PULL(INDEX(DATASET([],RECORDOF(idxLayout)), 
                                 {idxLayout.transaction_id}, {idxLayout},
										 subIdxFileName(pversion)));

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);
export indexDailyStgFile(String pv, boolean isRollupAsked)  := scout.logs.util.fn_buildSubKeyAndAddToSuperKey(INDEX(VerificationOfOccupancy(transaction_id <> '' and AttributeName <> ''), 
                                 {VerificationOfOccupancy.transaction_id, VerificationOfOccupancy.datetime}, {VerificationOfOccupancy},
										 subIdxFileName(pv)), idxKeyName, subIdxFileName(pv), isRollupAsked);

EXPORT superFileData(Boolean isSuperFor2Years = true) := INDEX(DATASET([],layout.attributes_key), {layout.attributes_key.transaction_id, layout.attributes_key.datetime}, {layout.attributes_key},
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
