roi_x = 336:346
roi_y = 76:86

roi_c_x = 324:336
roi_c_y = 58:72
roi_c_x_2 = 344:354
roi_c_y_2 = 338:348

roi_n_x = 439:447
roi_n_y = 380:389

roi_n_x_2 = 354:364
roi_n_y_2 = 322:334

z = 150
enface = OCT(z,:,:,:);
figure(1); clf(1)
subplot(2,1,1)
imagesc(squeeze(test(150,:,:))); axis equal tight
colorbar
hold on
rectangle('Position',[roi_y(1) roi_x(1) length(roi_y) length(roi_x)],'EdgeColor','r')
rectangle('Position',[roi_c_y(1) roi_c_x(1) length(roi_c_y) length(roi_c_x)],'EdgeColor','g')
rectangle('Position',[roi_c_y_2(1) roi_c_x_2(1) length(roi_c_y) length(roi_c_x)],'EdgeColor','c')
rectangle('Position',[roi_n_y(1) roi_n_x(1) length(roi_n_y) length(roi_n_x)],'EdgeColor','b')
rectangle('Position',[roi_n_y_2(1) roi_n_x_2(1) length(roi_n_y) length(roi_n_x)],'EdgeColor','y')
hold off

subplot(2,1,2)
plot(squeeze(mean(mean(squeeze(OCT(z,roi_x,roi_y,:)),1),2)),'r')
hold on
plot(squeeze(mean(mean(squeeze(OCT(z,roi_c_x,roi_c_y,:)),1),2)),'g')
hold on
plot(squeeze(mean(mean(squeeze(OCT(z,roi_c_x_2,roi_c_y_2,:)),1),2)),'c')
hold on
plot(squeeze(mean(mean(squeeze(OCT(z,roi_n_x,roi_n_y,:)),1),2)),'b')
hold on
plot(squeeze(mean(mean(squeeze(OCT(z,roi_n_x_2,roi_n_y_2,:)),1),2)),'y')
hold off
axis equal tight