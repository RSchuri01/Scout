/*--SOAP--
	<message name="TestNewKeys">
</message>
	<part name="Product" type="xsd:string"/>
*/

import STD, Files;

export Test_New_Keys := MACRO

#WEBSERVICE(FIELDS(
		'Product'));

string20 in_product := '' : STORED('Product');

// r_layout := record
 // String One;
 // String Two;
 // String Three;
// end;

// Key := DATASET([{'a','b','c'},
                // {'d','e','f'},
                // {'g','h','i'}], r_layout);
								
Key1 := Files.LookupKey_Keys.Attributes;
Key2 := Files.LookupKey_Keys.ReasonCodes;
Key3 := Files.LookupKey_Keys.Scores;

filter1 := Key1(product = trim(in_product));
filter2 := Key2(product = trim(in_product));
filter3 := Key3(product = trim(in_product));

a := filter1;
b := filter2;
c := filter3;
//b := choosen(Seed_Files.key_SmallBusFinancialExchange, 10);
	
output(a, named('Attribute_List'));
output(b, named('ReasonCode_List'));
output(c, named('Score_List'));


ENDMACRO;