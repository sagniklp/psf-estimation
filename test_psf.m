
%% Load camera parameters
load('camParams_omniV.mat')
folder = 'inp_images/omniv/';
%% Load input images 
white=im2double(imread('../raw_reader/images/white.jpg'));
no_obj=im2double(imread('../raw_reader/images/no_obj.jpg'));
no_obj=undistortImage(no_obj, cameraParams_omniV);
white=undistortImage(white, cameraParams_omniV);

cb = im2double(demosaic(imread(strcat(folder,'cb.png')),'bggr'));
cb = undistortImage(cb, cameraParams_omniV);

% figure; imshow(white);
% figure; imshow(no_obj);
figure; imshow(cb);

%% Apply blind deconvolution
% dcv_noobj= deconvblind (no_obj,psf,100);
% dcv_wh= deconvblind (white,psf,100);
% dcv_cb= deconvblind (cb,psf,100);
% figure; imshow(dcv_noobj);
% figure; imshow(dcv_wh);
% figure; imshow(dcv_cb);

out_cb=zeros(400,400);
out_no=zeros(400,400);
out_wh=zeros(400,400);

V=0.00001
for i=1:3
    il=i*25+1;
    ih=il+24;
    img_il=i*100+1;
    img_ih=img_il+99;
    for j=1:3
       jl=j*25+1;
       jh=jl+24;
       psf=psf_grid(il:ih,jl:jh);
       
       if  sum(nonzeros(psf(:)))==0
            psf(13, 13) = 1;
       end
       img_jl=j*100+1;
       img_jh=img_jl+99;
       dcv_cb= deconvlucy (cb(img_il:img_ih,img_jl:img_jh),psf,20,sqrt(V));
       out_cb(img_il:img_ih,img_jl:img_jh)=out_cb(img_il:img_ih,img_jl:img_jh)+dcv_cb;
       
       dcv_no= deconvlucy (no_obj(img_il:img_ih,img_jl:img_jh),psf,20,sqrt(V));
       out_no(img_il:img_ih,img_jl:img_jh)=out_no(img_il:img_ih,img_jl:img_jh)+dcv_no;
       
       dcv_wh= deconvlucy (white(img_il:img_ih,img_jl:img_jh),psf,20,sqrt(V));
       out_wh(img_il:img_ih,img_jl:img_jh)=out_wh(img_il:img_ih,img_jl:img_jh)+dcv_wh;
%        figure; imshow(dcv_cb);
%        figure; imagesc(psf);
    end
end
figure; imshow(psf_grid(26:100,26:100,:));

figure; imshow(out_cb(101:400,101:400));
figure; imshow(cb(101:400,101:400));

figure; imshow(out_wh(101:400,101:400));
figure; imshow(white(101:400,101:400));

figure; imshow(out_no(101:400,101:400));
figure; imshow(no_obj(101:400,101:400));