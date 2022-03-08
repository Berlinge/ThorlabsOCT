function main_gui
% by Michael Münter - 15.03.2020
%
clearvars; clc; fclose('all'); close all; close all hidden;

p = [100 100 1200 520];
s = [200 200];
f = uifigure('Position',p,'Name','Pipeline'); % main figure
batch = 'off';

%%% Init
fileID = fopen('main_gui.txt','r');
init = fscanf(fileID,'%s');
fclose(fileID);

version = str2double(extractBefore(extractAfter(init,'version="'),'"'));
rec_path = string(extractBefore(extractAfter(init,'rec_path="'),'"'));
server_path = string(extractBefore(extractAfter(init,'server_path="'),'"'));
c = cd;
c = c(1:end-3);
local_path = string(extractBefore(extractAfter(init,'local_path="'),'"'));
local_path = fullfile(c,local_path);
disp(version)

addpath(rec_path);
addpath(local_path);

try
    addpath(genpath(server_path));
catch
end

fct_path_help_l = struct2cell(dir(strcat(local_path,'*.m')));
fct_path_help_s = struct2cell(dir(strcat(server_path,'*.m')));
fct_path =[fct_path_help_l(1,:),fct_path_help_s(1,:)];
t = table();
infi = struct();

% Processing Options for xposure & oct
inf = main_init();

btn_select = uibutton(f,'push',...
    'Text','Select Folder',...
    'Position',[p(1)+s(1)-250, p(2)+s(2)+150, 100, 22],...
    'ButtonPushedFcn', @(btn,event) my_fileselect());
btn_run = uibutton(f,'push',...
    'Text','Start processing',...
    'Position',[p(1)+s(1)+175, p(2)+s(2)+150, 100, 22],...
    'ButtonPushedFcn', @(btn,event) f_process());
btn_run_p = uibutton(f,'push',...
    'Text','Start function',...
    'Position',[p(1)+s(1)+570, p(2)+s(2)+150, 100, 22],...
    'ButtonPushedFcn', @(btn,event) f_process_function_use_proc());
btn_run_batch = uibutton(f,'push',...
    'Text','Start Batch',...
    'Position',[p(1)+s(1)+680, p(2)+s(2)+150, 100, 22],...
    'ButtonPushedFcn', @(btn,event) f_process_batch());
btn_delete = uibutton(f,'push',...
    'Text','Delete',...
    'Position',[p(1)+s(1)+790, p(2)+s(2)+150, 100, 22],...
    'ButtonPushedFcn', @(btn,event) f_delete());
btn_refresh = uibutton(f,'push',...
    'Text','Refresh',...
    'Position',[p(1)+s(1)-130, p(2)+s(2)+150, 100, 22],...
    'ButtonPushedFcn', @(btn,event) f_refresh());

sw_interp = uiswitch(f,...
    'Items',{' ','exp'},...
    'Position',[p(1)+s(1)+70 p(2)+s(2)+170 20 45],...
    'Value',' ',...
    'Tooltip','Stay left, if you dont know',...
    'ValueChangedFcn',@switchMoved);
sw_complex = uiswitch(f,...
    'Items',{'abs','complex'},...
    'Position',[p(1)+s(1)+70 p(2)+s(2)+155 20 45],...
    'Value','abs',...
    'Tooltip','abs: Processing is faster and take up less storage',...
    'ValueChangedFcn',@switchMoved);
sw_disp = uiswitch(f,...
    'Items',{'ind','saved'},...
    'Position',[p(1)+s(1)+70 p(2)+s(2)+185 20 45],...
    'Value','saved',...
    'Tooltip','Individuell dispersions or saved within OCT file',...
    'ValueChangedFcn',@switchMoved);
sw_disp = uiswitch(f,...
    'Items',{'half','full'},...
    'Position',[p(1)+s(1)+70 p(2)+s(2)+200 20 45],...
    'Value','half',...
    'Tooltip','Full spectrum if extended',...
    'ValueChangedFcn',@switchMoved);
uit = uitable(f,'Data',t,...
    'Position',[p(1)+s(1)+50, p(2)+s(2)-280, 250, 420]);
uit_p = uitable(f,'Data',t,...
    'Position',[p(1)+s(1)+640, p(2)+s(2)-280, 250, 420]);
ef1 = uieditfield(f,...
    'text',...
    'Position',[p(1)+s(1)-260 p(2)+s(2)-250 260 22],...
    'Value',' ');
edt = uieditfield(f,...
    'text',...
    'Value','off',...
    'Position',[p(1)+s(1)+150 p(2)+s(2)+180 150 20]);
edt_path = uieditfield(f,...
    'text',...
    'Value','Path',...
    'Position',[p(1)+s(1)-250 p(2)+s(2)+180 250 20]);
edt_fd = uitextarea(f,...
    'Value',{'functions description'},...
    'Position',[p(1)+s(1)+330 p(2)+s(2)-260 300 60]);
lbx = uilistbox(f,...
    'Tag','FileNames',...
    'Position',[p(1)+s(1)-260 p(2)+s(2)-190 300 300],...
    'Items',{''},...
    'Multiselect','on',...
    'ValueChangedFcn', @(src,event) f_preview());
lbx_p = uilistbox(f,...
    'Tag','FileNames',...
    'Position',[p(1)+s(1)+330 p(2)+s(2)-190 300 300],...
    'Items',{''},...
    'Multiselect','on',...
    'ValueChangedFcn', @(src,event) f_preview_p());
lmp = uilamp(f,...
    'Position',[p(1)+s(1)+10 p(2)+s(2)-250 20 20],...
    'Color','green');
dd = uidropdown(f,...
    'Position',[p(1)+s(1)+350 p(2)+s(2)+150 200 20],...
    'ValueChangedFcn', @(src,event) f_preview_dc(),...
    'Items',cellstr(fct_path));


IFC = uicheckbox(f, 'Text','Image Field Correction',...
                  'Value', 0,...
                  'Position',[p(1)+s(1)+360 p(2)+s(2)+180 150 15]);
IR = uicheckbox(f, 'Text','Image Registration',...
                  'Value', 0,...
                  'Position',[p(1)+s(1)+360 p(2)+s(2)+200 150 15]);

edt_fd.Value = help(dd.Value);

    function my_fileselect()
        try
            inf.path = uigetdir();
            if isequal(inf.path, 0)
                inf.path = edt_path.Value;
            end
            edt_path.Value = inf.path;
        catch
            ef1.Value = 'No Folder selected, or not oct files available';
        end
        f_refresh()
    end

    function [] = switchMoved(src,~)
        switch src.Value
            case ' '
                inf.rec = '1';
            case 'exp'
                inf.rec = '2';
            case 'complex'
                inf.process_complex = 'on';
            case 'abs'
                inf.process_complex = 'off';
            case 'ind'
                edt.Value = 'Calc or put dispersion here';
            case 'saved'
                edt.Value = 'off';
            case 'half'
                inf.proc.half = 'on';
            case 'full'
                inf.proc.half = 'off';
        end
        
    end

    function [] = f_preview_dc()
        edt_fd.Value = help(dd.Value);
    end

    function [] =  f_delete()
        lbx_p.Value
        for i=1:length(lbx_p.Value)
            File = lbx_p.Value{i};
            try
                delete(fullfile(inf.path,File(1:end-8),'*.mat'));
            catch
            end
            try
                delete(fullfile(inf.path,File));
            catch
                disp('Could not delete file')
            end
        end
        f_refresh()
    end

    function [] = f_preview()
        try
            inf.disp = 'off';
            inf.extract_info = 'on';
            if length(lbx.Value)==1
                inf.file = lbx.Value;
                inf.i = 1;
                if contains(inf.file{1,inf.i},'.oct')
                    [inf_preview,~] = thorlabs_oct(inf);
                elseif contains(inf.file{1,inf.i},'.raw')
                    [inf_preview,~] = xposure_raw(inf);
                end
                t_input{1,1} = 'Size (zxy) [px]';
                t_input{1,2} = [num2str(inf_preview.SizeZ),' ',num2str(inf_preview.SizeX),' ',num2str(inf_preview.SizeY)];
                t_input{2,1} = 'Size (zxy) (mm)';
                t_input{2,2} = [num2str(inf_preview.SizeZ_real),' ',num2str(inf_preview.SizeX_real),' ',num2str(inf_preview.SizeY_real)];
                t_input{3,1} = 'Center (xy) (mm)';
                t_input{3,2} = [num2str(inf_preview.CenterX),' ',num2str(inf_preview.CenterY)];
                t_input{4,1} = 'Averaging Fast Axis';
                t_input{4,2} = inf_preview.SaFA;
                t_input{5,1} = 'Averaging Slow Axis';
                t_input{5,2} = inf_preview.SaSA;
                t_input{6,1} = 'CameraLineRate';
                t_input{6,2} = inf_preview.CameraLineRate;
                t_input{7,1} = 'Comment';
                t_input{7,2} = inf_preview.Comment;
                t_input = cell2table(t_input);
                t_input.Properties.VariableNames = {'Property ','Value'};
                uit.Data = t_input;
                ef1.Value = ' ';
            else
                d = length(lbx.Value);
                ef1.Value = [num2str(d),' files selected; select only one file for data view'];
                uit.Data = table();
            end
            inf.extract_info = 'off';
        catch
            ef1.Value = 'Could not load inf';
            uit.Data = table();
        end
    end

    function [] = f_preview_p()
        try
            if length(lbx_p.Value)==1
                infi = load(fullfile(inf.path,strcat(lbx_p.Value{1}(1:end-4),'.mat')),'inf');
                t_input{1,1} = 'Complex';
                t_input{1,2} = infi.inf.process_complex;
                t_input{2,1} = 'Interolation method';
                t_input{2,2} = infi.inf.interp_par;
                t_input{3,1} = 'Size (zxy) [px]';
                t_input{3,2} = [num2str(infi.inf.SizeZ),' ',num2str(infi.inf.SizeX),' ',num2str(infi.inf.SizeY)];
                t_input{4,1} = 'Size (zxy) (mm)';
                t_input{4,2} = [num2str(infi.inf.SizeZ_real),' ',num2str(infi.inf.SizeX_real),' ',num2str(infi.inf.SizeY_real)];
                t_input{5,1} = 'Center (xy) (mm)';
                t_input{5,2} = [num2str(infi.inf.CenterX),' ',num2str(infi.inf.CenterY)];
                t_input{6,1} = 'Averaging Slow Axis';
                t_input{6,2} = infi.inf.SaSA;
                t_input{7,1} = 'CameraLineRate';
                t_input{7,2} = infi.inf.CameraLineRate;
                t_input{8,1} = 'Comment';
                t_input{8,2} = infi.inf.Comment;
                t_input{9,1} = 'dOCT b_scan';
                t_input{9,2} = ' ';
                t_input{10,1} = 'dOCT frequency [Hz]';
                t_input{10,2} = 1/((infi.inf.SizeX + 0.002*infi.inf.CameraLineRate)/infi.inf.CameraLineRate);
                t_input{11,1} = 'dOCT time [s]';
                t_input{11,2} = ((infi.inf.SizeX + 0.002*infi.inf.CameraLineRate)/infi.inf.CameraLineRate)*infi.inf.SaSA;
                t_input{12,1} = 'dOCT time measure [s]';
                t_input{12,2} = ((infi.inf.SizeX + 0.002*infi.inf.CameraLineRate)/infi.inf.CameraLineRate)*infi.inf.SizeY*infi.inf.SaSA;
                t_input{13,1} = 'Dispersion';
                t_input{13,2} = (num2str(infi.inf.Dispersion));
                t_input{14,1} = 'Rekonstruction Version:';
                t_input{14,2} = ((infi.inf.rec));
                t_input = cell2table(t_input);
                t_input.Properties.VariableNames = {'Property ','Value'};
                uit_p.Data = t_input;
            else
                
            end
        catch
            disp('Values from inf could not be loaded correctly')
        end
    end

    function [] = f_process()
        btn_run.Enable = 'off';
        btn_run_batch.Enable = 'off';
        btn_run_p.Enable = 'off';
        inf.extract_info = 'off';
        lmp.Color = 'red';
        pause(0.01);
        inf.file = lbx.Value;
        %[inf] = help_inf(inf);
        inf.disp = edt.Value;
        ef1.Value = ['Start Processing 0/',num2str(length(inf.file))];
        for i=1:length(inf.file)
            inf.i = i;
            if strcmp(inf.file{i}(end-2:end),'raw')
                [inf,~] = xposure_raw(inf);
            elseif strcmp(inf.file{i}(end-2:end),'oct')
                [inf,~] = thorlabs_oct(inf);
            end
            save(fullfile(inf.path,[inf.file{inf.i}(1:end-4),'_inf.mat']),'inf');
            ef1.Value = ['Processed ',num2str(i),'/',num2str(length(inf.file))];
        end
        lmp.Color = 'green';
        f_refresh()
    end

    function [] = f_process_function_use_proc()
        postprocessing.image_field_correction = IFC.Value;
        postprocessing.image_registration = IR.Value;
        btn_run.Enable = 'off';
        btn_run_batch.Enable = 'off';
        btn_run_p.Enable = 'off';
        pause(0.01);
        if strcmp(batch,'on')
            inf.file = strrep(lbx.Value,'.oct','_inf.mat');
        else
            inf.file = lbx_p.Value;           
        end
        if strcmp(dd.Value(1:end-2),'adjBrightness_gui')
            i = 1;
            inf.file{1,1} = 'empty';
            feval(convertCharsToStrings(dd.Value(1:end-2)),inf.path,inf.file{1,i},dd.Value(1:end-2));
            return
        end
        for i=1:length(inf.file)
            inf.i = i;
            try 
            save(fullfile(inf.path,inf.file{1,i}),'postprocessing','-append'); % add variables for postprocessing
            catch
            end
            feval(convertCharsToStrings(dd.Value(1:end-2)),inf.path,inf.file{1,i},dd.Value(1:end-2));
        end
        f_refresh()
    end

    function [] = f_process_batch()
        batch = 'on';
        f_process()
        f_process_function_use_proc()
        f_refresh();
        batch = 'off';
    end

    function [] = f_refresh()
        btn_run.Enable = 'on';
        btn_run_batch.Enable = 'on';
        btn_run_p.Enable = 'on';
        fct_path_help_l = struct2cell(dir(strcat(local_path,'*.m')));
        fct_path_help_s = struct2cell(dir(strcat(server_path,'*.m')));
        fct_path =[fct_path_help_l(1,:),fct_path_help_s(1,:)];
        dd.Items = cellstr(fct_path);
        Files = [dir(fullfile([inf.path],'*.raw'));dir(fullfile([inf.path],'*.oct'))];
        Files = struct2cell(Files);
        Files = Files(1,:);
        lbx.Items = Files;
        Filesi = dir(fullfile([inf.path],'*.mat'));
        Filesi = struct2cell(Filesi);
        Filesi = Filesi(1,:);
        lbx_p.Items = Filesi;
        f_preview_p();
        f_preview();
    end
end