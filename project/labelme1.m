LM_TRAIN_ANNOTATIONS='/tmp/working-roman/labelme/train/Annotations';
LM_TRAIN_IMAGES='/tmp/working-roman/labelme/train/Images';

if ~exist('LMTrainDatabase', 'var'),
	LMTrainDatabase = LMdatabase( LM_TRAIN_ANNOTATIONS );
end

tags = java.util.HashMap;
idx=1;
for i=1:length(LMTrainDatabase),
	if ~isfield(LMTrainDatabase(i).annotation, 'object'),
		continue;
	end
	for j=1:length(LMTrainDatabase(i).annotation.object),
		if ~tags.containsKey( LMTrainDatabase(i).annotation.object(j).tag),
			tags.put( LMTrainDatabase(i).annotation.object(j).tag, idx );
			tagarray{idx} = LMTrainDatabase(i).annotation.object(j).tag;
			idx = idx+1;
		end
	end
end

W = zeros( length(LMTrainDatabase), tags.size );
for i=1:length(LMTrainDatabase),
	if ~isfield(LMTrainDatabase(i).annotation, 'object'),
		continue;
	end
	for j=1:length(LMTrainDatabase(i).annotation.object),
		idx = tags.get(  LMTrainDatabase(i).annotation.object(j).name );
		W( i, idx )=1;
	end
end
