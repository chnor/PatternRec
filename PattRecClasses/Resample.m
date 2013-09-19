function R = Resample(data, distance, METHOD)
    
    addpath('PattRecClasses/external');
    
    % Find stroke boundaries
    ud = find(diff(data(3, :)) ~= 0);
    ud = [1, ud, size(data, 2)];
    R = [];
    % TODO do another loop to preallocate R
    for i = 1:length(ud)-1
        stroke = data(1:2, ud(i):ud(i+1));
        total_path_length = sum(sqrt(stroke(1, :).^2 + stroke(2, :).^2));
        n = floor(total_path_length / distance);
        stroke = interparc(n, stroke(1, :), stroke(2, :), METHOD)';
        if data(3, ud(i)+1) == 1
            R_1 = [stroke; ones(1, size(stroke, 2))];
        else
            R_1 = [stroke; zeros(1, size(stroke, 2))];
        end
        R = [R, R_1];
    end
    
end