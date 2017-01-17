function h=LM_plot_inrange(db, idx, tree, maxdepth, pfx_keys, sigma)

[WS, DS] = LMtopicinput(db(idx), tree, maxdepth);

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

%disp(['Loading features for image ',i]);
% extract position of features -> x, y vectors
f = LMloadfeatures(db, idx, pfx_keys);

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
idx = sub2ind(size(relcodebook), WS(I), WS(J));

rcb_idx = relcodebook(idx);

hold on;
hlines=line([f(1,I); f(1, J)], [f(2,I); f(2,J)]);
set(hlines,'Color', [.3,.1,.9]);
scatter(f(1,:),f(2,:),1, 'filled');%3*f(3,:),'filled';
hold off;
)
