function [Raw,inf,function_name] = load_to_memory(path,file,function_name)
clc;
file = fullfile(path,file);

load(file,'inf');
try
load(file,'postprocessing');
inf.postprocessing = postprocessing;
catch
end
if strcmp(inf.path,path)~=1 % check if files were stored at any other location
    inf.path = path;
end

%%%
%  inf.SizeZ = 2048;
try
    try
        SizeZ(1) = inf.SizeZ(1);
        SizeZ(2) = inf.SizeZ(2);
    catch
        SizeZ(1) = 1;
        SizeZ(2) = inf.SizeZ;
    end
    try
        if strcmp(inf.proc.half,'off')
            SizeZ(2) = SizeZ(2)*2;
        end
    catch
    end
    %SizeZ(2) = 1024;
    if ismac
        mem.MaxPossibleArrayBytes = 1000000000;
    else
        mem = memory;
    end
    if ((SizeZ(2)-SizeZ(1)+1)*inf.SizeX*inf.SizeY*inf.SaSA*64)/8 >= mem.MaxPossibleArrayBytes % check available memory
        disp('houston we have a problem');
        dbstop at 31 in load_to_memory
        m = matfile(fullfile(file(1:end-8),[num2str(1),'.mat']));
        imagesc(abs(m.b_scan(SizeZ(1):SizeZ(2),:)))
        SizeZ(1) = 301;
        SizeZ(2) = 700;
    end
    
    if strcmp(inf.process_complex,'on')
        Raw = complex(zeros(SizeZ(2)-SizeZ(1)+1,inf.SizeX,inf.SizeY*inf.SaSA,'single'));
    elseif strcmp(inf.process_complex,'off')
        Raw = zeros(SizeZ(2)-SizeZ(1)+1,inf.SizeX,inf.SizeY*inf.SaSA,'single');
    end
    wb = waitbar(0,'Start Loading Data...');
    loadi = inf.SizeY*inf.SaSA-1;
    
    %profile on
    try
    for j=0:loadi
        m = matfile(fullfile(file(1:end-8),[num2str(j),'.mat']));
        %load(fullfile(file(1:end-8),[num2str(j),'.mat']));
        if strcmp(inf.process_complex,'on')
            Raw(:,:,j+1) = m.b_scan(SizeZ(1):SizeZ(2),:);
        elseif strcmp(inf.process_complex,'off')
            Raw(:,:,j+1) = abs(m.b_scan(SizeZ(1):SizeZ(2),:));  
        end
        waitbar(j/loadi,wb,'Loading your data');
    end
    catch
    end
    close(wb)
    
catch
    disp('No Raw.mat file found')
    Raw = 'error';
    return
end
try
    %dbclear in load_to_memory
catch
end
% save(fullfile([file(1:end-8),'_inf.mat']),'inf','-nocompression');
end