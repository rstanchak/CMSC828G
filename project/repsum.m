function A=repsum(A, dim)
% calculate repmat( sum(A, dim), size(A, otherdim)
if ~exist('dim', 'var'),
	dim=1;
end

if dim>2,
	error('dim > 2 not implemented');
end

if dim==1,
	A=repmat(sum(A), [size(A,1), 1]);
elseif dim==2,
	A=repmat(sum(A,2), [1, size(A,2)]);
end
