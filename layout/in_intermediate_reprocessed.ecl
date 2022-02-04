EXPORT in_intermediate_reprocessed := RECORD

STRING20 	transaction_id; 
UNSIGNED6 	product_id; 
STRING20 	date_added;
INTEGER4 	process_type; 
decimal5_2 	processing_time; 
STRING20 	source_code; 
STRING20 	content_type; 
STRING20 	version;
STRING15 	reference_number;
STRING 		content_data;
STRING20 	date_inserted;
end;