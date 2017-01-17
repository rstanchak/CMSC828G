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
neighborsK=2;
%[trainWS, trainDS] = LMtopicinput(LMTrainDatabase, LMTrainTree, maxdepth);
%[trainWS, trainDS] = LM_knn_cb(trainWS, trainDS, LMTrainDatabase, pfx_train_keys, neighborsK);
[testWS, testDS] = LMtopicinput(LMTestDatabase, LMTrainTree, maxdepth);
[testWS, testDS] = LM_knn_cb(testWS, testDS, LMTestDatabase, pfx_test_keys, neighborsK);
trainN=length(trainWS);
trainWS=[trainWS testWS];
clear testWS;
trainDS=[trainDS testDS+max(trainDS)];
clear testDS;
[WP,DP,Z] = GibbsSamplerLDA( trainWS, trainDS, T, N,ALPHA,BETA,SEED,OUTPUT );

is_trainW = sparse(1:trainN,ones(trainN,1),ones(trainN,1),size(trainWS,2), 1);
is_trainD = sparse(1:length(LMTrainDatabase), ones(length(LMTrainDatabase), 1), ones(length(LMTrainDatabase),1), length(LMTrainDatabase)+length(LMTestDatabase), 1);

save([pfx_extra_train, '/lda-knn100.mat'], 'maxdepth', 'T', 'N', 'ALPHA', 'BETA', 'is_trainW', 'is_trainD', 'trainDS', 'trainWS', 'WP', 'DP', 'Z');
