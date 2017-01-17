function [WP, DP, Z]=read_ctm(fname)
% read the assignment-file produced by CTM and return the following:
% WP(i,j) contains the number of times word |i| has been assigned to topic |j|.
% DP(d,j) contains the number of times a word in document |d| has been assigned to topic |j|
% Z(k) contains the topic assignment for token k.  

f=fopen(fname, 'r');
WP=0;
DP=0;
Z=0;

k=1;
ntopics=0;
nwords=0;
ntokens=0;

while ~feof(f),
	count=fscanf(f,'%d',1);
	if length(count)>0,
		Y = fscanf(f,'%d:%d',count*2);
		Y = Y+1;  % 0 to 1 based index
		nwords=max(nwords, max(Y(1:2:end)));
		ntopics=max(ntopics, max(Y(2:2:end)));
		X{k}=Y;
		k=k+1;
		ntokens=ntokens+count;
	end
end
fclose(f);

WP=sparse(nwords, ntopics);
DP=sparse(length(X), ntopics);
%Z=zeros(ntokens);

k=1;
for i=1:length(X),
	DP(i, :)=hist(X{i}(2:2:end), 1:ntopics);
end
