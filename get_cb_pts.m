function [new_coords] = get_cb_pts(cb_img, img_blk, img_wht, cb_rows, cb_cols)
%GET_CB_PTS Takes in an image of a checkperboard, and returns the
% coordinates for each internal cube in the checkerboard. Each coordinate is
%cmade up of 8 values: ll_x, ll_y, lr_x, lr_y, ur_x, ur_y, ul_x, ul_y
% Author: Rose Rustowicz, rose.rustowicz@gmail.com
% Date: 16 March 2018

% Correct cb image to see checkerboard along edges
% cb_img = cb_img./img_wht;

% Detect checkerboards within the image
[imagePoints,boardSize] = detectCheckerboardPoints(cb_img,'MinCornerMetric',0.01);
imagePoints = round(imagePoints);

figure;
imshow(cb_img);
hold on;
plot(imagePoints(:,1),imagePoints(:,2),'ro');

counts = [2, cb_rows+1, cb_rows, 1];
iter = 1;
% new_coords = zeros((cb_rows-2)*(cb_cols-2), 8);
new_coords = zeros((cb_rows-2)*(cb_cols-2), 8);
% while iter < ((cb_rows-2) * (cb_cols-2) + 1)
%     if mod(counts(4), (cb_rows-1)) == 0
%         counts = counts + 1;
%     end
%     new_coords(iter,5) = imagePoints(counts(1),1); % 5
%     new_coords(iter,6) = imagePoints(counts(1),2); % 6
%     new_coords(iter,7) = imagePoints(counts(2),1); % 7 
%     new_coords(iter,8) = imagePoints(counts(2),2); % 8
%     new_coords(iter,3) = imagePoints(counts(3),1); % 3
%     new_coords(iter,4) = imagePoints(counts(3),2); % 4
%     new_coords(iter,1) = imagePoints(counts(4),1); % 1
%     new_coords(iter,2) = imagePoints(counts(4),2); % 2 
%     
%     counts = counts + 1;
%     iter = iter + 1;
% 
% end

for i=0:(cb_rows-3)
    l=i*(cb_cols-1);
    u=(i+1)*(cb_cols-1);
%     if i==22
%         i
%     end
    for j=1:(cb_cols-2)
        ll=l+j;
        lr=ll+1;
        ul=u+j;
        ur=ul+1;
        new_coords(iter,1)= imagePoints(ll,1);
        new_coords(iter,3)= imagePoints(lr,1);
        new_coords(iter,7)= imagePoints(ul,1);
        new_coords(iter,5)= imagePoints(ur,1);
        new_coords(iter,2)= imagePoints(ll,2);
        new_coords(iter,4)= imagePoints(lr,2);
        new_coords(iter,8)= imagePoints(ul,2);
        new_coords(iter,6)= imagePoints(ur,2);
        iter=iter+1;
    end
end

