Import scout;

EXPORT config := RECORD
	string40 	ServiceName;
	string 		Url;
	string50  TransactionId := '';
	dataset(scout.gateway.layouts.config_properties) properties := dataset([], scout.gateway.layouts.config_properties);
END;