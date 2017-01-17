for i=1:length(LMTrainDatabase),
	anno = LMTrainDatabase(i).annotation;
	if ~isfield(anno, 'object'),
		continue;
	end
	for j=1:length(anno.object),
		obj=anno.object(j);
		if ~isfield(obj, 'tag')
			continue;
		end
		if ~strcmp(obj.name, obj.tag),
			disp(obj)
		end
	end
end
			
