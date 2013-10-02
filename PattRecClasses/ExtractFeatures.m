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
%   row 5 contains the x position normalized to the bounding
%       box of the character
%   row 6 contains the y position normalized to the bounding
%       box of the character
%   row 7 contains the angle of the tangents in radians
%   row 8 contains the angular velocity of the tangents in radians
%----------------------------------------------------
% Code Authors:
% Christopher Norman
% Pierre Laurent

function [features] = ExtractFeatures(data)
    % Preprocess
    
    % Interpolate interstrokes (not used)
    % data = StraightenLiftedStrokes(data);
    
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
    
    width = data(1, :);
    if any(data(3, :) == 1) % Any strokes?
        min_width = min(width(data(3, :) == 1));
        max_width = max(width(data(3, :) == 1));
        width = (width - min_width) / (max_width - min_width);
    end
    
    % cos(theta), sin(theta)
    alpha = normc(diff(data(1:2, :), 1, 2));
    
    % theta
    direction = atan2(alpha(2, :), alpha(1, :));
    
    % delta theta
    curvature = diff(direction);
    curvature = mod(curvature + pi, 2*pi) - pi;
    
    % cos(delta theta), sin(delta theta)
    beta_1 = alpha(1, 1:end-2) .* alpha(1, 3:end) + alpha(2, 1:end-2) .* alpha(2, 3:end);
    beta_2 = alpha(1, 1:end-2) .* alpha(2, 3:end) - alpha(2, 1:end-2) .* alpha(1, 3:end);
    beta = normc([beta_1; beta_2]);
    
    features = [alpha(1, 2:end-1); ...
                alpha(2, 2:end-1); ...
                beta(1, :); ...
                beta(2, :); ...
                width(2:end-2); ...
                height(2:end-2); ...
                direction(2:end-1); ...
                curvature(2:end); ...
                ];
    
    % Exclude non-strokes
    features = features(:, data(3, 2:end-2) ~= 0);
    
end