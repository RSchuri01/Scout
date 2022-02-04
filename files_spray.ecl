IMPORT * from $;
IMPORT scout;
IMPORT scout.logs.layout;

EXPORT files_spray := module

  EXPORT spray_prefix 	:= scout.common.scout_spray + '::logs::' + scout.common.stored_frequency;
 	
  shared mbs_fcra_intermediate			:= 'log_mbs_fcra_intermediate_log';
  shared mbs_fcra_transaction_online	:= 'log_mbs_fcra_transaction_log_online';
  shared mbs_fcra_transaction_scout		:= 'log_mbs_fcra_transaction_log_scout';
  shared mbs_intermediate				:= 'log_mbs_intermediate_log';
  shared mbs_transaction_online			:= 'log_mbs_transaction_log_online';
  shared mbs_transaction_scout			:= 'log_mbs_transaction_log_scout';
  shared mbs_fcra_intermediate_reprocessed			:= 'log_mbs_fcra_intermediate_log_reprocessed';
  shared mbs_fcra_transaction_online_reprocessed	:= 'log_mbs_fcra_transaction_log_online_reprocessed';
  shared mbs_fcra_transaction_scout_reprocessed		:= 'log_mbs_fcra_transaction_log_scout_reprocessed';
  shared mbs_intermediate_reprocessed				:= 'log_mbs_intermediate_log_reprocessed';
  shared mbs_transaction_online_reprocessed			:= 'log_mbs_transaction_log_online_reprocessed';
  shared mbs_transaction_scout_reprocessed			:= 'log_mbs_transaction_log_scout_reprocessed';

  EXPORT mbs_fcra_intermediate_ds 		:= DATASET(spray_prefix + '::' + mbs_fcra_intermediate, 		layout.in_intermediate, 		csv(separator('|\t|'), terminator('|\n')),opt);
  EXPORT mbs_fcra_transaction_online_ds := DATASET(spray_prefix + '::' + mbs_fcra_transaction_online, 	layout.in_transaction_online, 	csv(separator('|\t|'), terminator('|\n')),opt);
  EXPORT mbs_fcra_transaction_scout_ds 	:= DATASET(spray_prefix + '::' + mbs_fcra_transaction_scout, 	layout.in_transaction_scout, 	csv(separator('|\t|'), terminator('|\n')),opt);
  EXPORT mbs_intermediate_ds			:= DATASET(spray_prefix + '::' + mbs_intermediate, 				layout.in_intermediate,			csv(separator('|\t|'), terminator('|\n')),opt);
  EXPORT mbs_transaction_online_ds		:= DATASET(spray_prefix + '::' + mbs_transaction_online, 		layout.in_transaction_online,	csv(separator('|\t|'), terminator('|\n')),opt);
  EXPORT mbs_transaction_scout_ds		:= DATASET(spray_prefix + '::' + mbs_transaction_scout, 		layout.in_transaction_scout, 	csv(separator('|\t|'), terminator('|\n')),opt);

  EXPORT mbs_fcra_intermediate_reprocessed_ds 		:= DATASET(spray_prefix + '::' + mbs_fcra_intermediate_reprocessed, 		layout.in_intermediate_reprocessed, 		csv(separator('|\t|'), terminator('|\n')),opt);
  EXPORT mbs_fcra_transaction_online_reprocessed_ds := DATASET(spray_prefix + '::' + mbs_fcra_transaction_online_reprocessed, 	layout.in_transaction_online_reprocessed, 	csv(separator('|\t|'), terminator('|\n')),opt);
  EXPORT mbs_fcra_transaction_scout_reprocessed_ds 	:= DATASET(spray_prefix + '::' + mbs_fcra_transaction_scout_reprocessed, 	layout.in_transaction_scout_reprocessed, 	csv(separator('|\t|'), terminator('|\n')),opt);
  EXPORT mbs_intermediate_reprocessed_ds			:= DATASET(spray_prefix + '::' + mbs_intermediate_reprocessed, 				layout.in_intermediate_reprocessed,			csv(separator('|\t|'), terminator('|\n')),opt);
  EXPORT mbs_transaction_online_reprocessed_ds		:= DATASET(spray_prefix + '::' + mbs_transaction_online_reprocessed, 		layout.in_transaction_online_reprocessed,	csv(separator('|\t|'), terminator('|\n')),opt);
  EXPORT mbs_transaction_scout_reprocessed_ds		:= DATASET(spray_prefix + '::' + mbs_transaction_scout_reprocessed, 		layout.in_transaction_scout_reprocessed, 	csv(separator('|\t|'), terminator('|\n')),opt);

END;