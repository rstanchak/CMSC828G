LM_TEST_ANNOTATIONS='/tmp/working-roman/labelme/test2008/Annotations';
LM_TEST_IMAGES='/tmp/working-roman/labelme/test2008/Images';

if ~exist('LMTestDatabase', 'var'),
	LMTestDatabase = LMdatabase( LM_TEST_ANNOTATIONS );
end

tags = java.util.HashMap;
idx=1;
for i=1:length(LMTestDatabase),
	for j=1:length(LMTestDatabase(i).annotation.object),
		if ~tags.containsKey( LMTestDatabase(i).annotation.object(j).name ),
			tags.put( LMTestDatabase(i).annotation.object(j).name, idx );
			tagarray{idx} = LMTestDatabase(i).annotation.object(j).name;
			idx = idx+1;
		end
	end
end

W = zeros( length(LMTestDatabase), tags.size );
for i=1:length(LMTestDatabase),
	for j=1:length(LMTestDatabase(i).annotation.object),
		idx = tags.get(  LMTestDatabase(i).annotation.object(j).name );
		W( i, idx )=1;
	end
end

[Y,I] = sort(-sum(W));
W = W(:,I(1:100));

% compute conditional probabilities that W(i)=1 | W(j)=1
% = N( W(i)=1 and W(j)=1 )/ N( W(j)=1 )
P = zeros( size(W, 2) );

N_W_j = sum( W );
for i=1:size(P, 1),
	P(i, :) = sum(repmat(W(:,i)==1, [1,size(W,2)]).*W)./N_W_j;
end

imagesc(P > repmat(N_W_j./size(W,1), [size(W,2),1]));

