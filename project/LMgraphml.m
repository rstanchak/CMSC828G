function LMgraphml(db, filename)

% build lookup table for tag->idx
taglist=LMtaglist(db);
tags=java.util.HashMap;
for i=1:length(taglist),
	tags.put(taglist{i}, i);
end

f=fopen(filename, 'w');
fprintf(f, '<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(f, '<graphml xmlns="http://graphml.graphdrawing.org/xmlns"  \n');
fprintf(f, '    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n');
fprintf(f, '    xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns\n');
fprintf(f, '     http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">\n');
fprintf(f, '  <key id="d0" for="node" attr.name="folder" attr.type="string"><default></default></key>\n');
fprintf(f, '  <key id="d1" for="node" attr.name="filename" attr.type="string"><default></default></key>\n');
fprintf(f, '  <key id="d2" for="node" attr.name="type" attr.type="string"/>\n');
fprintf(f, '  <key id="d3" for="node" attr.name="name" attr.type="string"><default></default></key>\n');
fprintf(f, '  <graph id="G" edgedefault="undirected">\n');

for i=1:length(db),
	anno = db(i).annotation;
	if isfield(anno, 'object'),
		fprintf(f, '<node id="img%d">\n', i);
		fprintf(f, '<data key="d0">%s</data>\n', db(i).annotation.folder);
		fprintf(f, '<data key="d1">%s</data>\n', db(i).annotation.filename);
		fprintf(f, '<data key="d2">image</data>\n</node>\n');
	end
end
for i=1:length(taglist),
	fprintf(f,'<node id="tag%d">\n', i);
	fprintf(f,'<data key="d2">tag</data>\n');
	fprintf(f,'<data key="d3">%s</data>\n</node>\n',taglist{i});	
end
for i=1:length(db),
	anno = db(i).annotation;
	if isfield(anno, 'object'),
		for j=1:length(anno.object),
			if length(anno.object(j).tag)>0,
				fprintf(f, '<edge source="img%d" target="tag%d"/>\n', i, tags.get( anno.object(j).tag ));
			end
		end
	end
end
fprintf(f, '</graph></graphml>\n');
fclose(f);

