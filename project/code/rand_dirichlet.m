function Y = rand_dirichlet( alpha, count ),
% sample vector from dirichlet distribution
if ~exist('alpha'),
	alpha = 1;
end
if ~exist('count', 'var'),
	count = 1;
end

Y = randg( repmat( alpha, [count, 1] ) );
Y = Y ./ repmat( sum(Y, 2), [1, length(alpha)]);
