/*
Script used for testing the detailed search service
*/

Import scout;
// #OPTION('OUTPUTLIMIT', 200);


//SearchBy fields
// in_TransactionID := '439330567R54040';
in_TransactionID := '';



scout.iesp.scout_search_detail.t_ScoutTransactionDetailSearchBy formatsearch() := Transform
	self.TransactionId := in_TransactionID;
End;

searchtemp := dataset([formatsearch()]);
search := searchtemp[1];

scout.iesp.scout_search_detail.t_ScoutTransactionDetailRequest formatrequest() := Transform
	self.SearchBy := search;
	self := [];
END;

in_rec := dataset([formatrequest()]);


scout.iesp.context.t_Context formatcontext() := Transform
	a := DATASET([TRANSFORM(scout.iesp.context.t_Gateway,
	                        self.name := 'scout';
							self.url := 'http://delta_iid_api_user:2rch%40p1%24%24@10.176.69.151:7911';
                            // self.url := 'http://espdev64.sc.seisint.com:8909';
							)]);

  self.Common.ESP.Config.Method.Gateways := a[1];
	self := [];
END;

in_context := dataset([formatcontext()]);
// in_context := in_context_temp[1];

output(in_rec, named('in_rec'));
output(in_context, named('in_context'));

#STORED('ScoutTransactionDetailRequest', in_rec);
#STORED('context', in_context);


scout.services.detailed_search_service();
