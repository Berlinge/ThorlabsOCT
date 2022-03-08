function [ id1,id2,id3,id4 ] = xml2struct( test )
test = test.LVData.Cluster;

% Numbers
for i=1:size(test.DBL,2)
    id1{i,1} = string(test.DBL{1,i}.Name.Text);
    id1{i,2} = str2double(test.DBL{1,i}.Val.Text);
end
try
    ans1 = id1{find([id1{:}]=="x_steps"),2}; % Indexing / Converter
catch
end

% Boolean
for i=1:size(test.Boolean,2)
    id2{i,1} = string(test.Boolean{1,i}.Name.Text);
    id2{i,2} = str2double(test.Boolean{1,i}.Val.Text);
end
try
    ans2 = id2{find([id2{:}]=="x_steps"),2}; % Indexing / Converter
catch
end

% Array
for i=1:size(test.Array,2)
    id3{i,1} = string(test.Array{1,i}.Name.Text);
    for j=1:str2double(test.Array{1, i}.Dimsize.Text)
        array(j) = str2double(test.Array{1,i}.DBL{1,j}.Val.Text);
        id3{i,2} = array;
    end
end
try
    ans3 = id3{find([id3{:}]=="x_steps"),2}; % Indexing / Converter
    % plot(id3{find([id3{:}]=="D DC"),2})
catch
end


% Array
for i=1:size(test.String,2)
    id4{i,1} = string(test.String.Name.Text);
    id4{i,2} = string(test.String.Val.Text);
end
try
    ans4 = id4{find([id4{:}]=="Comment"),2}; % Indexing / Converter
    % plot(id3{find([id3{:}]=="D DC"),2})
catch
end
end