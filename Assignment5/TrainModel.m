function [HMMs, R, thetas, ppv_out, npv_out] = TrainModel(data, labels, n, classes, priors, frac, ITER)
    
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
    thetas = cell(1, length(classes));
    for i = 1:length(split_features)
        disp(['Training model for class: ', classes{i}]);
        
        AUC_opt      = 0;
        pred_acc_opt = 0;
        
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
            
            positive = cell2mat(response(ismember(classes, classes(i))));
            negative = cell2mat(response(~ismember(classes, classes(i))));
            ROC = ComputeROC(positive(:), negative(:));
            
            % ~~~~~~ Take convex hull of ROC ~~~~~~
            % We have to add the point (1, 0) in order to make the
            % curve into a shape
            ROC_hull = convhull([ROC(:, 1:2); 0, 1], 'simplify', true);
            % Remove this extra point from the hull
            ROC_hull = ROC_hull(ROC_hull <= size(ROC, 1));
            % We don't know the order of the points into the hull
            % (not in the documentation), retranslate into the curve
            % parameterized by increasing thetas
            [~, ROC_hull_i] = sort(ROC(ROC_hull, 3));
            ROC_hull = ROC_hull(ROC_hull_i);
            % Just in case the ROC curve has redundant points at the
            % start or end
            ROC_hull = unique(ROC_hull, 'stable');
            
            % ~~~~~~ Find optimal threshold ~~~~~~
            tangent_slope = diff(ROC(ROC_hull, 1)) ./ diff(ROC(ROC_hull, 2));
            theta_index = ROC_hull(find(tangent_slope < (1 - priors(i)) / priors(i), 1, 'first'));
            theta = ROC(theta_index, 3);
            
            % ~~~~~~ Plot sanity check information ~~~~~~
%             plot(ROC(:, 2), ROC(:, 1));
            area_handle = area(ROC(:, 2), ROC(:, 1));
            set(area_handle, 'FaceColor', [0.95, 0.95, 1]);
            hold on;
            plot(ROC(ROC_hull, 2), ROC(ROC_hull, 1), 'b');
            plot([0, 1], [0, 1], 'b');
            plot(ROC(theta_index, 2), ROC(theta_index, 1), 'ro');
            title(['ROC for character: "', classes{i}, '". Trial no: ', num2str(iter)]);
            xlabel('FP Rate (1 - specificity)');
            ylabel('TP Rate (sensitivity)');
            drawnow;
            hold off;
            
            ppv = sum(positive <= theta) / length(positive);
            npv = sum(negative > theta) / length(negative);
%             disp(['Optimal ppv: ', num2str(ppv)]);
%             disp(['Optimal npv: ', num2str(npv)]);
            pred_acc = priors(i)*ppv + (1 - priors(i))*npv;
%             disp(['Predicted accuracy: ', num2str(pred_acc), ' (', num2str(ppv), ', ', num2str(npv), ')']);
            
            AUC = polyarea(ROC(:, 1), ROC(:, 2)) + 0.5;
            
            if pred_acc > pred_acc_opt
                disp(['AUC = ', num2str(AUC), ', Predicted accuracy: ', num2str(pred_acc), ' (', num2str(ppv), ', ', num2str(npv), ') (Current optimum)']);
                HMMs{i}      = h;
                R{i}         = response;
                thetas{i}    = theta;
                AUC_opt      = AUC;
                pred_acc_opt = pred_acc;
                ppv_out{i}   = ppv;
                npv_out{i}   = npv;
            else
                disp(['AUC = ', num2str(AUC), ', Predicted accuracy: ', num2str(pred_acc), ' (', num2str(ppv), ', ', num2str(npv), ')']);
            end
%             if AUC_opt > 0.99
%                 disp('AUC close to optimal, skipping additional iterations');
%                 break;
%             end
            % This threshold must be set higher than the 1 - priors(i)
            if pred_acc_opt > 1 - 1e-4
                disp('Predicted accuracy is close to optimal, skipping additional iterations');
                break;
            end
        end
    end
    
end