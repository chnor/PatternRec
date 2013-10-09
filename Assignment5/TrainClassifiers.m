% Train classifiers for each character in data set
% Input:
%   classes: (optional) the characters to use
% Output:
%   Classifier: a stuct containing:
%       HMMs: a cell array of HMMs that recognize each character
%       classes: the class label for the corresponding HMM
%       features: used features
%   R:    a cell array of the ROC curves for each HMM

function [Classifier, R] = TrainClassifiers(classes)
    
    [data, chars] = LoadData;
    if nargin < 1
        classes = unique(chars, 'stable');
    end
    
    % Set number of states (strokes) for each character
    n = 4*ones(size(classes)); % Default (good for most characters)
    % Tweak for some characters:
%     n(ismember(classes, 'B')) = 3;
    n(ismember(classes, 'M')) = 6;
%     n(ismember(classes, 'Z')) = 3;
%     n(ismember(classes, 'o')) = 1;
%     n(ismember(classes, 's')) = 1;
    
    features_to_use = 1:6;
    [HMMs, R] = TrainModel(data, chars, n, classes, features_to_use, 0.3);
    Classifier.HMMs = HMMs;
    Classifier.classes = classes;
    Classifier.features = features_to_use;
    
end