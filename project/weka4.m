function weka4(train_fname, test_fname, out_fname, algorithm, args)
% call weka using the input data and class as input and the given algorithm
% where algorithm is the java class designation, i.e.  
%     weka.classifiers.m5.M5Prime
%     weka.classifiers.j48.J48
%     etc
% R is a struct containing TP, FP, KAPPA, ABS_ERR, RMS_ERR, ABS_REL_ERR, RMS_REL_ERR
if(~exist('args', 'var'))
	args='';
end%if

%outfname='/tmp/weka.txt';
%CP='/fs/junkfood/roman/localroot/generic/usr/share/java/lib/libsvm.jar:/fs/junkfood/roman/localroot/generic/usr/share/java/lib/weka.jar';
%filter='(^optimization|^nu|^obj|nSV|^Zero|^\*)';
%sys=sprintf('/usr/local/bin/java -cp %s %s -t %s -T %s %s 2>&1 | egrep -v ''%s'' > %s', CP, algorithm, train_fname, test_fname, args, filter, outfname);
weka_config;
WEKA_CMD=sprintf('/usr/local/bin/java -Xmx2048m -cp %s %%s -t %%s -T %%s -threshold-file %s %%s 2>&1 | egrep -v ''%s'' > %s', CP,                out_fname, WEKA_FILTER, WEKA_STDOUT);
sys=sprintf(WEKA_CMD, algorithm, train_fname, test_fname, args);
disp(sys);

% kill some old files to avoid errors
if exist(WEKA_THRESH_FILE, 'file')
	delete( WEKA_THRESH_FILE );
end

% Time classifier training call
tic();
[status, output] = system(sys);
TIME=toc();

if status~= 0,
	error('Error running weka classifier -- please check /tmp/weka.txt');
end

if ~exist(out_fname, 'file')
	error(sprintf('Error reading %s -- please check /tmp/weka.txt'));
end

%[status, output] = system ("echo foo; exit 2");
%fid=fopen(outfname, 'r');

%s = fgets (fid);
%while isstr(s);
%	[S, E, TE, M, T, NM]=regexp(s, 'Correctly Classified Instances\s+(\d+)');
%	if(length(S)>0), R.TP=str2double(T{1}{1}); end%if;
%	[S, E, TE, M, T, NM]=regexp(s, 'Incorrectly Classified Instances\s+(\d+)');
%	if(length(S)>0), R.FP=str2double(T{1}{1}); end%if;
%	[S, E, TE, M, T, NM]=regexp(s, 'Kappa statistic\s+([-\d\.]+)');
%	if(length(S)>0), R.KAPPA=str2double(T{1}{1}); end%if;
%	[S, E, TE, M, T, NM]=regexp(s, 'Mean absolute error\s+([\d\.]+)');    
%	if(length(S)>0), R.ABS_ERR=str2double(T{1}{1}); end%if;
%	[S, E, TE, M, T, NM]=regexp(s, 'Root mean squared error\s+([\d\.]+)');    
%	if(length(S)>0), R.RMS_ERR=str2double(T{1}{1}); end%if;
%	[S, E, TE, M, T, NM]=regexp(s, 'Relative absolute error\s+([\d\.]+)');
%	if(length(S)>0), R.ABS_REL_ERR=str2double(T{1}{1}); end%if;
%	[S, E, TE, M, T, NM]=regexp(s, 'Root relative squared error\s+([\d\.]+)'); 
%	if(length(S)>0), R.RMS_REL_ERR=str2double(T{1}{1}); end%if;
%	s = fgets (fid);
%end%while
%fclose(fid);

% check that all fields were assigned
%fields={'TIME', 'TP', 'FP', 'KAPPA', 'ABS_ERR', 'RMS_ERR', 'ABS_REL_ERR', 'RMS_REL_ERR' };
%for r=1:length(fields),
%	field = fields{r};
%	if ~isfield( R, field ),
%		error( sprintf('Field %s not assigned in result -- check weka output in /tmp/weka.txt', field ) );
%	end
%end%for
