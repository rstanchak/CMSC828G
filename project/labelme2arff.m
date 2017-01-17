% build index for bag database -> labelme database
db_map = java.util.HashMap
for i=1:length(database)
	db_map.put( database(i).name, i );
end

db_index = zeros(length(LMTrainDatabase),1);

for i=1:length(LMTrainDatabase)
	[PATHSTR,NAME,EXT,VERSN] = fileparts( LMTrainDatabase(i).annotation.filename );
	siftname=fullfile(pfx_sift, LMTrainDatabase(i).annotation.folder, [NAME, '.key']);
	db_index(i)=db_map.get(siftname);
end

savearff('/tmp/working-roman/extra/labelme-train-lda.arff', full(DP(db_index,:)), W(:, 1));
