IMPORT std.File;
IMPORT * from scout.lookupkeys;
IMPORT std;
IMPORT scout.common.util;
IMPORT scout.lookupkeys.layouts.spray;

spray_ds := lookupkeys.files_spray.products_ds(product <> '');
stg_ds   := lookupkeys.files_stg.products_ds;

layout := lookupkeys.layouts.stg.products;

prj_spr_ds := PROJECT(spray_ds,
					  TRANSFORM(layout,
								self.WUID	:= workunit;
								SELF		:= LEFT));

max_id := max(stg_ds, product_id);


layout t_merge(layout o, layout n)  := transform
	self.product_id 	:= o.product_id; // do not overwrite
	self 				:= if(n.product_id <> 0 , o, n); // overwrite all new if available
end;

merged_recs := join(distribute(stg_ds, hash64(product)), 
					distribute(prj_spr_ds, hash64(product)),
										left.product = right.product,
								    t_merge(left,right),
								    full outer,
									local);

tbl_stg 	:= table(stg_ds, {product, x:= count(group)}, product, product)(x > 1);
tbl_merge 	:= table(merged_recs, {product, x:= count(group)}, product, product)(x > 1);

layout assign_id(layout l, layout r) := transform
	self.product_id := max(max_id, l.product_id ) + 1;
	self := r;
end;

with_id := iterate(merged_recs(product_id = 0),assign_id(left,right));

both 	:= merged_recs(product_id != 0) + with_id;

export build_products_stg	:= IF (count(tbl_stg) > 0,
									fail('StgTable has dups'),
									IF (COUNT(tbl_merge) > 0, 
										fail ('Products MergeTable has dups'),
										util.fn_promote_ds(both, lookupkeys.files_stg.stg_prefix, files_stg.products)));