load(config.fname_train_db);
load(config.fname_train_tree);

% for each feature x, word w, calculate p( w, x )
% p(w,x)=sum_c p(w|c)p(x|c)p(c)

% load tags
tags = LMtaglist(LMTrainDatabase);
tagmap = LMtagmap(tags);

% load document, words
d=[config.work_dir, '/labelme/wikipedia_cache'];
CS = load('-ascii', fullfile(d,'docs.txt'));
WS = load('-ascii', fullfile(d,'words.txt'));
dict = textread(fullfile(d,'dict.txt'), '%s');
urls = textread(fullfile(d,'doc_urls.txt'), '%s');

maxdepth=2;
pfx_train_images = [config.work_dir, '/labelme/train/Images'];
[XS, DS] = LMtopicinput(LMTrainDatabase, LMTrainTree, maxdepth);
TS = LM_feature_tag_all(tagmap, LMTrainDatabase, config.pfx_train_images, config.pfx_train_keys, config.bagoptions.data_min_sigma);

% P(w|c) = #(w,c)/#(c)
P_w_c = sparse(WS, CS, ones(size(WS)), max(WS), max(CS));
P_w_c = normalizedim(P_w_c, 1);

notnan_idx = find(~isnan(TS));

% P(x|c) = #(x,c)/#(c) --> need to associate each feature location with a tag
P_x_c = sparse(XS(notnan_idx), TS(notnan_idx), ones(size(notnan_idx)), max(XS), max(CS));
P_x_c = normalizedim(P_x_c, 1);

P_c = hist( TS, 1:max(CS) )/length(notnan_idx);


P_w_x = P_w_c*diag(P_c)*P_x_c';
clear P_x_c;
clear P_w_c;
clear SC
clear WS;
%clear TS;

% most likely words for an image
for i=1:100:max(DS),
	idx=find(DS==i);
	P_w = sum( -log(0.0001+P_w_x(:, XS(idx))), 2);
	[Y,I] = sort( P_w );
	dict( I(1:20) )
	clf;
	LMplot(LMTrainDatabase, i, pfx_train_images);
	legend hide;
	drawnow;
end

% P( word | feature )
for i=1:100:max(DS),
	idx = find(DS==i);
	f = LMloadfeatures( LMTrainDatabase, i, config.pfx_train_keys );
	f = f(:, find(f(3,:)>=config.bagoptions.data_min_sigma ));
	img = LMimread( LMTrainDatabase, i, config.pfx_train_images );
	sz = size(img);
	sz = sz * 512 / max(sz);
	img = imresize(img, sz(1:2), 'bilinear');

	P_w = sum( -log(0.0001+P_w_x(:, XS(idx))), 2);
	[Y,I] = sort( P_w );
	for j=1:length(I),
		image(img);
		hold on;
		P =  P_w_x(I(j), XS(idx));
		P = (P-min(P))/(max(P)-min(P))*255;
		scatter( f(1,:), f(2,:), 20, P );
		hold off;
		title(['P( ', dict{I(j)}, ' | feature)']);
		colorbar;
		drawnow;
		pause(5.0);
	end
end

% most likely words for unknown features
for i=1:20:max(DS),
	doc_idx = find(DS==i);
	%unk_idx = find(isnan(TS(doc_idx)));
	unk_idx = 1:length(doc_idx);

	f = LMloadfeatures( LMTrainDatabase, i, config.pfx_train_keys );
	f = f(:, find(f(3,:)>=config.bagoptions.data_min_sigma ));

	[Y,I] = max(P_w_x(:, XS(notnan_idx(doc_idx(unk_idx)))),[], 1);


    img = LMimread( LMTrainDatabase, i, config.pfx_train_images );
    sz = size(img);
    sz = sz * 512 / max(sz);
    img = imresize(img, sz(1:2), 'nearest');

	image(img);

	hold on;
	classes = unique(I);
	for j=1:length(classes),
		idx = find(I==classes(j));
		scatter( f(1,unk_idx(idx)), f(2,unk_idx(idx)), 20, config.plot.colors(j), 'filled' );
	end
	hold off;
	legend( dict{classes} );
	drawnow;
	pause(5.0);
end


% most likely words for unknown features
for i=1:20:max(DS),
    doc_idx = find(DS==i);

    f = LMloadfeatures( LMTrainDatabase, i, config.pfx_train_keys );
    f = f(:, find(f(3,:)>=config.bagoptions.data_min_sigma ));

    img = LMimread( LMTrainDatabase, i, config.pfx_train_images );
    sz = size(img);
    sz = sz * 512 / max(sz);
    img = imresize(img, sz(1:2), 'nearest');

    image(img);

    hold on;
    scatter( f(1,:), f(2,:), 20, XS(doc_idx), 'filled' );
    hold off;
	colormap jet;
    drawnow;
    pause(5.0);
end

