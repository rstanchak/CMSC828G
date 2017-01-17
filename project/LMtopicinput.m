function [WS, DS]=LMtopicinput(database, tree, maxdepth)

tree_K = length(tree.sub);
if ~exist('maxdepth', 'var'),
	maxdepth = tree.depth
end

WS = zeros( 1,size([database.asgn],2));
DS = zeros( size(WS) );

% convert vocabulary tree asgn variable to a codebook index
i=1;
for k=1:length(database),
	asgn = database(k).asgn;
    cb_idx = zeros(1, size(asgn, 2));
	for kk=1:maxdepth
		cb_idx = cb_idx + double(asgn(kk,:)-1)*(tree_K^(maxdepth-kk));
	end
	i2=i+length(cb_idx)-1;
	WS(i:i2) = cb_idx + 1; % matlab index
	DS(i:i2) = k;
	i = i2+1;
end
