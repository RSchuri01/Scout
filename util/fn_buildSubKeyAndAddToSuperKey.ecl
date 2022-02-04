IMPORT scout, DataMgmt;
export fn_buildSubKeyAndAddToSuperKey(theindexprep, superKeyName,  subKeyName, isForRollupOnly) := functionmacro
/*
theindexprep is the index to be written to disk
SuperKeyname is 'key::xxxx' (superfile name)
seq_name is the sequential output name
numgenerations is currently to be just 2, 3 or 4
*/
IMPORT DataMgmt;

monthlyFreq := 'daily' : stored('frequency'); 

dailySuperFileName := scout.logs.util.fn_getMySuperKeyNameByKey(superKeyName, false);

dailyPackageMapSuperFileName := scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(superKeyName);

dailyPackageMapSuperFileNameForAttributes := scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(scout.common.constants.key_scorelogs_attributes_keyName);

seq_name := SEQUENTIAL(
    IF(isForRollupOnly, 
        buildindex(theindexprep, subKeyName, OVERWRITE),
		SEQUENTIAL(
            IF(monthlyFreq in  ['monthly_recovery','monthly'],
                STD.File.PromoteSuperFileList([dailySuperFileName], subKeyName, true),
                STD.File.AddSuperFile(dailySuperFileName, subKeyName)
            )
            ,
            DataMgmt.GenIndex.AppendSubkey(
                dailyPackageMapSuperFileName, 
                subKeyName,
                scout.common.constants.fido_ip
			),
            IF( superKeyName IN scout.common.constants.attributesNameList ,
                DataMgmt.GenIndex.AppendSubkey(
                    dailyPackageMapSuperFileNameForAttributes, 
                    subKeyName,
                    scout.common.constants.fido_ip
			    )
            )
        )
    )
);

RETURN seq_name;
endmacro;