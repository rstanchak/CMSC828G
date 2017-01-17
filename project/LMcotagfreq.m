function A=LMcotagfreq(db)
% return a symmetric binary matrix indicating which tags
% occur together in some image.

W = [db.has_tag];
[Y,I] = sort( sum(W, 2) ); %'descend');
A=zeros( length(db(1).has_tag ) );
for i=1:length(db),
	idx=find( db(i).has_tag );
	for ii=1:length(idx),
		for jj=(ii+1):length(idx),
			A(I(idx(ii)),I(idx(jj)))=A(I(idx(ii)),I(idx(jj)))+1;
			A(I(idx(jj)),I(idx(ii)))=A(I(idx(ii)),I(idx(jj)));
		end
	end
end
