import * from std;
import scout;

import scout.common.spray;


export fn_Promote_ds(Dataset dset, 
					 String Path, 
					 String FileName, 
					 boolean prepForSQLLoad = false, 
					 string delim ='\t', 
					 boolean heading = false, 
					 string despray_prefix = '') := FUNCTION
					 
	start_pos		:= std.str.find(FileName,'::',2);
	FileName_csv	:= if(start_pos = 0,
							FileName,
							FileName[start_pos + 2..] +'_' + FileName[..4] + FileName[7..8]);
																
	fileDate 				:= (string)std.date.today()  : stored('filedate');
	FileNameNewLogical 		:= Path + '::' + fileDate+ '::'+ FileName +'_' + workunit;		
	despray_prefix_str		:= if (length(trim(despray_prefix)) > 0, trim(despray_prefix) + '_', '');
	FileNameNewLogical_csv 	:= scout.common.despray_prefix + '::'+ trim(despray_prefix_str) + FileName_csv;		
	
	// force independent on dims/facts so graphs aren't duplicated for each output
	indy_dset				:= dset : independent;
	data_for_file			:= if(prepForSQLLoad, indy_dset, dset);
	
	SaveNewFile_thor 		:=	output(data_for_file, , FileNameNewLogical, thor, compressed);
	
	SaveNewFile_csv := 	if(heading = false,
							output(data_for_file, , FileNameNewLogical_csv, CSV(heading(0), SEPARATOR(delim), TERMINATOR('\n'), MAXLENGTH(10240)), overwrite, compressed),
							output(data_for_file, , FileNameNewLogical_csv, CSV(HEADING(SINGLE), SEPARATOR(delim), TERMINATOR('\n'), MAXLENGTH(10240)), overwrite, compressed));

	Promote_File 	:= Spray.fn_promotefile(Path, fileDate, FileName, FileName);
	
	Return 	If(prepForSQLLoad,
				Sequential(Parallel(SaveNewFile_thor, SaveNewFile_csv), Promote_File), // Apllies for dim's and fact's
				Sequential(SaveNewFile_thor, Promote_File)); 						   // Apllies for spray, stg etc.
end;
