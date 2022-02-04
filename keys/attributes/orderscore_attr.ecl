import scout;
import scout.logs;
import std;
import scout.logs.layout as layout;
IMPORT DataMgmt;
IMPORT scout.common.constants;

EXPORT orderscore_attr := MODULE

SHARED infile := scout.logs.files_stg.online_stg_ds : INDEPENDENT;

espName := 'ORDERSCORE';

EXPORT mbs_base_slim := infile(std.str.touppercase(TRIM(esp_method))[1..LENGTH(espName)] = espName and regexfind('<Attributes>', outputxml));
mbs_logs := project(mbs_base_slim, transform(layout.base_transaction,
				SELF.outputxml := '<OrderScoreResponseEx><Datetime>' + LEFT.Datetime + '</Datetime>' + LEFT.outputxml + '</OrderScoreResponseEx>', self := left, self := []));
			
layout.attributes     parseoutput() := transform

  SELF.Transaction_ID	:= TRIM(XMLTEXT('Header/TransactionId')); // Forced into the record so I can join it all together
  SELF.datetime       := TRIM(XMLTEXT('Datetime'));
//attributes
  SELF.Attribute1Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[1]/Value'));
  SELF.Attribute1Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[1]/Name')) ;  
	SELF.Attribute2Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[2]/Name')) ;
  SELF.Attribute2Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[2]/Value')) ;
  SELF.Attribute3Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[3]/Name')) ;
  SELF.Attribute3Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[3]/Value')) ;
  SELF.Attribute4Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[4]/Name')) ;
  SELF.Attribute4Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[4]/Value')) ;
  SELF.Attribute5Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[5]/Name')) ;
  SELF.Attribute5Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[5]/Value')) ;
  SELF.Attribute6Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[6]/Name')) ;
  SELF.Attribute6Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[6]/Value'));
  SELF.Attribute7Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[7]/Name')) ;
  SELF.Attribute7Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[7]/Value')) ;
  SELF.Attribute8Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[8]/Name')) ;
  SELF.Attribute8Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[8]/Value')) ;
  SELF.Attribute9Name      := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[9]/Name')) ;
  SELF.Attribute9Value     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[9]/Value')) ;
  SELF.Attribute10Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[10]/Name')) ;
  SELF.Attribute10Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[10]/Value'));
  SELF.Attribute11Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[11]/Name')) ;
  SELF.Attribute11Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[11]/Value'));
  SELF.Attribute12Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[12]/Name')) ;
  SELF.Attribute12Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[12]/Value'));
  SELF.Attribute13Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[13]/Name')) ;
  SELF.Attribute13Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[13]/Value'));
  SELF.Attribute14Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[14]/Name')) ;
  SELF.Attribute14Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[14]/Value'));
  SELF.Attribute15Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[15]/Name')) ;
  SELF.Attribute15Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[15]/Value'));
  SELF.Attribute16Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[16]/Name')) ;
  SELF.Attribute16Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[16]/Value'));
  SELF.Attribute17Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[17]/Name')) ;
  SELF.Attribute17Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[17]/Value'));
  SELF.Attribute18Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[18]/Name')) ;
  SELF.Attribute18Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[18]/Value'));
  SELF.Attribute19Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[19]/Name')) ;
  SELF.Attribute19Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[19]/Value'));
  SELF.Attribute20Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[20]/Name')) ;
  SELF.Attribute20Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[20]/Value'));
  SELF.Attribute21Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[21]/Name')) ;
  SELF.Attribute21Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[21]/Value'));
  SELF.Attribute22Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[22]/Name')) ;
  SELF.Attribute22Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[22]/Value'));
  SELF.Attribute23Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[23]/Name')) ;
  SELF.Attribute23Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[23]/Value'));
  SELF.Attribute24Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[24]/Name')) ;
  SELF.Attribute24Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[24]/Value'));
  SELF.Attribute25Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[25]/Name')) ;
  SELF.Attribute25Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[25]/Value'));
  SELF.Attribute26Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[26]/Name')) ;
  SELF.Attribute26Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[26]/Value'));
  SELF.Attribute27Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[27]/Name')) ;
  SELF.Attribute27Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[27]/Value'));
  SELF.Attribute28Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[28]/Name')) ;
  SELF.Attribute28Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[28]/Value'));
  SELF.Attribute29Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[29]/Name')) ;
  SELF.Attribute29Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[29]/Value'));
  SELF.Attribute30Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[30]/Name')) ;
  SELF.Attribute30Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[30]/Value'));
  SELF.Attribute31Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[31]/Name')) ;
  SELF.Attribute31Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[31]/Value'));
  SELF.Attribute32Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[32]/Name')) ;
  SELF.Attribute32Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[32]/Value'));
  SELF.Attribute33Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[33]/Name')) ;
  SELF.Attribute33Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[33]/Value'));
  SELF.Attribute34Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[34]/Name')) ;
  SELF.Attribute34Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[34]/Value'));
  SELF.Attribute35Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[35]/Name')) ;
  SELF.Attribute35Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[35]/Value'));
  SELF.Attribute36Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[36]/Name')) ;
  SELF.Attribute36Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[36]/Value'));
  SELF.Attribute37Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[37]/Name')) ;
  SELF.Attribute37Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[37]/Value'));
  SELF.Attribute38Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[38]/Name')) ;
  SELF.Attribute38Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[38]/Value'));
  SELF.Attribute39Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[39]/Name')) ;
  SELF.Attribute39Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[39]/Value'));
  SELF.Attribute40Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[40]/Name')) ;
  SELF.Attribute40Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[40]/Value'));
  SELF.Attribute41Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[41]/Name')) ;
  SELF.Attribute41Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[41]/Value'));
  SELF.Attribute42Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[42]/Name')) ;
  SELF.Attribute42Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[42]/Value'));
  SELF.Attribute43Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[43]/Name')) ;
  SELF.Attribute43Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[43]/Value'));
  SELF.Attribute44Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[44]/Name')) ;
  SELF.Attribute44Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[44]/Value'));
  SELF.Attribute45Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[45]/Name')) ;
  SELF.Attribute45Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[45]/Value'));
  SELF.Attribute46Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[46]/Name')) ;
  SELF.Attribute46Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[46]/Value'));
  SELF.Attribute47Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[47]/Name')) ;
  SELF.Attribute47Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[47]/Value'));
  SELF.Attribute48Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[48]/Name')) ;
  SELF.Attribute48Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[48]/Value'));
  SELF.Attribute49Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[49]/Name')) ;
  SELF.Attribute49Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[49]/Value'));
  SELF.Attribute50Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[50]/Name')) ;
  SELF.Attribute50Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[50]/Value'));
  SELF.Attribute51Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[51]/Name')) ;
  SELF.Attribute51Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[51]/Value'));
  SELF.Attribute52Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[52]/Name')) ;
  SELF.Attribute52Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[52]/Value'));
  SELF.Attribute53Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[53]/Name')) ;
  SELF.Attribute53Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[53]/Value'));
  SELF.Attribute54Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[54]/Name')) ;
  SELF.Attribute54Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[54]/Value'));
  SELF.Attribute55Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[55]/Name')) ;
  SELF.Attribute55Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[55]/Value'));
  SELF.Attribute56Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[56]/Name')) ;
  SELF.Attribute56Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[56]/Value'));
  SELF.Attribute57Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[57]/Name')) ;
  SELF.Attribute57Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[57]/Value'));
  SELF.Attribute58Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[58]/Name')) ;
  SELF.Attribute58Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[58]/Value'));
  SELF.Attribute59Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[59]/Name')) ;
  SELF.Attribute59Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[59]/Value'));
  SELF.Attribute60Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[60]/Name')) ;
  SELF.Attribute60Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[60]/Value'));
  SELF.Attribute61Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[61]/Name')) ;
  SELF.Attribute61Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[61]/Value'));
  SELF.Attribute62Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[62]/Name')) ;
  SELF.Attribute62Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[62]/Value'));
  SELF.Attribute63Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[63]/Name')) ;
  SELF.Attribute63Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[63]/Value'));
  SELF.Attribute64Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[64]/Name')) ;
  SELF.Attribute64Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[64]/Value'));
  SELF.Attribute65Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[65]/Name')) ;
  SELF.Attribute65Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[65]/Value'));
  SELF.Attribute66Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[66]/Name')) ;
  SELF.Attribute66Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[66]/Value'));
  SELF.Attribute67Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[67]/Name')) ;
  SELF.Attribute67Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[67]/Value'));
  SELF.Attribute68Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[68]/Name')) ;
  SELF.Attribute68Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[68]/Value'));
  SELF.Attribute69Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[69]/Name')) ;
  SELF.Attribute69Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[69]/Value'));
  SELF.Attribute70Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[70]/Name')) ;
  SELF.Attribute70Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[70]/Value'));
  SELF.Attribute71Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[71]/Name')) ;
  SELF.Attribute71Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[71]/Value'));
  SELF.Attribute72Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[72]/Name')) ;
  SELF.Attribute72Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[72]/Value'));
  SELF.Attribute73Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[73]/Name')) ;
  SELF.Attribute73Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[73]/Value'));
  SELF.Attribute74Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[74]/Name')) ;
  SELF.Attribute74Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[74]/Value'));
  SELF.Attribute75Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[75]/Name')) ;
  SELF.Attribute75Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[75]/Value'));
  SELF.Attribute76Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[76]/Name')) ;
  SELF.Attribute76Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[76]/Value'));
  SELF.Attribute77Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[77]/Name')) ;
  SELF.Attribute77Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[77]/Value'));
  SELF.Attribute78Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[78]/Name')) ;
  SELF.Attribute78Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[78]/Value'));
  SELF.Attribute79Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[79]/Name')) ;
  SELF.Attribute79Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[79]/Value'));
  SELF.Attribute80Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[80]/Name')) ;
  SELF.Attribute80Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[80]/Value'));
  SELF.Attribute81Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[81]/Name')) ;
  SELF.Attribute81Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[81]/Value'));
  SELF.Attribute82Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[82]/Name')) ;
  SELF.Attribute82Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[82]/Value'));
  SELF.Attribute83Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[83]/Name')) ;
  SELF.Attribute83Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[83]/Value'));
  SELF.Attribute84Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[84]/Name')) ;
  SELF.Attribute84Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[1]/Attributes[1]/Attribute[84]/Value'));
  SELF.Attribute85Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[1]/Name')) ;
  SELF.Attribute85Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[1]/Value'));
  SELF.Attribute86Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[2]/Name')) ;
  SELF.Attribute86Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[2]/Value'));
  SELF.Attribute87Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[3]/Name')) ;
  SELF.Attribute87Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[3]/Value'));
  SELF.Attribute88Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[4]/Name')) ;
  SELF.Attribute88Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[4]/Value'));
  SELF.Attribute89Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[5]/Name')) ;
  SELF.Attribute89Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[5]/Value'));
  SELF.Attribute90Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[6]/Name')) ;
  SELF.Attribute90Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[6]/Value'));
  SELF.Attribute91Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[7]/Name')) ;
  SELF.Attribute91Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[7]/Value'));
  SELF.Attribute92Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[8]/Name')) ;
  SELF.Attribute92Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[8]/Value'));
  SELF.Attribute93Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[9]/Name')) ;
  SELF.Attribute93Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[9]/Value'));
  SELF.Attribute94Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[10]/Name')) ;
  SELF.Attribute94Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[10]/Value'));
  SELF.Attribute95Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[11]/Name')) ;
  SELF.Attribute95Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[11]/Value'));
  SELF.Attribute96Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[12]/Name')) ;
  SELF.Attribute96Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[12]/Value'));
  SELF.Attribute97Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[13]/Name')) ;
  SELF.Attribute97Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[13]/Value'));
  SELF.Attribute98Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[14]/Name')) ;
  SELF.Attribute98Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[14]/Value'));
  SELF.Attribute99Name     := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[15]/Name')) ;
  SELF.Attribute99Value    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[2]/Attributes[1]/Attribute[15]/Value'));
  SELF.Attribute100Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[1]/Name'));
  SELF.Attribute100Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[1]/Value'));
  SELF.Attribute101Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[2]/Name')) ;
  SELF.Attribute101Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[2]/Value'));
  SELF.Attribute102Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[3]/Name')) ;
  SELF.Attribute102Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[3]/Value'));
  SELF.Attribute103Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[4]/Name')) ;
  SELF.Attribute103Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[4]/Value'));
  SELF.Attribute104Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[5]/Name')) ;
  SELF.Attribute104Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[5]/Value'));
  SELF.Attribute105Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[6]/Name')) ;
  SELF.Attribute105Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[6]/Value'));
  SELF.Attribute106Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[7]/Name')) ;
  SELF.Attribute106Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[7]/Value'));
  SELF.Attribute107Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[8]/Name')) ;
  SELF.Attribute107Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[8]/Value'));
  SELF.Attribute108Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[9]/Name')) ;
  SELF.Attribute108Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[9]/Value'));
  SELF.Attribute109Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[10]/Name')) ;
  SELF.Attribute109Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[10]/Value'));
  SELF.Attribute110Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[11]/Name')) ;
  SELF.Attribute110Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[11]/Value'));
  SELF.Attribute111Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[12]/Name')) ;
  SELF.Attribute111Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[12]/Value'));
  SELF.Attribute112Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[13]/Name')) ;
  SELF.Attribute112Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[13]/Value'));
  SELF.Attribute113Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[14]/Name')) ;
  SELF.Attribute113Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[14]/Value'));
  SELF.Attribute114Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[15]/Name')) ;
  SELF.Attribute114Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[15]/Value'));
  SELF.Attribute115Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[16]/Name')) ;
  SELF.Attribute115Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[16]/Value'));
  SELF.Attribute116Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[17]/Name')) ;
  SELF.Attribute116Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[17]/Value'));
  SELF.Attribute117Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[18]/Name')) ;
  SELF.Attribute117Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[18]/Value'));
  SELF.Attribute118Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[19]/Name')) ;
  SELF.Attribute118Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[19]/Value'));
  SELF.Attribute119Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[20]/Name')) ;
  SELF.Attribute119Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[20]/Value'));
  SELF.Attribute120Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[21]/Name')) ;
  SELF.Attribute120Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[21]/Value'));
  SELF.Attribute121Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[22]/Name')) ;
  SELF.Attribute121Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[22]/Value'));
  SELF.Attribute122Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[23]/Name')) ;
  SELF.Attribute122Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[23]/Value'));
  SELF.Attribute123Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[24]/Name')) ;
  SELF.Attribute123Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[24]/Value'));
  SELF.Attribute124Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[25]/Name')) ;
  SELF.Attribute124Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[25]/Value'));
  SELF.Attribute125Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[26]/Name')) ;
  SELF.Attribute125Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[26]/Value'));
  SELF.Attribute126Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[27]/Name')) ;
  SELF.Attribute126Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[27]/Value'));
  SELF.Attribute127Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[28]/Name')) ;
  SELF.Attribute127Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[28]/Value'));
  SELF.Attribute128Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[29]/Name')) ;
  SELF.Attribute128Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[29]/Value'));
  SELF.Attribute129Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[30]/Name')) ;
  SELF.Attribute129Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[30]/Value'));
  SELF.Attribute130Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[31]/Name')) ;
  SELF.Attribute130Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[31]/Value'));
  SELF.Attribute131Name    := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[32]/Name')) ;
  SELF.Attribute131Value   := TRIM(XMLTEXT('Result/AttributeGroups[1]/AttributeGroup[3]/Attributes[1]/Attribute[32]/Value'));
                                                                                                                             
	self := [];
 
  END;

parsedoutput := PARSE(mbs_logs, outputxml, parseOutput(), XML('OrderScoreResponseEx'));



SHARED projectedData := project(parsedoutput, transform(layout.attributes,
					   self.esp_method := 'OrderScoreResponseEx', self := left));

SHARED OrderScoreResponseEx := dedup(
	        normalize(projectedData, 2160, scout.logs.util.fn_transformattributesByNormalize(left, counter), local), all, local);

export idxKeyName := scout.common.constants.orderscore_attr_keyName;

SHARED subIdxFileName(String pversion) := scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion);

SHARED idxLayout := RECORDOF(OrderScoreResponseEx);

EXPORT readIdxSubFileData(String pversion):= PULL(INDEX(DATASET([],RECORDOF(idxLayout)), 
                                 {idxLayout.transaction_id}, {idxLayout},
										 subIdxFileName(pversion)));

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);

export indexDailyStgFile(String pv, boolean isRollupAsked)  := scout.logs.util.fn_buildSubKeyAndAddToSuperKey(INDEX(OrderScoreResponseEx(transaction_id <> '' and AttributeName <> ''), 
                                 {OrderScoreResponseEx.transaction_id, OrderScoreResponseEx.datetime}, {OrderScoreResponseEx},
										 subIdxFileName(pv)), idxKeyName, subIdxFileName(pv), isRollupAsked);

EXPORT superFileData(Boolean isSuperFor2Years = true) := INDEX(DATASET([],idxLayout), {idxLayout.transaction_id, idxLayout.datetime}, {idxLayout},
				    superFileName(isSuperFor2Years), opt);

SHARED twoyrsOldData := PULL(SUPERFILEDATA(false));

EXPORT rollupBackSuperFileIndex(String pversion, Boolean isRollupOnly = true) := scout.logs.util.fn_rollupSupKeyIndexData(INDEX(twoyrsOldData , 
                                           {twoyrsOldData.transaction_id, twoyrsOldData.datetime}, 
                                           {twoyrsOldData}, 
                                           scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion, true)
                                      ),
								   idxKeyName,
                                   scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion,true),
								   isRollupOnly
                             );

EXPORT fileDateIndexData := INDEX(DATASET([], idxLayout), {idxLayout.transaction_id, idxLayout.datetime}, {idxLayout},
				    			scout.logs.util.fn_getMySuperKeyNameByKeyForDailyBuild(idxKeyName),
							opt)(datetime[1..8] = Scout.logs.files_stg.yesterday);

end;