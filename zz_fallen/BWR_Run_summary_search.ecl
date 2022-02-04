/*
Script used for testing the summary search service
*/

Import scout;
#OPTION('OUTPUTLIMIT', 2000);
#stored();

//Options fields
in_ReturnCount := 100;
in_StartingRecord := 1;
in_SortOnResponseField := '';
in_SortAscending := false;
// in_ReturnCount := 0;
// in_StartingRecord := 0;
// in_SortOnResponseField := '';
// in_SortAscending := false;

//SearchBy fields
//TestSearch1
// in_TransactionID := '479262243R674999';c
in_TransactionID := '';
StartYear := 2015;
StartMonth := 09;
StartDay := 01;
StartHour24 := 0;
StartMinute := 0;
StartSecond := 0;
EndYear := 2015;
EndMonth := 09;
EndDay := 02;
EndHour24 := 00;
EndMinute := 00;
EndSecond := 0;
in_CompanyID := 0;
in_LoginID := '';
in_ProductID := '';
in_DRM := '';
in_DPM := '';
in_Industry := '';
in_ESPMethodName := '';
in_ResponseTimeGreaterThan := '';
in_ModelName := '';
in_Score_low := '';
in_Score_high := '';
in_Score_RCs := dataset([/*{'72'},{'9X'}*/], scout.iesp.share.t_StringArrayItem); //examples: 'EV', '18', '80'
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
in_DataRestrictionMask := '';
in_DataPermissionMask := '';


scout.iesp.scouttransactionsearch.t_ScoutTransactionSearchSearchBy formatsearch() := Transform
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
	// self.DataRestrictionMask := in_DataRestrictionMask;
	// self.DataPermissionMask := in_DataPermissionMask;
	self := [];
End;

searchtemp := dataset([formatsearch()]);
search := searchtemp[1];

scout.iesp.scouttransactionsearch.t_ScoutTransactionSearchOptions formatoptions() := Transform
	self.ReturnCount := in_ReturnCount;
	self.StartingRecord := in_StartingRecord;
	self.SortOnResponseField := in_SortOnResponseField;
	self.SortAscending := in_SortAscending;
	self := [];
End;

optionstemp := dataset([formatoptions()]);
option := optionstemp[1];

scout.iesp.scouttransactionsearch.t_ScoutTransactionSearchRequest formatrequest() := Transform
	self.Options := option;
	self.SearchBy := search;
	self := [];
END;

in_rec := dataset([formatrequest()]);

scout.iesp.context.t_Context formatcontext() := Transform
	a := DATASET([TRANSFORM(scout.iesp.context.t_Gateway,
	                        self.name := 'scout';
							self.url := 'http://delta_iid_api_user:2rch%40p1%24%24@10.176.69.151:7911'; //prod
							// self.url := 'http://fallendevxml:Summer@2018@10.176.68.151:7911'; //cert
							// self.url := 'http://10.176.68.151:7911'; //cert
							// self.url := 'http://espdev64.sc.seisint.com:8909';                          //dev
							)]);

  self.Common.ESP.Config.Method.Gateways := a[1];
	self := [];
END;

in_context := dataset([formatcontext()]);
// in_context := in_context_temp[1];

// output(in_rec, named('in_rec'));
// output(in_context, named('in_context'));

#STORED('ScoutTransactionSearchRequest', in_rec);
#STORED('context', in_context);


scout.services.summary_search_service();
