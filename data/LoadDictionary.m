function dictionary = LoadDictionary(corpusname, n_words_to_extract, allowed_letters)
    
    dictionary = ConstructDictionary;
    
    corpus = fopen(corpusname);
    entries = textscan(corpus, '%*s %s %*s %d\n');
    words = entries{1}';
    freqs = entries{2}';
    n_words_to_extract = min(n_words_to_extract, length(freqs));
    for i = 1:n_words_to_extract
        word = lower(words{i});
        allowed = true;
        for letter = word
            if ~ismember(allowed_letters, letter)
                allowed = false;
            end
        end
        if ~allowed
            disp(['Skipping: "', word, '"']);
            continue;
        end
        disp(['Extracting: "', word, '" with rank: ', num2str(i), ' frequency: ', num2str(freqs(i))]);
        dictionary = AddWordToDictionary(word, dictionary, freqs(i));
    end
    
    % Calculate log probabilities for each node transition in tree
    % and the log probabilities for ending in each node
    
    % Hackish: TODO do something better
    dictionary.end_p = -Inf*ones(size(dictionary.word_count));
    dictionary.transition_p = -Inf*ones(size(dictionary.subword_count));
    
    for node = dictionary.trie.nodeorderiterator
        subnodes = getchildren(dictionary.trie, node);
        total_count = sum(dictionary.subword_count(subnodes));
        total_count = total_count + dictionary.word_count(node);
        if total_count == 0
            continue;
        end
        dictionary.transition_p(subnodes) = log(dictionary.subword_count(subnodes)) - log(total_count);
        if dictionary.word_count(node) > 0
            dictionary.end_p(node) = log(dictionary.word_count(node)) - log(total_count);
        end
    end
    
end