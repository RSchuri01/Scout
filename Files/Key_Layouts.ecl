/*Layouts for the Lookup Keys*/
EXPORT Key_Layouts := MODULE

	Export Attribute_lookup_layout := RECORD
		String20 Product;
		String25 Attribute;
		String10 Type;
	END;
	
	Export ReasonCode_lookup_layout := RECORD
		String20 Product;
		String3 ReasonCode;
	END;
	
	Export Scores_lookup_layout := RECORD
		String20 Product;
		String3 Score;
		String10 ScoreType;
	END;


END;