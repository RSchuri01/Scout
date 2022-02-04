IMPORT Files;

EXPORT LookupKey_Keys := MODULE

	// shared locat := Data_Services.Data_location.Prefix('Scout') + 'scout::key::lookup::';
	shared locat := '~scout::key::lookup::';
	
	attr := Files.LookupKey_Files.Attributes;
	export Attributes := index(attr,{product}, {attr}, 
											// locat + 'attributes');
											locat + 'attributes_QA');


	reason := Files.LookupKey_Files.ReasonCodes;
	export ReasonCodes := index(reason,{product}, {reason}, 
											// locat + 'reasoncodes');		
											locat + 'reasoncodes_QA');


	score := Files.LookupKey_Files.Scores;
	export Scores := index(score,{product}, {score}, 
											// locat + 'scores');		
											locat + 'scores_QA');	

END;