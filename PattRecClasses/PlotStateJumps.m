% Plot State Jumps
% Pretty plotting of state sequences.
% Takes sequences as row vectors.

function PlotStateJumps(S)
    
    nStates = max(max(S));
    maxSamples = max(size(S, 2));
    nSets = size(S, 1);
    % Avoid degenerate cases
    nStates = max(nStates, 4);
    maxSamples = max(maxSamples, 4);
    
    % Draw helper lines for each state
    plot(repmat([1 maxSamples]', [1, nStates]), ...
         repmat((1:nStates), [2, 1]), '--k');
    hold all;
    % Draw end lines
    plot([1, 1], [1, nStates], '-k');
    plot(maxSamples*[1, 1], [1, nStates], '-k');
    
    for i = 1:nSets
        sample = S(i, :);
        sample = sample(sample ~= 0);
        plot(1:length(sample), sample, '-o');
    end
    
    axis([0, maxSamples + 1, 0.4, nStates + 0.6]);
    set(gca, 'XTick', 1:maxSamples);
    set(gca, 'YTick', 1:nStates);
    xlabel('t');
    ylabel('s_t');
    
    hold off;
    
end