function [HMMs, R] = TrainModel(data, labels, n, classes, used_features)
    
    assert(all(size(data) == size(labels)));
    assert(all(size(n) == size(classes)));
    
    data_to_use = zeros(size(labels));
    for class = classes
        data_to_use = data_to_use | ismember(labels, class);
    end
    assert(sum(data_to_use) > 0);
    data = data(data_to_use);
    labels = labels(data_to_use);
    
    split_data = cell(1, length(classes));
    for i = 1:length(classes)
        split_data{i} = data(ismember(labels, classes(i)));
    end
    
    disp('Extracting features');
    split_features = cell(1, length(classes));
    for i = 1:length(split_data)
        split_features{i} = cell(1, length(split_data{i}));
        for j = 1:length(split_data{i})
            split_features{i}{j} = ExtractFeatures(split_data{i}{j});
            split_features{i}{j} = split_features{i}{j}(used_features, :);
        end
    end
    
    HMMs = cell(1, length(classes));
    R = cell(1, length(classes));
    for i = 1:length(split_features)
        disp(['Training model for class: ', classes(i)]);
        HMMs{i} = Train(split_features{i}, split_features{i}, n(i), 20);
        
        response = cell(1, length(classes));
        for j = 1:length(split_features)
            response{j} = cellfun(@(f) -logprob(HMMs{i}, f), split_features{j});
        end
        
        disp('Plotting ROC');
        positive = cell2mat(response(ismember(classes, classes(i))));
        negative = cell2mat(response(~ismember(classes, classes(i))));
        ComputeROC(positive(:), negative(:));
        drawnow;
        R{i} = response;
    end
    
end