
EXPORT constants := MODULE

// Miscellaneous
	export unsigned2 MaxCountHRI := 10; 
	export unsigned1 MaxResponseExceptions := 4;
	export unsigned2 PhoneInfoMessages := 1;

	// Scout Constants
	export SCOUT := MODULE
		export unsigned1 MaxRCFilter := 6;
		export unsigned2 MaxSearchRecords := 10000;
		export unsigned1 MaxInputNames := 8;
		export unsigned1 MaxReasons := 6;
	END;
	
	export Identifier2c := MODULE
		export MaxRiskIndicators := 50;
	END;	
	
  export FI := MODULE
		export unsigned1 MaxCVIRiskIndicators	:= 75;
  end;
	
END;