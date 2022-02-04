import Score_Logs, scout, std;

export fn_productXMLcleaner(dataset(scout.logs.layout.base_transaction_reprocessed) infile, String productName) := function

Base_Transaction_Layout1 := record
	STRING transaction_id;
	STRING customer_id;
	STRING input_recordtype;
	STRING output_recordtype;
	STRING datetime;
	STRING30 esp_method;
	STRING inputxml {MAXLENGTH(3072)};
	DATASET(Score_Logs.Layouts_InputXML.rform1) inputxml_parsed {XPATH('Info'), MAXLENGTH(3072)}; // 3 kb
	STRING outputxml {MAXLENGTH(30720)};
	DATASET(Score_Logs.Layouts_OutputXML.rform1) outputxml_parsed {XPATH('OutResults'), MAXLENGTH(30720)}; // 30 kb
END;

p_all := project(infile(std.str.ToUppercase(TRIM(esp_method))[1..LENGTH(productName)] = STD.STR.ToUppercase(productName) 
AND (Length(TRIM(esp_method, LEFT, RIGHT)) = Length(productname) OR std.str.ToUppercase(TRIM(esp_method)) =  STD.STR.ToUppercase(productName) + 'RESULT'  OR Std.str.ToUppercase(TRIM(esp_method)) =  STD.STR.ToUppercase(productName)  + 'REQUEST')),

// p_all := project(infile(std.str.ToUppercase(TRIM(esp_method))[1..LENGTH(productName)] = STD.STR.ToUppercase(productName) 
//                 AND (Length(TRIM(esp_method, LEFT, RIGHT)) = Length(productname) OR std.str.endsWith(STD.STR.ToUppercase(productName), 'RESULT') OR std.str.endsWith(STD.STR.ToUppercase(productName), 'REQUEST'))),
								transform({string outputxml2,
													 string filt1, string filt3, string inputxml2,
								            scout.logs.layout.base_transaction}, 
									self.filt1 := left.inputxml[1..STD.STR.FIND(left.inputxml, '>', 1)];
									self.filt3 := STD.STR.filterout(self.filt1, '<>');
									
									inputxmla := regexreplace(left.inputxml[1..STD.STR.find(left.inputxml, '>', 1)], left.inputxml, '<Info><Product>' + self.filt3 + '</Product>'); 
									inputxmlb := regexreplace(STD.STR.findreplace(left.inputxml[1..STD.STR.find(left.inputxml, '>', 1)], '<', '</'), inputxmla, '</Info>');

									inputxmla1 := '<OutResults><Product>' + self.filt3 + '</Product>' + left.outputxml; 
									inputxmlb1 := inputxmla1 + '</OutResults>';
									
									self.inputxml2 := STD.STR.cleanspaces(regexreplace('<WatchList>ALL</WatchList>',inputxmlb, '<WatchList><All>ALL</All></WatchList>', nocase));
									self.outputxml2 := STD.STR.cleanspaces(regexreplace('<WatchList>ALL</WatchList>',inputxmlb1, '<WatchList><All>ALL</All></WatchList>', nocase));
									
									self := left));

p2 := PROJECT(p_all, TRANSFORM(Base_Transaction_Layout1,

											Score_Logs.Layouts_InputXML.rform1 fields1	:= FROMXML(Score_Logs.Layouts_InputXML.rform1, left.inputxml2
														,trim, ONFAIL(transform(Score_Logs.Layouts_InputXML.rform1,self := ROW([],Score_Logs.Layouts_InputXML.rform1))));
														
											self.inputxml_parsed := fields1;
											Score_Logs.Layouts_OutputXML.rform1 fields2	:= FROMXML(Score_Logs.Layouts_OutputXML.rform1, left.outputxml2
														,trim, ONFAIL(transform(Score_Logs.Layouts_OutputXML.rform1,self := ROW([],Score_Logs.Layouts_OutputXML.rform1))));
														
											self.outputxml_parsed := fields2;			

											self := left;
											self := []));

// old_online := dataset('~thor_data400::persist::score_logs::instantid_preparsed__p1257639175', Base_Transaction_Layout1, thor);
	
old_online := project(p2(~(inputxml_parsed[1].product = '' or outputxml_parsed[1].product = '')), 												
TRANSFORM(Base_Transaction_Layout1, self := left, self := [])) ;//:persist('~thor_data400::persist::score_logs::' + productName + '_preparsed');

Logs := PROJECT(old_online,
 TRANSFORM(scout.logs.layout.base_transaction_reprocessed, 
	// Need to mold the input XML into something that can be passed through the same PARSE function - this means making sure the first tag is <RiskView>
	inputXMLTemp1 := STD.STR.FindReplace(LEFT.inputxml, '<' + productName + '>', '<' + productName + '><TransactionId>' + LEFT.Transaction_Id + '</TransactionId>');
	inputXMLTemp2 := STD.STR.FindReplace(inputXMLTemp1, '<' + productName + 'Request>', '<' + productName + '><TransactionId>' + LEFT.Transaction_Id + '</TransactionId>');
	SELF.inputxml := STD.STR.FindReplace(inputXMLTemp2, '</' + productName + 'Request>', '</' + productName + '>'); 
	// SELF.outputxml := '<InstantID><TransactionId>' + LEFT.Transaction_Id + '</TransactionId><Datetime>' + LEFT.Datetime + '</Datetime>' + LEFT.outputxml + '</InstantID>';
		// SELF.outputxml := LEFT.outputxml ;
	SELF := LEFT, self := []));

return logs;

end;
