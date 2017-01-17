function [RWS, RDS]=LMknncb(WS, DS, db, pfx_keys)

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

k1=1;
for i=1:length(db),
	%disp(['Loading features for image ',i]);
	% extract position of features -> x, y vectors
	f = LMloadfeatures(db, i, pfx_keys);
	
	% compute delaunay triangulation of features
	%disp('Computing delaunay triangulation');
	kd = kdtree( f(1:2,:)');
	
	%disp('Computing relational features');
	% compute relational features
	% for each edge, lookup codebook value i,j , add relational feature (i,j)
	I=[tri(:,1);tri(:,1);tri(:,2);tri(:,2);tri(:,3);tri(:,3)];
	J=[tri(:,2);tri(:,3);tri(:,1);tri(:,3);tri(:,1);tri(:,2)];
	S=ones(size(I));
	A=sparse(I,J,S,size(f,2),size(f,2));

	[I,J] = find(A);

	% only select upper triangular portion (lower is redundant)
	sel = find(J > I);
	I=I(sel);
	J=J(sel);

	% relational codeword is 1D index into 2D array
	cb_idx = WS( find(DS==i) );
	idx = sub2ind(size(relcodebook), cb_idx(I), cb_idx(J));
	
	rcb_idx = relcodebook(idx);
	k2=k1+length(rcb_idx)-1;
	RWS(k1:k2) = rcb_idx;
	RDS(k1:k2) = i;
	k1=k2+1;
end%function
