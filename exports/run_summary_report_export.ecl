import scout;
import scout.exports as exps;
import std;

string summarySearchId :=  '' : stored('summarySearchId');

checkInput := IF(summarySearchId = '', FAIL('Invalid Summary Search Condition'));

getSummaryReportRecord := scout.exports.summary_report_export_db_query.getSummaryReportParameters((integer)summarySearchId);

scout.iesp.scout_search_detail.t_ScoutTransactionSearchSearchBy formatsearch(exps.layout.summary_report_parameters in) := Transform
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
	self.ModelName := in.model_number;
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

searchtemp := dataset([formatsearch(getSummaryReportRecord[1])]);
search := searchtemp[1];


scout.iesp.scout_search_detail.t_ScoutTransactionSearchRequest formatrequest(scout.iesp.scout_search_detail.t_ScoutTransactionSearchSearchBy srch) := Transform
	self.SearchBy := srch;
	self := [];
END;

in_rec_temp := dataset([formatrequest(search)]);
in_rec := in_rec_temp[1];

//Transform the options into the option layout
	scout.services.layouts.report_options Into_options(exps.layout.summary_report_parameters in) := transform
		self.input_pop_report := (boolean)in.data_inputs_report;
		self.score_report := (boolean)in.scores_summary_report;
		self.reasoncode_report := (boolean)in.rc_wc_ri_report;
		self.attribute_report := (boolean)in.attributes_report;
		self.Report_date_type := in.date_display_type_description; 
    self.score_bin_type := in.score_bin_type_id;
		self := [];
		//self.user := in.requester_email;
	end;
	
	options_temp := Dataset([Into_options(getSummaryReportRecord[1])]);
	report_options := options_temp[1];


//results := scout.services.summary_report_service(in_rec, report_options);

//output(in_rec);
//output(report_options);

x := sequential(output(getSummaryReportRecord, named('getSummaryReportRecord')), output(search, named('Search')), output(in_rec, named('in_rec')));

EXPORT run_summary_report_export := sequential(x, checkInput, scout.services.summary_report_service(in_rec, report_options));