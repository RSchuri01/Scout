EXPORT Layouts_OutputXML := MODULE

enduser_layout := record
	STRING CompanyName{XPATH('CompanyName')};
	STRING StreetAddress1{XPATH('StreetAddress1')};
	STRING City{XPATH('City')};
	STRING State{XPATH('State')};
	STRING Zip5{XPATH('Zip5')};
END;

user_layout := record
	STRING TransactionId{XPATH('TransactionId')};
	STRING Status{XPATH('Status')};
	STRING ReferenceCode{XPATH('ReferenceCode')};
	STRING BillingCode{XPATH('BillingCode')};
	STRING QueryID{XPATH('QueryId')};
	STRING GLBPurpose{XPATH('GLBPurpose')};
	STRING DLPurpose{XPATH('DLPurpose')};
	DATASET(enduser_layout) EndUser{XPATH('EndUser')};
	STRING MaxWaitSeconds{XPATH('MaxWaitSeconds')};
	STRING AccountNumber{XPATH('AccountNumber')};
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

Name_Layout := RECORD
	STRING Full{XPATH('Full')};
	STRING First{XPATH('First')};
	STRING Middle{XPATH('Middle')};
	STRING Last{XPATH('Last')};
	STRING Suffix{XPATH('Suffix')};
	STRING Prefix{XPATH('Prefix')};
	STRING FirstNameMatch{XPATH('FirstNameMatch')};
	STRING MiddleInitialMatch{XPATH('MiddleInitialMatch')};
	STRING LastNameMatch{XPATH('LastNameMatch')};
	STRING SuffixMatch{XPATH('SuffixMatch')};

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

InputEcho_layout := record
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
	//BusinessInstantID
	STRING CompanyName{XPATH('CompanyName')};
	STRING AlternateCompanyName{XPATH('AlternateCompanyName')};
	DATASET(companyaddress_layout) CompanyAddress {XPATH('CompanyAddress')};
	STRING FEIN{XPATH('FEIN')};
	STRING CompanyPhone{XPATH('CompanyPhone')};
	DATASET(authorizedrepresentative_layout) AuthorizedRepresentative {XPATH('AuthorizedRepresentative')};
	STRING UseDOBFilter{XPATH('UseDOBFilter')};
	//InstantID
	STRING Channel{XPATH('Channel')};
	STRING OwnOrRent{XPATH('OwnOrRent')};

END;

NameAddressPhone_layout := RECORD
	STRING Summary{XPATH('Summary')};
END;

VerifiedElementSummary_layout := RECORD
	STRING DOB{XPATH('DOB')};
	STRING DOBMatchLevel{XPATH('DOBMatchLevel')}; 
	STRING DL{XPATH('DL')};
END;

ValidElementSummary_layout := RECORD
	STRING SSNValid{XPATH('SSNValid')};
	STRING SSNDeceased{XPATH('SSNDeceased')};
	STRING PassportValid{XPATH('PassportValid')};
END;

CVIHighRiskIndicator_Layout := RECORD
	STRING RiskCode{XPATH('RiskCode')};
	STRING Description{XPATH('Description')};
	STRING Sequence{XPATH('Sequence')};

END;

CVIHighRiskIndicators_Layout := RECORD
	DATASET(CVIHighRiskIndicator_Layout) CVIHighRiskIndicator{XPATH('CVIHighRiskIndicator')};
END;

// address_layout := RECORD
// STRING StreetNumber{XPATH('StreetNumber')};
// STRING StreetPreDirection{XPATH('StreetPreDirection')};
// STRING StreetName{XPATH('StreetName')};
// STRING StreetSuffix{XPATH('StreetSuffix')};
// STRING StreetPostDirection{XPATH('StreetPostDirection')};
// STRING UnitDesignation{XPATH('UnitDesignation')};
// STRING UnitNumber{XPATH('UnitNumber')};
// STRING StreetAddress1{XPATH('StreetAddress1')};
// STRING StreetAddress2{XPATH('StreetAddress2')};
// STRING City{XPATH('City')};
// STRING State{XPATH('State')};
// STRING Zip5{XPATH('Zip5')};
// STRING Zip4{XPATH('Zip4')};
// STRING County{XPATH('County')};
// STRING PostalCode{XPATH('PostalCode')};
// STRING StateCityZip{XPATH('StateCityZip')};
// END;

FEINMatchResult_Layout := RECORD
	STRING CompanyName {XPATH('CompanyName')};
	DATASET(address_layout) address {XPATH('Address')};
END;

FEINMatchResults_Layout := RECORD
	DATASET(FEINMatchResult_layout) FEINMatchResult {XPATH('FEINMatchResult')};
END;

DateFirstSeen_layout := RECORD
	STRING Year{XPATH('Year')};
	STRING Month{XPATH('Month')};
END;

InputCorrected_layout := RECORD
	STRING CompanyName{XPATH('CompanyName')};
	DATASET(name_layout) Name {XPATH('Name')};
	STRING FEIN{XPATH('FEIN')};
	STRING SSN{XPATH('SSN')};
	STRING Phone10{XPATH('Phone10')};
	DATASET(address_layout) Address {XPATH('Address')};
	DATASET(DateFirstSeen_layout) DateFirstSeen {XPATH('DateFirstSeen')};
END;

NameAddressOfPhone_layout := RECORD
	STRING CompanyName{XPATH('CompanyName')};
	DATASET(address_layout) Address {XPATH('Address')};
END;

YYYYMMDD_layout := RECORD
	STRING Year{XPATH('Year')};
	STRING Month{XPATH('Month')};
	STRING Day{XPATH('Day')};
END;

RecentLienNameAddress_layout := RECORD 
	STRING CompanyName {XPATH('CompanyName')};
	DATASET(Address_layout) Address {XPATH('Address')};
END;

RiskIndicator_layout := RECORD
	STRING RiskCode {XPATH('RiskCode')};
	STRING Description {XPATH('Description')};
	STRING Sequence {XPATH('Sequence')};
END;

RiskIndicators_layout := RECORD
	DATASET(RiskIndicator_layout) RiskIndicator {XPATH('RiskIndicator')};
END;

VerifiedInput_Layout := RECORD
	STRING CompanyName{XPATH('CompanyName')};
	DATASET(Name_Layout) Name {XPATH('Name')};
	STRING Phone10{XPATH('Phone10')};
	STRING FEIN{XPATH('FEIN')};
	DATASET(address_layout) Address {XPATH('Address')};
END;

VerificationIndicators_Layout := RECORD
	STRING CompanyName{XPATH('CompanyName')};
	STRING address {XPATH('Address')};
	STRING State {XPATH('State')};
	STRING Phone10{XPATH('Phone10')};
	STRING FEIN{XPATH('FEIN')};
	STRING SSN{XPATH('SSN')};
	STRING Name{XPATH('Name')};

END;

CompanyResults_Layout := RECORD
	STRING NameAddressPhoneIndicator {XPATH('NameAddressPhoneIndicator')};
	STRING NameAddressFEINIndicator {XPATH('NameAddressFEINIndicator')};
	STRING NameAddressSSNIndicator {XPATH('NameAddressSSNIndicator')};
	STRING BusinessVerificationIndicator {XPATH('BusinessVerificationIndicator')};
	STRING PhoneType {XPATH('PhoneType')};
	STRING BankruptcyCount {XPATH('BankruptcyCount')};
	STRING RecentLienType {XPATH('RecentLienType')};
	DATASET(FEINMatchResults_layout) FEINMatchResults {XPATH('FEINMatchResults')};
	DATASET(InputCorrected_layout) InputCorrected {XPATH('InputCorrected')};
	DATASET(NameAddressOfPhone_layout) NameAddressOfPhone {XPATH('NameAddressOfPhone')};
	STRING BusinessId {XPATH('BusinessId')};
	DATASET(YYYYMMDD_layout) RecentLienFilingDate{XPATH('RecentLienFilingDate')};
	STRING UnreleasedLienCounter {XPATH('UnreleasedLienCounter')};
	STRING SICCode {XPATH('SICCode')};
	STRING BusinessDescription {XPATH('BusinessDescription')};
	STRING SOSFilingName {XPATH('SOSFilingName')};
	DATASET(RecentLienNameAddress_layout) RecentLienNameAddress{XPATH('RecentLienNameAddress')}; 
	DATASET(RiskIndicators_layout) RiskIndicators {XPATH('RiskIndicators')};
	DATASET(VerifiedInput_Layout) VerifiedInput {XPATH('VerifiedInput')};
	DATASET(VerificationIndicators_Layout) VerificationIndicators {XPATH('VerificationIndicators')};
END;

HighRiskIndicator_Layout := RECORD
	STRING Description{XPATH('Description')};
	STRING RiskCode{XPATH('RiskCode')};
 	STRING Sequence{XPATH('Sequence')};
END;

HighRiskIndicators_Layout := RECORD
	DATASET(HighRiskIndicator_Layout) HighRiskIndicator{XPATH('HighRiskIndicator')};
END;

WarningCodeIndicator_Layout := RECORD
	STRING WarningCode{XPATH('WarningCode')};
	STRING Description{XPATH('Description')};
 	STRING Sequence{XPATH('Sequence')};
END;

WarningCodeIndicators_Layout := RECORD
	DATASET(WarningCodeIndicator_Layout) WarningCodeIndicator{XPATH('WarningCodeIndicator')};
END;

Score_Layout := RECORD
	STRING Value{XPATH('Value')};
	STRING Type{XPATH('Type')};
	DATASET(RiskIndicators_Layout) RiskIndicators{XPATH('RiskIndicators')};
	DATASET(HighRiskIndicators_Layout) HighRiskIndicators{XPATH('HighRiskIndicators')};
	DATASET(WarningCodeIndicators_Layout) WarningCodeIndicators{XPATH('WarningCodeIndicators')};
END;

Scores_Layout := RECORD
	DATASET(Score_Layout) Score{XPATH('Score')};
END;

Model_Layout := RECORD
	STRING Name{XPATH('Name')};
	DATASET(Scores_Layout) Scores{XPATH('Scores')};
END;

Models_Layout := RECORD
	DATASET(Model_Layout) Model{XPATH('Model')};
END;

Attribute_Layout := RECORD
	STRING Name{XPATH('Name')};
	STRING Value{XPATH('Value')};
END;

Attributes_Layout := RECORD
	DATASET(Attribute_Layout) Attribute{XPATH('Attribute')};
END;

FollowupAction_Layout := RECORD
	STRING Action{XPATH('Action')};
	STRING RiskCode{XPATH('RiskCode')};
	STRING Description{XPATH('Description')};
END;

FollowupActions_Layout := RECORD
	DATASET(FollowupAction_Layout) FollowupAction{XPATH('FollowupAction')};
END;

AddressPhone_Layout := Record
	STRING IsBestAddress {XPATH('IsBestAddress')};
	DATASET(Address_Layout) Address{XPATH('Address')};
	DATASET(DateFirstSeen_layout) DateLastSeen {XPATH('DateLastSeen')};
END;

IssuedStartDate_Layout := RECORD
	DATASET(YYYYMMDD_layout) IssuedStartDate {XPATH('IssuedStartDate')};
END;

IssuedEndDate_Layout := RECORD
	DATASET(YYYYMMDD_layout) IssuedEndDate {XPATH('IssuedEndDate')};
END;

SSNInfo_Layout := RECORD
	STRING Valid {XPATH('Valid')};
	STRING IssuedLocation {XPATH('IssuedLocation')};
	DATASET(YYYYMMDD_Layout) IssuedStartDate {XPATH('IssuedStartDate')};
	DATASET(YYYYMMDD_Layout) IssuedEndDate {XPATH('IssuedEndDate')};
END;

AlternateAddressPhones_layout := RECORD
	DATASET(AddressPhone_Layout) AddressPhone {XPATH('AddressPhone')};
END;

authorizedrepresentativeresults_layout := RECORD
	STRING NameAddressSSNSummary{XPATH('NameAddressSSNSummary')};
	STRING NameAddressPhoneSummary{XPATH('NameAddressPhoneSummary')};
	STRING ComprehensiveVerificationIndex{XPATH('ComprehensiveVerificationIndex')};
	STRING AreaCodeSplitFlag{XPATH('AreaCodeSplitFlag')};
	STRING PhoneOfNameAddress{XPATH('PhoneOfNameAddress')};
	DATASET(FollowupActions_Layout) FollowupActions{XPATH('FollowupActions')};
	DATASET(InputCorrected_layout) InputCorrected {XPATH('InputCorrected')};
	DATASET(AlternateAddressPhones_layout) AlternateAddressPhones {XPATH('AlternateAddressPhones')};
	DATASET(AddressPhone_Layout) AddressPhone {XPATH('AddressPhone')};
	DATASET(VerificationIndicators_Layout) VerificationIndicators {XPATH('VerificationIndicators')};
	DATASET(SSNInfo_Layout) SSNInfo {XPATH('SSNInfo')};
	DATASET(RiskIndicators_Layout) RiskIndicators {XPATH('RiskIndicators')};
	DATASET(VerifiedInput_Layout) VerifiedInput {XPATH('VerifiedInput')};
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

PotentialFollowupActions_Layout := RECORD
	DATASET(FollowupAction_Layout) FollowupAction{XPATH('FollowupAction')};
END;

Result_layout := RECORD
	DATASET(InputEcho_layout) InputEcho {XPATH('InputEcho')};
	DATASET(NameAddressPhone_layout) NameAddressPhone {XPATH('NameAddressPhone')};
	DATASET(VerifiedElementSummary_layout) VerifiedElementSummary {XPATH('VerifiedElementSummary')};
	DATASET(ValidElementSummary_layout) ValidElementSummary {XPATH('ValidElementSummary')};
	STRING NameAddressSSNSummary{XPATH('NameAddressSSNSummary')};
	STRING ComprehensiveVerificationIndex{XPATH('ComprehensiveVerificationIndex')};
	DATASET(CVIHighRiskIndicators_Layout) CVIHighRiskIndicators {XPATH('CVIHighRiskIndicators')};
	//BusinessInstantID
	STRING AuthorizedRepresentativeRelationshipToCompany{XPATH('AuthorizedRepresentativeRelationshipToCompany')};
	DATASET(CompanyResults_Layout) CompanyResults{XPATH('CompanyResults')};
	DATASET(Models_Layout) Models{XPATH('Models')};
	STRING DistHomeAddressToBusinessAddress{XPATH('DistHomeAddressToBusinessAddress')};
	STRING DistHomePhoneToBusinessAddress{XPATH('DistHomePhoneToBusinessAddress')};
	STRING DistHomeAddressToBusinessPhone{XPATH('DistHomeAddressToBusinessPhone')};
	STRING DistHomePhoneToHomeAddress{XPATH('DistHomePhoneToHomeAddress')};
	STRING DistBusinessPhoneToBusinessAddress{XPATH('DistBusinessPhoneToBusinessAddress')};
	DATASET(Attributes_Layout) Attributes{XPATH('Attributes')};
	DATASET(authorizedrepresentativeresults_layout) AuthorizedRepresentativeResults {XPATH('AuthorizedRepresentativeResults')};
	//FRAUDPOINT
	STRING UniqueId{XPATH('UniqueId')};
	STRING AdditionalScore1{XPATH('AdditionalScore1')};
	STRING AdditionalScore2{XPATH('AdditionalScore2')};
	DATASET(RedFlagsReport_Layout) RedFlagsReport{XPATH('RedFlagsReport')};
	STRING PassportValidated{XPATH('PassportValidated')};
	STRING DOBMatchLevel{XPATH('DOBMatchLevel')};
	DATASET(WatchLists_Layout) WatchLists{XPATH('WatchLists')};
	STRING DOBVerified{XPATH('DOBVerified')};
	DATASET(PotentialFollowupActions_Layout) PotentialFollowupActions{XPATH('PotentialFollowupActions')};
	DATASET(RiskIndicators_Layout) RiskIndicators{XPATH('RiskIndicators')};
END;

Row_Layout := RECORD
	STRING acctno {XPATH('acctno')};
	STRING account {XPATH('account')};
	STRING riskwiseid {XPATH('riskwiseid')};
	STRING firstcount {XPATH('firstcount')};
	STRING lastcount {XPATH('lastcount')};
	STRING addrcount {XPATH('addrcount')};
	STRING phonecount {XPATH('phonecount')};
	STRING socscount {XPATH('socscount')};
	STRING socsverlevel {XPATH('socsverlevel')};
	STRING dobcount {XPATH('dobcount')};
	STRING drlccount {XPATH('drlccount')};
	STRING cmpycount {XPATH('cmpycount')};
	STRING cmpyaddrcount {XPATH('cmpyaddrcount')};
	STRING cmpyphonecount {XPATH('cmpyphonecount')};
	STRING fincount {XPATH('fincount')};
	STRING emailcount {XPATH('emailcount')};
	STRING verfirst {XPATH('verfirst')};
	STRING verlast {XPATH('verlast')};
	STRING veraddr {XPATH('veraddr')};
	STRING vercity {XPATH('vercity')};
	STRING verstate {XPATH('verstate')};
	STRING verzip {XPATH('verzip')};
	STRING verhphone {XPATH('verhphone')};
	STRING versocs {XPATH('versocs')};
	STRING verdrlc {XPATH('verdrlc')};
	STRING verdob {XPATH('verdob')};
	STRING vercmpy {XPATH('vercmpy')};
	STRING vercmpyaddr {XPATH('vercmpyaddr')};
	STRING vercmpycity {XPATH('vercmpycity')};
	STRING vercmpystate {XPATH('vercmpystate')};
	STRING vercmpyzip {XPATH('vercmpyzip')};
	STRING vercmpyphone {XPATH('vercmpyphone')};
	STRING verfin {XPATH('verfin')};
	STRING numelever {XPATH('numelever')};
	STRING numsource {XPATH('numsource')};
	STRING numcmpyelever {XPATH('numcmpyelever')};
	STRING numcmpysource {XPATH('numcmpysource')};
	STRING firstscore {XPATH('firstscore')};
	STRING lastscore {XPATH('lastscore')};
	STRING cmpyscore {XPATH('cmpyscore')};
	STRING addrscore {XPATH('addrscore')};
	STRING phonescore {XPATH('phonescore')};
	STRING socscore {XPATH('socscore')};
	STRING dobscore {XPATH('dobscore')};
	STRING drlcscore {XPATH('drlcscore')};
	STRING cmpyscore2 {XPATH('cmpyscore2')};
	STRING cmpyaddrscore {XPATH('cmpyaddrscore')};
	STRING cmpyphonescore {XPATH('cmpyphonescore')};
	STRING finscore {XPATH('finscore')};
	STRING emailscore {XPATH('emailscore')};
	STRING wphonename {XPATH('wphonename')};
	STRING wphoneaddr {XPATH('wphoneaddr')};
	STRING wphonecity {XPATH('wphonecity')};
	STRING wphonestate {XPATH('wphonestate')};
	STRING wphonezip {XPATH('wphonezip')};
	STRING socsmiskeyflag {XPATH('socsmiskeyflag')};
	STRING phonemiskeyflag {XPATH('phonemiskeyflag')};
	STRING addrmiskeyflag {XPATH('addrmiskeyflag')};
	STRING idtheftflag {XPATH('idtheftflag')};
	STRING hphonetypeflag {XPATH('hphonetypeflag')};
	STRING hphonesrvc {XPATH('hphonesrvc')};
	STRING hphone2addrtypeflag {XPATH('hphone2addrtypeflag')};
	STRING hphone2typeflag {XPATH('hphone2typeflag')};
	STRING wphonetypeflag {XPATH('wphonetypeflag')};
	STRING wphonesrvc {XPATH('wphonesrvc')};
	STRING areacodesplitflag {XPATH('areacodesplitflag')};
	STRING altareacode {XPATH('altareacode')};
	STRING phonezipflag {XPATH('phonezipflag')};
	STRING socsdob {XPATH('socsdob')};
	STRING hhriskphoneflag {XPATH('hhriskphoneflag')};
	STRING hriskcmpy {XPATH('hriskcmpy')};
	STRING sic {XPATH('sic')};
	STRING zipclassflag {XPATH('zipclassflag')};
	STRING zipname {XPATH('zipname')};
	STRING medincome {XPATH('medincome')};
	STRING addrriskflag {XPATH('addrriskflag')};
	STRING bansflag {XPATH('bansflag')};
	STRING bansdatefiled {XPATH('bansdatefiled')};
	STRING addrvalflag {XPATH('addrvalflag')};
	STRING addrreason {XPATH('addrreason')};
	STRING lowissue {XPATH('lowissue')};
	STRING dwelltypeflag {XPATH('dwelltypeflag')};
	STRING phonedissflag {XPATH('phonedissflag')};
	STRING ecovariables {XPATH('ecovariables')};
	STRING tcifull {XPATH('tcifull')};
	STRING tcilast {XPATH('tcilast')};
	STRING tciaddr {XPATH('tciaddr')};
	STRING hriskphoneflag {XPATH('hriskphoneflag')};
	STRING phonevalflag {XPATH('phonevalflag')};
	STRING hriskaddrflag {XPATH('hriskaddrflag')};
	STRING decsflag {XPATH('decsflag')};
	STRING socsdobflag {XPATH('socsdobflag')};
	STRING socsvalflag {XPATH('socsvalflag')};
	STRING drlcvalflag {XPATH('drlcvalflag')};
	STRING frdriskscore {XPATH('frdriskscore')};
	STRING splitdate {XPATH('splitdate')};
	STRING cassaddr {XPATH('cassaddr')};
	STRING casscity {XPATH('casscity')};
	STRING cassstate {XPATH('cassstate')};
	STRING casszip {XPATH('casszip')};
	STRING coaalertflag {XPATH('coaalertflag')};
	STRING coafirst {XPATH('coafirst')};
	STRING coalast {XPATH('coalast')};
	STRING coaaddr {XPATH('coaaddr')};
	STRING coacity {XPATH('coacity')};
	STRING coastate {XPATH('coastate')};
	STRING coazip {XPATH('coazip')};
	STRING aptscanflag {XPATH('aptscanflag')};
	STRING addrhistoryflag {XPATH('addrhistoryflag')};
	STRING formerlastcount {XPATH('formerlastcount')};
	STRING hphonecount {XPATH('hphonecount')};
	STRING wphonecount {XPATH('wphonecount')};
	STRING verwphone {XPATH('verwphone')};
	STRING veremail {XPATH('veremail')};
	STRING hphonescore {XPATH('hphonescore')};
	STRING wphonescore {XPATH('wphonescore')};
	STRING socsscore {XPATH('socsscore')};
	STRING dlnmscore {XPATH('dlnmscore')};
	STRING hphonemiskeyflag {XPATH('hphonemiskeyflag')};
	STRING hrisksic {XPATH('hrisksic')};
	STRING hriskaddr {XPATH('hriskaddr')};
	STRING hriskcity {XPATH('hriskcity')};
	STRING hriskstate {XPATH('hriskstate')};
	STRING hriskzip {XPATH('hriskzip')};
	STRING disthphoneaddr {XPATH('disthphoneaddr')};
	STRING disthphonewphone {XPATH('disthphonewphone')};
	STRING distwphoneaddr {XPATH('distwphoneaddr')};
	STRING estincome {XPATH('estincome')};
	STRING numfraud {XPATH('numfraud')};
	STRING first {XPATH('first')};
	STRING last {XPATH('last')};
	STRING addr {XPATH('addr')};
	STRING city {XPATH('city')};
	STRING state {XPATH('state')};
	STRING zip {XPATH('zip')};
	STRING first2 {XPATH('first2')};
	STRING last2 {XPATH('last2')};
	STRING addr2 {XPATH('addr2')};
	STRING city2 {XPATH('city2')};
	STRING state2 {XPATH('state2')};
	STRING zip2 {XPATH('zip2')};	

END;

Dataset_layout := RECORD
	DATASET(Row_Layout) Row {XPATH('Row')};
END;

AccountVerification_layout := RECORD
	STRING AccountNumber{XPATH('AccountNumber')};
	STRING AccountNumberFlags{XPATH('AccountNumberFlags')};
	STRING LostStolenClosed{XPATH('LostStolenClosed')};
END;

Hit_layout := RECORD
	STRING Code{XPATH('Code')};
	STRING Description{XPATH('Description')};
END;


ControlHeader_layout := RECORD
	STRING MessageId{XPATH('MessageId')};
	STRING InterConnectTransactionId{XPATH('InterConnectTransactionId')};
	STRING InterConnectInteractionId{XPATH('InterConnectInteractionId')};
	STRING ConfigurationVersionNumber{XPATH('ConfigurationVersionNumber')};
END;

response_layout := RECORD
	STRING ReportDate{XPATH('ReportDate')};
	STRING AddressDiscrepancy{XPATH('AddressDiscrepancy')};
	DATASET(AccountVerification_layout) AccountVerification {XPATH('AccountVerification')};
	DATASET(Hit_layout) Hit {XPATH('Hit')};
	DATASET(Hit_layout) FraudVictimIndicator {XPATH('FraudVictimIndicator')};
	DATASET(Name_layout) Name {XPATH('Name')};
	DATASET(user_layout) Header {XPATH('Header')};
	DATASET(ControlHeader_layout) ControlHeader {XPATH('ControlHeader')};
END;

EfxAccountVerificationResponseEx_Layout := RECORD
	DATASET(response_layout) response {XPATH('response')};
END;

EXPORT rform1 := RECORD
	STRING Product{XPATH('Product')};
	// DATASET(user_layout) user {XPATH('Header')};
	// DATASET(Result_layout) Result {XPATH('Result')};
	// DATASET(Dataset_layout) Dataset {XPATH('Dataset')};
	// DATASET(EfxAccountVerificationResponseEx_Layout) EfxAccountVerificationResponseEx {XPATH('EfxAccountVerificationResponseEx')};

END;

END;