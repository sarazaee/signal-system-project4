clc; clear; close all;

% --- 1. Load Video ---
videoFile = '2-3_VariableSize.mp4'; 
if ~exist(videoFile, 'file')
    error('Video file not found. Please check the file path.');
end
vid = VideoReader(videoFile);

% --- Output Video Settings ---
outputFile = 'tracked_airplane_3.mp4';
outputVideo = VideoWriter(outputFile, 'MPEG-4');
outputVideo.FrameRate = vid.FrameRate; 
open(outputVideo);

% --- 2. Read first frame and Select object ---
firstFrame = readFrame(vid);
firstGray = rgb2gray(firstFrame);

figure('Name', 'Select Object');
imshow(firstFrame);
title('Draw a rectangle around the object and double-click.');
h = imrect;
position = wait(h);
close;

trackBox = position; % Current tracked position [x, y, width, height]
frame1_gray = firstGray;

% --- 3. Process Frames ---
hFig = figure('Name', 'Tracked Video');

while hasFrame(vid)
    frame2 = readFrame(vid);
    frame2_gray = rgb2gray(frame2);
    
    % --- Step 1 & 2: Difference and Thresholding ---
    diffFrame = imabsdiff(frame2_gray, frame1_gray);
    bw = diffFrame > 20; % Sensitivity threshold
    
    % --- Step 3: Morphology ---
    bw = bwareaopen(bw, 15);
    se = strel('disk', 3);
    bw = imclose(bw, se);
    
        % --- Step 4 & 5: Detection and Matching ---
    stats = regionprops(bw, 'BoundingBox', 'Area', 'Centroid');
    
    bestMatch = [];
    minDist = inf;
    
    % Define allowed movement (in pixels) - e.g., plane can't jump 100 pixels in 1 frame
    maxMovement = 50; 
    
    % Define size constraints (optional: plane size won't change drastically)
    % You can tune these values based on your target size
    minArea = 20; 
    maxArea = 500; 

    if ~isempty(trackBox) && numel(trackBox) >= 4
        prevCenter = [trackBox(1) + trackBox(3)/2, trackBox(2) + trackBox(4)/2];
        
        for k = 1:length(stats)
            currCenter = stats(k).Centroid;
            dist = norm(currCenter - prevCenter);
            currArea = stats(k).Area;
            
            % NEW: Add strict filtering
            % 1. Distance constraint (must be close to previous)
            % 2. Area constraint (must be within size limits)
            if dist < minDist && dist < maxMovement && ...
               currArea > minArea && currArea < maxArea
                
                minDist = dist;
                bestMatch = stats(k).BoundingBox;
            end
        end
    end

    
    % --- Step 6: Update and Draw ---
    frameOut = frame2;
    if ~isempty(bestMatch)
        trackBox = bestMatch; % Update successful
        frameOut = insertShape(frameOut, 'Rectangle', trackBox, 'Color', 'green', 'LineWidth', 3);
    elseif ~isempty(trackBox)
        % If not found, use the last known position (Yellow box)
        frameOut = insertShape(frameOut, 'Rectangle', trackBox, 'Color', 'yellow', 'LineWidth', 3);
    end
    
    % --- Step 7: Display and Write ---
    if ishandle(hFig)
        imshow(frameOut);
        title('Tracking (Green: Found, Yellow: Estimated)');
        drawnow;
    end
    
    writeVideo(outputVideo, frameOut);
    frame1_gray = frame2_gray;
end

close(outputVideo);
disp('Processing completed. Output video saved.');
