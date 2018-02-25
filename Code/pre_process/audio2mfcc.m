% Script for converting .mp3 files to X and Y matrices

clear
close all

% preprocessing hyperparams
window_size_ms = 10; %window length
window_per_frame = 10; %windows in each frame (training example)
frame_stride = 3; %stride of each frame in number of windows
num_mfcc = 13; %desired number of mfcc coefficients 

% Read through the contents of the audio folder
audioFolder = 'Audio_Data';
folderConts = dir(audioFolder);

for ii = 1:length(folderConts)
    audioFile = folderConts(ii);
    fprintf('File #%i of %i, %s \n', ii, length(folderConts), audioFile.name);
    
    [~, name, ext] = fileparts(audioFile.name);
    class = 0;
    
    if isequal(ext, '.mp3')
        [sig, Fs] = data_load_trim(fullfile(audioFolder,audioFile.name));
        try
            X = kannumfcc(13, sig, Fs, window_size_ms);
            
            X = data_frame(X, frame_stride, window_per_frame);

            if ~isempty(strfind(name, 'obama'))
                class = 1;
            elseif ~isempty(strfind(name, 'trump'))
                class = 2;
            end
            
            Y = zeros(size(X, 1), 2);
            Y(:, class) = 1;
            
            
            % split data into overlapping windows
            
            % Write X and Y to csv
            Xfile = fullfile('MFCC_Data', [name, '_X.csv']);
            Yfile = fullfile('MFCC_Data', [name, '_Y.csv']);
            
            csvwrite(Xfile, X);
            csvwrite(Yfile, Y);
        catch
            fprintf('Skipped file #%i \n', ii);
        end
    end
end