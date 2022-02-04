﻿/*** Not to be hand edited (changes will be lost on re-generation) ***/
/*** ECL Interface generated by esdl2ecl version 1.0 from scouttransactionsearch.xml. ***/
/*===================================================*/

import scout.iesp as iesp;

export scouttransactionsearch := MODULE
			
export t_ScoutTransactionSearchOptions := record
	integer ReturnCount {xpath('ReturnCount')};
	integer StartingRecord {xpath('StartingRecord')};
	string20 SortOnResponseField {xpath('SortOnResponseField')};
	boolean SortAscending {xpath('SortAscending')};
end;
		
export t_ScoutTransactionSearchConsumer := record
	string20 UniqueId {xpath('UniqueId')};
	iesp.scout_share.t_Name Name {xpath('Name')};
	string9 SSN {xpath('SSN')};
	iesp.scout_share.t_Address Address {xpath('Address')};
	string30 DriverLicense {xpath('DriverLicense')};
end;
		
export t_ScoutTransactionSearchBusiness := record
	string50 Name {xpath('Name')};
	string9 FEIN {xpath('FEIN')};
	iesp.scout_share.t_Name AuthRepName {xpath('AuthRepName')};
	iesp.scout_share.t_Address Address {xpath('Address')};
end;
		
export t_ScoutTransactionSearchAttribute := record
	string30 Name {xpath('Name')};
	string30 OperatorOne {xpath('OperatorOne')}; //values['','GREATER_THAN','GREATER_THAN_OR_EQUAL','EQUAL','']
	string10 ValueOne {xpath('ValueOne')};
	string30 OperatorTwo {xpath('OperatorTwo')}; //values['','LESS_THAN','LESS_THAN_OR_EQUAL','']
	string10 ValueTwo {xpath('ValueTwo')};
end;
		
export t_ScoutTransactionSearchScore := record
	iesp.scout_share.t_StringRange ValueRange {xpath('ValueRange')};
	dataset(iesp.share.t_StringArrayItem) ReasonCodes {xpath('ReasonCodes/ReasonCode'), MAXCOUNT(iesp.Constants.SCOUT.MaxRCFilter)};
end;
		
export t_TimeStampRange := record
	iesp.scout_share.t_TimeStamp StartTimeStamp {xpath('StartTimeStamp')};
	iesp.scout_share.t_TimeStamp EndTimeStamp {xpath('EndTimeStamp')};
end;
		
export t_ScoutTransactionSearchSearchBy := record
	string16 TransactionId {xpath('TransactionId')};
	t_TimeStampRange DateRange {xpath('DateRange')};
	integer CompanyId {xpath('CompanyId')};
	string2 ProductId {xpath('ProductId')};
	string20 ESPLoginId {xpath('ESPLoginId')};
	string1024 DataRestrictionMask {xpath('DataRestrictionMask')};
	string1024 DataPermissionMask {xpath('DataPermissionMask')};
	string30 Industry {xpath('Industry')};
	string30 ESPMethodName {xpath('ESPMethodName')};
	string10 ResponseTimeGreaterThan {xpath('ResponseTimeGreaterThan')};
	string20 ModelName {xpath('ModelName')};
	t_ScoutTransactionSearchScore Score {xpath('Score')};
	t_ScoutTransactionSearchAttribute Attribute {xpath('Attribute')};
	t_ScoutTransactionSearchConsumer Consumer {xpath('Consumer')};
	t_ScoutTransactionSearchBusiness Business {xpath('Business')};
end;
		
export t_ScoutTransactionSearchRecord := record
	string16 TransactionId {xpath('TransactionId')};
	integer CompanyId {xpath('CompanyId')};
	string2 ProductId {xpath('ProductId')};
	iesp.scout_share.t_Name Name {xpath('Name')};
	string50 BusinessName {xpath('BusinessName')};
	iesp.scout_share.t_TimeStamp TimeStamp {xpath('TimeStamp')};
	string50 ESPMethodName {xpath('ESPMethodName')};
end;
		
export t_ScoutTransactionSearchResponse := record
	integer RecordCount {xpath('RecordCount')};
	string1024 Message {xpath('Message')};
	dataset(t_ScoutTransactionSearchRecord) Records {xpath('Records/Record'), MAXCOUNT(iesp.Constants.SCOUT.MaxSearchRecords)};
end;
		
export t_ScoutTransactionSearchRequest := record (iesp.scout_share.t_ScoutBaseRequest)
	t_ScoutTransactionSearchOptions Options {xpath('Options')};
	t_ScoutTransactionSearchSearchBy SearchBy {xpath('SearchBy')};
end;
		
export t_ScoutTransactionSearchResponseEx := record
	t_ScoutTransactionSearchResponse response {xpath('response')};
end;
		

end;

/*** Not to be hand edited (changes will be lost on re-generation) ***/
/*** ECL Interface generated by esdl2ecl version 1.0 from scouttransactionsearch.xml. ***/
/*===================================================*/
