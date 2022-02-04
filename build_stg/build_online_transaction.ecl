IMPORT scout;
IMPORT scout.logs.layout as layout;
IMPORT scout.logs.util as util;
IMPORT std.str;
IMPORT std;

online_fcra_ds 		:= scout.logs.files_spray.mbs_fcra_transaction_online_ds;
online_non_fcra_ds	:= scout.logs.files_spray.mbs_transaction_online_ds;
online_reprocessed_fcra_ds := scout.logs.files_spray.mbs_fcra_transaction_online_reprocessed_ds;
online_reprocessed_non_fcra_ds := scout.logs.files_spray.mbs_transaction_online_reprocessed_ds;

tempRec := record
String2 source;
layout.in_transaction_online;
STRING1 processing_status;
STRING20 date_inserted;
end;

file_name := scout.common.app_constants.stage_filename_online;

projected_online_fcra_ds 	:= PROJECT(util.fn_uncompressxml(PROJECT(online_fcra_ds, TRANSFORM(layout.in_transaction_online_reprocessed, SELF := LEFT; SELF := []))),
											TRANSFORM(tempRec,
													  self.source 	:= 'F',
													  self.processing_status := 'P',
													  self.date_inserted := LEFT.date_added,
													  self			:= left))
								   + 
								   PROJECT(util.fn_uncompressxml(online_reprocessed_fcra_ds),
											TRANSFORM(tempRec,
													  self.source 	:= 'F',
													  self.processing_status := 'R',
													  self			:= left));

projected_online_non_fcra_ds 	:= PROJECT(util.fn_uncompressxml(PROJECT(online_non_fcra_ds, TRANSFORM(layout.in_transaction_online_reprocessed, SELF := LEFT; SELF := []))),
											TRANSFORM(tempRec,
													  self.source 	:= 'NF',
													  self.processing_status := 'P',
													  self.date_inserted :=  LEFT.date_added,
													  self			:= left))
								   + 
								   PROJECT(util.fn_uncompressxml(online_reprocessed_non_fcra_ds),
											TRANSFORM(tempRec,
													  self.source 	:= 'NF',
													  self.processing_status := 'R',
													  self			:= left));

combined_online_ds 				:= projected_online_fcra_ds + projected_online_non_fcra_ds;

project_combined_online_ds := PROJECT(combined_online_ds,
									  TRANSFORM(layout.base_transaction_reprocessed,
									  			self.datetime 			:= str.filter(left.date_added, ' 0123456789');
												self.date_inserted 			:= str.filter(left.date_inserted, ' 0123456789');
									  			self.input_recordtype 	:= left.request_format;
												self.output_recordtype 	:= left.response_format;
												self.inputxml 			:= left.request_data;
												self.outputxml 			:= left.response_data;
												self := left;
												self := []));
									  			
dedup_incoming_online_ds :=	DEDUP(SORT(DISTRIBUTE(project_combined_online_ds, HASH(transaction_id)), transaction_id, LOCAL), transaction_id, LOCAL);

fileDate 			:= (String) STD.Date.Today() : stored('filedate');

min_ym          := scout.common.util.dateutils.getyesterday(fileDate)[1..6];

yr_mth			:= min_ym[1..6];
yr_mth_filename	:= min_ym[1..4] + '::' + min_ym[5..6] + '::'+ file_name; // Calucating the yr_month value based on in_recs data

next_yr_mth_filename	:= fileDate[1..4] + '::' + fileDate[5..6] + '::'+ file_name;

// merge new incoming feeds with current monthly file, this will be used to promote the monthly stage with old + new data.
online_base_ds		:=  scout.logs.files_stg.online_month_stg_ds;

scout_base_ds 		:=	scout.logs.files_stg.scout_month_stg_ds;

deduped_with_monthly_online_ds		:= DEDUP(SORT(DISTRIBUTE(online_base_ds + dedup_incoming_online_ds, HASH(TRANSACTION_ID)), 
								 TRANSACTION_ID, LOCAL), TRANSACTION_ID, LOCAL);

/*
	new spray online is added with monthly file and then join against scout to get esp_method filled in. 
	in Old code, the join happens with spray data then join result will be added with monthly file for promotion
	with this change, if we receive scout record of txn with time 060007 and online record of txn with time 055959 
	the txn was not filled with esp_method as scout record of this txn will be received at FIDO in next day than the 
	online record due to the DB export cut off is from 6am to 6am
	Ex : 
	onilne record : NF	70750927R44193	0	B64CMPXML	B64CMPXML	20200716 055958
	scout record :  NF	70750927R44193	1469887	LN_API_AML2	1	CP_VERIFOFOCCP	VERIFICATIONOFOCCUPANCY	1.870000	XML	20200716 060008
*/
deduped_online_ds 	:=   JOIN (DISTRIBUTE(deduped_with_monthly_online_ds, HASH64(transaction_id)), 
                               DISTRIBUTE(scout_base_ds, HASH64(transaction_id)),
								 LEFT.transaction_id = RIGHT.transaction_id,
								 TRANSFORM(RECORDOF(LEFT),
								 		   SELF.company_id 	:= RIGHT.company_id,
								 		   SELF.esp_method	:= RIGHT.esp_method,
								 		   SELF				:= LEFT),
								LEFT OUTER,
										LOCAL);

next_mn         := fileDate[1..6];

EXPORT build_online_transaction := SEQUENTIAL(
	scout.common.util.fn_promote_ds(deduped_online_ds(datetime[1..6] = yr_mth), scout.logs.files_stg.monthly_stg_prefix, yr_mth_filename, true),
	IF(min_ym <> next_mn AND EXISTS(deduped_online_ds(str.filter(datetime, ' 0123456789')[1..6] = next_mn)), 
		scout.common.util.fn_promote_ds(deduped_online_ds(datetime[1..6] = next_mn), scout.logs.files_stg.monthly_stg_prefix, next_yr_mth_filename, true)
	),
	IF(EXISTS(Nothor(STD.File.SuperFileContents(scout.logs.files_stg.currentyear_superfile_online))(name = scout.logs.files_stg.monthly_stg_prefix[2..] + '::' + next_yr_mth_filename)) <> TRUE,
		std.file.AddSuperFile(scout.logs.files_stg.currentyear_superfile_online, scout.logs.files_stg.monthly_stg_prefix + '::' + next_yr_mth_filename)
	)
);