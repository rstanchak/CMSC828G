config=struct();
config.work_dir = '/tmp/working-roman';
config.name = 'labelme';
config.pfx_train_images = [config.work_dir, '/labelme/train/Images'];
config.pfx_test_images = [config.work_dir, '/labelme/test2008/Images'];
config.pfx_extra_train = [config.work_dir, '/extra/', config.name, '/train'];
config.pfx_extra_test = [config.work_dir, '/extra/', config.name, '/test2008'];
config.pfx_train_keys = [config.pfx_extra_train, '/std-sift'];
config.pfx_test_keys = [config.pfx_extra_test, '/std-sift'];
config.fname_train_db = [config.pfx_extra_train, '/std-database.mat'];
config.fname_train_tree = [config.pfx_extra_train, '/std-tree.mat'];
config.fname_test_db = [config.pfx_extra_test, '/std-database.mat'];

config.test_tags = {'tree', 'building', 'person', 'sidewalk', 'car', 'road', 'sky', ...
			 	'motorbike', 'wall'};
config.methods = { ... %'at-cb100', 'at-cb10000', 'at-del100', 
'lda-range100', 'lda-knn100', 'lda-del100', 'lda-cb100', 'lda-cb10000' }; 
config.weka=struct();
config.weka.algorithms= { 'weka.classifiers.bayes.BayesNet',
               'weka.classifiers.bayes.NaiveBayes' ,
               'weka.classifiers.lazy.IBk',
               'weka.classifiers.trees.J48'
		};
config.weka.algorithm_names = { 'BayesNet', 'Naive Bayes', 'K-Nearest Neighbor', 'Decision Tree' };
config.weka.alg_args = { '-D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 1 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5' , ...
             '', ...
             '-K 2 -W 0', ...
             '-C 0.2 -M 3' };

config.plot.symbols = '*+xo.sd^v><ph';
config.plot.linesym = {'-','--', ':', '-.','-','--', ':', '-.'};
config.plot.colors = 'rgbcmkyrgbcmky';
config.bagoptions.data_min_sigma = 1.5;
