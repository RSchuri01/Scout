Export MacroToFindVarianceForMeasure(measureDataSet, measureField, varienceDiff, varienceFreq, noOfvarienceFreqs) := Macro

IMPORT scout;

#UNIQUENAME(dimDate);

#UNIQUENAME(joinData);

#UNIQUENAME(aggregateData);

#UNIQUENAME(prevWeekVarience);


%dimDate% := scout.common.util.scout_date.file;

%joinData% := Join(measureDataset, %dimDate%, left.date = right.date_sk);

%readyInput% := Project(%joinData%, transform(recordof(left), self.measureField := regexreplace('%', Left.measureField, ''); self := left));

%aggregateData% := 

     CASE(STD.STR.toUppercase(varienceFreq),
        'WEEKLY' => Sort(Table(%readyInput%, {iso_wk_num_of_year, decimal32_16 variance := sum(group, (Integer)value)}, iso_wk_num_of_year), -iso_wk_num_of_year),
        'MONTHLY' =>  Sort(Table(%readyInput%, {yr_mth_num, decimal32_16 variance := sum(group, (Integer)value)}, yr_mth_num), -yr_mth_num),
         Sort(Table(%readyInput%, {iso_wk_num_of_year, decimal32_16 variance := sum(group, (Integer)value)}, iso_wk_num_of_year), -iso_wk_num_of_year)
      );

%prevWeekVarience% := SUM(%aggregateData%[2 .. noOfvarienceFreqs + 1], (decimal32_16)measureField) / noOfvarienceFreqs;

varienceDiff := (decimal32_16)%aggregateData%[1].variance - (decimal32_16)%prevWeekVarience% ;

endMacro;