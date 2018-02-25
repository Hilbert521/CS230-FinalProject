function [signal, fs] = data_load_trim(file_name)
% loads audio data
% trims out sections where no one is speaking
% returns audio data with most silence removed


% inputs: file_name - path to audio file
% outputs signal - audio file data in matrix form with no gaps
%         fs - sample rate

[segments, fs] = detectVoiced(file_name);

signal = null(1);
for ii = 1:length(segments)
    
   seg = cell2mat(segments(ii));
   
   signal = [signal; seg];
end

