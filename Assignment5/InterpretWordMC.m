% Segment multicharacter input and classify each written
% character using viterbi.
% Input:
%   Classifier
%   MC: Language model arkov chain representing each possible
%       letter transition
%   data
% Output:
%   word: The classification result

function word = InterpretWordMC(Classifier, MC, data)
    
%     DisplayCharacter(data);
%     DrawRects(ExtractStrokeBounds(data), 'r');
%     DrawRects(CollapseRects(ExtractStrokeBounds(data)), 'g');
    data = SegmentWord(data);
    
    features = cellfun(@PreprocessData, data, 'UniformOutput', false);
    responses = zeros(length(Classifier.HMMs), length(data));
    for i = 1:size(data, 2)
        responses(:, i) = logprob([Classifier.HMMs{1, :}], features{i});
    end
    
    decision = viterbi(MC, responses);
    word = Classifier.classes(decision);
    
end