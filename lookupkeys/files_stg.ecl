IMPORT * from $;
IMPORT scout;
IMPORT scout.lookupkeys.layouts.stg;

EXPORT files_stg := module

  EXPORT stg_prefix 	:= scout.common.scout_stg + '::lookupkeys';
	
  EXPORT attributes		:= 'attributes';
  EXPORT inputfields	:= 'inputfields';
  EXPORT products		:= 'products';
  EXPORT reasoncodes	:= 'reasoncodes';
  EXPORT scores			:= 'scores';
  EXPORT industry		:= 'industry';

  EXPORT attributes_ds 	:= DATASET(DYNAMIC(stg_prefix + '::' + attributes), 	stg.attributes,		THOR, OPT);
  EXPORT inputfields_ds := DATASET(stg_prefix + '::' + inputfields, stg.inputfields, 	THOR, OPT);
  EXPORT products_ds 	:= DATASET(stg_prefix + '::' + products, 	stg.products, 		THOR, OPT);
  EXPORT reasoncodes_ds	:= DATASET(stg_prefix + '::' + reasoncodes, stg.reasoncodes, 	THOR, OPT);
  EXPORT scores_ds		:= DATASET(stg_prefix + '::' + scores, 		stg.scores, 		THOR, OPT);
  EXPORT industry_ds	:= DATASET(stg_prefix + '::' + industry, 	stg.industry, 		THOR, OPT);

END;