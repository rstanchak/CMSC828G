function [RWS, RDS]=LMinrange(WS, DS, db, pfx_keys, sigma)

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
	
	% throw points in a kdtree for quick lookup 
	kd = kdtree( f(1:2,:)' );
	
	% for each point, mark neighbors within a sigma-neighborhood
	A=sparse(size(f,2),size(f,2));
	for j=1:size(f,2),
		rng = [ f(1:2, j)-sigma, f(1:2, j)+sigma];
		idx = kdtree_range(kd, rng);
		A(j,idx)=1;
		A(idx,j)=1;
	end

	%disp('Computing relational features');
	% compute relational features
	% for each edge, lookup codebook value i,j , add relational feature (i,j)
	[I,J] = find(A);

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
