IMPORT scout;
IMPORT scout.logs.layout as layout;
IMPORT scout.logs.util as util;
IMPORT std.str;
IMPORT std;

scout_fcra_ds 		:= scout.logs.files_spray.mbs_fcra_transaction_scout_ds;
scout_non_fcra_ds	:= scout.logs.files_spray.mbs_transaction_scout_ds;
scout_reprocessed_fcra_ds 		:= scout.logs.files_spray.mbs_fcra_transaction_scout_reprocessed_ds ;
scout_reprocessed_non_fcra_ds	:= scout.logs.files_spray.mbs_transaction_scout_reprocessed_ds;
file_name := scout.common.app_constants.stage_filename_scout;

tempRec := record
scout.logs.layout.base_transaction_scout;

STRING20 date_inserted;
STRING1 processing_status;
end;

projected_scout_fcra_ds 	:= PROJECT(scout_fcra_ds,
											TRANSFORM(tempRec,
													  self.source 	:= 'F',
													  self.processing_status := 'P',
													  SELF.datetime := str.filter(LEFT.date_added,  ' 0123456789');
													  self.date_inserted := str.filter(LEFT.date_added,  ' 0123456789'),
													  self			:= left))
								   + 
								   PROJECT(scout_reprocessed_fcra_ds,
											TRANSFORM(tempRec,
													  self.source 	:= 'F',
													  self.processing_status := 'R',
													  SELF.datetime := str.filter(LEFT.date_added,  ' 0123456789');
													  SELF.date_inserted := str.filter(LEFT.date_inserted,  ' 0123456789');
													  self			:= left));

projected_scout_non_fcra_ds 	:= PROJECT(scout_non_fcra_ds,
											TRANSFORM(tempRec,
													  self.source 	:= 'NF',
													  self.processing_status := 'P',
													  SELF.datetime := str.filter(LEFT.date_added,  ' 0123456789');
													  self.date_inserted := str.filter(LEFT.date_added,  ' 0123456789');,
													  self			:= left))
								   + 
								   PROJECT(scout_reprocessed_non_fcra_ds,
											TRANSFORM(tempRec,
													  self.source 	:= 'NF',
													  self.processing_status := 'R',
													  SELF.datetime := str.filter(LEFT.date_added,  ' 0123456789');
													  SELF.date_inserted := str.filter(LEFT.date_inserted,  ' 0123456789');

													  self			:= left));

combined_scout_ds := projected_scout_fcra_ds + projected_scout_non_fcra_ds;

util.fn_clean.cleanfields(combined_scout_ds, cleaned_scout_ds);

incoming_scout_ds	:= DEDUP(
							SORT(
								DISTRIBUTE(cleaned_scout_ds, hash(transaction_id)),
							transaction_id, LOCAL),
						transaction_id, LOCAL);

fileDate 			:= (String) STD.Date.Today() : stored('filedate');

min_ym          := scout.common.util.dateutils.getyesterday(fileDate)[1..6];

yr_mth			:= min_ym[1..6];
yr_mth_filename	:= min_ym[1..4] + '::' + min_ym[5..6] + '::'+ file_name; // Calucating the yr_month value based on in_recs data

next_yr_mth_filename	:= fileDate[1..4] + '::' + fileDate[5..6] + '::'+ file_name; // Calucating the yr_month value based on in_recs data

// merge new incoming feeds with current monthly file, this will be used to promote the monthly stage with old + new data.
scout_base_ds		:= DISTRIBUTE(
							incoming_scout_ds + scout.logs.files_stg.scout_month_stg_ds,
							hash(transaction_id)
						);

merge_with_base_ds := DEDUP(SORT(scout_base_ds, transaction_id, LOCAL), transaction_id, LOCAL);


next_mn         := fileDate[1..6];

EXPORT build_scout_transaction := SEQUENTIAL(
	scout.common.util.fn_promote_ds(merge_with_base_ds(datetime[1..6] = yr_mth), scout.logs.files_stg.monthly_stg_prefix, yr_mth_filename, true),
	IF(min_ym <> next_mn AND EXISTS(combined_scout_ds(datetime[1..6] = next_mn)), 
		scout.common.util.fn_promote_ds(merge_with_base_ds(datetime[1..6] = next_mn), scout.logs.files_stg.monthly_stg_prefix, next_yr_mth_filename, true)
	),
	IF(EXISTS(Nothor(STD.File.SuperFileContents(scout.logs.files_stg.currentyear_superfile_scout))(name = scout.logs.files_stg.monthly_stg_prefix[2..] + '::' + next_yr_mth_filename)) <> TRUE,
		std.file.AddSuperFile(scout.logs.files_stg.currentyear_superfile_scout, scout.logs.files_stg.monthly_stg_prefix + '::' + next_yr_mth_filename)
	)
);
