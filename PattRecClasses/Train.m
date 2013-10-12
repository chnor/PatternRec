% Train HMM
% Input:
%   features:   training data
%   test:       test data (features)
%   n:          number of states in model
%   ITER:       number of iterations

function h = Train(features, test, n, ITER)
    
    % Input dimensionality
    % Assume constant for all samples
    d = size(features{1}, 1);
    
    % Generate initial transition matrix
    A = rand(n, n+1);
    % Make left-right
%     for i = 1:n
%         for j = 1:i-1
%             A(i, j) = 0;
%         end
%     end
    % Normalize
    A = bsxfun(@rdivide, A, sum(A, 2));
    
    % Generate initial prior
    q = rand(n);
    q = q / sum(q);
    
    % Generate initial output distributions
    G = [];
    
    % Use k-means clustering
    raw = cell2mat(features);
    idx = kmeans(raw', n);
    for i = 1:n;
        X = raw(:, idx' == i);
        G = [G, GaussD('Mean', mean(X, 2)', 'Covariance', X*X')];
    end
    
    % Generate randomly
%     for i = 1:n;
%         C = rand(d);
%         G = [G, GaussD('Mean', rand(d, 1), 'Covariance', C*C')];
%     end
    
    mc = MarkovChain(q, A);
    h = HMM(mc, G);
    
    % Main loop
    state = adaptStart(h);
%     last_test_log_p = mean(cellfun(@(x) -logprob(h, x), test));
    last_test_log_p = -Inf;
    for iter = 1:ITER
        h_new = h;
        % Train
        try
            for i = 1:length(features);
                [state, ~] = adaptAccum(h_new, state, features{i});
                h_new = adaptSet(h_new, state);
            end
        catch E
            % TODO: figure out something better
            break;
        end
        
        % Calculate training log probabilities
        % TODO: figure out what the heck the logP that
        % adaptAccum returns is. It certainly isn't the
        % same as log_p
        log_p = mean(cellfun(@(x) logprob(h_new, x), features));
        test_log_p = mean(cellfun(@(x) logprob(h_new, x), test));
        
        % Check for early stopping
        if last_test_log_p > test_log_p
            break;
        end
        % Check for degeneration
        if isnan(log_p)
            break;
        end
        
%         disp(['Training: ', num2str(log_p), ' vs Test: ', num2str(test_log_p)]);
        
        last_test_log_p = test_log_p;
        h = h_new;
    end
%     disp(['Test log probability: ', num2str(last_test_log_p)]);
    
end