function [alpha,beta,ll] = lda_param_est(D,lexsize,numtopics,maxem, ...
                                alpha0,beta0,plotoption)

% LDA_PARAM_EST
%
% function [alpha,beta,ll] = lda_param_est(D,lexsize,numtopics,maxem, ...
%                                alpha0,beta0,plotoption)
%
% input:
%   D is a V x M matrix (the corpus)
%   lexsize is the number of words in the vocabulary
%   maxem is the max number of em iterations to run
%   alpha0,beta0 are initial values for alpha and beta
%       if they should be random, set these to be scalars.
%   plotoption is 'p' for plotting the loglikelihoods at
%       each step.
%
% output:
%   alpha is a K x 1 vector
%   beta is a K x V matrix
%   ll is the log-likelihood of the data at the end of EM
%
% Authors: Jonathan Huang       (jch1 at cs.cmu.edu)
%          Tomasz Malisiewicz  (tomasz at cmu.edu)

M = length(D); 
K = numtopics; 
V = lexsize;   

% initialize variables
if length(alpha0) <= 1 && length(beta0) <= 1
    alpha = rand(K,1)+1;
    beta = rand(K,V)+.01;
else
    alpha = alpha0;
    beta = beta0;
end
beta = beta ./ repmat(sum(beta,2),1,V);
alphaold = alpha;
betaold = beta;
gamma = zeros(length(alpha),M);
%phi = cell(M);
numiter = 0;
ll = zeros(maxem+1,1);

if exist('plotoption') && strcmp(plotoption,'p')
    figure;
    hold on;
end

while true
    alphaold = alpha;
    betaold = beta;

    %E-step
    tic
    fprintf(1,'E-step\n');
    [gamma,phi,likelihood]=Estep(D,alpha,beta);
    ll(numiter+1) = likelihood;
    toc

    %M-step
    tic    
    fprintf(1,'M-step\n');
    beta = updatebeta(D,phi,K,V);
    alpha = updatealpha(alpha,gamma,M);    
    toc

    numiter = numiter + 1
    if exist('plotoption') && strcmp(plotoption,'p')
        plotll(ll(1:numiter),[1 maxem+1 ll(1) 0]);
    end
    if (numiter > maxem || (numiter > 1 && ...
                (ll(numiter-1)-ll(numiter))/(ll(numiter)) < .001))
        break;
    end

    fprintf(1,'writing alpha and beta\n');
    save('intermediate_result.mat','alpha','beta');
end
ll = ll(numiter);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ldagamma,ldaphi,likelihood]=Estep(D,a,b)

M = length(D);
ldagamma = zeros(length(a),M);
%ldaphi = cell([1,M]);
likelihood = 0;
for d = 1:M
	[gamma,phi,ll] = ldainference(D{d},a,b);
	ldagamma(:,d) = gamma;
	ldaphi{d} = phi;
    likelihood = likelihood + ll;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function beta = updatebeta(D,ldaphi,numtopics,lexsize)

beta = zeros(numtopics,lexsize);
for d = 1:length(D)
    for n = 1:length(D{d})
        beta(:,D{d}(n)) = beta(:,D{d}(n)) + ldaphi{d}(:,n);
    end
end
beta = beta ./ repmat(sum(beta,2),1,lexsize);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function alpha = updatealpha(alpha,ldagamma,numdocs)

pg = sum( digamma( ldagamma )' )' - ones(length(alpha),1) * sum( digamma(sum(ldagamma)));
M = numdocs;
hessian_max_iter = 40000;
hessian_iter = 1;

fprintf(1,'Starting Newton-Raphson.\n');
alpha_before_newton = alpha;
while (true)
    alphasum = sum(alpha);
    Gradient =  M*((digamma(alphasum))-digamma(alpha))+pg;
    h = M*trigamma(alpha);
    z = -M* trigamma(alphasum);
    c = sum(Gradient ./ h ) / (z^-1 + sum(1./h));
    alpha_new = alpha + (Gradient - c)./h; 

    diff = norm(alpha - alpha_new);
    alpha = alpha_new;
    alpha = max(alpha,repmat(.0002,size(alpha,1),size(alpha,2)));

    if (diff < .0001)
        break;
    end

    %fprintf(1,'Newton Raphson iteration diff of %f\n',diff);
    hessian_iter = hessian_iter +1;
    if (hessian_iter > hessian_max_iter)
        alpha = alpha_before_newton;
        break;
    end
end
fprintf(1,'Newton-Raphson Iterations: %d\n',hessian_iter);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotll(ll,boxdim)

clf
plot(ll)
axis(boxdim);
title('Data Log-Likelihood in EM');
xlabel('#Iterations');
ylabel('Log-Likelihood');
drawnow
