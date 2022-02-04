IMPORT scout;
IMPORT scout.logs.layout as layout;
IMPORT scout.logs.util as util;
IMPORT std.str;
IMPORT std;

intermediate_fcra_ds 		:= scout.logs.files_spray.mbs_fcra_intermediate_ds;
intermediate_non_fcra_ds	:= scout.logs.files_spray.mbs_intermediate_ds;
intermediate_reprocessed_fcra_ds 		:= scout.logs.files_spray.mbs_fcra_intermediate_reprocessed_ds;
intermediate_reprocessed_non_fcra_ds	:= scout.logs.files_spray.mbs_intermediate_reprocessed_ds;


tempRec := record
String2 source;
layout.in_intermediate;
STRING1 processing_status;
STRING20 date_inserted;
end;

file_name := scout.common.app_constants.stage_filename_intermediate;
projected_intermediate_fcra_ds 	:= PROJECT(intermediate_fcra_ds,
											TRANSFORM(tempRec,
													  self.source 	:= 'F',
													  self.processing_status := 'P',
													  self.date_inserted := LEFT.date_added,
													  self			:= left))
								   + 
								   PROJECT(intermediate_reprocessed_fcra_ds,
											TRANSFORM(tempRec,
													  self.source 	:= 'F',
													  self.processing_status := 'R',
													  self			:= left));

projected_intermediate_non_fcra_ds 	:= PROJECT(intermediate_non_fcra_ds,
											TRANSFORM(tempRec,
													  self.source 	:= 'NF',
													  self.processing_status := 'P',
													  self.date_inserted := LEFT.date_added,
													  self			:= left))
								   + 
								   PROJECT(intermediate_reprocessed_non_fcra_ds,
											TRANSFORM(tempRec,
													  self.source 	:= 'NF',
													  self.processing_status := 'R',
													  self			:= left));

combined_intermediate_ds 		:= projected_intermediate_fcra_ds + projected_intermediate_non_fcra_ds;

project_combined_intermediate_ds := PROJECT(combined_intermediate_ds,
										  TRANSFORM(layout.base_intermediate_reprocessed,
										  			self.outputxml 			:= LEFT.content_data;
										  			self.datetime	 		:= str.filter(LEFT.date_added, ' 0123456789');
													self.date_inserted	 		:= str.filter(LEFT.date_inserted, ' 0123456789');
										  			self := left));
									  			
dedup_incoming_intermediate_ds 	:=	DEDUP(SORT(DISTRIBUTE(project_combined_intermediate_ds, HASH(transaction_id)), 
									  		transaction_id, LOCAL), 
											transaction_id, LOCAL);


scout_ds 					:= DISTRIBUTE(scout.logs.files_stg.scout_stg_ds, HASH(transaction_id)); // This is the SCOUT daily feed

fileDate 			:= (String) STD.Date.Today() : stored('filedate');

min_ym          := scout.common.util.dateutils.getyesterday(fileDate)[1..6];

yr_mth			:= min_ym[1..6];
yr_mth_filename	:= min_ym[1..4] + '::' + min_ym[5..6] + '::'+ file_name; // Calucating the yr_month value based on in_recs data

next_yr_mth_filename	:= fileDate[1..4] + '::' + fileDate[5..6] + '::'+ file_name; // Calucating the yr_month value based on in_recs data

// merge new incoming feeds with current monthly file, this will be used to promote the monthly stage with old + new data.
intermediate_base_ds		:=  scout.logs.files_stg.intermediate_month_stg_ds;			 
			 
deduped_intermediate_ds		:= DEDUP(SORT(DISTRIBUTE(intermediate_base_ds + dedup_incoming_intermediate_ds, hash(transaction_id)),
									 transaction_id, local),
									 transaction_id, local);

// EXPORT build_intermediate_transaction := scout.common.util.fn_promote_ds(deduped_intermediate_ds(datetime[1..6] = yr_mth), 
// 																		scout.logs.files_stg.monthly_stg_prefix, 
// 																		yr_mth_filename, true);

next_mn         := fileDate[1..6];

EXPORT build_intermediate_transaction := SEQUENTIAL(
	scout.common.util.fn_promote_ds(deduped_intermediate_ds(datetime[1..6] = yr_mth), scout.logs.files_stg.monthly_stg_prefix, yr_mth_filename, true),
	IF(min_ym <> next_mn AND EXISTS(combined_intermediate_ds(str.filter(date_added, ' 0123456789')[1..6] = next_mn)), 
		scout.common.util.fn_promote_ds(deduped_intermediate_ds(datetime[1..6] = next_mn), scout.logs.files_stg.monthly_stg_prefix, next_yr_mth_filename, true)
	),
	IF(EXISTS(Nothor(STD.File.SuperFileContents(scout.logs.files_stg.currentyear_superfile_online))(name = scout.logs.files_stg.monthly_stg_prefix[2..] + '::' + next_yr_mth_filename)) <> TRUE,
		std.file.AddSuperFile(scout.logs.files_stg.currentyear_superfile_online, scout.logs.files_stg.monthly_stg_prefix + '::' + next_yr_mth_filename)
	)
);
