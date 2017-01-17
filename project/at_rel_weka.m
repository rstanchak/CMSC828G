function [testfname, trainfname] = ATsaveweka(exptype, traindb, testdb, cat_id, tree, maxdepth, beta)
fname = sprintf('/tmp/working-roman/extra/labelme/train/ATresult_%s.mat', exptype);
trainfname = sprintf('/tmp/working-roman/extra/labelme/train/AT_%s.arff', exptype)
testfname = sprintf('/tmp/working-roman/extra/labelme/test2008/AT_%s.arff', exptype)

result = load(fname, 'trainZ', 'trainWP', 'DZ');
[WS, DS] = LMtopicinput(testdb, tree, maxdepth);                             
[WS, DS] = LMdelaunaycb(WS, DS, testdb, '/tmp/working-roman/extra/labelme/test2008/std-sift');
testDZ = LDAtopicmix( WS, DS, result.trainWP, beta );

trainC=[traindb.has_tag]; trainC = trainC(cat_id,:);
testC=[testdb.has_tag]; testC = testC(cat_id,:);

savearff(trainfname, result.DZ./repmat( sum(result.DZ,2), [1, size(result.DZ,2)]), trainC);
savearff(testfname, (testDZ./repmat( sum(testDZ), [size(testDZ,1), 1]))', testC);
