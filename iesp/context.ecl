
EXPORT context := MODULE

	export t_Gateway := record
		String name {xpath('name')};
		String url {xpath('url')};
	end;

	export t_Method := record
		dataset(t_Gateway) Gateways {xpath('Gateways/Gateway')};
	end;

	export t_Config := record
		t_Method Method {xpath('Method')};
	end;

	export t_ESP := record
		String ServiceName {xpath('ServiceName')};
		t_Config Config {xpath('Config')};
	end;
	
	export t_Common := record
		t_ESP ESP {xpath('ESP')};
		String TransactionID {xpath('TransactionId')};
	end;

	export t_Context := record
		t_Common Common {xpath('Common')};
	end;
	
END;