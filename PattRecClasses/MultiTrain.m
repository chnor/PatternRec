% Train HMM
% Input:
%   features:   training data
%   test:       test data (features)
%   n:          number of states in model
%   ITER:       number of iterations

function h = MultiTrain(features, test, n, ITER, m)
    
    % Input dimensionality
    % Assume constant for all samples
    d = size(features{1}, 1);
    
    for k = 1:m
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
%         raw = cell2mat(features);
%         idx = kmeans(raw', n);
%         for i = 1:n;
%             X = raw(:, idx' == i);
%             G = [G, GaussD('Mean', mean(X, 2)', 'Covariance', X*X')];
%         end

        % Generate randomly
        for i = 1:n;
            C = rand(d);
            G = [G, GaussD('Mean', rand(d, 1), 'Covariance', C*C')];
        end

        mc = MarkovChain(q, A);
        h{k} = HMM(mc, G);
    end
    
    % Main loop
    state = cellfun(@adaptStart, h);
    for iter = 1:ITER
        h_new = h;
        % Train
        count = zeros(size(h));
        for i = 1:length(features);
            try
                [~, max_i] = max(cellfun(@(h_i) logprob(h_i, features{i}), h));
                state(max_i) = adaptAccum(h_new{max_i}, state(max_i), features{max_i});
                h_new{max_i} = adaptSet(h_new{max_i}, state(max_i));
                count(max_i) = count(max_i) + 1;
            catch E
            end
        end
        disp(['Distribution: ', mat2str(count)]);
%         state = state(count ~= 0);
%         h_new = h_new(count ~= 0);
        h = h_new;
    end
    
end