IMPORT scout.logs.build_stg as stg;

EXPORT stg_build := SEQUENTIAL(
								stg.build_scout_transaction,
								stg.build_online_transaction,
								stg.build_intermediate_transaction);