% Script for converting raw .mp3 files to pre-processed MFCC data
clear
close all
clc

% User inputs:
% Flags
writeVoicedData = true;     % Write the VAD-processed speech to .wav files
writeAllMFCCData = true;    % Write all MFCC data for each audio file to .csv
writeShuffledSets = true;   % Write the train, dev, and test sets to .csv

% Pre-processing hyperparameters
frame_size_ms = 10; %window length
frames_per_window = 10; %windows in each frame (training example)
frame_stride = 3; %stride of each frame in number of windows
num_mfcc = 13; %desired number of mfcc coefficients 

% Set the shuffling seed (if desired)
rng(123);
% rng('shuffle');

% Set the desired breakdown of train, dev, and test data
trainSize = 0.95;
devSize = 0.025;
testSize = 0.025;

% Paths to raw and pre-processed data
    % Note: based on git folder structure
currentFile = mfilename('fullpath');
[currentPath, ~, ~] = fileparts(currentFile);

dataFolder = fullfile(currentPath, '..', '..', 'Data');
rawAudioFolder = fullfile(dataFolder, 'Raw_Audio_Data');
speechAudioFolder = fullfile(dataFolder, 'VAD-Processed_Audio_Data');
mfccFolder = fullfile(dataFolder, 'MFCC_Data');

% Read through the contents of the raw audio folder
folderConts = dir(rawAudioFolder);

% Initialize empty arrays for the full set of X and Y data
fullX = [];
fullY = [];

for ii = 1:length(folderConts) 
    audioFile = folderConts(ii);
    fprintf('File #%i of %i: %s \n', ii, length(folderConts), audioFile.name);

    [~, fileName, ext] = fileparts(audioFile.name);
    
    % Only process mp3 files
    if isequal(ext, '.mp3')
        
        % Pull the class from the file name
        classStr = strtok(fileName, '-');
        class = str2double(classStr);
        
        % Process only the voiced data from the raw audio
        [voicedSig, Fs] = data_load_trim(fullfile(rawAudioFolder, audioFile.name));
        
        % Save the voiced data for reference
        if writeVoicedData
            % Note: audiowrite can't handle .mp3, defaulting to .wav
            voicedDataPath = fullfile(speechAudioFolder, [fileName, '-Speech', '.wav']);
            audiowrite(voicedDataPath, voicedSig, Fs);
        end
        
        try
            % Extract MFCCs
            X = kannumfcc(13, voicedSig, Fs, frame_size_ms);
            
            % Re-structure data to account for overlapping frames
            X = data_frame(X, frame_stride, frames_per_window);
            
            % Generate the corresponding Y matrix
            Y = zeros(size(X, 1), 2);
            Y(:, class) = 1;
            
            % Write X and Y to csv
            if writeAllMFCCData
                Xfile = fullfile(mfccFolder, [fileName, '_X.csv']);
                Yfile = fullfile(mfccFolder, [fileName, '_Y.csv']);
            
                csvwrite(Xfile, X);
                csvwrite(Yfile, Y);
            end
            
            % Expand the full X and Y sets
            fullX = [fullX; X];
            fullY = [fullY; Y];
        catch
            fprintf('------------\n');
            fprintf('Skipped file\n');
            fprintf('------------\n');
        end
    end
end

if writeShuffledSets
    fprintf('Writing full data sets\n');
    % Shuffle the full X and Y matrices
    m_full = size(fullX, 1);
    shuffledIdx = randperm(m_full);
    
    shuffledX = fullX(shuffledIdx, :);
    shuffledY = fullY(shuffledIdx, :);
    
    % Parse train, dev and test sets
    m_train = floor(trainSize*m_full);
    m_dev = floor(devSize*m_full);
    m_test = floor(testSize*m_full);
    
    X_train = shuffledX(1:m_train, :);
    Y_train = shuffledY(1:m_train, :);
    
    trainFileX = fullfile(mfccFolder, 'X_train.csv');
    trainFileY = fullfile(mfccFolder, 'Y_train.csv');
    
    X_dev = shuffledX((m_train + 1):(m_train + m_dev), :);
    Y_dev = shuffledY((m_train + 1):(m_train + m_dev), :);
    
    devFileX = fullfile(mfccFolder, 'X_dev.csv');
    devFileY = fullfile(mfccFolder, 'Y_dev.csv');
    
    X_test = shuffledX((m_train + m_dev + 1):(m_train + m_dev + m_test), :);
    Y_test = shuffledY((m_train + m_dev + 1):(m_train + m_dev + m_test), :);
    
    testFileX = fullfile(mfccFolder, 'X_test.csv');
    testFileY = fullfile(mfccFolder, 'Y_test.csv');
    
    % Write out the train, dev, and test sets
    csvwrite(trainFileX, X_train);
    csvwrite(trainFileY, Y_train);
    
    csvwrite(devFileX, X_dev);
    csvwrite(devFileY, Y_dev);
    
    csvwrite(testFileX, X_test);
    csvwrite(testFileY, Y_test);
end

fprintf('Complete!\n');