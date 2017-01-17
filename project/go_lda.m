if(~exist('database'))
	go_tree;
	go_sign;
end

% reshape data into word count, document count
WS = [database.cb_idx];
DS = zeros(size(WS));
k=1;
for i=1:length(database);
	DS(k:(k+length(database(i).cb_idx)-1))=i;
	k=k+length(database(i).cb_idx);
end
%%
% Set the number of topics
T=200;

%%
% Set the hyperparameters
BETA=0.01;
ALPHA=50/T;

%%
% The number of iterations
N = 100;

%%
% The random seed
SEED = 3;

%%
% What output to show (0=no output; 1=iterations; 2=all output)
OUTPUT = 2;

%%
% This function might need a few minutes to finish
tic
[ WP,DP,Z ] = GibbsSamplerLDA( WS,DS,T,N,ALPHA,BETA,SEED,OUTPUT );
toc
