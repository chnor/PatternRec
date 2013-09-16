function [features] = ExtractFeatures(data)
    
    pen_up_down_index = find(diff(data(3, :)) ~= 0);
    pen_down_index = pen_up_down_index(1:2:end);
    pen_down_index = [pen_down_index, size(data, 2)];
    pen_up_index = pen_up_down_index(2:2:end);
    pen_up_index = [1, pen_up_index];
    for i = 1:length(pen_up_index)
        t = pen_down_index(i) - pen_up_index(i);
        x_0 = data(1, pen_up_index(i));
        x_1 = data(1, pen_down_index(i));
        data(1, pen_up_index(i):pen_down_index(i)) = x_0:(x_1 - x_0)/t:x_1;
        y_0 = data(2, pen_up_index(i));
        y_1 = data(2, pen_down_index(i));
        data(2, pen_up_index(i):pen_down_index(i)) = y_0:(y_1 - y_0)/t:y_1;
    end
%     data = data(:, pen_down_index(1):pen_up_index(end));
    
    delta = diff(data(1:2, :), 1, 2);
    angles = smooth(atan2(delta(2, :), delta(1, :)))';
    diff_angles = diff(angles);
    diff_angles = mod(diff_angles + pi, 2*pi) - pi;
    diff_2_angles = diff(diff_angles);
    diff_2_angles(abs(diff_2_angles) > 0.5) = 0;
    
    features = [angles(3:end); diff_angles(2:end); diff_2_angles(1:end); delta(1, 3:end); delta(2, 3:end)];
    
end