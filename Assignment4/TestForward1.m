% Test that the forward function yields the correct value for
% for the example in A.3.1
%--------------------------------------------------------
%Code Authors:
% Pierre Laurent
% Christopher Norman
%--------------------------------------------------------

function [alphaHat, c] = TestForward1()

    X = [-.2 2.6 1.3];

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

    pX = prob(Gauss, X);

    [alphaHat, c] = forward(mc, pX);

end

