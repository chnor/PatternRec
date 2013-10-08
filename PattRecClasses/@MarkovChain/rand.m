function S=rand(mc,T)
%S=rand(mc,T) returns a random state sequence from given MarkovChain object.
%
%Input:
%mc=    a single MarkovChain object
%T= scalar defining maximum length of desired state sequence.
%   An infinite-duration MarkovChain always generates sequence of length=T
%   A finite-duration MarkovChain may return shorter sequence,
%   if END state was reached before T samples.
%
%Result:
%S= integer row vector with random state sequence,
%   NOT INCLUDING the END state,
%   even if encountered within T samples
%If mc has INFINITE duration,
%   length(S) == T
%If mc has FINITE duration,
%   length(S) <= T
%
%---------------------------------------------
%Code Authors:
% Christopher Norman
% Pierre Laurent
%---------------------------------------------

% Pregenerated jumps will be faster if T >> nStates
% and if the chain doesn't absorb. For finite chains
% with very low expected length the naive version will
% likewise be faster.
% TODO calculate better cutoffs experimentally.

expected_length = T;
if finiteDuration(mc)
    Q = mc.TransitionProb(1:mc.nStates, 1:mc.nStates);
    tau = (eye(mc.nStates) - Q) \ ones(mc.nStates, 1);
    %8/10/2013: tau = (eye(2) - Q) \ ones(mc.nStates, 1);
    expected_length = mc.InitialProb'*tau;
end

if expected_length / mc.nStates < 6.7
    algorithm = 'naive_algorithm';
else
    if finiteDuration(mc)
        algorithm = 'pregenerated_jumps_finite';
    else
        algorithm = 'pregenerated_jumps';
    end
end

switch algorithm
case 'pregenerated_jumps'
    c = zeros(mc.nStates, T);
    for i = 1:mc.nStates
        c(i, :) = rand(DiscreteD(mc.TransitionProb(i, :)), T);
    end
    c_i = ones(mc.nStates, 1);
    S = zeros(1, T);
    d0 = DiscreteD(mc.InitialProb);
    S(1) = rand(d0, 1);
    for i = 2:T
        S(i) = c(S(i-1), c_i(S(i-1)));
        c_i(S(i-1)) = c_i(S(i-1)) + 1;
    end
case 'pregenerated_jumps_finite'
    c = zeros(mc.nStates + 1, T);
    for i = 1:mc.nStates
        c(i, :) = rand(DiscreteD(mc.TransitionProb(i, :)), T);
    end
    c(mc.nStates + 1, :) = mc.nStates + 1;
    c_i = ones(mc.nStates + 1, 1);
    S = zeros(1, T);
    d0 = DiscreteD(mc.InitialProb);
    S(1) = rand(d0, 1);
%     S(1) = 2;
    for i = 2:T
        S(i) = c(S(i-1), c_i(S(i-1)));
        c_i(S(i-1)) = c_i(S(i-1)) + 1;
    end
    S = S(1:find(S == mc.nStates + 1, 1, 'first')-1);
case 'naive_algorithm'
    S = zeros(1, T);
    d0 = DiscreteD(mc.InitialProb);
    S(1) = rand(d0, 1);

    for i = 2:T
        S(i) = rand(DiscreteD(mc.TransitionProb(S(i-1), :)), 1);
        % Check if we've absorbed
        if S(i) == mc.nStates+1
            S = S(1:i-1);
            return;
        end
    end
end
