function X_framed = data_frame(X, stride, framesPerWindow)

% splits data into windows according to the Ge paper

% inputs:
% X, mfcc data already split into windows
% stride, the stride between frames (units of windows)
% win_per_frame, number of windows stacked together to make one data sample

% output:
% X_framed, mfcc's of audio data split into frames 

numFrames = size(X, 1);
numFeatures = size(X, 2);

m = floor((numFrames - framesPerWindow)/stride);
X_framed = zeros(m, numFeatures*framesPerWindow);

for ii = 1:m
    
    ind_start = (ii - 1)*stride + 1;
    ind_end = ind_start + framesPerWindow - 1;
    
    sect = X(ind_start:ind_end, :);
    X_framed(ii, :) = reshape(sect', 1, []);
    
end



