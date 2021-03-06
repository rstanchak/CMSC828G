function [WS, DS] = LMtopicinput(database),
% reshape database cb_idx variable into topic toolbox WS and DS 
% WS: list of word indices
% DS: list of document indices
WS = [database.rcb_idx];
DS = zeros(size(WS));
k=1;
for i=1:length(database);
	DS(k:(k+length(database(i).rcb_idx)-1))=i;
	k=k+length(database(i).rcb_idx);
end

