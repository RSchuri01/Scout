IMPORT lib_fileservices;

EXPORT fn_promotefile(String Path, String filedate, String FileName, String SuperFileName) := FUNCTION
		
	file_date 					:= if(filedate <> '',filedate + '::', filedate );
	FileNameNewLogical 			:= Path + '::' + file_date +  FileName +'_' + workunit;
	FilePath					:= Path + '::' + SuperFileName;
	FileNameFather 				:= Path + '::' + 'father' + '::'+ SuperFileName;
	FileNameGrandFather 		:= Path + '::' + 'grandfather' + '::'+ SuperFileName;
	FileNameGreatGrandFather	:= Path + '::' + 'greatgrandfather' + '::'+ SuperFileName;

	PromotionList := [FilePath,FileNameFather];
		
	Return FileServices.PromoteSuperFileList(PromotionList, FileNameNewLogical, true);
END;