import std.file;
import scout.common.spray;
import scout;

EXPORT fn_despray(string filename) := function

	thor_filename := scout.common.despray_prefix + '::' + filename;
	remote_file 	:= scout.common.app_constants.getExportRemoteName(filename);
	
	despray :=	file.despray(thor_filename, 
							 spray.Spray_Constants().analyticsProdLZ, //landingzone, 
							 remote_file + scout.common.app_constants.extn
							 ,,,,true);
								 
	fileexists := File.FileExists(thor_filename);
		
	return if(fileexists, despray, output('MISSING ' + thor_filename));

end;