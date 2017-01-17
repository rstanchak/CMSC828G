function [ldagamma,ldaphi,likelihood]=ldainference(d,a,b)

% LDAINFERENCE
%
% function [ldagamma,ldaphi,likelihood]=ldainference(d,a,b)
%
% Variational inference algorithm for the LDA Model
%
% input: (document vector, corpus parameters
%        d is a Nx1 word occurrence vector
%        a is a kx1 dirichlet parameter
%        b is a kxV matrix
% output: (variational parameters)
%        ldagamma is a kx1 vector
%        ldaphi is a kxN matrix
%        likelihood is the (variational) log likelihood of 
%        the document.
%
% where V is the size of the vocabulary
%       k is the # of topics
%       N is the number of words in d (sum(d))
%
% Authors: Jonathan Huang       (jch1 at cs.cmu.edu)
%          Tomasz Malisiewicz  (tomasz at cmu.edu)

epsilon = .00001; % convergence criterion

V = size(b,2);
k = length(a); 
N = length(d);

% initialize variational parameters
ldaphi = repmat(1/k,k,N);
ldagamma = a + repmat(N/k,k,1);

oldphi=ldaphi;
oldgamma=ldagamma;

maxiter = 200;
numiter = 1;
change=2*epsilon;
% until convergence...
while change>epsilon
    oldphi=ldaphi;
    oldgamma=ldagamma;
    
	ldaphi = b(:,d).*repmat(exp(digamma(ldagamma)),1,N);
    ldaphi = ldaphi ./ repmat(sum(ldaphi),k,1);
    ldagamma = a + sum(ldaphi')';
    
    change = max(max(abs(ldagamma-oldgamma)), ...
        max(max(abs(ldaphi-oldphi))));

	numiter = numiter + 1;  
    if (numiter > maxiter)
        break
    end
end

dig = digamma(ldagamma);
digsum = digamma(sum(ldagamma));
likelihood=gammaln(sum(a))-sum(gammaln(a)) + sum((a-1).*(dig-digsum)) ...
    - gammaln(sum(ldagamma))+sum(gammaln(ldagamma)) ...
	- sum((ldagamma-1).*(dig-digsum)) - sum(sum(ldaphi.*log(ldaphi))) ...
	+ (dig-digsum)'*sum(ldaphi,2) + sum(sum(ldaphi.*log(b(:,d))));
