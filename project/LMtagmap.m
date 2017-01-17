function tagmap=LMtagmap(taglist),
% get tag indices from names
tagmap=java.util.HashMap;
for i=1:length(taglist),
	tagmap.put(taglist{i}, i);
end
