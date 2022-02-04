Import scout, std;
#OPTION('OUTPUTLIMIT', 2000);

//export options
in_input_pop_report := false;
in_score_report := false;
in_reasoncode_report := true;
in_attribute_report := False;
in_Report_type := 'day';  //OnDemand, Daily, Weekly, Monthly
in_bin_type := 2;
requestor := 'fallen';
 
//Options fields
in_ReturnCount := 0;
in_StartingRecord := 0;
in_SortOnResponseField := '';
in_SortAscending := false;
// in_ReturnCount := 0;
// in_StartingRecord := 0;
// in_SortOnResponseField := '';
// in_SortAscending := false;

//SearchBy fields
//TestSearch1
// in_TransactionID := '163066621R100';
in_TransactionID := '';
StartYear := 2018;
StartMonth := 06;
StartDay := 01;
StartHour24 := 00;
StartMinute := 00;
StartSecond := 00;
EndYear := 2018;
EndMonth := 09;
EndDay := 30;
EndHour24 := 00;
EndMinute := 01;
EndSecond := 00;
in_CompanyID := 0;
// in_CompanyID := 1523780;
in_LoginID := '';
in_ProductID := '';
in_DRM := '';
in_DPM := '';
in_Industry := '';
in_ESPMethodName := 'Fraudpoint';
// in_ESPMethodName := '';
in_ResponseTimeGreaterThan := '';
in_ModelName := '';
in_Score_low := '';
in_Score_high := '';
in_Score_RCs := dataset([/*{'72'},{'9X'}*/], scout.iesp.share.t_StringArrayItem); // 'EV', '18', '80'
in_Attribute_name := '';
in_Attribute_OperatorOne := '';
in_Attribute_ValueOne := '';
in_Attribute_OperatorTwo := '';
in_Attribute_ValueTwo := '';
in_Consumer_FirstName := '';
in_Consumer_LastName := '';
in_Consumer_SSN := '';
in_Consumer_Address := '';
in_Consumer_City := '';
in_Consumer_State := '';
in_Consumer_Zip := '';
in_Consumer_DL := '';
in_Bus_Name := '';
in_Bus_FEIN := '';
in_Bus_AuthFirstName := '';
in_Bus_AuthLastName := '';
in_Bus_Address := '';
in_Bus_City := '';
in_Bus_State := '';
in_Bus_Zip := '';

//TestSearch2
// in_TransactionID := '163066621R100';
// in_TransactionID := '';
// StartYear := 2017;
// StartMonth := 08;
// StartDay := 01;
// StartHour24 := 0;
// StartMinute := 0;
// StartSecond := 0;
// EndYear := 2017;
// EndMonth := 08;
// EndDay := 10;
// EndHour24 := 0;
// EndMinute := 0;
// EndSecond := 0;
// in_CompanyID := 0;
// in_LoginID := '';
// in_ProductID := '';
// in_DRM := '';
// in_DPM := '';
// in_Industry := '';
// in_ESPMethodName := 'Riskview2';
// in_ResponseTimeGreaterThan := '';
// in_ModelName := '';
// in_Score_low := '';
// in_Score_high := '';
// in_Score_RCs := dataset([], scout.iesp.share.t_StringArrayItem); // 'EV', '18', '80'
// in_Attribute_name := '';
// in_Attribute_OperatorOne := '';
// in_Attribute_ValueOne := '';
// in_Attribute_OperatorTwo := '';
// in_Attribute_ValueTwo := '';
// in_Consumer_FirstName := '';
// in_Consumer_LastName := '';
// in_Consumer_SSN := '';
// in_Consumer_Address := '';
// in_Consumer_City := '';
// in_Consumer_State := '';
// in_Consumer_Zip := '';
// in_Consumer_DL := '';
// in_Bus_Name := '';
// in_Bus_FEIN := '';
// in_Bus_AuthFirstName := '';
// in_Bus_AuthLastName := '';
// in_Bus_Address := '';
// in_Bus_City := '';
// in_Bus_State := '';
// in_Bus_Zip := '';

// soapcall

scout.iesp.scout_search_detail.t_ScoutTransactionSearchSearchBy formatsearch() := Transform
	self.TransactionId := in_TransactionID;
	self.DateRange.StartTimeStamp.Year := StartYear;
	self.DateRange.StartTimeStamp.Month := StartMonth;
	self.DateRange.StartTimeStamp.Day := StartDay;
	self.DateRange.StartTimeStamp.Hour24 := StartHour24;
	self.DateRange.StartTimeStamp.Minute := StartMinute;
	self.DateRange.StartTimeStamp.Second := StartSecond;
	self.DateRange.EndTimeStamp.Year := EndYear;
	self.DateRange.EndTimeStamp.Month := EndMonth;
	self.DateRange.EndTimeStamp.Day := EndDay;
	self.DateRange.EndTimeStamp.Hour24 := EndHour24;
	self.DateRange.EndTimeStamp.Minute := EndMinute;
	self.DateRange.EndTimeStamp.Second := EndSecond;
	self.CompanyId := in_CompanyID;
	self.ProductId := in_ProductID;
	self.ESPLoginId := in_LoginID;
	self.DataRestrictionMask := in_DRM;
	self.DataPermissionMask := in_DPM;
	self.Industry := in_Industry;
	self.ESPMethodName := in_ESPMethodName;
	self.ResponseTimeGreaterThan := in_ResponseTimeGreaterThan;
	self.ModelName := in_ModelName;
	self.Score.ValueRange.Low := in_Score_low;
	self.Score.ValueRange.High := in_Score_high;
	self.Score.ReasonCodes := in_Score_RCs;
	self.Attribute.Name := in_Attribute_name;
	self.Attribute.OperatorOne := in_Attribute_OperatorOne;
	self.Attribute.ValueOne := in_Attribute_ValueOne;
	self.Attribute.OperatorTwo := in_Attribute_OperatorTwo;
	self.Attribute.ValueTwo := in_Attribute_ValueTwo;
	self.Consumer.Name.First := in_Consumer_FirstName;
	self.Consumer.Name.Last := in_Consumer_LastName;
	self.Consumer.SSN := in_Consumer_SSN;
	self.Consumer.Address.StreetAddress1 := in_Consumer_Address;
	self.Consumer.Address.City := in_Consumer_City;
	self.Consumer.Address.State := in_Consumer_State;
	self.Consumer.Address.Zip5 := in_Consumer_Zip;
	self.Consumer.DriverLicense := in_Consumer_DL;
	self.Business.Name := in_Bus_Name;
	self.Business.FEIN := in_Bus_FEIN;
	self.Business.Address.StreetAddress1 := in_Bus_Address;
	self.Business.Address.City := in_Bus_City;
	self.Business.Address.State := in_Bus_State;
	self.Business.Address.Zip5 := in_Bus_Zip;
	
	self := [];
End;

searchtemp := dataset([formatsearch()]);
search := searchtemp[1];

scout.iesp.scout_search_detail.t_ScoutTransactionSearchOptions formatoptions() := Transform
	self.ReturnCount := in_ReturnCount;
	self.StartingRecord := in_StartingRecord;
	self.SortOnResponseField := in_SortOnResponseField;
	self.SortAscending := in_SortAscending;
	self := [];
End;

optionstemp := dataset([formatoptions()]);
option := optionstemp[1];

scout.iesp.scout_search_detail.t_ScoutTransactionSearchRequest formatrequest() := Transform
	self.Options := option;
	self.SearchBy := search;
	self := [];
END;

in_rec_temp := dataset([formatrequest()]);
in_rec := in_rec_temp[1];

//Transform the options into the option layout
	scout.services.layouts.report_options Into_options() := transform
		self.input_pop_report := in_input_pop_report;
		self.score_report := in_score_report;
		self.reasoncode_report := in_reasoncode_report;
		self.attribute_report := in_attribute_report;
		self.Report_date_type := in_Report_type;
        self.score_bin_type := in_bin_type;
		self.user := requestor;
	end;
	
	options_temp := Dataset([Into_options()]);
	report_options := options_temp[1];

results := scout.services.AllLogReports.product_rc_report(in_rec, report_options) : PERSIST('input_for_bwr_run_report_rc');

results1 := scout.services.summary_report_service(in_rec, report_options);

scout.logs.util.MacroToFindVarianceForMeasure(results, rc_1, varienceDiff, 'MONTHLY', 1, 20180701, 20180731 );

// Output(results, all);

// results1;

output(varienceDiff, all, named('rc_1'));
 
// results; 