function tags=LM_feature_tag( tagmap, db, idx, pfx_images, pfx_keys, data_min_sigma ),
	
	anno = db(idx).annotation;
	info = imfinfo( [pfx_images, '/', anno.folder, '/', anno.filename ] );
	sz = [info.Height, info.Width];
	s = max(sz)/512;
	f = LMloadfeatures( db, idx, pfx_keys ); 
	sel = find( f(3,:)>=data_min_sigma );
	f = f(:,sel);
	f(1,:) = f(1,:)*s;
	f(2,:) = f(2,:)*s;

	tags = nan(size(f,2),1);

	if isfield(anno, 'object'),
		for i=1:length(anno.object),
			if isfield(anno.object(i), 'tag'),
				[xv,yv] = getLMpolygon( anno.object(i).polygon );
				in = inpolygon( f(1,:), f(2,:), xv, yv );
				tags( find(in) ) = tagmap.get(anno.object(i).tag);
			end
		end
	end
end

