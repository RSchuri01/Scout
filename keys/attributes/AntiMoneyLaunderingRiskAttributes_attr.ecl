import scout;
import scout.logs;
import scout.logs.util;
import std;
IMPORT Scout.LOGS.KEYS;
import scout.logs.layout as layout;
IMPORT DataMgmt;
IMPORT scout.common.constants;

EXPORT AntiMoneyLaunderingRiskAttributes_attr := MODULE

SHARED infile := scout.logs.files_stg.online_stg_ds : INDEPENDENT;

EXPORT mbs_base_slim := infile(std.str.touppercase(TRIM(esp_method, ALL)) in ['ANTIMONEYLAUNDERINGRISKATTRIBU', 'ANTIMONEYLAUNDERINGRISKATTRIBUTES'] and regexfind('<Attributes>', outputxml));

mbs_logs := project(mbs_base_slim, transform(layout.base_transaction, 
			SELF.outputxml := '<AntiMoneyLaunderingRiskAttributes><TransactionId>' + LEFT.Transaction_Id + '</TransactionId>' + 
			 '<Datetime>' + LEFT.Datetime + '</Datetime>' + LEFT.outputxml + '</AntiMoneyLaunderingRiskAttributes>', self := left));			
		
layout.attributes parseoutput() := transform

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
	SELF.Attribute21Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[21]/Name'));
	SELF.Attribute21Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[21]/Value'));
	SELF.Attribute22Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[22]/Name'));
	SELF.Attribute22Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[22]/Value'));
	SELF.Attribute23Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[23]/Name'));
	SELF.Attribute23Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[23]/Value'));
	SELF.Attribute24Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[24]/Name'));
	SELF.Attribute24Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[24]/Value'));
	SELF.Attribute25Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[25]/Name'));
	SELF.Attribute25Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[25]/Value'));
	SELF.Attribute26Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[26]/Name'));
	SELF.Attribute26Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[26]/Value'));
	SELF.Attribute27Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[27]/Name'));
	SELF.Attribute27Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[27]/Value'));
	SELF.Attribute28Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[28]/Name'));
	SELF.Attribute28Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[28]/Value'));
	SELF.Attribute29Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[29]/Name'));
	SELF.Attribute29Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[29]/Value'));
	SELF.Attribute30Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[30]/Name'));
	SELF.Attribute30Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[30]/Value'));
	SELF.Attribute31Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[31]/Name'));
	SELF.Attribute31Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[31]/Value'));
	SELF.Attribute32Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[32]/Name'));
	SELF.Attribute32Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[32]/Value'));
	SELF.Attribute33Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[33]/Name'));
	SELF.Attribute33Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[33]/Value'));
	SELF.Attribute34Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[34]/Name'));
	SELF.Attribute34Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[34]/Value'));
	SELF.Attribute35Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[35]/Name'));
	SELF.Attribute35Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[35]/Value'));
	SELF.Attribute36Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[36]/Name'));
	SELF.Attribute36Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[36]/Value'));
	SELF.Attribute37Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[37]/Name'));
	SELF.Attribute37Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[37]/Value'));
	SELF.Attribute38Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[38]/Name'));
	SELF.Attribute38Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[38]/Value'));
	SELF.Attribute39Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[39]/Name'));
	SELF.Attribute39Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[39]/Value'));
	SELF.Attribute40Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[40]/Name'));
	SELF.Attribute40Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[40]/Value'));
	SELF.Attribute41Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[41]/Name'));
	SELF.Attribute41Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[41]/Value'));
	SELF.Attribute42Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[42]/Name'));
	SELF.Attribute42Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[42]/Value'));
	SELF.Attribute43Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[43]/Name'));
	SELF.Attribute43Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[43]/Value'));
	SELF.Attribute44Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[44]/Name'));
	SELF.Attribute44Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[44]/Value'));
	SELF.Attribute45Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[45]/Name'));
	SELF.Attribute45Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[45]/Value'));
	SELF.Attribute46Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[46]/Name'));
	SELF.Attribute46Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[46]/Value'));
	SELF.Attribute47Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[47]/Name'));
	SELF.Attribute47Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[47]/Value'));
	SELF.Attribute48Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[48]/Name'));
	SELF.Attribute48Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[48]/Value'));
	SELF.Attribute49Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[49]/Name'));
	SELF.Attribute49Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[49]/Value'));
	SELF.Attribute50Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[50]/Name'));
	SELF.Attribute50Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[50]/Value'));
	SELF.Attribute51Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[51]/Name'));
	SELF.Attribute51Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[51]/Value'));
	SELF.Attribute52Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[52]/Name'));
	SELF.Attribute52Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[52]/Value'));
	SELF.Attribute53Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[53]/Name'));
	SELF.Attribute53Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[53]/Value'));
	SELF.Attribute54Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[54]/Name'));
	SELF.Attribute54Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[54]/Value'));
	SELF.Attribute55Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[55]/Name'));
	SELF.Attribute55Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[55]/Value'));
	SELF.Attribute56Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[56]/Name'));
	SELF.Attribute56Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[56]/Value'));
	SELF.Attribute57Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[57]/Name'));
	SELF.Attribute57Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[57]/Value'));
	SELF.Attribute58Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[58]/Name'));
	SELF.Attribute58Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[58]/Value'));
	SELF.Attribute59Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[59]/Name'));
	SELF.Attribute59Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[59]/Value'));
	SELF.Attribute60Name	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[60]/Name'));
	SELF.Attribute60Value	:=	TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[60]/Value'));
	
	SELF := [];
END;
		
parsedoutput := PARSE(mbs_logs, outputxml, parseOutput(), XML('AntiMoneyLaunderingRiskAttributes'));

SHARED projectedData := project(parsedoutput, transform(layout.attributes,
					   self.esp_method := 'AntiMoneyLaunderingRiskAttributes', self := left));


SHARED AntiMoneyLaunderingRiskAttributes := dedup(
	        normalize(projectedData, 2160, scout.logs.util.fn_transformattributesByNormalize(left, counter), local), all, local);

EXPORT idxKeyName := scout.common.constants.AntiMoneyLaunderingRiskAttributes_attr_keyName;

SHARED subIdxFileName(String pversion) := scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion);

SHARED idxLayout := RECORDOF(AntiMoneyLaunderingRiskAttributes);

EXPORT readIdxSubFileData(String pversion):= PULL(INDEX(DATASET([],RECORDOF(idxLayout)), 
                                 {idxLayout.transaction_id}, {idxLayout},
										 subIdxFileName(pversion)));

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);

export indexDailyStgFile(String pv, boolean isRollupAsked) := scout.logs.util.fn_buildSubKeyAndAddToSuperKey(INDEX(AntiMoneyLaunderingRiskAttributes(transaction_id <> '' and AttributeName <> ''), 
                                 {AntiMoneyLaunderingRiskAttributes.transaction_id, AntiMoneyLaunderingRiskAttributes.datetime}, {AntiMoneyLaunderingRiskAttributes},
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

EXPORT fileDateIndexData := INDEX(DATASET([], layout.attributes_key), {layout.attributes_key.transaction_id, layout.attributes_key.datetime}, {layout.attributes_key},
				    			scout.logs.util.fn_getMySuperKeyNameByKeyForDailyBuild(idxKeyName),
							opt)(datetime[1..8] = Scout.logs.files_stg.yesterday);

end;
