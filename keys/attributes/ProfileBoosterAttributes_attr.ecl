﻿import scout;
import scout.logs;
import std;
import scout.logs.layout as layout;
IMPORT DataMgmt;
IMPORT scout.common.constants;

EXPORT ProfileBoosterAttributes_attr := MODULE

SHARED infile := scout.logs.files_stg.online_stg_ds : INDEPENDENT;

espName := 'PROFILEBOOSTERATTRIBUTES';

EXPORT mbs_base_slim := infile(std.str.touppercase(TRIM(esp_method))[1..LENGTH(espName)] = espName  and regexfind('<Attributes>', outputxml));
mbs_logs := project(mbs_base_slim, transform(layout.base_transaction,
	SELF.outputxml := '<ProfileBoosterAttributes><Datetime>' + LEFT.Datetime + '</Datetime>' + LEFT.outputxml + '</ProfileBoosterAttributes>',
				self := left, self := []));
			
layout.attributes     parseoutput() := transform

  SELF.Transaction_ID	:= TRIM(XMLTEXT('Header/TransactionId')); // Forced into the record so I can join it all together
  SELF.datetime       := TRIM(XMLTEXT('Datetime'));
//attributes
  SELF.Attribute1Value     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[1]/Value'));
  SELF.Attribute1Name      := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[1]/Name')) ;  
	SELF.Attribute2Name      := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[2]/Name')) ;
  SELF.Attribute2Value     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[2]/Value')) ;
  SELF.Attribute3Name      := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[3]/Name')) ;
  SELF.Attribute3Value     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[3]/Value')) ;
  SELF.Attribute4Name      := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[4]/Name')) ;
  SELF.Attribute4Value     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[4]/Value')) ;
  SELF.Attribute5Name      := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[5]/Name')) ;
  SELF.Attribute5Value     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[5]/Value')) ;
  SELF.Attribute6Name      := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[6]/Name')) ;
  SELF.Attribute6Value     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[6]/Value'));
  SELF.Attribute7Name      := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[7]/Name')) ;
  SELF.Attribute7Value     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[7]/Value')) ;
  SELF.Attribute8Name      := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[8]/Name')) ;
  SELF.Attribute8Value     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[8]/Value')) ;
  SELF.Attribute9Name      := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[9]/Name')) ;
  SELF.Attribute9Value     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[9]/Value')) ;
  SELF.Attribute10Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[10]/Name')) ;
  SELF.Attribute10Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[10]/Value'));
  SELF.Attribute11Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[11]/Name')) ;
  SELF.Attribute11Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[11]/Value'));
  SELF.Attribute12Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[12]/Name')) ;
  SELF.Attribute12Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[12]/Value'));
  SELF.Attribute13Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[13]/Name')) ;
  SELF.Attribute13Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[13]/Value'));
  SELF.Attribute14Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[14]/Name')) ;
  SELF.Attribute14Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[14]/Value'));
  SELF.Attribute15Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[15]/Name')) ;
  SELF.Attribute15Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[15]/Value'));
  SELF.Attribute16Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[16]/Name')) ;
  SELF.Attribute16Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[16]/Value'));
  SELF.Attribute17Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[17]/Name')) ;
  SELF.Attribute17Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[17]/Value'));
  SELF.Attribute18Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[18]/Name')) ;
  SELF.Attribute18Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[18]/Value'));
  SELF.Attribute19Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[19]/Name')) ;
  SELF.Attribute19Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[19]/Value'));
  SELF.Attribute20Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[20]/Name')) ;
  SELF.Attribute20Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[20]/Value'));
  SELF.Attribute21Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[21]/Name')) ;
  SELF.Attribute21Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[21]/Value'));
  SELF.Attribute22Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[22]/Name')) ;
  SELF.Attribute22Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[22]/Value'));
  SELF.Attribute23Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[23]/Name')) ;
  SELF.Attribute23Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[23]/Value'));
  SELF.Attribute24Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[24]/Name')) ;
  SELF.Attribute24Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[24]/Value'));
  SELF.Attribute25Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[25]/Name')) ;
  SELF.Attribute25Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[25]/Value'));
  SELF.Attribute26Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[26]/Name')) ;
  SELF.Attribute26Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[26]/Value'));
  SELF.Attribute27Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[27]/Name')) ;
  SELF.Attribute27Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[27]/Value'));
  SELF.Attribute28Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[28]/Name')) ;
  SELF.Attribute28Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[28]/Value'));
  SELF.Attribute29Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[29]/Name')) ;
  SELF.Attribute29Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[29]/Value'));
  SELF.Attribute30Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[30]/Name')) ;
  SELF.Attribute30Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[30]/Value'));
  SELF.Attribute31Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[31]/Name')) ;
  SELF.Attribute31Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[31]/Value'));
  SELF.Attribute32Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[32]/Name')) ;
  SELF.Attribute32Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[32]/Value'));
  SELF.Attribute33Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[33]/Name')) ;
  SELF.Attribute33Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[33]/Value'));
  SELF.Attribute34Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[34]/Name')) ;
  SELF.Attribute34Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[34]/Value'));
  SELF.Attribute35Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[35]/Name')) ;
  SELF.Attribute35Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[35]/Value'));
  SELF.Attribute36Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[36]/Name')) ;
  SELF.Attribute36Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[36]/Value'));
  SELF.Attribute37Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[37]/Name')) ;
  SELF.Attribute37Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[37]/Value'));
  SELF.Attribute38Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[38]/Name')) ;
  SELF.Attribute38Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[38]/Value'));
  SELF.Attribute39Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[39]/Name')) ;
  SELF.Attribute39Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[39]/Value'));
  SELF.Attribute40Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[40]/Name')) ;
  SELF.Attribute40Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[40]/Value'));
  SELF.Attribute41Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[41]/Name')) ;
  SELF.Attribute41Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[41]/Value'));
  SELF.Attribute42Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[42]/Name')) ;
  SELF.Attribute42Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[42]/Value'));
  SELF.Attribute43Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[43]/Name')) ;
  SELF.Attribute43Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[43]/Value'));
  SELF.Attribute44Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[44]/Name')) ;
  SELF.Attribute44Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[44]/Value'));
  SELF.Attribute45Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[45]/Name')) ;
  SELF.Attribute45Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[45]/Value'));
  SELF.Attribute46Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[46]/Name')) ;
  SELF.Attribute46Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[46]/Value'));
  SELF.Attribute47Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[47]/Name')) ;
  SELF.Attribute47Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[47]/Value'));
  SELF.Attribute48Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[48]/Name')) ;
  SELF.Attribute48Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[48]/Value'));
  SELF.Attribute49Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[49]/Name')) ;
  SELF.Attribute49Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[49]/Value'));
  SELF.Attribute50Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[50]/Name')) ;
  SELF.Attribute50Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[50]/Value'));
  SELF.Attribute51Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[51]/Name')) ;
  SELF.Attribute51Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[51]/Value'));
  SELF.Attribute52Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[52]/Name')) ;
  SELF.Attribute52Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[52]/Value'));
  SELF.Attribute53Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[53]/Name')) ;
  SELF.Attribute53Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[53]/Value'));
  SELF.Attribute54Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[54]/Name')) ;
  SELF.Attribute54Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[54]/Value'));
  SELF.Attribute55Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[55]/Name')) ;
  SELF.Attribute55Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[55]/Value'));
  SELF.Attribute56Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[56]/Name')) ;
  SELF.Attribute56Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[56]/Value'));
  SELF.Attribute57Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[57]/Name')) ;
  SELF.Attribute57Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[57]/Value'));
  SELF.Attribute58Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[58]/Name')) ;
  SELF.Attribute58Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[58]/Value'));
  SELF.Attribute59Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[59]/Name')) ;
  SELF.Attribute59Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[59]/Value'));
  SELF.Attribute60Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[60]/Name')) ;
  SELF.Attribute60Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[60]/Value'));
  SELF.Attribute61Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[61]/Name')) ;
  SELF.Attribute61Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[61]/Value'));
  SELF.Attribute62Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[62]/Name')) ;
  SELF.Attribute62Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[62]/Value'));
  SELF.Attribute63Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[63]/Name')) ;
  SELF.Attribute63Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[63]/Value'));
  SELF.Attribute64Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[64]/Name')) ;
  SELF.Attribute64Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[64]/Value'));
  SELF.Attribute65Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[65]/Name')) ;
  SELF.Attribute65Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[65]/Value'));
  SELF.Attribute66Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[66]/Name')) ;
  SELF.Attribute66Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[66]/Value'));
  SELF.Attribute67Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[67]/Name')) ;
  SELF.Attribute67Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[67]/Value'));
  SELF.Attribute68Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[68]/Name')) ;
  SELF.Attribute68Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[68]/Value'));
  SELF.Attribute69Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[69]/Name')) ;
  SELF.Attribute69Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[69]/Value'));
  SELF.Attribute70Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[70]/Name')) ;
  SELF.Attribute70Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[70]/Value'));
  SELF.Attribute71Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[71]/Name')) ;
  SELF.Attribute71Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[71]/Value'));
  SELF.Attribute72Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[72]/Name')) ;
  SELF.Attribute72Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[72]/Value'));
  SELF.Attribute73Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[73]/Name')) ;
  SELF.Attribute73Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[73]/Value'));
  SELF.Attribute74Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[74]/Name')) ;
  SELF.Attribute74Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[74]/Value'));
  SELF.Attribute75Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[75]/Name')) ;
  SELF.Attribute75Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[75]/Value'));
  SELF.Attribute76Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[76]/Name')) ;
  SELF.Attribute76Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[76]/Value'));
  SELF.Attribute77Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[77]/Name')) ;
  SELF.Attribute77Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[77]/Value'));
  SELF.Attribute78Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[78]/Name')) ;
  SELF.Attribute78Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[78]/Value'));
  SELF.Attribute79Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[79]/Name')) ;
  SELF.Attribute79Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[79]/Value'));
  SELF.Attribute80Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[80]/Name')) ;
  SELF.Attribute80Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[80]/Value'));
  SELF.Attribute81Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[81]/Name')) ;
  SELF.Attribute81Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[81]/Value'));
  SELF.Attribute82Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[82]/Name')) ;
  SELF.Attribute82Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[82]/Value'));
  SELF.Attribute83Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[83]/Name')) ;
  SELF.Attribute83Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[83]/Value'));
  SELF.Attribute84Name     := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[84]/Name')) ;
  SELF.Attribute84Value    := TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[84]/Value'));
  SELF.Attribute85Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[85]/Name'));
	SELF.Attribute85Value	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[85]/Value'));
	SELF.Attribute86Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[86]/Name'));
	SELF.Attribute86Value    :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[86]/Value'));
	SELF.Attribute87Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[87]/Name'));
	SELF.Attribute87Value	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[87]/Value'));
	SELF.Attribute88Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[88]/Name'));
	SELF.Attribute88Value	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[88]/Value'));
	SELF.Attribute89Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[89]/Name'));
	SELF.Attribute89Value	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[89]/Value'));
	SELF.Attribute90Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[90]/Name'));
	SELF.Attribute90Value  	 :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[90]/Value'));
	SELF.Attribute91Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[91]/Name'));
	SELF.Attribute91Value	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[91]/Value'));
	SELF.Attribute92Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[92]/Name'));
	SELF.Attribute92Value	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[92]/Value'));
	SELF.Attribute93Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[93]/Name'));
	SELF.Attribute93Value	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[93]/Value'));
	SELF.Attribute94Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[94]/Name'));
	SELF.Attribute94Value	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[94]/Value'));
	SELF.Attribute95Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[95]/Name'));
	SELF.Attribute95Value	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[95]/Value'));
	SELF.Attribute96Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[96]/Name'));
	SELF.Attribute96Value	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[96]/Value'));
	SELF.Attribute97Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[97]/Name'));
	SELF.Attribute97Value	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[97]/Value'));
	SELF.Attribute98Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[98]/Name'));
	SELF.Attribute98Value	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[98]/Value'));
	SELF.Attribute99Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[99]/Name'));
	SELF.Attribute99Value	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[99]/Value'));
	SELF.Attribute100Name	   :=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[100]/Name'));
	SELF.Attribute100Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[100]/Value'));
	SELF.Attribute101Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[101]/Name'));
	SELF.Attribute101Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[101]/Value'));
	SELF.Attribute102Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[102]/Name'));
	SELF.Attribute102Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[102]/Value'));
	SELF.Attribute103Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[103]/Name'));
	SELF.Attribute103Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[103]/Value'));
	SELF.Attribute104Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[104]/Name'));
	SELF.Attribute104Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[104]/Value'));
	SELF.Attribute105Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[105]/Name'));
	SELF.Attribute105Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[105]/Value'));
	SELF.Attribute106Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[106]/Name'));
	SELF.Attribute106Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[106]/Value'));
	SELF.Attribute107Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[107]/Name'));
	SELF.Attribute107Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[107]/Value'));
	SELF.Attribute108Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[108]/Name'));
	SELF.Attribute108Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[108]/Value'));
	SELF.Attribute109Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[109]/Name'));
	SELF.Attribute109Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[109]/Value'));
	SELF.Attribute110Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[110]/Name'));
	SELF.Attribute110Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[110]/Value'));
	SELF.Attribute111Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[111]/Name'));
	SELF.Attribute111Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[111]/Value'));
	SELF.Attribute112Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[112]/Name'));
	SELF.Attribute112Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[112]/Value'));
	SELF.Attribute113Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[113]/Name'));
	SELF.Attribute113Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[113]/Value'));
	SELF.Attribute114Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[114]/Name'));
	SELF.Attribute114Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[114]/Value'));
	SELF.Attribute115Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[115]/Name'));
	SELF.Attribute115Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[115]/Value'));
	SELF.Attribute116Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[116]/Name'));
	SELF.Attribute116Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[116]/Value'));
	SELF.Attribute117Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[117]/Name'));
	SELF.Attribute117Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[117]/Value'));
	SELF.Attribute118Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[118]/Name'));
	SELF.Attribute118Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[118]/Value'));
	SELF.Attribute119Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[119]/Name'));
	SELF.Attribute119Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[119]/Value'));
	SELF.Attribute120Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[120]/Name'));
	SELF.Attribute120Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[120]/Value'));
	SELF.Attribute121Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[121]/Name'));
	SELF.Attribute121Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[121]/Value'));
	SELF.Attribute122Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[122]/Name'));
	SELF.Attribute122Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[122]/Value'));
	SELF.Attribute123Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[123]/Name'));
	SELF.Attribute123Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[123]/Value'));
	SELF.Attribute124Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[124]/Name'));
	SELF.Attribute124Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[124]/Value'));
	SELF.Attribute125Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[125]/Name'));
	SELF.Attribute125Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[125]/Value'));
	SELF.Attribute126Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[126]/Name'));
	SELF.Attribute126Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[126]/Value'));
	SELF.Attribute127Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[127]/Name'));
	SELF.Attribute127Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[127]/Value'));
	SELF.Attribute128Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[128]/Name'));
	SELF.Attribute128Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[128]/Value'));
	SELF.Attribute129Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[129]/Name'));
	SELF.Attribute129Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[129]/Value'));
	SELF.Attribute130Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[130]/Name'));
	SELF.Attribute130Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[130]/Value'));
	SELF.Attribute131Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[131]/Name'));
	SELF.Attribute131Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[131]/Value'));
	SELF.Attribute132Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[132]/Name'));
	SELF.Attribute132Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[132]/Value'));
	SELF.Attribute133Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[133]/Name'));
	SELF.Attribute133Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[133]/Value'));
	SELF.Attribute134Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[134]/Name'));
	SELF.Attribute134Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[134]/Value'));
	SELF.Attribute135Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[135]/Name'));
	SELF.Attribute135Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[135]/Value'));
	SELF.Attribute136Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[136]/Name'));
	SELF.Attribute136Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[136]/Value'));
	SELF.Attribute137Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[137]/Name'));
	SELF.Attribute137Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[137]/Value'));
	SELF.Attribute138Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[138]/Name'));
	SELF.Attribute138Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[138]/Value'));
	SELF.Attribute139Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[139]/Name'));
	SELF.Attribute139Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[139]/Value'));
	SELF.Attribute140Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[140]/Name'));
	SELF.Attribute140Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[140]/Value'));
	SELF.Attribute141Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[141]/Name'));
	SELF.Attribute141Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[141]/Value'));
	SELF.Attribute142Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[142]/Name'));
	SELF.Attribute142Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[142]/Value'));
	SELF.Attribute143Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[143]/Name'));
	SELF.Attribute143Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[143]/Value'));
	SELF.Attribute144Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[144]/Name'));
	SELF.Attribute144Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[144]/Value'));
	SELF.Attribute145Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[145]/Name'));
	SELF.Attribute145Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[145]/Value'));
	SELF.Attribute146Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[146]/Name'));
	SELF.Attribute146Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[146]/Value'));
	SELF.Attribute147Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[147]/Name'));
	SELF.Attribute147Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[147]/Value'));
	SELF.Attribute148Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[148]/Name'));
	SELF.Attribute148Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[148]/Value'));
	SELF.Attribute149Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[149]/Name'));
	SELF.Attribute149Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[149]/Value'));
	SELF.Attribute150Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[150]/Name'));
	SELF.Attribute150Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[150]/Value'));
	SELF.Attribute151Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[151]/Name'));
	SELF.Attribute151Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[151]/Value'));
	SELF.Attribute152Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[152]/Name'));
	SELF.Attribute152Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[152]/Value'));
	SELF.Attribute153Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[153]/Name'));
	SELF.Attribute153Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[153]/Value'));
	SELF.Attribute154Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[154]/Name'));
	SELF.Attribute154Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[154]/Value'));
	SELF.Attribute155Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[155]/Name'));
	SELF.Attribute155Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[155]/Value'));
	SELF.Attribute156Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[156]/Name'));
	SELF.Attribute156Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[156]/Value'));
	SELF.Attribute157Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[157]/Name'));
	SELF.Attribute157Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[157]/Value'));
	SELF.Attribute158Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[158]/Name'));
	SELF.Attribute158Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[158]/Value'));
	SELF.Attribute159Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[159]/Name'));
	SELF.Attribute159Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[159]/Value'));
	SELF.Attribute160Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[160]/Name'));
	SELF.Attribute160Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[160]/Value'));
	SELF.Attribute161Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[161]/Name'));
	SELF.Attribute161Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[161]/Value'));
	SELF.Attribute162Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[162]/Name'));
	SELF.Attribute162Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[162]/Value'));
	SELF.Attribute163Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[163]/Name'));
	SELF.Attribute163Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[163]/Value'));
	SELF.Attribute164Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[164]/Name'));
	SELF.Attribute164Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[164]/Value'));
	SELF.Attribute165Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[165]/Name'));
	SELF.Attribute165Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[165]/Value'));
	SELF.Attribute166Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[166]/Name'));
	SELF.Attribute166Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[166]/Value'));
	SELF.Attribute167Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[167]/Name'));
	SELF.Attribute167Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[167]/Value'));
	SELF.Attribute168Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[168]/Name'));
	SELF.Attribute168Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[168]/Value'));
	SELF.Attribute169Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[169]/Name'));
	SELF.Attribute169Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[169]/Value'));
	SELF.Attribute170Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[170]/Name'));
	SELF.Attribute170Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[170]/Value'));
	SELF.Attribute171Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[171]/Name'));
	SELF.Attribute171Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[171]/Value'));
	SELF.Attribute172Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[172]/Name'));
	SELF.Attribute172Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[172]/Value'));
	SELF.Attribute173Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[173]/Name'));
	SELF.Attribute173Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[173]/Value'));
	SELF.Attribute174Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[174]/Name'));
	SELF.Attribute174Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[174]/Value'));
	SELF.Attribute175Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[175]/Name'));
	SELF.Attribute175Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[175]/Value'));
	SELF.Attribute176Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[176]/Name'));
	SELF.Attribute176Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[176]/Value'));
	SELF.Attribute177Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[177]/Name'));
	SELF.Attribute177Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[177]/Value'));
	SELF.Attribute178Name		:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[178]/Name'));
	SELF.Attribute178Value	:=	TRIM(XMLTEXT('AttributesGroup/Attributes/Attribute[178]/Value'));                                                                                                     
	self := [];
 
  END;

parsedoutput := PARSE(mbs_logs, outputxml, parseOutput(), XML('ProfileBoosterAttributes'));               


SHARED projectedData := project(parsedoutput, transform(layout.attributes,
					   self.esp_method := 'ProfileBoosterAttributes', self := left));

SHARED ProfileBoosterAttributes := dedup(
	        normalize(projectedData, 2160, scout.logs.util.fn_transformattributesByNormalize(left, counter), local), all, local);

export idxKeyName := scout.common.constants.ProfileBoosterAttributes_attr_keyName;

export twoyrHistoryFileName := scout.logs.keys.key_constants('2yearhistory').ProfileBoosterAttributes_idx;

SHARED subIdxFileName(String pversion) := scout.logs.util.fn_getMySubKeyNameByKey(idxKeyName, pversion);

SHARED idxLayout := RECORDOF(ProfileBoosterAttributes);

EXPORT readIdxSubFileData(String pversion):= PULL(INDEX(DATASET([],RECORDOF(idxLayout)), 
                                 {idxLayout.transaction_id}, {idxLayout},
										 subIdxFileName(pversion)));

EXPORT  superFileName(Boolean isSuperFor2Years = true) := scout.logs.util.fn_getMySuperKeyNameByKey(idxKeyName, isSuperFor2Years);

export indexDailyStgFile(String pv, boolean isRollupAsked)  := scout.logs.util.fn_buildSubKeyAndAddToSuperKey(INDEX(ProfileBoosterAttributes(transaction_id <> '' and AttributeName <> ''), 
                                 {ProfileBoosterAttributes.transaction_id, ProfileBoosterAttributes.datetime}, {ProfileBoosterAttributes},
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