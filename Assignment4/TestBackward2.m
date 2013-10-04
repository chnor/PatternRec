% Test that the backward function doesn't explode for
% corner cases like empty observed sequences and
% observed sequences of length 1.
% The markov chain in A.3.2 obviously can't produce
% sequences of length 1 (and no chain can produce zero
% length sequences since it is assumed that the chain
% can't start in the exit state) so the output isn't
% interesting but the algorithm at least should fail
% gracefully in such cases.
% The original backward function explodes in the first case
% and produces [NaN; Inf] in the other.
%--------------------------------------------------------
%Code Authors:
% Pierre Laurent
% Christopher Norman
%--------------------------------------------------------

function betaHat = TestBackward2()

    q = [1 0];
    A = [.9 .1 0; 0 .9 .1];
    mc = MarkovChain(q,A);

    Gauss1 = GaussD('Mean', 0, 'StDev', 1);
    Gauss2 = GaussD('Mean', 3, 'StDev', 2);
    Gauss = [Gauss1; Gauss2];
    
    pX = prob(Gauss, []);
    % Degenerate case: we don't really care about the output
    % The original backward explodes on this input
    backward(mc, pX, []);
    pX = prob(Gauss, [-0.2]);
    % Should give [0; 0] but the original backward gives
    % [NaN; Inf]
    betaHat = backward(mc, pX, [1, 0]);

end

