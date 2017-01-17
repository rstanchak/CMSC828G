function A=LMcotagfreq(db)
% return a symmetric binary matrix indicating which tags
% occur together in some image.

ncodewords=max([db.cb_idx]);
A=sparse( ncodewords, ncodewords );
for i=1:length(db),
	C=hist(db(i).cb_idx, 1:ncodewords);
	for ii=find(C),
		A(ii,:)=A(ii,:)+C;
	end
end
