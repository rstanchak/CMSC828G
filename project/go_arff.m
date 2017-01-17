go_config

% load tag names and groundtruth
taginfo=load([config.pfx_extra_train, '/taginfo.mat']);

% get tag indices from names
tagmap=java.util.HashMap;
for i=1:length(taginfo.tags),
	tagmap.put(taginfo.tags{i}, i);
end

tagidx=zeros(length(config.test_tags),1);
for i=1:length(config.test_tags),
	tagidx(i)=tagmap.get( config.test_tags{i} );
end

% got tag indices

make_weka_fname=@(dir, method, class) [dir, '/', method, '-', class, '.arff'];
ntrain=2920;
ntest=1133;
% write arff files
for i=1:length(config.methods),
	data_fname = [config.pfx_extra_train, '/', config.methods{i}, '.mat'];
	data=load(data_fname, 'DP', 'trainN');
	if size(data.DP,1)~=(ntrain+ntest),
		error('DP does not contain the expected amount of data')
	end
	% normalize for word counts
	data.DP = data.DP ./ repmat( sum(data.DP,2), [1, size(data.DP,2)]);
	for j=1:length(tagidx),
		t=tagidx(j);
		train_fname = make_weka_fname(config.pfx_extra_train, config.methods{i}, taginfo.tags{j});
		test_fname = make_weka_fname(config.pfx_extra_test, config.methods{i}, taginfo.tags{j});
		if ~exist(train_fname, 'file'),
			savearff(train_fname, data.DP(1:ntrain,:), taginfo.hastag(t,:));	
		end
		if ~exist(test_fname, 'file'),
			savearff(test_fname, data.DP((1+ntrain):end,:), taginfo.hastag(t,:));
		end
		disp(['saved: ', train_fname, ', ', test_fname]);
	end
end
		
% for each method:
%     read in result
%     for each class:
%          export arff w/ class id

% for each class:
%     for each method:
%          run weka and get result
%     save weka result, classname, algorithms

