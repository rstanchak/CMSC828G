function tree = LMktree(database, pfx_keys, options),
% GO_TREE_NEW  Scan the database to build K-tree dictionary
%   This is from
%
%   [1] D. Nister and H.Stewenius, "Scalable recognition with a
%   vocabulary tree," in Proc. CVPR, 2006.
%   

% AUTORIGHTS
% Copyright (C) 2006 Regents of the University of California
% All rights reserved
% 
% Written by Andrea Vedaldi (UCLA VisionLab).
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the distribution.
%     * Neither the name of the University of California, Berkeley nor the
%       names of its contributors may be used to endorse or promote products
%       derived from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
% EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

if ~exist('options', 'var')
	options = struct();
end
if ~isfield(options, 'tree_fair_data')
	options.tree_fair_data=0;
end
if ~isfield(options, 'tree_limit_data')
	options.tree_limit_data=.1;
end
if ~isfield(options, 'tree_restrict_to_train')
	options.tree_restrict_to_train=0;
end
if ~isfield(options, 'tree_K')
	options.tree_K=10;
end
if ~isfield(options, 'tree_nleaves')
	options.tree_nleaves=10000;
end
if ~isfield(options, 'data_min_sigma')
	options.data_min_sigma=1.0;
end

% --------------------------------------------------------------------
if ~isfield(database,'f')
	fprintf('Loading features...\n') ;
	for k=1:length(database)
		% load keys
		[PATHSTR,NAME,EXT,VERSN] = fileparts( database(k).annotation.filename );
		key_name=fullfile(pfx_keys, database(k).annotation.folder, [NAME, '.key']);

		f = load(key_name,'-ASCII')' ;
		M = size(f,2) ;
		
		% load descriptors
		[path,name] = fileparts(key_name) ;
		desc_name = fullfile(path, [name '.desc']) ;
		fd=fopen(desc_name,'r','l') ; 
		d =fread(fd,[128,size(f,2)],'uint8=>uint8') ;
		fclose(fd) ;
		
		% throw away small features
		sel = find(f(3,:) >= options.data_min_sigma) ;
		f = f(:,sel) ;
		d = d(:,sel) ;
		
		% throw away excess features
		N = size(d,2) ;
		perm = randperm(N) ;
		N_keep = ceil(options.tree_limit_data*N) ;
		sel = perm(1:N_keep) ;
		
		% throw away features if this is not training data
		if options.tree_restrict_to_train && ~ database(k).is_train
			sel = [] ;
		end
		
		database(k).d=d;
		fprintf('Loaded ''%s''\r', key_name) ;
	end 
	fprintf('\nFeatures loaded.\n') ;
end

data = [database.d];

% now build the tree
fprintf('Building k-tree ...\n') ;
[tree,asgn] = hikmeans(data,options.tree_K,options.tree_nleaves) ;
