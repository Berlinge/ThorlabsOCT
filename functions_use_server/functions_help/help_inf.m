function [inf] = help_inf(inf)
%HELP_ING Summary of this function goes here
%   Detailed explanation goes here
inf.l = 3000; % Length for processing / Image size; should  not be touched
inf.satisfy = true; % Dispersion preset
inf.electrons = 7200; % Binary to electron for dB value
inf.only_information = 0;
v = squeeze(struct2cell(inf.version));
inf.x_pixel_start = 1;
inf.y_pixel_start = 1;

%%% Check toolboxes and options
if strcmp(inf.use_gpu,'on') && strcmp(inf.interp_par,'spline')
    inf.interp_par = 'linear';
    inf.use_gpu = 'off';
    disp('inf.interp_par was set to linear, spline is not supported')
end

if sum(any(strcmp(v,'Parallel Computing Toolbox')))==0
    inf.use_gpu = 'off';
    disp('No GPU device was found or Mathworks toolbox is not installed');
end

if sum(any(strcmp(v,'Optimization Toolbox')))==0 && sum(any(strcmp(v,'Global Optimization Toolbox')))==0
    inf.disp_corr_image = 'off';
    disp('Optimization Toolbox is not installed');
end

%%% Additional disperions
if strcmp(inf.disp_corr_image,'on_extended')
    
    if strcmp(inf.disp_corr_image,'on') || strcmp(inf.disp_corr_image,'on_extended') && length(inf.file)>1
        [index,~] = listdlg('PromptString',{'Select a file for dispersion correction.',...
            'Only one file can be selected at a time.',''},...
            'SelectionMode','single','ListString',inf.file);
        %%% old_begin
        %     prompt = {'Which File to start?'};
        %     dlgtitle = 'Input';
        %     %dims = [1 size(inf.file,2)];
        %     %definput = {'1'};
        %     answer = inputdlg(prompt,dlgtitle);
        %     input = str2double(answer{1,1});
        % %     if input>dims(2)
        % %         input = dims(2);
        % %     end
        %%% old_end
        inf.file([1 index]) = inf.file([index 1]);
    end
    
    answer = questdlg('Use Dispersion from file?','Yes','No');
    switch answer
        case 'Yes'
            inf.disp_corr_use_saved = 'on';
        case 'No'
            inf.disp_corr_use_saved = 'off';
        otherwise
            inf.disp_corr_use_saved = 'off';
    end
    
    answer = questdlg('Use Dispersion for every file','Yes','No');
    switch answer
        case 'Yes'
            inf.disp_corr_every_image = 'off';  % "on" or "off"
        case 'No'
            inf.disp_corr_every_image = 'on';  % "on" or "off"
        otherwise
            inf.disp_corr_every_image = 'off';  % "on" or "off"
    end
    
    answer = questdlg('Use Dispersion - User input?','Yes','No');
    switch answer
        case 'Yes'
            inf.dispersion_use = inputdlg('Enter separated numbers for dispersion:','Dispersion vector', [1 50]);
            inf.dispersion_use = str2double(inf.dispersion_use{1});
        case 'No'
            
        otherwise
    end
else
    inf.disp_corr_use_saved = 'off';
    disp_corr_every_image = 'off';
end

%%% Faktor zur Korrektur 
if strcmp(inf.disp_corr_algorithm,'fminsearch')
    inf.disp_hlp_f = 1000000;
elseif strcmp(inf.disp_corr_algorithm,'patternsearch')
    inf.disp_hlp_f = 1;
end

inf.t_total = tic;
end

