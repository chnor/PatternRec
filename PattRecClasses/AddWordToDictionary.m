function dict = AddWordToDictionary(word, dict, n)
    
    assert(~isempty(word));
    
    if nargin < 3
        n = 1;
    end
    
    [t, nodes] = TrieLookup(word, dict.trie);
    dict.trie = t;
    if nodes(end) > length(dict.word_count)
        dict.word_count(nodes(end)) = 0;
    end
    dict.word_count(nodes(end)) = dict.word_count(nodes(end)) + n;
    for node = nodes
        if node > length(dict.subword_count)
            dict.subword_count(node) = 0;
        end
        dict.subword_count(node) = dict.subword_count(node) + n;
    end
    dict.total_word_count = dict.total_word_count + n;
    
end