function [Raw,inf] = load_to_memory_wait(path,file,function_name)
% Loads selected file into workspace
% and waits
[Raw,inf,~] = load_to_memory(path,file,dbstack);

try
    dbstop at 12 in load_to_memory_wait
    [Raw,inf] = load_to_memory(file); % PRaw is only pointer to mat-File
    if length(inf.SizeZ)>1
        inf.SizeZ = inf.SizeZ(2)-inf.SizeZ(1)+1;
    end
catch
end
disp('Go on')
end