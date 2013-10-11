% Train HMM using AdaBoost
% Input:
%   data:           training data
%   labels:         labels for the data
%   used_features:  array containing the features to use (indices)
%   T:              number of weak classifiers
%   ITER:           number of iterations
% Output:
%   HMM: all candidate HMMs created during training
%   Cparams: struct containing:
%       alphas: the weight for each HMM
%       Thetas: the HMM indices, thresholds, and parities
%       thresh: the optimal boosting threshold

function [HMM, Cparams] = Boost(data, labels, m, T)
    
	features = cell(1, length(data));
    for i = 1:length(data)
        features{i} = PreprocessData(data{i});
    end
    
    Cparams = cell(1, length(unique(labels)));
    HMM = cell(1, length(unique(labels)));
    
    n = 0;
    for label = unique(labels)
        n = n + 1;
        ys = ismember(labels, label);
        training_set = features(ys);
        h = cell(1, length(training_set));
        fs = zeros(length(data), length(training_set));
        for i = 1:length(training_set)
            disp(['Generating candidate HMM no ', num2str(i)]);
            h{i} = Train(training_set(i), training_set(i), m, 30);
            fs(:, i) = cellfun(@(x) -logprob(h{i}, x), features)';
        end
        Cparams{n} = BoostingAlg(fs, ys', T);
        HMM{n} = h;
    end
    
end