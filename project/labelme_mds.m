LM_TRAIN_ANNOTATIONS='/tmp/working-roman/labelme/train/Annotations';
LM_TRAIN_IMAGES='/tmp/working-roman/labelme/train/Images';

if ~exist('LMTrainDatabase', 'var'),
	LMTrainDatabase = LMdatabase( LM_TRAIN_ANNOTATIONS );
end

tags = java.util.HashMap;
idx=1;
for i=1:length(LMTrainDatabase),
	if isfield(LMTrainDatabase(i).annotation, 'object'),
	for j=1:length(LMTrainDatabase(i).annotation.object),
		if isfield(LMTrainDatabase(i).annotation.object(j), 'tag')
		if ~tags.containsKey( LMTrainDatabase(i).annotation.object(j).tag),
			tags.put( LMTrainDatabase(i).annotation.object(j).name, idx );
			tagarray{idx} = LMTrainDatabase(i).annotation.object(j).tag;
			idx = idx+1;
		end
		end
	end
	end
end

W = zeros( length(LMTrainDatabase), tags.size );
for i=1:length(LMTrainDatabase),
	if isfield(LMTrainDatabase(i).annotation, 'object'),
	for j=1:length(LMTrainDatabase(i).annotation.object),
		if isfield(LMTrainDatabase(i).annotation.object(j), 'tag')
			idx = tags.get(  LMTrainDatabase(i).annotation.object(j).tag );
			W( i, idx )=1;
		end
	end
end
end
[Y,I] = sort( sum(W), 'descend');
W=W(:,I);

A = distance_matrix_l1(W');
[w2,err] = mds(A,2);

% assign a size to each instance inversely proportional to how frequent its tags are
X = ceil(20*exp(-sum( W .* repmat( Y, [size(W,1), 1] ), 2)));  

scatter3(w2(1,:),w2(2,:),w2(3,:),X ,W(1,:));
