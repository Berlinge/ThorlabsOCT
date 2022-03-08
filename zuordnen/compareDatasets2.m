%% Extract Comment
for i=2:size(Set,1)
    Set{i,4} = Set{i,2}.Comment;
end
%% Calc Std
for i=2:size(Set,1)
    Set{i,5} = std(abs(Set{i,3}),0,3);
end
%% Register Data
for i=2:size(Set,1)
    Set{i,6} = registration_b_scans(Set{i,3});
end
%% Calc Std for Reg Data
for i=2:size(Set,1)
    Set{i,7} = std(Set{i,6},0,3);
end
%% Extract Data
clearvars s
clc
k = 1;
spalte = 5;
for i=2:size(Set,1)
    if isempty(Set{i,spalte})~= 1
        s(:,:,k) = Set{i,spalte};
        k = k+1;
    end
end
%implay((s+1))

%%
clc
o = registration_b_scans_floating(medfilt3(s,[1 1 1]));
implay(o)
implay(log(o+1))