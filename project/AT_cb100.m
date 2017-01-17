%%% Topic modelling parameters
T=50;
N=100;
BETA  = 0.01;
ALPHA = 50/T;
OUTPUT = 1;
SEED = 1;
maxdepth = 2;

fname=[pfx_extra_train, '/ATresult_100.mat'];
load(fname);
if ~exist('trainZ', 'var'),
    % augment with an additional 'author' for images without any tags
    AD = [AD; ones(1, length(LMTrainDatabase))];
    [trainWP, trainAT, trainZ, trainX] = GibbsSamplerAT( trainWS, trainDS , AD, T , N , ALPHA , BETA , SEED , OUTPUT );
    DZ=sparse( DS, trainZ, ones(size(trainZ)), length(LMTrainDatabase), T );
end

[WS, DS] = LMtopicinput(LMTestDatabase, LMTrainTree, maxdepth);
testDP = LDAtopicmix( WS, DS, trainWP, BETA );
trainN = length(trainZ);
DP=[DZ', testDP]';
save([pfx_extra_train, '/at-cb100.mat'], 'maxdepth', 'T', 'N', 'ALPHA', 'BETA', 'trainN', 'DP');
