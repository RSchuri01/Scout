EXPORT Layouts_OutputXML_Intermediate := MODULE

EXPORT shell_input_layout := RECORD
	STRING seq {XPATH('seq')};
	STRING did {XPATH('did')};
	STRING score {XPATH('score')};
	STRING fname {XPATH('fname')};
	STRING lname {XPATH('lname')};
	STRING in_streetaddress {XPATH('in_streetaddress')};
	STRING in_city {XPATH('in_city')};
	STRING in_state {XPATH('in_state')};
	STRING in_zipcode {XPATH('in_zipcode')};
	STRING prim_range {XPATH('prim_range')};
	STRING prim_name {XPATH('prim_name')};
	STRING addr_suffix {XPATH('addr_suffix')};
	STRING p_city_name {XPATH('p_city_name')};
	STRING st {XPATH('st')};
	STRING z5 {XPATH('z5')};
	STRING zip4 {XPATH('zip4')};
	STRING lat {XPATH('lat')};
	STRING long {XPATH('long')};
	STRING county {XPATH('county')};
	STRING geo_blk {XPATH('geo_blk')};
	STRING addr_type {XPATH('addr_type')};
	STRING addr_status {XPATH('addr_status')};
	STRING ssn {XPATH('ssn')};
	STRING age {XPATH('age')};
	STRING phone10 {XPATH('phone10')};
END;

EXPORT iid_layout := RECORD
STRING nas_summary {XPATH('nas_summary')};
STRING nap_summary {XPATH('nap_summary')};
STRING cvi {XPATH('cvi')};
STRING reason1 {XPATH('reason1')};
STRING reason2 {XPATH('reason2')};
STRING reason3 {XPATH('reason3')};
STRING reason4 {XPATH('reason4')};
STRING didcount {XPATH('didcount')};
STRING did2 {XPATH('did2')};
STRING did3 {XPATH('did3')};
STRING did2_sources {XPATH('did2_sources')};
STRING did2_fnamesources {XPATH('did2_fnamesources')};
STRING did2_addrsources {XPATH('did2_addrsources')};
STRING did2_creditfirstseen {XPATH('did2_creditfirstseen')};
STRING did2_creditlastseen {XPATH('did2_creditlastseen')};
STRING did2_headerfirstseen {XPATH('did2_headerfirstseen')};
STRING did2_headerlastseen {XPATH('did2_headerlastseen')};
STRING did2_criminal_count {XPATH('did2_criminal_count')};
STRING did2_felony_count {XPATH('did2_felony_count')};
STRING did2_liens_recent_unreleased_count {XPATH('did2_liens_recent_unreleased_count')};
STRING did2_liens_historical_unreleased_count {XPATH('did2_liens_historical_unreleased_count')};
STRING did2_liens_recent_released_count {XPATH('did2_liens_recent_released_count')};
STRING did2_liens_historical_released_count {XPATH('did2_liens_historical_released_count')};
STRING did3_creditfirstseen {XPATH('did3_creditfirstseen')};
STRING did3_creditlastseen {XPATH('did3_creditlastseen')};
STRING did3_headerfirstseen {XPATH('did3_headerfirstseen')};
STRING did3_headerlastseen {XPATH('did3_headerlastseen')};
STRING did3_criminal_count {XPATH('did3_criminal_count')};
STRING did3_felony_count {XPATH('did3_felony_count')};
STRING did3_liens_recent_unreleased_count {XPATH('did3_liens_recent_unreleased_count')};
STRING did3_liens_historical_unreleased_count {XPATH('did3_liens_historical_unreleased_count')};
STRING did3_liens_recent_released_count {XPATH('did3_liens_recent_released_count')};
STRING did3_liens_historical_released_count {XPATH('did3_liens_historical_released_count')};
STRING non_us_ssn {XPATH('non_us_ssn')};
STRING hriskphoneflag {XPATH('hriskphoneflag')};
STRING hphonetypeflag {XPATH('hphonetypeflag')};
STRING wphonetypeflag {XPATH('wphonetypeflag')};
STRING phonevalflag {XPATH('phonevalflag')};
STRING hphonevalflag {XPATH('hphonevalflag')};
STRING wphonevalflag {XPATH('wphonevalflag')};
STRING phonezipflag {XPATH('phonezipflag')};
STRING pwphonezipflag {XPATH('pwphonezipflag')};
STRING phonedissflag {XPATH('phonedissflag')};
STRING wphonedissflag {XPATH('wphonedissflag')};
STRING phoneverlevel {XPATH('phoneverlevel')};
STRING phonever_type {XPATH('phonever_type')};
STRING hriskaddrflag {XPATH('hriskaddrflag')};
STRING decsflag {XPATH('decsflag')};
STRING socsdobflag {XPATH('socsdobflag')};
STRING pwsocsdobflag {XPATH('pwsocsdobflag')};
STRING socsvalflag {XPATH('socsvalflag')};
STRING pwsocsvalflag {XPATH('pwsocsvalflag')};
STRING socsrcisflag {XPATH('socsrcisflag')};
STRING socllowissue {XPATH('socllowissue')};
STRING soclhighissue {XPATH('soclhighissue')};
STRING soclstate {XPATH('soclstate')};
STRING socsverlevel {XPATH('socsverlevel')};
STRING areacodesplitflag {XPATH('areacodesplitflag')};
STRING reverse_areacodesplitflag {XPATH('reverse_areacodesplitflag')};
STRING addrvalflag {XPATH('addrvalflag')};
STRING bansflag {XPATH('bansflag')};
STRING sources {XPATH('sources')};
STRING firstcount {XPATH('firstcount')};
STRING lastcount {XPATH('lastcount')};
STRING addrcount {XPATH('addrcount')};
STRING wphonecount {XPATH('wphonecount')};
STRING socscount {XPATH('socscount')};
STRING numelever {XPATH('numelever')};
STRING phonefirstcount {XPATH('phonefirstcount')};
STRING phonelastcount {XPATH('phonelastcount')};
STRING phoneaddrcount {XPATH('phoneaddrcount')};
STRING phonephonecount {XPATH('phonephonecount')};
STRING phoneaddr_firstcount {XPATH('phoneaddr_firstcount')};
STRING phoneaddr_lastcount {XPATH('phoneaddr_lastcount')};
STRING phoneaddr_addrcount {XPATH('phoneaddr_addrcount')};
STRING phoneaddr_phonecount {XPATH('phoneaddr_phonecount')};
STRING utiliaddr_lastcount {XPATH('utiliaddr_lastcount')};
STRING utiliaddr_addrcount {XPATH('utiliaddr_addrcount')};
STRING utiliaddr_phonecount {XPATH('utiliaddr_phonecount')};
STRING verfirst {XPATH('verfirst')};
STRING verlast {XPATH('verlast')};
STRING socsmiskeyflag {XPATH('socsmiskeyflag')};
STRING hphonemiskeyflag {XPATH('hphonemiskeyflag')};
STRING addrmiskeyflag {XPATH('addrmiskeyflag')};
STRING addrcommflag {XPATH('addrcommflag')};
STRING disthphoneaddr {XPATH('disthphoneaddr')};
STRING disthphonewphone {XPATH('disthphonewphone')};
STRING distwphoneaddr {XPATH('distwphoneaddr')};
STRING dirsaddr_phone {XPATH('dirsaddr_phone')};
STRING dirsaddr_lastscore {XPATH('dirsaddr_lastscore')};
STRING phonetype {XPATH('phonetype')};
STRING ziptypeflag {XPATH('ziptypeflag')};
STRING drlcvalflag {XPATH('drlcvalflag')};
STRING drlcgender {XPATH('drlcgender')};
STRING statezipflag {XPATH('statezipflag')};
STRING cityzipflag {XPATH('cityzipflag')};
STRING chronoprim_range {XPATH('chronoprim_range')};
STRING chronoprim_name {XPATH('chronoprim_name')};
STRING chronosuffix {XPATH('chronosuffix')};
STRING chronocity {XPATH('chronocity')};
STRING chronostate {XPATH('chronostate')};
STRING chronozip {XPATH('chronozip')};
STRING chronoactivephone {XPATH('chronoactivephone')};
STRING chronomatchlevel {XPATH('chronomatchlevel')};
STRING chrono_sources {XPATH('chrono_sources')};
STRING chrono_addr_flags {XPATH('chrono_addr_flags')};
STRING chronoactivephone2 {XPATH('chronoactivephone2')};
STRING chronomatchlevel2 {XPATH('chronomatchlevel2')};
STRING chrono_addr_flags2 {XPATH('chrono_addr_flags2')};
STRING chronoactivephone3 {XPATH('chronoactivephone3')};
STRING chronomatchlevel3 {XPATH('chronomatchlevel3')};
STRING chrono_addr_flags3 {XPATH('chrono_addr_flags3')};
STRING chronodate_first {XPATH('chronodate_first')};
STRING chronodate_first2 {XPATH('chronodate_first2')};
STRING chronodate_first3 {XPATH('chronodate_first3')};
STRING altlastpop {XPATH('altlastpop')};
STRING altlast2pop {XPATH('altlast2pop')};
STRING lastssnmatch {XPATH('lastssnmatch')};
STRING lastssnmatch2 {XPATH('lastssnmatch2')};
STRING firstssnmatch {XPATH('firstssnmatch')};
STRING ssnexists {XPATH('ssnexists')};
STRING combo_first {XPATH('combo_first')};
STRING combo_last {XPATH('combo_last')};
STRING combo_prim_range {XPATH('combo_prim_range')};
STRING combo_prim_name {XPATH('combo_prim_name')};
STRING combo_suffix {XPATH('combo_suffix')};
STRING combo_city {XPATH('combo_city')};
STRING combo_state {XPATH('combo_state')};
STRING combo_zip {XPATH('combo_zip')};
STRING combo_ssn {XPATH('combo_ssn')};
STRING combo_firstscore {XPATH('combo_firstscore')};
STRING combo_lastscore {XPATH('combo_lastscore')};
STRING combo_addrscore {XPATH('combo_addrscore')};
STRING combo_sec_rangescore {XPATH('combo_sec_rangescore')};
STRING combo_hphonescore {XPATH('combo_hphonescore')};
STRING combo_ssnscore {XPATH('combo_ssnscore')};
STRING combo_dobscore {XPATH('combo_dobscore')};
STRING combo_cmpyscore {XPATH('combo_cmpyscore')};
STRING combo_firstcount {XPATH('combo_firstcount')};
STRING combo_lastcount {XPATH('combo_lastcount')};
STRING combo_addrcount {XPATH('combo_addrcount')};
STRING combo_hphonecount {XPATH('combo_hphonecount')};
STRING combo_ssncount {XPATH('combo_ssncount')};
STRING combo_dobcount {XPATH('combo_dobcount')};
STRING combo_cmpycount {XPATH('combo_cmpycount')};
STRING watchlisthit {XPATH('watchlisthit')};
STRING name_addr_phone {XPATH('name_addr_phone')};
STRING inputaddrnotmostrecent {XPATH('inputaddrnotmostrecent')};
STRING publish_code {XPATH('publish_code')};
STRING iid_flags {XPATH('iid_flags')};
STRING dl_searched {XPATH('dl_searched')};
STRING any_dl_found {XPATH('any_dl_found')};
STRING dl_exists {XPATH('dl_exists')};
STRING dl_score {XPATH('dl_score')};
END;

EXPORT source_verification_layout := RECORD
STRING eq_count {XPATH('eq_count')};
STRING en_count {XPATH('en_count')};
STRING tu_count {XPATH('tu_count')};
STRING dl_count {XPATH('dl_count')};
STRING pr_count {XPATH('pr_count')};
STRING v_count {XPATH('v_count')};
STRING em_count {XPATH('em_count')};
STRING vo_count {XPATH('vo_count')};
STRING w_count {XPATH('w_count')};
STRING em_only_count {XPATH('em_only_count')};
STRING adl_eqfs_first_seen {XPATH('adl_eqfs_first_seen')};
STRING adl_en_first_seen {XPATH('adl_en_first_seen')};
STRING adl_tu_first_seen {XPATH('adl_tu_first_seen')};
STRING adl_dl_first_seen {XPATH('adl_dl_first_seen')};
STRING adl_pr_first_seen {XPATH('adl_pr_first_seen')};
STRING adl_v_first_seen {XPATH('adl_v_first_seen')};
STRING adl_em_first_seen {XPATH('adl_em_first_seen')};
STRING adl_vo_first_seen {XPATH('adl_vo_first_seen')};
STRING adl_em_only_first_seen {XPATH('adl_em_only_first_seen')};
STRING adl_w_first_seen {XPATH('adl_w_first_seen')};
STRING adl_eqfs_last_seen {XPATH('adl_eqfs_last_seen')};
STRING adl_en_last_seen {XPATH('adl_en_last_seen')};
STRING adl_tu_last_seen {XPATH('adl_tu_last_seen')};
STRING adl_dl_last_seen {XPATH('adl_dl_last_seen')};
STRING adl_pr_last_seen {XPATH('adl_pr_last_seen')};
STRING adl_v_last_seen {XPATH('adl_v_last_seen')};
STRING adl_em_last_seen {XPATH('adl_em_last_seen')};
STRING adl_vo_last_seen {XPATH('adl_vo_last_seen')};
STRING adl_em_only_last_seen {XPATH('adl_em_only_last_seen')};
STRING adl_w_last_seen {XPATH('adl_w_last_seen')};
STRING firstnamesources {XPATH('firstnamesources')};
STRING lastnamesources {XPATH('lastnamesources')};
STRING addrsources {XPATH('addrsources')};
STRING socssources {XPATH('socssources')};
STRING num_nonderogs {XPATH('num_nonderogs')};
STRING num_nonderogs30 {XPATH('num_nonderogs30')};
STRING num_nonderogs90 {XPATH('num_nonderogs90')};
STRING num_nonderogs180 {XPATH('num_nonderogs180')};
STRING num_nonderogs12 {XPATH('num_nonderogs12')};
STRING num_nonderogs24 {XPATH('num_nonderogs24')};
STRING num_nonderogs36 {XPATH('num_nonderogs36')};
STRING num_nonderogs60 {XPATH('num_nonderogs60')};
END;

EXPORT available_sources_layout := RECORD
STRING dl {XPATH('dl')};
STRING voter {XPATH('voter')};
END;

EXPORT input_validation_layout := RECORD
STRING firstname {XPATH('firstname')};
STRING lastname {XPATH('lastname')};
STRING address {XPATH('address')};
STRING ssn {XPATH('ssn')};
STRING ssn_length {XPATH('ssn_length')};
STRING dateofbirth {XPATH('dateofbirth')};
STRING email {XPATH('email')};
STRING ipaddress {XPATH('ipaddress')};
STRING homephone {XPATH('homephone')};
STRING workphone {XPATH('workphone')};
END;

EXPORT address_validation_layout := RECORD
STRING usps_deliverable {XPATH('usps_deliverable')};
STRING zip_type {XPATH('zip_type')};
STRING hr_address {XPATH('hr_address')};
STRING error_codes {XPATH('error_codes')};
STRING corrections {XPATH('corrections')};
END;

EXPORT name_verification_layout := RECORD
STRING adl_score {XPATH('adl_score')};
STRING fname_score {XPATH('fname_score')};
STRING lname_score {XPATH('lname_score')};
STRING lname_change_date {XPATH('lname_change_date')};
STRING lname_prev_change_date {XPATH('lname_prev_change_date')};
STRING source_count {XPATH('source_count')};
STRING fname_credit_sourced {XPATH('fname_credit_sourced')};
STRING lname_credit_sourced {XPATH('lname_credit_sourced')};
STRING fname_tu_sourced {XPATH('fname_tu_sourced')};
STRING lname_tu_sourced {XPATH('lname_tu_sourced')};
STRING fname_eda_sourced {XPATH('fname_eda_sourced')};
STRING lname_eda_sourced {XPATH('lname_eda_sourced')};
STRING fname_dl_sourced {XPATH('fname_dl_sourced')};
STRING lname_dl_sourced {XPATH('lname_dl_sourced')};
STRING fname_voter_sourced {XPATH('fname_voter_sourced')};
STRING lname_voter_sourced {XPATH('lname_voter_sourced')};
STRING fname_utility_sourced {XPATH('fname_utility_sourced')};
STRING lname_utility_sourced {XPATH('lname_utility_sourced')};
STRING age {XPATH('age')};
STRING dob_score {XPATH('dob_score')};
STRING newest_lname_dt_first_seen {XPATH('newest_lname_dt_first_seen')};
END;

EXPORT utility_layout := RECORD
STRING utili_adl_count {XPATH('utili_adl_count')};
STRING utili_adl_nap {XPATH('utili_adl_nap')};
STRING utili_addr1_nap {XPATH('utili_addr1_nap')};
STRING utili_addr2_nap {XPATH('utili_addr2_nap')};
END;

EXPORT input_address_information_layout := RECORD
STRING address_score {XPATH('address_score')};
STRING house_number_match {XPATH('house_number_match')};
STRING isbestmatch {XPATH('isbestmatch')};
STRING unit_count {XPATH('unit_count')};
STRING geo12_fc_index {XPATH('geo12_fc_index')};
STRING geo11_fc_index {XPATH('geo11_fc_index')};
STRING fips_fc_index {XPATH('fips_fc_index')};
STRING source_count {XPATH('source_count')};
STRING credit_sourced {XPATH('credit_sourced')};
STRING eda_sourced {XPATH('eda_sourced')};
STRING dl_sourced {XPATH('dl_sourced')};
STRING voter_sourced {XPATH('voter_sourced')};
STRING utility_sourced {XPATH('utility_sourced')};
STRING applicant_owned {XPATH('applicant_owned')};
STRING occupant_owned {XPATH('occupant_owned')};
STRING family_owned {XPATH('family_owned')};
STRING family_sold {XPATH('family_sold')};
STRING applicant_sold {XPATH('applicant_sold')};
STRING family_sale_found {XPATH('family_sale_found')};
STRING family_buy_found {XPATH('family_buy_found')};
STRING applicant_sale_found {XPATH('applicant_sale_found')};
STRING applicant_buy_found {XPATH('applicant_buy_found')};
STRING naprop {XPATH('naprop')};
STRING purchase_date {XPATH('purchase_date')};
STRING built_date {XPATH('built_date')};
STRING purchase_amount {XPATH('purchase_amount')};
STRING mortgage_amount {XPATH('mortgage_amount')};
STRING mortgage_date {XPATH('mortgage_date')};
STRING assessed_amount {XPATH('assessed_amount')};
STRING assessed_total_value {XPATH('assessed_total_value')};
STRING date_first_seen {XPATH('date_first_seen')};
STRING date_last_seen {XPATH('date_last_seen')};
STRING standardized_land_use_code {XPATH('standardized_land_use_code')};
STRING building_area {XPATH('building_area')};
STRING no_of_buildings {XPATH('no_of_buildings')};
STRING no_of_stories {XPATH('no_of_stories')};
STRING no_of_rooms {XPATH('no_of_rooms')};
STRING no_of_bedrooms {XPATH('no_of_bedrooms')};
STRING no_of_baths {XPATH('no_of_baths')};
STRING no_of_partial_baths {XPATH('no_of_partial_baths')};
STRING garage_type_code {XPATH('garage_type_code')};
STRING parking_no_of_cars {XPATH('parking_no_of_cars')};
STRING assessed_value_year {XPATH('assessed_value_year')};
STRING hr_address {XPATH('hr_address')};
STRING prim_range {XPATH('prim_range')};
STRING prim_name {XPATH('prim_name')};
STRING addr_suffix {XPATH('addr_suffix')};
STRING city_name {XPATH('city_name')};
STRING st {XPATH('st')};
STRING zip5 {XPATH('zip5')};
STRING county {XPATH('county')};
STRING geo_blk {XPATH('geo_blk')};
STRING full_match {XPATH('full_match')};
END;

EXPORT owned_layout := RECORD
// STRING property_count {XPATH('property_count')};
STRING property_total {XPATH('property_total')};
STRING property_owned_purchase_total {XPATH('property_owned_purchase_total')};
STRING property_owned_purchase_count {XPATH('property_owned_purchase_count')};
STRING property_owned_assessed_total {XPATH('property_owned_assessed_total')};
STRING property_owned_assessed_count {XPATH('property_owned_assessed_count')};
END;

EXPORT sold_layout := RECORD
STRING property_total {XPATH('property_total')};
STRING property_owned_purchase_total {XPATH('property_owned_purchase_total')};
STRING property_owned_purchase_count {XPATH('property_owned_purchase_count')};
STRING property_owned_assessed_total {XPATH('property_owned_assessed_total')};
STRING property_owned_assessed_count {XPATH('property_owned_assessed_count')};
END;

EXPORT ambiguous_layout := RECORD
STRING property_total {XPATH('property_total')};
STRING property_owned_purchase_total {XPATH('property_owned_purchase_total')};
STRING property_owned_purchase_count {XPATH('property_owned_purchase_count')};
STRING property_owned_assessed_total {XPATH('property_owned_assessed_total')};
STRING property_owned_assessed_count {XPATH('property_owned_assessed_count')};
END;

EXPORT recent_property_sales_layout := RECORD
STRING sale_price1 {XPATH('sale_price1')};
STRING sale_date1 {XPATH('sale_date1')};
STRING prev_purch_price1 {XPATH('prev_purch_price1')};
STRING prev_purch_date1 {XPATH('prev_purch_date1')};
STRING sale_price2 {XPATH('sale_price2')};
STRING sale_date2 {XPATH('sale_date2')};
STRING prev_purch_price2 {XPATH('prev_purch_price2')};
STRING prev_purch_date2 {XPATH('prev_purch_date2')};
END;

EXPORT address_history_1_layout := RECORD
STRING address_score {XPATH('address_score')};
STRING house_number_match {XPATH('house_number_match')};
STRING isbestmatch {XPATH('isbestmatch')};
STRING unit_count {XPATH('unit_count')};
STRING geo12_fc_index {XPATH('geo12_fc_index')};
STRING geo11_fc_index {XPATH('geo11_fc_index')};
STRING fips_fc_index {XPATH('fips_fc_index')};
STRING source_count {XPATH('source_count')};
STRING credit_sourced {XPATH('credit_sourced')};
STRING eda_sourced {XPATH('eda_sourced')};
STRING dl_sourced {XPATH('dl_sourced')};
STRING voter_sourced {XPATH('voter_sourced')};
STRING utility_sourced {XPATH('utility_sourced')};
STRING applicant_owned {XPATH('applicant_owned')};
STRING occupant_owned {XPATH('occupant_owned')};
STRING family_owned {XPATH('family_owned')};
STRING family_sold {XPATH('family_sold')};
STRING applicant_sold {XPATH('applicant_sold')};
STRING family_sale_found {XPATH('family_sale_found')};
STRING family_buy_found {XPATH('family_buy_found')};
STRING applicant_sale_found {XPATH('applicant_sale_found')};
STRING applicant_buy_found {XPATH('applicant_buy_found')};
STRING naprop {XPATH('naprop')};
STRING purchase_date {XPATH('purchase_date')};
STRING built_date {XPATH('built_date')};
STRING purchase_amount {XPATH('purchase_amount')};
STRING mortgage_amount {XPATH('mortgage_amount')};
STRING mortgage_date {XPATH('mortgage_date')};
STRING assessed_amount {XPATH('assessed_amount')};
STRING assessed_total_value {XPATH('assessed_total_value')};
STRING date_first_seen {XPATH('date_first_seen')};
STRING date_last_seen {XPATH('date_last_seen')};
STRING building_area {XPATH('building_area')};
STRING no_of_buildings {XPATH('no_of_buildings')};
STRING no_of_stories {XPATH('no_of_stories')};
STRING no_of_rooms {XPATH('no_of_rooms')};
STRING no_of_bedrooms {XPATH('no_of_bedrooms')};
STRING no_of_baths {XPATH('no_of_baths')};
STRING no_of_partial_baths {XPATH('no_of_partial_baths')};
STRING parking_no_of_cars {XPATH('parking_no_of_cars')};
STRING hr_address {XPATH('hr_address')};
STRING full_match {XPATH('full_match')};
END;

EXPORT address_history_2_layout := RECORD
STRING address_score {XPATH('address_score')};
STRING house_number_match {XPATH('house_number_match')};
STRING isbestmatch {XPATH('isbestmatch')};
STRING unit_count {XPATH('unit_count')};
STRING geo12_fc_index {XPATH('geo12_fc_index')};
STRING geo11_fc_index {XPATH('geo11_fc_index')};
STRING fips_fc_index {XPATH('fips_fc_index')};
STRING source_count {XPATH('source_count')};
STRING credit_sourced {XPATH('credit_sourced')};
STRING eda_sourced {XPATH('eda_sourced')};
STRING dl_sourced {XPATH('dl_sourced')};
STRING voter_sourced {XPATH('voter_sourced')};
STRING utility_sourced {XPATH('utility_sourced')};
STRING applicant_owned {XPATH('applicant_owned')};
STRING occupant_owned {XPATH('occupant_owned')};
STRING family_owned {XPATH('family_owned')};
STRING family_sold {XPATH('family_sold')};
STRING applicant_sold {XPATH('applicant_sold')};
STRING family_sale_found {XPATH('family_sale_found')};
STRING family_buy_found {XPATH('family_buy_found')};
STRING applicant_sale_found {XPATH('applicant_sale_found')};
STRING applicant_buy_found {XPATH('applicant_buy_found')};
STRING naprop {XPATH('naprop')};
STRING purchase_date {XPATH('purchase_date')};
STRING built_date {XPATH('built_date')};
STRING purchase_amount {XPATH('purchase_amount')};
STRING mortgage_amount {XPATH('mortgage_amount')};
STRING mortgage_date {XPATH('mortgage_date')};
STRING assessed_amount {XPATH('assessed_amount')};
STRING assessed_total_value {XPATH('assessed_total_value')};
STRING date_first_seen {XPATH('date_first_seen')};
STRING date_last_seen {XPATH('date_last_seen')};
STRING building_area {XPATH('building_area')};
STRING no_of_buildings {XPATH('no_of_buildings')};
STRING no_of_stories {XPATH('no_of_stories')};
STRING no_of_rooms {XPATH('no_of_rooms')};
STRING no_of_bedrooms {XPATH('no_of_bedrooms')};
STRING no_of_baths {XPATH('no_of_baths')};
STRING no_of_partial_baths {XPATH('no_of_partial_baths')};
STRING parking_no_of_cars {XPATH('parking_no_of_cars')};
STRING hr_address {XPATH('hr_address')};
STRING full_match {XPATH('full_match')};
END;

EXPORT address_verification_layout := RECORD
DATASET(input_address_information_layout) input_address_information {XPATH('input_address_information')};
DATASET(owned_layout) owned {XPATH('owned')};
DATASET(sold_layout) sold {XPATH('sold')};
DATASET(ambiguous_layout) ambiguous {XPATH('ambiguous')};
DATASET(recent_property_sales_layout) recent_property_sales {XPATH('recent_property_sales')};
STRING distance_in_2_h1 {XPATH('distance_in_2_h1')};
STRING distance_in_2_h2 {XPATH('distance_in_2_h2')};
STRING distance_h1_2_h2 {XPATH('distance_h1_2_h2')};
STRING addr1addr2score {XPATH('addr1addr2score')};
STRING addr1addr3score {XPATH('addr1addr3score')};
STRING addr2addr3score {XPATH('addr2addr3score')};
STRING edamatchlevel {XPATH('edamatchlevel')};
STRING activephone {XPATH('activephone')};
STRING edamatchlevel2 {XPATH('edamatchlevel2')};
STRING activephone2 {XPATH('activephone2')};
STRING edamatchlevel3 {XPATH('edamatchlevel3')};
STRING activephone3 {XPATH('activephone3')};
DATASET(address_history_1_layout) address_history_1 {XPATH('address_history_1')};
DATASET(address_history_2_layout) address_history_2 {XPATH('address_history_2')};
STRING addr_flags_1 {XPATH('addr_flags_1')};
STRING addr_flags_2 {XPATH('addr_flags_2')};
END;

EXPORT other_address_info_layout := RECORD
STRING max_lres {XPATH('max_lres')};
STRING avg_lres {XPATH('avg_lres')};
STRING addrs_last_5years {XPATH('addrs_last_5years')};
STRING addrs_last_10years {XPATH('addrs_last_10years')};
STRING addrs_last_15years {XPATH('addrs_last_15years')};
STRING isprison {XPATH('isprison')};
STRING hist1_isprison {XPATH('hist1_isprison')};
STRING hist2_isprison {XPATH('hist2_isprison')};
STRING addrs_last30 {XPATH('addrs_last30')};
STRING addrs_last90 {XPATH('addrs_last90')};
STRING addrs_last12 {XPATH('addrs_last12')};
STRING addrs_last24 {XPATH('addrs_last24')};
STRING addrs_last36 {XPATH('addrs_last36')};
STRING date_first_purchase {XPATH('date_first_purchase')};
STRING date_most_recent_purchase {XPATH('date_most_recent_purchase')};
STRING num_purchase30 {XPATH('num_purchase30')};
STRING num_purchase90 {XPATH('num_purchase90')};
STRING num_purchase180 {XPATH('num_purchase180')};
STRING num_purchase12 {XPATH('num_purchase12')};
STRING num_purchase24 {XPATH('num_purchase24')};
STRING num_purchase36 {XPATH('num_purchase36')};
STRING num_purchase60 {XPATH('num_purchase60')};
STRING date_most_recent_sale {XPATH('date_most_recent_sale')};
STRING num_sold30 {XPATH('num_sold30')};
STRING num_sold90 {XPATH('num_sold90')};
STRING num_sold180 {XPATH('num_sold180')};
STRING num_sold12 {XPATH('num_sold12')};
STRING num_sold24 {XPATH('num_sold24')};
STRING num_sold36 {XPATH('num_sold36')};
STRING num_sold60 {XPATH('num_sold60')};
END;

EXPORT gong_did_layout := RECORD
STRING gong_adl_dt_first_seen_full {XPATH('gong_adl_dt_first_seen_full')};
STRING gong_adl_dt_last_seen_full {XPATH('gong_adl_dt_last_seen_full')};
STRING gong_did_phone_ct {XPATH('gong_did_phone_ct')};
STRING gong_did_addr_ct {XPATH('gong_did_addr_ct')};
STRING gong_did_first_ct {XPATH('gong_did_first_ct')};
STRING gong_did_last_ct {XPATH('gong_did_last_ct')};
END;

EXPORT phone_verification_layout := RECORD
STRING phone_score {XPATH('phone_score')};
STRING telcordia_type {XPATH('telcordia_type')};
STRING phone_zip_mismatch {XPATH('phone_zip_mismatch')};
STRING distance {XPATH('distance')};
STRING disconnected {XPATH('disconnected')};
STRING recent_disconnects {XPATH('recent_disconnects')};
STRING hr_phone {XPATH('hr_phone')};
STRING corrections {XPATH('corrections')};
DATASET(gong_did_layout) gong_did {XPATH('gong_did')};
END;

EXPORT validation_layout := RECORD
STRING deceased {XPATH('deceased')};
STRING deceaseddate {XPATH('deceaseddate')};
STRING valid {XPATH('valid')};
STRING issued {XPATH('issued')};
STRING high_issue_date {XPATH('high_issue_date')};
STRING low_issue_date {XPATH('low_issue_date')};
STRING issue_state {XPATH('issue_state')};
STRING dob_mismatch {XPATH('dob_mismatch')};
STRING inputsocscharflag {XPATH('inputsocscharflag')};
STRING inputsocscode {XPATH('inputsocscode')};
END;

EXPORT ssn_verification_layout := RECORD
STRING ssn_score {XPATH('ssn_score')};
STRING nameperssn_count {XPATH('nameperssn_count')};
STRING adlperssn_count {XPATH('adlperssn_count')};
STRING credit_sourced {XPATH('credit_sourced')};
STRING credit_first_seen {XPATH('credit_first_seen')};
STRING credit_last_seen {XPATH('credit_last_seen')};
STRING header_count {XPATH('header_count')};
STRING header_first_seen {XPATH('header_first_seen')};
STRING header_last_seen {XPATH('header_last_seen')};
STRING tu_sourced {XPATH('tu_sourced')};
STRING voter_sourced {XPATH('voter_sourced')};
STRING utility_sourced {XPATH('utility_sourced')};
STRING bk_sourced {XPATH('bk_sourced')};
STRING other_sourced {XPATH('other_sourced')};
DATASET(validation_layout) validation {XPATH('validation')};
END;

EXPORT velocity_counters_layout := RECORD
STRING ssns_per_adl {XPATH('ssns_per_adl')};
STRING addrs_per_adl {XPATH('addrs_per_adl')};
STRING phones_per_adl {XPATH('phones_per_adl')};
STRING dobs_per_adl {XPATH('dobs_per_adl')};
STRING ssns_per_adl_created_6months {XPATH('ssns_per_adl_created_6months')};
STRING addrs_per_adl_created_6months {XPATH('addrs_per_adl_created_6months')};
STRING phones_per_adl_created_6months {XPATH('phones_per_adl_created_6months')};
STRING dobs_per_adl_created_6months {XPATH('dobs_per_adl_created_6months')};
STRING ssns_per_adl_seen_18months {XPATH('ssns_per_adl_seen_18months')};
STRING ssns_per_adl_multiple_use {XPATH('ssns_per_adl_multiple_use')};
STRING ssns_per_adl_multiple_use_non_relative {XPATH('ssns_per_adl_multiple_use_non_relative')};
STRING lnames_per_adl {XPATH('lnames_per_adl')};
STRING lnames_per_adl30 {XPATH('lnames_per_adl30')};
STRING lnames_per_adl90 {XPATH('lnames_per_adl90')};
STRING lnames_per_adl180 {XPATH('lnames_per_adl180')};
STRING lnames_per_adl12 {XPATH('lnames_per_adl12')};
STRING lnames_per_adl24 {XPATH('lnames_per_adl24')};
STRING lnames_per_adl36 {XPATH('lnames_per_adl36')};
STRING lnames_per_adl60 {XPATH('lnames_per_adl60')};
STRING invalid_ssns_per_adl {XPATH('invalid_ssns_per_adl')};
STRING invalid_phones_per_adl {XPATH('invalid_phones_per_adl')};
STRING invalid_addrs_per_adl {XPATH('invalid_addrs_per_adl')};
STRING invalid_ssns_per_adl_created_6months {XPATH('invalid_ssns_per_adl_created_6months')};
STRING invalid_phones_per_adl_created_6months {XPATH('invalid_phones_per_adl_created_6months')};
STRING invalid_addrs_per_adl_created_6months {XPATH('invalid_addrs_per_adl_created_6months')};
STRING dl_addrs_per_adl {XPATH('dl_addrs_per_adl')};
STRING vo_addrs_per_adl {XPATH('vo_addrs_per_adl')};
STRING pl_addrs_per_adl {XPATH('pl_addrs_per_adl')};
STRING addrs_per_ssn {XPATH('addrs_per_ssn')};
STRING adls_per_ssn_created_6months {XPATH('adls_per_ssn_created_6months')};
STRING addrs_per_ssn_created_6months {XPATH('addrs_per_ssn_created_6months')};
STRING adls_per_ssn_seen_18months {XPATH('adls_per_ssn_seen_18months')};
STRING lnames_per_ssn {XPATH('lnames_per_ssn')};
STRING lnames_per_ssn_created_6months {XPATH('lnames_per_ssn_created_6months')};
STRING addrs_per_ssn_multiple_use {XPATH('addrs_per_ssn_multiple_use')};
STRING adls_per_ssn_multiple_use {XPATH('adls_per_ssn_multiple_use')};
STRING adls_per_ssn_multiple_use_non_relative {XPATH('adls_per_ssn_multiple_use_non_relative')};
STRING adls_per_addr {XPATH('adls_per_addr')};
STRING ssns_per_addr {XPATH('ssns_per_addr')};
STRING phones_per_addr {XPATH('phones_per_addr')};
STRING adls_per_addr_created_6months {XPATH('adls_per_addr_created_6months')};
STRING ssns_per_addr_created_6months {XPATH('ssns_per_addr_created_6months')};
STRING phones_per_addr_created_6months {XPATH('phones_per_addr_created_6months')};
STRING adls_per_addr_multiple_use {XPATH('adls_per_addr_multiple_use')};
STRING ssns_per_addr_multiple_use {XPATH('ssns_per_addr_multiple_use')};
STRING phones_per_addr_multiple_use {XPATH('phones_per_addr_multiple_use')};
STRING suspicious_adls_per_addr_created_6months {XPATH('suspicious_adls_per_addr_created_6months')};
STRING adls_per_phone {XPATH('adls_per_phone')};
STRING adls_per_phone_created_6months {XPATH('adls_per_phone_created_6months')};
STRING adls_per_phone_multiple_use {XPATH('adls_per_phone_multiple_use')};
STRING addrs_per_phone {XPATH('addrs_per_phone')};
STRING addrs_per_phone_created_6months {XPATH('addrs_per_phone_created_6months')};
END;

EXPORT infutor_layout := RECORD
STRING infutor_date_first_seen {XPATH('infutor_date_first_seen')};
STRING infutor_date_last_seen {XPATH('infutor_date_last_seen')};
STRING infutor_nap {XPATH('infutor_nap')};
END;

EXPORT infutor_phone_layout := RECORD
STRING infutor_date_first_seen {XPATH('infutor_date_first_seen')};
STRING infutor_date_last_seen {XPATH('infutor_date_last_seen')};
STRING infutor_nap {XPATH('infutor_nap')};
END;

EXPORT impulse_layout := RECORD
STRING count {XPATH('count')};
STRING first_seen_date {XPATH('first_seen_date')};
STRING last_seen_date {XPATH('last_seen_date')};
STRING siteid {XPATH('siteid')};
STRING count30 {XPATH('count30')};
STRING count90 {XPATH('count90')};
STRING count180 {XPATH('count180')};
STRING count12 {XPATH('count12')};
STRING count24 {XPATH('count24')};
STRING count36 {XPATH('count36')};
STRING count60 {XPATH('count60')};
STRING annual_income {XPATH('annual_income')};
END;

EXPORT bjl_layout := RECORD
STRING bankrupt {XPATH('bankrupt')};
STRING date_last_seen {XPATH('date_last_seen')};
STRING filing_count {XPATH('filing_count')};
STRING bk_recent_count {XPATH('bk_recent_count')};
STRING bk_disposed_recent_count {XPATH('bk_disposed_recent_count')};
STRING bk_disposed_historical_count {XPATH('bk_disposed_historical_count')};
STRING bk_count30 {XPATH('bk_count30')};
STRING bk_count90 {XPATH('bk_count90')};
STRING bk_count180 {XPATH('bk_count180')};
STRING bk_count12 {XPATH('bk_count12')};
STRING bk_count24 {XPATH('bk_count24')};
STRING bk_count36 {XPATH('bk_count36')};
STRING bk_count60 {XPATH('bk_count60')};
STRING liens_recent_unreleased_count {XPATH('liens_recent_unreleased_count')};
STRING liens_historical_unreleased_count {XPATH('liens_historical_unreleased_count')};
STRING liens_unreleased_count30 {XPATH('liens_unreleased_count30')};
STRING liens_unreleased_count90 {XPATH('liens_unreleased_count90')};
STRING liens_unreleased_count180 {XPATH('liens_unreleased_count180')};
STRING liens_unreleased_count12 {XPATH('liens_unreleased_count12')};
STRING liens_unreleased_count24 {XPATH('liens_unreleased_count24')};
STRING liens_unreleased_count36 {XPATH('liens_unreleased_count36')};
STRING liens_unreleased_count60 {XPATH('liens_unreleased_count60')};
STRING liens_recent_released_count {XPATH('liens_recent_released_count')};
STRING liens_historical_released_count {XPATH('liens_historical_released_count')};
STRING liens_released_count30 {XPATH('liens_released_count30')};
STRING liens_released_count90 {XPATH('liens_released_count90')};
STRING liens_released_count180 {XPATH('liens_released_count180')};
STRING liens_released_count12 {XPATH('liens_released_count12')};
STRING liens_released_count24 {XPATH('liens_released_count24')};
STRING liens_released_count36 {XPATH('liens_released_count36')};
STRING liens_released_count60 {XPATH('liens_released_count60')};
STRING last_liens_released_date {XPATH('last_liens_released_date')};
STRING criminal_count {XPATH('criminal_count')};
STRING criminal_count30 {XPATH('criminal_count30')};
STRING criminal_count90 {XPATH('criminal_count90')};
STRING criminal_count180 {XPATH('criminal_count180')};
STRING criminal_count12 {XPATH('criminal_count12')};
STRING criminal_count24 {XPATH('criminal_count24')};
STRING criminal_count36 {XPATH('criminal_count36')};
STRING criminal_count60 {XPATH('criminal_count60')};
STRING last_criminal_date {XPATH('last_criminal_date')};
STRING felony_count {XPATH('felony_count')};
STRING last_felony_date {XPATH('last_felony_date')};
STRING eviction_recent_unreleased_count {XPATH('eviction_recent_unreleased_count')};
STRING eviction_historical_unreleased_count {XPATH('eviction_historical_unreleased_count')};
STRING eviction_recent_released_count {XPATH('eviction_recent_released_count')};
STRING eviction_historical_released_count {XPATH('eviction_historical_released_count')};
STRING eviction_count {XPATH('eviction_count')};
STRING eviction_count30 {XPATH('eviction_count30')};
STRING eviction_count90 {XPATH('eviction_count90')};
STRING eviction_count180 {XPATH('eviction_count180')};
STRING eviction_count12 {XPATH('eviction_count12')};
STRING eviction_count24 {XPATH('eviction_count24')};
STRING eviction_count36 {XPATH('eviction_count36')};
STRING eviction_count60 {XPATH('eviction_count60')};
STRING last_eviction_date {XPATH('last_eviction_date')};
STRING arrests_count {XPATH('arrests_count')};
STRING arrests_count30 {XPATH('arrests_count30')};
STRING arrests_count90 {XPATH('arrests_count90')};
STRING arrests_count180 {XPATH('arrests_count180')};
STRING arrests_count12 {XPATH('arrests_count12')};
STRING arrests_count24 {XPATH('arrests_count24')};
STRING arrests_count36 {XPATH('arrests_count36')};
STRING arrests_count60 {XPATH('arrests_count60')};
STRING date_last_arrest {XPATH('date_last_arrest')};
STRING foreclosure_flag {XPATH('foreclosure_flag')};
END;

EXPORT owned_relatives_layout := RECORD
STRING relatives_property_count {XPATH('relatives_property_count')};
STRING relatives_property_total {XPATH('relatives_property_total')};
STRING relatives_property_owned_purchase_total {XPATH('relatives_property_owned_purchase_total')};
STRING relatives_property_owned_purchase_count {XPATH('relatives_property_owned_purchase_count')};
STRING relatives_property_owned_assessed_total {XPATH('relatives_property_owned_assessed_total')};
STRING relatives_property_owned_assessed_count {XPATH('relatives_property_owned_assessed_count')};
END;

EXPORT sold_relatives_layout := RECORD
STRING relatives_property_count {XPATH('relatives_property_count')};
STRING relatives_property_total {XPATH('relatives_property_total')};
STRING relatives_property_owned_purchase_total {XPATH('relatives_property_owned_purchase_total')};
STRING relatives_property_owned_purchase_count {XPATH('relatives_property_owned_purchase_count')};
STRING relatives_property_owned_assessed_total {XPATH('relatives_property_owned_assessed_total')};
STRING relatives_property_owned_assessed_count {XPATH('relatives_property_owned_assessed_count')};
END;

EXPORT ambiguous_relatives_layout := RECORD
STRING relatives_property_count {XPATH('relatives_property_count')};
STRING relatives_property_total {XPATH('relatives_property_total')};
STRING relatives_property_owned_purchase_total {XPATH('relatives_property_owned_purchase_total')};
STRING relatives_property_owned_purchase_count {XPATH('relatives_property_owned_purchase_count')};
STRING relatives_property_owned_assessed_total {XPATH('relatives_property_owned_assessed_total')};
STRING relatives_property_owned_assessed_count {XPATH('relatives_property_owned_assessed_count')};
END;

EXPORT relatives_layout := RECORD
STRING relative_count {XPATH('relative_count')};
STRING relative_bankrupt_count {XPATH('relative_bankrupt_count')};
STRING relative_criminal_count {XPATH('relative_criminal_count')};
STRING relative_criminal_total {XPATH('relative_criminal_total')};
STRING relative_felony_count {XPATH('relative_felony_count')};
STRING relative_felony_total {XPATH('relative_felony_total')};
STRING criminal_relative_within25miles {XPATH('criminal_relative_within25miles')};
STRING criminal_relative_within100miles {XPATH('criminal_relative_within100miles')};
STRING criminal_relative_within500miles {XPATH('criminal_relative_within500miles')};
STRING criminal_relative_withinother {XPATH('criminal_relative_withinother')};
DATASET(owned_relatives_layout) owned {XPATH('owned')};
DATASET(sold_relatives_layout) sold {XPATH('sold')};
DATASET(ambiguous_relatives_layout) ambiguous {XPATH('ambiguous')};
STRING relative_within25miles_count {XPATH('relative_within25miles_count')};
STRING relative_within100miles_count {XPATH('relative_within100miles_count')};
STRING relative_within500miles_count {XPATH('relative_within500miles_count')};
STRING relative_withinother_count {XPATH('relative_withinother_count')};
STRING relative_incomeunder25_count {XPATH('relative_incomeunder25_count')};
STRING relative_incomeunder50_count {XPATH('relative_incomeunder50_count')};
STRING relative_incomeunder75_count {XPATH('relative_incomeunder75_count')};
STRING relative_incomeunder100_count {XPATH('relative_incomeunder100_count')};
STRING relative_incomeover100_count {XPATH('relative_incomeover100_count')};
STRING relative_homeunder50_count {XPATH('relative_homeunder50_count')};
STRING relative_homeunder100_count {XPATH('relative_homeunder100_count')};
STRING relative_homeunder150_count {XPATH('relative_homeunder150_count')};
STRING relative_homeunder200_count {XPATH('relative_homeunder200_count')};
STRING relative_homeunder300_count {XPATH('relative_homeunder300_count')};
STRING relative_homeunder500_count {XPATH('relative_homeunder500_count')};
STRING relative_homeover500_count {XPATH('relative_homeover500_count')};
STRING relative_educationunder8_count {XPATH('relative_educationunder8_count')};
STRING relative_educationunder12_count {XPATH('relative_educationunder12_count')};
STRING relative_educationover12_count {XPATH('relative_educationover12_count')};
STRING relative_ageunder20_count {XPATH('relative_ageunder20_count')};
STRING relative_ageunder30_count {XPATH('relative_ageunder30_count')};
STRING relative_ageunder40_count {XPATH('relative_ageunder40_count')};
STRING relative_ageunder50_count {XPATH('relative_ageunder50_count')};
STRING relative_ageunder60_count {XPATH('relative_ageunder60_count')};
STRING relative_ageunder70_count {XPATH('relative_ageunder70_count')};
STRING relative_ageover70_count {XPATH('relative_ageover70_count')};
STRING relative_vehicle_owned_count {XPATH('relative_vehicle_owned_count')};
STRING relatives_at_input_address {XPATH('relatives_at_input_address')};
STRING relative_suspicious_identities_count {XPATH('relative_suspicious_identities_count')};
STRING relative_bureau_only_count {XPATH('relative_bureau_only_count')};
STRING relative_bureau_only_count_created_1month {XPATH('relative_bureau_only_count_created_1month')};
STRING relative_bureau_only_count_created_6months {XPATH('relative_bureau_only_count_created_6months')};
END;

EXPORT vehicle1_layout := RECORD
STRING year_make {XPATH('year_make')};
STRING title {XPATH('title')};
END;

EXPORT vehicle2_layout := RECORD
STRING year_make {XPATH('year_make')};
STRING title {XPATH('title')};
END;

EXPORT vehicle3_layout := RECORD
STRING year_make {XPATH('year_make')};
STRING title {XPATH('title')};
END;

EXPORT vehicles_layout := RECORD
STRING current_count {XPATH('current_count')};
STRING historical_count {XPATH('historical_count')};
DATASET(vehicle1_layout) vehicle1 {XPATH('vehicle1')};
DATASET(vehicle2_layout) vehicle2 {XPATH('vehicle2')};
DATASET(vehicle3_layout) vehicle3 {XPATH('vehicle3')};
END;

EXPORT watercraft_layout := RECORD
STRING watercraft_count {XPATH('watercraft_count')};
STRING watercraft_count30 {XPATH('watercraft_count30')};
STRING watercraft_count90 {XPATH('watercraft_count90')};
STRING watercraft_count180 {XPATH('watercraft_count180')};
STRING watercraft_count12 {XPATH('watercraft_count12')};
STRING watercraft_count24 {XPATH('watercraft_count24')};
STRING watercraft_count36 {XPATH('watercraft_count36')};
STRING watercraft_count60 {XPATH('watercraft_count60')};
END;

EXPORT acc_layout := RECORD
STRING num_accidents {XPATH('num_accidents')};
STRING dmgamtaccidents {XPATH('dmgamtaccidents')};
STRING datelastaccident {XPATH('datelastaccident')};
STRING dmgamtlastaccident {XPATH('dmgamtlastaccident')};
STRING numaccidents30 {XPATH('numaccidents30')};
STRING numaccidents90 {XPATH('numaccidents90')};
STRING numaccidents180 {XPATH('numaccidents180')};
STRING numaccidents12 {XPATH('numaccidents12')};
STRING numaccidents24 {XPATH('numaccidents24')};
STRING numaccidents36 {XPATH('numaccidents36')};
STRING numaccidents60 {XPATH('numaccidents60')};
END;

EXPORT atfault_layout := RECORD
STRING num_accidents {XPATH('num_accidents')};
STRING dmgamtaccidents {XPATH('dmgamtaccidents')};
STRING datelastaccident {XPATH('datelastaccident')};
STRING dmgamtlastaccident {XPATH('dmgamtlastaccident')};
STRING numaccidents30 {XPATH('numaccidents30')};
STRING numaccidents90 {XPATH('numaccidents90')};
STRING numaccidents180 {XPATH('numaccidents180')};
STRING numaccidents12 {XPATH('numaccidents12')};
STRING numaccidents24 {XPATH('numaccidents24')};
STRING numaccidents36 {XPATH('numaccidents36')};
STRING numaccidents60 {XPATH('numaccidents60')};
END;

EXPORT atfaultda_layout := RECORD
STRING num_accidents {XPATH('num_accidents')};
STRING dmgamtaccidents {XPATH('dmgamtaccidents')};
STRING datelastaccident {XPATH('datelastaccident')};
STRING dmgamtlastaccident {XPATH('dmgamtlastaccident')};
STRING numaccidents30 {XPATH('numaccidents30')};
STRING numaccidents90 {XPATH('numaccidents90')};
STRING numaccidents180 {XPATH('numaccidents180')};
STRING numaccidents12 {XPATH('numaccidents12')};
STRING numaccidents24 {XPATH('numaccidents24')};
STRING numaccidents36 {XPATH('numaccidents36')};
STRING numaccidents60 {XPATH('numaccidents60')};
END;

EXPORT accident_data_layout := RECORD
DATASET(acc_layout) acc {XPATH('acc')};
DATASET(atfault_layout) atfault {XPATH('atfault')};
DATASET(atfaultda_layout) atfaultda {XPATH('atfaultda')};
END;

EXPORT aircraft_layout := RECORD
STRING aircraft_count {XPATH('aircraft_count')};
STRING aircraft_count30 {XPATH('aircraft_count30')};
STRING aircraft_count90 {XPATH('aircraft_count90')};
STRING aircraft_count180 {XPATH('aircraft_count180')};
STRING aircraft_count12 {XPATH('aircraft_count12')};
STRING aircraft_count24 {XPATH('aircraft_count24')};
STRING aircraft_count36 {XPATH('aircraft_count36')};
STRING aircraft_count60 {XPATH('aircraft_count60')};
END;

EXPORT professional_license_layout := RECORD
STRING professional_license_flag {XPATH('professional_license_flag')};
STRING proflic_count {XPATH('proflic_count')};
STRING date_most_recent {XPATH('date_most_recent')};
STRING expiration_date {XPATH('expiration_date')};
STRING proflic_count30 {XPATH('proflic_count30')};
STRING proflic_count90 {XPATH('proflic_count90')};
STRING proflic_count180 {XPATH('proflic_count180')};
STRING proflic_count12 {XPATH('proflic_count12')};
STRING proflic_count24 {XPATH('proflic_count24')};
STRING proflic_count36 {XPATH('proflic_count36')};
STRING proflic_count60 {XPATH('proflic_count60')};
STRING expire_count30 {XPATH('expire_count30')};
STRING expire_count90 {XPATH('expire_count90')};
STRING expire_count180 {XPATH('expire_count180')};
STRING expire_count12 {XPATH('expire_count12')};
STRING expire_count24 {XPATH('expire_count24')};
STRING expire_count36 {XPATH('expire_count36')};
STRING expire_count60 {XPATH('expire_count60')};
END;

EXPORT input_address_information_avm_layout := RECORD
STRING avm_land_use_code {XPATH('avm_land_use_code')};
STRING avm_recording_date {XPATH('avm_recording_date')};
STRING avm_assessed_value_year {XPATH('avm_assessed_value_year')};
STRING avm_sales_price {XPATH('avm_sales_price')};
STRING avm_assessed_total_value {XPATH('avm_assessed_total_value')};
STRING avm_tax_assessment_valuation {XPATH('avm_tax_assessment_valuation')};
STRING avm_price_index_valuation {XPATH('avm_price_index_valuation')};
STRING avm_hedonic_valuation {XPATH('avm_hedonic_valuation')};
STRING avm_automated_valuation {XPATH('avm_automated_valuation')};
STRING avm_automated_valuation2 {XPATH('avm_automated_valuation2')};
STRING avm_automated_valuation3 {XPATH('avm_automated_valuation3')};
STRING avm_automated_valuation4 {XPATH('avm_automated_valuation4')};
STRING avm_automated_valuation5 {XPATH('avm_automated_valuation5')};
STRING avm_automated_valuation6 {XPATH('avm_automated_valuation6')};
STRING avm_confidence_score {XPATH('avm_confidence_score')};
STRING avm_median_fips_level {XPATH('avm_median_fips_level')};
STRING avm_median_geo11_level {XPATH('avm_median_geo11_level')};
STRING avm_median_geo12_level {XPATH('avm_median_geo12_level')};
END;

EXPORT address_history_1_avm_layout := RECORD
STRING avm_tax_assessment_valuation {XPATH('avm_tax_assessment_valuation')};
STRING avm_price_index_valuation {XPATH('avm_price_index_valuation')};
STRING avm_hedonic_valuation {XPATH('avm_hedonic_valuation')};
STRING avm_automated_valuation {XPATH('avm_automated_valuation')};
STRING avm_automated_valuation2 {XPATH('avm_automated_valuation2')};
STRING avm_automated_valuation3 {XPATH('avm_automated_valuation3')};
STRING avm_automated_valuation4 {XPATH('avm_automated_valuation4')};
STRING avm_automated_valuation5 {XPATH('avm_automated_valuation5')};
STRING avm_automated_valuation6 {XPATH('avm_automated_valuation6')};
STRING avm_confidence_score {XPATH('avm_confidence_score')};
STRING avm_median_fips_level {XPATH('avm_median_fips_level')};
STRING avm_median_geo11_level {XPATH('avm_median_geo11_level')};
STRING avm_median_geo12_level {XPATH('avm_median_geo12_level')};
END;

EXPORT address_history_2_avm_layout := RECORD
STRING avm_tax_assessment_valuation {XPATH('avm_tax_assessment_valuation')};
STRING avm_price_index_valuation {XPATH('avm_price_index_valuation')};
STRING avm_hedonic_valuation {XPATH('avm_hedonic_valuation')};
STRING avm_automated_valuation {XPATH('avm_automated_valuation')};
STRING avm_automated_valuation2 {XPATH('avm_automated_valuation2')};
STRING avm_automated_valuation3 {XPATH('avm_automated_valuation3')};
STRING avm_automated_valuation4 {XPATH('avm_automated_valuation4')};
STRING avm_automated_valuation5 {XPATH('avm_automated_valuation5')};
STRING avm_automated_valuation6 {XPATH('avm_automated_valuation6')};
STRING avm_confidence_score {XPATH('avm_confidence_score')};
STRING avm_median_fips_level {XPATH('avm_median_fips_level')};
STRING avm_median_geo11_level {XPATH('avm_median_geo11_level')};
STRING avm_median_geo12_level {XPATH('avm_median_geo12_level')};
END;

EXPORT avm_layout := RECORD
DATASET(input_address_information_avm_layout) input_address_information {XPATH('input_address_information')};
DATASET(address_history_1_avm_layout) address_history_1 {XPATH('address_history_1')};
DATASET(address_history_2_avm_layout) address_history_2 {XPATH('address_history_2')};
END;




EXPORT liens_unreleased_civil_judgment_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_released_civil_judgment_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_unreleased_federal_tax_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_released_federal_tax_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_unreleased_foreclosure_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_released_foreclosure_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_unreleased_landlord_tenant_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_released_landlord_tenant_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_unreleased_lispendens_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_released_lispendens_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_unreleased_other_lj_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_released_other_lj_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_unreleased_other_tax_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_released_other_tax_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_unreleased_small_claims_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_released_small_claims_layout := RECORD
STRING count {XPATH('count')};
STRING earliest_filing_date {XPATH('earliest_filing_date')};
STRING most_recent_filing_date {XPATH('most_recent_filing_date')};
STRING total_amount {XPATH('total_amount')};
END;

EXPORT liens_layout := RECORD
DATASET(liens_unreleased_civil_judgment_layout) liens_unreleased_civil_judgment {XPATH('liens_unreleased_civil_judgment')};
DATASET(liens_released_civil_judgment_layout) liens_released_civil_judgment {XPATH('liens_released_civil_judgment')};
DATASET(liens_unreleased_federal_tax_layout) liens_unreleased_federal_tax {XPATH('liens_unreleased_federal_tax')};
DATASET(liens_released_federal_tax_layout) liens_released_federal_tax {XPATH('liens_released_federal_tax')};
DATASET(liens_unreleased_foreclosure_layout) liens_unreleased_foreclosure {XPATH('liens_unreleased_foreclosure')};
DATASET(liens_unreleased_landlord_tenant_layout) liens_unreleased_landlord_tenant {XPATH('liens_unreleased_landlord_tenant')};
DATASET(liens_released_landlord_tenant_layout) liens_released_landlord_tenant {XPATH('liens_released_landlord_tenant')};
DATASET(liens_unreleased_lispendens_layout) liens_unreleased_lispendens {XPATH('liens_unreleased_lispendens')};
DATASET(liens_released_lispendens_layout) liens_released_lispendens {XPATH('liens_released_lispendens')};
DATASET(liens_unreleased_other_lj_layout) liens_unreleased_other_lj {XPATH('liens_unreleased_other_lj')};
DATASET(liens_released_other_lj_layout) liens_released_other_lj {XPATH('liens_released_other_lj')};
DATASET(liens_unreleased_other_tax_layout) liens_unreleased_other_tax {XPATH('liens_unreleased_other_tax')};
DATASET(liens_released_other_tax_layout) liens_released_other_tax {XPATH('liens_released_other_tax')};
DATASET(liens_unreleased_small_claims_layout) liens_unreleased_small_claims {XPATH('liens_unreleased_small_claims')};
DATASET(liens_released_small_claims_layout) liens_released_small_claims {XPATH('liens_released_small_claims')};
END;

EXPORT consumerflags_layout := RECORD
STRING corrected_flag {XPATH('corrected_flag')};
STRING consumer_statement_flag {XPATH('consumer_statement_flag')};
STRING dispute_flag {XPATH('dispute_flag')};
STRING security_freeze {XPATH('security_freeze')};
STRING security_alert {XPATH('security_alert')};
STRING negative_alert {XPATH('negative_alert')};
STRING id_theft_flag {XPATH('id_theft_flag')};
END;

EXPORT adl_shell_flags_layout := RECORD
STRING in_addrpop {XPATH('in_addrpop')};
STRING in_hphnpop {XPATH('in_hphnpop')};
STRING in_ssnpop {XPATH('in_ssnpop')};
STRING in_dobpop {XPATH('in_dobpop')};
STRING adl_addr {XPATH('adl_addr')};
STRING adl_hphn {XPATH('adl_hphn')};
STRING adl_ssn {XPATH('adl_ssn')};
STRING adl_dob {XPATH('adl_dob')};
STRING in_addrpop_found {XPATH('in_addrpop_found')};
STRING in_hphnpop_found {XPATH('in_hphnpop_found')};
END;

EXPORT header_summary_layout := RECORD
STRING ssn_name_source_count {XPATH('ssn_name_source_count')};
STRING ssn_addr_source_count {XPATH('ssn_addr_source_count')};
STRING addr_name_source_count {XPATH('addr_name_source_count')};
STRING phone_addr_source_count {XPATH('phone_addr_source_count')};
STRING phone_lname_source_count {XPATH('phone_lname_source_count')};
STRING eq_did_nlr {XPATH('eq_did_nlr')};
STRING en_did_nlr {XPATH('en_did_nlr')};
STRING tn_did_nlr {XPATH('tn_did_nlr')};
STRING eq_ssn_nlr {XPATH('eq_ssn_nlr')};
STRING en_ssn_nlr {XPATH('en_ssn_nlr')};
STRING tn_ssn_nlr {XPATH('tn_ssn_nlr')};
END;

EXPORT advo_input_addr_layout := RECORD
STRING address_vacancy_indicator {XPATH('address_vacancy_indicator')};
STRING throw_back_indicator {XPATH('throw_back_indicator')};
STRING seasonal_delivery_indicator {XPATH('seasonal_delivery_indicator')};
STRING dnd_indicator {XPATH('dnd_indicator')};
STRING college_indicator {XPATH('college_indicator')};
STRING drop_indicator {XPATH('drop_indicator')};
STRING residential_or_business_ind {XPATH('residential_or_business_ind')};
STRING mixed_address_usage {XPATH('mixed_address_usage')};
END;

EXPORT advo_addr_hist1_layout := RECORD
STRING address_vacancy_indicator {XPATH('address_vacancy_indicator')};
STRING throw_back_indicator {XPATH('throw_back_indicator')};
STRING seasonal_delivery_indicator {XPATH('seasonal_delivery_indicator')};
STRING dnd_indicator {XPATH('dnd_indicator')};
STRING college_indicator {XPATH('college_indicator')};
STRING drop_indicator {XPATH('drop_indicator')};
STRING residential_or_business_ind {XPATH('residential_or_business_ind')};
STRING mixed_address_usage {XPATH('mixed_address_usage')};
END;


EXPORT inquiries_layout := RECORD
STRING counttotal {XPATH('counttotal')};
STRING countday {XPATH('countday')};
STRING countweek {XPATH('countweek')};
STRING count01 {XPATH('count01')};
STRING count03 {XPATH('count03')};
STRING count06 {XPATH('count06')};
STRING count12 {XPATH('count12')};
STRING count24 {XPATH('count24')};
STRING cbdcounttotal {XPATH('cbdcounttotal')};
STRING cbdcount01 {XPATH('cbdcount01')};
END;


EXPORT collection_layout := RECORD
STRING counttotal {XPATH('counttotal')};
STRING countday {XPATH('countday')};
STRING countweek {XPATH('countweek')};
STRING count01 {XPATH('count01')};
STRING count03 {XPATH('count03')};
STRING count06 {XPATH('count06')};
STRING count12 {XPATH('count12')};
STRING count24 {XPATH('count24')};
STRING cbdcounttotal {XPATH('cbdcounttotal')};
STRING cbdcount01 {XPATH('cbdcount01')};
END;


EXPORT auto_layout := RECORD
STRING counttotal {XPATH('counttotal')};
STRING countday {XPATH('countday')};
STRING countweek {XPATH('countweek')};
STRING count01 {XPATH('count01')};
STRING count03 {XPATH('count03')};
STRING count06 {XPATH('count06')};
STRING count12 {XPATH('count12')};
STRING count24 {XPATH('count24')};
STRING cbdcounttotal {XPATH('cbdcounttotal')};
STRING cbdcount01 {XPATH('cbdcount01')};
END;


EXPORT banking_layout := RECORD
STRING counttotal {XPATH('counttotal')};
STRING countday {XPATH('countday')};
STRING countweek {XPATH('countweek')};
STRING count01 {XPATH('count01')};
STRING count03 {XPATH('count03')};
STRING count06 {XPATH('count06')};
STRING count12 {XPATH('count12')};
STRING count24 {XPATH('count24')};
STRING cbdcounttotal {XPATH('cbdcounttotal')};
STRING cbdcount01 {XPATH('cbdcount01')};
END;


EXPORT mortgage_layout := RECORD
STRING counttotal {XPATH('counttotal')};
STRING countday {XPATH('countday')};
STRING countweek {XPATH('countweek')};
STRING count01 {XPATH('count01')};
STRING count03 {XPATH('count03')};
STRING count06 {XPATH('count06')};
STRING count12 {XPATH('count12')};
STRING count24 {XPATH('count24')};
STRING cbdcounttotal {XPATH('cbdcounttotal')};
STRING cbdcount01 {XPATH('cbdcount01')};
END;


EXPORT highriskcredit_layout := RECORD
STRING counttotal {XPATH('counttotal')};
STRING countday {XPATH('countday')};
STRING countweek {XPATH('countweek')};
STRING count01 {XPATH('count01')};
STRING count03 {XPATH('count03')};
STRING count06 {XPATH('count06')};
STRING count12 {XPATH('count12')};
STRING count24 {XPATH('count24')};
STRING cbdcounttotal {XPATH('cbdcounttotal')};
STRING cbdcount01 {XPATH('cbdcount01')};
END;


EXPORT retail_layout := RECORD
STRING counttotal {XPATH('counttotal')};
STRING countday {XPATH('countday')};
STRING countweek {XPATH('countweek')};
STRING count01 {XPATH('count01')};
STRING count03 {XPATH('count03')};
STRING count06 {XPATH('count06')};
STRING count12 {XPATH('count12')};
STRING count24 {XPATH('count24')};
STRING cbdcounttotal {XPATH('cbdcounttotal')};
STRING cbdcount01 {XPATH('cbdcount01')};
END;


EXPORT communications_layout := RECORD
STRING counttotal {XPATH('counttotal')};
STRING countday {XPATH('countday')};
STRING countweek {XPATH('countweek')};
STRING count01 {XPATH('count01')};
STRING count03 {XPATH('count03')};
STRING count06 {XPATH('count06')};
STRING count12 {XPATH('count12')};
STRING count24 {XPATH('count24')};
STRING cbdcounttotal {XPATH('cbdcounttotal')};
STRING cbdcount01 {XPATH('cbdcount01')};
END;


EXPORT fraudsearches_layout := RECORD
STRING counttotal {XPATH('counttotal')};
STRING countday {XPATH('countday')};
STRING countweek {XPATH('countweek')};
STRING count01 {XPATH('count01')};
STRING count03 {XPATH('count03')};
STRING count06 {XPATH('count06')};
STRING count12 {XPATH('count12')};
STRING count24 {XPATH('count24')};
END;


EXPORT other_layout := RECORD
STRING counttotal {XPATH('counttotal')};
STRING countday {XPATH('countday')};
STRING countweek {XPATH('countweek')};
STRING count01 {XPATH('count01')};
STRING count03 {XPATH('count03')};
STRING count06 {XPATH('count06')};
STRING count12 {XPATH('count12')};
STRING count24 {XPATH('count24')};
STRING cbdcounttotal {XPATH('cbdcounttotal')};
STRING cbdcount01 {XPATH('cbdcount01')};
END;

EXPORT acc_logs_layout := RECORD
STRING inquiry_addr_ver_ct {XPATH('inquiry_addr_ver_ct')};
STRING inquiry_fname_ver_ct {XPATH('inquiry_fname_ver_ct')};
STRING inquiry_lname_ver_ct {XPATH('inquiry_lname_ver_ct')};
STRING inquiry_ssn_ver_ct {XPATH('inquiry_ssn_ver_ct')};
STRING inquiry_dob_ver_ct {XPATH('inquiry_dob_ver_ct')};
STRING inquiry_phone_ver_ct {XPATH('inquiry_phone_ver_ct')};
DATASET(inquiries_layout) inquiries {XPATH('inquiries')};
DATASET(collection_layout) collection {XPATH('collection')};
DATASET(auto_layout) auto {XPATH('auto')};
DATASET(banking_layout) banking {XPATH('banking')};
DATASET(mortgage_layout) mortgage {XPATH('mortgage')};
DATASET(highriskcredit_layout) highriskcredit {XPATH('highriskcredit')};
DATASET(retail_layout) retail {XPATH('retail')};
DATASET(communications_layout) communications {XPATH('communications')};
DATASET(fraudsearches_layout) fraudsearches {XPATH('fraudsearches')};
DATASET(other_layout) other {XPATH('other')};
STRING inquiryperadl {XPATH('inquiryperadl')};
STRING inquiryssnsperadl {XPATH('inquiryssnsperadl')};
STRING inquiryaddrsperadl {XPATH('inquiryaddrsperadl')};
STRING inquirylnamesperadl {XPATH('inquirylnamesperadl')};
STRING inquiryfnamesperadl {XPATH('inquiryfnamesperadl')};
STRING inquiryphonesperadl {XPATH('inquiryphonesperadl')};
STRING inquirydobsperadl {XPATH('inquirydobsperadl')};
STRING unverifiedssnsperadl {XPATH('unverifiedssnsperadl')};
STRING unverifiedaddrsperadl {XPATH('unverifiedaddrsperadl')};
STRING unverifiedphonesperadl {XPATH('unverifiedphonesperadl')};
STRING unverifieddobsperadl {XPATH('unverifieddobsperadl')};
STRING inquiryperssn {XPATH('inquiryperssn')};
STRING inquiryadlsperssn {XPATH('inquiryadlsperssn')};
STRING inquirylnamesperssn {XPATH('inquirylnamesperssn')};
STRING inquiryaddrsperssn {XPATH('inquiryaddrsperssn')};
STRING inquirydobsperssn {XPATH('inquirydobsperssn')};
STRING fraudsearchinquiryperssn {XPATH('fraudsearchinquiryperssn')};
STRING fraudsearchinquiryperssnyear {XPATH('fraudsearchinquiryperssnyear')};
STRING fraudsearchinquiryperssnmonth {XPATH('fraudsearchinquiryperssnmonth')};
STRING fraudsearchinquiryperssnweek {XPATH('fraudsearchinquiryperssnweek')};
STRING fraudsearchinquiryperssnday {XPATH('fraudsearchinquiryperssnday')};
STRING inquiryperaddr {XPATH('inquiryperaddr')};
STRING inquiryadlsperaddr {XPATH('inquiryadlsperaddr')};
STRING inquirylnamesperaddr {XPATH('inquirylnamesperaddr')};
STRING inquiryssnsperaddr {XPATH('inquiryssnsperaddr')};
STRING fraudsearchinquiryperaddr {XPATH('fraudsearchinquiryperaddr')};
STRING fraudsearchinquiryperaddryear {XPATH('fraudsearchinquiryperaddryear')};
STRING fraudsearchinquiryperaddrmonth {XPATH('fraudsearchinquiryperaddrmonth')};
STRING fraudsearchinquiryperaddrweek {XPATH('fraudsearchinquiryperaddrweek')};
STRING fraudsearchinquiryperaddrday {XPATH('fraudsearchinquiryperaddrday')};
STRING inquirysuspciousadlsperaddr {XPATH('inquirysuspciousadlsperaddr')};
STRING inquiryperphone {XPATH('inquiryperphone')};
STRING inquiryadlsperphone {XPATH('inquiryadlsperphone')};
STRING fraudsearchinquiryperphone {XPATH('fraudsearchinquiryperphone')};
STRING fraudsearchinquiryperphoneyear {XPATH('fraudsearchinquiryperphoneyear')};
STRING fraudsearchinquiryperphonemonth {XPATH('fraudsearchinquiryperphonemonth')};
STRING fraudsearchinquiryperphoneweek {XPATH('fraudsearchinquiryperphoneweek')};
STRING fraudsearchinquiryperphoneday {XPATH('fraudsearchinquiryperphoneday')};
STRING cbd_inquiryaddrsperadl {XPATH('cbd_inquiryaddrsperadl')};
STRING cbd_inquiryadlsperaddr {XPATH('cbd_inquiryadlsperaddr')};
STRING cbd_inquiryphonesperadl {XPATH('cbd_inquiryphonesperadl')};
END;

EXPORT employment_layout := RECORD
STRING first_seen_date {XPATH('first_seen_date')};
STRING business_ct {XPATH('business_ct')};
STRING dead_business_ct {XPATH('dead_business_ct')};
STRING business_active_phone_ct {XPATH('business_active_phone_ct')};
STRING source_ct {XPATH('source_ct')};
END;


EXPORT business_header_address_summary_layout := RECORD
STRING bus_addr_match_cnt {XPATH('bus_addr_match_cnt')};
STRING bus_name_match {XPATH('bus_name_match')};
STRING bus_ssn_match {XPATH('bus_ssn_match')};
STRING bus_phone_match {XPATH('bus_phone_match')};
END;


EXPORT email_summary_layout := RECORD
STRING email_ct {XPATH('email_ct')};
STRING email_domain_free_ct {XPATH('email_domain_free_ct')};
STRING email_domain_isp_ct {XPATH('email_domain_isp_ct')};
STRING email_domain_edu_ct {XPATH('email_domain_edu_ct')};
STRING email_domain_corp_ct {XPATH('email_domain_corp_ct')};
END;


EXPORT address_history_summary_layout := RECORD
STRING address_history_advo_college_hit {XPATH('address_history_advo_college_hit')};
STRING unique_addr_cnt {XPATH('unique_addr_cnt')};
STRING avg_mo_per_addr {XPATH('avg_mo_per_addr')};
STRING addr_count2 {XPATH('addr_count2')};
STRING addr_count3 {XPATH('addr_count3')};
STRING addr_count6 {XPATH('addr_count6')};
STRING addr_count10 {XPATH('addr_count10')};
STRING lres_2mo_count {XPATH('lres_2mo_count')};
STRING lres_6mo_count {XPATH('lres_6mo_count')};
STRING lres_12mo_count {XPATH('lres_12mo_count')};
STRING hist_addr_match {XPATH('hist_addr_match')};
STRING input_addr_first_seen {XPATH('input_addr_first_seen')};
STRING input_addr_last_seen {XPATH('input_addr_last_seen')};
END;


EXPORT addr_risk_summary_layout := RECORD
STRING occupants_1yr {XPATH('occupants_1yr')};
STRING turnover_1yr_in {XPATH('turnover_1yr_in')};
STRING turnover_1yr_out {XPATH('turnover_1yr_out')};
STRING n_vacant_properties {XPATH('n_vacant_properties')};
STRING n_business_count {XPATH('n_business_count')};
STRING n_sfd_count {XPATH('n_sfd_count')};
STRING n_mfd_count {XPATH('n_mfd_count')};
STRING n_ave_building_age {XPATH('n_ave_building_age')};
STRING n_ave_purchase_amount {XPATH('n_ave_purchase_amount')};
STRING n_ave_mortgage_amount {XPATH('n_ave_mortgage_amount')};
STRING n_ave_assessed_amount {XPATH('n_ave_assessed_amount')};
STRING n_ave_building_area {XPATH('n_ave_building_area')};
STRING n_ave_price_per_sf {XPATH('n_ave_price_per_sf')};
STRING n_ave_no_of_stories_count {XPATH('n_ave_no_of_stories_count')};
STRING n_ave_no_of_rooms_count {XPATH('n_ave_no_of_rooms_count')};
STRING n_ave_no_of_bedrooms_count {XPATH('n_ave_no_of_bedrooms_count')};
STRING n_ave_no_of_baths_count {XPATH('n_ave_no_of_baths_count')};
END;


EXPORT addr_risk_summary2_layout := RECORD
STRING occupants_1yr {XPATH('occupants_1yr')};
STRING turnover_1yr_in {XPATH('turnover_1yr_in')};
STRING turnover_1yr_out {XPATH('turnover_1yr_out')};
STRING n_vacant_properties {XPATH('n_vacant_properties')};
STRING n_business_count {XPATH('n_business_count')};
STRING n_sfd_count {XPATH('n_sfd_count')};
STRING n_mfd_count {XPATH('n_mfd_count')};
STRING n_ave_building_age {XPATH('n_ave_building_age')};
STRING n_ave_purchase_amount {XPATH('n_ave_purchase_amount')};
STRING n_ave_mortgage_amount {XPATH('n_ave_mortgage_amount')};
STRING n_ave_assessed_amount {XPATH('n_ave_assessed_amount')};
STRING n_ave_building_area {XPATH('n_ave_building_area')};
STRING n_ave_price_per_sf {XPATH('n_ave_price_per_sf')};
STRING n_ave_no_of_stories_count {XPATH('n_ave_no_of_stories_count')};
STRING n_ave_no_of_rooms_count {XPATH('n_ave_no_of_rooms_count')};
STRING n_ave_no_of_bedrooms_count {XPATH('n_ave_no_of_bedrooms_count')};
STRING n_ave_no_of_baths_count {XPATH('n_ave_no_of_baths_count')};
END;

EXPORT rform1 := RECORD
	STRING seq {XPATH('seq')};
	STRING did {XPATH('did')};
	STRING truedid {XPATH('truedid')};
	STRING adlcategory {XPATH('adlcategory')};
	DATASET(shell_input_layout) shell_input {XPATH('shell_input')};
	DATASET(iid_layout) iid {XPATH('iid')};
	DATASET(source_verification_layout) source_verification {XPATH('source_verification')};
	DATASET(available_sources_layout) available_sources {XPATH('available_sources')};
	DATASET(input_validation_layout) input_validation {XPATH('input_validation')};
	DATASET(address_validation_layout) address_validation {XPATH('address_validation')};
	DATASET(name_verification_layout) name_verification {XPATH('name_verification')};
	DATASET(utility_layout) utility {XPATH('utility')};
	DATASET(address_verification_layout) address_verification {XPATH('address_verification')};
	DATASET(other_address_info_layout) other_address_info {XPATH('other_address_info')};
	DATASET(phone_verification_layout) phone_verification {XPATH('phone_verification')};
	DATASET(ssn_verification_layout) ssn_verification {XPATH('ssn_verification')};
	DATASET(velocity_counters_layout) velocity_counters {XPATH('velocity_counters')};
  DATASET(infutor_layout) infutor {XPATH('infutor')};
	DATASET(infutor_phone_layout) infutor_phone {XPATH('infutor_phone')};
	DATASET(impulse_layout) impulse {XPATH('impulse')};
	DATASET(bjl_layout) bjl {XPATH('bjl')};
	DATASET(relatives_layout) relatives {XPATH('relatives')};
	DATASET(vehicles_layout) vehicles {XPATH('vehicles')};
	DATASET(watercraft_layout) watercraft {XPATH('watercraft')};
	DATASET(accident_data_layout) accident_data {XPATH('accident_data')};
	DATASET(aircraft_layout) aircraft {XPATH('aircraft')};
	STRING student {XPATH('student')}; //may be a dataset
	DATASET(professional_license_layout) professional_license {XPATH('professional_license')};
	DATASET(avm_layout) avm {XPATH('avm')};
	DATASET(liens_layout) liens {XPATH('liens')};
	STRING rv_scores {XPATH('rv_scores')}; //could be a dataset. no examples
	STRING fd_scores {XPATH('fd_scores')}; //could be a dataset. no examples
	STRING wealth_indicator {XPATH('wealth_indicator')};
	STRING reported_dob {XPATH('reported_dob')};
	STRING dobmatchlevel {XPATH('dobmatchlevel')};
	STRING inferred_age {XPATH('inferred_age')};
	STRING mobility_indicator {XPATH('mobility_indicator')};
	STRING lres {XPATH('lres')};
	STRING lres2 {XPATH('lres2')};
	STRING lres3 {XPATH('lres3')};
	STRING addrpop {XPATH('addrpop')};
	STRING addrpop2 {XPATH('addrpop2')};
	STRING addrpop3 {XPATH('addrpop3')};
	STRING historydate {XPATH('historydate')};
	STRING addrhist2zip4 {XPATH('addrhist2zip4')};
	STRING gong_adl_dt_first_seen {XPATH('gong_adl_dt_first_seen')};
	STRING gong_adl_dt_last_seen {XPATH('gong_adl_dt_last_seen')};
	STRING total_number_derogs {XPATH('total_number_derogs')};
	STRING date_last_derog {XPATH('date_last_derog')};
	STRING estimated_income {XPATH('estimated_income')};
	DATASET(consumerflags_layout) consumerflags {XPATH('consumerflags')};
	DATASET(adl_shell_flags_layout) adl_shell_flags {XPATH('adl_shell_flags')};
	DATASET(header_summary_layout) header_summary {XPATH('header_summary')};
	DATASET(advo_input_addr_layout) advo_input_addr {XPATH('advo_input_addr')};
	DATASET(advo_addr_hist1_layout) advo_addr_hist1 {XPATH('advo_addr_hist1')};
	DATASET(acc_logs_layout) acc_logs {XPATH('acc_logs')};
	DATASET(employment_layout) employment {XPATH('employment')};
	DATASET(business_header_address_summary_layout) business_header_address_summary {XPATH('business_header_address_summary')};
	DATASET(email_summary_layout) email_summary {XPATH('email_summary')};
	DATASET(address_history_summary_layout) address_history_summary {XPATH('address_history_summary')};
	DATASET(addr_risk_summary_layout) addr_risk_summary {XPATH('addr_risk_summary')};
	DATASET(addr_risk_summary2_layout) addr_risk_summary2 {XPATH('addr_risk_summary2')};
	STRING uspis_hotlist {XPATH('uspis_hotlist')};
	STRING ibehavior {XPATH('ibehavior')}; // could be dataset. no examples
END;

END;