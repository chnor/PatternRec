function [HMMs, R] = TrainModel(data, labels, n, classes, frac, ITER)
    
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
            split_features{i}{j} = PreprocessData(split_data{i}{j});
        end
    end
    
    HMMs = cell(1, length(classes));
    R = cell(1, length(classes));
    for i = 1:length(split_features)
        disp(['Training model for class: ', classes{i}]);
        
        AUC_opt = 0;
        
        for iter = 1:ITER
            f = split_features{i};
            num_f = size(split_features{i}, 2);
            f = f(randperm(num_f));
            training_set = f(1:floor(frac*num_f));
            testing_set = f(floor(frac*num_f)+1:end);
            h = Train(training_set, testing_set, n(i), 20);
            
%             disp('Training finished, calculating cross-class response');
            response = cell(1, length(classes));
            for j = 1:length(split_features)
                response{j} = cellfun(@(f) -logprob(h, f), split_features{j});
            end

%             disp('Plotting ROC');
            positive = cell2mat(response(ismember(classes, classes(i))));
            negative = cell2mat(response(~ismember(classes, classes(i))));
            ROC = ComputeROC(positive(:), negative(:));
            plot(ROC(:, 2), ROC(:, 1));
            drawnow;
            
            AUC = polyarea(ROC(:, 1), ROC(:, 2)) + 0.5;
            if AUC > AUC_opt
                if iter > 1
                    disp(['AUC = ', num2str(AUC), ' (Improvement)']);
                else
                    % Three cases to print one thing. Not very pretty...
                    disp(['AUC = ', num2str(AUC)]);
                end
                HMMs{i} = h;
                R{i}    = response;
                AUC_opt = AUC;
            else
                disp(['AUC = ', num2str(AUC)]);
            end
            if AUC_opt > 0.99
                disp('AUC close to optimal, skipping additional iterations');
                break;
            end
        end
    end
    
end