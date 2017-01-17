descmap=java.util.HashMap;
clear desclist;
clear dbdescs;
for i=1:length(LMTrainDatabase),
	desc = LMTrainDatabase(i).annotation.scenedescription;
	descs = regexp(desc, '([A-Za-z\d\.]+)', 'tokens');
	dbdescs{i} = [];
	for j=1:length(descs),
		f=char(descs{j});
		m = regexp(f, 'jpg');
		if length(m)==0,
		   	if ~descmap.containsKey( f ),
				descmap.put(f, descmap.size+1);
				desclist{ descmap.size } = f;
			end
			dbdescs{i} = [dbdescs{i} descmap.get(f)];
		end
	end

end
cls2=zeros(length(LMTrainDatabase),descmap.size);
for i=1:length(LMTrainDatabase),
	cls2(i, dbdescs{i})=1;
end

desclist2={'formentera', 'puigpunyent', 'palma', 'coruna', 'valladolid', 'barcelona'};

cls=zeros(length(LMTrainDatabase),1);
for i=1:length(desclist2),
	j=descmap.get(desclist2{i});
	cls( find(cls2(:,j)) )=i;
end

taglist=LMtaglist(LMTrainDatabase);
hastag=db_has_tag(LMTrainDatabase, taglist);
%
numtrain=30;
numclasses = max(cls); %descmap.size;

train_idx=[];
test_idx=[];

% select instances for training
for i=1:numclasses 
	idx = find( cls==i );

	% ignore descs without enough instances
	if(length(idx) < 2*numtrain ),
		continue;
	end
	
	% shuffle instances
	idx = idx(randperm(length(idx)));
	
	train_idx = [train_idx; idx(1:numtrain)];
	test_idx = [test_idx; idx(numtrain:end)];
end

train_fname = [config.pfx_extra_train, '/tag_desc.arff'];
test_fname = [config.pfx_extra_test, '/tag_desc.arff'];
%savearff_nominal(train_fname, hastag(:,train_idx)',cls(train_idx), taglist, desclist2);
idx = find( cls );
savearff_nominal(train_fname, hastag(:,idx)', cls(idx), taglist, desclist2);
%savearff_nominal(test_fname, hastag(:,test_idx)',cls(test_idx), taglist, desclist2);
break
wekaoptions=struct();
wekaoptions.predictions=1;
R=weka( train_fname, test_fname, wekaoptions );
if(length(R.predicted)~=length(test_idx)),
	error('R.predicted is too short')
end

pconfusion = R.confusion ./ repmat( sum(R.confusion, 2), [1, size(R.confusion, 2)]);
pconfusion(find(isnan(pconfusion)))=0;
figure(1);
imagesc(pconfusion);

I=[1,2]; J=[2,1];
for i=1:length(I)
	idx = find(R.predicted==J(i) & R.actual==I(i));
	idx=idx(1:min(25,length(idx)));
	figure;
	imagesc([hastag(:,test_idx(idx)) R.predicted(idx) R.actual(idx)])
	%LMdbshowscenes(LMTrainDatabase(test_idx(idx)), [config.work_dir, '/labelme/train/Images'], [5,5], 0);
	%print(gcf, '-djpeg', [config.work_dir, '/labelme/actual_', desclist2{I(i)}, '_predicted_as_', desclist2{J(i)}, '.jpg']);
	close;
	idx = find(R.actual==J(i));
	idx=idx(1:min(25,length(idx)));
	%LMdbshowscenes(LMTrainDatabase(test_idx(idx)), [config.work_dir, '/labelme/train/Images'], [5, 5], 0);
	%print(gcf, '-djpeg', [config.work_dir, '/labelme/actual_', desclist2{J(i)} '.jpg']);
	%close;
	idx = find(R.actual==I(i));
	idx=idx(1:min(25,length(idx)));
	%LMdbshowscenes(LMTrainDatabase(test_idx(idx)), [config.work_dir, '/labelme/train/Images'], [5, 5], 0);
	%print(gcf, '-djpeg', [config.work_dir, '/labelme/actual_', desclist2{I(i)} '.jpg']);
	%close;
end

