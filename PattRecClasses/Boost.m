function [HMM, Cparams] = Boost(data, labels, used_features, T, ITER)
    
	features = cell(1, length(data));
    for i = 1:length(data)
        f = ExtractFeatures(data{i});
        features{i} = f(used_features, :);
    end
    
    Cparams = cell(1, length(unique(labels)));
    HMM = cell(1, length(unique(labels)));
    
    n = 0;
    for label = unique(labels)
        n = n + 1;
        ys = ismember(labels, label);
        % TODO: Use separate test set!
        training_set = features(ys);
        h = cell(1, ITER);
        fs = zeros(length(data), ITER);
        for i = 1:ITER
            disp(['Generating candidate HMM no ', num2str(i)]);
            h{i} = Train(training_set, training_set, 4, 30);
            fs(:, i) = cellfun(@(x) -logprob(h{i}, x), features)';
        end
        Cparams{n} = BoostingAlg(fs, ys', T);
        HMM{n} = h;
    end
    
end