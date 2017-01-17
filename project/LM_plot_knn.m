function hlines=LM_knn_cb(WS, DS, db, idx, pfx_keys, K)

ncodewords = max( WS );
relcodebook = zeros(ncodewords,ncodewords);
k=1;
for i=1:ncodewords,
	for j=i:ncodewords,
		relcodebook(i,j)=k;
		relcodebook(j,i)=k;
		k=k+1;
	end
end

RWS=[];
RDS=[];
k1=1;

%disp(['Loading features for image ',i]);
% extract position of features -> x, y vectors
f = LMloadfeatures(db, idx, pfx_keys);

[I, nndist] = kNearestNeighbors( f(1:2,:)', K );
J = repmat((1:size(f,2))', [1, K]);

% for each point, mark neighbors within a sigma-neighborhood
% A=sparse(nn, I(:), ones(size(nn)), size(f,2),size(f,2));

%disp('Computing relational features');
% compute relational features
% for each edge, lookup codebook value i,j , add relational feature (i,j)
%[I,J] = find(A);

% only select J>I 
sel = find(J>I);
I=I(sel);
J=J(sel);

% relational codeword is 1D index into 2D array
cb_idx = WS( find(DS==idx) );
idx = sub2ind(size(relcodebook), cb_idx(I), cb_idx(J));

rcb_idx = relcodebook(idx);

hold on;
hlines=line([f(1,I); f(1, J)], [f(2,I); f(2,J)]);
set(hlines,'Color', [.3,.1,.9]);
%scatter(f(1,:),f(2,:),3*f(3,:), 'filled');%3*f(3,:),'filled';
hold off;


end%function
