﻿EXPORT in_transaction_scout_reprocessed := RECORD
	STRING16 transaction_id;
	UNSIGNED5 company_id;
	STRING20 login_id;
	INTEGER6 product_id;
	STRING20 function_name;
	STRING50 esp_method;
	STRING10 interface_version;
	STRING5 delivery_method;
	STRING20 date_added;
	STRING5 death_master_purpose;
	STRING10 ssn_mask;
	STRING10 dob_mask;
	STRING1 dl_mask;
	STRING1 exclude_dmv_pii;
	STRING1 scout_opt_out;
	STRING1 archive_opt_in;
	decimal8_4 response_time;
	STRING data_restriction_mask;
	STRING data_permission_mask;
	STRING30 industry;
	STRING9 i_ssn;
	STRING30 i_name_first;
	STRING30 i_name_last;
	UNSIGNED6 i_lexid;
	STRING60 i_address;
	STRING50 i_city;
	STRING2 i_state;
	STRING9 i_zip;
	STRING30 i_dl;
	STRING2 i_dl_state;
	STRING9 i_tin;
	STRING30 i_name_first_2;
	STRING30 i_name_last_2;
	STRING30 i_name_first_3;
	STRING30 i_name_last_3;
	STRING30 i_name_first_4;
	STRING30 i_name_last_4;
	STRING30 i_name_first_5;
	STRING30 i_name_last_5;
	STRING30 i_name_first_6;
	STRING30 i_name_last_6;
	STRING30 i_name_first_7;
	STRING30 i_name_last_7;
	STRING30 i_name_first_8;
	STRING30 i_name_last_8;
	STRING50 i_bus_name;
	STRING60 i_bus_address;
	STRING50 i_bus_city;
	STRING2 i_bus_state;
	STRING9 i_bus_zip;
	STRING20 i_model_name_1;
  	STRING20 i_model_name_2;
  	STRING60 i_attribute_name;
	STRING10 o_score_1;
	STRING8 o_reason_1_1;
	STRING8 o_reason_1_2;
	STRING8 o_reason_1_3;
	STRING8 o_reason_1_4;
	STRING8 o_reason_1_5;
	STRING8 o_reason_1_6;
	STRING10 o_score_2;
  	STRING8 o_reason_2_1;
	STRING8 o_reason_2_2;
	STRING8 o_reason_2_3;
	STRING8 o_reason_2_4;
	STRING8 o_reason_2_5;
	STRING8 o_reason_2_6;
	UNSIGNED6 o_lexid;	
    integer2 o_glb;
    integer2 o_dppa;
 	STRING8 i_dob;
    STRING120 i_name_full;
    STRING20 i_home_phone;
    STRING20 i_work_phone;
    STRING50 i_alt_bus_name;
    STRING50 i_bus_phone;
    STRING14 o_bdid;
    UNSIGNED8 o_seleid;
	STRING20 date_inserted;	
end;