IMPORT mysql;
IMPORT std;
import scout;
import scout.common;
IMPORT scout.exports as exps;

EXPORT alert_export_db_query := MODULE

EXPORT dataset(exps.layout.alert_parameters) getAlertParameters(integer _alertExportId) := EMBED(mysql : server(common.mysqlconnection.myServer), 
																											port(common.mysqlconnection.myPort), 
																											user(common.mysqlconnection.myUser), 
																											password(common.mysqlconnection.mypass),  
																											database(common.mysqlconnection.myDB), 
																											cache(0))


SELECT
  alert.alert_id,
  alert.status,
  alert.alert_type_id,
  alert_type.description AS 'alert_type_description',
  alert.alert_name,
  alert.product_id,
  products.product AS 'esp_method_name',
  alert.recipient_group_id,
  GROUP_CONCAT(recipient.email_address SEPARATOR ',') AS recipient_email_addresses,
  alert.alert_baseline_timeframe_type_id,
  timeframe_type.description AS alert_baseline_timeframe_type_description,
  timeframe_type.requires_baseline_date AS alert_baseline_timeframe_type_requires_date,
  IF(timeframe_type.requires_baseline_date, 'static', 'rolling') AS alert_baseline_timeframe_date_type,
  date_range_type.timeframe_date_range_type_id,    
  date_range_type.description AS date_range_type_description,  
  alert.threshold_increases_by_percent,
  alert.threshold_decreases_by_percent,
  alert.baseline_date,
  alert.billing_id,
  alert.company_id,
  alert.mbs_product_id,
  alert.company_name,
  alert.score_low,
  alert.score_high,
  alert.score_average_excluding_exceptions,
  alert.score_median_excluding_exceptions,
  alert.inputfield_id,
  inputfield.inputfield,
  alert.attribute_id,
  attribute.attribute,
  GROUP_CONCAT(TRIM(reasoncodes.reasoncode) SEPARATOR ',') AS reason_codes, -- CSV
  alert.date_added AS 'alert_date_added',
  alert.user_added AS 'alert_user_added',
  alert.date_changed AS 'alert_date_changed',
  alert.user_changed AS 'alert_user_changed'
FROM
  scout.mbs_alert alert
  JOIN mbs_alert_type alert_type ON alert.alert_type_id = alert_type.alert_type_id
  LEFT JOIN mbs_alert_baseline_timeframe_type timeframe_type ON alert.alert_baseline_timeframe_type_id = timeframe_type.alert_baseline_timeframe_type_id
  LEFT JOIN mbs_timeframe_date_range_type date_range_type ON timeframe_type.timeframe_date_range_type_id = date_range_type.timeframe_date_range_type_id
  LEFT JOIN mbs_alert_reason_code alert_reason_codes ON alert.alert_id = alert_reason_codes.alert_id AND alert_reason_codes.status = 1
  LEFT JOIN mbs_recipient_list recipient_list ON alert.recipient_group_id = recipient_list.recipient_group_id AND recipient_list.status = 1
  LEFT JOIN mbs_recipient recipient ON recipient_list.recipient_id = recipient.recipient_id
  LEFT JOIN meta_inputfields inputfield ON alert.inputfield_id = inputfield.inputfield_id
  LEFT JOIN meta_attributes attribute ON alert.attribute_id = attribute.attribute_id  
  LEFT JOIN meta_reasoncodes reasoncodes ON alert_reason_codes.reasoncode_id = reasoncodes.reasoncode_id
  LEFT JOIN meta_products products ON alert.product_id = products.product_id
WHERE alert.alert_id = ? 
GROUP BY alert.alert_id;

ENDEMBED; 

END;