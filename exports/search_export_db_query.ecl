IMPORT mysql;
IMPORT std;
import scout;
import scout.common;
IMPORT scout.exports as exps;

EXPORT search_export_db_query := MODULE

EXPORT dataset(exps.layout.search_parameters) getExportParameters(integer _searchExportId) := EMBED(mysql : server(common.mysqlconnection.myServer), 
																											port(common.mysqlconnection.myPort), 
																											user(common.mysqlconnection.myUser), 
																											password(common.mysqlconnection.mypass),  
																											database(common.mysqlconnection.myDB), 
																											cache(0))

SELECT
 search.search_id, 	
 search.search_name, 
 search.start_date, 
 search.end_date,  
 search.company_id, 
 search.company_name, 
 search.transaction_id, 
 search.response_time_greater_than, 
 search.esp_login_id,
 IFNULL(search.mbs_product_id, '') AS mbs_product_id, 
 search.consumer_first_name, 
 search.consumer_last_name, 
 search.consumer_lex_id, 
 search.consumer_address, 
 search.consumer_city, 
 search.consumer_state, 
 search.consumer_zip, 
 search.business_name, 
 search.business_tin_fein_id, 
 search.business_auth_rep_first_name, 
 search.business_auth_rep_last_name, 
 search.business_address, 
 search.business_city, 
 search.business_state, 
 search.business_zip, 
 products.product AS 'esp_method_name',
 industry.industry, 
 search.model_number, 
 search.data_restriction_mask, 
 search.data_permission_mask, 
 IFNULL(search.score_low, '') AS score_low,
 IFNULL(search.score_high, '') AS score_high,
 attribute.attribute, 
 attribute_low.attribute, 
 operator_type_low.esp_parameter AS 'attribute_low_operator', -- GREATER_THAN, GREATER_THAN_OR_EQUAL, EQUAL
 attribute_high.attribute, 
 operator_type_high.esp_parameter AS 'attribute_high_operator', -- LESS_THAN, LESS_THAN_OR_EQUAL
 GROUP_CONCAT(TRIM(reasoncodes.reasoncode) SEPARATOR ',') AS reason_codes, -- CSV
 search.date_added AS 'search_date_added', 
 search.user_added AS 'search_user_added', 
 search.date_changed AS 'search_date_changed', 
 search.user_changed AS 'search_user_changed',
 export.search_export_id,  -- use this id to update export status
 export.include_customer_data_inputs, 
 export.include_accounting_log_data, 
 export.include_customer_response_data, 
 IFNULL(export.random_number_of_transactions,0), 
 IFNULL(export.random_percent_of_transactions,0), 
 export.shell_ready_export_format, 
 export.export_status_id, 
 export.requester_email, 
 export.report_path, 
 export.mask_pii,
 export.date_added AS 'export_date_added', 
 export.user_added AS 'export_user_added', 
 export.date_changed AS 'export_date_changed', 
 export.user_changed AS 'export_user_changed'
FROM mbs_search_export export
JOIN mbs_search search ON export.search_id = search.search_id
LEFT JOIN meta_products products ON search.product_id = products.product_id -- reason codes
LEFT JOIN mbs_attribute_operator_type operator_type_low ON search.attribute_low_operator_type_id = operator_type_low.attribute_operator_type_id
LEFT JOIN mbs_attribute_operator_type operator_type_high ON search.attribute_high_operator_type_id = operator_type_high.attribute_operator_type_id
LEFT JOIN meta_attributes attribute ON search.attribute_id = attribute.attribute_id
LEFT JOIN meta_attributes attribute_low ON search.attribute_low = attribute_low.attribute_id
LEFT JOIN meta_attributes attribute_high ON search.attribute_high = attribute_high.attribute_id
LEFT JOIN meta_industry industry ON search.industry = industry.industry_id
LEFT JOIN mbs_search_reason_code search_reason_codes ON search.search_id = search_reason_codes.search_id AND search_reason_codes.status = 1
LEFT JOIN meta_reasoncodes reasoncodes ON search_reason_codes.reasoncode_id = reasoncodes.reasoncode_id
WHERE export.export_status_id = 2 and export.search_export_id = ?
GROUP BY export.search_export_id;

ENDEMBED; 

END;