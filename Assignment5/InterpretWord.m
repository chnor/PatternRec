% Segment multicharacter input and classify each written
% character. For now this simply tries to classify each
% character independently.

function word = InterpretWord(Classifier, data)
    
%     DisplayCharacter(data);
%     DrawRects(ExtractStrokeBounds(data), 'r');
%     DrawRects(CollapseRects(ExtractStrokeBounds(data)), 'g');
    data = SegmentWord(data);
    
    features = cellfun(@PreprocessData, data, 'UniformOutput', false);
    responses = zeros(length(Classifier.HMMs), length(data));
    for i = 1:size(data, 2)
        responses(:, i) = logprob([Classifier.HMMs{1, :}], features{i});
    end
    [~, decision] = max(responses, [], 1);
    word = Classifier.classes(decision);
    
end