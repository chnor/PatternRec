
function DrawRects(rects, color)
    hold on;
    for rect = rects'
        x = rect(1);
        y = rect(2);
        w = rect(3) - x;
        h = rect(4) - y;
        plot(x + [0 w w 0 0], ...
             y + [0 0 h h 0], color);
    end
    hold off;
end