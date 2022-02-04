import  Score_logs;

EXPORT layouts := module

EXPORT in_transaction_online := RECORD 
string20 transaction_id;  
integer4 transaction_type; 
STRING request_data;
STRING response_data;
string9 request_format; 
string9 response_format; 
string20 date_added; 
end;


EXPORT in_intermediate := RECORD

string20 transaction_id; 
unsigned6 product_id; 
string20 date_added;
integer4 process_type; 
decimal5_2 processing_time; 
string20 source_code; 
string20 content_type; 
string20 version;
string15 reference_number;
STRING content_data;

end;

EXPORT in_transaction_scout := RECORD

	string16 transaction_id;
	unsigned5 company_id;
	string20 login_id;
	integer6 product_id;
	string20 function_name;
	string50 esp_method;
	string10 interface_version;
	string5 delivery_method;
	string20 date_added;
	string5 death_master_purpose;
	string10 ssn_mask;
	string10 dob_mask;
	string1 dl_mask;
	string1 exclude_dmv_pii;
	string1 scout_opt_out;
	string1 archive_opt_in;
	decimal8_4 response_time;
	STRING data_restriction_mask;
	STRING data_permission_mask;
	string30 industry;
  string9 i_ssn;
	string30 i_name_first;
	string30 i_name_last;
	unsigned6 i_lexid;
	string60 i_address;
	string50 i_city;
	string2 i_state;
	string9 i_zip;
	string30 i_dl;
	string2 i_dl_state;
	string9 i_tin;
	string30 i_name_first_2;
	string30 i_name_last_2;
	string30 i_name_first_3;
	string30 i_name_last_3;
	string30 i_name_first_4;
	string30 i_name_last_4;
	string30 i_name_first_5;
	string30 i_name_last_5;
	string30 i_name_first_6;
	string30 i_name_last_6;
	string30 i_name_first_7;
	string30 i_name_last_7;
	string30 i_name_first_8;
	string30 i_name_last_8;
	string50 i_bus_name;
	string60 i_bus_address;
	string50 i_bus_city;
	string2 i_bus_state;
	string9 i_bus_zip;
	string20 i_model_name_1;
  string20 i_model_name_2;
  string60 i_attribute_name;
	string10 o_score_1;
	string4 o_reason_1_1;
	string4 o_reason_1_2;
	string4 o_reason_1_3;
	string4 o_reason_1_4;
	string4 o_reason_1_5;
	string4 o_reason_1_6;
	string10 o_score_2;
  string4 o_reason_2_1;
	string4 o_reason_2_2;
	string4 o_reason_2_3;
	string4 o_reason_2_4;
	string4 o_reason_2_5;
	string4 o_reason_2_6;
	unsigned6 o_lexid;

end;

EXPORT Base_Transaction_Layout := RECORD
	STRING2 source;
	STRING16 transaction_id;
	unsigned5 company_id;
	STRING9 input_recordtype;
	STRING9 output_recordtype;
	STRING20 datetime;
	STRING50 esp_method;
	STRING inputxml {MAXLENGTH(3072)};
	STRING outputxml {MAXLENGTH(30720)};
END;

EXPORT Base_Intermediate_Layout := RECORD
	STRING2 source;
	STRING16 transaction_id;
	STRING20 datetime;
	unsigned6 product_id;
	STRING outputxml {MAXLENGTH(162000)};

END;


EXPORT base_transaction_scout := RECORD
  STRING2 source;
	string16 transaction_id;
	unsigned5 company_id;
	string20 login_id;
	integer6 product_id;
	string20 function_name;
	string50 esp_method;
	string10 interface_version;
	string5 delivery_method;
	string20 datetime;
	string5 death_master_purpose;
	string10 ssn_mask;
	string10 dob_mask;
	string1 dl_mask;
	string1 exclude_dmv_pii;
	string1 scout_opt_out;
	string1 archive_opt_in;
	decimal8_4 response_time;
	STRING data_restriction_mask;
	STRING data_permission_mask;
	string30 industry;
  string9 i_ssn;
	string30 i_name_first;
	string30 i_name_last;
	unsigned6 i_lexid;
	string60 i_address;
	string50 i_city;
	string2 i_state;
	string9 i_zip;
	string30 i_dl;
	string2 i_dl_state;
	string9 i_tin;
	string30 i_name_first_2;
	string30 i_name_last_2;
	string30 i_name_first_3;
	string30 i_name_last_3;
	string30 i_name_first_4;
	string30 i_name_last_4;
	string30 i_name_first_5;
	string30 i_name_last_5;
	string30 i_name_first_6;
	string30 i_name_last_6;
	string30 i_name_first_7;
	string30 i_name_last_7;
	string30 i_name_first_8;
	string30 i_name_last_8;
	string50 i_bus_name;
	string60 i_bus_address;
	string50 i_bus_city;
	string2 i_bus_state;
	string9 i_bus_zip;
	string20 i_model_name_1;
  string20 i_model_name_2;
  string60 i_attribute_name;
	string10 o_score_1;
	string4 o_reason_1_1;
	string4 o_reason_1_2;
	string4 o_reason_1_3;
	string4 o_reason_1_4;
	string4 o_reason_1_5;
	string4 o_reason_1_6;
	string10 o_score_2;
  string4 o_reason_2_1;
	string4 o_reason_2_2;
	string4 o_reason_2_3;
	string4 o_reason_2_4;
	string4 o_reason_2_5;
	string4 o_reason_2_6;
	unsigned6 o_lexid;	
end;

EXPORT attributes := RECORD
	STRING16 transaction_id;
	STRING50 esp_method;
// risk_reporting.Layouts.Attributes_Layout;
end;

EXPORT attributes_key := RECORD
	STRING16 transaction_id;
	STRING50  AttributeName;
	STRING50	AttributeValue;
end;

EXPORT Base_Transaction_online_Key := RECORD
	STRING16 transaction_id;
	STRING20 datetime;
	unsigned1 seq_num;
	unsigned3 outputxml_len;
	STRING inputxml {BLOB,MAXLENGTH(3072)};
	STRING outputxml {BLOB,MAXLENGTH(29500)}; //key length limit of 32767 
END;

EXPORT Base_Intermediate_Key := RECORD
	STRING16 transaction_id;
	STRING20 datetime;
	unsigned6 product_id;
	unsigned1 seq_num;
	unsigned3 outputxml_len;
	STRING outputxml {BLOB,MAXLENGTH(29500)};//key length limit of 32767 unless blob which cannot be displayed on thor
END;

EXPORT Scout_companyid_key := RECORD

unsigned5	company_id;
integer6	product_id;
string20	datetime;
string16	transaction_id;

end;

EXPORT Scout_name_key := RECORD

string30	fname;
string30	lname;
string20	datetime;
string16	transaction_id;

end;

EXPORT Scout_bus_name_key := RECORD

string50	bus_name;
string20	datetime;
string16	transaction_id;

end;

EXPORT Scout_address_key := RECORD

string50 city;
string2	 st;
string5	 zip;
string20	 datetime;
string16	transaction_id;

end;

EXPORT Scout_industry_key := RECORD

string30	industry;
string20	datetime;
string16	transaction_id;

end;

EXPORT Scout_loginID_key := RECORD

string20	login_id;
string20	datetime;
string16	transaction_id;

end;

EXPORT Scout_esp_method_key := RECORD

string50	esp_method;
string20	datetime;
string16	transaction_id;

end;

end;
