function ExtractorPlotted (data)

close all
figure
t = 1:size(data,2);
plot(t, data(1, :), t, data(2, :));
axis([0, size(data, 2), -1.2, 1.2]);

pop = uicontrol('Style', 'popup',...
    'String', 'direction|curvature|torsion|delta_x|delta_y|beta_1|beta_2|velocity|height',...
    'Position', [20 340 100 50],...
    'Callback', {@setmap, data, t});    


slide = uicontrol('Style', 'slider',...
    'Min',1,'Max',9,'Value',1,...
    'SliderStep',[1 .125],...
    'Position', [400 20 120 20],...
    'Callback', {@secondPlot, data, pop, t});

uicontrol('Style','text',...
    'Position',[400 45 120 20],...
    'String', 'direction');

end


function [val] = setmap(hObj,event, data, t) 
val = get(hObj,'Value');
plot(t, data(val, :), t, data(1, :));
axis([0, size(data, 2), -1.2, 1.2]);
end

function secondPlot(hObj,event, data, pop, t) 
firstPlot = get(pop, 'Value');
val = round(get(hObj,'Value'));
plot(t, data(firstPlot, :), t, data(val, :));
axis([0, size(data, 2), -1.2, 1.2]);

switch val
    case 1
        type = 'direction';
    case 2
        type = 'curvature';
    case 3
        type = 'torsion';
    case 4
        type = 'delta_x';
    case 5
        type = 'delta_y';
    case 6
        type = 'beta_1';
    case 7
        type = 'beta_2';
    case 8
        type = 'velocity';
    case 9
        type = 'height';
        
end

uicontrol('Style','text',...
    'Position',[400 45 120 20],...
    'String', type);

end