function LMsavectm(db, filename),
% convert the vedaldi bag database to a correlated topic model input data file

f=fopen(filename, 'w');
for i=1:length(db),
	words = java.util.HashMap;
	for j=1:length(db(i).cb_idx),
		count = words.get( db(i).cb_idx(j) );
		if length(count)==0,
			count=1;
		end
		words.put( db(i).cb_idx(j), count+1 );
	end
	fprintf(f, '%d', words.size);
	iter = words.keySet.iterator;
	while iter.hasNext,
		key = iter.next;
		fprintf(f, ' %d:%d', key, words.get(key));
	end
	fprintf(f, '\n');
end
fclose(f);
