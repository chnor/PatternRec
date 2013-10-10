function confusionMatrix(Classifier, name)

%Default values:
    HMMs        = Classifier.HMMs;
    classes     = Classifier.classes;
    features    = Classifier.features;
%Initialization values:
[charMatrix charTest] = LoadData;%Can uppload another db
%A = cellfun(@ExtractFeatures,charMatrix,'UniformOutput',false);
% redundancy, as it can be done in the loop
length = size(charMatrix ,2); %this calculate the number of elements in our database
Matrix = zeros(size(classes,2), size(classes,2));

for i=1:length
    
    %From user input
    character = ExtractFeatures(charMatrix{i});
    proba = logprob([HMMs{1,:}], character(features,:));
    [~, index] = max(proba);
    charwritten = classes(index);
    
    %From our db
    trueChar = charTest(i);
    index2 = find(ismember(classes,trueChar));
    
    Matrix(index, index2) = Matrix(index, index2) + 1;
    
    
end

save(name, 'Matrix');
end
