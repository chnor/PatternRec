
function new_rects = CollapseRects(rects)
    
    x_0 = rects(:, 1);
    y_0 = rects(:, 2);
    x_1 = rects(:, 3);
    y_1 = rects(:, 4);
    xywh = [x_0, y_0, x_1 - x_0, y_1 - y_0];
    D = sparse(rectint(xywh, xywh));
    [S, C] = graphconncomp(D);
    
    new_rects = zeros(S, 4);
    for i = 1:S
        x_0 = min(rects(C == i, 1));
        y_0 = min(rects(C == i, 2));
        x_1 = min(rects(C == i, 1) + rects(C == i, 3));
        y_1 = min(rects(C == i, 2) + rects(C == i, 4));
        new_rects(i, :) = [x_0, y_0, x_1 - x_0, y_1 - y_0];
    end
    
end