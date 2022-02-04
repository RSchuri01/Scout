IMPORT SCOUT;

EXPORT fn_getMySubKeyNameByKey(STRING keyName, STRING pversion, BOOLEAN rollupIdx = false) := FUNCTION

dailykeyPrefix := scout.common.constants.superkeypath + 'subkeys::' ;

Import std;

today := ((STRING)STD.Date.Today());

fileDate1 := today : STORED('filedate');

fileDate := IF(fileDate1[7..8] = '01', (String)(std.date.AdjustDate(Std.Date.FromStringToDate(fileDate1, '%Y%m%d'), month_delta := -1)), fileDate1);

monthlykeyPrefix := scout.common.app_constants.key_file_prefix + 'monthly::' + fileDate[1..4] + '::' + fileDate[5..6] + '::';

monthlySub :=  (STRING) monthlykeyPrefix + keyName + '_' + workunit;

dailySub := dailykeyPrefix  + keyName + '::' + pversion + '::' + IF(rollupIdx, '2YrsRollupKey', scout.common.stored_frequency);

monthlyFreq := 'daily' : stored('frequency'); 

return IF(monthlyFreq in  ['monthly_recovery','monthly'], monthlySub, dailySub);

end;