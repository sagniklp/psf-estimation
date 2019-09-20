
%% Load camera parameters
load('camParams_omniV.mat')
folder = 'inp_images/omniv/';
%% Load input images 
white=imread('../raw_reader/images/white.jpg');
no_obj=imread('../raw_reader/images/no_obj.jpg');
no_obj=undistortImage(no_obj, cameraParams_omniV);
white=undistortImage(white, cameraParams_omniV);

cb = im2double(demosaic(imread(strcat(folder,'cb.png')),'bggr'));
cb = undistortImage(cb, cameraParams_omniV);

figure; imshow(white);
figure; imshow(no_obj);
figure; imshow(cb);

%% Apply blind deconvolution
dcv_noobj= deconvblind (no_obj,psf,100);
dcv_wh= deconvblind (white,psf,100);
dcv_cb= deconvblind (cb,psf,100);
figure; imshow(dcv_noobj);
figure; imshow(dcv_wh);
figure; imshow(dcv_cb);