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
    n = repmat(4, size(classes)); % Default (good for most characters)
    % Tweak for some characters:
%     n(ismember(classes, 'B')) = 3;
    n(ismember(classes, 'M')) = 6;
%     n(ismember(classes, 'Z')) = 3;
%     n(ismember(classes, 'o')) = 1;
%     n(ismember(classes, 's')) = 1;
    
    priors = zeros(size(classes));
    for i = 1:length(classes)
        priors(i) = sum(ismember(chars, classes(i))) / length(chars);
    end
    % Priors for lower case: taken from
    % http://en.wikipedia.org/wiki/Letter_frequency#Relative_frequencies_of_letters_in_the_English_language
    priors(ismember(classes, 'a')) = 0.08167;
    priors(ismember(classes, 'b')) = 0.01492;
    priors(ismember(classes, 'c')) = 0.02782;
    priors(ismember(classes, 'd')) = 0.04253;
    priors(ismember(classes, 'e')) = 0.12702;
    priors(ismember(classes, 'f')) = 0.02228;
    priors(ismember(classes, 'g')) = 0.02015;
    priors(ismember(classes, 'h')) = 0.06094;
    priors(ismember(classes, 'i')) = 0.06966;
    priors(ismember(classes, 'j')) = 0.00153;
    priors(ismember(classes, 'k')) = 0.00772;
    priors(ismember(classes, 'l')) = 0.04025;
    priors(ismember(classes, 'm')) = 0.02406;
    priors(ismember(classes, 'n')) = 0.06749;
    priors(ismember(classes, 'o')) = 0.07507;
    priors(ismember(classes, 'p')) = 0.01929;
    priors(ismember(classes, 'q')) = 0.00095;
    priors(ismember(classes, 'r')) = 0.05987;
    priors(ismember(classes, 's')) = 0.06327;
    priors(ismember(classes, 't')) = 0.09056;
    priors(ismember(classes, 'u')) = 0.02758;
    priors(ismember(classes, 'v')) = 0.00978;
    priors(ismember(classes, 'w')) = 0.02360;
    priors(ismember(classes, 'x')) = 0.00150;
    priors(ismember(classes, 'y')) = 0.01974;
    priors(ismember(classes, 'z')) = 0.00074;
    % Priors for upper case: ignore for now
    
    [HMMs, R, thetas, ppv, npv] = TrainModel(data, chars, n, classes, priors, frac, ITER);
    Classifier.HMMs     = HMMs;
    Classifier.classes  = classes;
    Classifier.thetas   = thetas;
    Classifier.priors   = priors;
    Classifier.pos_acc  = ppv;
    Classifier.neg_acc  = npv;
    
end