function features = LMloadfeatures(database, idx, pfx_keys)

	%data_min_sigma=1;

    % reconsturct image name from SIFT file name
	anno = database(idx).annotation;
	[PATHSTR,NAME,EXT] = fileparts(anno.filename);
    key_name      = [pfx_keys, '/', anno.folder, '/', NAME, '.key'];
    features = load(key_name, '-ASCII')' ;
	% throw away small features
	%sel = find(features(3,:) >= data_min_sigma) ;
	%features=features(:,sel);

end%function

