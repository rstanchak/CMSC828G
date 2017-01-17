go_config;

d=[config.work_dir, '/labelme/wikipedia_cache'];
DS = load('-ascii', fullfile(d,'docs.txt'));
WS = load('-ascii', fullfile(d,'words.txt'));
dict = textread(fullfile(d,'dict.txt'), '%s');
urls = textread(fullfile(d,'doc_urls.txt'), '%s');

T = 50;
N = 100;
ALPHA = 1;
BETA = .01;
SEED =1;
OUTPUT=1;

[WP, DP, Z] = GibbsSamplerLDA( WS, DS, T, N,ALPHA,BETA,SEED,OUTPUT );

for i=1:50,
	X = WP(:,i);
	[Y,I] = sort(X);
	fprintf('Topic %d ----\n', i);
	for j=1:5,
		fprintf('%s ', dict{ I(end-j) });
	end
	fprintf('\n');
end

for i=1:length(urls),
	fprintf('URL: %s\n', urls{i});
	Z = randsample( T, 10, true, DP(i,:)+.01); 
	for j=1:length(Z),
		Y = randsample( length(dict), 1, true, WP(:, Z(j))+.01); 
		fprintf('%s ', dict{ Y });
	end
	fprintf('\n');
end
