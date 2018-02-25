function X_framed = data_frame(X, stride, win_per_frame)

% splits data into windows according to the Ge paper

% inputs:
% X, mfcc data already split into windows
% stride, the stride between frames (units of windows)
% win_per_frame, number of windows stacked together to make one data sample

% output:
% X_framed, mfcc's of audio data split into frames 

num_win = length(X(:,1));

m = floor((num_win-win_per_frame)/stride);
X_framed = zeros(m, length(X(1,:))*win_per_frame);

for ii = 1:m
    
    ind_start = (ii-1)*stride+1;
    ind_end = ind_start+win_per_frame-1;
    
    sect = X(ind_start:ind_end, :);
    X_framed(ii,:) = reshape(sect',1,[]);
    
end



