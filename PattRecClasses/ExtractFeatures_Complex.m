function [features, path_angles] = ExtractFeatures_Complex(data)
    
    pen_up_down_index = find(diff(data(3, :)) ~= 0);
    pen_up_down_index = pen_up_down_index + 1;
    if data(3, 1) == 1
        pen_up_down_index = [1, pen_up_down_index];
    end
    if data(3, end) == 1
        pen_up_down_index = [pen_up_down_index, size(data, 2)];
    end
    pen_down_index = pen_up_down_index(1:2:end);
    pen_up_index = pen_up_down_index(2:2:end);
    
    pressure = data(3, pen_up_down_index(1:end-1));
    
    raw_strokes = data(:, pen_up_down_index);
    strokes = diff(raw_strokes(1:2, :), 1, 2);
    angles = atan2(strokes(2, :), strokes(1, :));
%     angles = angles - mean(angles);
    lengths = sqrt(strokes(1, :).^2 + strokes(2, :).^2);
    lengths(2:end) = lengths(2:end) / max(lengths);
    
    % TODO watch for zero lengths
    
    pos_angles = zeros(size(lengths));
    neg_angles = zeros(size(lengths));
    for i = 1:(length(pen_up_down_index) - 1)
        if pressure(i) == 0
            continue;
        end
        path = data(1:2, pen_up_down_index(i):(pen_up_down_index(i+1)));
        path(1, :) = path(1, :) - path(1, 1);
        path(2, :) = path(2, :) - path(2, 1);
        line = path(:, end) - path(:, 1);
        line = [0 -1; 1 0]*line;
        line = line / sqrt(line(1)^2 + line(2)^2);
        response = line' * path / sqrt(path(1, end).^2 + path(2, end).^2);
        pos_angles(i) = max(response);
        neg_angles(i) = abs(min(response));
    end
    
    features = [angles; lengths; pos_angles; neg_angles; pressure];
    
end