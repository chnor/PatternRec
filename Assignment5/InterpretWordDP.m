% Segment multicharacter input and classify each written
% character using dynamic programming.
% Unoptimized, so it is incredibly slow. It also underpenalizes
% the prior probabilities so much that's it's not very useful.
% Input:
%   Classifier
%   dict: A dictionary object
%   data
% Output:
%   word: The classification result

function word = InterpretWordDP(Classifier, dict, data)
    
%     DisplayCharacter(data);
%     DrawRects(ExtractStrokeBounds(data), 'r');
%     DrawRects(CollapseRects(ExtractStrokeBounds(data)), 'g');
    data = SegmentWord(data);
    
    features = cellfun(@PreprocessData, data, 'UniformOutput', false);
    responses = zeros(length(Classifier.HMMs), length(data));
    for i = 1:size(data, 2)
        responses(:, i) = logprob([Classifier.HMMs{1, :}], features{i});
    end
    
    opt_value = repmat(-Inf, length(Classifier.HMMs), length(data));
    opt_node  = zeros(length(Classifier.HMMs), length(data));
    opt_prev_j  = zeros(length(Classifier.HMMs), length(data));
    
    n = length(Classifier.HMMs);
    m = length(data);
    
    null_prob = log(0);
    word_transition_influence = 1;
    word_end_influence = 1;
    
    for i = 1:n
        char = Classifier.classes{i};
        
        prev_node = 1;
        children = dict.trie.getchildren(prev_node);
        child_chars = arrayfun(@(x) dict.trie.get(x), children, 'UniformOutput', false);
        next_node = children(ismember(child_chars, char));
        if next_node
            opt_node(i, 1) = next_node;
            opt_value(i, 1) = 0;
            opt_value(i, 1) = opt_value(i, 1) + word_transition_influence * dict.transition_p(opt_node(i, 1));
            opt_value(i, 1) = opt_value(i, 1) + responses(i, 1);
        else
            opt_node(i, 1) = 0;
%             opt_value(i, 1) = -Inf;
            opt_value(i, 1) = null_prob;
            opt_value(i, 1) = opt_value(i, 1) + responses(i, 1);
        end
    end
    
    for k = 2:m
        for i = 1:n
            char = Classifier.classes{i};
            
            cur_opt_node = 0;
            cur_opt_prev_j = 0;
            cur_opt_value = -Inf;
            
            for j = 1:n
                prev_node = opt_node(j, k - 1);
                if prev_node
                    children = dict.trie.getchildren(prev_node);
                    child_chars = arrayfun(@(x) dict.trie.get(x), children, 'UniformOutput', false);
                    next_node = children(ismember(child_chars, char));
                    if next_node
                        opt_node(i, k) = next_node;
                        value = opt_value(j, k - 1);
                        value = value + word_transition_influence * dict.transition_p(opt_node(i, k));
                        value = value + responses(i, k);
                        if value > cur_opt_value
                            cur_opt_value = value;
                            cur_opt_node  = next_node;
                            cur_opt_prev_j  = j;
                        end
                    end
                end
                if null_prob + responses(i, k) > cur_opt_value
                    cur_opt_value = null_prob;
                    cur_opt_value = cur_opt_value + responses(i, k);
                    [~, max_j] = max(opt_value(:, k - 1));
                    cur_opt_prev_j = max_j;
                end
                
            end
            
            opt_prev_j(i, k)  = cur_opt_prev_j;
            opt_node(i, k)  = cur_opt_node;
            opt_value(i, k) = cur_opt_value;
            
        end
    end
    
    for i = 1:n
        node = opt_node(i, end);
        if node
            opt_value(i, end) = opt_value(i, end) + word_end_influence * dict.end_p(node);
        end
    end
%     [opt_value, opt_prev_j]
    
    [~, max_j] = max(opt_value(:, end));
    word_j = zeros(size(data));
    for j = length(word_j):-1:1
        word_j(j) = max_j;
        max_j = opt_prev_j(max_j, j);
    end
    word = Classifier.classes(word_j);
%     nodes = dict.trie.findpath(1, opt_node(max_i, end));
%     word = arrayfun(@(x) dict.trie.get(x), nodes(2:end), 'UniformOutput', false);
    
end