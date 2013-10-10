function matrixAnalysis (Matrix, Classifier)
%
%----------------------------------------------------
%Code Authors:
% Pierre Laurent
% Christopher Norman
%----------------------------------------------------
%Default values:
classes = Classifier.classes;

for i=1:size(Matrix,1)
    trueAnswer(i) = Matrix(i,i)/sum(Matrix(:,i))*100;
end


figure('Name','Percentage of good classification ','NumberTitle','off')
bar(1:20,trueAnswer, 'stacked')
set(gca, 'XtickLabel', classes);
set(gca, 'Xtick', 1:size(classes, 2));
set(gca,'XLim',[0 size(trueAnswer,2)+1]);
xlabel ('Character');
ylabel ('%');
average = sum(trueAnswer)/(size(trueAnswer,2));

addAverage = strcat({'Average:'}, {' '}, num2str(average), {'%'});
title (addAverage);


figure('Name','Repartition for each source','NumberTitle','off')
a =  find(Matrix(:,1)>0);
pie3(Matrix(a, 1)); legend(classes(a));
title ('Source: a');
% Create a uicontrol with a pop-up menu and a Callback
uicontrol('Style', 'popup',...
    'String', classes,...
    'Position', [20 340 100 50],...
    'Callback', {@setmap, Matrix, classes});


    function setmap(hObj,event, Matrix, classes)
        %Called when user activates popup menu
        val = get(hObj,'Value');
        a =  find(Matrix(:,val)>0);
        combinedStr = strcat({'Source:'}, {' '}, classes(val));
        pie3(Matrix(a, val)); legend(classes(a));
        title (combinedStr);
        
    end

end

