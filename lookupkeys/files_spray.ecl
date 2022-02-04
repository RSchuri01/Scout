IMPORT * from $;
IMPORT scout;
IMPORT scout.lookupkeys.layouts.spray;

EXPORT files_spray := module

  EXPORT spray_prefix 	:= scout.common.scout_spray + '::lookupkeys::adhoc';
	
  EXPORT attributes		:= 'attributekey';
  EXPORT inputfields	:= 'inputfieldkey';
  EXPORT products		:= 'productkey';
  EXPORT reasoncodes	:= 'reasoncodekey';
  EXPORT scores			:= 'scorekey';
  EXPORT industry		:= 'industrykey';

  EXPORT attributes_ds 	:= DATASET(spray_prefix + '::' + attributes, 	spray.attributes, 	csv(separator(','), quote([]), heading(1)));
  EXPORT inputfields_ds := DATASET(spray_prefix + '::' + inputfields, 	spray.inputfields, 	csv(separator(','), quote([]), heading(1)));
  EXPORT products_ds 	:= DATASET(spray_prefix + '::' + products, 		spray.products, 	csv(separator(','), quote([]), heading(1)));
  EXPORT reasoncodes_ds	:= DATASET(spray_prefix + '::' + reasoncodes, 	spray.reasoncodes, 	csv(separator(','), quote([]), heading(1)));
  EXPORT scores_ds		:= DATASET(spray_prefix + '::' + scores, 		spray.scores, 		csv(separator(','), quote([]), heading(1)));
  EXPORT industry_ds	:= DATASET(spray_prefix + '::' + industry, 		spray.industry, 	csv(separator(','), quote([]), heading(1)));

END;