EXPORT Layouts_InputXML := MODULE

Name_Layout := RECORD
STRING Full{XPATH('Full')};
STRING First{XPATH('First')};
STRING Middle{XPATH('Middle')};
STRING Last{XPATH('Last')};
STRING Suffix{XPATH('Suffix')};
STRING Prefix{XPATH('Prefix')};
END;


address_layout := RECORD
STRING StreetNumber{XPATH('StreetNumber')};
STRING StreetPreDirection{XPATH('StreetPreDirection')};
STRING StreetName{XPATH('StreetName')};
STRING StreetSuffix{XPATH('StreetSuffix')};
STRING StreetPostDirection{XPATH('StreetPostDirection')};
STRING UnitDesignation{XPATH('UnitDesignation')};
STRING UnitNumber{XPATH('UnitNumber')};
STRING StreetAddress1{XPATH('StreetAddress1')};
STRING StreetAddress2{XPATH('StreetAddress2')};
STRING City{XPATH('City')};
STRING State{XPATH('State')};
STRING Zip5{XPATH('Zip5')};
STRING Zip4{XPATH('Zip4')};
STRING County{XPATH('County')};
STRING PostalCode{XPATH('PostalCode')};
STRING StateCityZip{XPATH('StateCityZip')};
END;

dob_layout := RECORD
STRING Year{XPATH('Year')};
STRING Month{XPATH('Month')};
STRING Day{XPATH('Day')};
END;

enduser_layout := record
STRING CompanyName{XPATH('CompanyName')};
STRING StreetAddress1{XPATH('StreetAddress1')};
STRING City{XPATH('City')};
STRING State{XPATH('State')};
STRING Zip5{XPATH('Zip5')};
END;

authorizedrepresentative_layout := RECORD
	DATASET(Name_Layout) Name{XPATH('Name')};
	DATASET(address_layout) Address{XPATH('Address')};
	DATASET(DOB_Layout) DOB{XPATH('DOB')};
	STRING Age{XPATH('Age')};
	STRING SSN{XPATH('SSN')};
	STRING DriverLicenseNumber{XPATH('DriverLicenseNumber')};
	STRING DriverLicenseState{XPATH('DriverLicenseState')};
	STRING Phone10{XPATH('Phone10')};
	STRING FormerLastName{XPATH('FormerLastName')};
END;

user_layout := record
STRING ReferenceCode{XPATH('ReferenceCode')};
STRING BillingCode{XPATH('BillingCode')};
STRING QueryID{XPATH('QueryId')};
STRING CompanyId{XPATH('CompanyId')};
STRING GLBPurpose{XPATH('GLBPurpose')};
STRING DLPurpose{XPATH('DLPurpose')};
string LoginHistoryId{XPATH('LoginHistoryId')};
string DebitUnits{XPATH('DebitUnits')};
string IP{XPATH('IP')};
string IndustryClass{XPATH('IndustryClass')};
string ResultFormat{XPATH('ResultFormat')};
string LogAsFunction{XPATH('LogAsFunction')};
string SSNMask{XPATH('SSNMask')};
string DOBMask{XPATH('DOBMask')};
string DLMask{XPATH('DLMask')};
string DataRestrictionMask{XPATH('DataRestrictionMask')};
string DataPermissionMask{XPATH('DataPermissionMask')};
string SourceCode{XPATH('SourceCode')};
string ApplicationType{XPATH('ApplicationType')};
string SSNMaskingOn{XPATH('SSNMaskingOn')};
string DLMaskingOn{XPATH('DLMaskingOn')};
DATASET(enduser_layout) EndUser{XPATH('EndUser')};
STRING MaxWaitSeconds{XPATH('MaxWaitSeconds')};
STRING AccountNumber{XPATH('AccountNumber')};
STRING RelatedTransactionId{XPATH('RelatedTransactionId')};
STRING TestDataEnabled{XPATH('TestDataEnabled')};
STRING TestDataTableName{XPATH('TestDataTableName')};
END;

RequireExactMatch_layout := RECORD
STRING LastName{XPATH('LastName')};
STRING FirstName{XPATH('FirstName')};
STRING FirstNameAllowNickname{XPATH('FirstNameAllowNickname')};
STRING Address{XPATH('Address')};
STRING HomePhone{XPATH('HomePhone')};
STRING SSN{XPATH('SSN')};
STRING DriverLicense{XPATH('DriverLicense')};
END;

DOBMatch_Layout := record
STRING MatchType{XPATH('MatchType')};
STRING MatchYearRadius{XPATH('MatchYearRadius')};
END;

ModelOption_layout := RECORD
STRING OptionName{XPATH('OptionName')};
STRING OptionValue{XPATH('OptionValue')};
END;

ModelOptions_Layout := RECORD
DATASET(ModelOption_layout) ModelOption{XPATH('ModelOption')};
END;

modelrequest_layout := RECORD
STRING ModelName{XPATH('ModelName')};
DATASET(ModelOptions_layout) ModelOptions{XPATH('ModelOptions')};
END;

modelrequests_layout := RECORD
DATASET(modelrequest_layout) ModelRequest{XPATH('ModelRequest')};
END;

StudentDefenderModel_layout := RECORD
STRING StudentDefender{XPATH('StudentDefender')};
STRING IsStudentApplicant{XPATH('IsStudentApplicant')};
END;

CVIModel_layout := RECORD
STRING IncludeCVI{XPATH('IncludeCVI')};
STRING IncludeNAP{XPATH('IncludeNAP')};
STRING IncludeNAS{XPATH('IncludeNAS')};
END;

FraudPointModel_layout := RECORD
STRING ModelName{XPATH('ModelName')};
STRING IncludeRiskIndices{XPATH('IncludeRiskIndices')};
END;

IncludeModels_Layout := record
STRING BusinessDefender{XPATH('BusinessDefender')};
// STRING FraudPointModel{XPATH('FraudPointModel')};
DATASET(FraudPointModel_layout) FraudPointModel{XPATH('FraudPointModel')};
DATASET(modelrequests_layout) ModelRequests{XPATH('ModelRequests')};
//Instant ID
STRING Thindex{XPATH('Thindex')};
DATASET(StudentDefenderModel_layout) StudentDefenderModel{XPATH('StudentDefenderModel')};
DATASET(CVIModel_layout) CVIModel{XPATH('CVIModel')};
//Lead Integrity
STRING Integrity{XPATH('Integrity')};
END;

WatchList_Layout := RECORD
	STRING All{XPATH('All')};
	STRING Table{XPATH('Table')};
	STRING RecordNumber{XPATH('RecordNumber')};
	STRING Country{XPATH('Country')};
	STRING EntityName{XPATH('EntityName')};
	DATASET(Name_Layout) Name{XPATH('Name')};
	DATASET(Address_layout) Address{XPATH('Address')};
END;

WatchLists_Layout := RECORD
	DATASET(WatchList_Layout) Watchlist{XPATH('WatchList')};
END;


HighRiskIndicator_Layout := RECORD
	STRING Description{XPATH('Description')};
	STRING RiskCode{XPATH('RiskCode')};
 	STRING Sequence{XPATH('Sequence')};
END;

HighRiskIndicators_Layout := RECORD
	DATASET(HighRiskIndicator_Layout) HighRiskIndicator{XPATH('HighRiskIndicator')};
END;

RedFlag_Layout := RECORD
	STRING Name{XPATH('Name')};
	DATASET(HighRiskIndicators_Layout) HighRiskIndicators{XPATH('HighRiskIndicators')};
END;

RedFlags_Layout := RECORD
	DATASET(RedFlag_Layout) RedFlag{XPATH('RedFlag')};
END;

RedFlagsReport_layout := RECORD
	STRING Version{XPATH('Version')};
	DATASET(RedFlags_LAYOUT) RedFlags{XPATH('RedFlags')};
END;

options_layout := RECORD
//FlexID
DATASET(WatchLists_Layout) WatchLists{XPATH('WatchLists')};
STRING UseDOBFilter{XPATH('UseDOBFilter')};
STRING DOBRadius{XPATH('DOBRadius')};
STRING IncludeMSOverride{XPATH('IncludeMSOverride')};
STRING IncludeCLOverride{XPATH('IncludeCLOverride')};
STRING IncludeIncludeReasonCodes{XPATH('IncludeReasonCodes')};
STRING IncludeReasonCodes{XPATH('IncludeIncludeReasonCodes')};
STRING PoBoxCompliance{XPATH('PoBoxCompliance')};
DATASET(RequireExactMatch_layout) RequireExactMatch {XPATH('RequireExactMatch')};
STRING IncludeAllRiskIndicators{XPATH('IncludeAllRiskIndicators')};
STRING IncludeVerifiedElementSummary{XPATH('IncludeVerifiedElementSummary')};
STRING IncludeDLVerification{XPATH('IncludeDLVerification')};
DATASET(DOBMatch_Layout) DOBMatch{XPATH('DOBMatch')};
//Fraudpoint
DATASET(IncludeModels_Layout) IncludeModels{XPATH('IncludeModels')};
DATASET(RedFlagsReport_Layout) RedFlagsReport{XPATH('RedFlagsReport')};
//BusinessInstantID
STRING IncludeOFAC{XPATH('IncludeOFAC')};
STRING IncludeOtherWatchLists{XPATH('IncludeOtherWatchLists')};
STRING GlobalWatchlistThreshold{XPATH('GlobalWatchlistThreshold')};
//LeadIntegrity
STRING AttributesVersionRequest{XPATH('AttributesVersionRequest')};
//FCRAAccountVerificationRequest
STRING Blind{XPATH('Blind')};
STRING Encrypt{XPATH('Encrypt')};
STRING StrictMatch{XPATH('StrictMatch')};
STRING MaxResults{XPATH('MaxResults')};
STRING FCRAPurpose{XPATH('FCRAPurpose')}; 

END;

companyaddress_layout := RECORD
STRING StreetNumber{XPATH('StreetNumber')};
STRING StreetPreDirection{XPATH('StreetPreDirection')};
STRING StreetName{XPATH('StreetName')};
STRING StreetSuffix{XPATH('StreetSuffix')};
STRING StreetPostDirection{XPATH('StreetPostDirection')};
STRING UnitDesignation{XPATH('UnitDesignation')};
STRING UnitNumber{XPATH('UnitNumber')};
STRING StreetAddress1{XPATH('StreetAddress1')};
STRING StreetAddress2{XPATH('StreetAddress2')};
STRING City{XPATH('City')};
STRING State{XPATH('State')};
STRING Zip5{XPATH('Zip5')};
STRING Zip4{XPATH('Zip4')};
STRING County{XPATH('County')};
STRING PostalCode{XPATH('PostalCode')};
STRING StateCityZip{XPATH('StateCityZip')};
END;

ExpirationDate_layout := RECORD
STRING PassportYear{XPATH('Year')};
STRING PassportMonth{XPATH('Month')};
STRING PassportDay{XPATH('Day')};
END;

passport_layout := RECORD
STRING PassportNumber{XPATH('Number')};
DATASET(ExpirationDate_Layout) PassportExpirationDate{XPATH('ExpirationDate')};
STRING PassportCountry{XPATH('Country')};
STRING PassportMachineReadableLine1{XPATH('MachineReadableLine1')};
STRING PassportMachineReadableLine2{XPATH('MachineReadableLine2')};
END;

CreditCard_Layout := RECORD
STRING Number{XPATH('Number')};
STRING Type{XPATH('Type')};
STRING IssuedBy{XPATH('IssuedBy')};
DATASET(ExpirationDate_Layout) PassportExpirationDate{XPATH('ExpirationDate')};
END;

searchby_layout := RECORD
//FlexID
DATASET(Name_Layout) Name{XPATH('Name')};
DATASET(Address_Layout) Address{XPATH('Address')};
DATASET(DOB_Layout) DOB{XPATH('DOB')};
STRING Age{XPATH('Age')};
STRING SSN{XPATH('SSN')};
STRING SSNLast4{XPATH('SSNLast4')};
STRING DriverLicenseNumber{XPATH('DriverLicenseNumber')};
STRING DriverLicenseState{XPATH('DriverLicenseState')};
STRING IPAddress{XPATH('IPAddress')};
STRING Phone10{XPATH('Phone10')};
STRING HomePhone{XPATH('HomePhone')};
STRING WorkPhone{XPATH('WorkPhone')};
DATASET(Passport_Layout) Passport{XPATH('Passport')};
STRING Gender{XPATH('Gender')};
//Instant ID fcra
STRING Email{XPATH('Email')};
STRING Channel{XPATH('Channel')};
STRING Income{XPATH('Income')};
STRING OwnOrRent{XPATH('OwnOrRent')};
STRING LocationIdentifier{XPATH('LocationIdentifier')};
STRING OtherApplicationIdentifier1{XPATH('OtherApplicationIdentifier1')};
STRING OtherApplicationIdentifier2{XPATH('OtherApplicationIdentifier2')};
STRING OtherApplicationIdentifier3{XPATH('OtherApplicationIdentifier3')};
//BusinessInstantID
STRING CompanyName{XPATH('CompanyName')};
STRING AlternateCompanyName{XPATH('AlternateCompanyName')};
DATASET(companyaddress_layout) CompanyAddress {XPATH('CompanyAddress')};
STRING FEIN{XPATH('FEIN')};
STRING CompanyPhone{XPATH('CompanyPhone')};
DATASET(authorizedrepresentative_layout) AuthorizedRepresentative {XPATH('AuthorizedRepresentative')};
STRING UseDOBFilter{XPATH('UseDOBFilter')};
//FCRAAccountVerificationRequest
DATASET(CreditCard_Layout) CreditCard {XPATH('CreditCard')};
END;

gateways_row_layout := RECORD
	STRING servicename{XPATH('servicename')};
	STRING url{XPATH('url')};
END;

gateways_layout := RECORD
	DATASET(gateways_row_layout) gateways_row {XPATH('row')};
END;

EXPORT rform1 := RECORD
	STRING Product{XPATH('Product')};
	// DATASET(user_layout) user {XPATH('User')};
	// DATASET(options_layout) options {XPATH('Options')};
	// DATASET(SearchBy_layout) SearchBy {XPATH('SearchBy')};
	// RiskWise.RiskWiseMainBC1O
	// DATASET(gateways_layout) gateways {XPATH('gateways')};
	// STRING RemoteLocations{XPATH('RemoteLocations')};
	// STRING _LoginId{XPATH('_LoginId')};
	// STRING _TimeLimit{XPATH('_TimeLimit')};
	// STRING DataRestrictionMask{XPATH('DataRestrictionMask')};
	// STRING account{XPATH('account')};
	// STRING first{XPATH('first')};
	// STRING middleini{XPATH('middleini')};
	// STRING last{XPATH('last')};
	// STRING addr{XPATH('addr')};
	// STRING city{XPATH('city')};
	// STRING state{XPATH('state')};
	// STRING zip{XPATH('zip')};
	// STRING socs{XPATH('socs')};
	// STRING dob{XPATH('dob')};
	// STRING drlc{XPATH('drlc')};
	// STRING drlcstate{XPATH('drlcstate')};
	// STRING wphone{XPATH('wphone')};
	// STRING hphone{XPATH('hphone')};
	// STRING income{XPATH('income')};
	// STRING balance{XPATH('balance')};
	// STRING chargeoffdate{XPATH('chargeoffdate')};
	// STRING cmpy{XPATH('cmpy')};
	// STRING cmpyaddr{XPATH('cmpyaddr')};
	// STRING cmpycity{XPATH('cmpycity')};
	// STRING cmpystate{XPATH('cmpystate')};
	// STRING cmpyzip{XPATH('cmpyzip')};
	// STRING cmpyphone{XPATH('cmpyphone')};
	// STRING fin{XPATH('fin')};
	// STRING appdate{XPATH('appdate')};
	// STRING apptime{XPATH('apptime')};
	// STRING tribcode{XPATH('tribcode')};
	// STRING runSeed{XPATH('runSeed')};
	
END;

END;