import scout;

EXPORT Spray_Constants(STRING sFileName		 	= '',
												STRING build_date 	= '',
												STRING SourceName 	= '',
												STRING Frequency 		= '',  
												STRING File_Date 		= '', 
												STRING SrcQuote 		= '"',
												STRING SrcSeparator = '\t' ) := MODULE

  	EXPORT sProdID           	:= 'scout';
	EXPORT wuid              	:= WorkUnit;
	EXPORT FileSeparator		:= '\\';
	EXPORT FileNameCov			:= '**';
	EXPORT RecordTerminator  	:= ['\n','\r\n','\n\r'];
	EXPORT RecordQuote		 	:= SrcQuote;
	EXPORT FieldSeparator    	:= SrcSeparator;

	EXPORT devlandingzone    	:= '10.48.76.98';

	EXPORT prodLandingZone	 	:= '10.194.83.41'; //'10.195.93.54';

	EXPORT analyticsProdLZ		:= '10.195.88.211'; 
	
	EXPORT LandingZone			:= if(scout.common.stored_env='prod', prodLandingZone, devLandingZone);

	SHARED DIR_SourceName		:= If(TRIM(SourceName,left,right) <> '', FileSeparator + TRIM(SourceName,left,right),'');
	SHARED DIR_Frequency		:= If(TRIM(Frequency,left,right) <> '',  FileSeparator + TRIM(Frequency,left,right), FileSeparator + 'daily');
	SHARED Thor_Frequency		:= If(TRIM(Frequency,left,right) <> '',  '::' + TRIM(Frequency,left,right),'');
	SHARED DIR_File_Date		:= If(TRIM(File_Date,left,right) <> '',  FileSeparator + TRIM(File_Date,left,right),'');
  
  	EXPORT processDir        	:= if(scout.common.stored_env='dev2','C:','D:') + '\\scout\\data\\inbound'+ DIR_SourceName + DIR_Frequency + '\\working' + DIR_File_Date;

	EXPORT processfile       	:= processDir + FileSeparator + TRIM(sFileName,left,right); 

	EXPORT spray_str 			:= '~thor::' + sProdID + '::spray::' + SourceName + thor_frequency + '::' + File_Date;
		
	EXPORT spray_file 		 	:= spray_str + '::' + sFileName;
	
	EXPORT spray_subfile		:= spray_file + '_'+ wuid;
END;