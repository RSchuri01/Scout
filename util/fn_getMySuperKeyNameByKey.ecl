IMPORT SCOUT, DataMgmt;

EXPORT fn_getMySuperKeyNameByKey(STRING keyName, Boolean isSuperFor2Years = true) := FUNCTION

Import std;

/**
    NOTE : the below code and the code inside IF to pick up the virtualSuperKeyPath needs to be toggled for commenting, when we go for ROXIE query publish
    as ROXIE access the data by virtual SuperKeyPath than physical
**/

datafreq := scout.common.app_constants.exportDataFreq;

dataHistoryFrequency := IF(datafreq = '2YRS', 2, 7);

// NOTE :this Below code Block should be commented  for Roxie Query publish
superkeyName := IF(isSuperFor2Years = TRUE,
                        scout.common.app_constants.key_file_prefix + dataHistoryFrequency + 'yearssuper::' + keyName,
                        scout.common.app_constants.key_file_prefix + keyName
                );

// NOTE :this Below code Block should be commented   for Thor jobs, ex : export jobs and any ordinary search data queries
/*superkeyName := DataMgmt.GenIndex.VirtualSuperkeyPath(
                        scout.logs.util.fn_getMyPackageMapSuperKeyNameByKey(keyName)
                );
*/

masterSuperKey :=  superkeyName;

storedStartYYYYMM_input := '' : stored('startyyyymm') ;

monthlyFreq := 'daily' : stored('frequency'); 

fileDate 	:= (string)std.date.Today() : stored('filedate');

storedStartYyyyMm := IF(storedStartYYYYMM_input = '', std.date.AdjustDate(std.date.Today(), month_delta := -84)[1..6], storedStartYYYYMM_input) ;

storedEndYyyyMm   := std.date.Today()[1..6] : stored('endyyyymm') ;

input_files := DATASET(84, 
                    TRANSFORM({STRING NAME},
                        SELF.NAME := scout.common.app_constants.key_file_prefix + 'monthly::' +  STD.Date.AdjustDate(Std.Date.Today(), month_delta := -1 * (COUNTER -1))[1..4] + '::' + STD.Date.AdjustDate(Std.Date.Today(), month_delta := -1 * (COUNTER -1))[5..6] + '::' + keyName;
                    )
                )('' +Std.Str.SplitWords(name, '::')[6] + Std.Str.SplitWords(name, '::')[7] >=  storedStartYyyyMm AND  '' +Std.Str.SplitWords(name, '::')[6] + Std.Str.SplitWords(name, '::')[7]  <= storedEndYyyyMm );

RETURN  IF(storedStartYYYYMM_input = '', 
            IF(monthlyFreq = 'monthly' AND std.date.Today()[1..6] <> filedate[1..6],
                scout.logs.util.fn_getMySuperKeyNameByKeyForMonthlyRollup(keyName),
                masterSuperKey
            ),
        '{' + Std.Str.CombineWords(SET(input_files, name), ',') + '}'
);

end;