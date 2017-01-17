%%% Topic modelling parameters
T=50;
N=100;
BETA  = 0.01;
ALPHA = 50/T;
OUTPUT = 1;
SEED = 1;
maxdepth = 2;

[trainWS, trainDS] = LMtopicinput(LMTrainDatabase, LMTrainTree, maxdepth);
[testWS, testDS] = LMtopicinput(LMTestDatabase, LMTrainTree, maxdepth);
testDS = testDS + max(trainDS);
[WP,DP,Z] = GibbsSamplerLDA( [trainWS, testWS], [trainDS, testDS], T, N,ALPHA,BETA,SEED,OUTPUT );

save([pfx_extra_train, '/lda-cb100.mat'], 'maxdepth', 'T', 'N', 'ALPHA', 'BETA', 'trainDS', 'trainWS', 'testDS', 'testWS', 'WP', 'DP', 'Z');
