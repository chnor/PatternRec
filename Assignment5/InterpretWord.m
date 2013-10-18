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
%         InterpretChar(Classifier, data{i})
        responses(:, i) = logprob([Classifier.HMMs{1, :}], features{i});
        responses(:, i) = log(Classifier.priors)' + responses(:, i);
%         responses(:, i) = - cell2mat(Classifier.thetas)' + responses(:, i);
    end
    
    % Hack
%     responses(1, :) = responses(1, :) + 75;
%     responses(3, :) = responses(3, :) + 150;
%     responses(12, :) = responses(12, :) + 50;
%     responses(20, :) = responses(20, :) - 50;
    
    [~, decision] = max(responses, [], 1);
%     [~, decision] = sort(responses, 'descend');
    word = Classifier.classes(decision);
    
end