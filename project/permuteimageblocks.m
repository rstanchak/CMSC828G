blocksz=16;
sz = size(img1)/blocksz;
nblocks = prod(sz);
perm=randperm(nblocks);
bimg = zeros(size(img));
for k=1:nblocks,
	[i1,j1] = ind2sub(sz, perm(k));
	[i2,j2] = ind2sub(sz, k);
	i1 = (i1-1)*blocksz + (1:blocksz);
	j1 = (j1-1)*blocksz + (1:blocksz);
	i2 = (i2-1)*blocksz + (1:blocksz);
	j2 = (j2-1)*blocksz + (1:blocksz);
	bimg(i2,j2,1:3)=img(i1,j1,1:3);
end
bimg = uint8(bimg);
imshow(bimg)
