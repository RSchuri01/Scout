import scout;
import scout.logs;
import std;
import scout.logs.layout as layout;

EXPORT fn_premiseassociation_attr(dataset(layout.base_transaction) infile) := MODULE

mbs_logs_slim := infile(std.str.touppercase(TRIM(esp_method)) = 'PREMISEASSOCIATION' and regexfind('<Attributes>', outputxml));
mbs_logs := project(mbs_logs_slim, transform(layout.base_transaction,
				SELF.outputxml := '<PremiseAssociation><Datetime>' + LEFT.Datetime + '</Datetime>' + LEFT.outputxml + '</PremiseAssociation>', self := left, self := []));
			
layout.attributes     parseoutput() := transform

  SELF.Transaction_ID	:= TRIM(XMLTEXT('Header/TransactionId')); // Forced into the record so I can join it all together
  SELF.datetime       := TRIM(XMLTEXT('Datetime'));
//attributes
  SELF.Attribute1Value     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[1]/Value'));
  SELF.Attribute1Name      := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[1]/Name')) ;  
	SELF.Attribute2Name      := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[2]/Name')) ;
  SELF.Attribute2Value     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[2]/Value')) ;
  SELF.Attribute3Name      := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[3]/Name')) ;
  SELF.Attribute3Value     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[3]/Value')) ;
  SELF.Attribute4Name      := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[4]/Name')) ;
  SELF.Attribute4Value     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[4]/Value')) ;
  SELF.Attribute5Name      := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[5]/Name')) ;
  SELF.Attribute5Value     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[5]/Value')) ;
  SELF.Attribute6Name      := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[6]/Name')) ;
  SELF.Attribute6Value     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[6]/Value'));
  SELF.Attribute7Name      := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[7]/Name')) ;
  SELF.Attribute7Value     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[7]/Value')) ;
  SELF.Attribute8Name      := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[8]/Name')) ;
  SELF.Attribute8Value     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[8]/Value')) ;
  SELF.Attribute9Name      := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[9]/Name')) ;
  SELF.Attribute9Value     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[9]/Value')) ;
  SELF.Attribute10Name     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[10]/Name')) ;
  SELF.Attribute10Value    := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[10]/Value'));
  SELF.Attribute11Name     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[11]/Name')) ;
  SELF.Attribute11Value    := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[11]/Value'));
  SELF.Attribute12Name     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[12]/Name')) ;
  SELF.Attribute12Value    := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[12]/Value'));
  SELF.Attribute13Name     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[13]/Name')) ;
  SELF.Attribute13Value    := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[13]/Value'));
  SELF.Attribute14Name     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[14]/Name')) ;
  SELF.Attribute14Value    := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[14]/Value'));
  SELF.Attribute15Name     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[15]/Name')) ;
  SELF.Attribute15Value    := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[15]/Value'));
  SELF.Attribute16Name     := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[16]/Name')) ;
  SELF.Attribute16Value    := TRIM(XMLTEXT('Result/AttributeGroup/Attributes/Attribute[16]/Value'));
  
	self := [];
 
  END;

parsedoutput := PARSE(mbs_logs, outputxml, parseOutput(), XML('PremiseAssociation'));

add_product := project(parsedoutput, transform(layout.attributes,
						self.esp_method := 'PremiseAssociation', self := left));

export generate := OUTPUT(add_product,,'~thor::scout::score_logs::PremiseAssociation_parsed_attributes', thor, overwrite, compressed);

export getDS := dataset('~thor::scout::score_logs::PremiseAssociation_parsed_attributes', layout.attributes, thor);

end;