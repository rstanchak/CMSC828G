function [alpha,beta,ll] = trainLDA(D,lexsize,numtopics,maxem)

% TRAINLDA
%
% function [alpha,beta,ll] = trainLDA(D,lexsize,numtopics,maxem)
%
% This function is basically LDA_PARAM_EST except that it tries
% LDA_PARAM_EST a lot of times and takes the best outcome
%
% input:
%   D is a V x M matrix (the corpus)
%   lexsize is the number of words in the vocabulary
%   maxem is the max number of em iterations to run
%
% output:
%   alpha is a K x 1 vector
%   beta is a K x V matrix
%   ll is the log-likelihood of the data at the end of EM
%
% Authors: Jonathan Huang       (jch1 at cs.cmu.edu)
%          Tomasz Malisiewicz  (tomasz at cmu.edu)

numtries = 20;
numbesttries = 5;
tmpalphas = cell(numtries,1);
tmpbetas = cell(numtries,1);
alphas = cell(numbesttries,1);
betas = cell(numbesttries,1);
tmpll = zeros(numtries,1);
ll = zeros(numbesttries,1);

for i=1:numtries
    [tmpalphas{i},tmpbetas{i},tmpll(i)] = lda_param_est(D,lexsize,numtopics,5,0,0,'n');
    disp(sprintf('corpus likelihood: %f',tmpll(i)));
end

[bestlikes,bestindices]=sort(tmpll,1,'descend');

for i=1:numbesttries
    [alphas{i},betas{i},ll(i)] = lda_param_est(D,lexsize,numtopics,...
            maxem,tmpalphas{bestindices(i)},tmpbetas{bestindices(i)},'p');
end

[bestlike,bestindex]=max(ll);
alpha = alphas{bestindex};
beta = betas{bestindex};
tmpll 
ll
ll = bestlike;
