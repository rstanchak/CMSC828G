go_config

make_weka_fname=@(dir, method, class, ext) [dir, '/', method, '-', class, '.arff'];
% for each class:
for j=1:length(tagidx),
	for i=1:length(config.methods),
		t=tagidx(j);
		train_fname = make_weka_fname(config.pfx_extra_train, config.methods{i}, taginfo.tags{j});
		test_fname = make_weka_fname(config.pfx_extra_test, config.methods{i}, taginfo.tags{j});
		for k=1:length(config.weka.algorithms),
			out_fname = [config.pfx_extra_test, '/', config.methods{i}, '-', taginfo.tags{j}, '-', config.weka.algorithms{k}, '.csv'];
			if ~exist(out_fname, 'file')
				weka4(train_fname, test_fname, out_fname, config.weka.algorithms{k}, config.weka.alg_args{k});
			end
		end
	end
end
%     for each method:
%          run weka and get result
%     save weka result, classname, algorithms

