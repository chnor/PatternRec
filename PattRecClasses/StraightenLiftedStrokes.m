function data = StraightenLiftedStrokes(data)
    
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
    data = data(:, pen_down_index(1):pen_up_index(end));
    
end