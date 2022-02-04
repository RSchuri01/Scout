Import scout;
Import std;

/*
	*************************************************************************************
	General usage:

		// To read gateway configuration from store, use:
		dGWCfg  := Gateway.Configuration.Get();

		// To pick a specific gateway configuration, apply filter by service name. E.g.:
		dTargusGWCfg  := dGWCfg(Gateway.Configuration.IsTargus(servicename));

	*************************************************************************************
*/
export configuration := module

	// Read gateway configuration from #store.
	export Get() := function		
		
		// Reading additional configuration.
		string 	_transactionID 	:= '' : stored('_TransactionId');
		string 	_bJobID 			 	:= '' : stored('_BatchJobId');
		string 	_bSpecID 			 	:= '' : stored('_BatchSpecId');
		/*--------------------------------------------------------------------------------------------------------------------------
			__Blind is for roxie-roxie soapcall, plaform needs to see <_blind>1<_blind> inorder to blind log the soap request.
			The other "Blind" is coming from ESP request required by Gateway ESP's to blind log the gateway logs in database.
		--------------------------------------------------------------------------------------------------------------------------*/
		boolean	__Blind	:= FALSE : stored('_Blind');
		boolean	Blind		:= FALSE : stored('Blind');
		string _Blind 	:= if(Blind or __Blind, '1', '0'); 
		
		// Reading query name; removing appended version, if necessary.		
		string 	_roxieQName 		:= std.system.Job.Name();
		integer _vIdx 				:= std.str.find(_roxieQName,'.',2)-1;
		string 	_roxieQueryName	:= IF(_vIdx>0, _roxieQName[1.._vIdx], _roxieQName);

		// ************************************************************************************
		// Storing gatway information into Context gateway structure for Dynamic ESDL purposes 
		// ************************************************************************************

		dGWIn := dataset([], scout.iesp.context.t_Context) : stored ('Context', few);	
		
		

		dGWInReturn 	:= project(dGWIn,  
													 transform(scout.iesp.context.t_Context, 
																		 self.Common.TransactionId := _transactionID, 
																		 self.Common.ESP.ServiceName := _roxieQueryName,
																		 self := left)); 
																		 						 
		return dGWInReturn;
		
		//========Debugging Purposes===================================
		// Debugging := Parallel(
			// output(dGWIn, named('dGWIn'));
			// output(dGWInReturn, named('dGWInReturn'));
		// );
		// Return When(dGWInReturn, Debugging);
	//=============================================================
		
	end;
	
end;