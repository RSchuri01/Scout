import std;
import std.Date;
import scout.common.util.scout_date;

EXPORT dateutils := Module

export today 		:= std.Date.today();

export today_ym := (Integer)std.date.tostring(today,'%Y%m');

export date_math(INTEGER4 start_date, integer offset) := FUNCTION;

yr := (INTEGER2)((STRING8)start_date)[1..4];
mn := (UNSIGNED1)((STRING8)start_date)[5..6];
da := (UNSIGNED1)((STRING8)start_date)[7..8];

return (INTEGER4)date.FromDaysSince1900(date.DaysSince1900(yr,mn,da) + offset);

end;

export getDayName(Integer4 _today = today) := function
	return scout_date.file((integer4)date_sk = today)[1].day_of_wk_nam_ld;
end;

EXPORT getISOWkEnding(Integer iso_weeknum) := function
	return scout_date.file((integer4)(iso_yr_num + intformat(iso_wk_num_of_year, 2, 1)) = iso_weeknum)[1].iso_wk_end_dt;
end;

EXPORT getISOWkEndingNoHypen(Integer iso_weeknum) := function
    dateWithHypen := getISOWkEnding(iso_weeknum);
	dateWithOutHypen := std.str.findreplace(dateWithHypen,'-','');
	return (INTEGER4)dateWithOutHypen;
END;

EXPORT getISOWkEndingRangeNoHypen(Integer4 iso_begin_week, Integer4 iso_end_week) := FUNCTION
	REC := RECORD
		INTEGER4 ISO_WEEK_NUM;
		integer4 iso_Week_End_dt;
	END;
	
	DS := scout_date.file((integer4)((string)iso_yr_num + intformat(iso_wk_num_of_year, 2, 1)) >= iso_begin_week AND
							   (integer4)((string)iso_yr_num + intformat(iso_wk_num_of_year, 2, 1)) <= iso_end_week);
	
	PROJECTEDDS := PROJECT(DS,
						   TRANSFORM(REC,
						   			 SELF.ISO_WEEK_NUM 		:= (integer4)((string)LEFT.iso_yr_num + intformat(LEFT.iso_wk_num_of_year, 2, 1)); 
						   			 SELF.iso_Week_End_dt 	:= (integer4)std.str.findreplace(left.iso_wk_end_dt, '-','');
						   			 ));
	RETURN DEDUP(SORT(PROJECTEDDS, ISO_WEEK_NUM, iso_Week_End_dt), ISO_WEEK_NUM, iso_Week_End_dt);
END;


EXPORT getRecentNISOWeekNum(Integer4 numberOfWeeks, INTEGER4 fromDate = today) := FUNCTION
	REC := RECORD
		INTEGER4 ISO_WEEK_NUM;
	END;

	current_iso_wk_start := (INTEGER4)REGEXREPLACE('-',scout_date.file(date_sk = fromDate)[1].iso_wk_start_dt,'');

	X := PROJECT(TABLE(scout_date.file(date_sk < current_iso_wk_start), {iso_yr_num, iso_wk_num_of_year}, iso_yr_num, iso_wk_num_of_year),
				 TRANSFORM(REC,
				 		   SELF.ISO_WEEK_NUM := (INTEGER4)(((STRING)LEFT.iso_yr_num) + INTFORMAT(LEFT.iso_wk_num_of_year, 2, 1)))); 
			 		   
	RETURN TOPN(SORT(X, -ISO_WEEK_NUM), numberOfWeeks, -ISO_WEEK_NUM);
END;

EXPORT getRecentNISOWeekNumByWeekNum(Integer4 numberOfWeeks, INTEGER4 fromWeekNum, Boolean IncludeFromWeekNum) := FUNCTION
	REC := RECORD
		INTEGER4 ISO_WEEK_NUM;
	END;
	
	get_date_sk := scout_date.file((integer4)((string)iso_yr_num + intformat(iso_wk_num_of_year, 2, 1)) = fromWeekNum)[1].date_sk;
	return IF (IncludeFromWeekNum, getRecentNISOWeekNum(numberOfWeeks, get_date_sk) + Dataset([{fromWeekNum}], rec), getRecentNISOWeekNum(numberOfWeeks, get_date_sk));	
END;

/*EXPORT getAllDatesFrom(integer startDt, integer monthslookback) := FUNCTION
	gobackstart := (integer4)(red.common.util.dateutils.getPrevYearMonthByMonthAgo(red.common.util.dateutils.today_ym, monthslookback) + '01');
	RETURN SORT(TABLE(scout_date.file(date_sk <= red.common.util.dateutils.today and date_sk >= gobackstart), {DATE_SK}, DATE_SK), -DATE_SK);
END;
*/

export getISOWkForYr(integer4 fromYear, integer4 toYear = fromYear) := FUNCTION

d := scout_date.file;

x := table(d(iso_yr_num>=fromYear and iso_yr_num<=toYear), 
	  {iso_week := (integer4)((string)iso_yr_num + intformat(iso_wk_num_of_year, 2, 1))},
	  (integer4)((string)iso_yr_num + intformat(iso_wk_num_of_year, 2, 1)));
	  
return x;
end;

EXPORT getNRecentWeeks(integer4 numberOfWeeks, INTEGER4 fromDate = today) := FUNCTION
	
	REC := RECORD
		INTEGER4 iso_wk_start_dt;
	END;
	
	current_iso_wk_start := (INTEGER4)REGEXREPLACE('-',scout_date.file(date_sk = fromDate)[1].iso_wk_start_dt,'');
	
	X := PROJECT(TABLE(scout_date.file(date_sk < current_iso_wk_start), {iso_wk_start_dt}, iso_wk_start_dt),
				 TRANSFORM(REC,
				 		   SELF.ISO_WK_START_DT := (INTEGER4)REGEXREPLACE('-',LEFT.iso_wk_start_dt,'')));
				 		   
	RETURN TOPN(SORT(X, -iso_wk_start_dt), numberOfWeeks, -iso_wk_start_dt);
END;

EXPORT getCurrentISOWeek(integer4 _in_date_sk=today) := FUNCTION
TODAYREC := scout_date.file(date_sk = _in_date_sk)[1];
 
RETURN (INTEGER4)(TODAYREC.iso_yr_num + '' + intformat(TODAYREC.iso_wk_num_of_year, 2, 1));

END;

EXPORT getPrevWeekSameDay (string8 yyyymmdd = (string8)today) := function

	J1 := STD.Date.FromGregorianYMD((unsigned)yyyymmdd[1..4],(unsigned)yyyymmdd[5..6],(unsigned)yyyymmdd[7..8]);
	
	Y := STD.Date.ToGregorianYMD(j1-7).Year; 
	M := STD.Date.ToGregorianYMD(J1-7).Month; 
	D := STD.Date.ToGregorianYMD(j1-7).Day; 
	
	return (string)y + if(m<=9,'0','') +  (string)m + if(d<=9,'0','') +  (string)d;

end;

export getPrevISOWeekDate(String8 inDate = (STRING8)today) := function
	referenceDt := getPrevWeekSameDay(inDate);
	dt 			:= scout_date.file(date_sk = (integer4)referenceDt)[1];
	yr_iso_week := (INTEGER4)(dt.ISO_yr_num + intformat(dt.iso_wk_num_of_year, 2, 1));
	return yr_iso_week;
end;

export getISOWeekEndDt(INTEGER4 reference_iso_week) := function

integer3 year_num 	:= (integer3)((STRING6)reference_iso_week)[1..4];
integer2 week_num 	:= (integer2)((STRING6)reference_iso_week)[5..6];

iso_rec := scout_date.file(yr_num = year_num and iso_wk_num_of_year = week_num)[7];
get_iso_start_dt 	:= iso_rec.date_sk;

return (INTEGER4)get_iso_start_dt;

end;

export getISOWeekStartDt(INTEGER4 reference_iso_week) := function

integer3 year_num 	:= (integer3)((STRING6)reference_iso_week)[1..4];
integer2 week_num 	:= (integer2)((STRING6)reference_iso_week)[5..6];

iso_rec := scout_date.file(yr_num = year_num and iso_wk_num_of_year = week_num)[1];
get_iso_start_dt 	:= iso_rec.date_sk;

return (INTEGER4)get_iso_start_dt;

end;

export getRecentClosedWeekBeginEndDt(integer4 reference_iso_week = 0) := function

iso_week_to_get_info := if (reference_iso_week = 0, getPrevISOWeekDate(), reference_iso_week);

rec := RECORD
		INTEGER4 begin_dt;
		integer4 end_dt;
END;

return dataset([{getISOWeekStartDt(iso_week_to_get_info), getISOWeekEndDt(iso_week_to_get_info)}], rec);

end;


/* Ahead go with + number and behind go with -ve number */
export getISOWeek(INTEGER4 reference_iso_week, integer2 num_of_weeks_ahead_or_behind) := function

get_iso_start_dt 	:= getISOWeekStartDt(reference_iso_week);
get_hist_day 		:= date_math(get_iso_start_dt, 7 * num_of_weeks_ahead_or_behind);

x := scout_date.file(date_sk = (integer4)get_hist_day)[1];
return x.iso_year_week_num;//(INTEGER4)(x.yr_num + '' + intformat(x.iso_wk_num_of_year, 2, 1));

end;

EXPORT getYesterday (string8 yyyymmdd) := function

	J1 := STD.Date.FromGregorianYMD((unsigned)yyyymmdd[1..4],(unsigned)yyyymmdd[5..6],(unsigned)yyyymmdd[7..8]);
	
	Y := STD.Date.ToGregorianYMD(j1-1).Year; 
	M := STD.Date.ToGregorianYMD(J1-1).Month; 
	D := STD.Date.ToGregorianYMD(j1-1).Day; 
	
	return (string)y + if(m<=9,'0','') +  (string)m + if(d<=9,'0','') +  (string)d;
end;

EXPORT getTomorrow (string8 yyyymmdd) := function

	J1 := STD.Date.FromGregorianYMD((unsigned)yyyymmdd[1..4],(unsigned)yyyymmdd[5..6],(unsigned)yyyymmdd[7..8]);
	
	Y := STD.Date.ToGregorianYMD(j1+1).Year; 
	M := STD.Date.ToGregorianYMD(J1+1).Month; 
	D := STD.Date.ToGregorianYMD(j1+1).Day; 
	
	return (string)y + if(m<=9,'0','') +  (string)m + if(d<=9,'0','') +  (string)d;
end;

export yesterday() := function
	return getYesterday((String8)today);  
end;

EXPORT getPaddedValue(String x) := Function
return if (length(x) < 2, (Integer)'00' + x, x);
End;

EXPORT monthsBetween2(UNSIGNED4 lower, UNSIGNED4 upper) := FUNCTION
    years 	:= (INTEGER)(UPPER / 100) - (INTEGER)(LOWER/100);
    months 	:= (INTEGER)(UPPER % 100) - (INTEGER)(LOWER%100);
    result	:= years * 12 + months;
    RETURN result;
END;

EXPORT monthsBetween(UNSIGNED4 lower, UNSIGNED4 upper) := FUNCTION
    years 	:= std.Date.Year(upper) - std.Date.Year(lower);
    months 	:= std.Date.Month(upper) - std.Date.Month(lower);
    result	:= years * 12 + months;
    RETURN result;
END;

EXPORT monthsDiff(UNSIGNED4 lower, UNSIGNED4 upper) := FUNCTION
		
		Integer LowerYear 	:= (Integer)(((String)lower)[1..6])/100;
		Integer LowerMonth := (Integer)(((String)lower)[5..6]);

		Integer upperYear 	:= (Integer)(((String)upper)[1..6])/100;
		Integer upperMonth := (Integer)(((String)upper)[5..6]);
		
    years 	:= upperYear - LowerYear;
    months 	:= upperMonth - LowerMonth;
    result	:= years * 12 + months;
		
    RETURN result;
END;

EXPORT getMilitaryHour(String x, String AMPM) := Function
	MilitaryHour := if (std.str.tolowercase(AMPM) = 'am' and (Integer) x = 12, 0, ((Integer) x + if (std.str.tolowercase(AMPM) = 'pm' and (Integer)x < 12, 12, 0)));
	return MilitaryHour;
End;

EXPORT getDateWithTimeStamp(String strDate) := function
	searchPattern := '^(.*)/(.*)/(.*) (.*):(.*):(.*) (AM|PM)';
	// strDate := '4/28/2010 12:47:50 PM';

	Month 	:= REGEXFIND(searchPattern, strDate, 1);
	Day	 		:= REGEXFIND(searchPattern, strDate, 2);
	Year		:= REGEXFIND(searchPattern, strDate, 3);
	Hour		:= REGEXFIND(searchPattern, strDate, 4);
	Minute	:= REGEXFIND(searchPattern, strDate, 5);
	seconds	:= REGEXFIND(searchPattern, strDate, 6);
	AMPM		:= REGEXFIND(searchPattern, strDate, 7);

  militaryHour := (String)getMilitaryHour(hour, AMPM);
	
//	NewHour := IF (std.str.tolowercase(ampm) = 'am' and Hour = '12' and minute = '00' and seconds = '00', '00', militaryHour);
	
	return Year + getPaddedValue(Month) + getPaddedValue(day) + getPaddedValue(militaryHour) + getPaddedValue(minute) + getPaddedValue(seconds); 

End;

export getdatewithoptionaltimestamp(string strdate) := function

	strdatetime := if(regexfind('^\\d\\d?/\\d\\d?/\\d\\d\\d\\d$',trim(strdate)),trim(strdate) + ' 12:00:00 AM',strdate);
	
	searchpattern := '^(\\d\\d?)/(\\d\\d?)/(\\d\\d\\d\\d) (\\d\\d?):([0-5]\\d):([0-5]\\d) (AM|PM)';
	// strDate := '4/28/2010 12:47:50 PM';

	month 	:= regexfind(searchpattern, strdatetime, 1);
	day	 		:= regexfind(searchpattern, strdatetime, 2);
	year		:= regexfind(searchpattern, strdatetime, 3);
	hour		:= regexfind(searchpattern, strdatetime, 4);
	minute	:= regexfind(searchpattern, strdatetime, 5);
	seconds	:= regexfind(searchpattern, strdatetime, 6);
	ampm		:= regexfind(searchpattern, strdatetime, 7);
	
  militaryhour := (string)getmilitaryhour(hour, ampm);
		
	return year + getpaddedvalue(month) + getpaddedvalue(day) + getpaddedvalue(militaryhour) + getpaddedvalue(minute) + getpaddedvalue(seconds); 
end;



EXPORT getDateHHMMSS(String strDate) := function
	return getDateWithTimeStamp(strDate)[9..14];
End;

EXPORT getDateYYYYMMDD(String strDate) := function
	return getDateWithTimeStamp(strDate)[1..8];
End;

EXPORT integer8 DaysApart(string8 d1, string8 d2) := Function
		return abs(Date.DaysSince1900((integer2)(d1[1..4]), (integer1)(d1[5..6]), (integer1)(d1[7..8])) -
		Date.DaysSince1900((integer2)(d2[1..4]), (integer1)(d2[5..6]), (integer1)(d2[7..8])));
End;


EXPORT boolean checkDates(String LowDate, String HighDate) := function
	
	Ldate := (Integer)getDateYYYYMMDD(LowDate);
	Hdate := (Integer)getDateYYYYMMDD(HighDate);

	LTStamp := (Integer)getDateHHMMSS(LowDate);
	HTStamp := (Integer)getDateHHMMSS(HighDate);
	
	return IF ( Hdate - Ldate < 0, False, 
							IF (Hdate = Ldate and HTStamp - LTStamp < 0, False, True));
	
End;

EXPORT String getMinutes (String LowDate, String HighDate) := Function

	Low_Dt_TimeStamp := getDateYYYYMMDD(LowDate) + getDateHHMMSS(LowDate);
	High_Dt_TimeStamp := getDateYYYYMMDD(HighDate) + getDateHHMMSS(HighDate);

	daysElapsed := DaysApart(Low_Dt_TimeStamp[1..8],High_Dt_TimeStamp[1..8]);
	HoursDiff 	:= (Integer)High_Dt_TimeStamp[9..10] - (Integer)Low_Dt_TimeStamp[9..10];
	MinsDiff 		:= (Integer)High_Dt_TimeStamp[11..12] - (Integer)Low_Dt_TimeStamp[11..12];
	SecondsDiff := (Integer)High_Dt_TimeStamp[13..14] - (Integer)Low_Dt_TimeStamp[13..14];
	
	secondsElapsed := daysElapsed * 24 * 60 * 60 + HoursDiff * 60 * 60 + MinsDiff * 60 + secondsDiff;

	Mins := IF (checkDates(LowDate, HighDate) = False, 0, secondsElapsed);
	
	return Trim(REALFORMAT((Mins / 60), 10,2),ALL);
End;

EXPORT getdatefromtimestamp(String x) := FUNCTION
	RemoveHypen := IF (std.str.contains(x, '-', True), std.str.filterout(x, '-'), x);
	RemoveColon := IF (std.str.contains(RemoveHypen, ':', True), std.str.filterout(RemoveHypen, ':'), RemoveHypen);
	RemoveSlash	:= IF (std.str.contains(RemoveColon, '/', True), std.str.filterout(RemoveColon, '/'), removeColon);
	RETURN (Integer) TRIM(REMOVESLASH, ALL)[0..8];
END;

EXPORT isdatewithin(Integer beginDt, Integer endDt, Integer dateToBeChecked) := Function
	RETURN IF (dateToBeChecked >= beginDt and dateToBeChecked <= endDt, True, False);
END;

EXPORT istimestampwithin(String beginDt, String endDt, String dateToBeChecked) := Function
	RETURN IF (getdatefromtimestamp(dateToBeChecked) >= getdatefromtimestamp(beginDt) and getdatefromtimestamp(dateToBeChecked) < getdatefromtimestamp(endDt), True, False);
END;

EXPORT getYear(Integer YearMonth) := FUNCTION
 return (YearMonth / 100);
END;

EXPORT getPrevYearMonth(Integer yearMonth = today_ym) := FUNCTION

	Integer Year 	:= yearMonth/100;
	Integer Month := (Integer)(((String)yearmonth)[5..6]);

	RETURN (INTEGER)(IF ((Month - 1) = 0, (String)(Year - 1) + '12', (String)Year + INTFORMAT(Month - 1, 2, 1)));
END;

EXPORT getPrevYearMonthByMonthAgo(Integer yearMonth, Integer numberOfMonthsAgo) := FUNCTION

	Integer Year 	:= yearMonth/100;
	Integer Month := (Integer)(((String)yearmonth)[5..6]);
  
	YrDiff 		:= numberOfMonthsAgo Div 12;
	monthDiff := numberOfMonthsAgo % 12;
	
	monthDiff2 := Month - monthDiff;
	
	yearDiff2  := IF (monthDiff2 <= 0, (year - yrDiff - 1), (year - yrDiff));

	newYrMonth := yearDiff2 * 100 + IF (monthDiff2  <= 0, 12 + monthDiff2, monthDiff2);
	
	RETURN (INTEGER)newYrMonth;
END;

EXPORT getNextYearMonthByMonths(Integer yearMonth, Integer numberOfMonthsMore) := FUNCTION

	Integer Year 	:= yearMonth/100; 
	Integer Month := (Integer)(((String)yearmonth)[5..6]); 
  
	YrDiff 		:= numberOfMonthsMore Div 12; 
	monthDiff := numberOfMonthsMore % 12; 
	
	monthDiff2 := Month + monthDiff; 
	
	yearDiff2  := IF (monthDiff2 = 12, (year + yrDiff), IF (monthDiff2 >= 12, (year + yrDiff + 1), (year + yrDiff))); 

	newYrMonth := yearDiff2 * 100 + IF (monthDiff2 =12, 12, IF (monthDiff2 >=12, monthDiff2 - 12, monthDiff2)); 
	
	RETURN (INTEGER)newYrMonth; 
END; 

EXPORT getPriorYr(Integer lookBackYr = 1) := function
		currYr	:= std.date.toString(std.Date.today(),'%Y');
		return (Integer)currYr - lookBackYr;
end;

EXPORT getCurrentYrBegin() := function
		currYr				:= std.date.toString(std.Date.today(),'%Y');
		return (Integer)currYr + '01';
end;

EXPORT getCurrentYr() := function
	return std.date.toString(std.Date.today(),'%Y');
end;

EXPORT getCurrentYrEnd() := function
		currYr				:= std.date.toString(std.Date.today(),'%Y');
		return (Integer)currYr + '01';
end;
	
EXPORT getPriorYrBegin(Integer lookBackYr = 1) := function
		currYr				:= std.date.toString(std.Date.today(),'%Y');
		return (Integer)currYr - lookBackYr + '01';
end;
	
EXPORT getPriorYrEnd(Integer lookBackYr = 1) := function
		currYr				:= std.date.toString(std.Date.today(),'%Y');
		return (Integer)currYr - lookBackYr + '12';
end;

EXPORT ValidDate (STRING8 InDate) := FUNCTION

 in_Year 					    := (INTEGER) InDate [1..4];
 l_range   		        := (INTEGER) 1000;
 BOOLEAN isValidYear 	:= IF (in_Year >= l_range, TRUE, FALSE);
 BOOLEAN isValidMonth	:= IF (InDate [5..6] between '01' and '12', TRUE, FALSE);
 BOOLEAN isValidDay 	:= MAP ((InDate [5..6] = '01') AND (InDate [7..8] between '01' and '31') => TRUE,
											(Std.Date.IsLeapYear(in_Year) and  InDate [5..6] = '02') AND (InDate [7..8] between '01' and '29') => TRUE,
											(~Std.Date.IsLeapYear(in_Year) and  InDate [5..6] = '02') AND (InDate [7..8] between '01' and '28') => TRUE,
																					(InDate [5..6] = '03') AND (InDate [7..8] between '01' and '31') => TRUE,
																					(InDate [5..6] = '04') AND (InDate [7..8] between '01' and '30') => TRUE,
																					(InDate [5..6] = '05') AND (InDate [7..8] between '01' and '31') => TRUE,
																					(InDate [5..6] = '06') AND (InDate [7..8] between '01' and '30') => TRUE,
																					(InDate [5..6] = '07') AND (InDate [7..8] between '01' and '31') => TRUE,
																					(InDate [5..6] = '08') AND (InDate [7..8] between '01' and '31') => TRUE,
																					(InDate [5..6] = '09') AND (InDate [7..8] between '01' and '30') => TRUE,
																					(InDate [5..6] = '10') AND (InDate [7..8] between '01' and '31') => TRUE,
																					(InDate [5..6] = '11') AND (InDate [7..8] between '01' and '30') => TRUE,
																					(InDate [5..6] = '12') AND (InDate [7..8] between '01' and '31') => TRUE,
																																																							FALSE
 ); 

 IsValidDate := IF((IsValidYear AND IsValidMonth AND IsValidDay), TRUE, FALSE); 
 
//		 IsValidDate := IsValidYear AND IsValidMonth AND IsValidDay;
								
 RETURN IsValidDate;
 END;

EXPORT LastDayOfMonthStr (STRING8 InDate) := FUNCTION
	
LastDate := if (ValidDate(InDate[1..6] + '31'),
		                 InDate[1..6] + '31',
										 If (ValidDate(InDate[1..6] + '30'),
												 InDate[1..6] + '30',
												 If (ValidDate(InDate[1..6] + '29'),
												     InDate[1..6] + '29',
														 InDate[1..6] + '28')));
RETURN LastDate;
END;	

EXPORT LastDayOfMonth (INTEGER3 InDate) := FUNCTION
RETURN LastDayOfMonthStr((String6)InDate);
END;

EXPORT getMonthName(STRING2 MONTH, BOOLEAN longname=False) := FUNCTION
	
	INTEGER inmonth := (INTEGER) MONTH;
	
	STRING monthname := CASE (inmonth, 1 => 'January', 
																		2 => 'February',
																		3 => 'March',
																		4 => 'April',
																		5 => 'May', 
																		6 => 'June',
																		7 => 'July',
																		8 => 'August',
																		9 => 'September',
																		10 => 'October',
																		11 => 'November',
																		12 => 'December',
																		'');
	
	checkandreturn := IF (INMONTH <= 0 OR INMONTH > 12, error('MONTH HAS TO BE BETWEEN 01 - 12 OR 1 - 12'), 
										if (longname, monthname, monthname[1..3]));
	
  RETURN checkandreturn;

END;

export isDaylightTime(string d) := function
	
	year 	:= (Integer2) (d[1..4]);
	day 	:= (unsigned1) (d[9..10]);
	month := (unsigned1) (d[6..7]);

	unsigned1 dayofweek := std.date.DaysSince1900(year,month,day) % 7;

	
	return MAP( month >= 4 and month <= 10 			=> TRUE,
		          month = 12 or month <= 2 				=> FALSE,
							month = 11 => MAP(day > 6 						=> FALSE,
							                  day - dayofweek > 0 => FALSE,
																TRUE),
							MAP( day > 13 							=> TRUE,
							     day < 8 								=> FALSE,
									 day-7 - dayofweek > 0 	=> TRUE,
									 FALSE ) );
end;

EXPORT getESTFromGMT(String date, Integer dstadjust) := FUNCTION

//Right now the assumed input date format is YYYY-MM-DD HH:MM:SS'

datestr := std.date.convertFormat(date[1..10], '%Y-%m-%d', '%Y%m%d');
hour		:= (integer1)date[12..13];

est_hour := if (hour < dstadjust, (24 - dstadjust) + hour, hour - dstadjust);

est_datestr := if (hour < dstadjust, getYesterday(datestr), datestr);

return std.date.convertFormat(est_datestr, '%Y%m%d', '%Y-%m-%d') + ' ' + intformat(est_hour, 2, 1) + date[14..];

end;

EXPORT ConvertGMTtoEST(STRING Input_DateTime) := FUNCTION

	date := input_datetime[1..10];
	
	hour := (unsigned1)input_datetime[12..13];
	
	boolean isdaylight := isDaylightTime(date);
	
	return if (isdaylight, getESTFromGMT(input_datetime, 4), getESTFromGMT(input_datetime, 5));
	

END;


 export getnextdate (string8 yyyymmdd) := function

	J1 := STD.Date.FromGregorianYMD((unsigned)yyyymmdd[1..4],(unsigned)yyyymmdd[5..6],(unsigned)yyyymmdd[7..8]);
	
	Y := STD.Date.ToGregorianYMD(j1+1).Year; 
	M := STD.Date.ToGregorianYMD(J1+1).Month; 
	D := STD.Date.ToGregorianYMD(j1+1).Day; 
	
	return (string)y + if(m<=9,'0','') +  (string)m + if(d<=9,'0','') +  (string)d;

end;

	export get_date_sk (string22 yyyymmdd, integer1 zero_sk = -1) := function
			date_sk := (integer) getDateWithTimeStamp(yyyymmdd)[1..8];
			return if (date_sk = 0, zero_sk, date_sk);
end;

export string ConvertDateFormatMultipleFido (string date_text, set of varstring from_formats, varstring to_format='%Y%m%d') :=
		if(date_text = '', '', std.date.ConvertFormatMultiple(date_text, from_formats, to_format));


export getSecondsBetweenTime(integer8 time1, integer8 time2) := function
  string t1 := if(intformat(time1, 6, 1) = '******', '000000', intformat(time1, 6, 1));
  string t2 := if(intformat(time2, 6, 1) = '******', '000000', intformat(time2, 6, 1));
  
  integer t1_seconds := ((integer8)t1[1..2] * 60 * 60) + ((integer8)t1[3..4] * 60) + ((integer8)t1[5..6]);
  integer t2_seconds := ((integer8)t2[1..2] * 60 * 60) + ((integer8)t2[3..4] * 60) + ((integer8)t2[5..6]);
  
	return t1_seconds - t2_seconds;
end;

export getSecondsToHours(integer8 seconds) := function
	return (decimal11_4)seconds/60/60;
end;

export getSecondsFromTime(string19 time) := function
  integer4 am_pm := if(time[10..11] = 'AM', 0, 43200);
  
  integer4 hours := if(time[1..2] = '12', 0, (integer4)time[1..2] * 60 * 60);
  
  integer4 minutes := (integer4)time[4..5] * 60;
  
  integer4 seconds := (integer4)time[7..8];
  
  return am_pm + hours + minutes + seconds;
end;

export getTodayStringFormat(boolean end_of_day) := function
  string time := if(end_of_day, '23:59:59', '00:00:00');

	return ((string19)date.today())[1..4] + '-' + ((string19)date.today())[5..6] + '-' + ((string19)date.today())[7..8] + ' ' + time;
end;

export ConvertSiebelToSQL(string100 siebel_datetime) := function
  string10 sql_date := siebel_datetime[7..10] + '-' + siebel_datetime[1..2] + '-' + siebel_datetime[4..5];
  
  string8 sql_time := if(siebel_datetime[21..22] = 'PM', 
                          if(siebel_datetime[12..13] = '12', '12',(string2)((integer4)siebel_datetime[12..13] + 12)),
                            siebel_datetime[12..13])
                        + ':' + siebel_datetime[15..16] + ':' + siebel_datetime[18..19];
                          
  return if(siebel_datetime = '', '', sql_date + ' ' + sql_time);
end;


	export fn_add_months(integer4 date_sk, integer4 months_add) := function
		/* split all date sections */
		integer4 year := (integer4)((string)date_sk)[1..4];
		integer4 month := (integer4)((string)date_sk)[5..6];
		integer4 day := (integer4)((string)date_sk)[7..8];
		
		integer4 total_months := month + months_add;
		
		/* set final date sections */
		integer4 final_year := year + (total_months div 12);
		integer4 final_month := total_months % 12;

		return (integer4)((string)final_year + getPaddedValue((string)final_month) + getPaddedValue((string)day));
	end;
	
	export fn_add_one_day(integer4 date_sk) := function
		/* split all date sections */
		integer4 year := (integer4)((string)date_sk)[1..4];
		integer4 month := (integer4)((string)date_sk)[5..6];
		integer4 day := (integer4)((string)date_sk)[7..8];
		
		integer4 days_in_month := if(month = 2, 
											if(year % 4 = 0, 29, 28),
												if(month in [1,3,5,7,10,12], 31, 30));
		
		integer4 total_days := if(day = days_in_month, 1, day + 1);
		integer4 total_months := if(total_days = 1, 
															if(month = 12, 1, month + 1), 
																month);
		integer4 total_years := if(total_months = 1 and total_days = 1, year + 1, year);
	
		return (integer4)((string)total_years + getPaddedValue((string)total_months) + getPaddedValue((string)total_days));
	end;
	
	export fn_subtract_one_day(integer4 date_sk) := function
		/* split all date sections */
		integer4 year := (integer4)((string)date_sk)[1..4];
		integer4 month := (integer4)((string)date_sk)[5..6];
		integer4 day := (integer4)((string)date_sk)[7..8];

		integer new_year := if(month = 1 and day = 1, year - 1, year);
		
		integer4 new_month := if(day = 1, 
															if(month = 1, 12, month - 1), 
																month);

		integer4 days_in_month := if(new_month = 2, 
											if(new_year % 4 = 0, 29, 28),
												if(new_month in [1,3,5,7,10,12], 31, 30));
		
		integer4 new_day := if(day = 1, days_in_month, day - 1);
	
		return (integer4)((string)new_year + getPaddedValue((string)new_month) + getPaddedValue((string)new_day));
	end;

	export boolean fn_is_valid_sql_date(string input_date) := function
		/* format '2016-11-11 08:22:00'  */
		
		string4 year := input_date[1..4];
		string2 month := input_date[6..7];
		string2 day := input_date[9..10];
		string2 hour := input_date[12..13];
		string2 minute := input_date[15..16];
		string2 second := input_date[18..19];
		
		boolean is_valid_format := if(year not between '1900' and '9999', false,
									if(input_date[5..5] != '-', false,
										if(month not between '01' and '12', false,
											if(input_date[8..8] != '-', false,
												if(day not between '01' and '31', false,
													if(input_date[11..11] != ' ', false,
														if(hour not between '00' and '23', false,
															if(input_date[14..14] != ':', false,
																if(minute not between '00' and '59', false,
																	if(input_date[17..17] != ':', false,
																		if(second not between '00' and '59', false,
											true)))))))))));
		
		boolean is_valid_day := if((integer)month = 2, 
											if((integer)year % 4 = 0, 29, 28),
												if((integer)month in [1,3,5,7,10,12], 31, 30));
												
		return if(is_valid_format and is_valid_day, true, false);
	end;


	export fn_convert_to_gmt(string input_datetime, string3 timezone) := function
		// string input_datetime := '2017-01-05 11:28:42.687';
		// string input_datetime := '2017-01-05 20:28:42.687';
		// string input_datetime := '2017-01-31 20:28:42.687';
		// string input_datetime := '2017-04-28 11:28:42.687';
		// string input_datetime := '2017-04-30 22:28:42.687';
		// string3 timezone := 'EST';
	
		/** right now coded just for EST, add code as needed **/
		
		integer4 year := (integer4)input_datetime[1..4];
		integer4 month := (integer4)input_datetime[6..7];
		integer4 day := (integer4)input_datetime[9..10];
		integer4 hour := (integer4)input_datetime[12..13];
		
		string extended_info := input_datetime[14..100];
		
		boolean daylight_savings := isDaylightTime(input_datetime);
		integer4 offset_timezone := if(timezone='EST', -5, 0);
		integer4 offset := if(daylight_savings, offset_timezone + 1, offset_timezone);
		
		boolean add_day := if(hour+abs(offset) > 23, true, false);
		
		integer4 days_in_month := if(month = 2, 
											if(year % 4 = 0, 29, 28),
												if(month in [1,3,5,7,8,10,12], 31, 30));
												
		integer4 new_hour := if(add_day, hour+abs(offset)-24, hour+abs(offset));
		integer4 new_year := if(add_day and month=12 and day=31, year + 1, year);
		integer4 new_month := if(add_day and days_in_month = day,
														if(month = 12, 1, month + 1), month);
		
		integer4 days_in_new_month := if(new_month = 2, 
											if(year % 4 = 0, 29, 28),
												if(new_month in [1,3,5,7,8,10,12], 31, 30));
		
		integer4 new_day := if(add_day,
													if(days_in_month = day, 1, day + 1), day);
													
		return getPaddedValue((string)new_year) + '-' + getPaddedValue((string)new_month) + '-' + getPaddedValue((string)new_day) + ' ' +
						getPaddedValue((string)new_hour) + extended_info;
	end;

    EXPORT twoyearsback := ((integer4)sort(getNRecentWeeks(106, today), iso_wk_start_dt)[1].iso_wk_start_dt);
		
		EXPORT twoyearsback_new := Date.DatesForWeek(Date.AdjustDate(Date.Today(), day_delta := -742)).startDate;

end;

