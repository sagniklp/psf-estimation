function [i_prime_norm] = warp_funtion(cb, noise, black, white, img_cb, img_noise, img_blk, img_wht)
%WARP_FUNTION uses calibration targets to warp a pristine image into the camera image space
% Author: Rose Rustowicz, rose.rustowicz@gmail.com
% Date: 16 March 2018

% cb = cb(1:end-34*3,1:end-34*7);
% noise = noise(1:end-34*3,1:end-34*7);
% black = black(1:end-34*3,1:end-34*7);
% white = white(1:end-34*3,1:end-34*7);

cb_rows = 19; % - 3;
cb_cols = 19; % - 7;
S_p = 20;

%Extract corners from synthetic and actual checkerboard image
% col (x), row (y) order for coordinates
[aB_coords] = get_cb_pts(cb, black, white, cb_rows, cb_cols);
[xy_coords] = get_cb_pts(img_cb, img_blk, img_wht, cb_rows, cb_cols);

% Visualize to make sure that the points match between the synthetic vs img
% of the checkerboard pattern
% figure; 
% visualize_cb_pts(aB_coords, cb);
% figure;
% visualize_cb_pts(xy_coords, img_cb);

% Now we have a list of the corners for each checkerboard on the target!

% Map the synthetic cb into image space via forward mapping / bilinear interpolation

% Initialize values
count = zeros(size(img_cb(:,:,1)));
i_prime = zeros(size(img_cb(:,:,1)));

% mat = [[ 1,  0,  0,  0];
%        [-1,  1,  0,  0];
%        [-1,  0,  1,  0];
%        [ 1, -1, -1,  1]];

mat = [[ 1,  -1,  -1,  1];
       [-1,  1,  0,  0];
       [-1,  0,  1,  0];
       [ 1,  0,  0,  0]];
   
counter = 0;
for cur_block = 1:numel(aB_coords(:,1))
    counter = counter + 1;
    
    if mod(counter, 10) == 0
        display(counter)
    end
        
    % map current alphas and betas to [0, 1]
%     u0 = floor((aB_coords(cur_block, 1) + aB_coords(cur_block, 5))/2);
    u=round(aB_coords(cur_block, 3) - aB_coords(cur_block, 1));
    v=round(aB_coords(cur_block, 8) - aB_coords(cur_block, 2));
    u0=aB_coords(cur_block, 1);
    u1=aB_coords(cur_block, 2);
%     u1 = floor((aB_coords(cur_block, 3) + aB_coords(cur_block, 7))/2);
    us = linspace(0, 1, S_p);
   
%     v0 = floor((aB_coords(cur_block, 2) + aB_coords(cur_block, 4))/2);
%     v2 = floor((aB_coords(cur_block, 6) + aB_coords(cur_block, 8))/2);
    vs = linspace(0, 1, S_p); 
    
    xy = xy_coords(cur_block,:); 
    
    % y, x form
    xy_mat = [[xy(1), xy(2)];
              [xy(3), xy(4)];
              [xy(7), xy(8)];
              [xy(5), xy(6)]];
          
    uv_mat = zeros(S_p*S_p, 4);
    uv_mat(:,4) = 1;
    uv_mat(:,2) = repmat(us,1,S_p);
    
    for idx = 1:S_p
        r1 = (idx-1)*S_p+1;
        r2 = idx*S_p;
        uv_mat(r1:r2,3) = vs(idx);
    end
    uv_mat(:,1) = uv_mat(:,2) .* uv_mat(:,3);
    
    xy_new = round(uv_mat * mat * xy_mat);
    
    for idx = 1:numel(xy_new(:,1))
        cur_xy = xy_new(idx,:);
%         plot(cur_xy(1),cur_xy(2),'r.')
        count(cur_xy(1), cur_xy(2)) = count(cur_xy(1), cur_xy(2)) + 1;
%         plot(round(uv_mat(idx,2)*(u1-u0)+u0),round(uv_mat(idx,3)*(v2-v0)+v0),'g.')
%         i_prime(cur_xy(1), cur_xy(2),:) = i_prime(cur_xy(1), cur_xy(2),:) + noise(round(uv_mat(idx,2)*(u1-u0)+u0),round(uv_mat(idx,3)*(v2-v0)+v0),:);
        i_prime(cur_xy(1), cur_xy(2),:) = i_prime(cur_xy(1), cur_xy(2),:) + noise(round(uv_mat(idx,2)*u +u0),round(uv_mat(idx,3)*v+u1),:);
    end
end

i_prime = i_prime ./ count;
% figure; imshow(i_prime);

max_iprime = max(i_prime(:));
min_iprime = min(i_prime(:));

i_prime_norm = (i_prime - min_iprime) / (max_iprime - min_iprime);
figure; imshow(i_prime_norm, []);

end

