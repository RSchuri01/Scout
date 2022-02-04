import std;

EXPORT scout_date := module

EXPORT layout:= RECORD
  integer4 date_sk;
  string10 date_dt;
  string11 date_sd;
  string32 date_ld;
  unsigned2 yr_num;
  unsigned1 half_yr_num;
  string9 half_yr_nam_sd;
  string32 half_yr_nam_ld;
  unsigned1 qtr_num;
  string2 qtr_nam_sd;
  string9 qtr_nam_ld;
  unsigned4 qtr_start_dt;
  unsigned4 qtr_end_dt;
  unsigned3 yr_qtr_num;
  string10 yr_qtr_nam_sd;
  string18 yr_qtr_nam_ld;
  unsigned1 mth_num;
  string5 mth_nam_sd;
  string9 mth_nam_ld;
  unsigned4 mth_end_dt;
  unsigned1 days_in_mth_num;
  unsigned3 yr_mth_num;
  string10 yr_mth_nam_sd;
  string24 yr_mth_nam_ld;
  unsigned2 days_in_yr_num;
  unsigned1 day_of_mth_num;
  unsigned1 day_of_wk_num;
  string5 day_of_wk_nam_sd;
  string10 day_of_wk_nam_ld;
  unsigned2 day_of_yr_num;
  unsigned1 wk_of_yr_num;
  unsigned4 wk_start_dt;
  unsigned4 wk_end_dt;
  string1 wkday_fl;
  string1 holiday_fl;
  string1 major_event_fl;
  unsigned4 first_seen_dt;
  unsigned4 last_seen_dt;
  string10 iso_wk_start_dt;
  string10 iso_wk_end_dt;
  integer8 iso_wk_num_of_year;
  integer8 ins_wk_num_of_month;
  integer8 ins_like_day;
  decimal3_2 ins_rev_day;
  decimal3_2 bsv_rev_day;
  decimal15_3 bsv_fcst_day_factor;
  integer4 iso_yr_num;
  string1 ln_holiday_fl;
  integer2 work_hours;
  string10 qtr_start_date;
  string10 qtr_end_date;
  string10 mth_start_date;
  string10 mth_end_date;
  string10 year_start_date;
  string10 year_end_date;
  integer8 iso_year_week_num;
  integer8 ins_lag_day;
  string10 ins_like_date;
 END;

shared string file_name := 'dim_date';

shared prefix := '~thor::red::dm';

export file := if( nothor(std.File.superfileexists(prefix + '::' + file_name)),
                   dataset(prefix + '::' + file_name, layout, thor),
									 dataset([ {-1,'',-1,'UNASSIGNED',0,0,'','',0,'','',0,0,0,'','',0,'','',0,0,0,'','',0,0,0,
																 '','',0,0,0,0,'','','',std.date.today(),std.date.today(),'','',0 ,0,0,0,0,0, 0,'',0,'','','','','','',0,0,''},
															{-2,'',-2,'NA',0,0,'','',0,'','',0,0,0,'','',0,'','',0,0,0,'','',0,0,0,
																 '','',0,0,0,0,'','','',std.date.today(),std.date.today(),'','',0,0,0,0,0,0,0,'',0,'','','','','','',0,0,''}	], layout ) 
																);									 

end;