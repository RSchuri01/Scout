IMPORT SCOUT;

EXPORT fn_getMySuperKeyNameByKeyForMonthlyRollup(STRING keyName) := FUNCTION

Import std;

today := ((STRING)STD.Date.Today());

fileDate1 := today : STORED('filedate');

fileDate := IF(fileDate1[7..8] = '01', (String)(std.date.AdjustDate(Std.Date.FromStringToDate(fileDate1, '%Y%m%d'), month_delta := -1)), fileDate1);

keyPrefix := scout.common.app_constants.key_file_prefix + 'monthly::' + fileDate[1..4] + '::' + fileDate[5..6] + '::';

return (STRING) keyPrefix + keyName;

end;