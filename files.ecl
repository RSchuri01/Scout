EXPORT files := MODULE

//MBS transaction files
EXPORT NonFCRA_online := dataset('~thor::in::score_logsv2::log_mbs_transaction_online', Score_Logsv2.layouts.in_transaction_online, csv(separator('|\t|'), terminator('|\n')),opt);

EXPORT NonFCRA_scout := dataset('~thor::in::score_logsv2::log_mbs_transaction_scout', Score_Logsv2.layouts.in_transaction_scout,  csv(separator('|\t|'), terminator('|\n')),opt);

EXPORT NonFCRA_Intermediate := dataset('~thor::in::score_logsv2::log_mbs_intermediate', Score_Logsv2.layouts.in_Intermediate, csv(separator('|\t|'), terminator('|\n')),opt);
EXPORT FCRA_online := dataset('~thor::in::score_logsv2::log_mbs_fcra_transaction_online', Score_Logsv2.layouts.in_transaction_online, csv(separator('|\t|'), terminator('|\n')),opt);
EXPORT FCRA_scout := dataset('~thor::in::score_logsv2::log_mbs_fcra_transaction_scout', Score_Logsv2.layouts.in_transaction_scout, csv(separator('|\t|'), terminator('|\n')),opt);

EXPORT FCRA_Intermediate := dataset('~thor::in::score_logsv2::log_mbs_fcra_intermediate', Score_Logsv2.layouts.in_Intermediate, csv(separator('|\t|'), terminator('|\n')),opt);

//MBS transaction processed files
EXPORT NonFCRA_online_processed := dataset('~thor::in::score_logsv2::log_mbs_transaction_online::processed', Score_Logsv2.layouts.in_transaction_online, csv(separator('|\t|'), terminator('|\n')));

EXPORT NonFCRA_scout_processed := dataset('~thor::in::score_logsv2::log_mbs_transaction_scout::processed', Score_Logsv2.layouts.in_transaction_scout,  csv(separator('|\t|'), terminator('|\n')));

EXPORT NonFCRA_Intermediate_processed := dataset('~thor::in::score_logsv2::log_mbs_intermediate::processed', Score_Logsv2.layouts.in_Intermediate, csv(separator('|\t|'), terminator('|\n')));

EXPORT FCRA_online_processed := dataset('~thor::in::score_logsv2::log_mbs_fcra_transaction_online::processed', Score_Logsv2.layouts.in_transaction_online, csv(separator('|\t|'), terminator('|\n')),opt);
EXPORT FCRA_scout_processed := dataset('~thor::in::score_logsv2::log_mbs_fcra_transaction_scout::processed', Score_Logsv2.layouts.in_transaction_scout, csv(separator('|\t|'), terminator('|\n')),opt);

EXPORT FCRA_Intermediate_processed := dataset('~thor::in::score_logsv2::log_mbs_fcra_intermediate::processed', Score_Logsv2.layouts.in_Intermediate, csv(separator('|\t|'), terminator('|\n')),opt);

END;