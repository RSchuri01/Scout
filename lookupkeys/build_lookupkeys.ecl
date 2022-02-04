import scout.lookupkeys as keys;


EXPORT build_lookupkeys := sequential(keys.spray_build, keys.stg_build);
//EXPORT build_lookupkeys := keys.stg_build;