%% read video

vidIn = VideoReader('atrium.mp4');

vidHeight = vidIn.Height;
vidWidth = vidIn.Width;

nFrame = 0;
while hasFrame(vidIn)
    nFrame = nFrame + 1;
    readFrame(vidIn);
end

vidIn.CurrentTime = 0;


%% block-wise sparse and low-rank decomposition

vidOut = VideoWriter('error.avi', 'Grayscale AVI');
open(vidOut);

threshold = 0.1;
heat = 0;

nFramePerBlock = 80;
nFrameOverlap = 20;
nFrameMoving = nFramePerBlock - nFrameOverlap;

nBlock = floor((nFrame - nFramePerBlock) / nFrameMoving) + 1;
nFrame = (nBlock - 1) * nFrameMoving + nFramePerBlock;

for iBlock = 1 : nBlock
    
    disp(['===Block ', num2str(iBlock), ' out of ', num2str(nBlock), '===']);
    
    % read video
    dim = vidHeight * vidWidth;
    D = zeros(dim, nFramePerBlock);
    for iFrame = 1 : nFramePerBlock
        if iFrame == nFrameMoving + 1
            flagTime = vidIn.CurrentTime;
        end
        frameIn = readFrame(vidIn);
        D(:, iFrame) = reshape(frameIn(:, :, 2), [dim, 1]); % use green
    end
    
    % sparse and low-rank decomposition
    [A, E] = SparseLowrankDecomposition(D);
    if iBlock > 1
        E = E(:, (nFrameOverlap + 1) : end);
    end
    for jFrame = 1 : size(E, 2)
        frameOut = abs(reshape(E(:, jFrame), [vidHeight, vidWidth]) / 256);
        frameOut = 1 * (frameOut > threshold);
        heat = heat + frameOut;
        writeVideo(vidOut, frameOut);
    end
    vidIn.CurrentTime = flagTime;
end

close(vidOut);

