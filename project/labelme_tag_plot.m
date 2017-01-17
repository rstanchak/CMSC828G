function labelme_tag_plot( W, tagarray, i1, i2, i3, i4)
colormap([0 0 1; 1 0 0; .75 1  0 ; 1 .75 0]);
scatter(W(:,i1)+.1*randn(1,size(W, 1))', ...
        W(:,i2)+.1*randn(1,size(W, 1))', 12, ...
		W(:,i3) + 2*W(:,i4)); 
xlabel( tagarray(i1)); 
ylabel( tagarray(i2));
legend(sprintf('%s, %s', tagarray{i3}, tagarray{i4}))
