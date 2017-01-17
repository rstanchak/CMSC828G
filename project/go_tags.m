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

ntrain=2920;
ntest=1133;

