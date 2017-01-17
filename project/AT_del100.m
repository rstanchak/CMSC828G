%%% Topic modelling parameters
T=50;
N=100;
BETA  = 0.01;
ALPHA = 50/T;
OUTPUT = 1;
SEED = 1;
maxdepth = 2;

clear train *
fname=[config.pfx_extra_train, '/ATresult_rel.mat'];
load(fname);
if ~exist('trainWP', 'var'),
    % augment with an additional 'author' for images without any tags
    AD = [AD; ones(1, length(LMTrainDatabase))];
    [trainWP, trainAT, trainZ, trainX] = GibbsSamplerAT( trainWS, trainDS , AD, T , N , ALPHA , BETA , SEED , OUTPUT );
    DP=sparse( DS, trainZ, ones(size(trainZ)), length(LMTrainDatabase), T );
end

fname=[config.pfx_extra_test, '/at-del100-data.mat'];
if exist(fname, 'file'), 
	load(fname)
else
	[WS, DS] = LMtopicinput(LMTestDatabase, LMTrainTree, maxdepth);
	[WS, DS] = LMdelaunaycb(WS, DS, LMTestDatabase, [config.pfx_extra_test, '/std-sift']);
	save(fname, 'WS', 'DS', 'trainWP', 'trainDP' );
end
DP = LDAtopicmix( WS, DS, trainWP, BETA );
DP=[trainDP', DP]';
save([pfx_extra_train, '/at-del100.mat'], 'maxdepth', 'T', 'N', 'ALPHA', 'BETA', 'DP');
