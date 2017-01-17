function A=distance_matrix(X)
% compute NxN L1 distance matrix A for the KxN input point set
% where the entries of A encode the euclidean distance between
% pairs of points in X
% 
% A(i,j) = | X(:,i) - X(:,j) |
%
[K,N] = size(X);
A = zeros(N,N);
for i=1:N
	A(i,i)=0;
	for j=1:(i-1),
		A(i,j)=sum(abs(X(:,i)-X(:,j)));
		A(j,i)=A(i,j);
	end
end
