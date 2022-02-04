IMPORT SCOUT;

IMPORT STD.STR;


online_fcra_ds 		:= scout.logs.files_spray.mbs_fcra_transaction_online_ds;
online_non_fcra_ds	:= scout.logs.files_spray.mbs_transaction_online_ds;

scout_fcra_ds 		:= scout.logs.files_spray.mbs_fcra_transaction_scout_ds;
scout_non_fcra_ds	:= scout.logs.files_spray.mbs_transaction_scout_ds;

intermediate_fcra_ds 		:= scout.logs.files_spray.mbs_fcra_intermediate_ds;
intermediate_non_fcra_ds	:= scout.logs.files_spray.mbs_intermediate_ds;

dataDate := scout.logs.files_stg.yesterday;

validationResult :=     EXISTS(online_fcra_ds(str.filter(date_added, ' 0123456789')[1..8] = dataDate)) AND
    EXISTS(online_non_fcra_ds(str.filter(date_added, ' 0123456789')[1..8] = dataDate)) AND
    EXISTS(scout_fcra_ds(str.filter(date_added, ' 0123456789')[1..8] = dataDate)) AND
    EXISTS(scout_non_fcra_ds(str.filter(date_added, ' 0123456789')[1..8] = dataDate));
    //  AND
    // EXISTS(intermediate_fcra_ds(str.filter(date_added, ' 0123456789')[1..8] = dataDate)) AND
    // EXISTS(intermediate_non_fcra_ds(str.filter(date_added, ' 0123456789')[1..8] = dataDate));

EXPORT build_scout_files_validate := WHEN(validationResult, OUTPUT('Scout Log files Validation is ' + IF(validationResult, 'SUCCESS', 'FAILURE')));

