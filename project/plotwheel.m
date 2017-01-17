function plotwheel( A )
% plot the adjacency matrix A on a wheel
N = size(A,1);
T = (0:(N-1))/N*2*pi;
R = 1;
X = R*cos(T);
Y = R*sin(T);
%colormap jet
%scatter(X,Y,12,1:N);
idx = find(A);
[I,J] = ind2sub(size(A), idx);

X1=X(I);
Y1=Y(I);
X2=X(J);
Y2=Y(J);

clf;
h=line( [X1 ; X2], [Y1 ; Y2]);

