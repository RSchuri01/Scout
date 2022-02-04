import scout;
import scout.logs;
import std;
import scout.logs.layout as layout;

EXPORT fn_businessinstantID_attr(dataset(layout.base_transaction) infile) := MODULE

mbs_logs_slim := infile(std.str.touppercase(TRIM(esp_method)) = 'BUSINESSINSTANTID' and ~regexfind('<CompanyName>1991562253 010', outputxml) and regexfind('<Attributes>', outputxml));

mbs_logs := project(mbs_logs_slim, transform(layout.base_transaction, 
	SELF.outputxml := '<BusinessInstantID><TransactionId>' + LEFT.Transaction_Id + '</TransactionId>' + 
	'<Datetime>' + LEFT.Datetime + '</Datetime>' + LEFT.outputxml + '</BusinessInstantID>', self := left, self := []));	
							
layout.attributes     parseoutput() := transform

	SELF.Transaction_ID	:= TRIM(XMLTEXT('TransactionId')); // Forced into the record so I can join it all together
	SELF.datetime       := TRIM(XMLTEXT('Datetime'));
	SELF.Attribute1Name		:=	TRIM(XMLTEXT('Result/Attributes/Attribute[1]/Name'));
	SELF.Attribute1Value	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[1]/Value'));
	SELF.Attribute2Name		:=	TRIM(XMLTEXT('Result/Attributes/Attribute[2]/Name'));
	SELF.Attribute2Value	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[2]/Value'));
	SELF.Attribute3Name		:=	TRIM(XMLTEXT('Result/Attributes/Attribute[3]/Name'));
  SELF.Attribute3Value	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[3]/Value'));
	SELF.Attribute4Name		:=	TRIM(XMLTEXT('Result/Attributes/Attribute[4]/Name'));
	SELF.Attribute4Value	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[4]/Value'));
	SELF.Attribute5Name		:=	TRIM(XMLTEXT('Result/Attributes/Attribute[5]/Name'));
	SELF.Attribute5Value	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[5]/Value'));
	SELF.Attribute6Name		:=	TRIM(XMLTEXT('Result/Attributes/Attribute[6]/Name'));
  SELF.Attribute6Value	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[6]/Value'));
	SELF.Attribute7Name		:=	TRIM(XMLTEXT('Result/Attributes/Attribute[7]/Name'));
  SELF.Attribute7Value	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[7]/Value'));
	SELF.Attribute8Name		:=	TRIM(XMLTEXT('Result/Attributes/Attribute[8]/Name'));
  SELF.Attribute8Value	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[8]/Value'));
	SELF.Attribute9Name		:=	TRIM(XMLTEXT('Result/Attributes/Attribute[9]/Name'));
  SELF.Attribute9Value	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[9]/Value'));
	SELF.Attribute10Name	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[10]/Name'));
  SELF.Attribute10Value	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[10]/Value'));
	SELF.Attribute11Name	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[11]/Name'));
  SELF.Attribute11Value	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[11]/Value'));
	SELF.Attribute12Name	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[12]/Name'));
  SELF.Attribute12Value	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[12]/Value'));
	SELF.Attribute13Name	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[13]/Name'));
  SELF.Attribute13Value	:=	TRIM(XMLTEXT('Result/Attributes/Attribute[13]/Value'));
	
  SELF := [];
END;

parsedoutput := PARSE(mbs_logs, outputxml, parseOutput(), XML('BusinessInstantID'));

projectedData := project(parsedoutput, transform(layout.attributes,
							self.esp_method := 'BusinessInstantID', self := left));

export generate := OUTPUT(projectedData,,'~thor::scout::score_logs::BusinessInstantID_parsed_attributes', thor, overwrite, compressed);

export getDS := dataset('~thor::scout::score_logs::BusinessInstantID_parsed_attributes', layout.attributes, thor);

end;
