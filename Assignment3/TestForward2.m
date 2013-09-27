% Test that the forward function doesn't explode for
% corner cases like empty observed sequences and
% observed sequences of length 1.
% The markov chain in A.3.1 obviously can't produce
% sequences of length 1 (and no chain can produce zero
% length sequences since it is assumed that the chain
% can't start in the exit state) so the output isn't
% interesting but the algorithm at least should fail
% gracefully in such cases.
%--------------------------------------------------------
%Code Authors:
% Pierre Laurent
% Christopher Norman
%--------------------------------------------------------

function [alphaHat, c] = TestForward2()

    q = [1 0];
    A = [.9 .1 0;0 .9 .1];
    mc = MarkovChain(q,A);

    mu_1 = 0;
    mu_2 = 3;
    Var_1 = 1;
    Var_2 = 2^2;

    Gauss1 = GaussD('Mean', mu_1, 'Variance', Var_1);
    Gauss2 = GaussD('Mean', mu_2, 'Variance', Var_2);
    Gauss = [Gauss1; Gauss2];

    pX = prob(Gauss, []);
    % Degenerate case: we don't really care about the output
    forward(mc, pX);
    pX = prob(Gauss, [-0.2]);
    [alphaHat, c] = forward(mc, pX);

end

