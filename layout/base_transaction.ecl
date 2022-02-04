EXPORT base_transaction := RECORD
	STRING2 	source;
	STRING16 	transaction_id;
	UNSIGNED5 	company_id;
	STRING9 	input_recordtype;
	STRING9 	output_recordtype;
	STRING20 	datetime;
	STRING50 	esp_method;
	STRING 		inputxml {MAXLENGTH(3072)};
	STRING 		outputxml {MAXLENGTH(30720)};
END;

