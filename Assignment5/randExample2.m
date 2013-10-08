function randExample (trainingSet)

%Input:
%HMMs that you can find using the TrainClassifiers function
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
    randVec{i} = rand(HMMs{i}, vectorSize);
end

figure('Name','Plotting rand vectors obtained from each source','NumberTitle','off')


for i = 1:9
    x = 1 : size(HMMs, 2);
    subplot(3,3,i)
    stem(x, logprob(A, randVec{i}));
    set(gca, 'XtickLabel', classes);
    set(gca, 'Xtick', 1:size(HMMs, 2));
    xlabel ('HMM index');
    ylabel ('logprob(X, HMM)');
    title (classes(i))
end




end

