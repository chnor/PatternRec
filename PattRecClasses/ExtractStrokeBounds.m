function R = ExtractStrokeBounds(data)
    
    if all(data(3, :) == 0)
        R = zeros(0, 4);
        return;
    end
    
    % Extract the data between the start of the trace s_0
    % and the end of the trace s_1
    if (data(3, 1) == 0)
        s_0 = find(diff(data(3, :)) ~= 0, 1, 'first') + 1;
    else
        s_0 = 1;
    end
    if (data(3, end) == 0)
        s_1 = find(diff(data(3, :)) ~= 0, 1, 'last');
    else
        s_1 = size(data, 2) - 1;
    end
    data = data(:, s_0:s_1);
    
    % Find all stroke endpoints except the first and last
    I = find(diff(data(3, :)) ~= 0);
    % Extract the start I_1, and end I_0 index of each
    I_1 = I(1:2:end);
    I_0 = I(2:2:end);
    % Add initial down:
    I_0 = [1, I_0];
    % Add terminal up:
    I_1 = [I_1, size(data, 2)];
    
    % Use global min/max y
    y_0 = min(data(2, :));
    y_1 = max(data(2, :));
    
    R = zeros(size(I_0, 1), 4);
    for i = 1:length(I_1)
        stroke = data(1:2, I_0(i):I_1(i));
        x_0 = min(stroke(1, :));
        x_1 = max(stroke(1, :));
        R(i, :) = [x_0, y_0, x_1, y_1];
    end
    
end