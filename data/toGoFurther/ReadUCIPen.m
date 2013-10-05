function [data, chars] = ReadUCIPen(filename, verbose)
    
    file = fopen(filename);
    if nargin < 2
        verbose = false;
    end
    
    % Preallocating isn't possible since we don't
    % know how many examples there are in the file
    % Do the next best thing
    block_size = 10000;
    data = cell(1, block_size);
    chars = cell(1, block_size);
    
    % Suppress warnings about array growth
    %#ok<*AGROW>
    
    i = 0;
    while ~feof(file)
        % Eat up all comment lines
        line = fgets(file);
        while strcmp(line(1:2), '//')
            line = fgets(file);
        end
        
        code = sscanf(line, 'WORD %s %*s \n');
        % We might want to check for bad formatting here.
        % For now we simply assume that the file has the
        % correct format.
        if verbose
            name = sscanf(line, 'WORD %*s %s \n');
            disp(['Reading ', name, ' ', code]);
        end
        
        i = i + 1;
        if i == length(data)
            % Output buffer filled up: Reallocate
            % Reallocation only triggers once the buffer
            % is filled but Matlab doesn't know that
            % so we get warnings about array growth here
            % if we don't suppress them
            block_size = 2*block_size;
            data = [data, cell(1, block_size)];
            chars = [chars, cell(1, block_size)];
        end
        
        fscanf(file, '\n');
        numstrokes = fscanf(file, 'NUMSTROKES %d\n');
        % Array growing is actually faster than constructing
        % a cell array with 2*numstrokes - 1 matrices and
        % transforming it into a single matrix with cell2mat
        P = [];
        for s = 1:numstrokes
            numpoints = fscanf(file, 'POINTS %i #');
            p = fscanf(file, '%d \n');
            p = reshape(p, [2, numpoints]); % Breaks implicitly if numpoints is incorrect
            p = [p; ones(size(p(1, :)))];
            if numel(P) ~= 0 % If not the first stroke
                % Also construct an interstroke from the end
                % of the last stroke to the start of this one
                last_x = P(1, end);
                last_y = P(2, end);
                next_x = p(1, 1);
                next_y = p(2, 1);
                steps = 10;
                if last_x == next_x
                    x_0 = last_x * ones(1, steps);
                else
                    x_0 = last_x:(next_x-last_x)/(steps-1):next_x;
                end
                if last_y == next_y
                    y_0 = last_y*ones(1, steps);
                else
                    y_0 = last_y:(next_y-last_y)/(steps-1):next_y;
                end
                P = [P [x_0; y_0; zeros(size(x_0))]];
            end
            P = [P p];
        end
        % Normalize x and y in [0, 1]
        max_x = max(P(1, :));
        min_x = min(P(1, :));
        max_y = max(P(2, :));
        min_y = min(P(2, :));
        P(1, :) = (P(1, :) - min_x) / (max_x - min_x);
        P(2, :) = (P(2, :) - min_y) / (max_y - min_y);
        P(2, :) = 1 - P(2, :);
        
        data{i} = P;
        chars{i} = code;
    end
    disp(['Read ', num2str(i), ' examples from file']);
    
    data = data(1:i);
    chars = chars(1:i);
    
end