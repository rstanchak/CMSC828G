function A=LMcommontags(db)
% return a symmetric binary matrix indicating which tags
% occur together in some image.

A=zeros( length(db(1).has_tag ) );
for i=1:length(db),
	I=find( db(i).has_tag );
	for ii=1:length(I),
		for jj=2:length(I),
			A(I(ii),I(jj))=1;
		end
	end
end
