function R = weka_crossvalidation(train_fname, algorithm, args)
% call weka using the input data and class as input and the given algorithm
% where algorithm is the java class designation, i.e.  
%     weka.classifiers.m5.M5Prime
%     weka.classifiers.j48.J48
%     etc
% R is a struct containing TP, FP, KAPPA, ABS_ERR, RMS_ERR, ABS_REL_ERR, RMS_REL_ERR
if(~exist('args', 'var'))
	args='';
end%if

weka_config;
sys=sprintf(WEKAX_CMD, algorithm, train_fname, args);
disp(sys);

clear R;

% Time classifier training call
tic();
[status, output] = system(sys);
R.TIME=toc();

if status~= 0,
	error('Error running weka classifier -- please check /tmp/weka.txt');
end

%[status, output] = system ("echo foo; exit 2");
fid=fopen(outfname, 'r');

s = fgets (fid);
while isstr(s);
	[S, E, TE, M, T, NM]=regexp(s, 'Correctly Classified Instances\s+(\d+)');
	if(length(S)>0), R.TP=str2double(T{1}{1}); end%if;
	[S, E, TE, M, T, NM]=regexp(s, 'Incorrectly Classified Instances\s+(\d+)');
	if(length(S)>0), R.FP=str2double(T{1}{1}); end%if;
	[S, E, TE, M, T, NM]=regexp(s, 'Kappa statistic\s+([-\d\.]+)');
	if(length(S)>0), R.KAPPA=str2double(T{1}{1}); end%if;
	[S, E, TE, M, T, NM]=regexp(s, 'Mean absolute error\s+([\d\.]+)');    
	if(length(S)>0), R.ABS_ERR=str2double(T{1}{1}); end%if;
	[S, E, TE, M, T, NM]=regexp(s, 'Root mean squared error\s+([\d\.]+)');    
	if(length(S)>0), R.RMS_ERR=str2double(T{1}{1}); end%if;
	[S, E, TE, M, T, NM]=regexp(s, 'Relative absolute error\s+([\d\.]+)');
	if(length(S)>0), R.ABS_REL_ERR=str2double(T{1}{1}); end%if;
	[S, E, TE, M, T, NM]=regexp(s, 'Root relative squared error\s+([\d\.]+)'); 
	if(length(S)>0), R.RMS_REL_ERR=str2double(T{1}{1}); end%if;
	s = fgets (fid);
end%while
fclose(fid);

% check that all fields were assigned
fields={'TIME', 'TP', 'FP', 'KAPPA', 'ABS_ERR', 'RMS_ERR', 'ABS_REL_ERR', 'RMS_REL_ERR' };
for r=1:length(fields),
	field = fields{r};
	if ~isfield( R, field ),
		error( sprintf('Field %s not assigned in result -- check weka output in /tmp/weka.txt', field ) );
	end
end%for
