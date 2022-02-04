EXPORT in_transaction_online_reprocessed := RECORD 
	STRING20 	transaction_id;  
	INTEGER4 	transaction_type; 
	STRING 		request_data;
	STRING 		response_data;
	STRING9 	request_format; 
	STRING9 	response_format; 
	STRING20 	date_added; 
	STRING20 	date_inserted;
end;