import scout;
import scout.exports as exps;
import scout.common.spray;
import std;

//#stored('searchExportId','22');

string exportSearchId :=  '' : stored('exportSearchId');

checkInput := IF(exportSearchId = '', FAIL('Invalid_Search Condition'));

getSearchRecord := scout.exports.search_export_db_query.getExportParameters((integer)exportSearchId);

//getSearchRecord;

scout.iesp.scout_search_detail.t_ScoutTransactionSearchSearchBy formatsearch(exps.layout.search_parameters in) := Transform
	self.TransactionId := in.transaction_id;
	self.DateRange.StartTimeStamp.Year := (integer)in.start_date[1..4];
	self.DateRange.StartTimeStamp.Month := (integer)in.start_date[6..7];
	self.DateRange.StartTimeStamp.Day := (integer)in.start_date[9..10];
	self.DateRange.StartTimeStamp.Hour24 := (integer)in.start_date[12..13];
	self.DateRange.StartTimeStamp.Minute := (integer)in.start_date[15..16];
	self.DateRange.StartTimeStamp.Second := (integer)in.start_date[18..19];
	self.DateRange.EndTimeStamp.Year := (integer)in.end_date[1..4];
	self.DateRange.EndTimeStamp.Month := (integer)in.end_date[6..7];
	self.DateRange.EndTimeStamp.Day := (integer)in.end_date[9..10];
	self.DateRange.EndTimeStamp.Hour24 := (integer)in.end_date[12..13];
	self.DateRange.EndTimeStamp.Minute := (integer)in.end_date[15..16];
	self.DateRange.EndTimeStamp.Second := 59; //(integer)in.end_date[18..19];
	self.CompanyId := (integer)in.company_id;
	self.ProductId := in.product_id;
	self.ESPLoginId := in.Login_ID; 
	self.DataRestrictionMask := in.data_restriction_mask;
	self.DataPermissionMask := in.data_permission_mask;
	self.Industry := in.Industry;
	self.ESPMethodName := in.product;
	self.ResponseTimeGreaterThan := in.response_time_greater_than;
	self.ModelName := in.model_number;// Check with Danny if it is modelName or number;
	self.Score.ValueRange.Low := in.score_low;
	self.Score.ValueRange.High := in.Score_high;
    in_RC_temp := scout.services.functions.fromDelimited(in.reasoncodes);
    self.Score := project(in_RC_temp, transform(scout.iesp.scout_search_detail.t_ScoutTransactionSearchScore,
                                              self.reasoncodes := project(left, transform(scout.iesp.share.t_StringArrayItem,
                                                                                                self.value := left.fieldvalues)),
                                              self := []));
	self.Attribute.Name := in.Attribute;
	self.Attribute.OperatorOne := in.operator_type_low_esp_parameter;
	self.Attribute.ValueOne := in.attribute_low;
	self.Attribute.OperatorTwo := in.operator_type_high_esp_parameter;
	self.Attribute.ValueTwo := in.attribute_high;
	self.Consumer.Name.First := in.consumer_first_name;
	self.Consumer.Name.Last := in.consumer_last_name;
	self.Consumer.SSN := ''; //in_Consumer_SSN; // Not persisted 
	self.Consumer.Address.StreetAddress1 := in.Consumer_Address;
	self.Consumer.Address.City := in.Consumer_City;
	self.Consumer.Address.State := in.Consumer_State;
	self.Consumer.Address.Zip5 := in.Consumer_Zip;
	self.Consumer.DriverLicense := ''; //in_Consumer_DL; // Not found in Search table
	self.Business.Name := in.business_name;
	self.Business.FEIN := in.business_tin_fein_id;
	self.Business.Address.StreetAddress1 := in.Business_Address;
	self.Business.Address.City := in.Business_City;
	self.Business.Address.State := in.Business_State;
	self.Business.Address.Zip5 := in.Business_Zip;
	
	self := [];
End;


searchtemp := DATASET([formatsearch(getSearchRecord[1])]);
search := searchtemp[1];

//search;

scout.iesp.scout_search_detail.t_ScoutTransactionSearchRequest formatrequest(scout.iesp.scout_search_detail.t_ScoutTransactionSearchSearchBy srch) := Transform
	self.SearchBy := srch;
	self := [];
END;

in_rec_temp := dataset([formatrequest(search)]);
in_rec := in_rec_temp[1];

//in_rec;

//Transform the options into the option layout
//scout.services.layouts.export_options Into_options(searchInputRec in) := transform

scout.services.layouts.export_options Into_options(exps.layout.search_parameters in) := transform
	self.Include_Customer_Input := in.include_customer_data_inputs;
	self.Include_Customer_Response := in.include_customer_response_data;
	self.Include_AccountingLog_Data := in.include_accounting_log_data;
	self.Modeling_Shell_layout_option := in.shell_ready_export_format;
	self.percent_transactions := in.random_percent_of_transactions;
	self.number_transactions := in.random_number_of_transactions;
	self.user := in.search_user_added;
	self.Mask_pii := in.mask_pii; 
end;

options_temp := Dataset([Into_options(getSearchRecord[1])]);
export_options_record := options_temp[1];

//export_options_record;

EXPORT run_search_export := sequential(checkInput, scout.services.thor_export_service(in_rec, export_options_record));