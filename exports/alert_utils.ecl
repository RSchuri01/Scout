
EXPORT alert_utils := MODULE

IMPORT SCOUT;
IMPORT SCOUT.exports AS exps;
import std;
import scout.common;
import * from scout.iesp.scout_search_detail;

export 	scout.services.layouts.report_options Into_options(String in_Report_type) := transform
	self.Report_date_type := in_Report_type;
	self := [];
end;

EXPORT t_ScoutTransactionSearchRequest formatrequest(t_ScoutTransactionSearchSearchBy search) := Transform
	self.SearchBy := search;
	self := [];
END;

EXPORT scout.iesp.scout_search_detail.t_ScoutTransactionSearchSearchBy formatsearch(exps.layout.alert_parameters in, 
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


	self.Score.ValueRange.Low := if (in.score_low = 0 and std.str.touppercase(in.esp_method_name) not in common.app_constants.ZeroAsValidScoreProducts, '', (string)in.score_low);
	self.Score.ValueRange.High := if (in.score_high = 0 and std.str.touppercase(in.esp_method_name) not in common.app_constants.ZeroAsValidScoreProducts, '', (string)in.score_high);
	
  // in_RC_temp := scout.services.functions.fromDelimited(in.reason_codes);
  in_RC_temp := scout.services.functions.fromDelimited(''); // Leave this Blank in order to get all records with all reasoncodes.
  self.Score := project(in_RC_temp, transform(scout.iesp.scout_search_detail.t_ScoutTransactionSearchScore,
                                              self.reasoncodes := project(left, transform(scout.iesp.share.t_StringArrayItem,
                                                                                                self.value := left.fieldvalues)),
                                              self := []));

	self := [];
End;



EXPORT getAlertDates(String frequency, integer noOfFrequencyLookBack, String baselineDate) := function

	rec := record
		integer4 filterBeginDate;
		integer4 alertPeriodBeginDate;
		integer4 filterEndDate;
	end;

	stored_iso_yr_week 	:= (integer4)scout.common.stored_alert_iso_yr_week;
	stored_yr_month 		:= (integer4)scout.common.stored_alert_yr_month;
	
	recentClosedWeek := if (stored_iso_yr_week <> 0, stored_iso_yr_week, scout.common.util.dateutils.getPrevISOWeekDate());

	p1 := output(recentClosedWeek, named('recentClosedWeek'));
	
	weeksBehindISOWeek := scout.common.util.dateutils.getISOWeek(recentClosedWeek, -noOfFrequencyLookBack);

	p2 := output(weeksBehindISOWeek, named('weeksBehindISOWeek'));

	WeekfilterBeginDate	:= scout.common.util.dateutils.getRecentClosedWeekBeginEndDt(weeksBehindISOWeek)[1].Begin_Dt;

	p3 := output(WeekfilterBeginDate, named('WeekfilterBeginDate'));

	WeekBeginDate 			:= scout.common.util.dateutils.getRecentClosedWeekBeginEndDt(recentClosedWeek)[1].Begin_Dt;

	p4 := output(WeekBeginDate, named('WeekBeginDate'));

	WeekEndDate	 				:= scout.common.util.dateutils.getTomorrow((string)scout.common.util.dateutils.getRecentClosedWeekBeginEndDt(recentClosedWeek)[1].End_dt);

	p5 := output(WeekEndDate, named('WeekEndDate'));

	recentClosedMonth 		 := if (stored_yr_month <> 0, stored_yr_month, scout.common.util.dateutils.getPrevYearMonth(stored_yr_month));
	recentClosedMonthBegin := scout.common.util.dateutils.getPrevYearMonth(stored_yr_month) + '01';
	prevBaseLineMonthBegin := scout.common.util.dateutils.getPrevYearMonthByMonthAgo(recentClosedMonth, noOfFrequencyLookBack) + '01';
	//LastDayOfTheMonth 	 := scout.common.util.dateutils.LastDayOfMonth(recentClosedMonth);
	alertMonthEnd			 		 := scout.common.util.dateutils.today_ym + '01';

	alertFilterBegingDate := if (baselineDate <> '', (integer4)baselineDate,
																	(MAP (std.str.ToUppercase(frequency) = 'WEEKLY'  => (integer4)WeekfilterBeginDate, 
																				std.str.ToUppercase(frequency) = 'MONTHLY' => (integer4)prevBaseLineMonthBegin,
																				0)));

	p6 := output(alertFilterBegingDate, named('alertFilterBegingDate'));
	
	alertBegingDate 			:= 	MAP (std.str.ToUppercase(frequency) = 'WEEKLY'  => (integer4)WeekBeginDate, 
																 std.str.ToUppercase(frequency) = 'MONTHLY' => (integer4)recentClosedMonthBegin,
																 0);
	
	p7 := output(alertBegingDate, named('alertBegingDate'));
	
	alerEndDate 					:= 	MAP (std.str.ToUppercase(frequency) = 'WEEKLY'  => (integer4)WeekEndDate, 
																 std.str.ToUppercase(frequency) = 'MONTHLY' => (integer4)alertMonthEnd,
																 0);
	
	p8 := output(alerEndDate, named('alerEndDate'));
	
	weeklyprintout := sequential(p1, p2, p3, p4, p5, p6, p7, p8);
	
	//return sequential(weeklyprintout);
	return Dataset([{alertFilterBegingDate, alertBegingDate, alerEndDate}], rec);

END;

END;