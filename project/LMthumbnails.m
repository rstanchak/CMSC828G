function LMThumbnails(db, image_dir, output_dir, maxdim)
% scan images in the database and scale them 

disp('Creating thumbnail directories...');
if ~exist(output_dir, 'dir'),
	mkdir(output_dir);
end
for i=1:length(db)
	anno_folder = [output_dir, '/', db(i).annotation.folder];
	if ~exist(anno_folder, 'dir');
		mkdir(anno_folder);
	end
end

disp('Creating thumbnails')
for i=1:length(db)
	anno = db(i).annotation;
	out_fname = [output_dir, '/', anno.folder, '/', anno.filename];
	image_fname = [image_dir, '/', anno.folder, '/', anno.filename];
	sys = sprintf('convert "%s" -resize %dx%d "%s"', image_fname, maxdim, maxdim, out_fname);
%	disp(sys);
	if system(sys) > 0,
		error('Error resizing image: ', sys)
	end
end
