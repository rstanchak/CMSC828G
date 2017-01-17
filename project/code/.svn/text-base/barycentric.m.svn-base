function Y=barycentric(X)
% convert barycentric coordinates to points on 2D plane
% (a,b,c) -> (b+c/2, sqrt(3)/2 c) 

if size(X,1)~=3,
	error('X must be 3 x N');
end

Y = [X(2,:)+X(3,:)/2 ; sqrt(3)/2 * X(3,:)];
