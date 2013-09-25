function [data, chars] = ReadUCIPen(filename)
    file = fopen(filename);
    
    data = cell(1, 11640);
    chars = cell(1, 11640);
    while ~feof(file)
        
        line = fgets(file);
        while strcmp(line(1:2), '//')
            line = fgets(file);
        end
        
        code = sscanf(line, 'WORD %s %*s \n');
        name = sscanf(line, 'WORD %*s %s \n');
        disp(['Reading ', name, ' ', code]);
        fscanf(file, '\n');
        numstrokes = fscanf(file, 'NUMSTROKES %d\n');
        P = [];
        for s = 1:numstrokes
            numpoints = fscanf(file, 'POINTS %i #');
            p = fscanf(file, '%d \n');
%             p = [p(1:2:end)'; p(2:2:end)'];
            p = reshape(p, [2, numpoints]);
            p = [p; ones(size(p(1, :)))];
            if numel(P) ~= 0
                if P(1, end) == p(1, 1)
                    x_0 = P(1, end)*ones(1, 11);
                else
                    x_0 = [P(1, end):(p(1, 1)-P(1, end))/10:p(1, 1)];
                end
                if P(2, end) == p(2, 1)
                    y_0 = P(2, end)*ones(1, 11);
                else
                    y_0 = [P(2, end):(p(2, 1)-P(2, end))/10:p(2, 1)];
                end
                P = [P [x_0; y_0; zeros(size(x_0))]];
            end
            P = [P p];
        end
        max_x = max(P(1, :));
        min_x = min(P(1, :));
        max_y = max(P(2, :));
        min_y = min(P(2, :));
        P(1, :) = (P(1, :) - min_x) / (max_x - min_x);
        P(2, :) = (P(2, :) - min_y) / (max_y - min_y);
        P(2, :) = 1 - P(2, :);
        data{length(data) + 1} = P;
        chars{length(chars) + 1} = code;
    end
    
end