function P=weka_parse_predictions(fname),
% parse stdout from weka to get actual/predicted classes for each test instance
fid = fopen(fname, 'r');
s = fgets(fid);
P=[];
while isstr(s);
	
	fields = sscanf(s, '%d %d:%d %d:%d + %f');
	if length(fields)~=6
		fields = sscanf(s, '%d %d:%d %d:%d %f');
	end
	if length(fields)==6,
		P=[P  fields];
	end
    %match=regexp(s, '(\d+)\s*(\d+):(\d+)\s*(\d+):(\d+)\s*([+]*)\s*([0-9.]+)', 'tokens');
	%if length(match)>0
	%	match{:}
	%end
	s = fgets(fid);
end%while
fclose(fid)
