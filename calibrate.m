
% Define images to process
imageFileNames = {'/media/hilab/HiLabData/Sagnik/CSLProject/psf-estimation/calibration/1.bmp',...
    '/media/hilab/HiLabData/Sagnik/CSLProject/psf-estimation/calibration/2.bmp',...
    '/media/hilab/HiLabData/Sagnik/CSLProject/psf-estimation/calibration/3.bmp',...
    '/media/hilab/HiLabData/Sagnik/CSLProject/psf-estimation/calibration/4.bmp',...
    '/media/hilab/HiLabData/Sagnik/CSLProject/psf-estimation/calibration/5.bmp',...
    };
% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates of the corners of the squares
squareSize = 8;  % in units of 'millimeters'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% View reprojection errors
h1=figure; showReprojectionErrors(cameraParams);

% Visualize pattern locations
h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, cameraParams);

% For example, you can use the calibration data to remove effects of lens distortion.
undistortedImage = undistortImage(originalImage, cameraParams);

