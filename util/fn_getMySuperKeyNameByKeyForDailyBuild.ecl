IMPORT SCOUT;

EXPORT fn_getMySuperKeyNameByKeyForDailyBuild(STRING keyName) := FUNCTION

Import std;

keyPrefix := scout.common.app_constants.key_file_prefix;

return keyPrefix + keyName;

end;