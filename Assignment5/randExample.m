function randExample (trainingSet, characterToPlot)

%Input:
%trainingSet that you can find using the TrainClassifiersPierre function.
%Structure containing the HMMs, and the classes objects.
%
%----------------------------------------------------
%Code Authors:
% Pierre Laurent
% Christopher Norman
%----------------------------------------------------
vectorSize = 10000;
HMMs = trainingSet.HMMs;
classes = trainingSet.classes;
A = [HMMs{1,:}];


for i=1:9
    randVec{i} = rand(HMMs{characterToPlot}, vectorSize);
end

combinedStr = strcat({'Plotting rand vectors obtained from source:'}, {' '}, classes(characterToPlot));
figure('Name',combinedStr{1},'NumberTitle','off')


for i = 1:9
    subplot(3,3,i)
    x = 1:size(HMMs, 2);
    stem(x, logprob(A, randVec{i}))
    set(gca, 'XtickLabel', classes);
    set(gca, 'Xtick', 1:size(HMMs, 2));
    xlabel ('HMM index');
    ylabel ('logprob(X, HMM)');
end

end

