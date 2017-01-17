function A=normalizedim(A, dim)
% scale the data such that those values along dim sum to 1
if ~exist('dim', 'var'),
	dim=1;
end

if dim>2,
	error('dim > 2 not implemented');
end

if dim==1,
	A=A./repmat(sum(A), [size(A,1), 1]);
elseif dim==2,
	A=A./repmat(sum(A,2), [1, size(A,2)]);
end
A(find(isnan(A)))=0;
