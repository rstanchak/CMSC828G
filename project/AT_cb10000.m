%%% Topic modelling parameters
T=50;
N=100;
BETA  = 0.01;
ALPHA = 50/T;
OUTPUT = 1;
SEED = 1;
maxdepth = 4;

clear trainWP;
fname=[pfx_extra_train, '/ATresult_10000.mat'];
load(fname);
if ~exist('trainWP', 'var'),
    % augment with an additional 'author' for images without any tags
    AD = [AD; ones(1, length(LMTrainDatabase))];
    [trainWP, trainAT, trainZ, trainX] = GibbsSamplerAT( trainWS, trainDS , AD, T , N , ALPHA , BETA , SEED , OUTPUT );
    DZ=sparse( DS, trainZ, ones(size(trainZ)), length(LMTrainDatabase), T );
end

[WS, DS] = LMtopicinput(LMTestDatabase, LMTrainTree, maxdepth);
DP = LDAtopicmix( WS, DS, trainWP, BETA );
trainN = length(trainZ);
DP=[DZ', DP]';
save([pfx_extra_train, '/at-cb10000.mat'], 'maxdepth', 'T', 'N', 'ALPHA', 'BETA', 'trainN', 'DP');
