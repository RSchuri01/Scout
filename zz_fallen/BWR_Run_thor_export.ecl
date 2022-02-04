/*
Script used for testing the thor export service
*/

Import scout;
#OPTION('OUTPUTLIMIT', 2000);
// #STORED('historyfreq', '7YRS');

//export options
Include_Customer_Input_in := true;
Include_Customer_Response_in := true;
Include_AccountingLog_Data_in := true;
Modeling_Shell_layout_option_in := False;
Mask_pii_in := false;
percent_trans := 0;
number_trans := 0;
requestor := 'allefr01';

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
// in_TransactionID := '473245363R207854';
in_TransactionID := '';
StartYear := 2019;
StartMonth := 04;
StartDay := 30;
StartHour24 := 00;
StartMinute := 00;
StartSecond := 00;
EndYear := 2019;
EndMonth := 04;
EndDay := 30;
EndHour24 := 23;
EndMinute := 59;
EndSecond := 59;
in_CompanyID := 0;
in_LoginID := '';
in_ProductID := '1'; //1 for NONFCRA, 2 for FCRA
in_DRM := '';
in_DPM := '';
in_Industry := '';
in_ESPMethodName := '';
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
	scout.services.layouts.export_options Into_options() := transform
		self.Include_Customer_Input := Include_Customer_Input_in;
		self.Include_Customer_Response := Include_Customer_Response_in;
		self.Include_AccountingLog_Data := Include_AccountingLog_Data_in;
		self.Modeling_Shell_layout_option := Modeling_Shell_layout_option_in;
		self.Mask_pii := Mask_pii_in;
		self.percent_transactions := percent_trans;
		self.number_transactions := number_trans;
		self.user := requestor;
	end;
	
	options_temp := Dataset([Into_options()]);
	export_options := options_temp[1];


results := scout.services.thor_export_service(in_rec, export_options);

output(in_rec);
output(export_options);

results;