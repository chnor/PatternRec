% Train classifiers for each character in data set
% Input:
%   classes: (optional) the characters to use
% Output:
%   HMMs: a cell array of HMMs that recognize each character
%   R:    a cell array of the ROC curves for each HMM

function [HMMs, R] = TrainClassifiers(classes)
    
    [data, chars] = LoadData;
    if nargin < 1
        classes = unique(chars);
    end
    
    % Set number of states (strokes) for each character
    n = 4*ones(size(classes)); % Default (good for most characters)
    % Tweak for some characters:
%     n(ismember(classes, 'B')) = 3;
    n(ismember(classes, 'M')) = 6;
%     n(ismember(classes, 'Z')) = 3;
%     n(ismember(classes, 'o')) = 1;
%     n(ismember(classes, 's')) = 1;
    
    [HMMs, R] = TrainModel(data, chars, n, classes, 1:6);
    
end