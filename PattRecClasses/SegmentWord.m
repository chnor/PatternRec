
function segmented_data = SegmentWord(data)
    
    rects = CollapseRects(ExtractStrokeBounds(data));
    % We have four conditions to confirm that each point falls
    % inside each rect, one for each side of each rect.
    % Construct each as a logical matrix where the entry at (i, j)
    % is 1 iff point j falls inside rect i.
    c_1 = bsxfun(@(x_i, x_0) x_0 <= x_i, data(1, :), rects(:, 1));
    c_2 = bsxfun(@(x_i, x_1) x_1 >= x_i, data(1, :), rects(:, 3));
    c_3 = bsxfun(@(y_i, y_0) y_0 <= y_i, data(2, :), rects(:, 2));
    c_4 = bsxfun(@(y_i, y_1) y_1 >= y_i, data(2, :), rects(:, 4));
    % The point is inside the rect if it fulfills all 4 conditions:
    c = c_1 & c_2 & c_3 & c_4;
    % Assume that the rects are non-overlapping (should be
    % guaranteed by CollapseRects), then each points can only fall
    % inside one rect. Determine which rect (the index) each points
    % falls inside.
    [~, c] = max(c, [], 1);
    
    segmented_data = cell(1, size(rects, 1));
    for i = 1:size(rects, 1)
        segmented_data{i} = data(:, c == i);
    end
    
end