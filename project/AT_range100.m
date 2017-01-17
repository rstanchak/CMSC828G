%%% Topic modelling parameters
T=50;
N=100;
BETA  = 0.01;
ALPHA = 50/T;
OUTPUT = 1;
SEED = 1;
maxdepth = 2;

clear train* WS DP DZ DS;

% load relational features from previous run (since they are slow to compute)
data = load([pfx_extra_train, '/lda-range100.mat'], 'trainWS', 'trainDS', 'maxdepth' );
train_idx = find(data.trainDS <= length(LMTrainDatabase));
data.trainWS=data.trainWS(train_idx);
data.trainDS=data.trainDS(train_idx);


if data.maxdepth~=maxdepth,
	error('Expected same maxdepth')
end

% author/tag assignments for training documents
AD = [LMTrainDatabase.has_tag];

% assume all images have a single shared tag (fixes images without tags)
AD = [AD; ones(1, length(LMTrainDatabase))];

[trainWP, trainAT, trainZ, trainX] = GibbsSamplerAT( data.trainWS, data.trainDS, AD, T , N , ALPHA , BETA , SEED , OUTPUT );

% save gibbs sample 
save([pfx_extra_train, 'at-range100-gibbs.mat'], 'trainZ', 'trainX', 'maxdepth', 'T', 'N', 'ALPHA', 'BETA');

% reload data b/c of stupid memory
data = load([pfx_extra_train, '/lda-range100.mat'], 'trainWS', 'trainDS', 'maxdepth' );
test_idx = find(data.trainDS > length(LMTrainDatabase));
test_offset = data.trainDS( test_idx(1) )-1;  % maps first test index to 1
data.trainWS=data.trainWS(test_idx);
data.trainDS=data.trainDS(test_idx)-test_offset;

% given word counts, compute probability each topic generated them
testDP = LDAtopicmix( data.trainWS, data.trainDS, trainWP, BETA );
DP=sparse( data.trainDS(train_idx), trainZ, ones(size(trainZ)), length(LMTrainDatabase), T );
DP=[DP', testDP]';
save([pfx_extra_train, '/at-range100.mat'], 'maxdepth', 'T', 'N', 'ALPHA', 'BETA', 'DP');
