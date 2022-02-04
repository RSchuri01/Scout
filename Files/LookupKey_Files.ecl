IMPORT Files;

EXPORT LookupKey_Files := MODULE

	export get_filename(string File) := FUNCTION
	
		choice := case (File,
							'attribute'		=> '~scout::base::attributekey',           
							'reasoncode'	=> '~scout::base::reasoncodekey',
							'scorekey'		=> '~scout::base::scorekey',
												'' );
		if( choice='', FAIL('Unknown File') );
		return choice;
	end;
	

	export Attributes	:= dataset(get_filename('attribute'), Files.Key_Layouts.Attribute_lookup_layout, CSV (heading(1), QUOTE('"')));
	export ReasonCodes	:= dataset(get_filename('reasoncode'), Files.Key_Layouts.ReasonCode_lookup_layout, CSV (heading(1), QUOTE('"')));
	export Scores		:= dataset(get_filename('scorekey'), Files.Key_Layouts.Scores_lookup_layout, CSV (heading(1), QUOTE('"')));
	
END;