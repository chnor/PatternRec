function userInput(Classifier, characterToMatrix)

%Input:
%   Classifier: stuct containing:
%       - HMMs: a cell array of HMMs that recognize each character
%       - classes: the class label for the corresponding HMM
%       - features: used features
%   characterToMatrix: the character you will display, so that the
%                      Confusion Matrix will be displayed

HMMs        = Classifier.HMMs;
classes     = Classifier.classes;
features    = Classifier.features;

character = DrawCharacter();
character = ExtractFeatures(character);
proba = logprob([HMMs{1,:}], character(features,:));
[~, index] = max(proba);

disp(['Written letter: ', classes(index)]);

%Improvement: - allow the db length to vary.
%             - Display the letters which are not in the diagonal and create
%               confusion

if nargin == 2
    
    savefile = 'confusionMatrix.mat';
    finder = cell2mat(classes);
    index2 = strfind(finder, characterToMatrix);
    
    if exist(savefile) == 2
        data = load(savefile);
        confusionMatrix = data.confusionMatrix;
        confusionMatrix(index, index2) = confusionMatrix(index, index2) + 1;
        
    else
        length = size (classes, 2);
        confusionMatrix = zeros(length, length);
        confusionMatrix (index, index2) = 1;
        
    end
    save(savefile, 'confusionMatrix');
end

end
