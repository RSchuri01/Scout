IMPORT std.File;
IMPORT * from scout.lookupkeys;
IMPORT std;
IMPORT scout.common.util;
IMPORT scout.lookupkeys.layouts.spray;

spray_ds := lookupkeys.files_spray.reasoncodes_ds( product <> '' or reasoncode <> '');
stg_ds   := lookupkeys.files_stg.reasoncodes_ds;
product_stg_ds 	:= lookupkeys.files_stg.products_ds; 

layout := lookupkeys.layouts.stg.reasoncodes;

prj_spr_ds := PROJECT(spray_ds,
					  TRANSFORM(layout,
								self.WUID	:= workunit;
								SELF		:= LEFT));

max_id := max(stg_ds, reasoncode_id);


layout t_merge(layout o, layout n)  := transform
	self.reasoncode_id 	:= o.reasoncode_id; // do not overwrite
	self 				:= if(n.reasoncode_id <> 0 , o, n); // overwrite all new if available
end;

merged_recs := join(distribute(stg_ds, hash64(product, reasoncode)), 
					distribute(prj_spr_ds, hash64(product, reasoncode)),
										left.product 			= right.product
										and left.reasoncode 	= right.reasoncode,
								    t_merge(left,right),
								    full outer,
									local);

tbl_stg 	:= table(stg_ds, {product, reasoncode, 	 x:= count(group)}, product, reasoncode)(x > 1);
tbl_merge := table(merged_recs, {product, reasoncode, x:= count(group)}, product, reasoncode)(x > 1);

layout assign_id(layout l, layout r) := transform
	self.reasoncode_id := max(max_id, l.reasoncode_id ) + 1;
	self := r;
end;

with_id := iterate(merged_recs(reasoncode_id = 0),assign_id(left,right));

both 	:= merged_recs(reasoncode_id != 0) + with_id;

join_product := JOIN (both, product_stg_ds,
					  trim(std.str.tolowercase(left.product), all) = trim(std.str.tolowercase(right.product), all),
					  transform(recordof(left),
					  			self.product_id := right.product_id,
					  			self			:= left), lookup); 
					  			
					  			
export build_reasoncodes_stg	:= IF (count(tbl_stg) > 0,
									fail('StgTable has dups'),
									IF (COUNT(tbl_merge) > 0, 
										fail ('Reasoncodes MergeTable has dups'),
										util.fn_promote_ds(join_product, lookupkeys.files_stg.stg_prefix, files_stg.reasoncodes)));