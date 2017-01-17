function tags=LMtaglist(db),
	tagset = java.util.HashSet;
	idx=1;
	for i=1:length(db)
		if ~isfield(db(i).annotation, 'object'),
			continue;
		end
		for j=1:length(db(i).annotation.object),
			if ~isfield( db(i).annotation.object(j), 'tag'),
				continue;
			end
			if ~tagset.contains( db(i).annotation.object(j).tag ),
				tagset.add( db(i).annotation.object(j).tag );
				tags{idx} = db(i).annotation.object(j).tag;
				idx = idx+1;
			end
		end
	end
end%function
