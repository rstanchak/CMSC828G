function adj2graphml(filename, A, names)
% save the adjacency matrix A to the graphml file filename
% names is an array of the node names

f=fopen(filename, 'w');
fprintf(f, '<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(f, '<graphml xmlns="http://graphml.graphdrawing.org/xmlns"  \n');
fprintf(f, '    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n');
fprintf(f, '    xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns\n');
fprintf(f, '     http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">\n');
fprintf(f, '  <key id="d0" for="node" attr.name="name" attr.type="string"/>\n');
fprintf(f, '  <key id="d1" for="edge" attr.name="freq" attr.type="int"/>\n');
fprintf(f, '  <graph id="G" edgedefault="undirected">\n');

for i=1:length(names),
	fprintf(f, '<node id="n%d">\n<data key="d0">%s</data>\n</node>\n', i, names{i} );
end

for i=1:size(A,1)
	for j=1:size(A,2)
		if(A(i,j)),
			fprintf(f, '<edge source="n%d" target="n%d">\n<data key="d1">%d</data>\n</edge>', i, j, A(i,j));
		end
	end
end
fprintf(f, '</graph></graphml>\n');
fclose(f);

