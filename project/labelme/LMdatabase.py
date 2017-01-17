def [D, XML] = LMdatabase(varargin)
#def [database, XML] = LMdatabase(HOMEANNOTATIONS, folderlist)
#
# This line reads the entire database into a Matlab struct.
#
# Different ways of calling this def
# database = LMdatabase(HOMEANNOTATIONS); # reads only annotated images
# database = LMdatabase(HOMEANNOTATIONS, HOMEIMAGES); # reads all images
# database = LMdatabase(HOMEANNOTATIONS, folderlist);
# database = LMdatabase(HOMEANNOTATIONS, HOMEIMAGES, folderlist);
#
# Reads all the annotations.
# It creates a struct 'almost' equivalent to what you would get if you concatenate
# first all the xml files, then you add at the beggining the tag <D> and at the end </D> 
# and then use loadXML.m
#
# You do not need to download the database. The defs that read the
# images and the annotation files can be refered to the online tool. For
# instance, you can run the next command:
#
# HOMEANNOTATIONS = 'http://labelme.csail.mit.edu/Annotations'
# D = LMdatabase(HOMEANNOTATIONS);
#
# This will create the database struct without needing to download the
# database. It might be slower than having a local copy. 
#
#######################################################################
# LabelMe, the open annotation tool
# Contribute to the database by labeling objects using the annotation tool.
# http://labelme.csail.mit.edu/
# 
# CSAIL, MIT
# 2006
#######################################################################

# This def removes all the deleted polygons. If you want to read them
# too, you have to comment line 132.

Folder = [];

# Parse input arguments and read list of folders
N = nargin;
HOMEANNOTATIONS = varargin{1};
if N==3
    HOMEIMAGES = varargin{2};
else
    HOMEIMAGES = '';
end

if iscell(varargin{N})
    folderlist = varargin{N}

    Nfolders = length(folderlist);
    for i = 1:Nfolders
        Folder{i} = folderlist{i};
    end
else
    if N==2
        HOMEIMAGES = varargin{2};
    end
    if ~strcmp(HOMEANNOTATIONS(1:5), 'http:');
        folders = genpath(HOMEANNOTATIONS);
        h = [findstr(folders,  pathsep)];
        h = [0 h];
        Nfolders = length(h)-1
        for i = 1:Nfolders
            tmp = folders(h(i)+1:h(i+1)-1);
            tmp = strrep(tmp, HOMEANNOTATIONS, ''); tmp = tmp(2:end);
            Folder{i} = tmp;
        end
    else
        files = urldir(HOMEANNOTATIONS);
        Folder = {files(2:end).name}; # the first item is the main path name
        Nfolders = length(Folder);
        #for i = 1:Nfolders
        #    Folder{i} = Folder{i};
        #end
    end
end

# Open figure that visualizes the file and folder counter
Hfig = plotbar;

# Loop on folders
D = []; n = 0; nPolygons = 0;
if nargout == 2; XML = ['<database>']; end
for f = 1:Nfolders
    folder = Folder{f};
    disp(sprintf('#d/#d, #s', f, Nfolders, folder))
    filesImages = [];
    
    if ~strcmp(HOMEANNOTATIONS(1:5), 'http:');
        filesAnnotations = dir(fullfile(HOMEANNOTATIONS, folder, '*.xml'));
        if length(HOMEIMAGES)>0
            filesImages = dir(fullfile(HOMEIMAGES, folder, '*.jpg'));
        end
    else
        filesAnnotations = urlxmldir(fullfile(HOMEANNOTATIONS, folder));
        if length(HOMEIMAGES)>0
            filesImages = urldir(fullfile(HOMEIMAGES, folder), 'img');
        end
    end
    
    #keyboard
    
    if length(HOMEIMAGES)>0
        N = length(filesImages);
    else
        N = length(filesAnnotations);
    end
    
    #fprintf(1, '#d ', N)
    emptyAnnotationFiles = 0;
    labeledImages = 0;
    for i = 1:N
        clear v
        if length(HOMEIMAGES)>0
            filename = fullfile(HOMEIMAGES, folder, filesImages(i).name);
            filenameanno = strrep(filesImages(i).name, '.jpg', '.xml');
            if length(filesAnnotations)>0
                J = strmatch(filenameanno, {filesAnnotations(:).name});
            else
                J = [];
            end
            if length(J)==1
                if filesAnnotations(J).bytes > 0
                    [v, xml] = loadXML(fullfile(HOMEANNOTATIONS, folder, filenameanno));
                    labeledImages = labeledImages+1;
                else
                    #disp(sprintf('file #s is empty', filenameanno))
                    emptyAnnotationFiles = emptyAnnotationFiles+1;
                    v.annotation.folder = folder;
                    v.annotation.filename = filesImages(i).name;
                end
            else
                #disp(sprintf('image #s has no annotation', filename))
                v.annotation.folder = folder;
                v.annotation.filename = filesImages(i).name;
            end
        else
            filename = fullfile(HOMEANNOTATIONS, folder, filesAnnotations(i).name);
            if filesAnnotations(i).bytes > 0
                [v, xml] = loadXML(filename);
                labeledImages = labeledImages+1;
           else
                disp(sprintf('file #s is empty', filename))
                v.annotation.folder = folder;
                v.annotation.filename = strrep(filesAnnotations(i).name, '.xml', '.jpg');
            end
        end
        
        n = n+1;

        # Add folder and file name to the scene description
        if ~isfield(v.annotation, 'scenedescription')
            v.annotation.scenedescription = [v.annotation.folder ' ' v.annotation.filename];
        end
        
        # Add object ids
        if isfield(v.annotation, 'object')
            #if ~isfield(v.annotation.object, 'id')
            for m = 1:length(v.annotation.object)
                v.annotation.object(m).id = m;
            end
            #end
        end
        
        # store annotation into the database
        D(n).annotation = v.annotation;

        if nargout == 2
            XML = [XML xml];
        end

        if mod(i,10)==1
            plotbar(Hfig,f,Nfolders,i,N);
        end
    end
    disp(sprintf(' Total images:#d, annotation files:#d (with #d empty xml files)', N, labeledImages, emptyAnnotationFiles))
end

if nargout == 2; XML = [XML '</database>']; end

# Remove all the deleted objects. Comment this line if you want to see all
# the deleted files.
D = LMvalidobjects(D);

# Add view point into the object name
D = addviewpoint(D);

# Add image size field
# D = addimagesize(D);

# # Summary database;
#[names, counts] = LMobjectnames(D);
#disp('-----------------')
#disp(sprintf('LabelMe Database summary:\n Total of #d annotated images. \n There are #d polygons assigned to #d different object names', length(D), sum(counts), length(names)))
disp(sprintf('LabelMe Database summary:\n Total of #d annotated images.', length(D)))
#disp('-----------------')
# 
close(Hfig)

#######################################################################################
def urlxmldir(page):

    files = []; Folder = [];
    page = strrep(page, '\\', '/');

    folders = urlread(page);
    folders = folders(1:length(folders));
    j1 = findstr(lower(folders), '<a href="');
    j2 = findstr(lower(folders), '</a>');
    Nfolders = length(j1);

    fn = 0;
    for f in  xrange(Nfolders):
        tmp = folders(j1(f)+9:j2(f)-1);
        fin = findstr(tmp, '"');
        if length(findstr(tmp(1:fin(end)-1), 'xml'))>0
            fn = fn+1;
            Folder{fn} = tmp(1:fin(end)-1);

    for f = xrange(length(Folder)):
        files(f).name = Folder{f};
        files(f).bytes = 1;
    return files
