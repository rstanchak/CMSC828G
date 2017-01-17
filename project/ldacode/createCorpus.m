function D = createCorpus(files,lexicon,stopwords)
% CREATECORPUS
%
% function D = createCorpus(files,lexicon,stopwords)
%
% input: files - list of files to vectorify
%        lexicon - the lexicon to use
% output: The Corpus which is a V x M matrix where
%         V is the size of the lexicon and
%         M is the size of the corpus (number of files)

%D = sparse(length(lexicon),length(files));
fprintf(1,'Creating Corpus\n');
D=cell(1,length(files));
tic
for d = 1:length(files)
    D{d} = wordlist(files{d},lexicon,stopwords);
    fprintf(1,'.');
    if (mod(d,50)==0)
        fprintf(1,'\n');
    end
end
endtime = toc;
% fprintf(1,'\nCreated %d documents in %f seconds for % seconds/document\n',length(files),endtime,endtime/length(files));
