function hlines=LMplotdelaunay(h, db, i, img_dir, pfx_keys)
figure(h);
clf

% extract position of features -> x, y vectors
f = LMloadfeatures(db, i, pfx_keys);

% read features
%img = LMimread(db, i, img_dir);
%sz = size(img);
%sz = sz * 512 / max(sz);
%img = imresize(img, sz(1:2), 'bilinear');

% compute delaunay triangulation of features
tri = delaunay(f(1,:), f(2,:));


%imshow(img);
hold on;
hlines=line([f(1,tri(:,1))', f(1, tri(:,2))' f(1, tri(:,3))' f(1, tri(:,1))']', ...
     [f(2,tri(:,1))', f(2, tri(:,2))' f(2, tri(:,3))' f(2, tri(:,1))']');
set(hlines,'Color', 'k');%[.3,.1,.9]);
%scatter(f(1,:),f(2,:),3*f(3,:),db(i).cb_idx,'filled');
hold off;

