import * from $;
import std.str;

export fn_sf_nameclean(string super_file_name) := function

	file_reverse := str.reverse(super_file_name);
	file_trim := file_reverse[str.find(file_reverse, '_',1)+1..];
	file_good := str.reverse(file_trim);
	RETURN str.tolowercase(file_good);	
							
end;