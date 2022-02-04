IMPORT std.File;
IMPORT * from scout.lookupkeys;
IMPORT std;
IMPORT scout.common.util;
IMPORT scout.lookupkeys.layouts.spray;

spray_ds := lookupkeys.files_spray.scores_ds(product <> '');
stg_ds   := lookupkeys.files_stg.scores_ds;
product_stg_ds 	:= lookupkeys.files_stg.products_ds; 

layout := lookupkeys.layouts.stg.scores;

prj_spr_ds := PROJECT(spray_ds,
					  TRANSFORM(layout,
								self.WUID	:= workunit;
								SELF		:= LEFT));

max_id := max(stg_ds, score_id);


layout t_merge(layout o, layout n)  := transform
	self.score_id 	:= o.score_id; // do not overwrite
	self 			:= if(n.score_id <> 0 , o, n); // overwrite all new if available
end;

merged_recs := join(distribute(stg_ds, hash64(product, score)), 
					distribute(prj_spr_ds, hash64(product, score)),
										left.product 			= right.product
										and left.score 	= right.score,
								    t_merge(left,right),
								    full outer,
									local)(product <> '' and score_type <>'');

tbl_stg 	:= table(stg_ds, {product, score,  x:= count(group)}, product, score, score_type)(x > 1);
tbl_merge 	:= table(merged_recs, {product, score,  x:= count(group)}, product, score, score_type)(x > 1);


layout assign_id(layout l, layout r) := transform
	self.score_id := max(max_id, l.score_id ) + 1;
	self := r;
end;

with_id := iterate(merged_recs(score_id = 0),assign_id(left,right));

both 	:= merged_recs(score_id != 0) + with_id;

join_product := JOIN (both, product_stg_ds,
					  trim(std.str.tolowercase(left.product), all) = trim(std.str.tolowercase(right.product), all),
					  transform(recordof(left),
					  			self.product_id := right.product_id,
					  			self			:= left), lookup); 
					  			
					  			
export build_scores_stg	:= IF (count(tbl_stg) > 0,
									fail('StgTable has dups'),
									IF (COUNT(tbl_merge) > 0, 
										fail ('Scores MergeTable has dups'),
										util.fn_promote_ds(join_product, lookupkeys.files_stg.stg_prefix, files_stg.scores)));