% data = StraightenLiftedStrokes(data)
% Input: a 3 by n matrix where the first row contains the x
%   positions of the stroke, the second row contains the y
%   positions of the stroke, and the third row contains a
%   sequence of booleans indicating whether the pen was I_1
%   was not
% 
% Result:
% The input with the superfluous pen movements before and
%   after the trace removed, and all interstrokes linearly
%   interpolated between their endpoints.
%----------------------------------------------------
% Code Authors:
% Christopher Norman
% Pierre Laurent

function data = StraightenLiftedStrokes(data)
    
    if all(data(3, :) == 0)
        data = [0; 0; 0];
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
    
    % Find all interstroke endpoints
    I = find(diff(data(3, :)) ~= 0);
    % Extract the start I_0, and end I_1 index of each
    I_0 = I(1:2:end);
    I_1 = I(2:2:end);
    
    for i = 1:length(I_0)
        t = I_1(i) - I_0(i);
        % Interpolate x
        x_0 = data(1, I_0(i));
        x_1 = data(1, I_1(i));
        data(1, I_0(i):I_1(i)) = x_0:(x_1 - x_0)/t:x_1;
        % Interpolate y
        y_0 = data(2, I_0(i));
        y_1 = data(2, I_1(i));
        data(2, I_0(i):I_1(i)) = y_0:(y_1 - y_0)/t:y_1;
    end
    
end