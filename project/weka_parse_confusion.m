function confusion = weka_parse_confusion(fname)
% parse the file fname and return the confusion matrix

fid=fopen(fname, 'r');

s = fgets(fid);
while isstr(s);
	if regexp(s, 'Confusion Matrix'),
		fgets( fid );  % blank line
		s=fgets( fid );  % " a   b   <-- classified as" 
		s=regexp(s, '(.*)<--', 'tokens');
		s=regexp(s{1}{1}, '(\w+)', 'tokens');
		nclasses = length(s);
		if nclasses<2,
			error('Error parsing /tmp/weka.txt');
		end
		confusion = zeros( nclasses );
		% parse classes
		for i=1:nclasses,
			s = fgets( fid );
			confusion( i, : ) = sscanf(s, '%d', nclasses);
		end
	end
	s = fgets(fid);
end
fclose(fid);
