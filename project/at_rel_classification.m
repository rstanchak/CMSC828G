algorithms = { 'weka.classifiers.bayes.BayesNet',
               'weka.classifiers.bayes.NaiveBayes' ,
               'weka.classifiers.lazy.IBk',
               'weka.classifiers.trees.J48'};
alg_args = { '-D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 1 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5' , ...
             '', ...
             '-K 2 -W 0', ...
             '-C 0.2 -M 3' };

symbols = '*+xo.sd^v><ph';
colors = 'rgbcmky';

WORK_DIR='/tmp/working-roman';
%ctm_train_data_fname='/tmp/working-roman/src/ctm-dist/labelme-train.ctm';
%ctm_test_data_fname='/tmp/working-roman/src/ctm-dist/labelme-test.ctm';
%ctm_train_result_fname='/tmp/working-roman/src/ctm-dist/labelme-train-word-assgn.dat';
%ctm_test_result_fname='/tmp/working-roman/src/ctm-dist/labelme-test-word-assgn.dat';

trainfname='/tmp/working-roman/extra/labelme/at-train.arff';
testfname='/tmp/working-roman/extra/labelme/at-test.arff';
pfx_extra_train = [WORK_DIR,'/extra/labelme/train'];
pfx_extra_test = [WORK_DIR,'/extra/labelme/test2008'];
LMTrainTreeFname = [pfx_extra_train, '/std-tree.mat'];

if ~exist('LMTrainDatabase', 'var'),
	LMTrainDatabase = LMdatabase('/tmp/working-roman/labelme/train');
end
if ~exist('LMTrainTree', 'var'),
	if exist(LMTrainTreeFname, 'file'),
		load(LMTrainTreeFname);
	else
		LMTrainTree = LMktree(LMTrainDatabase, '/tmp/working-roman/extra/labelme/train/std-sift');
		save LMTrainTreeFname, LMTrainTree;
	end
end

if ~exist('LMTestDatabase', 'var'),
	LMTestDatabase = LMdatabase('/tmp/working-roman/labelme/test2008');
end

if ~isfield(LMTrainDatabase, 'asgn'),
	LMTrainDatabase = LMpushtree(LMTrainDatabase, LMTrainTree, '/tmp/working-roman/extra/labelme/train/std-sift');
end
if ~isfield(LMTrainDatabase, 'cb_idx'),
	LMTrainDatabase=db_cb_idx(LMTrainDatabase, LMTrainTree,2)
end
if ~isfield(LMTrainDatabase, 'rcb_idx'),
	LMTrainDatabase=LMdelaunaycb(LMTrainDatabase, [pfx_extra_train, '/std-sift'])
end
if ~isfield(LMTestDatabase, 'asgn'),
	LMTestDatabase = LMpushtree(LMTestDatabase, LMTrainTree, '/tmp/working-roman/extra/labelme/test2008/std-sift');
end
if ~isfield(LMTestDatabase, 'cb_idx'),
	LMTestDatabase=db_cb_idx(LMTestDatabase, LMTrainTree,2)
end
if ~isfield(LMTestDatabase, 'rcb_idx'),
	LMTestDatabase=LMdelaunaycb(LMTestDatabase, [pfx_extra_test, '/std-sift'])
end

if ~isfield(LMTrainDatabase, 'has_tag')
	% add tag-feature vector to database
	tags = LMtaglist(LMTrainDatabase);
	LMTrainDatabase.has_tag = db_has_tag( LMTrainDatabase, tags );
	LMTestDatabase.has_tag = db_has_tag( LMTestDatabase, tags );
end

%%% Topic modelling parameters
T=50;
N=100;
BETA  = 0.01;
ALPHA = 50/T;
OUTPUT = 1;
SEED = 1;

if ~exist('trainAT', 'var'),
	error('this shouldnt happen');
	[WS, DS] = LMtopicinput_rel(LMTrainDatabase);
	AD = [LMTrainDatabase.has_tag];
	% augment with an additional 'author' for images without any tags
	AD = [AD; ones(1, length(LMTrainDatabase))];
	[trainWP, trainAT, trainZ, trainX] = GibbsSamplerAT( WS, DS , AD, T , N , ALPHA , BETA , SEED , OUTPUT );
	DZ=sparse( DS, trainZ, ones(size(trainZ)), length(LMTrainDatabase), T );
end

% test
if ~exist('testDP', 'var'),
	testADtruth = [LMTestDatabase.has_tag];
	testADprob = zeros( size(testADtruth) );
	for i=1:length(LMTestDatabase),
		W=LMTestDatabase(i).rcb_idx;
		testADprob(:,i) = ATprobauth(W, trainWP, trainAT(1:(end-1), :), ALPHA, BETA)'; 
		if mod(i,10)==0,
			fprintf('Done %d of %d\r', i, length(LMTestDatabase));
		end
	end
end


%if ~exist('R', 'var')
%for c=1:length(tags),
%	trainC=[LMTrainDatabase.has_tag]; trainC = trainC(c,:);
	%testC=[LMTestDatabase.has_tag]; testC = testC(c,:);
%	savearff(trainfname, DZ, trainC);
	%savearff(testfname, full(testDP), full(testC));
	%for i=1:length(algorithms),
%	for i=2:2,
		%try,
%			R{c}=weka_crossvalidation(trainfname, algorithms{i}, alg_args{i});
		%catch,
		%	R{c}=R{c-1};
		%end
%	end
%end
%end

% correct classifications (both +/-)
%ncorrect=zeros(length(tags),1);
%for i=1:length(R), 
%	ncorrect(i)=R{i}.TP/length(LMTrainDatabase); 
%end

% random correct classification 
%npos=sum([LMTrainDatabase.has_tag]')/length(LMTrainDatabase);
%nrcorrect=max(npos, 1.0-npos);

%figure(1)
%plot( 1:length(R), sort(ncorrect ./ nrcorrect'), 'b-', 1:length(R), ones(1,length(R)), 'r-');
%figure(2)
%scatter( npos, ncorrect );
