function dictionary = AddWordToDictionary(word, dictionary)
    
    [t, node] = TrieLookup(word, dictionary.trie);
    dictionary.trie = t;
    if node > length(dictionary.word_count)
        dictionary.word_count(node) = 0;
    end
    dictionary.word_count(node) = dictionary.word_count(node) + 1;
    dictionary.total_word_count = dictionary.total_word_count + 1;
    
end