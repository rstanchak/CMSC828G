go_config;

LMTrainTreeFname = [config.pfx_extra_train, '/std-tree.mat'];

if ~exist('LMTrainDatabase', 'var'),
	LMTrainDatabase = LMdatabase(config.pfx_extra_train);
end
if ~exist('LMTrainTree', 'var'),
	if exist(LMTrainTreeFname, 'file'),
		load(LMTrainTreeFname);
	else
		LMTrainTree = LMktree(LMTrainDatabase, '/tmp/working-roman/extra/labelme/train/std-sift');
		save(LMTrainTreeFname, LMTrainTree);
	end
end

if ~exist('LMTestDatabase', 'var'),
	LMTestDatabase = LMdatabase(config.pfx_extra_train);
end

if ~isfield(LMTrainDatabase, 'asgn'),
	LMTrainDatabase = LMpushtree(LMTrainDatabase, LMTrainTree, '/tmp/working-roman/extra/labelme/train/std-sift', config.bagoptions);
end
%if ~isfield(LMTrainDatabase, 'cb_idx'),
%	LMTrainDatabase=db_cb_idx(LMTrainDatabase, LMTrainTree,2)
%end
%if ~isfield(LMTrainDatabase, 'rcb_idx'),
%	LMTrainDatabase=LMdelaunaycb(LMTrainDatabase, [pfx_extra_train, '/std-sift'])
%end
if ~isfield(LMTestDatabase, 'asgn'),
	LMTestDatabase = LMpushtree(LMTestDatabase, LMTrainTree, '/tmp/working-roman/extra/labelme/test2008/std-sift', config.bagoptions);
end
%if ~isfield(LMTestDatabase, 'cb_idx'),
%	LMTestDatabase=db_cb_idx(LMTestDatabase, LMTrainTree,2)
%end
%if ~isfield(LMTestDatabase, 'rcb_idx'),
%	LMTestDatabase=LMdelaunaycb(LMTestDatabase, [pfx_extra_test, '/std-sift'])
%end

%if ~isfield(LMTrainDatabase, 'has_tag')
	% add tag-feature vector to database
%	tags = LMtaglist(LMTrainDatabase);
%	LMTrainDatabase = db_has_tag( LMTrainDatabase, tags );
%	LMTestDatabase = db_has_tag( LMTestDatabase, tags );
%end

