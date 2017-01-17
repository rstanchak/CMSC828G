foldermap=java.util.HashMap;
clear folderlist;
cls=zeros(length(LMTrainDatabase),1);
for i=1:length(LMTrainDatabase),
	f = LMTrainDatabase(i).annotation.folder;
	if ~foldermap.containsKey( f ),
		foldermap.put(f, foldermap.size+1);
		folderlist{ foldermap.size } = f;
	end
	cls(i) = foldermap.get(f);
end
taglist=LMtaglist(LMTrainDatabase);
hastag=db_has_tag(LMTrainDatabase, taglist);
%
numtrain=10;
numclasses = foldermap.size;

train_idx=[];
test_idx=[];

% select instances for training
for i=1:numclasses 
	idx = find( cls==i );

	% ignore folders without enough instances
	if(length(idx) < 2*numtrain ),
		continue;
	end
	
	% shuffle instances
	idx = idx(randperm(length(idx)));
	
	train_idx = [train_idx; idx(1:numtrain)];
	test_idx = [test_idx; idx(numtrain:end)];
end

train_fname = [config.pfx_extra_train, '/tag_folder.arff'];
test_fname = [config.pfx_extra_test, '/tag_folder.arff'];
savearff_nominal(train_fname, hastag', cls, taglist, folderlist);
break
savearff(train_fname, hastag(:,train_idx)',cls(train_idx));
savearff(test_fname, hastag(:,test_idx)',cls(test_idx));
wekaoptions=struct();
wekaoptions.predictions=1;
R=weka( train_fname, test_fname, wekaoptions );
pconfusion = R.confusion ./ repmat( sum(R.confusion, 2), [1, size(R.confusion, 2)]);
pconfusion(find(isnan(pconfusion)))=0;
figure(1);
imagesc(pconfusion);

% pick most confused classes
[Y,I] = sort( pconfusion(:) ); % 'descend' sort on sparse matrices is broken
[I,J] = ind2sub( size(pconfusion), I( end:-1:1 ));

% ignore diagonal ... i.e. correct classifications
idx = find(I~=J);
I=I(idx); J=J(idx);
for i=1:10,
	idx = find(R.predicted==J(i) & R.actual==I(i));
	idx=idx(1:min(25,length(idx)));
	LMdbshowscenes(LMTrainDatabase(test_idx(idx)), [config.work_dir, '/labelme/train/Images'], [5,5], 0);
	print(gcf, '-djpeg', [config.work_dir, '/labelme/actual_', folderlist{I(i)}, '_predicted_as_', folderlist{J(i)}, '.jpg']);
	close;
	idx = find(R.actual==J(i));
	idx=idx(1:min(25,length(idx)));
	LMdbshowscenes(LMTrainDatabase(test_idx(idx)), [config.work_dir, '/labelme/train/Images'], [5, 5], 0);
	print(gcf, '-djpeg', [config.work_dir, '/labelme/actual_', folderlist{J(i)} '.jpg']);
	close;
	idx = find(R.actual==I(i));
	idx=idx(1:min(25,length(idx)));
	LMdbshowscenes(LMTrainDatabase(test_idx(idx)), [config.work_dir, '/labelme/train/Images'], [5, 5], 0);
	print(gcf, '-djpeg', [config.work_dir, '/labelme/actual_', folderlist{I(i)} '.jpg']);
	close;
end

