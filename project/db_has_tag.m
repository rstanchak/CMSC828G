function has_tag=db_has_tag(db, tag_names)
% return sparse matrix 'has_tag' that indicates whether 
% the database entry contains an annotation that matches that tag 

tag_lut=java.util.HashMap;
for i=1:length(tag_names),
	tag_lut.put(tag_names{i},i);
end

has_tag = sparse( length(tag_names), length(db) );
for i=1:length(db),
	if isfield(db(i).annotation, 'object'),
		for j=1:length(db(i).annotation.object)
			if isfield(db(i).annotation.object(j), 'tag'),
				has_tag( tag_lut.get( db(i).annotation.object(j).tag ), i )=1;
			end
		end
	end
end
