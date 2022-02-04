import scout;

export build_logs := sequential(
    scout.logs.spray_build, 
    IF(scout.logs.build_stg.build_scout_files_validate = TRUE, scout.logs.stg_build)
);