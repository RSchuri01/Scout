import scout;
import scout.exports as exps;
import scout.common.spray;
import std;

#stored('alertId', '46');

#stored('mysql_env', 'qa');

//export options
in_Report_type := 'day';

string alertId :=  scout.common.stored_alert_id;

checkInput := IF(alertId = '', FAIL('Invalid_Search Condition'));

getSearchRecord := scout.exports.alert_export_db_query.getAlertParameters((integer)alertId);

output(getSearchRecord, named('getSearchRecord'));

alert_type_id := getSearchRecord[1].type_id;

in_reason_codes := getSearchRecord[1].reason_codes;

output(alert_type_id, named('alert_type_id'));

getAlertDates(String frequency, integer noOfFrequencyLookBack, String baselineDate) := function

	rec := record
		integer4 filterBeginDate;
		integer4 alertPeriodBeginDate;
		integer4 filterEndDate;
	end;

	recentClosedWeek := scout.common.util.dateutils.getPrevISOWeekDate();

	weeksBehindISOWeek := scout.common.util.dateutils.getISOWeek(recentClosedWeek, -noOfFrequencyLookBack);

	WeekfilterBeginDate	:= scout.common.util.dateutils.getRecentClosedWeekBeginEndDt(weeksBehindISOWeek)[1].Begin_Dt;
	WeekBeginDate 			:= scout.common.util.dateutils.getRecentClosedWeekBeginEndDt()[1].Begin_Dt;
	WeekEndDate	 				:= scout.common.util.dateutils.getTomorrow((string)scout.common.util.dateutils.getRecentClosedWeekBeginEndDt()[1].End_dt);

	recentClosedMonth 		 := scout.common.util.dateutils.getPrevYearMonth();
	recentClosedMonthBegin := scout.common.util.dateutils.getPrevYearMonth() + '01';
	prevBaseLineMonthBegin := scout.common.util.dateutils.getPrevYearMonthByMonthAgo(recentClosedMonth, noOfFrequencyLookBack) + '01';
	//LastDayOfTheMonth 	 := scout.common.util.dateutils.LastDayOfMonth(recentClosedMonth);
	alertMonthEnd			 		 := scout.common.util.dateutils.today_ym + '01';

	alertFilterBegingDate := if (baselineDate <> '', (integer4)baselineDate,
																	(MAP (frequency = 'WEEKLY'  => (integer4)WeekfilterBeginDate, 
																				frequency = 'MONTHLY' => (integer4)prevBaseLineMonthBegin,
																				0)));

	alertBegingDate 			:= 	MAP (frequency = 'WEEKLY'  => (integer4)WeekBeginDate, 
																 frequency = 'MONTHLY' => (integer4)recentClosedMonthBegin,
																 0);

	alerEndDate 					:= 	MAP (frequency = 'WEEKLY'  => (integer4)WeekEndDate, 
																 frequency = 'MONTHLY' => (integer4)alertMonthEnd,
																 0);

	return Dataset([{alertFilterBegingDate, alertBegingDate, alerEndDate}], rec);

END;

varianceFreq 			:= TRIM(IF(getSearchRecord[1].timeframe_date_range_type_id = 1, 'WEEKLY', 'MONTHLY'), ALL);

noOfVarianceFreqs := IF((INTEGER)getSearchRecord[1].date_range_type_description <> 0, 
                         (INTEGER)STD.STR.SPLITWORDS(getSearchRecord[1].date_range_type_description, ' ' )[1],
                         0);

baselineDate  		:= if(getSearchRecord[1].baseline_date <> '', 
												scout.common.util.dateutils.ConvertDateFormatMultipleFido(getSearchRecord[1].baseline_date[1..10], ['%Y-%m-%d']),
												'');

datesDS := getAlertDates(varianceFreq, noOfVarianceFreqs, baselineDate)[1];

filterBeginDate := datesDS.filterBeginDate;
filterEndDate 	:= datesDS.filterEndDate;
alertBeginDate 	:= datesDS.alertPeriodBeginDate;

scout.iesp.scout_search_detail.t_ScoutTransactionSearchSearchBy formatsearch(exps.layout.alert_parameters in, 
																																							integer4 inFilterBeginDate,
																																							integer4 inFilterEndDate) := Transform
    
		start_date := (string)inFilterBeginDate; //in.baseline_date;
		end_date 	 := (string)inFilterEndDate;
		
	// =============================================================
	self.DateRange.StartTimeStamp.Year := (integer)start_date[1..4];
	self.DateRange.StartTimeStamp.Month := (integer)start_date[5..6];
	self.DateRange.StartTimeStamp.Day := (integer)start_date[7..8];
	// self.DateRange.StartTimeStamp.Hour24 := (integer)start_date[12..13];
	// self.DateRange.StartTimeStamp.Minute := (integer)start_date[15..16];
	// self.DateRange.StartTimeStamp.Second := (integer)start_date[18..19];
	self.DateRange.EndTimeStamp.Year := (integer)end_date[1..4];
	self.DateRange.EndTimeStamp.Month := (integer)end_date[5..6];
	self.DateRange.EndTimeStamp.Day := (integer)end_date[7..8];
	// self.DateRange.EndTimeStamp.Hour24 := (integer)end_date[12..13];
	// self.DateRange.EndTimeStamp.Minute := (integer)end_date[15..16];
	// self.DateRange.EndTimeStamp.Second := (integer)end_date[18..19];
  // =============================================================

	self.CompanyId := (integer)in.company_id;
	self.ProductId := (string)in.mbs_product_id;
	self.ESPMethodName := in.esp_method_name;
	self.Score.ValueRange.Low := (string)in.score_low;
	self.Score.ValueRange.High := (string)in.Score_high;
  in_RC_temp := scout.services.functions.fromDelimited(in.reason_codes);
  self.Score := project(in_RC_temp, transform(scout.iesp.scout_search_detail.t_ScoutTransactionSearchScore,
                                              self.reasoncodes := project(left, transform(scout.iesp.share.t_StringArrayItem,
                                                                                                self.value := left.fieldvalues)),
                                              self := []));

	self := [];
End;


searchtemp := DATASET([formatsearch(getSearchRecord[1], filterBeginDate, filterEndDate)]);
search := searchtemp[1];

output(search, named('search'));

scout.iesp.scout_search_detail.t_ScoutTransactionSearchRequest formatrequest() := Transform
	self.SearchBy := search;
	self := [];
END;

in_rec_temp := dataset([formatrequest()]);
in_rec := in_rec_temp[1];

//Transform the options into the option layout
	scout.services.layouts.report_options Into_options() := transform
		self.Report_date_type := in_Report_type;
		self := [];
	end;
	
	options_temp := Dataset([Into_options()]);
	report_options := options_temp[1];

results2 := scout.services.AllLogReports.single_range_report_table(in_rec, report_options);
results6 := scout.services.AllLogReports.response_time_report(in_rec, report_options);
results3 := scout.services.AllLogReports.default_rc_report(in_rec, report_options);

maprec := record
	string freq;
	string val;
end;

output(baselineDate, named('baselineDate'));
output(varianceFreq, named('varianceFreq'));
output(noOfVarianceFreqs, named('noOfVarianceFreqs'));
output(filterBeginDate, named('filterBeginDate'));
output(filterEndDate, named('filterEndDate'));
output(alertBeginDate, named('alertBeginDate'));

VarianceResult := MAP(alert_type_id = 2 => scout.logs.util.MacroToFindVarianceForMeasure(results2, bin, varianceFreq, noOfVarianceFreqs, alertBeginDate, filterEndDate),
										  alert_type_id = 6 => scout.logs.util.MacroToFindVarianceForMeasure(results6, response_time, varianceFreq, noOfVarianceFreqs, alertBeginDate, filterEndDate),
											alert_type_id = 3 => scout.logs.util.MacroToFindVarianceForMeasure(results3, RC_C21, varianceFreq, noOfVarianceFreqs, alertBeginDate, filterEndDate),
											dataset([], maprec));

output(results3, named('results3'));
output(VarianceResult, named('VarianceResult'));
/*scout.logs.util.MacroToFindVarianceForMeasure(results2, bin, varienceDiff, referenceDataset, varianceFreq, noOfVarianceFreqs, alertBeginDate, filterEndDate);

output(referenceDataset, named('referenceDataset'));

output(varienceDiff, named('varienceDiff'));
*/

// -- alert_type_id  description                                         
// -- -------------  ----------------------------------------------------
// --             1  transaction volume change                            
// --             2  score/score band frequency change                   
// --             3  reason code/warning code/risk indicator frequency   
// --             4  data input field frequency change                   
// --             5  attribute distribution change                       
// --             6  response time change                                
// --             7  data restriction mask setting change               
// --             8  data permission mask setting change    
