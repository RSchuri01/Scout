import * from $;
import scout.common;
import std.Date;
import scout.logs;
import std;
import scout.common.spray;

string frequency 	:= common.stored_frequency;

fileDate 	:= (string)std.date.today() : stored('filedate');
File_List	:= spray.Build_Exports('', '', 'logs', frequency, fileDate).FileList;
freq_chk	:= IF(logs.files_spray.spray_prefix ='', FAIL('Invalid_Frequency'));
Files_spray	:= NOTHOR(apply(File_List,nothor(spray.Build_Exports('',std.str.tolowercase(File_List.name), 'logs', frequency, fileDate).SprayFiles)));
Files_Build := NOTHOR(apply(File_List,common.spray.FN_PromoteFile(logs.files_spray.spray_prefix, 
							fileDate, 
							std.str.tolowercase(File_List.name),
							logs.common.util.fn_sf_nameclean(std.str.tolowercase(File_List.name)))));

Export spray_Build  := Sequential(output(fileDate),output(file_list), freq_chk, Files_spray, Files_build);