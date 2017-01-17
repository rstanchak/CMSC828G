function hlines=LMplotinrange(h, db, i, img_dir, pfx_keys, sigma)
figure(h);
clf

% extract position of features -> x, y vectors
f = LMloadfeatures(db, i, pfx_keys);

% read features
%img = LMimread(db, i, img_dir);
%sz = size(img);
%sz = sz * 512 / max(sz);
%img = imresize(img, sz(1:2), 'bilinear');

% throw points in a kdtree for quick lookup 
kd = kdtree( f(1:2,:)' );

% for each point, mark neighbors within a sigma-neighborhood
A=sparse(size(f,2),size(f,2));
for j=1:size(f,2),
	rng = [ f(1:2, j)-sigma, f(1:2, j)+sigma];
	idx = kdtree_range(kd, rng);
	A(j,idx)=1;
end
[I,J] = find(A);
sel = find(I~=J);
I=I(sel); J=J(sel);

%imshow(img);
hold on;
%hlines=line([f(1,I); f(1, J)], [f(2,I); f(2,J)]);
%set(hlines,'Color', [.3,.1,.9]);
scatter(f(1,:),f(2,:),3*f(3,:),'filled');
hold off;

