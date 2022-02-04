Import scout;
export constants := module

	export void_gateway := dataset([], scout.gateway.layouts.config);
	export gateway_scout := 'scout';
	export dev_scout_url := 'http://espdev64.sc.seisint.com:8909';
	
	export defaults := module		
		export integer WAIT_TIMEOUT 			:= 300; // 0 is wait forever, default if ommitted is 300 (s)
		export integer RETRIES 					:= 0;	// 0 is no retry, default if ommitted is (3)
	end;

	export configproperties := module
		export string20 TransactionId 	:= 'TransactionId';
		export string20 BlindOption		:= '_Blind';
		export string20 BatchJobId 		:= 'BatchJobId';
		export string20 BatchSpecId 	:= 'BatchSpecId';
		export string20 RoxieQueryName	:= 'RoxieQueryName';
	end;
	
end;