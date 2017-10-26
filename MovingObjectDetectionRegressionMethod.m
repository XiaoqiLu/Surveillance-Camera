function [ heat ] = MovingObjectDetectionRegressionMethod( fileIn, fileOut, ...
    nFrameSampled, threshold )

lambdaFactor = 1;

if nargin < 4
    threshold = 0.1;
end

if nargin < 3
    nFrameSampled = 100;
end

vidIn = VideoReader(fileIn);

vidHeight = vidIn.Height;
vidWidth = vidIn.Width;

nFrame = 0;
while hasFrame(vidIn)
    nFrame = nFrame + 1;
    readFrame(vidIn);
end

vidIn.CurrentTime = 0;

nFrameSampled = min(nFrameSampled, nFrame);
stepSize = floor(nFrame / nFrameSampled);
nFrameSampled = floor(nFrame / stepSize);

disp(['Sampling ', num2str(nFrameSampled), ' frames...']);

%% create dictrionary

dim = vidHeight * vidWidth;
D = zeros(dim, nFrameSampled);
iFrameSampled = 0;
for iFrame = 1 : nFrame
    frameIn = readFrame(vidIn);
    if mod(iFrame, stepSize) == 0
        iFrameSampled = iFrameSampled + 1;
        D(:, iFrameSampled) = reshape(frameIn(:, :, 2), [dim, 1]); % use green
    end
end

vidIn.CurrentTime = 0;

[A, ~] = SparseLowrankDecomposition(D, lambdaFactor);
coeff = pca(A);
A = A * coeff(:, 1 : rank(A));

disp('Dictionary created.');

%% regression

vidOut = VideoWriter(fileOut, 'MPEG-4');
open(vidOut);

heat = 0;

for iFrame = 1 : nFrame
    
    disp(['Frame: ', num2str(iFrame), ' / ', num2str(nFrame)]);
    
    frameIn = readFrame(vidIn);
    Y = reshape(frameIn(:, :, 2), [dim, 1]); % use green
    Y = double(Y);
    [~, ~, res] = regress(Y, A);
    
    frameOut = abs(reshape(res, [vidHeight, vidWidth]) / 256);
    frameOut = 1 * (frameOut > threshold);
    heat = heat + frameOut;
    writeVideo(vidOut, frameOut);
    
end

close(vidOut);

end

