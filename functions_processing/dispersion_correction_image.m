function [output] = dispersion_correction_image(inf,b_scan,Offset,Chirp,ChirpN,Dispersion,SE,infa,infb,interp_par,BtECS,FileName,File,Path,Apo,complex,spectrometer,half)
b_scan_backup = b_scan;
if strcmp(inf.rec,'1')
    [image] = rec1(1,b_scan,Offset,Chirp,ChirpN,Dispersion,SE,infa,infb,inf.interp_par,BtECS,FileName,File,Path,Apo,complex,spectrometer,half);
elseif strcmp(inf.rec,'2')
    [image] = rec2(1,b_scan,Offset,Chirp,Dispersion,infa,infb,BtECS,FileName,File,Path,Apo,complex,spectrometer,half);
end
figure(1); clf(1);
colormap gray
subplot(2,2,1)
imagesc(octa(image));
inf.disp_corr_window = drawrectangle('Label','ROI','Color',[1 1 1]);
inf.disp_corr_window =  round(inf.disp_corr_window.Position);
start_points = [0 0 0]./1000000;
if strcmp(spectrometer,'xposure')
    b_scan = reshape(b_scan,[SE length(b_scan)/SE]);
    b_scan = b_scan(:,inf.disp_corr_window(1):inf.disp_corr_window(1)+inf.disp_corr_window(3));
    b_scan = reshape(b_scan,[1 SE*size(b_scan,2)]);
end
func = @(start_points)  f_dispersion_correction_image(inf,b_scan,Offset,Chirp,ChirpN,Dispersion,SE,infa,infb,interp_par,BtECS,FileName,File,Path,Apo,complex,spectrometer,half,start_points);
for i=1:1
    %     if strcmp(inf.disp_corr_algorithm,'fminsearch')
    output = fminsearch(func,start_points);
    %     elseif strcmp(inf.disp_corr_algorithm,'patternsearch')
    %         options = optimoptions('patternsearch','UseParallel',false,'InitialMeshSize',100,'FunctionTolerance',5,'StepTolerance',5,'MeshTolerance',5);
    %         output = patternsearch(func,start_points,[],[],[],[],[],[],[],options);
    %     end
    start_points = [0 output];
end
output = round(output.*1000000);
answer = questdlg('Dispersion ok?','Yes','No');
switch answer
    case 'Yes'
        inf.satisfy = false;
        answer_save = questdlg('Dispersion save?','Yes','No');
        switch answer_save
            case 'Yes'
                % selpath = uigetdir;
                selpath = inf.path;
                %                save(fullfile(selpath,'disp.mat'),'output');
                T = table(output);
                T.Properties.VariableNames{1} = 'Dispersion';
                writetable(T,fullfile(inf.path,'dispersion.txt'));
                disp(['Dispersion saved to: ',selpath])
            case 'No'
                disp('Dispersion was not saved')
            otherwise
                output = 'Dispersion return';
                return
        end
    case 'No'
        dispersion_correction_image(inf,b_scan_backup,Offset,Chirp,ChirpN,Dispersion,SE,infa,infb,interp_par,BtECS,FileName,File,Path,Apo,complex,spectrometer,half)
    otherwise
        output = 'Dispersion return';
        return
end
end

function [output] = f_dispersion_correction_image(inf,b_scan,Offset,Chirp,ChirpN,Dispersion,SE,infa,infb,interp_par,BtECS,FileName,File,Path,Apo,complex,spectrometer,half,start_points)
Dispersion = start_points.*1000000;
interp_par = 'spline';
if strcmp(inf.rec,'1')
    [image] = rec1(1,b_scan,Offset,Chirp,ChirpN,Dispersion,SE,infa,infb,interp_par,BtECS,FileName,File,Path,Apo,complex,spectrometer,half);
elseif strcmp(inf.rec,'2')
    [image] = rec2(1,b_scan,Offset,Chirp,Dispersion,infa,infb,BtECS,FileName,File,Path,Apo,complex,spectrometer,half);
end
figure(1);
subplot(2,2,2)
imagesc(octa(image))
% axis equal tight
title(num2str(round(Dispersion)))
% image = octa(image);

if strcmp(spectrometer,'xposure')
    image = double((image(inf.disp_corr_window(2):inf.disp_corr_window(2)+inf.disp_corr_window(4),:)));
%     output = -entropy(double(octa(image)));
    output = -entropy(octa(image));
    subplot(2,2,3:4)
    title(output*1000)

else
    output = -entropy(double((image(inf.disp_corr_window(2):inf.disp_corr_window(2)+inf.disp_corr_window(4),inf.disp_corr_window(1):inf.disp_corr_window(1)+inf.disp_corr_window(3)))));
    image = octa(image)-mean(mean(octa(image)));
    rectangle('Position', inf.disp_corr_window ); %// draw rectangle on image
    subplot(2,2,3:4)
    plot(mean(octa(image(:,round((inf.disp_corr_window(1)+inf.disp_corr_window(3))/2))),2))
end
% if strcmp(inf.disp_corr_image_metric,'peak')
%     a_scan_reg = image(inf.disp_corr_window(2):inf.disp_corr_window(2)+inf.disp_corr_window(4),inf.disp_corr_window(1):inf.disp_corr_window(1)+inf.disp_corr_window(3));
%     output = -max(mean(abs(a_scan_reg),2));
%     output = -max(mean(octa(a_scan_reg),2));
% elseif strcmp(inf.disp_corr_image_metric,'entropy')
% image = octa(image)-mean(mean(octa(image)));

% output = -max(mean(double((image(inf.disp_corr_window(2):inf.disp_corr_window(2)+inf.disp_corr_window(4),inf.disp_corr_window(1):inf.disp_corr_window(1)+inf.disp_corr_window(3)))),2));

% else
%     disp('No metric has been selected')
% end
end