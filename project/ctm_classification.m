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

ctm_train_data_fname='/tmp/working-roman/src/ctm-dist/labelme-train.ctm';
ctm_test_data_fname='/tmp/working-roman/src/ctm-dist/labelme-test.ctm';
ctm_train_result_fname='/tmp/working-roman/src/ctm-dist/labelme-train-word-assgn.dat';
ctm_test_result_fname='/tmp/working-roman/src/ctm-dist/labelme-test-word-assgn.dat';

trainfname='/tmp/working-roman/src/ctm-dist/labelme-train.arff';
testfname='/tmp/working-roman/src/ctm-dist/labelme-test.arff';
if ~exist('LMTrainDatabase', 'var'),
	LMTrainDatabase = LMdatabase('/tmp/working-roman/labelme/train');
end
if ~exist('LMTrainTree', 'var'),
	LMTrainTree = LMktree(LMTrainDatabase, '/tmp/working-roman/extra/labelme/train/std-sift');
end

if ~exist('LMTestDatabase', 'var'),
	LMTestDatabase = LMdatabase('/tmp/working-roman/labelme/test2008');
end

if ~exist(ctm_train_data_fname, 'file'),
	LMTrainDatabase = LMpushtree(LMTrainDatabase, LMTrainTree, '/tmp/working-roman/extra/labelme/train/std-sift');
	LMTrainDatabase=db_cb_idx(LMTrainDatabase, LMTrainTree)
	LMsavectm(LMTrainDatabase, ctm_train_data_fname);
end
if ~exist(ctm_test_data_fname, 'file')
	LMTestDatabase = LMpushtree(LMTestDatabase, LMTrainTree, '/tmp/working-roman/extra/labelme/test2008/std-sift');
	LMTestDatabase=db_cb_idx(LMTestDatabase, LMTrainTree)
	LMsavectm(LMTestDatabase, ctm_test_data_fname);
end

if ~exist('/tmp/working-roman/src/ctm-dist/labelme-model', 'dir'),
	error(['run ./ctm est ', ctm_train_data_fname, '50 rand ./labelme-model settings.txt']);
end
if ~exist(ctm_train_result_fname, 'file'),
	error('run ./ctm inf /tmp/working-roman/src/ctm-dist/labelme-train.ctm');
end
if ~exist(ctm_test_result_fname, 'file'),
	error('run ./ctm inf /tmp/working-roman/src/ctm-dist/labelme-test.ctm');
end

% train 
if ~exist('trainDP', 'var'),
	[trainWP, trainDP, trainZ] = read_ctm(ctm_train_result_fname);
end

% test
if ~exist('testDP', 'var'),
	[testWP, testDP, testZ] = read_ctm('/tmp/working-roman/src/ctm-dist/labelme-test-word-assgn.dat');
end

tags = LMtaglist(LMTrainDatabase);
LMTrainDatabase.has_tag = db_has_tag( LMTrainDatabase, tags );
LMTestDatabase.has_tag = db_has_tag( LMTestDatabase, tags );

clear R
for c=1:length(tags),
	trainC=[LMTrainDatabase.has_tag]; trainC = trainC(c,:);
	testC=[LMTestDatabase.has_tag]; testC = testC(c,:);
	savearff(trainfname, full(trainDP), full(trainC));
	savearff(testfname, full(testDP), full(testC));
	%for i=1:length(algorithms),
	for i=2:2,
		try,
			R{c}=weka3(trainfname, testfname, algorithms{i}, alg_args{i});
		catch,
			R{c}=R{c-1};
		end
	end
end
