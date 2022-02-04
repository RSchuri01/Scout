EXPORT base_transaction_online_key := RECORD
	STRING16 transaction_id;
	STRING20 datetime;
	unsigned1 seq_num;
	unsigned3 outputxml_len;
	STRING inputxml {BLOB,MAXLENGTH(3072)};
	STRING outputxml {BLOB,MAXLENGTH(29500)}; //key length limit of 32767 
END;