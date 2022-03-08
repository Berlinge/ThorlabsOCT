function [Raw,inf] = adjBrightness_gui(pathunuse,fileunuse,function_name)
% Postprocessing function
% Einlesen von dOCT png Bilder und Anpassung der Helligkeit
clc;
try
    close figBrightness figure(10)
catch
end

p = [300 300 350 120];
figBrightness = uifigure('Position',p,'Name','Brightness Adjustment'); % main figure

btn = uibutton(figBrightness,'push',...
    'Text', 'Load Images',...
    'Position',[200, 80, 100, 22],...
    'ButtonPushedFcn', @(btn,event) loadImages(btn));
btn = uibutton(figBrightness,'push',...
    'Text', 'Save Images',...
    'Position',[200, 50, 100, 22],...
    'ButtonPushedFcn', @(btn,event) saveImages(btn));

labels = uilabel(figBrightness,'Text','sigma','Position',[10 30 100 32]);
sigma = uislider(figBrightness,...
    'Position',[60, 50, 100, 22],...
    'Limits',[0 10],...
    'ValueChangedFcn',@(sld,event) plotButtonPushed(btn));
labelb = uilabel(figBrightness,'Text','b','Position',[10 80 100 32]);
b = uislider(figBrightness,...
    'Position',[60, 100, 100, 22],...
    'Limits',[0 10],...
    'ValueChangedFcn',@(sld,event) plotButtonPushed(btn));

[file,path] = uigetfile({'*.png';'*.jpeg';'*.mat';'*.*'},'MultiSelect','on');
if iscell(file)
    k=size(file,2);
    filei = file;
else
    k=1;
    filei{1,1} = file;
end
for i=1:k
    image{1,i} = imread(fullfile(path,filei{1,i}));
end
image_backup = image;
displayImages(image,k)


    function plotButtonPushed(btn)
        figure(10); clf(10)
        for i=1:k
            image{1,i} = adjBrightness(image_backup{1,i},b.Value,sigma.Value);
        end
        displayImages(image,k)
    end

    function displayImages(image,k)
        figure(10); clf(10)
        for i=1:k
            subplot(1,k,i)
            imagesc(image{1,i})
            axis equal tight
        end
    end

    function [image] = adjBrightness(image,b,sigma)
        % Brightness enhancement based on the decrease in intensity outside of the focus.
        % image:    RGB image uint(z,x,3)
        % b:        Adjustment parameters
        % sigma:    Adjustment of the confocal gating
        
        image = double(image);
        ConfocalGating = mean(mean(image,2),3);
        ConfocalGating = ConfocalGating/max(ConfocalGating);
        z = linspace(1,size(image,1),size(image,1))';
        
        %% Fit:
        [xData, yData] = prepareCurveData( z, ConfocalGating );
        
        % Set up fittype and options.
        ft = fittype( 'gauss1' );
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
        opts.Display = 'Off';
        opts.Lower = [-Inf -Inf 0];
        opts.StartPoint = [1 415 94.2303557280076];
        
        % Fit model to data.
        [fitresult, gof] = fit( xData, yData, ft, opts );
        val = coeffvalues(fitresult);
        val(3) = val(3)*sigma;
        ConfocalGating_Fit = (val(1).*exp(-((z-val(2))/val(3)).^2));
        ConfocalGating_Fit = ConfocalGating_Fit/max(ConfocalGating_Fit);
        % figure(1);plot(ConfocalGating_Fit); drawnow
        
        %%
        mask1 = repmat(ConfocalGating_Fit,1,size(image,2));
        mask2 = repmat(1-ConfocalGating_Fit,1,size(image,2));
        image = uint8(image.*mask1 + image.*b.*mask2);
    end

    function loadImages(btn)
        [file,path] = uigetfile({'*.png';'*.jpeg';'*.mat';'*.*'},'MultiSelect','on');
        if iscell(file)
            k=size(file,2);
            filei = file;
        else
            k=1;
            filei{1,1} = file;
        end
        for i=1:k
            image{1,i} = imread(fullfile(path,filei{1,i}));
        end
        image_backup = image;
        displayImages(image,k)    
    end

    function saveImages(btn)
        for i=1:k
            file_name = filei{1,i};
            imwrite(image{1,i},fullfile(path,[file_name(1:end-4),'_adjBrightness.png']))
        end
    end
Raw = 0;
inf = 0;
end