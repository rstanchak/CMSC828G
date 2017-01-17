function wl=wordlist(filename,lexicon)

% WORDLIST
%
% function wl=wordlist(filename,lexicon)
%
% input: filename for newsgroup document
% output: list of indices into lexicon corresponding
% to each word of the document

words=retrievewords(filename);
wl=zeros(length(words),1);
counter=0;
for i=1:length(words)
	index=lexiconFind(lexicon,words{i});
    if index>0
        counter=counter+1;
        wl(counter) = index;
    end
end

wl=wl(1:counter);