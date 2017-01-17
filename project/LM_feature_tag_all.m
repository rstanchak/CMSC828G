function tags=LM_feature_tag_all( tagmap, db, pfx_images, pfx_keys, data_min_sigma ),
	tags = nan(size([db.asgn], 2),1);
	k=1;
	for i = 1:length(db),
		tags1 = LM_feature_tag( tagmap, db, i, pfx_images, pfx_keys, data_min_sigma );
		tags(k:(k+length(tags1)-1)) = tags1;
		k=k+length(tags1);		
	end
end

