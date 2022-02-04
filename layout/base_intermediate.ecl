EXPORT base_intermediate	:= RECORD
	STRING2 	source;
	STRING16 	transaction_id;
	STRING20 	datetime;
	UNSIGNED6 	product_id;
	STRING 		outputxml {MAXLENGTH(162000)};
END;