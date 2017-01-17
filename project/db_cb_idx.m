function database=db_cb_idx(database, tree, maxdepth)

tree_K = length(tree.sub);
if ~exist('maxdepth', 'var'),
	maxdepth = tree.depth
end

% convert vocabulary tree asgn variable to a codebook index
for k=1:length(database),
	asgn = database(k).asgn;
    cb_idx = zeros(1, size(asgn, 2));
	for kk=1:maxdepth
		cb_idx = cb_idx + double(asgn(kk,:)-1)*(tree_K^(maxdepth-kk));
	end
	database(k).cb_idx = cb_idx + 1; % matlab idx
end
