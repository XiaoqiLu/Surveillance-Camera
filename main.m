% %% Window Method
% 
% fileIn = '../atrium.mp4';
% fileOut = '../atrium_window_method.mp4';
% 
% heat_window = MovingObjectDetectionWindowMethod(fileIn, fileOut, 80, 20);



%% Window Method

% fileIn = '../atrium.mp4';
% fileOut = '../atrium_regression_method.mp4';

fileIn = '../sample.mp4';
fileOut = '../sample_regression_method.mp4';


heat_regression = MovingObjectDetectionRegressionMethod(fileIn, fileOut, 100, 0.15);
