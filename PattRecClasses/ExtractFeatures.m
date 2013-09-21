% features = ExtractFeatures(data)
% Input: a 3 by n matrix where the first row contains the x
%   positions of the stroke, the second row contains the y
%   positions of the stroke, and the third row contains a
%   sequence of booleans indicating whether the pen was down
%   was not
% 
% Result:
% A 8 by n matrix where
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
%   row 8 contains a sequence of booleans specifying whether the
%       pen was down or not
%----------------------------------------------------
% Code Authors:
% Christopher Norman
% Pierre Laurent

function [features] = ExtractFeatures(data)
    % Preprocess
    
    % Introduce a small amount of noise to avoid consecutive
    % identical frames
    data(1:2, :) = data(1:2, :) + 1e-6 * rand(size(data(1:2, :)));
    
    % Extract features
    height = data(2, :);
    if any(data(3, :) == 1) % Any strokes?
        min_height = min(height(data(3, :) == 1));
        max_height = max(height(data(3, :) == 1));
        height = (height - min_height) / (max_height - min_height);
    end
    
    alpha = normc(diff(data(1:2, :), 1, 2));
    
    direction = atan2(alpha(2, :), alpha(1, :));
    
    curvature = diff(direction);
    curvature = mod(curvature + pi, 2*pi) - pi;
    
    beta_1 = alpha(1, 1:end-2) .* alpha(1, 3:end) + alpha(2, 1:end-2) .* alpha(2, 3:end);
    beta_2 = alpha(1, 1:end-2) .* alpha(2, 3:end) - alpha(2, 1:end-2) .* alpha(1, 3:end);
    beta = normc([beta_1; beta_2]);
    
    features = [alpha(1, 2:end-1); ...
                alpha(2, 2:end-1); ...
                beta(1, :); ...
                beta(2, :); ...
                height(2:end-2); ...
                direction(2:end-1); ...
                curvature(2:end); ...
                data(3, 2:end-2); ...
                ];
    
end