function list=filelist(directory,ext)

remembercd = cd;
cd(directory);
dirinfo=dir('.');
list = cell(length(dirinfo),1);
count = 1;
for i=3:length(dirinfo)
    filename = dirinfo(i).name;
    currext = filename(max(regexp(filename,'[.]'))+1:end);
    if dirinfo(i).isdir==0
        if length(ext)==0 || strcmp(ext,currext)
            list{count}=filename;
            count=count+1;
        end
    end
end
list = list(1:count-1);
for i=3:length(dirinfo)
    filename = dirinfo(i).name;
    if dirinfo(i).isdir
        contents = filelist(filename,ext);
        for j=1:length(contents)
            contents{j} = strcat(filename,'\',contents{j});
        end
        list = [list; contents];
    end
end
cd(remembercd);
