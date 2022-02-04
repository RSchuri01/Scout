EXPORT alert_parameters := RECORD
    
unsigned4 alert_id;
integer2 status;
unsigned4 type_id;
string type_description;
string alert_name;
unsigned4 product_id;
string esp_method_name;
unsigned4 recipient_group_id;
string recipient_email_addresses;
unsigned4 alert_baseline_timeframe_type_id;
string alert_baseline_timeframe_type_description;
unsigned4 alert_baseline_timeframe_type_requires_date;
string alert_baseline_timeframe_date_type;
unsigned4 timeframe_date_range_type_id    ;
string date_range_type_description  ;
unsigned4 threshold_increases_by_percent;
unsigned4 threshold_decreases_by_percent;
string baseline_date;
string billing_id;
unsigned8 company_id;
integer2 mbs_product_id;
string company_name;
integer2 score_low;
integer2 score_high;
unsigned4 score_average_excluding_exceptions;
unsigned4 score_median_excluding_exceptions;
unsigned4 inputfield_id;
string inputfield;
string attribute_id;
string attribute;
string reason_codes ;
string date_added;
string user_added;
string date_changed;
string user_changed;


END;