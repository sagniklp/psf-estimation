% calibrate

[imagePoints,boardSize]=detectCheckerboardPoints(cb_img);
squareSizeInMM=5;
worldPoints=generateCheckerboardPoints(boardSize,squareSizeInMM);
params=estimateCameraParameters(imagePoints,worldPoints);
