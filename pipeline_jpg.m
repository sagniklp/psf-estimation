% This is the alignment procedure for the bayer images
% Author: Rose Rustowicz, rose.rustowicz@gmail.com
% Date: 16 March 2018

%% Read camera params
load('camParams_omniV.mat')
%% Read images
folder = 'inp_images/omniv/';
cb_img = im2double(demosaic(imread(strcat(folder,'cb.png')),'bggr'));
cb_img = undistortImage(cb_img, cameraParams_omniV);
black_img = im2double(demosaic(imread(strcat(folder,'bl.png')),'bggr'));
black_img = undistortImage(black_img, cameraParams_omniV);
white_img = im2double(demosaic(imread(strcat(folder,'wh.png')),'bggr'));
white_img = undistortImage(white_img, cameraParams_omniV);

for idx = 1:5
    noise_img{idx} = im2double(demosaic(imread(char(strcat(folder,'n',string(idx),'.png'))),'bggr'));
    noise_img{idx} = undistortImage(noise_img{idx}, cameraParams_omniV);
end

%% Read in pristine targets 
cb = im2double(imread('targets/samsung/cb.png'));
black = im2double(imread('targets/samsung/bl.png'));
white = im2double(imread('targets/samsung/wh.png'));
noise{1} = im2double(imread('targets/noise_01_n.png'));
noise{2} = im2double(imread('targets/noise_02_n.png'));
noise{3} = im2double(imread('targets/noise_03_n.png'));
noise{4} = im2double(imread('targets/noise_04_n.png'));
noise{5} = im2double(imread('targets/noise_05_n.png'));

%% FOR EACH COLOR CHANNEL:
for c = 1:2
    cur_cb_img = cb_img(:,:,c); 
    cur_black_img = black_img(:,:,c);
    cur_white_img = white_img(:,:,c);
    % cur_noise_img = noise_img(:,:,c);
    % iprime_norm = warp_function(cb, noise, black, white, cur_cb_img, cur_noise_img, cur_black_img, white_img);   
    % u_img = cur_black_img + iprime_norm .* (cur_white_img - cur_black_img);

    for n_idx = 1:numel(noise_img)
        cur_noise = noise_img{n_idx};
        cur_noise_img(:,:,n_idx) = cur_noise(:,:,c);
    end
    
    for n_idx = 1:numel(noise)
        cur_noise_ = noise{n_idx};
        cur_noise(:,:,n_idx) = cur_noise_(:,:,c);
    end
    
    % Project pristine image targets into image space
    for idx = 1 :5
       u_img(:,:,idx) = warp_function(cb, cur_noise(:,:,idx), black, white, cur_cb_img, cur_noise_img(:,:,idx), cur_black_img, cur_white_img);   
    end

    % Correct for colors in pristine image with black and white image
%     for idx = 1:5
%        u_img(:,:,idx) = cur_black_img + iprime_norm(:,:,idx) .* (cur_white_img - cur_black_img);
%     end
    
    fname = strcat('s10', num2str(c), '_uimgs_bimgs.mat');
    save(fname,'cur_noise_img','u_img')
end
