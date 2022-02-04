import file, system from std;
import * from $;
// This attribute has functions: pull data from the landing zone and spray the data on thor.

EXPORT Build_Exports(STRING build_date='', 
                     STRING bFileName='', 
										 STRING SourceName = '', 
										 STRING Frequency = '',  
										 STRING File_Date = '',
										 STRING SrcQuote = '',
										 STRING SrcSeparator = '',
										 integer max_rec_length = 500000000) := MODULE

export  mod_const := Spray_Constants(bFileName, build_date, SourceName, Frequency, File_Date, SrcQuote, SrcSeparator);

Export FileList   := file.RemoteDirectory(Spray_Constants().landingzone,
											                        mod_const.processDir, mod_const.FileNameCov);

    Export SprayFiles := file.SprayVariable(
		                  mod_const.landingzone,						// landing zone 
											mod_const.processfile,		// input file
											max_rec_length,				//1000100,//65536,
											mod_const.FieldSeparator,	// field sep
											'|\n',                        	// rec sep (use default)
											mod_const.RecordQuote,    	// quote
											system.Thorlib.group(),    	// destination group
											mod_const.spray_subfile,	// destination logical name
											-1,                       	// time
											,  
											,                         	// max connections
											TRUE,                     	// overwrite
											TRUE,                     	// replicate
											TRUE);                    	// compress
END;