function [alphaHat, c] = testForward 

    q = [1 0];
    A = [.9 .1 0;0 .9 .1];
    mc = MarkovChain(q,A);
    X= [-.2, 1.3, 10^500];
    X2= [-.2, 10^500, 2.6];

    mu_1 = 0;
    mu_2 = 3;
    Var_1 = 1;
    Var_2 = 2^2;

    Gauss1 = GaussD('Mean', mu_1, 'Variance', Var_1);
    Gauss2 = GaussD('Mean', mu_2, 'Variance', Var_2);
    Gauss = [Gauss1; Gauss2];

    pX = prob(Gauss, X2);
    [alphaHat, c] = forwardPierre(mc, pX);

end

