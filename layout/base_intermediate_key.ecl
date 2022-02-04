EXPORT base_intermediate_key := RECORD
	STRING16 transaction_id;
	STRING20 datetime;
	unsigned6 product_id;
	unsigned1 seq_num;
	unsigned3 outputxml_len;
	STRING outputxml {BLOB,MAXLENGTH(29500)};//key length limit of 32767 unless blob which cannot be displayed on thor
END;