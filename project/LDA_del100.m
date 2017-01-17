go_config;

result_fname=[pfx_extra_train, '/lda-del100.mat'];
if ~exist(result_fname, 'file'),
	%%% Topic modelling parameters
	T=50;
	N=100;
	BETA  = 0.01;
	ALPHA = 50/T;
	OUTPUT = 1;
	SEED = 1;
	maxdepth = 2;

	pfx_train_keys = [pfx_extra_train, '/std-sift'];
	pfx_test_keys = [pfx_extra_test, '/std-sift'];

	[trainWS, trainDS] = LMtopicinput(LMTrainDatabase, LMTrainTree, maxdepth);
	[trainWS, trainDS] = LMdelaunaycb(trainWS, trainDS, LMTrainDatabase, pfx_train_keys);
	[testWS, testDS] = LMtopicinput(LMTestDatabase, LMTrainTree, maxdepth);
	[testWS, testDS] = LMdelaunaycb(testWS, testDS, LMTestDatabase, pfx_test_keys);
	trainN=length(trainWS);
	trainWS=[trainWS testWS];
	clear testWS;
	trainDS=[trainDS testDS+max(trainDS)];
	clear testDS;
	[WP,DP,Z] = GibbsSamplerLDA( trainWS, trainDS, T, N,ALPHA,BETA,SEED,OUTPUT );

	save([pfx_extra_train, '/lda-del100.mat'], 'maxdepth', 'T', 'N', 'ALPHA', 'BETA', 'trainDS', 'trainWS', 'trainN',  'WP', 'DP', 'Z');
end
