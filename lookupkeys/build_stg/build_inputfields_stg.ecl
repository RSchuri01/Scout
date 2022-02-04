IMPORT std.File;
IMPORT * from scout.lookupkeys;
IMPORT std;
IMPORT scout.common.util;
IMPORT scout.lookupkeys.layouts.spray;

spray_ds := lookupkeys.files_spray.inputfields_ds(product <> '' or input_field <> '' or source <> '');
stg_ds   := lookupkeys.files_stg.inputfields_ds;
product_stg_ds 	:= lookupkeys.files_stg.products_ds; 

layout := lookupkeys.layouts.stg.inputfields;

prj_spr_ds := PROJECT(spray_ds,
					  TRANSFORM(layout,
								self.WUID	:= workunit;
								SELF		:= LEFT));

max_id := max(stg_ds, inputfield_id);


layout t_merge(layout o, layout n)  := transform
	self.inputfield_id := o.inputfield_id; // do not overwrite
	self := if(n.inputfield_id <> 0 , o, n); // overwrite all new if available
end;

merged_recs := join(distribute(stg_ds, hash64(product, input_field, source, path)), 
					distribute(prj_spr_ds, hash64(product, input_field, source, path)),
										left.product 			= right.product
										and left.input_field 	= right.input_field
										and left.source			= right.source
										and left.path			= right.path,
								    t_merge(left,right),
								    full outer,
									local);

tbl_stg 	:= table(stg_ds, {product, input_field, source, path, x:= count(group)}, product, input_field, source, path) (x > 1);
tbl_merge 	:= table(merged_recs, {product, input_field, source, path, x:= count(group)}, product, input_field, source, path)(x > 1);

layout assign_id(layout l, layout r) := transform
	self.inputfield_id := max(max_id, l.inputfield_id ) + 1;
	self := r;
end;

with_id := iterate(merged_recs(inputfield_id = 0),assign_id(left,right));

both 	:= merged_recs(inputfield_id != 0) + with_id;

join_product := JOIN (both, product_stg_ds,
					  trim(std.str.tolowercase(left.product), all) = trim(std.str.tolowercase(right.product), all),
					  transform(recordof(left),
					  			self.product_id := right.product_id,
					  			self			:= left), lookup); 
					  			
export build_inputfields_stg	:= IF (count(tbl_stg) > 0,
									fail('StgTable has dups'),
									IF (COUNT(tbl_merge) > 0, 
										fail ('InputFields MergeTable has dups'),
										util.fn_promote_ds(join_product, lookupkeys.files_stg.stg_prefix, files_stg.inputfields)));

