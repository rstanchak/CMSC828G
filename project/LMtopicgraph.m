function LMtopicgraph(db, document_topics, filename)

f=fopen(filename, 'w');
fprintf(f, '<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(f, '<graphml xmlns="http://graphml.graphdrawing.org/xmlns"  \n');
fprintf(f, '    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n');
fprintf(f, '    xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns\n');
fprintf(f, '     http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">\n');
fprintf(f, '  <key id="d0" for="node" attr.name="folder" attr.type="string"><default></default></key>\n');
fprintf(f, '  <key id="d1" for="node" attr.name="filename" attr.type="string"><default></default></key>\n');
fprintf(f, '  <key id="d2" for="node" attr.name="type" attr.type="string"/>\n');
fprintf(f, '  <key id="d3" for="edge" attr.name="weight" attr.type="double"/>\n');
fprintf(f, '  <graph id="G" edgedefault="undirected">\n');

for i=1:length(db),
	fprintf(f, '<node id="img%d">\n', i);
	fprintf(f, '<data key="d0">%s</data>\n', db(i).annotation.folder);
	fprintf(f, '<data key="d1">%s</data>\n', db(i).annotation.filename);
	fprintf(f, '<data key="d2">image</data>\n</node>\n');
end
for i=1:size(document_topics,2)
	fprintf(f,'<node id="z%d">\n', i);
	fprintf(f,'<data key="d2">topic</data>\n</node>\n');	
end
for i=1:size(document_topics,1)
	z = sum(document_topics(i,:));
	for j=1:size(document_topics,2)
		if(document_topics(i,j)),
			fprintf(f, '<edge source="img%d" target="z%d">\n<data key="d3">%f</data>\n</edge>', i, j, document_topics(i,j)/z);
		end
	end
end
fprintf(f, '</graph></graphml>\n');
fclose(f);

