% features = ExtractFeatures(data)
% Input: a 3 by n matrix where the first row contains the x
%   positions of the stroke, the second row contains the y
%   positions of the stroke, and the third row contains a
%   sequence of booleans indicating whether the pen was down
%   was not
% 
% Result:
% A 7 by n matrix where
%   row 1 contains the cosine of the tangents
%   row 2 contains the sine of the tangents
%   row 3 contains the cosine of the angular velocity
%       of the tangents
%   row 4 contains the sine of the angular velocity
%       of the tangents
%   row 5 contains the y position normalize to the bounding
%       box of the character
%   row 6 contains the angle of the tangents in radians
%   row 7 contains the angular velocity of the tangents in radians
%----------------------------------------------------
% Code Authors:
% Christopher Norman
% Pierre Laurent
%----------------------------------------------------
% % To run:
% P = ExtractFeatures(DrawCharacter);
% t = 1:size(P, 2);
% plot(t, P(4, :), t, P(5, :)); % Example: plot delta_1 and delta_2
% axis([0, size(P, 2), -1.2, 1.2]);
%
% * References
% * sine and cosine of direction, see
% S. Jaeger, S. Manke, J. Reichert, and A. Waibel. Online
% Handwriting Recognition: The NPen++ Recognizer.
% (ref for both angle and curvature)
% * Normalized derivatives? see
% M. Pastor, A. Toselli, and E. Vidal. Writing Speed Nor-
% malization for On-Line Handwritten Text Recognition
% * Height is from
% Bharath A, Sriganesh Madhvanath. Hidden Markov Models
% for Online Handwritten Tamil Word Recognition

function [features] = ExtractFeatures(data)
    % Preprocess
    
%     data(1, :) = smooth(data(1, :))';
%     data(2, :) = smooth(data(2, :))';

%     data = Resample(data, 0.5, 'linear');
    data = StraightenLiftedStrokes(data);
        
    % Extract features
    height = data(2, :);
    min_height = min(height(data(3, :) == 1));
    max_height = max(height(data(3, :) == 1));
    height = (height - min_height) / (max_height - min_height);
    
    alpha = normc(diff(data(1:2, :), 1, 2));
    
    direction = smooth(atan2(alpha(2, :), alpha(1, :)))';
    
    curvature = diff(direction);
    curvature = mod(curvature + pi, 2*pi) - pi;
    
    beta_1 = alpha(1, 1:end-2) .* alpha(1, 3:end) + alpha(2, 1:end-2) .* alpha(2, 3:end);
    beta_2 = alpha(1, 1:end-2) .* alpha(2, 3:end) - alpha(2, 1:end-2) .* alpha(1, 3:end);
    beta = normc([beta_1; beta_2]);
    
    features = [alpha(1, 3:end); ...
                alpha(2, 3:end); ...
                beta(1, :); ...
                beta(2, :); ...
                height(4:end); ...
                direction(3:end); ...
                curvature(2:end); ...
                ];
    
%     features(:, data(3, :) == 0) = 0;
    
end