﻿/*** Not to be hand edited (changes will be lost on re-generation) ***/
/*** ECL Interface generated by esdl2ecl version 1.0 from share.xml. ***/
/*===================================================*/

import scout.iesp as iesp;

export share := MODULE
			
export t_IntegerArrayItem := record
	integer value { xpath('')};
end;

export t_StringArrayItem := record
	string value {xpath(''), MAXLENGTH(8192) };
end;

export t_ByteArrayItem := record
	INTEGER1 value {xpath('')};
end;

export t_ShortArrayItem := record
	INTEGER2 value {xpath('')};
end;

export t_IntArrayItem := record
	INTEGER4 value {xpath('')};
end;

export t_LongArrayItem := record
	INTEGER8 value {xpath('')};
end;

export t_FloatArrayItem := record
	REAL4 value {xpath('')};
end;

export t_DoubleArrayItem := record
	REAL8 value {xpath('')};
end;

export t_UnsignedArrayItem := record
	UNSIGNED8 value {xpath('')};
end;

export t_Date := record
	integer2 Year {xpath('Year')};
	integer2 Month {xpath('Month')};
	integer2 Day {xpath('Day')};
end;
		
export t_Date2 := record
	string4 Year {xpath('Year')};
	string2 Month {xpath('Month')};
	string2 Day {xpath('Day')};
end;
		
export t_MaskableDate := record
	string4 Year {xpath('Year')};
	string2 Month {xpath('Month')};
	string2 Day {xpath('Day')};
end;
		
export t_DateRange := record
	t_Date StartDate {xpath('StartDate')};
	t_Date EndDate {xpath('EndDate')};
end;
		
export t_TimeStamp := record (t_Date)
	integer2 Hour24 {xpath('Hour24')};
	integer2 Minute {xpath('Minute')};
	integer2 Second {xpath('Second')};
end;
		
export t_Name := record
	string62 Full {xpath('Full')};
	string20 First {xpath('First')};
	string20 Middle {xpath('Middle')};
	string20 Last {xpath('Last')};
	string5 Suffix {xpath('Suffix')};
	string3 Prefix {xpath('Prefix')};
end;
		
export t_NameAndCompany := record (t_Name)
	string120 CompanyName {xpath('CompanyName')};
end;
		
export t_LongName := record
	string Full {xpath('Full')};
	string First {xpath('First')};
	string Middle {xpath('Middle')};
	string Last {xpath('Last')};
	string Suffix {xpath('Suffix')};
	string Prefix {xpath('Prefix')};
end;
		
export t_EndUserInfo := record
	string120 CompanyName {xpath('CompanyName')};
	string200 StreetAddress1 {xpath('StreetAddress1')};
	string25 City {xpath('City')};
	string2 State {xpath('State')};
	string5 Zip5 {xpath('Zip5')};//hidden[!_uk_]
	string10 Phone {xpath('Phone')};
end;
		
export t_User := record
	string50 ReferenceCode {xpath('ReferenceCode')};
	string20 BillingCode {xpath('BillingCode')};
	string50 QueryId {xpath('QueryId')};
	string20 CompanyId {xpath('CompanyId')};//hidden[internal]
	string20 BillingId {xpath('BillingId')};//hidden[internal]
	string2 GLBPurpose {xpath('GLBPurpose')};//hidden[!_uk_]
	string2 DLPurpose {xpath('DLPurpose')};//hidden[!_uk_]
	string20 LoginHistoryId {xpath('LoginHistoryId')};//hidden[internal]
	integer DebitUnits {xpath('DebitUnits')};//hidden[internal]
	string15 IP {xpath('IP')};//hidden[internal]
	string5 IndustryClass {xpath('IndustryClass')};//hidden[internal]
	string3 ResultFormat {xpath('ResultFormat')};//hidden[internal]
	string16 LogAsFunction {xpath('LogAsFunction')};//hidden[internal]
	string16 LogAsSuplFunction {xpath('LogAsSuplFunction')};//hidden[internal]
	string6 SSNMask {xpath('SSNMask')};//hidden[internal]
	string6 DOBMask {xpath('DOBMask')};//hidden[internal]
	boolean ExcludeDMVPII {xpath('ExcludeDMVPII')};//hidden[internal]
	boolean DLMask {xpath('DLMask')};//hidden[internal]
	string DataRestrictionMask {xpath('DataRestrictionMask')};//hidden[internal]
	string50 DataPermissionMask {xpath('DataPermissionMask')};//hidden[internal]
	string20 SourceCode {xpath('SourceCode')};//hidden[internal]
	string32 ApplicationType {xpath('ApplicationType')};//hidden[internal]
	boolean SSNMaskingOn {xpath('SSNMaskingOn')};//hidden[internal]
	boolean DLMaskingOn {xpath('DLMaskingOn')};//hidden[internal]
	boolean LnBranded {xpath('LnBranded')};//hidden[internal]
	t_EndUserInfo EndUser {xpath('EndUser')};
	integer MaxWaitSeconds {xpath('MaxWaitSeconds')};
	string16 RelatedTransactionId {xpath('RelatedTransactionId')};//hidden[internal]
	string20 AccountNumber {xpath('AccountNumber')};
	boolean TestDataEnabled {xpath('TestDataEnabled')};//hidden[ecl_only]
	string32 TestDataTableName {xpath('TestDataTableName')};//hidden[ecl_only]
	boolean OutcomeTrackingOptOut {xpath('OutcomeTrackingOptOut')};//hidden[internal]
	integer NonSubjectSuppression {xpath('NonSubjectSuppression')};//hidden[ecl_only]
	string20 ProductType {xpath('ProductType')};//hidden[internal]
	string11 BatchJobId {xpath('BatchJobId')};//hidden[internal]
	string11 BatchSequenceNumber {xpath('BatchSequenceNumber')};//hidden[internal]
	boolean ArchiveOptIn {xpath('ArchiveOptIn')};//hidden[internal]
	string20 ProcessSpecId {xpath('ProcessSpecId')};//hidden[internal]
	string20 ProductCode {xpath('ProductCode')};//hidden[internal]
	boolean AllowRoamingBypass {xpath('AllowRoamingBypass')};//hidden[internal]
	string5 OutputType {xpath('OutputType')}; //values['','X','B','P','']
end;
		
export t_LoginInfo := record
	string20 LoginHistoryId {xpath('LoginHistoryId')};
	string5 IndustryClass {xpath('IndustryClass')};
	integer DebitUnits {xpath('DebitUnits')};
	string3 ResultFormat {xpath('ResultFormat')};
end;
		
export t_Address := record
	string10 StreetNumber {xpath('StreetNumber')};
	string2 StreetPreDirection {xpath('StreetPreDirection')};
	string28 StreetName {xpath('StreetName')};
	string4 StreetSuffix {xpath('StreetSuffix')};
	string2 StreetPostDirection {xpath('StreetPostDirection')};
	string10 UnitDesignation {xpath('UnitDesignation')};
	string8 UnitNumber {xpath('UnitNumber')};
	string60 StreetAddress1 {xpath('StreetAddress1')};
	string60 StreetAddress2 {xpath('StreetAddress2')};
	string25 City {xpath('City')};
	string2 State {xpath('State')};
	string5 Zip5 {xpath('Zip5')};
	string4 Zip4 {xpath('Zip4')};
	string18 County {xpath('County')};
	string9 PostalCode {xpath('PostalCode')};
	string50 StateCityZip {xpath('StateCityZip')};
	string10 Latitude {xpath('Latitude')};
	string11 Longitude {xpath('Longitude')};
end;
		
export t_UniversalAddress := record (t_Address)
	string30 Country {xpath('Country')};
	string30 Province {xpath('Province')};
	boolean IsForeign {xpath('IsForeign')};
end;
		
export t_AddressWithRawInfo := record (t_Address)
	string OrigStreetAddress1 {xpath('OrigStreetAddress1'), maxlength(128)};
	string OrigStreetAddress2 {xpath('OrigStreetAddress2'), maxlength(128)};
end;
		
export t_UniversalAndRawAddress := record (t_Address)
	string30 Country {xpath('Country')};
	string30 Province {xpath('Province')};
	boolean IsForeign {xpath('IsForeign')};
	string OrigStreetAddress1 {xpath('OrigStreetAddress1'), maxlength(128)};
	string OrigStreetAddress2 {xpath('OrigStreetAddress2'), maxlength(128)};
end;
		
export t_LongAddress := record
	string StreetNumber {xpath('StreetNumber')};
	string StreetPreDirection {xpath('StreetPreDirection')};
	string StreetName {xpath('StreetName')};
	string StreetSuffix {xpath('StreetSuffix')};
	string StreetPostDirection {xpath('StreetPostDirection')};
	string UnitDesignation {xpath('UnitDesignation')};
	string UnitNumber {xpath('UnitNumber')};
	string StreetAddress1 {xpath('StreetAddress1')};
	string StreetAddress2 {xpath('StreetAddress2')};
	string City {xpath('City')};
	string State {xpath('State')};
	string Zip5 {xpath('Zip5')};
	string Zip4 {xpath('Zip4')};
	string County {xpath('County')};
	string PostalCode {xpath('PostalCode')};
	string StateCityZip {xpath('StateCityZip')};
	string Latitude {xpath('Latitude')};
	string Longitude {xpath('Longitude')};
end;
		
export t_RiskIndicator := record
	string4 RiskCode {xpath('RiskCode')};
	string150 Description {xpath('Description')};
end;
		
export t_SequencedRiskIndicator := record (t_RiskIndicator)
	integer Sequence {xpath('Sequence')};
end;
		
export t_ComprehensiveVerificationStruct := record
	integer ComprehensiveVerificationIndex {xpath('ComprehensiveVerificationIndex')};
	dataset(t_SequencedRiskIndicator) RiskIndicators {xpath('RiskIndicators/RiskIndicator'), MAXCOUNT(iesp.Constants.Identifier2c.MaxRiskIndicators)};
	dataset(t_RiskIndicator) PotentialFollowupActions {xpath('PotentialFollowupActions/FollowupAction'), MAXCOUNT(iesp.Constants.FI.MaxCVIRiskIndicators)};
end;
		
export t_CustomComprehensiveVerificationStruct := record (t_ComprehensiveVerificationStruct)
	string128 Name {xpath('Name')};
end;
		
export t_OptionsForCVICalculation := record
	boolean IncludeDOB {xpath('IncludeDOB')};
	boolean IncludeDriverLicense {xpath('IncludeDriverLicense')};
	boolean DisableCustomerNetworkOption {xpath('DisableCustomerNetworkOption')};
end;
		
export t_AddressEx := record (t_Address)
	dataset(t_RiskIndicator) HighRiskIndicators {xpath('HighRiskIndicators/HighRiskIndicator'), MAXCOUNT(iesp.Constants.MaxCountHRI)};
end;
		
export t_NameValuePair := record
	string32 Name {xpath('Name')};
	string Value {xpath('Value'), maxlength(128)};
end;
		
export t_AttributeGroup := record
	string32 Name {xpath('Name')};
	dataset(t_NameValuePair) Attributes {xpath('Attributes/Attribute'), MAXCOUNT(1)};
end;
		
export t_AddressWithType := record (t_Address)
	string60 _Type {xpath('Type')};
end;
		
export t_GeoLocation := record
	string10 Latitude {xpath('Latitude')};
	string11 Longitude {xpath('Longitude')};
end;
		
export t_GeoAddress := record
	t_Address Address {xpath('Address')};
	t_GeoLocation Location {xpath('Location')};
end;
		
export t_AddressWithGeoLocation := record
	string10 StreetNumber {xpath('StreetNumber')};
	string2 StreetPreDirection {xpath('StreetPreDirection')};
	string28 StreetName {xpath('StreetName')};
	string4 StreetSuffix {xpath('StreetSuffix')};
	string2 StreetPostDirection {xpath('StreetPostDirection')};
	string10 UnitDesignation {xpath('UnitDesignation')};
	string8 UnitNumber {xpath('UnitNumber')};
	string60 StreetAddress1 {xpath('StreetAddress1')};
	string60 StreetAddress2 {xpath('StreetAddress2')};
	string25 City {xpath('City')};
	string2 State {xpath('State')};
	string5 Zip5 {xpath('Zip5')};
	string4 Zip4 {xpath('Zip4')};
	string18 County {xpath('County')};
	string9 PostalCode {xpath('PostalCode')};
	string50 StateCityZip {xpath('StateCityZip')};
	string10 Latitude {xpath('Latitude')};
	string11 Longitude {xpath('Longitude')};
end;
		
export t_GeoLocationMatch := record (t_GeoLocation)
	string1 MatchCode {xpath('MatchCode')};
	string50 MatchDesc {xpath('MatchDesc')};
end;
		
export t_GeoAddressMatch := record
	t_Address Address {xpath('Address')};
	t_GeoLocationMatch GeoLocationMatch {xpath('GeoLocationMatch')};
end;
		
export t_RawAddress := record
	dataset(t_StringArrayItem) Lines {xpath('Lines/Line'), MAXCOUNT(3)};
end;
		
export t_AgeRange := record
	integer2 AgeLow {xpath('AgeLow')};
	integer2 AgeHigh {xpath('AgeHigh')};
end;
		
export t_IntRange := record
	integer2 Low {xpath('Low')};
	integer2 High {xpath('High')};
end;
		
// export t_UnsignedShortRange := record
	// unsignedShort Low {xpath('Low')};
	// unsignedShort High {xpath('High')};
// end;
		
export t_StringRange := record
	string Low {xpath('Low')};
	string High {xpath('High')};
end;
		
export t_PhoneTimeZone := record
	string10 Phone10 {xpath('Phone10')};
	string10 Fax {xpath('Fax')};
	string4 TimeZone {xpath('TimeZone')};
end;
		
export t_PhoneInfo := record
	string10 Phone10 {xpath('Phone10')};
	string1 PubNonpub {xpath('PubNonpub')};
	string10 ListingPhone10 {xpath('ListingPhone10')};
	string120 ListingName {xpath('ListingName')};
	string4 TimeZone {xpath('TimeZone')};
	string4 ListingTimeZone {xpath('ListingTimeZone')};
end;
		
export t_PhoneInfoEx := record (t_PhoneInfo)
	dataset(t_StringArrayItem) Messages {xpath('Messages/Message'), MAXCOUNT(iesp.Constants.PhoneInfoMessages)};
	dataset(t_RiskIndicator) HighRiskIndicators {xpath('HighRiskIndicators/HighRiskIndicator'), MAXCOUNT(iesp.Constants.MaxCountHRI)};
end;
		
export t_SSNInfoBase := record
	string9 SSN {xpath('SSN')};
	string5 Valid {xpath('Valid')};
	string32 IssuedLocation {xpath('IssuedLocation')};
	t_Date IssuedStartDate {xpath('IssuedStartDate')};
	t_Date IssuedEndDate {xpath('IssuedEndDate')};
end;
		
export t_SSNInfo := record (t_SSNInfoBase)
	integer FDNSsnInd {xpath('FDNSsnInd')};
end;
		
export t_SSNInfo2 := record (t_SSNInfoBase)
end;
		
export t_SSNInfoEx := record (t_SSNInfo)
	dataset(t_RiskIndicator) HighRiskIndicators {xpath('HighRiskIndicators/HighRiskIndicator'), MAXCOUNT(iesp.Constants.MaxCountHRI)};
end;
		
export t_WsException := record
	string Source {xpath('Source'), maxlength(64)};
	integer Code {xpath('Code')};
	string Location {xpath('Location'), maxlength(64)};
	string256 Message {xpath('Message')};
end;
		
export t_TransactionCap := record
	integer Maximum {xpath('Maximum')};
	integer Count {xpath('Count')};
	boolean AllowAboveMax {xpath('AllowAboveMax')};
end;
		
export t_ResponseHeader := record
	integer Status {xpath('Status')};
	string256 Message {xpath('Message')};
	string50 QueryId {xpath('QueryId')};
	string16 TransactionId {xpath('TransactionId')};
	dataset(t_WsException) Exceptions {xpath('Exceptions/Item'), MAXCOUNT(iesp.Constants.MaxResponseExceptions)};
	t_TransactionCap TransactionCap {xpath('TransactionCap')};//hidden[internal]
end;
		
export t_ServiceParameter := record
	string32 Name {xpath('Name')};
	string Value {xpath('Value'), maxlength(128)};
end;
		
export t_ServiceLocation := record
	string LocationId {xpath('LocationId'), maxlength(256)};
	string ServiceName {xpath('ServiceName'), maxlength(128)};
	dataset(t_ServiceParameter) Parameters {xpath('Parameters/Parameter'), MAXCOUNT(1)};
end;
		
export t_GatewayParams := record
	string16 TxnTransactionId {xpath('TxnTransactionId')};
	integer BatchJobId {xpath('BatchJobId')};
	integer ProcessSpecId {xpath('ProcessSpecId')};
	integer RoyaltyCode {xpath('RoyaltyCode')};
	string50 RoyaltyType {xpath('RoyaltyType')};
	string80 QueryName {xpath('QueryName')};
	boolean CheckVendorGatewayCall {xpath('CheckVendorGatewayCall')};
	boolean MakeVendorGatewayCall {xpath('MakeVendorGatewayCall')};
end;
		
export t_BaseOption := record
	boolean Blind {xpath('Blind')};//hidden[inhouse]
end;
		
export t_BaseSearchOption := record (t_BaseOption)
	boolean StrictMatch {xpath('StrictMatch')};//hidden[internal]
	integer MaxResults {xpath('MaxResults')};//hidden[internal]
end;
		
export t_BaseSearchOptionEx := record (t_BaseSearchOption)
	integer PenaltyThreshold {xpath('PenaltyThreshold')};//hidden[ecl_only]
	boolean UseNicknames {xpath('UseNicknames')};
	boolean IncludeAlsoFound {xpath('IncludeAlsoFound')};
	boolean UsePhonetics {xpath('UsePhonetics')};
end;
		
export t_BaseReportOption := record (t_BaseOption)
end;
		
export t_Identity := record
	string12 UniqueId {xpath('UniqueId')};
	t_Name Name {xpath('Name')};
	string6 Gender {xpath('Gender')};
	t_SSNInfoEx SSNInfoEx {xpath('SSNInfoEx')};
	t_Date DOB {xpath('DOB')};
	t_Date DOD {xpath('DOD')};
	string1 Deceased {xpath('Deceased')}; //values['U','Y','N','']
	integer Age {xpath('Age')};
	integer AgeAtDeath {xpath('AgeAtDeath')};
	string18 DeathCounty {xpath('DeathCounty')};
	string2 DeathState {xpath('DeathState')};
	string1 DeathVerificationCode {xpath('DeathVerificationCode')};
end;
		
export t_DocumentSource := record
	string4 Code {xpath('Code')};
	string32 Name {xpath('Name')};
	string32 Id {xpath('Id')};
end;
		
export t_HRIWarning := record
	string4 Code {xpath('Code')};
	string Message {xpath('Message'), maxlength(256)};
end;
		
export t_SourceSection := record
	string64 Name {xpath('Name')};
	integer Count {xpath('Count')};
	string32 SourceDocId {xpath('SourceDocId')};
	string16 Flag {xpath('Flag')};
end;
		
export t_SectionWithMoreRecords := record
	boolean NameVariations {xpath('NameVariations')};
	boolean AddressVariations {xpath('AddressVariations')};
	boolean PhoneVariations {xpath('PhoneVariations')};
	boolean ParentCompany {xpath('ParentCompany')};
	boolean Sales {xpath('Sales')};
	boolean IndustryInformation {xpath('IndustryInformation')};
	boolean IdNumbers {xpath('IdNumbers')};
	boolean Bankruptcies {xpath('Bankruptcies')};
	boolean BankruptciesV2 {xpath('BankruptciesV2')};
	boolean LiensJudgments {xpath('LiensJudgments')};
	boolean LiensJudgmentsV2 {xpath('LiensJudgmentsV2')};
	boolean ProfileInformation {xpath('ProfileInformation')};
	boolean ProfileInformationV2 {xpath('ProfileInformationV2')};
	boolean BusinessRegistrations {xpath('BusinessRegistrations')};
	boolean RegisteredAgents {xpath('RegisteredAgents')};
	boolean Contacts {xpath('Contacts')};
	boolean Executives {xpath('Executives')};
	boolean Properties {xpath('Properties')};
	boolean PropertiesV2 {xpath('PropertiesV2')};
	boolean MotorVehicles {xpath('MotorVehicles')};
	boolean MotorVehiclesV2 {xpath('MotorVehiclesV2')};
	boolean Watercrafts {xpath('Watercrafts')};
	boolean Aircrafts {xpath('Aircrafts')};
	boolean InternetDomains {xpath('InternetDomains')};
	boolean ProfessionalLicenses {xpath('ProfessionalLicenses')};
	boolean SuperiorLiens {xpath('SuperiorLiens')};
	boolean BusinessAssociates {xpath('BusinessAssociates')};
	boolean ExperianBusinessReports {xpath('ExperianBusinessReports')};
	boolean IRS5500s {xpath('IRS5500s')};
	boolean DunBradstreet {xpath('DunBradstreet')};
end;
		
export t_CodeMap := record
	string8 Code {xpath('Code')};
	string Description {xpath('Description'), maxlength(256)};
end;
		
export t_BooleanSearch := record
	string SearchText {xpath('SearchText'), maxlength(256)};
end;
		
export t_FocusSearch := record
	dataset(t_StringArrayItem) DocIDs {xpath('DocIDs/Item'), MAXCOUNT(1)};
end;
		
export t_BaseSearchBy := record
	t_BooleanSearch BooleanSearch {xpath('BooleanSearch')};
	t_FocusSearch FocusSearch {xpath('FocusSearch')};
end;
		
export t_InfoMessage := record
	string Description {xpath('Description'), maxlength(256)};
	integer MessageNumber {xpath('MessageNumber')};
end;
		
export t_MatchedParty := record
	string1 PartyType {xpath('PartyType')};
	string1 UniqueId {xpath('UniqueId')};
	string64 OriginName {xpath('OriginName')};
	t_Name ParsedParty {xpath('ParsedParty')};
	t_NameAndCompany ParsedParty2 {xpath('ParsedParty2')};
	t_Address Address {xpath('Address')};
end;
		
export t_CompanyVerificationIndicators := record
	boolean CompanyName {xpath('CompanyName')};
	boolean Address {xpath('Address')};
	boolean City {xpath('City')};
	boolean State {xpath('State')};
	boolean Zip {xpath('Zip')};
	boolean Phone10 {xpath('Phone10')};
	boolean _FEIN {xpath('FEIN')};
	boolean Recent {xpath('Recent')};
end;
		
export t_CompanyVerificationData := record
	string120 CompanyName {xpath('CompanyName')};
	t_Address Address {xpath('Address')};
	string10 Phone10 {xpath('Phone10')};
	string9 _FEIN {xpath('FEIN')};
end;
		
export t_CompanyVerification := record
	t_CompanyVerificationIndicators VerifiedIndicators {xpath('VerifiedIndicators')};
	t_CompanyVerificationData VerifiedInputs {xpath('VerifiedInputs')};
end;
		
export t_SourceDocInfo := record
	string32 SourceDocId {xpath('SourceDocId')};
	string2 _Type {xpath('Type')};
	integer _Count {xpath('Count')};
end;
		
export t_SourceInfo := record
	string Code {xpath('Code')};
	string Name {xpath('Name')};
end;
		
export t_SourceCounts := record
	integer Ids {xpath('Ids')};
	integer Types {xpath('Types')};
	integer Docs {xpath('Docs')};
end;
		
export t_Time := record
	integer2 Hour {xpath('Hour')};
	integer2 Minute {xpath('Minute')};
	integer2 Second {xpath('Second')};
end;
		
export t_Duration := record
	integer2 Years {xpath('Years')};
	integer2 Months {xpath('Months')};
	integer2 Days {xpath('Days')};
end;
		
export t_Duration2 := record
	string4 Years {xpath('Years')};
	string2 Months {xpath('Months')};
	string6 Days {xpath('Days')};
end;
		
export t_NameWithGender := record (t_Name)
	string Gender {xpath('Gender')};
end;
		
export t_BusinessIdentity := record
	unsigned6 DotID {xpath('DotID')}; // Xsd type: long
	unsigned6 EmpID {xpath('EmpID')}; // Xsd type: long
	unsigned6 POWID {xpath('POWID')}; // Xsd type: long
	unsigned6 ProxID {xpath('ProxID')}; // Xsd type: long
	unsigned6 SeleID {xpath('SeleID')}; // Xsd type: long
	unsigned6 OrgID {xpath('OrgID')}; // Xsd type: long
	unsigned6 UltID {xpath('UltID')}; // Xsd type: long
end;
		
export t_CriminalIndicators := record
	boolean HasCriminalConviction {xpath('HasCriminalConviction')};//hidden[internal]
	boolean IsSexualOffender {xpath('IsSexualOffender')};//hidden[internal]
end;
		
export t_ElapsedYears := record
	integer2 From {xpath('From')};
	integer2 To {xpath('To')};
end;
		
export t_RelationshipOption := record
	boolean HighConfidenceRelatives {xpath('HighConfidenceRelatives')};
	boolean HighConfidenceAssociates {xpath('HighConfidenceAssociates')};
	integer RelativeLookBackMonths {xpath('RelativeLookBackMonths')};
	string24 TransactionalAssociatesMask {xpath('TransactionalAssociatesMask')};
end;
		
export t_BaseRequest := record
	t_User User {xpath('User')};
	dataset(t_StringArrayItem) RemoteLocations {xpath('RemoteLocations/Item'), MAXCOUNT(1)};//hidden[internal]
	dataset(t_ServiceLocation) ServiceLocations {xpath('ServiceLocations/ServiceLocation'), MAXCOUNT(1)};//hidden[internal]
end;
		
export t_BaseResponse := record
	t_ResponseHeader _Header {xpath('Header')};
end;
		

end;

/*** Not to be hand edited (changes will be lost on re-generation) ***/
/*** ECL Interface generated by esdl2ecl version 1.0 from share.xml. ***/
/*===================================================*/

