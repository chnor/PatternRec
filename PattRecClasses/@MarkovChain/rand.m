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
