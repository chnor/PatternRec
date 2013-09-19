function [features] = ExtractFeatures(data)
    
%     pen_up_down_index = find(diff(data(3, :)) ~= 0);
%     pen_down_index = pen_up_down_index(1:2:end);
%     pen_down_index = [pen_down_index, size(data, 2)];
%     pen_up_index = pen_up_down_index(2:2:end);
%     pen_up_index = [1, pen_up_index];
%     for i = 1:length(pen_up_index)
%         t = pen_down_index(i) - pen_up_index(i);
%         x_0 = data(1, pen_up_index(i));
%         x_1 = data(1, pen_down_index(i));
%         data(1, pen_up_index(i):pen_down_index(i)) = x_0:(x_1 - x_0)/t:x_1;
%         y_0 = data(2, pen_up_index(i));
%         y_1 = data(2, pen_down_index(i));
%         data(2, pen_up_index(i):pen_down_index(i)) = y_0:(y_1 - y_0)/t:y_1;
%     end
%     data = data(:, pen_down_index(1):pen_up_index(end));
    
    data(1, :) = smooth(data(1, :))'; %smoothing the data using a 5-point method average
    data(2, :) = smooth(data(2, :))';
    
    height = data(2, :); % return all the y-coordinates of the mouse in time.
    min_height = min(height(data(3, :) == 1)); % the lowest coordinate for drawn portion.
    max_height = max(height(data(3, :) == 1));% the highest "
    height = (height - min_height) / (max_height - min_height); % normalization
    
    delta = diff(data(1:2, :), 1, 2);
    delta(1, :) = smooth(delta(1, :))' ./ (max(delta(1, :)) - min(delta(1, :)));
    delta(2, :) = smooth(delta(2, :))' ./ (max(delta(2, :)) - min(delta(2, :)));
%     delta(1, :) = smooth(delta(1, :))' ./ sqrt(delta(1, :).^2 + delta(2, :).^2);
%     delta(2, :) = smooth(delta(2, :))' ./ sqrt(delta(1, :).^2 + delta(2, :).^2);
    velocity = sqrt(delta(1, :).^2 + delta(2, :).^2);
    velocity = velocity / max(velocity);
    direction = smooth(atan2(delta(2, :), delta(1, :)))';
    curvature = diff(direction);
    curvature = mod(curvature + pi, 2*pi) - pi;
    beta_1 = delta(1, 1:end-2) .* delta(1, 3:end) + delta(2, 1:end-2) .* delta(2, 3:end);
    beta_2 = delta(1, 1:end-2) .* delta(2, 3:end) - delta(2, 1:end-2) .* delta(1, 3:end);
%     delta_2 = diff(delta, 1, 2);
%     curvature = (delta(1, 2:end).*delta_2(2, :) - delta(2, 2:end).*delta_2(1, :)) / nthroot(delta(1, 2:end).^2 + delta(2, 2:end).^2, 3/2);
    torsion = diff(curvature);
%     torsion(abs(torsion) > 0.5) = 0;
    
    % TODO sine and cosine of direction, see
    % S. Jaeger, S. Manke, J. Reichert, and A. Waibel. Online
    % Handwriting Recognition: The NPen++ Recognizer.
    % (ref for both angle and curvature)
    
    % TODO Normalized derivatives? see
    % M. Pastor, A. Toselli, and E. Vidal. Writing Speed Nor-
    % malization for On-Line Handwritten Text Recognition
    % These are of course equivalent but aren't dicontinuous
    % unlike the angle we get from atan2
    
    % Height is from
    % Bharath A, Sriganesh Madhvanath. Hidden Markov Models
    % for Online Handwritten Tamil Word Recognition
    
    features = [direction(3:end); ...
                curvature(2:end); ...
                torsion(1:end); ...
                delta(1, 3:end) ./ sqrt(delta(1, 3:end).^2 + delta(2, 3:end).^2); ...
                delta(2, 3:end) ./ sqrt(delta(1, 3:end).^2 + delta(2, 3:end).^2); ...
                beta_1 ./ sqrt(beta_1.^2 + beta_2.^2); ...
                beta_2 ./ sqrt(beta_1.^2 + beta_2.^2); ...
                velocity(3:end); ...
                height(4:end); ...
                ];
    
    
    features(:, data(3, :) == 0) = 0;
    
    % % To run:
    % P = ExtractFeatures(DrawCharacter);
    % t = 1:size(P, 2);
    % plot(t, P(4, :), t, P(5, :)); % Example: plot delta_1 and delta_2
    % axis([0, size(P, 2), -1.2, 1.2]);
    
end