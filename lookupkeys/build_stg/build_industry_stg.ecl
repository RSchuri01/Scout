IMPORT std.File;
IMPORT * from scout.lookupkeys;
IMPORT std;
IMPORT scout.common.util;
IMPORT scout.lookupkeys.layouts.spray;

spray_ds := lookupkeys.files_spray.industry_ds(industry <> '');
stg_ds   := lookupkeys.files_stg.industry_ds;

layout := lookupkeys.layouts.stg.industry;

prj_spr_ds := PROJECT(spray_ds,
					  TRANSFORM(layout,
								self.WUID	:= workunit;
								SELF		:= LEFT));

max_id := max(stg_ds, industry_id);


layout t_merge(layout o, layout n)  := transform
	self.industry_id := o.industry_id; // do not overwrite
	self := if(n.industry_id <> 0 , o, n); // overwrite all new if available
end;

merged_recs := join(distribute(stg_ds, hash64(industry)), 
					distribute(prj_spr_ds, hash64(industry)),
								left.industry 	= right.industry,
								    t_merge(left,right),
								    full outer,
									local);

stgtbl 		:= table(stg_ds, {industry, x:= count(group)}, industry) (x > 1);
mergetbl 	:= table(merged_recs, {industry, x:= count(group)}, industry)(x > 1);

layout assign_id(layout l, layout r) := transform
	self.industry_id := max(max_id, l.industry_id ) + 1;
	self := r;
end;

with_id := iterate(merged_recs(industry_id = 0),assign_id(left,right));

both 	:= merged_recs(industry_id != 0) + with_id;

export build_industry_stg	:= IF ((count(stgtbl) > 0 OR count(mergetbl) > 0), 
									fail ('industry MergeTable has dups'),
									util.fn_promote_ds(both, lookupkeys.files_stg.stg_prefix, files_stg.industry));

