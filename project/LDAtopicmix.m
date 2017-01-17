function Z = LDAtopicmix( WS, DS, trainWT, beta ), 
% trainWT are word-topic assignment counts
% trainWT is a |W| x |T| matrix
[nW, nZ] = size(trainWT);
nD=max(DS);

SUM_trainWT=repmat( sum(trainWT), [size(trainWT, 1), 1]);
PHI = (trainWT+beta)./(SUM_trainWT + beta*size(trainWT,1));
W = sparse(WS, DS, ones(prod(size(WS)),1), nW, nD);

Z = sparse( nZ, nD );
for i=1:nZ,
	Z(i,:) = sum( repmat(PHI(:,i), [1,nD]) .* W );
end
