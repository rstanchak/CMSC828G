function R = weka(varargin)
%function confusion = weka(X, Y, testX, testY, algorithm, args)
% weka(trainX, trainCLS, testX, testCLS, options)
% weka(X, CLS, options)
% weka(train_fname, test_fname, options)
% call weka using the input data and class as input and the given algorithm
% where algorithm is the java class designation, i.e.  
%     weka.classifiers.m5.M5Prime
%     weka.classifiers.j48.J48
%     etc
if nargin<1
	wekausage;
else,
  	if nargin<4,
		% filenames given
		% weka(train_fname, test_fname, options)
		if isstr(varargin{1}),
			train_fname = varargin{1};
			if nargin>1,
				if isstr(varargin{2}),
					test_fname = varargin{2};
				else
					options = varargin{3};
				end
			end
		else
			X = varargin{1};
			Y = varargin{2};
		end
		if nargin==3,
			options = varargin{3};
		end
	else,

	end
end;

% create default options
if ~exist('options', 'var'),
	options=struct();
end

% set default classifier if not given
if ~isfield(options, 'algorithm'),
	options.algorithm='weka.classifiers.bayes.NaiveBayes';
	options.args='';
	options.verbosity=1;
	warning(['No classifier given, using default: ', options.algorithm]);
end

% set other default options
if ~isfield(options, 'predictions'),
	options.predictions=0;
end
if ~isfield(options, 'verbosity'),
	options.verbosity=1;
end
if ~isfield(options, 'confusion'),
	options.confusion=~options.predictions;
end

% write ARFF files if given arrays
if ~exist('train_fname', 'var'),
	train_fname='/tmp/train_octave.arff';
	savearff(train_fname, X, Y );
	
	% write test ARFF if given
	if exist('testX', 'var'),
		test_fname='/tmp/test_octave.arff';
		savearff(test_fname, testX, testY);
	end
end

%if options.predictions,
options.args = [options.args, ' -p 0'];
%end

weka_config;
if ~exist('test_fname', 'var'),
	% do cross validation
	sys=sprintf(WEKAX_CMD, options.algorithm, train_fname, options.args);
else
	% classify test set
	sys=sprintf(WEKA_CMD, options.algorithm, train_fname, test_fname, options.args);
end
if options.verbosity > 0,
	disp(sys);
end

[status, output] = system(sys);

if status~= 0,
	error('Error running weka classifier -- please check /tmp/weka.txt');
end

%if options.confusion,
	%[status, output] = system ("echo foo; exit 2");
%	R.confusion = weka_parse_confusion(WEKA_STDOUT);
%elseif options.predictions
predictions = weka_parse_predictions(WEKA_STDOUT);
R.predicted = predictions(5,:);
R.actual = predictions(3,:);
R.score = predictions(6,:);
R.confusion = sparse( R.actual, R.predicted, ones( size(R.predicted) ) );

%end

end %function

function wekausage()
	help weka;
end%function
