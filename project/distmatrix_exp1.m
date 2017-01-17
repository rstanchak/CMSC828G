N = 10;
K = 10;
X = rand(K,N);

%figure(1);
%plot(X(1,:), X(2,:), '*');

for i=1:1000,
	idx = randperm(N);
	A = distance_matrix(X(:,idx));
	figure(2);
	imagesc(A);
	drawnow;
	pause(0.5);
end
