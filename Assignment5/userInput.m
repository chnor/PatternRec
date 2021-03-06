% Get input from user and return the most likely character
% Input:
%   Classifier: stuct containing:
%       - HMMs: a cell array of HMMs that recognize each character
%       - classes: the class label for the corresponding HMM
%       - features: used features
% Output:
%   char: The label of the decided character

function char = userInput(Classifier)
    
    HMMs        = Classifier.HMMs;
    classes     = Classifier.classes;

    character = DrawCharacter();
    character = PreprocessData(character);
    proba = logprob([HMMs{1,:}], character);
    [~, index] = max(proba);
    
    char = classes(index);
    
end
