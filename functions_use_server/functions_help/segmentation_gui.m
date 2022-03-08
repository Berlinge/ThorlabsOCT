function [Vol_res] = segmentation_gui(Raw)
% Experimental
% Einlesen eines Datensatzes und manuelle Segmentierung der
% Bildfeldkrümmung; angepasster Datensatz wird abgespeichert
if length(size(Raw)) == 3
elseif length(size(Raw))==4 % dann rgb Volumen

else
    disp('Sth is not right in segmentation gui')
end
%%
% figure(1), clf(1)
% imagesc(octa(Raw(:,:,1)))
%%
% Raw = Raw(351:750,:,:);
%%
% for x=1:1024
%     for y=1:1024
%         Vol_test = interp1(linspace(1,size(Raw,1),size(Raw,1)),Raw,linspace(1,size(Raw,1),size(Raw,1)*10),'linear');
%     end
% end
%%
figure(1), clf(1)
satisfy = true;
Vol_res = Raw;
while satisfy==true
    imagesc(octa(Raw(:,:,1,1)))
    hold on
    for i=1:5
        test = round(ginput(1));
        plot(test(1),test(2),'rx');
        xylist(i,:) = test;
        pause(0.01)
    end
    [xData, yData] = prepareCurveData( xylist(:,1), xylist(:,2) );
    ft = fittype( 'poly2' );
    [fitresult, gof] = fit( xData, yData, ft );
    plot(linspace(1,size(Raw,2),size(Raw,2)),fitresult(linspace(1,size(Raw,2),size(Raw,2))));
    hold off
    answer = questdlg('ok?','Yes','No');
    switch answer
        case 'Yes'
            satisfy = false;
        case 'No'
            satisfy = true;
    end
end
test = round(fitresult(linspace(1,512,512)));

for i=1:size(Raw,2)
    Vol_res(:,i,:,:) = circshift(squeeze(Raw(:,i,:,:)),-round(fitresult(i))+100,1);
end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1), clf(1)
satisfy = true;
while satisfy==true
    
    imagesc(octa(Vol_res(:,1,:,1)))
    hold on
    for i=1:5
        test = round(ginput(1));
        plot(test(1),test(2),'rx');
        xylist(i,:) = test;
        pause(0.01)
    end
    [xData, yData] = prepareCurveData( xylist(:,1), xylist(:,2) );
    ft = fittype('poly2');
    [fitresult, gof] = fit( xData, yData, ft );
    plot(linspace(1,size(Raw,3),size(Raw,3)),fitresult(linspace(1,size(Raw,3),size(Raw,3))));
    hold off
    answer = questdlg('ok?','Yes','No');
    switch answer
        case 'Yes'
            satisfy = false;
        case 'No'
            satisfy = true;
    end
end

for i=1:size(Raw,3)
    Vol_res(:,:,i,:) = circshift(Vol_res(:,:,i,:),-round(fitresult(i))+100,1);
end


% %%
% Vol_res = interp1(linspace(1,size(Vol_res,1),size(Vol_res,1)),Raw,linspace(1,size(Raw,1),400),'linear');
% %%
end