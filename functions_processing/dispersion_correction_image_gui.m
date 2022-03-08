function [output] = dispersion_correction_image_gui(inf,b_scan,Offset,Chirp,ChirpN,Dispersion,SE,infa,infb,interp_par,BtECS,FileName,File,Path,Apo,complex,spectrometer,half)

p = [300 300 550 200];
figBrightness = uifigure('Position',p,'Name','Brightness Adjustment'); % main figure

start_points = [0 0 0]./1000000;

labeld1 = uilabel(figBrightness,'Text','d1','Position',[10 130 100 32]);
d1 = uislider(figBrightness,...
    'Position',[60, 150, 300, 22],...
    'Limits',[-1000 1000],...
    'ValueChangedFcn',@(sld,event)  f_dispersion_correction_image_f(inf,b_scan,Offset,Chirp,ChirpN,Dispersion,SE,infa,infb,interp_par,BtECS,FileName,File,Path,Apo,complex,spectrometer,half,start_points));
labeld2 = uilabel(figBrightness,'Text','d2','Position',[10 80 100 32]);
d2 = uislider(figBrightness,...
    'Position',[60, 100, 300, 22],...
    'Limits',[-1000 1000],...
    'ValueChangedFcn',@(sld,event)  f_dispersion_correction_image_f(inf,b_scan,Offset,Chirp,ChirpN,Dispersion,SE,infa,infb,interp_par,BtECS,FileName,File,Path,Apo,complex,spectrometer,half,start_points));
labeld3 = uilabel(figBrightness,'Text','d3','Position',[10 30 100 32]);
d3 = uislider(figBrightness,...
    'Position',[60, 50, 300, 22],...
    'Limits',[-1000 1000],...
    'ValueChangedFcn',@(sld,event)  f_dispersion_correction_image_f(inf,b_scan,Offset,Chirp,ChirpN,Dispersion,SE,infa,infb,interp_par,BtECS,FileName,File,Path,Apo,complex,spectrometer,half,start_points));

start_points = [d1.Value d2.Value d3.Value]./1000000;

b_scan_backup = b_scan;
if strcmp(inf.rec,'1')
    [image] = rec1(1,b_scan,Offset,Chirp,ChirpN,Dispersion,SE,infa,infb,inf.interp_par,BtECS,FileName,File,Path,Apo,complex,spectrometer,half);
elseif strcmp(inf.rec,'2')
    [image] = rec2(1,b_scan,Offset,Chirp,Dispersion,infa,infb,BtECS,FileName,File,Path,Apo,complex,spectrometer,half);
end

figure(1); clf(1);
colormap gray
subplot(2,1,1)
imagesc(octa(image));
axis equal tight
disp_corr_window = drawrectangle('Label','ROI','Color',[1 1 1]);
disp_corr_window =  round(disp_corr_window.Position);

% if strcmp(spectrometer,'xposure')
%     b_scan = reshape(b_scan,[SE length(b_scan)/SE]);
%     b_scan = b_scan(:,inf.disp_corr_window(1):inf.disp_corr_window(1)+inf.disp_corr_window(3));
%     b_scan = reshape(b_scan,[1 SE*size(b_scan,2)]);
% end

% output = round(output.*1000000);

    function [output] = f_dispersion_correction_image_f(inf,b_scan,Offset,Chirp,ChirpN,Dispersion,SE,infa,infb,interp_par,BtECS,FileName,File,Path,Apo,complex,spectrometer,half,start_points)
        if strcmp(spectrometer,'xposure')
            b_scan = reshape(b_scan,[SE length(b_scan)/SE]);
            b_scan = b_scan(:,disp_corr_window(1):disp_corr_window(1)+disp_corr_window(3));
            b_scan = reshape(b_scan,[1 SE*size(b_scan,2)]);
        end
        Dispersion = [d1.Value d2.Value d3.Value];
        if strcmp(inf.rec,'1')
            [image] = rec1(1,b_scan,Offset,Chirp,ChirpN,Dispersion,SE,infa,infb,interp_par,BtECS,FileName,File,Path,Apo,complex,spectrometer,half);
        elseif strcmp(inf.rec,'2')
            [image] = rec2(1,b_scan,Offset,Chirp,Dispersion,infa,infb,BtECS,FileName,File,Path,Apo,complex,spectrometer,half);
        end
        figure(1);
        subplot(2,1,2)
        imagesc(octa(image(disp_corr_window(2):disp_corr_window(2)+disp_corr_window(4),:)))
        axis equal tight
        title(num2str(round(Dispersion)))
        if strcmp(spectrometer,'xposure')
            output = -entropy(double(octa(image)));
            %             output = -max(mean(image,2));
            subplot(2,1,1)
            title(output)
        else
            output = -entropy(double((image(inf.disp_corr_window(2):inf.disp_corr_window(2)+inf.disp_corr_window(4),inf.disp_corr_window(1):inf.disp_corr_window(1)+inf.disp_corr_window(3)))));
            image = octa(image)-mean(mean(octa(image)));
            rectangle('Position', inf.disp_corr_window ); %// draw rectangle on image
            subplot(2,2,3:4)
            plot(mean(octa(image(:,round((inf.disp_corr_window(1)+inf.disp_corr_window(3))/2))),2))
        end
    end
end