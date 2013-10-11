% Train classifiers for each character in data set
% Input:
%   frac: (optional) The percentage of samples to use for 
%       training (default: 0.3)
%   ITER: (optional) The number of trials for training (default: 3)
%   classes: (optional) the characters to use
% Output:
%   Classifier: a stuct containing:
%       HMMs: a cell array of HMMs that recognize each character
%       classes: the class label for the corresponding HMM
%   R:    a cell array of the ROC curves for each HMM

function [Classifier, R] = TrainClassifiers(frac, ITER, classes)
    
    [data, chars] = LoadData;
    if nargin < 1
        frac = 0.3;
    end
    if nargin < 2
        ITER = 3;
    end
    if nargin < 3
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
    
    [HMMs, R] = TrainModel(data, chars, n, classes, frac, ITER);
    Classifier.HMMs     = HMMs;
    Classifier.classes  = classes;
    
end