X = load('/tmp/working-roman/20news-bydate/matlab/train.data');
docidx = unique(X(:,1));
D = cell(length(docidx),1);
for i=1:docidx
	idx = find( X(:,1)==i );
	D{i} = sparse( X(idx,2), ones(length(idx),1), X(idx,3) );
end
lexsize=max(X(:,2));
clear X;
clear docidx;

fid = fopen('/tmp/working-roman/20news-bydate/matlab/vocabulary.txt'); i=1; while ~feof(fid), lexicon{i} = fscanf(fid, '%s', 1); i=i+1; end; fclose(fid);
