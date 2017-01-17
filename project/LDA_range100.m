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
radius=10;
[trainWS, trainDS] = LMtopicinput(LMTrainDatabase, LMTrainTree, maxdepth);
[trainWS, trainDS] = LMinrange(trainWS, trainDS, LMTrainDatabase, pfx_train_keys, radius);
if(length(trainWS)~=length(trainDS))
	error('WTF???')
end
[testWS, testDS] = LMtopicinput(LMTestDatabase, LMTrainTree, maxdepth);
[testWS, testDS] = LMinrange(testWS, testDS, LMTestDatabase, pfx_test_keys, radius);
trainN=length(trainWS);
trainWS=[trainWS testWS];
clear testWS;
trainDS=[trainDS testDS+max(trainDS)];
clear testDS;
[WP,DP,Z] = GibbsSamplerLDA( trainWS, trainDS, T, N,ALPHA,BETA,SEED,OUTPUT );

save([pfx_extra_train, '/lda-range100.mat'], 'maxdepth', 'T', 'N', 'ALPHA', 'BETA', 'trainN', 'trainDS', 'trainWS', 'WP', 'DP', 'Z');
