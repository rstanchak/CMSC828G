function ATgraphml(WP, AT, vocab, authors, filename)

f=fopen(filename, 'w');
fprintf(f, '<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(f, '<graphml xmlns="http://graphml.graphdrawing.org/xmlns"  \n');
fprintf(f, '    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n');
fprintf(f, '    xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns\n');
fprintf(f, '     http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">\n');
fprintf(f, '  <key id="d0" for="node" attr.name="name" attr.type="string"><default></default></key>\n');
fprintf(f, '  <key id="d1" for="node" attr.name="type" attr.type="string"/>\n');
fprintf(f, '  <key id="d2" for="edge" attr.name="weight" attr.type="double"/>\n');
fprintf(f, '  <graph id="G" edgedefault="undirected">\n');
if length(vocab)==0,
	clear vocab;
	for i=1:size(WP,1),
		vocab{i}=sprintf('word %d', i);

	end
end

for i=1:length(vocab)
	fprintf(f, '<node id="word%d">\n', i);
	fprintf(f, '<data key="d0">%s</data>\n', vocab{i});
	fprintf(f, '<data key="d1">word</data>\n</node>\n');
end
for i=1:length(authors)
	fprintf(f, '<node id="author%d">\n', i);
	fprintf(f, '<data key="d0">%s</data>\n', authors{i});
	fprintf(f, '<data key="d1">author</data>\n</node>\n');
end
for i=1:size(WP,2)
	fprintf(f,'<node id="z%d">\n', i);
	fprintf(f,'<data key="d0">Topic %d</data>\n', i);
	fprintf(f,'<data key="d1">topic</data>\n</node>\n');	
end
for i=1:size(WP,1)
	z = sum(WP(i,:));
	for j=1:size(WP,2)
		if(WP(i,j)),
			fprintf(f, '<edge source="word%d" target="z%d">\n<data key="d2">%f</data>\n</edge>', i, j, WP(i,j)/z);
		end
	end
end
for i=1:size(AT,1)
	z = sum(AT(i,:));
	for j=1:size(AT,2)
		if(AT(i,j)),
			fprintf(f, '<edge source="author%d" target="z%d">\n<data key="d2">%f</data>\n</edge>', i, j, AT(i,j)/z);
		end
	end
end
fprintf(f, '</graph></graphml>\n');
fclose(f);

