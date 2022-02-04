EXPORT base_intermediate_reprocessed	:= RECORD
	STRING2 	source;
	STRING16 	transaction_id;
	STRING20 	datetime;
	UNSIGNED6 	product_id;
	STRING 		outputxml {MAXLENGTH(162000)};
	string20 date_inserted;
	string1 processing_status;
END;