IMPORT SCOUT, STD;

EXPORT fn_getMyPackageMapSuperKeyNameByKey(String idxKeyName, Boolean isActualFileName = false) := 
        STD.Str.FindReplace(
            IF(isActualFileName, idxKeyName, scout.common.app_constants.key_file_prefix + idxKeyName),
            '::score_logs::', 
            '::score_logs::packageMap::'
);

