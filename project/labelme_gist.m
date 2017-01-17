LM_TEST_ANNOTATIONS='/tmp/working-roman/labelme/test2008/Annotations';
LM_TEST_IMAGES='/tmp/working-roman/labelme/test2008/Images';

if ~exist('LMTestDatabase', 'var'),
	LMTestDatabase = LMdatabase( LM_TEST_ANNOTATIONS );
end

% Parameters:
Nblocks = 4;
imageSize = 128;
orientationsPerScale = [8 8 4];
numberBlocks = 4;

% Precompute filter transfert functions (only need to do this one, unless image size is changes):
createGabor(orientationsPerScale, imageSize); % this shows the filters
G = createGabor(orientationsPerScale, imageSize);

clear gist;
for i=1:4,%length(LMTestDatabase),
	img = LMimread(LMTestDatabase, i, LM_TEST_IMAGES);
	img = prefilt(double(img), imageSize, 4);
	gist{i} = gistGabor(img, numberBlocks, G);
end
save '/tmp/working-roman/labelme/test_gist.mat' gist;
