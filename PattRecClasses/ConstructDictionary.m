function dictionary = ConstructDictionary
    
    dictionary = struct('total_word_count', 0, ...
                        'word_count', sparse([]), ...
                        'trie', tree('Root') ...
                        );
    
end