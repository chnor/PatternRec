function dict = AddWordToDictionary(word, dict)
    
    assert(~isempty(word));
    
    [t, nodes] = TrieLookup(word, dict.trie);
    dict.trie = t;
    if nodes(end) > length(dict.word_count)
        dict.word_count(nodes(end)) = 0;
    end
    dict.word_count(nodes(end)) = dict.word_count(nodes(end)) + 1;
    for node = nodes
        if node > length(dict.subword_count)
            dict.subword_count(node) = 0;
        end
        dict.subword_count(node) = dict.subword_count(node) + 1;
    end
    dict.total_word_count = dict.total_word_count + 1;
    
end