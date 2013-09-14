%% Plot State Jumps
% Pretty plotting of state sequences.
% Takes sequences as the rows of S.

function PlotStateJumps(S)
    
    if numel(S) == 0
        error('PlotStateJumps received singular input');
    end
    if size(S, 1) ~= 1 && size(S, 2) == 1
        % We've a column vector...
        % Could be a number of sequences each of length 1
        % but it's probably an error.
        warning('PlotStateJumps received column vector input');
    end
    
    nStates = max(max(S));
    maxSamples = max(size(S, 2));
    nSets = size(S, 1);
    % Avoid degenerate cases
    nStates = max(nStates, 4);
    maxSamples = max(maxSamples, 4);
    
    % Draw leader for each state
    plot(repmat([1 maxSamples]', [1, nStates]), ...
         repmat((1:nStates), [2, 1]), '--k');
    hold all;
    % Draw table borders
    plot([1, 1], [1, nStates], '-k');
    plot(maxSamples*[1, 1], [1, nStates], '-k');
    
    for i = 1:nSets
        sample = S(i, :);
        sample = sample(sample ~= 0);
        plot(1:length(sample), sample, '-o');
    end
    
    axis([0, maxSamples + 1, 0.4, nStates + 0.6]);
    x_step = ceil(maxSamples / 10);
    y_step = ceil(nStates / 10);
    set(gca, 'XTick', 1:x_step:maxSamples);
    set(gca, 'YTick', 1:y_step:nStates);
    xlabel('t');
    ylabel('s_t');
    
    hold off;
    
end