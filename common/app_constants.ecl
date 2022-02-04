IMPORT scout;

EXPORT app_constants := module

export FCRA_esp_method := ['RISKVIEW', 'RISKVIEWATTRIBUTES', 'RISKVIEWREPORT', 'RISKVIEW2']; 

EXPORT exportDataFreq := '2YRS' : STORED('historyfreq');

export key_file_prefix := '~thor::scout::key::score_logs::';
//export key_file_prefix := '~thor::key::score_logsv2::';

export historical_2year_key_file_prefix 			:= '~thor::scout::key::score_logs::2year_history';
export historical_2year_filtered_key_file_prefix 	:= '~thor::scout::key::score_logs::2year_history_filtered';
export recent_2year_filtered_key_file_prefix 		:= '~thor::scout::key::score_logs::recent_2year_filtered';
								 
export ZeroAsValidScoreProducts := ['BUSINESSINSTANTID','BUSINESSINSTANTID2','BUSINESSINSTANTIDMODEL','FLEXID','INSTANTID','INSTANTIDMODEL','CB61','IDP1','NP21','NP22','NP31','NPT1','PB01','SS02'];

export IPAddress(boolean isPROD = false) := if(isPROD, 'xxxxxxx', '10.195.93.54');

EXPORT IgnoredAccountIDs := ['1005199', '1006061'];

export Version_SuperKey := 'QA'; 

export extn := '.csv';

export getExportRemoteNetworkFolder() := function
 return trim('F:\\ScoringData1c\\Scout\\' + scout.common.stored_export_requested_user + '\\' + scout.common.stored_env + '\\' + workunit, all);
end;

export getExportRemoteFolder() := function
 return trim('F:\\ScoringData1c\\Scout\\' + scout.common.stored_export_requested_user + '\\' + scout.common.stored_env + '\\' + workunit, all);
end;

export getExportRemoteName(string filename) := function
	remote_file 	:=  getExportRemoteFolder() + '\\' + filename;
	return remote_file;
end;

export getExportAbsoulteRemoteName(string filename) := function
	remote_file 	:= getExportRemoteName(filename) + extn;
	return remote_file;
end;

export stage_filename_scout := 'logs::scout';

export stage_filename_online := 'logs::online';

export stage_filename_intermediate := 'logs::intermediate';

export export_search_file_prefix :=  scout.common.stored_env + 
									'_' + scout.common.stored_export_requested_user + 
									'_' + scout.common.stored_export_search_id + '_' ;
end;									 
				