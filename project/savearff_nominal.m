function savearff(fname, A, C, labels, class_labels)
% save labeled data A,C to Weka arff data format
% where A is a matrix whose rows are data points 
% and C is a vector whose elements are classes
f = fopen(fname, 'w');

if strcmp(class(A),'double'),
	A_cls='real';
	A_fmt='%f,';
elseif strcmp(class(A),'uint8'),
	A_cls='NUMERIC';
	A_fmt='%d,';
else
	error(sprintf('class of %s is not handled', class(A)));
end

% ARFF header
fprintf(f, '@relation ''data''\n');
for i=1:size(A,2),
	fprintf(f, '@attribute "%s" %s\n', labels{i}, A_cls);
end
fprintf(f, '@attribute class {');
for i=1:length(class_labels),
	fprintf(f, '"%s" ', class_labels{i});
end
fprintf(f, '}\n@data\n');

% if A is sparse, output a sparse ARFF file
if issparse(A),
	for i=1:size(A,1),
		[I,J,S] = find(A(i,:));
		J=J-1; % ARFF is 0 based index
		fprintf(f, '{');
		fprintf(f, ['%d ',A_fmt], [J;S]);
		fprintf(f, '%d %s}\n', size(A,2), class_labels{C(i)});
	end
else
	for i=1:size(A,1),
		fprintf(f, A_fmt, A(i,:));
		fprintf(f, '%s\n', class_labels{C(i)});
	end
end
fclose(f);
