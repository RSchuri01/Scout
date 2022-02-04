import scout;
import scout.logs;
import std;
import scout.logs.layout as layout;

EXPORT BUSINESSINSTANTID2_output := MODULE

SHARED infile := scout.logs.files_stg.online_stg_ds : INDEPENDENT;

espName := 'BUSINESSINSTANTID2';

EXPORT mbs_base_slim := scout.logs.util.fn_productXMLcleaner(infile, espName);

SHARED mbs_logs := project(mbs_base_slim, transform(layout.base_transaction,
				SELF.outputxml := '<BUSINESSINSTANTID2><TransactionId>' + LEFT.Transaction_Id + '</TransactionId>' + 
				'<Datetime>' + LEFT.Datetime + '</Datetime>' + LEFT.outputxml + '</BUSINESSINSTANTID2>', self := left, self := []));

SHARED Reclayout := RECORD
 string16 transaction_id;
  string20 datetime;
  string10 field_name;
  string1 numbervalidauthrepsinput;
  Unsigned6 companyseleid;
  string1 vercompanyname;
  string1 vercompanyaddr;
  string1 vercompanycity;
  string1 vercompanystate;
  string1 vercompanyzip;
  string1 vercompanyphone;
  string1 vercompanyfein;
  string2 companybusinessverificationindex;
  string100 companybusinessverificationdesc;
  string2 companypri_code1;
  string2 companypri_code2;
  string2 companypri_code3;
  string2 companypri_code4;
  string2 companypri_code5;
  string2 companypri_code6;
  string2 companypri_code7;
  string2 companypri_code8;
  string50 companyresidentialdesc;
  string50 companyverisummary_type1;
  string1 companyverisummary_index1;
  string100 companyverisummary_desc1;
  string50 companyverisummary_type2;
  string1 companyverisummary_index2;
  string100 companyverisummary_desc2;
  string50 companyverisummary_type3;
  string1 companyverisummary_index3;
  string100 companyverisummary_desc3;
  string50 companyverisummary_type4;
  string1 companyverisummary_index4;
  string100 companyverisummary_desc4;
  string50 companyverisummary_type5;
  string1 companyverisummary_index5;
  string100 companyverisummary_desc5;
  string1 bustoexexindex_rep1;
  string2 bustoexexindex_index1;
  string1 bustoexexindex_rep2;
  string2 bustoexexindex_index2;
  string1 bustoexexindex_rep3;
  string2 bustoexexindex_index3;
  string1 bustoexexindex_rep4;
  string2 bustoexexindex_index4;
  string1 bustoexexindex_rep5;
  string2 bustoexexindex_index5;
  String20 rep1uniqueid;
  string2 rep1cvi;
  string2 rep1nap;
  string2 rep1nas;
  string2 rep1ri_code1;
  string2 rep1ri_code2;
  string2 rep1ri_code3;
  string2 rep1ri_code4;
  string2 rep1ri_code5;
  string2 rep1ri_code6;
  string2 rep1ri_code7;
  string2 rep1ri_code8;
  string2 rep1ri_code9;
  string2 rep1ri_code10;
  String20 rep2uniqueid;
  string2 rep2cvi;
  string2 rep2nap;
  string2 rep2nas;
  string2 rep2ri_code1;
  string2 rep2ri_code2;
  string2 rep2ri_code3;
  string2 rep2ri_code4;
  string2 rep2ri_code5;
  string2 rep2ri_code6;
  string2 rep2ri_code7;
  string2 rep2ri_code8;
  string2 rep2ri_code9;
  string2 rep2ri_code10;
  String20 rep3uniqueid;
  string2 rep3cvi;
  string2 rep3nap;
  string2 rep3nas;
  string2 rep3ri_code1;
  string2 rep3ri_code2;
  string2 rep3ri_code3;
  string2 rep3ri_code4;
  string2 rep3ri_code5;
  string2 rep3ri_code6;
  string2 rep3ri_code7;
  string2 rep3ri_code8;
  string2 rep3ri_code9;
  string2 rep3ri_code10;
  String20 rep4uniqueid;
  string2 rep4cvi;
  string2 rep4nap;
  string2 rep4nas;
  string2 rep4ri_code1;
  string2 rep4ri_code2;
  string2 rep4ri_code3;
  string2 rep4ri_code4;
  string2 rep4ri_code5;
  string2 rep4ri_code6;
  string2 rep4ri_code7;
  string2 rep4ri_code8;
  string2 rep4ri_code9;
  string2 rep4ri_code10;
  String20 rep5uniqueid;
  string2 rep5cvi;
  string2 rep5nap;
  string2 rep5nas;
  string2 rep5ri_code1;
  string2 rep5ri_code2;
  string2 rep5ri_code3;
  string2 rep5ri_code4;
  string2 rep5ri_code5;
  string2 rep5ri_code6;
  string2 rep5ri_code7;
  string2 rep5ri_code8;
  string2 rep5ri_code9;
  string2 rep5ri_code10;




END;

Reclayout  parseoutput() := transform

  SELF.Transaction_ID	:= TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
  SELF.datetime       := TRIM(XMLTEXT('Datetime'));

SELF.numbervalidauthrepsinput := TRIM(XMLTEXT('Result/NumberValidAuthRepsInput'));
SELF.VerCompanyName := TRIM(XMLTEXT('Result/CompanyResults/VerificationIndicators/CompanyName'));
SELF.VerCompanyAddr := TRIM(XMLTEXT('Result/CompanyResults/VerificationIndicators/StreetAddress'));
SELF.VerCompanyCity := TRIM(XMLTEXT('Result/CompanyResults/VerificationIndicators/City'));
SELF.VerCompanyState := TRIM(XMLTEXT('Result/CompanyResults/VerificationIndicators/State'));
SELF.VerCompanyZip := TRIM(XMLTEXT('Result/CompanyResults/VerificationIndicators/Zip'));
SELF.VerCompanyPhone := TRIM(XMLTEXT('Result/CompanyResults/VerificationIndicators/Phone'));
SELF.VerCompanyFEIN := TRIM(XMLTEXT('Result/CompanyResults/VerificationIndicators/FEIN'));
SELF.companybusinessverificationindex := TRIM(XMLTEXT('Result/CompanyResults/BusinessVerification/Index'));
SELF.companybusinessverificationdesc := TRIM(XMLTEXT('Result/CompanyResults/BusinessVerification/Description'));
SELF.companypri_code1 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[1]/RiskCode'));
SELF.companypri_code2 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[2]/RiskCode'));
SELF.companypri_code3 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[3]/RiskCode'));
SELF.companypri_code4 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[4]/RiskCode'));
SELF.companypri_code5 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[5]/RiskCode'));
SELF.companypri_code6 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[6]/RiskCode'));
SELF.companypri_code7 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[7]/RiskCode'));
SELF.companypri_code8 := TRIM(XMLTEXT('Result/CompanyResults/RiskIndicators/RiskIndicator[8]/RiskCode'));
SELF.companyresidentialdesc := TRIM(XMLTEXT('Result/CompanyResults/ResidentialBusinesses/ResidentialBusiness/Description'));
SELF.companyverisummary_type1 := TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[1]/Type'));
SELF.companyverisummary_index1 := TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[1]/Index'));
SELF.companyverisummary_desc1 := TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[1]/Description'));
SELF.companyverisummary_type2 := TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[2]/Type'));
SELF.companyverisummary_index2 := TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[2]/Index'));
SELF.companyverisummary_desc2 := TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[2]/Description'));
SELF.companyverisummary_type3 := TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[3]/Type'));
SELF.companyverisummary_index3 := TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[3]/Index'));
SELF.companyverisummary_desc3 := TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[3]/Description'));
SELF.companyverisummary_type4 := TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[4]/Type'));
SELF.companyverisummary_index4 := TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[4]/Index'));
SELF.companyverisummary_desc4 := TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[4]/Description'));
SELF.companyverisummary_type5 := TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[5]/Type'));
SELF.companyverisummary_index5 := TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[5]/Index'));
SELF.companyverisummary_desc5 := TRIM(XMLTEXT('Result/CompanyResults/VerificationSummaries/VerificationSummary[5]/Description'));
SELF.bustoexexindex_rep1 := TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[1]/InputRepNumber'));
SELF.bustoexexindex_index1 := TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[1]/Index'));
SELF.bustoexexindex_rep2 := TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[2]/InputRepNumber'));
SELF.bustoexexindex_index2 := TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[2]/Index'));
SELF.bustoexexindex_rep3 := TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[3]/InputRepNumber'));
SELF.bustoexexindex_index3 := TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[3]/Index'));
SELF.bustoexexindex_rep4 := TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[4]/InputRepNumber'));
SELF.bustoexexindex_index4 := TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[4]/Index'));
SELF.bustoexexindex_rep5 := TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[5]/InputRepNumber'));
SELF.bustoexexindex_index5 := TRIM(XMLTEXT('Result/CompanyResults/BusinessToAuthorizedRepLinkIndexes/BusinessToAuthorizedRepLinkIndex[5]/Index'));
SELF.rep1cvi := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/ComprehensiveVerificationIndex'));
SELF.rep1nap := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/NameAddressPhoneSummary'));
SELF.rep1nas := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/NameAddressSSNSummary'));
SELF.rep1ri_code1 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[1]/RiskCode'));
SELF.rep1ri_code2 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[2]/RiskCode'));
SELF.rep1ri_code3 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[3]/RiskCode'));
SELF.rep1ri_code4 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[4]/RiskCode'));
SELF.rep1ri_code5 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[5]/RiskCode'));
SELF.rep1ri_code6 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[6]/RiskCode'));
SELF.rep1ri_code7 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[7]/RiskCode'));
SELF.rep1ri_code8 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[8]/RiskCode'));
SELF.rep1ri_code9 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[9]/RiskCode'));
SELF.rep1ri_code10 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[1]/RiskIndicators/RiskIndicator[10]/RiskCode'));
SELF.rep2uniqueid := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/UniqueId'));
SELF.rep2cvi := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/ComprehensiveVerificationIndex'));
SELF.rep2nap := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/NameAddressPhoneSummary'));
SELF.rep2nas := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/NameAddressSSNSummary'));
SELF.rep2ri_code1 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[1]/RiskCode'));
SELF.rep2ri_code2 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[2]/RiskCode'));
SELF.rep2ri_code3 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[3]/RiskCode'));
SELF.rep2ri_code4 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[4]/RiskCode'));
SELF.rep2ri_code5 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[5]/RiskCode'));
SELF.rep2ri_code6 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[6]/RiskCode'));
SELF.rep2ri_code7 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[7]/RiskCode'));
SELF.rep2ri_code8 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[8]/RiskCode'));
SELF.rep2ri_code9 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[9]/RiskCode'));
SELF.rep2ri_code10 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[2]/RiskIndicators/RiskIndicator[10]/RiskCode'));
SELF.rep3uniqueid := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/UniqueId'));
SELF.rep3cvi := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/ComprehensiveVerificationIndex'));
SELF.rep3nap := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/NameAddressPhoneSummary'));
SELF.rep3nas := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/NameAddressSSNSummary'));
SELF.rep3ri_code1 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[1]/RiskCode'));
SELF.rep3ri_code2 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[2]/RiskCode'));
SELF.rep3ri_code3 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[3]/RiskCode'));
SELF.rep3ri_code4 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[4]/RiskCode'));
SELF.rep3ri_code5 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[5]/RiskCode'));
SELF.rep3ri_code6 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[6]/RiskCode'));
SELF.rep3ri_code7 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[7]/RiskCode'));
SELF.rep3ri_code8 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[8]/RiskCode'));
SELF.rep3ri_code9 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[9]/RiskCode'));
SELF.rep3ri_code10 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[3]/RiskIndicators/RiskIndicator[10]/RiskCode'));
SELF.rep4uniqueid := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/UniqueId'));
SELF.rep4cvi := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/ComprehensiveVerificationIndex'));
SELF.rep4nap := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/NameAddressPhoneSummary'));
SELF.rep4nas := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/NameAddressSSNSummary'));
SELF.rep4ri_code1 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[1]/RiskCode'));
SELF.rep4ri_code2 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[2]/RiskCode'));
SELF.rep4ri_code3 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[3]/RiskCode'));
SELF.rep4ri_code4 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[4]/RiskCode'));
SELF.rep4ri_code5 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[5]/RiskCode'));
SELF.rep4ri_code6 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[6]/RiskCode'));
SELF.rep4ri_code7 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[7]/RiskCode'));
SELF.rep4ri_code8 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[8]/RiskCode'));
SELF.rep4ri_code9 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[9]/RiskCode'));
SELF.rep4ri_code10 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[4]/RiskIndicators/RiskIndicator[10]/RiskCode'));
SELF.rep5uniqueid := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/UniqueId'));
SELF.rep5cvi := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/ComprehensiveVerificationIndex'));
SELF.rep5nap := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/NameAddressPhoneSummary'));
SELF.rep5nas := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/NameAddressSSNSummary'));
SELF.rep5ri_code1 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[1]/RiskCode'));
SELF.rep5ri_code2 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[2]/RiskCode'));
SELF.rep5ri_code3 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[3]/RiskCode'));
SELF.rep5ri_code4 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[4]/RiskCode'));
SELF.rep5ri_code5 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[5]/RiskCode'));
SELF.rep5ri_code6 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[6]/RiskCode'));
SELF.rep5ri_code7 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[7]/RiskCode'));
SELF.rep5ri_code8 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[8]/RiskCode'));
SELF.rep5ri_code9 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[9]/RiskCode'));
SELF.rep5ri_code10 := TRIM(XMLTEXT('Result/AuthorizedRepresentativeResults/AuthorizedRepresentativeResult[5]/RiskIndicators/RiskIndicator[10]/RiskCode'));


	self := [];
 
  END;

parsedoutput := PARSE(mbs_logs, outputxml, parseOutput(), XML('BUSINESSINSTANTID2'));

SHARED BUSINESSINSTANTID2 := project(parsedoutput, transform(RecLayout,
					    self := left));

export idxKeyName := scout.common.constants.BUSINESSINSTANTID2_output_keyName;

SHARED subIdxFileName(String pversion) := scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion);

SHARED idxLayout := RECORDOF(BUSINESSINSTANTID2);

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);

export indexDailyStgFile(String pv, boolean isRollupAsked)  := scout.logs.util.fn_buildSubKeyAndAddToSuperKey(INDEX(BUSINESSINSTANTID2(transaction_id <> ''), 
                                 {BUSINESSINSTANTID2.transaction_id, BUSINESSINSTANTID2.datetime}, {BUSINESSINSTANTID2},
										 subIdxFileName(pv)), idxKeyName, subIdxFileName(pv), isRollupAsked);



EXPORT superFileData(Boolean isSuperFor2Years = true) := INDEX(DATASET([],idxLayout), {idxLayout.transaction_id, idxLayout.datetime}, {idxLayout},
				    superFileName(isSuperFor2Years), opt);

SHARED twoyrsOldData := PULL(SUPERFILEDATA(false));

EXPORT rollupBackSuperFileIndex(String pversion, Boolean isRollupOnly = true) := scout.logs.util.fn_rollupSupKeyIndexData(INDEX(twoyrsOldData , 
                                           {twoyrsOldData.transaction_id, twoyrsOldData.datetime}, 
                                           {twoyrsOldData}, 
                                           scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion, true)
                                      ),
								   idxKeyName,
                                   scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion,true),
								   isRollupOnly
                             );

EXPORT fileDateIndexData := INDEX(DATASET([], idxLayout), {idxLayout.transaction_id, idxLayout.datetime}, {idxLayout},
				    			scout.logs.util.fn_getMySuperKeyNameByKeyForDailyBuild(idxKeyName),
							opt)(datetime[1..8] = Scout.logs.files_stg.yesterday);

end;
