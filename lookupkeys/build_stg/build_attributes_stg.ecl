IMPORT std.File;
IMPORT * from scout.lookupkeys;
IMPORT std;
IMPORT scout.common.util;
IMPORT scout.lookupkeys.layouts.spray;

spray_ds 		:= lookupkeys.files_spray.attributes_ds(product <> '' or attribute <> '');
stg_ds   		:= lookupkeys.files_stg.attributes_ds;
product_stg_ds 	:= lookupkeys.files_stg.products_ds; 

layout := lookupkeys.layouts.stg.attributes;

prj_spr_ds := PROJECT(spray_ds,
					  TRANSFORM(layout,
								self.WUID	:= workunit;
								SELF		:= LEFT));

max_id := max(stg_ds, attribute_id);


layout t_merge(layout o, layout n)  := transform
	self.attribute_id := o.attribute_id; // do not overwrite
	self := if(n.attribute_id <> 0 , o, n); // overwrite all new if available
end;

merged_recs := join(distribute(stg_ds, hash64(product, attribute)), 
					distribute(prj_spr_ds, hash64(product, attribute)),
										left.product 		= right.product
										and left.attribute 	= right.attribute,
								    t_merge(left,right),
								    full outer,
									local);

stgtbl 		:= table(stg_ds, {product, attribute, x:= count(group)}, product,attribute) (product <> '' and attribute <> '' and x > 1);
mergetbl 	:= table(merged_recs, {product, attribute, x:= count(group)}, product,attribute)(product <> '' and attribute <> '' and x > 1);

layout assign_id(layout l, layout r) := transform
	self.attribute_id := max(max_id, l.attribute_id ) + 1;
	self := r;
end;

with_id := iterate(merged_recs(attribute_id = 0),assign_id(left,right));

both 	:= merged_recs(attribute_id != 0) + with_id;

join_product := JOIN (both, product_stg_ds,
					  trim(std.str.tolowercase(left.product), all) = trim(std.str.tolowercase(right.product), all),
					  transform(recordof(left),
					  			self.product_id := right.product_id,
					  			self			:= left), lookup); 
					  			
					  
export build_attributes_stg	:= IF ((count(stgtbl) > 0 OR count(mergetbl) > 0), 
									fail ('Attributes MergeTable has dups'),
									util.fn_promote_ds(join_product, lookupkeys.files_stg.stg_prefix, files_stg.attributes));

