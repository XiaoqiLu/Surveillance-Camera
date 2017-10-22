% %% read video
% 
% vidIn = VideoReader('atrium.mp4');
% 
% vidHeight = vidIn.Height;
% vidWidth = vidIn.Width;
% 
% vidStruct = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'), 'colormap',[]);
% 
% nFrame = 0;
% while hasFrame(vidIn)
%     nFrame = nFrame + 1;
%     vidStruct(nFrame).cdata = readFrame(vidIn);
% end
% 
% % set(gcf,'position',[400 400 vidObj.Width vidObj.Height]);
% % set(gca,'units','pixels');
% % set(gca,'position',[100 100 vidObj.Width vidObj.Height]);
% % movie(vidStruct,1,vidObj.FrameRate);
% 
% 
% 
% %% use green
% 
% dim = vidHeight * vidWidth;
% 
% nFrame = min(nFrame, 600);
% 
% D = zeros(dim, nFrame);
% 
% for iFrame = 1 : nFrame
%     D(:, iFrame) = reshape(vidStruct(iFrame).cdata(:, :, 2), [dim, 1]);
% end
% 
% %% sparse and low-rank decomposition
% 
% [A, E] = SparseLowrankDecomposition(D);

%% Output

vidOut = VideoWriter('error.avi', 'Grayscale AVI');

frame = zeros(vidHeight, vidWidth, nFrame);

open(vidOut)
for iFrame = 1 : nFrame
    frame(:, :, iFrame) = 1 * (abs(reshape(E(:, iFrame), [vidHeight, vidWidth]) / 256) > 0.05);
    writeVideo(vidOut, frame(:, :, iFrame));
end
close(vidOut);

heat = mean(frame, 3);
image(heat, 'CDataMapping', 'scaled')