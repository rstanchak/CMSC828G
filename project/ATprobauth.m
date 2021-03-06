function pA = ATprobauth( testW, trainWT, trainAT, alpha, beta ), 
% return the log probibilty the indicies in words were generated by each author
% trainWT are 
% trainAT are 
nW=size(trainWT,1);
nT=size(trainWT,2);
nA=size(trainAT,1);

pA=zeros(1,nA);
pA1=zeros(1,nA);

sum_trainWT= sum(trainWT);
SUM_trainWT=repmat( sum(trainWT), [size(trainWT, 1), 1]);
W = sparse(testW, ones(size(testW)), ones(size(testW)), nW, 1);
for a=1:nA
	% P( z=j | author=a)
	theta = (trainAT(a,:)+alpha)./(sum(trainAT(a,:)) + alpha*size(trainAT,2));

	PHI = (trainWT+beta)./(SUM_trainWT + beta*size(trainWT,1));
	THETA = repmat( theta, [size(trainWT, 1), 1] );

	pA(a) = sum( W.*log( sum( PHI.*THETA, 2 ) ) );
	%for i=1:length(testW)
	%	w = testW(i);
		% P(word=w | z=j)
	%	phi = (trainWT(w,:)+beta)./(sum_trainWT + beta*size(trainWT,1));

		% P(word=w | author=a)
	%	pA(a) = pA(a) + log( sum(phi.*theta) );
	%end
end

