function [RWS, RDS]=LM_knn_cb(WS, DS, db, pfx_keys, K)

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
for i=1:length(db),
	%disp(['Loading features for image ',i]);
	% extract position of features -> x, y vectors
	f = LMloadfeatures(db, i, pfx_keys);
	
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
	cb_idx = WS( find(DS==i) );
	idx = sub2ind(size(relcodebook), cb_idx(I), cb_idx(J));
	
	rcb_idx = relcodebook(idx);
	RWS = [ RWS, rcb_idx ];
	RDS = [ RDS, k1*ones(size(rcb_idx)) ];
	k1=k1+1;
end%function
