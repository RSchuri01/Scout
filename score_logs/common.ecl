IMPORT ADDRESS, std;
EXPORT common := module

EXPORT ParseCompanyName(STRING company_name_1, STRING company_name_2) := 
IF(company_name_1 <> '', company_name_1, company_name_2);

//EXPORT ParseSSN(STRING In_SSN, Integer1 Num_Length = 9) := IF((INTEGER)In_SSN <> 0, INTFORMAT((INTEGER)std.str.stringfilter(In_SSN, ' 0123456789'), Num_Length, 1), '');

EXPORT ParseSSN(STRING In_SSN, STRING In_SSN4 = '', Integer1 Num_Length = 9) := FUNCTION
		ParsedSSN := IF((INTEGER)In_SSN <> 0, INTFORMAT((INTEGER)std.str.stringfilter(In_SSN, ' 0123456789'), Num_Length, 1), '');
		ParsedSSN4 := IF((INTEGER)In_SSN4 <> 0, INTFORMAT((INTEGER)std.str.stringfilter(In_SSN4, ' 0123456789'), Num_Length, 1), '');
		
		RETURN (IF(ParsedSSN <> '', ParsedSSN, ParsedSSN4));
	END;
	
EXPORT Parsefname(STRING In_full, STRING In_fname) := FUNCTION
		Parsedfname := IF(In_fname <> '', In_fname, IF(In_full <> '', address.CleanPerson73(In_full)[6..25], ''));
		
		RETURN Parsedfname;
	END;
EXPORT Parselname(STRING In_full, STRING In_lname) := FUNCTION
		Parsedlname := IF(In_lname <> '', In_lname, IF(In_full <> '', address.CleanPerson73(In_full)[46..65], ''));
		
		RETURN Parsedlname;
	END;	
	
end;

