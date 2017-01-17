function database=db_new(pfx_sift)
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

  k = 1 ; % database entry index
  c = 1 ; % category index
	
	dir_list = dir(pfx_sift) ;  
	for dn = {dir_list([dir_list.isdir]).name}
		if(strcmp(dn{1},'.') || strcmp(dn{1},'..'))
			continue ;
		end
    dir_name = dn{1} ;
		
		i = 1 ; % image index
		
		file_list = dir([fullfile(pfx_sift, dir_name) '/*.key']) ;
		for fn = {file_list.name}
			key_name = fullfile(pfx_sift, dir_name, fn{1}) ;
			database(k).name   = key_name ;
			database(k).cat_id = c ;
			database(k).im_id  = i ;
			i=i+1 ;
			k=k+1;
			fprintf('Scanned ''%s''\r', key_name) ;
		end % for fn
		c=c+1 ;
  end % for dn
  fprintf('\nDatabase scanned.\n') ;

end%function
