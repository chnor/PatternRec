% Loads a language model in the form of a mrakov chain representing
% the probability of each possible letter transition. Requires ANC
% corpus format.
% Input:
%   corpusname:         The name of the file to load
%   n_words_to_extract: Number of words to loads. May be Inf.
%   allowed_letters:    Which letters to use. All other letters are
%       ignored
% Output:
%   mc: The resulting markov chain

function mc = LoadLanguageModelMC(corpusname, n_words_to_extract, allowed_letters)
    
    n = length(allowed_letters);
    q = zeros(n, 1);
    A = zeros(n, n+1);
    
    corpus = fopen(corpusname);
    entries = textscan(corpus, '%*s %s %*s %d\n');
    words = entries{1}';
    freqs = entries{2}';
    n_words_to_extract = min(n_words_to_extract, length(freqs));
    for i = 1:n_words_to_extract
        % Only care about lower case for now
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
        
        % Linear time lookup but it doesn't seem to matter much
        j_first = find(ismember(word(1), allowed_letters));
        q(j_first) = q(j_first) + freqs(i);
        for j = 2:length(word)
            j_1 = find(ismember(word(j-1), allowed_letters));
            j_2 = find(ismember(word(j), allowed_letters));
            A(j_1, j_2) = A(j_1, j_2) + freqs(i);
        end
        j_end = find(ismember(word(end), allowed_letters));
        A(j_end, n+1) = A(j_end, n+1) + freqs(i);
    end
    
    A = bsxfun(@rdivide, A, sum(A, 2));
    q = q / sum(q);
    % Add slight probabilities to unencountered states
    A = A + ones(size(A));
    q = q + ones(size(q));
    A = bsxfun(@rdivide, A, sum(A, 2));
    q = q / sum(q);
    
    mc = MarkovChain(q, A);
    
end