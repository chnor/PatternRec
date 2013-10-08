function randExample (HMMs)

%Input:
%HMMs that you can find using the TrainClassifiers function
%
%----------------------------------------------------
%Code Authors:
% Pierre Laurent
% Christopher Norman
%----------------------------------------------------
vectorSize = 10000;
A = [HMMs{1,:}];


for i=1:9
randVec{i} = rand(HMMs{i}, vectorSize);
end

 figure('Name','Plotting rand vectors obtained from each source','NumberTitle','off')


for i = 1:9
    subplot(3,3,i)
    stem(logprob(A, randVec{i}))
    xlabel ('HMM index');
    ylabel ('logprob(X, HMM)');
end




end

