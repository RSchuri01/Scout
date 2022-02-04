IMPORT * from $;
IMPORT STD;
IMPORT scout;
IMPORT scout.logs.layout;

export files_stg := module

EXPORT stg_prefix 	:= scout.common.scout_stg + '::logs';

EXPORT monthly_stg_prefix 	:= scout.common.scout_stg ;

export today 		:= scout.common.util.dateutils.today;

export twoyearsback := sort(scout.common.util.dateutils.getNRecentWeeks(106, today), iso_wk_start_dt)[1].iso_wk_start_dt;

shared filedate_stored    := '' : stored('filedate');

export filedate    := IF(filedate_stored = '', (string)today , filedate_stored);

export recoverfiledate 	:= '' : stored('recoverfiledate');

export yesterday	:= scout.common.util.dateutils.getyesterday(filedate);

shared fileMonth_stored    := '' : stored('filemonth');

export fileMonth    := IF(fileMonth_stored = '', yesterday[1..6] , fileMonth_stored);

shared isloadprocess  := '' : stored('loadprocess');

export yesterMonth	:= (String)scout.common.util.dateutils.getPrevYearMonth((Integer)fileMonth);

export currentyear_superfile_scout 		:= stg_prefix + '::' + 'migrated_history::currentyear::superfile::' + 'scout';
export currentyear_superfile_online 	:= stg_prefix + '::' + 'migrated_history::currentyear::superfile::' + 'online';
export currentyear_superfile_intermediate := stg_prefix + '::' + 'migrated_history::currentyear::superfile::' + 'intermediate';

export scout_all_fido_stg_ds 			:= DATASET(currentyear_superfile_scout, 		layout.base_transaction_scout_reprocessed, 	thor, opt);
export online_all_fido_stg_ds 			:= DATASET(currentyear_superfile_online, 		layout.base_transaction_reprocessed, 		thor, opt);
export intermediate_all_fido_stg_ds 	:= DATASET(currentyear_superfile_intermediate,	layout.base_intermediate_reprocessed, 		thor, opt);

shared getmonthlystg_scout_ds(string yyyymm) 		:= DATASET(monthly_stg_prefix + '::' + yyyymm[1..4] + '::' + yyyymm[5..6] + '::'+ scout.common.app_constants.stage_filename_scout, layout.base_transaction_scout_reprocessed, 	thor, opt);

shared getmonthlystg_online_ds(string yyyymm) 		:= DATASET(monthly_stg_prefix + '::' + yyyymm[1..4] + '::' + yyyymm[5..6] + '::'+ scout.common.app_constants.stage_filename_online, layout.base_transaction_reprocessed, 	thor, opt);

shared getmonthlystg_intermediate_ds(string yyyymm) := DATASET(monthly_stg_prefix + '::' + yyyymm[1..4] + '::' + yyyymm[5..6] + '::'+ scout.common.app_constants.stage_filename_intermediate, layout.base_intermediate_reprocessed, 	thor, opt);

export scout_month_stg_ds 			:= (getmonthlystg_scout_ds(fileMonth) + IF(filedate_stored[7..8] = '01' AND scout.common.stored_frequency <> 'monthly', getmonthlystg_scout_ds(fileDate)));

export online_month_stg_ds 			:= (getmonthlystg_online_ds(fileMonth) + IF(filedate_stored[7..8] = '01' AND scout.common.stored_frequency <> 'monthly', getmonthlystg_online_ds(fileDate)));

export intermediate_month_stg_ds 	:= (getmonthlystg_intermediate_ds(fileMonth) + IF(filedate_stored[7..8] = '01' AND scout.common.stored_frequency <> 'monthly', getmonthlystg_intermediate_ds(fileDate)));

export scout_daily_stg_ds 				:= scout_month_stg_ds(((integer4)(datetime[1..8])) = (integer4)yesterday);
export online_daily_stg_ds 				:= online_month_stg_ds(((integer4)(datetime[1..8])) = (integer4)yesterday);
export intermediate_daily_stg_ds 		:= intermediate_month_stg_ds(((integer4)(datetime[1..8])) = (integer4)yesterday);

export scout_daily_loadprocess_stg_ds 				:= scout_month_stg_ds(((integer4)(datetime[1..8])) IN [(integer4)yesterday, (integer4)filedate]);
export online_daily_loadprocess_stg_ds 				:= online_month_stg_ds(((integer4)(datetime[1..8])) IN [(integer4)yesterday, (integer4)filedate]);
export intermediate_daily_loadprocess_stg_ds 		:= intermediate_month_stg_ds(((integer4)(datetime[1..8])) IN [(integer4)yesterday, (integer4)filedate]);

export scout_2yrs_mgrtd_history_stg_ds 		 := dataset(stg_prefix + '::' + 'migrated_history::twoyears::superfile::' + 'scout', layout.base_transaction_scout_reprocessed, 	thor, opt);
export online_2yrs_mgrtd_history_stg_ds 	 := dataset(stg_prefix + '::' + 'migrated_history::twoyears::superfile::' + 'online', layout.base_transaction_reprocessed, 	thor, opt);
export intermediate_2yrs_mgrtd_history_stg_ds := dataset(stg_prefix + '::' + 'migrated_history::twoyears::superfile::' + 'intermediate', layout.base_intermediate_reprocessed, 	thor, opt);

export scout_7yrs_mgrtd_history_stg_ds 		 := dataset(stg_prefix + '::' + 'migrated_history::sevenyears::superfile::' + 'scout', layout.base_transaction_scout_reprocessed, 	thor, opt);
export online_7yrs_mgrtd_history_stg_ds 	 := dataset(stg_prefix + '::' + 'migrated_history::sevenyears::superfile::' + 'online', layout.base_transaction_reprocessed, 	thor, opt);
export intermediate_7yrs_mgrtd_history_stg_ds := dataset(stg_prefix + '::' + 'migrated_history::sevenyears::superfile::' + 'intermediate', layout.base_intermediate_reprocessed, 	thor, opt);

export scout_history_stg_ds 			:= scout_7yrs_mgrtd_history_stg_ds + scout_2yrs_mgrtd_history_stg_ds;
export online_history_stg_ds 			:= online_7yrs_mgrtd_history_stg_ds + online_2yrs_mgrtd_history_stg_ds;
export intermediate_history_stg_ds 		:= intermediate_7yrs_mgrtd_history_stg_ds + intermediate_2yrs_mgrtd_history_stg_ds;

export scout_2yrs_stg_ds 				:= scout_all_fido_stg_ds(((integer4)(datetime[1..8])) > twoyearsback);
export online_2yrs_stg_ds 				:= online_all_fido_stg_ds(((integer4)(datetime[1..8])) > twoyearsback);
export intermediate_2yrs_stg_ds			:= intermediate_all_fido_stg_ds(((integer4)(datetime[1..8])) > twoyearsback);

export scout_all_stg_ds 				:= scout_history_stg_ds + scout_all_fido_stg_ds;
export online_all_stg_ds 				:= online_history_stg_ds + online_all_fido_stg_ds;
export intermediate_all_stg_ds 			:= intermediate_history_stg_ds + intermediate_all_fido_stg_ds;

SHARED stored_frequency	:=	IF(scout.common.stored_frequency = 'daily' AND isloadprocess = 'yes', 'daily_loadprocess', scout.common.stored_frequency);

SHARED fail_check := IF((scout.common.stored_frequency = 'monthly_recovery' AND (fileMonth_stored = '' or recoverfiledate = '')) or (scout.common.stored_frequency = 'daily' AND  fileMonth <> yesterday[1..6]),
							FAIL('Stored variables Frequency = monthly and recoveryasof is expected together or When Frequency as Daily filemonth is expected matching with filedate\'s month'));

export scout_stg_ds :=  WHEN(CASE (stored_frequency,
										'daily' 					=> scout_daily_stg_ds,
										'daily_loadprocess'			=> scout_daily_loadprocess_stg_ds,
										'all_fido' 					=> scout_all_fido_stg_ds,
										'2years_migrated_history' 	=> scout_2yrs_mgrtd_history_stg_ds,
										'2years' 					=> scout_2yrs_stg_ds,
										'all_migrated_history'		=> scout_history_stg_ds,
										'monthly'					=> scout_month_stg_ds,
										'monthly_recovery'			=> scout_month_stg_ds(datetime[1..8] < recoverfiledate),
										'all'	  					=> scout_all_stg_ds,
										dataset([], layout.base_transaction_scout_reprocessed)
								), fail_check
 						): INDEPENDENT;
							 

export online_stg_ds := WHEN(CASE (stored_frequency,
							 'daily' 					=> online_daily_stg_ds,
							 'daily_loadprocess'		=> online_daily_loadprocess_stg_ds,
							 'all_fido' 				=> online_all_fido_stg_ds,
							 '2years_migrated_history' 	=> online_2yrs_mgrtd_history_stg_ds,
							 '2years' 					=> online_2yrs_stg_ds,
							 'all_migrated_history'		=> online_history_stg_ds,
							 'monthly'					=> online_month_stg_ds,
							 'monthly_recovery'			=> online_month_stg_ds(datetime[1..8] < recoverfiledate),
							 'all'	  					=> online_all_stg_ds,
							  dataset([], layout.base_transaction_reprocessed)
						), fail_check
					): INDEPENDENT;
export intermediate_stg_ds := WHEN(CASE (stored_frequency,
									 'daily' 					=> intermediate_daily_stg_ds,
									 'daily_loadprocess'		=> intermediate_daily_loadprocess_stg_ds,
									 'all_fido' 				=> intermediate_all_fido_stg_ds,
									 '2years_migrated_history' 	=> intermediate_2yrs_mgrtd_history_stg_ds,
									 '2years' 					=> intermediate_2yrs_stg_ds,
									 'all_migrated_history'		=> intermediate_history_stg_ds,
									 'monthly'					=> intermediate_month_stg_ds,
									 'monthly_recovery'			=> intermediate_month_stg_ds(datetime[1..8] < recoverfiledate),
									 'all'	  					=> intermediate_all_stg_ds,
									  dataset([], layout.base_intermediate_reprocessed)
									), fail_check
					): INDEPENDENT;

END;