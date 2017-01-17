LMresult_100=load('/tmp/working-roman/extra/labelme/train/ATresult_100.mat', 'testADtruth', 'testADprob');
LMresult_10000=load('/tmp/working-roman/extra/labelme/train/ATresult_10000.mat', 'testADtruth', 'testADprob');
LMresult_rel=load('/tmp/working-roman/extra/labelme/train/ATresult_rel.mat', 'testADtruth', 'testADprob');

N = size(LMresult_100.testADprob, 2);
norm = @(A) A./ repmat( sum(A), [size(A,1) 1] );
%norm = @(A) (A-repmat(min(A), [size(A,1) 1]))./ repmat( max(A)-min(A), [size(A,1) 1] );

% normalize class prob 
LMresult_100.testADprob=norm(LMresult_100.testADprob);
LMresult_10000.testADprob=norm(LMresult_10000.testADprob);
LMresult_rel.testADprob=norm(LMresult_rel.testADprob);

for i=1:size(LMresult_100.testADprob,1)
	[TP100,FP100]=roc(LMresult_100.testADprob(i,:), LMresult_100.testADtruth(i,:));
	[TP10000,FP10000]=roc(LMresult_10000.testADprob(i,:), LMresult_10000.testADtruth(i,:));
	[TPrel,FPrel]=roc(LMresult_rel.testADprob(i,:), LMresult_rel.testADtruth(i,:));
	[TPrand,FPrand]=roc(rand(N,1), LMresult_100.testADtruth(i,:));
	plot( FP100, TP100, 'b-', FP10000, TP10000, 'g-', FPrel, TPrel, 'r-', FPrand, TPrand, 'k-' );
	title(tags{i});
	ylabel('True positive rate');
	xlabel('False positive rate');
	pause(5.0);
end
