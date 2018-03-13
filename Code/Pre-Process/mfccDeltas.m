function [delta] = mfccDeltas(mfcc, N)
% mfccDeltas Computes MFCC delta coefficients
%   
% Inputs:
%    mfcc - matrix of MFCCs (size t x c)
%       N - size of delta regression window
% 
% Outputs:
%   delta - matrix of MFCC delta features (size t x c)

[t, c] = size(mfcc);
delta = zeros(t, c);

% Iterate over each coefficient
for ii = 1:c
    
    coeffs = mfcc(:, ii);
    
    % Iterate over each time step
    for tt = 1:t
        
        num = 0;
        den = 0;
        
        % Iterate over the desired window size
        for nn = 1:N
            
            idx1 = tt + nn;
            idx2 = tt - nn;
            
            % Handle out-of-bounds indices
            if idx1 > t
                idx1 = length(coeffs);
            end
            
            if idx2 < 1
                idx2 = 1;
            end
            
            % MFCC Delta formula:
            c1 = coeffs(idx1);
            c2 = coeffs(idx2);
            
            num = num + nn*(c1 - c2);
            den = den + nn^2;
            
        end
        
        delta(tt, ii) = num/(2*den);
        
    end
            
end

